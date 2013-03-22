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

import com.esri.ags.components.supportClasses.InfoWindow;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import mx.core.DPIClassification;
import mx.graphics.GradientEntry;
import mx.graphics.IStroke;
import mx.graphics.LinearGradient;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;

import spark.components.Group;
import spark.primitives.Path;
import spark.primitives.Rect;
import spark.primitives.RectangularDropShadow;

public class InfoWindowSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
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
    public function InfoWindowSkin()
    {

        dropShadowAlpha = 0.7;

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification

                borderSize = 2;
                backgroundCornerRadius = 1;
                dropShadowBlurX = 4;
                dropShadowBlurY = 4;
                dropShadowDistance = 1;
                arrowWidth = 30;
                arrowHeight = 20;

                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification

                borderSize = 1;
                backgroundCornerRadius = 1;
                dropShadowBlurX = 4;
                dropShadowBlurY = 4;
                dropShadowDistance = 1;
                arrowWidth = 30;
                arrowHeight = 20;
                */

                break;
            }
            default:
            {
                // default DPI_160
                borderSize = 1;
                backgroundCornerRadius = 2;
                dropShadowBlurX = 4;
                dropShadowBlurY = 4;
                dropShadowDistance = 1;
                arrowWidth = 30;
                arrowHeight = 20;

                break;
            }
        }
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var borderSize:int = 1;

    protected var backgroundCornerRadius:Number;

    protected var arrowWidth:Number;

    protected var arrowHeight:Number;

    protected var dropShadowBlurX:Number;

    protected var dropShadowBlurY:Number;

    protected var dropShadowDistance:Number;

    protected var dropShadowAlpha:Number;

    private var stringPath:StringPath = new StringPath();

    private var dropShadow:RectangularDropShadow;

    private var oldUnscaleWidth:Number;

    private var oldUnscaleHeight:Number;

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var graphicGroup:Group;

    public var infoWindowPath:Path;

    public var contentGroup:Group;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  hostComponent
    //----------------------------------

    public var hostComponent:InfoWindow;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void
    {
        super.createChildren();

        var stroke:IStroke;

        var fill:LinearGradient = new LinearGradient();
        fill.rotation = 90;
        fill.entries = [
            new GradientEntry(0x484848, 0, 0.8),
            new GradientEntry(0x484848, 0.8, 1)
            ];
        stroke = new SolidColorStroke(0x000000, 1, 1, true);
        infoWindowPath = new Path();
        infoWindowPath.fill = fill;
        infoWindowPath.stroke = stroke;

        var highlight:Rect = new Rect();
        highlight.left = highlight.right = highlight.top = borderSize;
        highlight.height = borderSize;
        highlight.fill = new SolidColor(0xFFFFFF, 0.4);

        dropShadow = new RectangularDropShadow();
        dropShadow.top = dropShadow.left = dropShadow.right = 0;
        dropShadow.bottom = arrowHeight;
        dropShadow.angle = 90;
        dropShadow.distance = dropShadowDistance;
        dropShadow.blurX = dropShadowBlurX;
        dropShadow.blurY = dropShadowBlurY;
        dropShadow.tlRadius = dropShadow.trRadius = dropShadow.blRadius = dropShadow.brRadius = backgroundCornerRadius;
        dropShadow.mouseEnabled = false;
        dropShadow.alpha = dropShadowAlpha;

        graphicGroup = new Group();
        graphicGroup.addElement(dropShadow);
        graphicGroup.addElement(infoWindowPath);
        graphicGroup.addElement(highlight);
        addChild(graphicGroup);

        contentGroup = new Group();
        contentGroup.id = "contentGroup";
        contentGroup.minWidth = contentGroup.minHeight = 0;
        contentGroup.percentWidth = contentGroup.percentHeight = 100;
        contentGroup.mouseChildren = true;
        contentGroup.mouseEnabled = false;

        addChild(contentGroup);
    }

    override protected function measure():void
    {
        super.measure();

        measuredWidth = contentGroup.getPreferredBoundsWidth() + 2 * borderSize + 2 * layoutGap;
        measuredHeight = contentGroup.getPreferredBoundsHeight() + arrowHeight + 2 * borderSize + 2 * layoutGap;
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Only update if the size changed.
        if (unscaledWidth != oldUnscaleWidth || unscaledHeight != oldUnscaleHeight)
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            oldUnscaleWidth = unscaledWidth;
            oldUnscaleHeight = unscaledHeight;
        }
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        var xStart:Number = -unscaledWidth * 0.5 + borderSize + layoutGap;
        var yStart:Number = -unscaledHeight + borderSize + layoutGap;

        // Groups in MobileSkin needs to be manually updated
        contentGroup.layout.updateDisplayList(unscaledWidth - 2 * borderSize - 2 * layoutGap, unscaledHeight - 2 * borderSize - 2 * layoutGap);

        setElementPosition(contentGroup, xStart, yStart);
        setElementPosition(graphicGroup, -unscaledWidth * 0.5, -unscaledHeight);
        setElementSize(graphicGroup, unscaledWidth, unscaledHeight);
    }

    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // corner radius
        var c:int = backgroundCornerRadius;
        var htw:Number = arrowWidth * 0.5;
        var th:Number = arrowHeight;

        var w:Number = unscaledWidth;
        var h:Number = unscaledHeight - th;

        // ycabon: Let's start the voodoo
        var s:StringPath = this.stringPath;
        s.reset();
        // Draw the top and the right side
        s.m(c, 0).h(w - c).q(w, c, c).v(h - c).q(w - c, h, c);
        // Draw the tail.
        s.h(w * 0.5 + htw).l(w * 0.5, h + th).l(w * 0.5 - htw, h).h(c);
        // Draw the top and the left side, Finish
        s.q(0, h - c, c).v(c).q(c, 0, c).z();
        infoWindowPath.data = s.data;
        (infoWindowPath.fill as LinearGradient).entries[1].ratio = h / unscaledHeight;
        infoWindowPath.validateNow();
    }

}
}
import flash.geom.Point;

class StringPath
{
    public var data:String = "";

    private var pen:Point = new Point();

    public function reset():StringPath
    {
        data = "";
        pen.setTo(0, 0);
        return this;
    }

    public function m(x:Number, y:Number):StringPath
    {
        data += "M " + x + " " + y + " ";
        pen.setTo(x, y);
        return this;
    }

    public function l(x:Number, y:Number):StringPath
    {
        data += "L " + x + " " + y + " ";
        pen.setTo(x, y);
        return this;
    }

    public function h(x:Number):StringPath
    {
        data += "H " + x + " ";
        pen.x = x;
        return this;
    }

    public function v(y:Number):StringPath
    {
        data += "V " + y + " ";
        pen.y = y;
        return this;
    }

    public function q(x:Number, y:Number, cornerRadius:Number):StringPath
    {
        var controlX:Number,
            controlY:Number;

        if (x > pen.x)
        {
            if (y > pen.y)
            {
                controlX = x;
                controlY = pen.y;
            }
            else
            {
                controlX = pen.x;
                controlY = y;
            }
        }
        else
        {
            if (y > pen.y)
            {
                controlX = pen.x;
                controlY = y;
            }
            else
            {
                controlX = x;
                controlY = pen.y;
            }
        }

        data += "Q " + controlX + " " + controlY + " " + x + " " + y + " ";
        pen.setTo(x, y);
        return this;
    }

    public function z():StringPath
    {
        data += "Z ";
        return this;
    }

}
