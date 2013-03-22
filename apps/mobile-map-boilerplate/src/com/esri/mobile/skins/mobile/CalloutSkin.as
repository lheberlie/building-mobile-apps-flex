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

import flash.display.BlendMode;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;

import mx.core.DPIClassification;
import mx.core.mx_internal;
import mx.events.EffectEvent;
import mx.events.FlexEvent;

import spark.components.Callout;
import spark.components.ContentBackgroundAppearance;
import spark.components.Group;
import spark.core.SpriteVisualElement;
import spark.effects.Fade;
import spark.primitives.RectangularDropShadow;

use namespace mx_internal;

public class CalloutSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
{
    mx_internal static const BACKGROUND_GRADIENT_BRIGHTNESS_TOP:int = 15;

    mx_internal static const BACKGROUND_GRADIENT_BRIGHTNESS_BOTTOM:int = -60;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function CalloutSkin()
    {
        super();

        dropShadowAlpha = 0.7;

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO
                backgroundCornerRadius = 16;
                frameThickness = 16;
                contentCornerRadius = 10;
                dropShadowBlurX = 32;
                dropShadowBlurY = 32;
                dropShadowDistance = 6;
                highlightWeight = 2;
                */

                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO
                backgroundCornerRadius = 12;
                frameThickness = 12;
                contentCornerRadius = 7;
                dropShadowBlurX = 24;
                dropShadowBlurY = 24;
                dropShadowDistance = 4;
                highlightWeight = 1;
                */

                break;
            }
            default:
            {
                // default DPI_160
                backgroundCornerRadius = 1; // 8;
                frameThickness = 0;//8;
                contentCornerRadius = 1;//5;
                dropShadowBlurX = 4;//16;
                dropShadowBlurY = 4;//16;
                dropShadowDistance = 1;//3;
                highlightWeight = 0; //1;

                break;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:Callout;

    /**
     *  Enables a RectangularDropShadow behind the <code>backgroundColor</code> frame.
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */
    protected var dropShadowVisible:Boolean = true;

    /**
     *  Corner radius used for the <code>contentBackgroundColor</code> fill.
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */
    protected var contentCornerRadius:uint;

    /**
     *  Corner radius of the <code>backgroundColor</code> "frame".
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */
    protected var backgroundCornerRadius:Number;

    /**
     *  The thickness of the <code>backgroundColor</code> "frame" that surrounds the
     *  <code>contentGroup</code>.
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */
    protected var frameThickness:Number;

    /**
     *  Color of the border stroke around the <code>backgroundColor</code> "frame".
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */
    protected var borderColor:Number = 0;

    /**
     *  Thickness of the border stroke around the <code>backgroundColor</code>
     *  "frame".
     *
     *  @langversion 3.0
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */
    protected var borderThickness:Number = NaN;

    /**
     *  @private
     *  Instance of the contentBackgroundClass
     */
    mx_internal var contentBackgroundGraphic:SpriteVisualElement;

    /**
     *  @private
     *  Tracks changes to the skin state to support the fade out tranisition
     *  when closed;
     */
    mx_internal var isOpen:Boolean;

    private var contentMask:Sprite;

    private var backgroundFill:SpriteVisualElement;

    private var dropShadow:RectangularDropShadow;

    private var dropShadowBlurX:Number;

    private var dropShadowBlurY:Number;

    private var dropShadowDistance:Number;

    private var dropShadowAlpha:Number;

    private var fade:Fade;

    private var highlightWeight:Number;

    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.components.SkinnableContainer#contentGroup
     */
    public var contentGroup:Group;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (dropShadowVisible)
        {
            dropShadow = new RectangularDropShadow();
            dropShadow.angle = 90;
            dropShadow.distance = dropShadowDistance;
            dropShadow.blurX = dropShadowBlurX;
            dropShadow.blurY = dropShadowBlurY;
            dropShadow.tlRadius = dropShadow.trRadius = dropShadow.blRadius =
                dropShadow.brRadius = backgroundCornerRadius;
            dropShadow.mouseEnabled = false;
            dropShadow.alpha = dropShadowAlpha;
            addChild(dropShadow);
        }

        // background fill placed above the drop shadow
        backgroundFill = new SpriteVisualElement();
        addChild(backgroundFill);

        // contentGroup
        if (!contentGroup)
        {
            contentGroup = new Group();
            contentGroup.id = "contentGroup";
            contentGroup.minWidth = contentGroup.minHeight = 0;
            addChild(contentGroup);
        }
    }

    /**
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        // always invalidate to accomodate arrow direction changes
        invalidateSize();
        invalidateDisplayList();
    }

    /**
     * @private
     */
    override protected function measure():void
    {
        super.measure();

        var borderWeight:Number = isNaN(borderThickness) ? 0 : borderThickness;
        var frameAdjustment:Number = (frameThickness + borderWeight) * 2;

        // count the contentGroup size and frame size
        measuredMinWidth = contentGroup.measuredMinWidth + frameAdjustment;
        measuredMinHeight = contentGroup.measuredMinHeight + frameAdjustment;

        measuredWidth = contentGroup.getPreferredBoundsWidth() + frameAdjustment;
        measuredHeight = contentGroup.getPreferredBoundsHeight() + frameAdjustment;
    }

    /**
     *  @private
     *  SkinnaablePopUpContainer skins must dispatch a
     *  FlexEvent.STATE_CHANGE_COMPLETE event for the component to properly
     *  update the skin state.
     */
    override protected function commitCurrentState():void
    {
        super.commitCurrentState();

        var isNormal:Boolean = (currentState == "normal");
        var isDisabled:Boolean = (currentState == "disabled")

        // play a fade out if the callout was previously open
        if (!(isNormal || isDisabled) && isOpen)
        {
            if (!fade)
            {
                fade = new Fade();
                fade.target = this;
                fade.duration = 200;
                fade.alphaTo = 0;
            }

            // BlendMode.LAYER while fading out
            blendMode = BlendMode.LAYER;

            // play a short fade effect
            fade.addEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
            fade.play();

            isOpen = false;
        }
        else
        {
            isOpen = isNormal || isDisabled;

            // handle re-opening the Callout while fading out
            if (fade && fade.isPlaying)
            {
                // Do not dispatch a state change complete.
                // SkinnablePopUpContainer handles state interruptions.
                fade.removeEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
                fade.stop();
            }

            if (isDisabled)
            {
                // BlendMode.LAYER to allow CalloutArrow BlendMode.ERASE
                blendMode = BlendMode.LAYER;

                alpha = 0.5;
            }
            else
            {
                // BlendMode.NORMAL for non-animated state transitions
                blendMode = BlendMode.NORMAL;

                if (isNormal)
                {
                    alpha = 1;
                }
                else
                {
                    alpha = 0;
                }
            }

            stateChangeComplete();
        }
    }

    /**
     * @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.drawBackground(unscaledWidth, unscaledHeight);

        var frameEllipseSize:Number = backgroundCornerRadius * 2;

        // account for borderThickness center stroke alignment
        var showBorder:Boolean = !isNaN(borderThickness);
        var borderWeight:Number = showBorder ? borderThickness : 0;

        // contentBackgroundGraphic already accounts for the arrow position
        // use it's positioning instead of recalculating based on unscaledWidth
        // and unscaledHeight
        var frameX:Number = Math.floor(contentGroup.getLayoutBoundsX() - frameThickness) - (borderWeight / 2);
        var frameY:Number = Math.floor(contentGroup.getLayoutBoundsY() - frameThickness) - (borderWeight / 2);
        var frameWidth:Number = contentGroup.getLayoutBoundsWidth() + (frameThickness * 2) + borderWeight;
        var frameHeight:Number = contentGroup.getLayoutBoundsHeight() + (frameThickness * 2) + borderWeight;

        var backgroundColor:Number = getStyle("backgroundColor");
        var backgroundAlpha:Number = getStyle("backgroundAlpha");

        var bgFill:Graphics = backgroundFill.graphics;
        bgFill.clear();

        if (showBorder)
        {
            bgFill.lineStyle(borderThickness, borderColor, 1, true);
        }

        bgFill.beginFill(backgroundColor, backgroundAlpha);
        bgFill.drawRoundRect(frameX, frameY, frameWidth,
                             frameHeight, frameEllipseSize, frameEllipseSize);
        bgFill.endFill();

        // draw content background styles
        var contentBackgroundAppearance:String = getStyle("contentBackgroundAppearance");

        if (contentBackgroundAppearance != ContentBackgroundAppearance.NONE)
        {
            var contentEllipseSize:Number = contentCornerRadius * 2;
            var contentBackgroundAlpha:Number = getStyle("contentBackgroundAlpha");
            var contentWidth:Number = contentGroup.getLayoutBoundsWidth();
            var contentHeight:Number = contentGroup.getLayoutBoundsHeight();

            // all appearance values except for "none" use a mask
            if (!contentMask)
            {
                contentMask = new SpriteVisualElement();
            }

            contentGroup.mask = contentMask;

            // draw contentMask in contentGroup coordinate space
            var maskGraphics:Graphics = contentMask.graphics;
            maskGraphics.clear();
            maskGraphics.beginFill(0, 1);
            maskGraphics.drawRoundRect(0, 0, contentWidth, contentHeight,
                                       contentEllipseSize, contentEllipseSize);
            maskGraphics.endFill();

            // reset line style to none
            if (showBorder)
            {
                bgFill.lineStyle(NaN);
            }

            // draw the contentBackgroundColor
            bgFill.beginFill(getStyle("contentBackgroundColor"),
                             contentBackgroundAlpha);
            bgFill.drawRoundRect(contentGroup.getLayoutBoundsX(),
                                 contentGroup.getLayoutBoundsY(),
                                 contentWidth, contentHeight, contentEllipseSize, contentEllipseSize);
            bgFill.endFill();

            if (contentBackgroundGraphic)
            {
                contentBackgroundGraphic.alpha = contentBackgroundAlpha;
            }
        }
        else // if (contentBackgroundAppearance == CalloutContentBackgroundAppearance.NONE))
        {
            // remove the mask
            if (contentMask)
            {
                contentGroup.mask = null;
                contentMask = null;
            }
        }
    }

    /**
     * @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);

        setElementSize(backgroundFill, unscaledWidth, unscaledHeight);
        setElementPosition(backgroundFill, 0, 0);

        var frameX:Number = 0;
        var frameY:Number = 0;
        var frameWidth:Number = unscaledWidth;
        var frameHeight:Number = unscaledHeight;

        if (dropShadow)
        {
            setElementSize(dropShadow, frameWidth, frameHeight);
            setElementPosition(dropShadow, frameX, frameY);
        }

        // Show frameThickness by inset of contentGroup
        var borderWeight:Number = isNaN(borderThickness) ? 0 : borderThickness;
        var contentBackgroundAdjustment:Number = frameThickness + borderWeight;

        var contentBackgroundX:Number = frameX + contentBackgroundAdjustment;
        var contentBackgroundY:Number = frameY + contentBackgroundAdjustment;

        contentBackgroundAdjustment = contentBackgroundAdjustment * 2;
        var contentBackgroundWidth:Number = frameWidth - contentBackgroundAdjustment;
        var contentBackgroundHeight:Number = frameHeight - contentBackgroundAdjustment;

        if (contentBackgroundGraphic)
        {
            setElementSize(contentBackgroundGraphic, contentBackgroundWidth, contentBackgroundHeight);
            setElementPosition(contentBackgroundGraphic, contentBackgroundX, contentBackgroundY);
        }

        setElementSize(contentGroup, contentBackgroundWidth, contentBackgroundHeight);
        setElementPosition(contentGroup, contentBackgroundX, contentBackgroundY);

        // mask position is in the contentGroup coordinate space
        if (contentMask)
        {
            setElementSize(contentMask, contentBackgroundWidth, contentBackgroundHeight);
        }
    }

    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        var allStyles:Boolean = !styleProp || styleProp == "styleName";

        if (allStyles || (styleProp == "contentBackgroundAppearance"))
        {
            invalidateProperties();
        }

        if (allStyles || (styleProp == "backgroundAlpha"))
        {
            var backgroundAlpha:Number = getStyle("backgroundAlpha");

            // Use BlendMode.LAYER to allow CalloutArrow to erase the dropShadow
            // when the Callout background is transparent
            blendMode = (backgroundAlpha < 1) ? BlendMode.LAYER : BlendMode.NORMAL;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function stateChangeComplete(event:Event = null):void
    {
        if (fade && event)
        {
            fade.removeEventListener(EffectEvent.EFFECT_END, stateChangeComplete);
        }

        // SkinnablePopUpContainer relies on state changes for open and close
        dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_COMPLETE));
    }
}
}
