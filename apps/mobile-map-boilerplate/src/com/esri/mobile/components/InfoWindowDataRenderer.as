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

package com.esri.mobile.components
{

import com.esri.mobile.components.supportClasses.ItemRenderer;
import com.esri.mobile.managers.supportClasses.InfoWindowData;

import flash.utils.getQualifiedClassName;

import mx.graphics.BitmapFillMode;

import spark.components.Image;
import spark.components.supportClasses.StyleableTextField;

/**
 * ItemRenderer that display an InfoWindowData object.
 */
public class InfoWindowDataRenderer extends com.esri.mobile.components.supportClasses.ItemRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  CSS Selector use for the subLabel.
     */
    private static const SUBLABEL_SELECTOR:String = getQualifiedClassName(InfoWindowDataRenderer).replace("::", ".") + " .subLabel";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function InfoWindowDataRenderer()
    {
        super();
    }


    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    protected var iconDisplay:Image;

    protected var labelDisplay:StyleableTextField;

    protected var subLabelDisplay:StyleableTextField;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (!iconDisplay)
        {
            createImage();
        }

        if (!labelDisplay)
        {
            createLabel();
        }

        if (!subLabelDisplay)
        {
            createSubLabel();
        }
    }

    /**
     *  @private
     */
    override protected function commitData():void
    {
        super.commitData();

        var infoWindowData:InfoWindowData = data as InfoWindowData;
        if (infoWindowData)
        {
            iconDisplay.source = infoWindowData.icon;
            labelDisplay.text = infoWindowData.getAttribute(infoWindowData.labelField);
            subLabelDisplay.text = infoWindowData.getAttribute(infoWindowData.subLabelField);
        }
    }

    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);

        setElementPosition(iconDisplay, 0, 0);
        setElementSize(iconDisplay, unscaledHeight, unscaledHeight);

        var viewWidth:Number = unscaledWidth - 2 * layoutGap;
        var viewHeight:Number = unscaledHeight - 2 * layoutGap;
        
        var verticalAlign:String;
        
        if (labelDisplay)
        {
            if (!subLabelDisplay || subLabelDisplay.text == "")
            {
                verticalAlign = "middle";
            }
            else
            {
                verticalAlign = "top";
            }
            positionAndSizeLabel(labelDisplay, viewWidth, viewHeight, unscaledHeight, layoutGap, verticalAlign);
        }
        if (subLabelDisplay && subLabelDisplay.text != "")
        {
            verticalAlign = "bottom";
            subLabelDisplay.visible = true;
            positionAndSizeLabel(subLabelDisplay, viewWidth, viewHeight, unscaledHeight, layoutGap, verticalAlign);
        }
        else
        {
            subLabelDisplay.visible = false;
        }
    }

    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.drawBackground(unscaledWidth, unscaledHeight);

        var backgroundColor:uint = getStyle("downColor");
        var backgroundAlpha:Number = down ? 1 : 0;

        graphics.beginFill(backgroundColor, backgroundAlpha);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
    }


    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    protected function createImage():void
    {
        iconDisplay = new Image();
        iconDisplay.fillMode = BitmapFillMode.CLIP;
        iconDisplay.verticalAlign = "middle";
        addChild(iconDisplay);
    }

    protected function createLabel():void
    {
        labelDisplay = createInFontContext(StyleableTextField) as StyleableTextField;
        labelDisplay.styleName = this;
        labelDisplay.editable = false;
        labelDisplay.wordWrap = false;
        labelDisplay.selectable = false;
        labelDisplay.mouseEnabled = false;
        addChild(labelDisplay);
    }

    protected function createSubLabel():void
    {
        // ycabon:
        // Create the sublabel with the style declaration of the renderer and some extra prop in the .subLabel one.
        subLabelDisplay = createInFontContext(StyleableTextField) as StyleableTextField;
        subLabelDisplay.styleName = this;
        subLabelDisplay.styleDeclaration = styleManager.getStyleDeclaration(SUBLABEL_SELECTOR);
        subLabelDisplay.editable = false;
        subLabelDisplay.wordWrap = false;
        subLabelDisplay.selectable = false;
        subLabelDisplay.mouseEnabled = false;
        addChild(subLabelDisplay);
    }

}
}
