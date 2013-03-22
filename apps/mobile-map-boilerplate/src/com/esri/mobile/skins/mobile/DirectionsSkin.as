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

package com.esri.mobile.skins.mobile
{

import com.esri.ags.components.Directions;
import com.esri.ags.components.supportClasses.DirectionsStop;
import com.esri.mobile.components.DirectionsDataGroupRenderer;
import com.esri.mobile.components.PopUpCallout;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.graphics.SolidColor;
import mx.managers.PopUpManager;

import spark.components.BusyIndicator;
import spark.components.Button;
import spark.components.Group;
import spark.components.HGroup;
import spark.components.Label;
import spark.components.Scroller;
import spark.components.VGroup;
import spark.components.supportClasses.ButtonBase;
import spark.layouts.VerticalAlign;
import spark.layouts.VerticalLayout;
import spark.primitives.Rect;


public class DirectionsSkin extends MobileSkin
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
    public function DirectionsSkin()
    {
        super();

    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var scroller:Scroller;

    private var scrollerViewport:VGroup;

    private var popUpCallout:PopUpCallout;

    private var routeInfoGroup:VGroup;

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    /**
     * @copy com.esri.ags.components.Directions#stopsGroup
     */
    public var stopsGroup:VGroup;

    /**
     * @copy com.esri.ags.components.Directions#directionsGroup
     */
    public var directionsGroup:VGroup;

    /**
     * @copy com.esri.ags.components.Directions#directionsStop
     */
    public var directionsStop:IFactory;

    /**
     * @copy com.esri.ags.components.Directions#directionsDataGroup
     */
    public var directionsDataGroup:IFactory;

    /**
     * @copy com.esri.ags.components.Directions#addStopButton
     */
    // Not Used: public var addStopButton:ButtonBase;

    /**
     * @copy com.esri.ags.components.Directions#clearButton
     */
    // public var clearButton:ButtonBase;

    /**
     * @copy com.esri.ags.components.Directions#getDirectionsButton
     */
    // Not Used: public var getDirectionsButton:ButtonBase;

    /**
     * @copy com.esri.ags.components.Directions#getReverseDirectionsButton
     */
    // Not Used: public var getReverseDirectionsButton:ButtonBase;

    /**
     * @copy com.esri.ags.components.Directions#printDirectionsButton
     */
    // public var printDirectionsButton:ButtonBase;

    /**
     * @copy com.esri.ags.components.Directions#routeName
     */
    public var routeName:Label;

    /**
     * @copy com.esri.ags.components.Directions#routeSummary
     */
    public var routeSummary:Label;

    private var totalTimeLabelDisplay:Label;

    private var totalDistanceLabelDisplay:Label;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:Directions;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------


    override protected function createChildren():void
    {
        super.createChildren();

        scrollerViewport = new VGroup();
        scrollerViewport.gap = layoutGap;
        scrollerViewport.percentWidth = 100;
        scrollerViewport.paddingBottom = layoutGap;

        stopsGroup = new VGroup();
        stopsGroup.gap = 0;
        stopsGroup.id = "stopsGroup";
        stopsGroup.percentWidth = 100;
        scrollerViewport.addElement(stopsGroup);

        /*
        Not used in that skin.

        addStopButton = new Button();
        addStopButton.id = "addStopButton";
        addStopButton.label = resourceManager.getString('ESRIMessages', 'directionsAddDestination');
        addStopButton.percentWidth = 100;
        scrollerViewport.addElement(addStopButton);
        */
        
        routeInfoGroup = new VGroup();
        routeInfoGroup.percentWidth = 100;
        routeInfoGroup.visible = routeInfoGroup.includeInLayout = false;

        var routeNameGroup:Group = new Group();
        routeNameGroup.percentWidth = 100;
        routeInfoGroup.addElement(routeNameGroup);
        
        // Background
        var rect:Rect = new Rect();
        rect.left = rect.right = rect.top = rect.bottom = 0;
        rect.fill = new SolidColor(0xFFBB33);
        routeNameGroup.addElement(rect);
        
        // border top
        rect = new Rect();
        rect.height = 1;
        rect.left = rect.right = 0;
        rect.fill = new SolidColor(0xFF8800);
        routeNameGroup.addElement(rect);

        // border bottom
        rect = new Rect();
        rect.height = 1;
        rect.left = rect.right = rect.bottom = 0;
        rect.fill = new SolidColor(0xFF8800);
        routeNameGroup.addElement(rect);

        // Route name
        routeName = new Label();
        routeName.id = "routeName";
        routeName.left = routeName.right = layoutGap;
        routeName.height = 56;
        routeName.setStyle("textAlign", "justify");
        routeName.setStyle("verticalAlign", "middle");
        routeNameGroup.addElement(routeName);
        
        // Group: Total time | Total distance
        var subgroup:HGroup = new HGroup();
        subgroup.horizontalAlign = "center";
        subgroup.gap = layoutGap;
        subgroup.paddingLeft =
            subgroup.paddingRight = layoutGap;
        subgroup.percentWidth = 100;
        routeInfoGroup.addElement(subgroup);
        
        // Horizontal Separator
        rect = new Rect();
        rect.height = 1;
        rect.percentWidth = 100;
        rect.left = rect.right = layoutGap;
        rect.fill = new SolidColor(0xFF8800);
        scrollerViewport.addElement(rect);
        routeInfoGroup.addElement(rect);
        
        scrollerViewport.addElement(routeInfoGroup);

        // Total Distance
        totalDistanceLabelDisplay = new Label();
        totalDistanceLabelDisplay.percentWidth = 50;
        totalDistanceLabelDisplay.height = 56;
        totalDistanceLabelDisplay.id = "totalDistanceLabelDisplay";
        subgroup.addElement(totalDistanceLabelDisplay);

        // Vertical separator
        rect = new Rect();
        rect.width = 1;
        rect.percentHeight = 100;
        rect.fill = new SolidColor(0xFF8800);
        subgroup.addElement(rect);

        // Total time
        totalTimeLabelDisplay = new Label();
        totalTimeLabelDisplay.percentWidth = 50;
        totalTimeLabelDisplay.height = 56;
        totalTimeLabelDisplay.id = "totalTimeLabelDisplay";
        subgroup.addElement(totalTimeLabelDisplay);

        /*
        Not used in that skin.

        routeSummary = new Label();
        routeSummary.id = "routeSummary";
        routeSummary.percentWidth = 100;
        scrollerViewport.addElement(routeSummary);
        */

        directionsGroup = new VGroup();
        directionsGroup.visible = directionsGroup.includeInLayout = false;
        directionsGroup.id = "directionsGroup";
        directionsGroup.gap = layoutGap;
        directionsGroup.percentWidth = 100;
        scrollerViewport.addElement(directionsGroup);

        directionsStop = new ClassFactory(com.esri.ags.components.supportClasses.DirectionsStop);
        directionsDataGroup = new DataGroupFactory();

        scroller = new Scroller();
        scroller.setStyle("horizontalScrollPolicy", "off");
        scroller.left = scroller.right = scroller.top = scroller.bottom = 0;
        scroller.minViewportInset = 0;
        scroller.viewport = scrollerViewport;

        addChild(scroller);

        var hGroup:HGroup = new HGroup();
        hGroup.verticalAlign = VerticalAlign.MIDDLE;
        hGroup.gap = layoutGap;
        hGroup.paddingLeft = hGroup.paddingRight = hGroup.paddingTop = hGroup.paddingBottom = layoutGap;

        var busyCursor:BusyIndicator = new BusyIndicator();
        hGroup.addElement(busyCursor);

        var computingDirectionsLabel:Label = new Label();
        computingDirectionsLabel.text = "Computing directions...";
        hGroup.addElement(computingDirectionsLabel);

        popUpCallout = new PopUpCallout();
        popUpCallout.id = "popUpCallout";
        popUpCallout.addElement(hGroup);
    }

    override protected function commitCurrentState():void
    {
        /*
        [SkinState("normal")]
        [SkinState("disabled")]
        [SkinState("computingDirections")]
        [SkinState("showDirections")]
        [SkinState("directionsNotFound")]
        */

        if (currentState == "computingDirections")
        {
            popUpCallout.open(this, true);
        }
        else if (popUpCallout.isOpen)
        {
            popUpCallout.close();
        }

        if (currentState == "showDirections")
        {
            directionsGroup.visible = directionsGroup.includeInLayout = true;
            routeInfoGroup.visible = routeInfoGroup.includeInLayout = true;
            totalTimeLabelDisplay.text = hostComponent.totalTime;
            totalDistanceLabelDisplay.text = hostComponent.totalDistance;
        }
        else
        {
            directionsGroup.visible = directionsGroup.includeInLayout = false;
            routeInfoGroup.visible = routeInfoGroup.includeInLayout = false;
        }
    }

    override protected function measure():void
    {
        measuredWidth = scroller.getPreferredBoundsWidth();
        measuredHeight = scroller.getPreferredBoundsHeight();
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        scroller.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
    }

}
}

import com.esri.mobile.components.DirectionsDataGroupRenderer;

import mx.core.ClassFactory;
import mx.core.IFactory;

import spark.components.DataGroup;
import spark.layouts.VerticalLayout;

class DataGroupFactory implements IFactory
{
    public function newInstance():*
    {
        var verticalLayout:VerticalLayout = new VerticalLayout();
        verticalLayout.gap = 0;

        var itemRendererFactory:ClassFactory = new ClassFactory(com.esri.mobile.components.DirectionsDataGroupRenderer);

        var instance:DataGroup = new DataGroup();
        instance.percentWidth = 100;
        instance.layout = verticalLayout;
        instance.itemRenderer = itemRendererFactory;

        return instance;
    }
}
