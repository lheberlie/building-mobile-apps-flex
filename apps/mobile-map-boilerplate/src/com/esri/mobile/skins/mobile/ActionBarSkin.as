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

import flash.text.TextFormatAlign;

import mx.core.DPIClassification;

import spark.components.ActionBar;
import spark.components.Group;
import spark.layouts.HorizontalAlign;
import spark.layouts.HorizontalLayout;
import spark.layouts.VerticalAlign;
import spark.skins.mobile.supportClasses.TabbedViewNavigatorTabBarHorizontalLayout;

/**
 *  The default skin class for the Spark ActionBar component in mobile
 *  applications.
 */
public class ActionBarSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function ActionBarSkin()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO
                layoutContentGroupHeight = 86;
                layoutTitleGroupHorizontalPadding = 26;
                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO
                layoutContentGroupHeight = 65;
                layoutTitleGroupHorizontalPadding = 20;
                */
                break;
            }
            default:
            {
                // default DPI_160
                layoutContentGroupHeight = 48;
                break;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Layout variables
    //
    //--------------------------------------------------------------------------

    /**
     *  Default height for navigationGroup and actionGroup.
     */
    protected var layoutContentGroupHeight:uint;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:ActionBar;

    private var m_navigationVisible:Boolean = false;

    private var m_titleContentVisible:Boolean = false;

    private var m_actionVisible:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.components.ActionBar#navigationGroup
     */
    public var navigationGroup:Group;

    /**
     *  @copy spark.components.ActionBar#titleGroup
     */
    public var titleGroup:Group;

    /**
     *  @copy spark.components.ActionBar#actionGroup
     */
    public var actionGroup:Group;

    /**
     *  @copy spark.components.ActionBar#titleDisplay
     *
     *  @private
     *  Wraps a StyleableTextField in a UIComponent to be compatible with
     *  ViewTransition effects.
     */
    public var titleDisplay:TitleDisplayComponent;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        navigationGroup = new Group();
        var hLayout:HorizontalLayout = new HorizontalLayout();
        hLayout.horizontalAlign = HorizontalAlign.LEFT;
        hLayout.verticalAlign = VerticalAlign.MIDDLE;
        hLayout.gap = 0;
        hLayout.paddingLeft = hLayout.paddingTop = hLayout.paddingRight =
            hLayout.paddingBottom = 0;
        navigationGroup.layout = hLayout;
        navigationGroup.id = "navigationGroup";

        titleGroup = new Group();
        hLayout = new HorizontalLayout();
        hLayout.horizontalAlign = HorizontalAlign.LEFT;
        hLayout.verticalAlign = VerticalAlign.MIDDLE;
        hLayout.gap = 0;
        hLayout.paddingLeft = hLayout.paddingRight = hLayout.paddingTop = hLayout.paddingBottom = 0;
        titleGroup.layout = hLayout;
        titleGroup.id = "titleGroup";

        actionGroup = new Group();
        var tLayout:TabbedViewNavigatorTabBarHorizontalLayout = new TabbedViewNavigatorTabBarHorizontalLayout();
        actionGroup.layout = tLayout;
        actionGroup.id = "actionGroup";

        titleDisplay = new TitleDisplayComponent();
        titleDisplay.id = "titleDisplay";

        // initialize titleAlign style (center is managed explicitly in layoutContents)
        var titleAlign:String = getStyle("titleAlign");
        titleAlign = (titleAlign == "center") ? TextFormatAlign.LEFT : titleAlign;
        titleDisplay.setStyle("textAlign", titleAlign);

        addChild(navigationGroup);
        addChild(titleGroup);
        addChild(actionGroup);
        addChild(titleDisplay);
    }

    override protected function measure():void
    {
        measuredHeight = layoutContentGroupHeight;
    }

    /**
     *  @private
     */
    override protected function commitCurrentState():void
    {
        super.commitCurrentState();

        m_titleContentVisible = currentState.indexOf("titleContent") >= 0;
        m_navigationVisible = currentState.indexOf("Navigation") >= 0;
        m_actionVisible = currentState.indexOf("Action") >= 0;

        invalidateSize();
        invalidateDisplayList();
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        if (titleDisplay)
        {
            var allStyles:Boolean = !styleProp || styleProp == "styleName";

            if (allStyles || (styleProp == "titleAlign"))
            {
                var titleAlign:String = getStyle("titleAlign");

                if (titleAlign == "center")
                {
                    // If the title align is set to center, the alignment is set to LEFT
                    // so that the skin can manually center the component in layoutContents
                    titleDisplay.setStyle("textAlign", TextFormatAlign.LEFT);
                }
                else
                {
                    titleDisplay.setStyle("textAlign", titleAlign);
                }
            }
        }

        super.styleChanged(styleProp);
    }

    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);

        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingRight:Number = getStyle("paddingRight");

        var navigationGroupWidth:Number = 0;
        var titleCompX:Number = paddingLeft;
        var titleCompWidth:Number = 0;
        
        var actionGroupX:Number = unscaledWidth;
        var actionGroupY:Number = 0;
        var actionGroupWidth:Number = 0;
        
        var splitMode:Boolean = hostComponent.actionContent != null
            && (unscaledWidth < 480 || (isPhone && isPortrait));

        if (m_navigationVisible)
        {
            navigationGroupWidth = getElementPreferredWidth(navigationGroup);
            titleCompX += navigationGroupWidth;

            setElementSize(navigationGroup, navigationGroupWidth, layoutContentGroupHeight);
            setElementPosition(navigationGroup, paddingLeft, 0);
        }

        if (m_actionVisible)
        {
            if (splitMode)
            {
                actionGroupWidth = 0;
                actionGroupX = paddingLeft;
                actionGroupY = unscaledHeight - layoutContentGroupHeight;
                setElementSize(actionGroup, unscaledWidth, layoutContentGroupHeight);
            }
            else
            {
                actionGroupWidth = actionGroup.getPreferredBoundsWidth();
                actionGroupX = unscaledWidth - actionGroupWidth - paddingRight;
                setElementSize(actionGroup, actionGroupWidth, layoutContentGroupHeight);
            }
            setElementPosition(actionGroup, actionGroupX, actionGroupY);
        }

        // titleGroup or titleDisplay is given remaining width after navigation
        // and action groups preferred widths
        titleCompWidth = unscaledWidth - navigationGroupWidth - actionGroupWidth
            - paddingLeft - paddingRight;

        if (titleCompWidth <= 0)
        {
            titleDisplay.visible = false;
            titleGroup.visible = false;
        }
        else if (m_titleContentVisible)
        {
            titleDisplay.visible = false;
            titleGroup.visible = true;

            // use titleGroup for titleContent
            setElementSize(titleGroup, unscaledWidth - navigationGroupWidth - actionGroupWidth, layoutContentGroupHeight);
            setElementPosition(titleGroup, titleCompX, 0);
        }
        else
        {
            // use titleDisplay for title text label
            titleGroup.visible = false;

            // use titleLayout for paddingLeft and paddingRight
            var layoutObject:Object = hostComponent.titleLayout;
            var titlePaddingLeft:Number = (layoutObject.paddingLeft) ? Number(layoutObject.paddingLeft) : 0;
            var titlePaddingRight:Number = (layoutObject.paddingRight) ? Number(layoutObject.paddingRight) : 0;

            // align titleDisplay to the absolute center
            var titleAlign:String = getStyle("titleAlign");

            // check for available width after padding
            if ((titleCompWidth - titlePaddingLeft - titlePaddingRight) <= 0)
            {
                titleCompX = 0;
                titleCompWidth = 0;
            }
            else if (titleAlign == "center")
            {
                // use LEFT instead of CENTER
                titleCompWidth = titleDisplay.getExplicitOrMeasuredWidth();

                // use x position of titleDisplay to implement CENTER
                titleCompX = Math.round((unscaledWidth - titleCompWidth) / 2);

                var navigationOverlap:Number = navigationGroupWidth + titlePaddingLeft - titleCompX;
                var actionOverlap:Number = (titleCompX + titleCompWidth + titlePaddingRight) - actionGroupX;

                // shrink and/or move titleDisplay width if there is any
                // overlap after centering
                if ((navigationOverlap > 0) && (actionOverlap > 0))
                {
                    // remaining width
                    titleCompX = navigationGroupWidth + titlePaddingLeft;
                    titleCompWidth = unscaledWidth - navigationGroupWidth - actionGroupWidth - titlePaddingLeft - titlePaddingRight;
                }
                else if ((navigationOverlap > 0) || (actionOverlap > 0))
                {
                    if (navigationOverlap > 0)
                    {
                        // nudge to the right
                        titleCompX += navigationOverlap;
                    }
                    else if (actionOverlap > 0)
                    {
                        // nudge to the left
                        titleCompX -= actionOverlap;

                        // force left padding
                        if (titleCompX < (navigationGroupWidth + titlePaddingLeft))
                        {
                            titleCompX = navigationGroupWidth + titlePaddingLeft;
                        }
                    }

                    // recompute action overlap and force right padding
                    actionOverlap = (titleCompX + titleCompWidth + titlePaddingRight) - actionGroupX;

                    if (actionOverlap > 0)
                    {
                        titleCompWidth -= actionOverlap;
                    }
                }
            }
            else
            {
                // implement padding by adjusting width and position
                titleCompX += titlePaddingLeft;
                titleCompWidth = titleCompWidth - titlePaddingLeft - titlePaddingRight;
            }

            // check for negative width
            titleCompWidth = (titleCompWidth < 0) ? 0 : titleCompWidth;

            setElementSize(titleDisplay, titleCompWidth, layoutContentGroupHeight);
            setElementPosition(titleDisplay, titleCompX, 0);

            titleDisplay.visible = true;
        }
    }

    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.drawBackground(unscaledWidth, unscaledHeight);

        var chromeColor:uint = getStyle("chromeColor");
        var backgroundAlphaValue:Number = getStyle("backgroundAlpha");

        graphics.beginFill(chromeColor, backgroundAlphaValue);
        graphics.drawRect(0, 0, unscaledWidth, layoutContentGroupHeight);

        var splitMode:Boolean = hostComponent.actionContent != null
            && (unscaledWidth < 480 || (isPhone && isPortrait));
        if (splitMode)
        {
            var startY:Number = unscaledHeight - layoutContentGroupHeight;
            graphics.drawRect(0, startY, unscaledWidth, layoutContentGroupHeight);
        }

        graphics.endFill();
    }

}
}

import flash.events.Event;

import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;

import spark.components.supportClasses.StyleableTextField;
import spark.core.IDisplayText;

use namespace mx_internal;

/**
 *  @private
 *  Component that holds StyleableTextFields to produce a drop shadow effect.
 *  Combines label and shadow into a single component to allow transitions to
 *  target them both.
 */
class TitleDisplayComponent extends UIComponent implements IDisplayText
{
    private var titleDisplay:StyleableTextField;
    private var titleDisplayShadow:StyleableTextField;
    private var title:String;
    private var titleChanged:Boolean;

    public function TitleDisplayComponent()
    {
        super();
        title = "";
    }

    override public function get baselinePosition():Number
    {
        return titleDisplay.baselinePosition;
    }

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        titleDisplay = StyleableTextField(createInFontContext(StyleableTextField));
        titleDisplay.styleName = this;
        titleDisplay.editable = false;
        titleDisplay.selectable = false;
        titleDisplay.multiline = false;
        titleDisplay.wordWrap = false;
        titleDisplay.addEventListener(FlexEvent.VALUE_COMMIT,
                                      titleDisplay_valueCommitHandler);

        titleDisplayShadow =
            StyleableTextField(createInFontContext(StyleableTextField));
        titleDisplayShadow.styleName = this;
        titleDisplayShadow.colorName = "textShadowColor";
        titleDisplayShadow.editable = false;
        titleDisplayShadow.selectable = false;
        titleDisplayShadow.multiline = false;
        titleDisplayShadow.wordWrap = false;

        addChild(titleDisplayShadow);
        addChild(titleDisplay);
    }

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (titleChanged)
        {
            titleDisplay.text = title;

            invalidateSize();
            invalidateDisplayList();

            titleChanged = false;
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        // reset text if it was truncated before.
        if (titleDisplay.isTruncated)
        {
            titleDisplay.text = title;
        }

        measuredWidth = titleDisplay.getPreferredBoundsWidth();

        // tightTextHeight
        measuredHeight = titleDisplay.getPreferredBoundsHeight();
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        // reset text if it was truncated before.
        if (titleDisplay.isTruncated)
        {
            titleDisplay.text = title;
        }
        titleDisplay.commitStyles();

        // use preferred height, setLayoutBoundsSize will accommodate for tight
        // text adjustment
        var tightHeight:Number = titleDisplay.getPreferredBoundsHeight();
        var tightY:Number = (unscaledHeight - tightHeight) / 2;

        titleDisplay.setLayoutBoundsSize(unscaledWidth, tightHeight);
        titleDisplay.setLayoutBoundsPosition(0, (unscaledHeight - tightHeight) / 2);

        // now truncate the text
        titleDisplay.truncateToFit();

        titleDisplayShadow.commitStyles();
        titleDisplayShadow.setLayoutBoundsSize(unscaledWidth, tightHeight);
        titleDisplayShadow.setLayoutBoundsPosition(0, tightY + 1);

        titleDisplayShadow.alpha = getStyle("textShadowAlpha");

        // if labelDisplay is truncated, then push it down here as well.
        // otherwise, it would have gotten pushed in the labelDisplay_valueCommitHandler()
        if (titleDisplay.isTruncated)
        {
            titleDisplayShadow.text = titleDisplay.text;
        }
    }

    /**
     *  @private
     */
    private function titleDisplay_valueCommitHandler(event:Event):void
    {
        titleDisplayShadow.text = titleDisplay.text;
    }

    public function get text():String
    {
        return title;
    }

    public function set text(value:String):void
    {
        title = value;
        titleChanged = true;

        invalidateProperties();
    }

    public function get isTruncated():Boolean
    {
        return titleDisplay.isTruncated;
    }
}
