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

import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import flash.display.DisplayObject;
import flash.events.FocusEvent;

import mx.core.DPIClassification;
import mx.core.mx_internal;

import spark.components.supportClasses.SkinnableTextBase;
import spark.components.supportClasses.StyleableStageText;
import spark.components.supportClasses.StyleableTextField;
import spark.core.IDisplayText;

use namespace mx_internal;

public class StageTextSkinBase extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
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
    public function StageTextSkinBase()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification

                measuredDefaultWidth = 600;
                measuredDefaultHeight = 66;
                layoutBorderSize = 2;

                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification

                measuredDefaultWidth = 440;
                measuredDefaultHeight = 50;
                layoutBorderSize = 1;

                */
                break;
            }
            default:
            {
                measuredDefaultWidth = 300;
                measuredDefaultHeight = 48;
                layoutBorderSize = 1;
                layoutGap = 8;

                break;
            }
        }

        addEventListener(FocusEvent.FOCUS_IN, focusChangeHandler);
        addEventListener(FocusEvent.FOCUS_OUT, focusChangeHandler);
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var isFocused:Boolean = false;


    //--------------------------------------------------------------------------
    //
    //  Layout variables
    //
    //--------------------------------------------------------------------------

    /**
     *  Defines the border's thickness.
     */
    protected var layoutBorderSize:uint;

    /**
     *  @private
     *  Multiline flag.
     */
    protected var multiline:Boolean = false;

    private static const focusExclusions:Array = [ "textDisplay" ];

    /**
     * @private
     */
    override protected function get focusSkinExclusions():Array
    {
        return focusExclusions;
    }


    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------

    /**
     *  textDisplay skin part.
     */
    public var textDisplay:StyleableStageText;

    [Bindable]
    /**
     *  Bindable promptDisplay skin part. Bindings fire when promptDisplay is
     *  removed and added for proper updating by the SkinnableTextBase.
     */
    public var promptDisplay:IDisplayText;


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

        if (!textDisplay)
        {
            textDisplay = new StyleableStageText(multiline);
            textDisplay.editable = true;

            textDisplay.styleName = this;
            this.addChild(textDisplay);
        }
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        var allStyles:Boolean = !styleProp || styleProp == "styleName";

        if (allStyles || styleProp.indexOf("padding") == 0)
        {
            invalidateDisplayList();
        }

        super.styleChanged(styleProp);
    }

    /**
     *  @private
     */
    override protected function commitCurrentState():void
    {
        super.commitCurrentState();

        alpha = currentState.indexOf("disabled") == -1 ? 1 : 0.5;

        var showPrompt:Boolean = currentState.indexOf("WithPrompt") != -1;

        if (showPrompt && !promptDisplay)
        {
            promptDisplay = createPromptDisplay();
            promptDisplay.addEventListener(FocusEvent.FOCUS_IN, promptDisplay_focusInHandler);
        }
        else if (!showPrompt && promptDisplay)
        {
            promptDisplay.removeEventListener(FocusEvent.FOCUS_IN, promptDisplay_focusInHandler);
            removeChild(promptDisplay as DisplayObject);
            promptDisplay = null;
        }

        invalidateDisplayList();
    }

    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.drawBackground(unscaledWidth, unscaledHeight);

        var halfLayoutGap:int = layoutGap * 0.5;

        var borderWidth:uint = layoutBorderSize * 2;
        var borderHeight:uint = layoutBorderSize * 3;

        var contentBackgroundColor:uint = getStyle("contentBackgroundColor");
        var contentBackgroundAlpha:Number = getStyle("contentBackgroundAlpha");

        /*if (isNaN(contentBackgroundAlpha))
        {
            contentBackgroundAlpha = 1;
        }

        if (contentBackgroundAlpha == 1)
        {
            opaqueBackground = contentBackgroundColor;
        }
        else
        {
            // Draw the contentBackgroundColor
            graphics.beginFill(contentBackgroundColor, contentBackgroundAlpha);
            graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
            graphics.endFill();
        }*/

        if (getStyle("borderVisible"))
        {
            var borderStyle:String = getStyle("contentBackgroundAppearance");
            var borderColor:uint = isFocused ? getStyle("downColor") : getStyle("borderColor");
            var borderBottom:Number = unscaledHeight - halfLayoutGap;
            var borderRight:Number = unscaledWidth - halfLayoutGap;
            if (borderStyle == "flat")
            {
                //var borderBottom:Number = unscaledHeight - halfLayoutGap;
                //var borderRight:Number = unscaledWidth - halfLayoutGap;
                graphics.beginFill(borderColor, 1);
                graphics.drawRect(halfLayoutGap, borderBottom - borderHeight, layoutBorderSize, borderHeight);
                graphics.drawRect(halfLayoutGap + layoutBorderSize, borderBottom - layoutBorderSize, borderRight - halfLayoutGap - borderWidth, layoutBorderSize);
                graphics.drawRect(borderRight - layoutBorderSize, borderBottom - borderHeight, layoutBorderSize, borderHeight);
                graphics.endFill();
            }
            else if (borderStyle == "inset")
            {
                graphics.lineStyle(layoutBorderSize, borderColor, 1);
                graphics.beginFill(contentBackgroundColor, contentBackgroundAlpha);
                graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
                graphics.endFill();
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Utility function used by subclasses' measure functions to measure their
     *  text host components.
     */
    protected function measureTextComponent(hostComponent:SkinnableTextBase):void
    {
        var textHeight:Number = getStyle("fontSize");

        if (textDisplay)
        {
            textHeight = getElementPreferredHeight(textDisplay);
        }

        // width is based on maxChars (if set)
        if (hostComponent && hostComponent.maxChars)
        {
            // Grab the fontSize and subtract 2 as the pixel value for each character.
            // This is just an approximation, but it appears to be a reasonable one
            // for most input and most font.
            var characterWidth:int = Math.max(1, (textHeight - 2));
            measuredWidth = (characterWidth * hostComponent.maxChars) +
                4 * layoutGap;
        }

        measuredHeight = layoutGap + textHeight + layoutGap;
    }

    /**
     *  @private
     *  Create a control appropriate for displaying the prompt text in a mobile
     *  input field.
     */
    protected function createPromptDisplay():IDisplayText
    {
        var prompt:StyleableTextField = StyleableTextField(createInFontContext(StyleableTextField));
        prompt.styleName = this;
        prompt.editable = false;
        prompt.mouseEnabled = false;
        prompt.useTightTextBounds = false;

        // StageText objects appear in their own layer on top of the display
        // list. So, even though this prompt may be created after the StageText
        // for textDisplay, textDisplay will still be on top.
        addChild(prompt);

        return prompt;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function focusChangeHandler(event:FocusEvent):void
    {
        isFocused = event.type == FocusEvent.FOCUS_IN;
        invalidateDisplayList();
    }

    /**
     *  If the prompt is focused, we need to move focus to the textDisplay
     *  StageText. This needs to happen outside of the process of setting focus
     *  to the prompt, so we use callLater to do that.
     */
    private function focusTextDisplay():void
    {
        textDisplay.setFocus();
    }

    private function promptDisplay_focusInHandler(event:FocusEvent):void
    {
        callLater(focusTextDisplay);
    }


}
}
