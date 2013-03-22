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

import com.esri.mobile.components.HorizontalPagingList;
import com.esri.mobile.components.LabelItemRenderer;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;
import com.esri.mobile.utils.DeviceUtil;

import flash.display.BlendMode;
import flash.display.Sprite;
import flash.utils.getQualifiedClassName;

import mx.core.ClassFactory;
import mx.core.DPIClassification;
import mx.core.mx_internal;
import mx.events.FlexEvent;

import spark.components.DataGroup;
import spark.components.Scroller;
import spark.components.supportClasses.StyleableTextField;
import spark.layouts.TileLayout;

use namespace mx_internal;

/**
 * A skin for the list of pages.
 *
 * It's inspired by Jason San Jose mobile list skin.
 * @see http://blogs.adobe.com/jasonsj/2011/11/mobile-list-paging-with-page-indicator-skin.html Mobile List Paging with Page Indicator Skin
 */
public class HorizontalPagingListSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  CSS Selector use for the indicator label.
     */
    private static const INDICATOR_SELECTOR:String = getQualifiedClassName(HorizontalPagingList).replace("::", ".") + " .indicator";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function HorizontalPagingListSkin()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification

                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification

                */
                break;
            }
            default:
            {
                pageLabelHeight = 12;
                measuredDefaultWidth = DeviceUtil.isTablet ? 320 : DeviceUtil.screenWidth - 20;
                measuredDefaultHeight = 56 + pageLabelHeight;
                break;
            }
        }

        minWidth = 112;
        blendMode = BlendMode.NORMAL;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:HorizontalPagingList;
    
    protected var pageLabelHeight:int;
    
    protected var indicatorOnTop:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var scroller:Scroller;

    public var dataGroup:DataGroup;

    public var indicatorContainer:Sprite;

    public var indicatorDisplay:StyleableTextField;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override public function styleChanged(styleProp:String):void
    {
        var allStyles:Boolean = !styleProp || styleProp == "styleName";

        super.styleChanged(styleProp);

        if (allStyles || styleProp == "indicatorPosition")
        {
            indicatorOnTop = getStyle("indicatorPosition") == "top";
            invalidateDisplayList();
        }
    }

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        if (!dataGroup)
        {
            // Create data group layout
            var layout:TileLayout = new TileLayout();
            layout.orientation = "rows";
            layout.requestedRowCount = 1;
            //layout.columnWidth = measuredDefaultWidth;
            //layout.rowHeight = measuredDefaultHeight - pageLabelHeight;
            layout.verticalGap = 0;
            layout.horizontalGap = 0;

            // Create data group
            dataGroup = new DataGroup();
            dataGroup.layout = layout;
            dataGroup.itemRenderer = new ClassFactory(com.esri.mobile.components.LabelItemRenderer);

            // listen for changes to the list
            dataGroup.addEventListener(FlexEvent.UPDATE_COMPLETE, dataGroupUpdateComplete);
        }

        if (!scroller)
        {
            // Create scroller
            scroller = new Scroller();
            scroller.hasFocusableChildren = false;
            scroller.ensureElementIsVisibleForSoftKeyboard = false;
            scroller.minViewportInset = 0;
            scroller.measuredSizeIncludesScrollBars = false;
            scroller.mx_internal::bounceEnabled = false;
            scroller.setStyle("backgroundColor", getStyle("downColor"));
            addChild(scroller);
        }

        // Associate scroller with data group
        if (!scroller.viewport)
        {
            scroller.viewport = dataGroup;
        }

        if (!indicatorContainer)
        {
            indicatorContainer = new Sprite();
            addChild(indicatorContainer);
        }

        if (!indicatorDisplay)
        {
            indicatorDisplay = createInFontContext(StyleableTextField) as StyleableTextField;
            indicatorDisplay.styleName = hostComponent;
            indicatorDisplay.styleDeclaration = styleManager.getStyleDeclaration(INDICATOR_SELECTOR);
            indicatorDisplay.editable = false;
            indicatorDisplay.selectable = false;
            indicatorDisplay.multiline = false;
            indicatorDisplay.wordWrap = true;
            indicatorDisplay.mouseEnabled = false;
            indicatorContainer.addChild(indicatorDisplay);
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        measuredWidth = Math.min(measuredDefaultWidth, dataGroup.getExplicitOrMeasuredWidth());
        measuredHeight = dataGroup.getExplicitOrMeasuredHeight() + pageLabelHeight;
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Skip super.
        graphics.clear();

        var layout:TileLayout = dataGroup.layout as TileLayout;
        setElementSize(scroller, unscaledWidth, unscaledHeight - pageLabelHeight);
        
        if (layout)
        {
            layout.columnWidth = unscaledWidth;
            layout.rowHeight = unscaledHeight - pageLabelHeight;

            indicatorContainer.x = 0;
            indicatorContainer.graphics.clear();
            indicatorContainer.graphics.beginFill(getStyle("chromeColor"), 1);
            indicatorContainer.graphics.drawRect(0, 0, unscaledWidth, pageLabelHeight);
            indicatorContainer.graphics.endFill();

            indicatorDisplay.text = hostComponent.pageNumber + " of " + hostComponent.numPages;
            var labelHeight:Number = getElementPreferredHeight(indicatorDisplay);
            setElementPosition(indicatorDisplay, 0, (pageLabelHeight - labelHeight) * 0.5);
            setElementSize(indicatorDisplay, unscaledWidth, labelHeight);
        }
        
        if (indicatorOnTop)
        {
            indicatorContainer.y = 0;
            setElementPosition(scroller, 0, pageLabelHeight);
        }
        else
        {
            indicatorContainer.y = unscaledHeight - pageLabelHeight;
            setElementPosition(scroller, 0, 0);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    private function dataGroupUpdateComplete(event:FlexEvent):void
    {
        if (dataGroup.getExplicitOrMeasuredHeight() != unscaledHeight)
        {
            var layout:TileLayout = dataGroup.layout as TileLayout;
            if (layout)
            {
                layout.columnWidth = NaN;
                layout.rowHeight = NaN;
            }
            invalidateSize();
            invalidateDisplayList();
        }
    }

/*private function touchInteractionStart(event:TouchInteractionEvent):void
{
    _suspendPageIndicatorShortcut = true;
}*/
}
}
