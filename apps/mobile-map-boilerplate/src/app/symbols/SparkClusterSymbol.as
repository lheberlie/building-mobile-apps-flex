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

package app.symbols
{

import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.clusterers.supportClasses.ClusterGraphic;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.Symbol;

import flash.display.BlendMode;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.EventPhase;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.core.UIComponent;

import spark.components.Label;

[DefaultProperty("weightRenderers")]

public class SparkClusterSymbol extends Symbol
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  renderers
    //----------------------------------

    [Inspectable(arrayType="app.symbols.WeightRenderer")]
    public var weightRenderers:Array;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map):void
    {
        const clusterGraphic:ClusterGraphic = sprite as ClusterGraphic;
        const extent:Extent = map.extent.expand(3);
        if (clusterGraphic)
        {
            const mapPoint:MapPoint = clusterGraphic.mapPoint;
            if (extent.containsXY(mapPoint.x, mapPoint.y))
            {
                drawMapPoint(clusterGraphic, mapPoint.x, mapPoint.y, map);
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function drawMapPoint(clusterGraphic:ClusterGraphic, mapPointX:Number, mapPointY:Number, map:Map):void
    {
        // Position the cluster
        var point:Point = toScreenXY(map, mapPointX, mapPointY);
        clusterGraphic.rotation = 0;
        clusterGraphic.move(point.x, point.y);
        clusterGraphic.rotation = -map.mapRotation;
        clusterGraphic.blendMode = BlendMode.LAYER;

        // Find the right renderer
        var weightRenderer:WeightRenderer;
        const weight:Number = clusterGraphic.cluster.weight;
        if (weightRenderers)
        {
            for (var i:int = 0, len:int = weightRenderers.length; i < len; i++)
            {
                weightRenderer = weightRenderers[i];
                if (weightRenderer.weight >= weight)
                {
                    break;
                }
            }
        }

        // Find or create the renderer instance
        const weightToString:String = weightRenderer.weight.toFixed(0);
        var renderer:UIComponent = clusterGraphic.getChildByName(weightToString) as UIComponent;
        if (!renderer)
        {
            clusterGraphic.removeChildren();
            renderer = weightRenderer.renderer.newInstance() as UIComponent;
            renderer.name = weightToString;
            renderer.mouseChildren = false;
            clusterGraphic.addChild(renderer);
        }
        renderer.move(-renderer.width * 0.5, -renderer.height * 0.5);

        // update the label
        var label:Label = renderer.getChildByName("label") as Label;
        if (label)
        {
            label.text = weight.toFixed(0);
        }
    }
   
}
}
