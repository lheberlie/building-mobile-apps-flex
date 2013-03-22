///////////////////////////////////////////////////////////////////////////
// Copyright (c) 2013 Esri. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////

package com.esri.mobile.managers
{

import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.clusterers.supportClasses.Cluster;
import com.esri.ags.clusterers.supportClasses.ClusterGraphic;
import com.esri.ags.events.MapMouseEvent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.GraphicsLayer;
import com.esri.ags.layers.supportClasses.LayerDetails;
import com.esri.ags.portal.PopUpRenderer;
import com.esri.ags.symbols.PictureMarkerSymbol;
import com.esri.ags.symbols.Symbol;
import com.esri.mobile.components.InfoWindowContent;
import com.esri.mobile.components.InfoWindowDataRenderer;
import com.esri.mobile.managers.supportClasses.InfoWindowData;

import flash.display.DisplayObject;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.geom.Point;

import mx.collections.ArrayList;
import mx.collections.IList;
import mx.core.ClassFactory;

import spark.events.IndexChangeEvent;

//--------------------------------------
//  Events
//--------------------------------------

[Event(name="change", type="spark.events.IndexChangeEvent")]

[Event(name="changing", type="spark.events.IndexChangeEvent")]

public class InfoWindowController extends EventDispatcher
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function InfoWindowController()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  map
    //----------------------------------

    private var m_map:Map;

    public function get map():Map
    {
        return m_map;
    }

    public function set map(value:Map):void
    {
        if (m_map !== value)
        {
            if (m_map)
            {
                m_map.removeEventListener(MapMouseEvent.MAP_CLICK, highPriorityMapClickHandler);
                m_map.removeEventListener(MapMouseEvent.MAP_CLICK, mapClickHandler);
            }
            m_map = value;
            if (m_map && m_enable)
            {
                // Make sure that we hide the infowindow before the map make another one appear.
                m_map.addEventListener(MapMouseEvent.MAP_CLICK, highPriorityMapClickHandler, false, 10000);
                m_map.addEventListener(MapMouseEvent.MAP_CLICK, mapClickHandler);
                m_map.infoWindowRenderersEnabled = false;
            }
        }
    }
    
    //----------------------------------
    //  enable
    //----------------------------------

    private var m_enable:Boolean = true;

    public function get enable():Boolean
    {
        return m_enable;
    }

    public function set enable(value:Boolean):void
    {
        if (m_enable !== value)
        {
            m_enable = value;
            if (m_map && m_enable)
            {
                m_map.addEventListener(MapMouseEvent.MAP_CLICK, mapClickHandler);
            }
            else if (m_map && !m_enable)
            {
                m_map.removeEventListener(MapMouseEvent.MAP_CLICK, mapClickHandler);
            }
        }
    }
    
    //----------------------------------
    //  selectedInfoWindowData
    //----------------------------------
    
    private var m_selectedInfoWindowData:InfoWindowData
    
    [Bindable("change")]
    
    public function get selectedInfoWindowData():InfoWindowData
    {
        return m_selectedInfoWindowData;
    }
    
    //----------------------------------
    //  infoWindowDataProvider
    //----------------------------------
    
    private var m_infoWindowDataProvider:IList;
    
    [Bindable("change")]
    
    public function get infoWindowDataProvider():IList
    {
        return m_infoWindowDataProvider;
    }
    
    public function set infoWindowDataProvider(value:IList):void
    {
        m_infoWindowDataProvider = value;
        infoWindowContent.dataProvider = value;
        /*
        TODO: List View handler
        
        var menuItem:MenuItem = new MenuItem();
        menuItem.label = "showList";
        menuItem.icon = ".list";
        infoWindowContent.menuItems = [menuItem];
        */
        m_map.infoWindowContent = infoWindowContent;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    public function createInfoWindowContent(graphics:Array):void
    {
        if (!graphics || !graphics.length)
        {
            return;
        }

        if (!infoWindowContent)
        {
            infoWindowContent = new InfoWindowContent();
            infoWindowContent.addEventListener(IndexChangeEvent.CHANGE, changeHandler);
            infoWindowContent.addEventListener(IndexChangeEvent.CHANGING, changingHandler);
            infoWindowContent.itemRenderer = new ClassFactory(InfoWindowDataRenderer);
        }
        var dataProvider:ArrayList = infoWindowDataProvider as ArrayList;
        if (!m_infoWindowDataProvider)
        {
            dataProvider = new ArrayList();
        }
        dataProvider.removeAll();
        for (var i:int = 0, len:uint = graphics.length; i < len; i++)
        {
            dataProvider.addItem(createInfoWindowData(graphics[i]));
        }
        infoWindowDataProvider = dataProvider;
    }

    private var popupRenderer:PopUpRenderer = new PopUpRenderer();

    private var infoWindowContent:InfoWindowContent;

    private function createInfoWindowData(graphic:Graphic):InfoWindowData
    {
        var result:InfoWindowData = new InfoWindowData();
        result.graphic = graphic;

        popupRenderer.graphic = graphic;
        popupRenderer.validateProperties();

        if (graphic.graphicsLayer is FeatureLayer)
        {
            var featureLayer:FeatureLayer = graphic.graphicsLayer as FeatureLayer;
            if (featureLayer
                && featureLayer.layerDetails)
            {
                var layerDetails:LayerDetails = featureLayer.layerDetails;
                result.labelField = layerDetails.typeIdField;
                result.subLabelField = layerDetails.displayField;
            }

            var symbol:Symbol = getSymbol(graphic, featureLayer);
            if (symbol is PictureMarkerSymbol)
            {
                result.icon = (symbol as PictureMarkerSymbol).source;
            }
        }

        return result;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function getGraphics(displayObjects:Array):Array
    {
        var graphics:Array = [];
        var clusterGraphics:Array = [];

        if (displayObjects)
        {
            for (var i:int = 0, n:int = displayObjects.length; i < n; i++)
            {
                var displayObject:DisplayObject = displayObjects[i];
                var graphic:Graphic = getTargetAsGraphic(displayObject);
                if (graphic
                    && graphic.graphicsLayer
                    && graphic.graphicsLayer.map === m_map
                    && (graphic.mouseChildren || graphic.mouseEnabled)
                    && graphics.indexOf(graphic) === -1
                    && clusterGraphics.indexOf(graphic) === -1)
                {
                    if (graphic is ClusterGraphic)
                    {
                        var clusterGraphic:ClusterGraphic = graphic as ClusterGraphic;
                        var cluster:Cluster = clusterGraphic.cluster;
                        if (cluster)
                        {
                            graphics = graphics.concat(cluster.graphics);
                            clusterGraphics.push(clusterGraphic);
                        }
                    }
                    else
                    {
                        graphics.push(graphic);
                    }
                }
            }
        }

        return graphics;
    }

    private function getSymbol(graphic:Graphic, layer:GraphicsLayer):Symbol
    {
        var symbol:Symbol;
        if (layer)
        {
            if (layer.renderer)
            {
                symbol = layer.renderer.getSymbol(graphic);
            }
            if (layer.symbol)
            {
                symbol = layer.symbol;
            }
        }
        return symbol;
    }


    private function getTargetAsGraphic(target:DisplayObject):Graphic
    {
        var graphic:Graphic = target as Graphic;
        if (graphic)
        {
            return graphic;
        }
        if (target.parent)
        {
            return getTargetAsGraphic(target.parent);
        }
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function highPriorityMapClickHandler(event:MapMouseEvent):void
    {
        m_map.infoWindow.hide();
    }

    private function mapClickHandler(event:MapMouseEvent):void
    {
        var stagePoint:Point = new Point(event.stageX, event.stageY);

        // find graphics
        var objectsUnderPoint:Array;
        if (m_map.stage.areInaccessibleObjectsUnderPoint(stagePoint)
            && event.originalTarget is DisplayObject)
        {
            objectsUnderPoint = [ event.originalTarget ];
        }
        else
        {
            objectsUnderPoint = m_map.stage.getObjectsUnderPoint(stagePoint);
        }

        var graphics:Array = getGraphics(objectsUnderPoint);
        if (graphics && graphics.length)
        {
            createInfoWindowContent(graphics);
            m_map.infoWindow.show(event.mapPoint, stagePoint);
            m_map.center = event.mapPoint;
        }
    }
    
    private function changeHandler(event:IndexChangeEvent):void
    {
        m_selectedInfoWindowData = infoWindowContent.list.selectedItem as InfoWindowData;
        dispatchEvent(event);
    }
    
    private function changingHandler(event:IndexChangeEvent):void
    {
        dispatchEvent(event);
    }
}
}
