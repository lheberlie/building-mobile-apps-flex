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

import mx.core.mx_internal;

import spark.components.LabelItemRenderer;

use namespace mx_internal;

public class LabelItemRenderer extends spark.components.LabelItemRenderer
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
    public function LabelItemRenderer()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function drawBorder(unscaledWidth:Number, unscaledHeight:Number):void
    {
        var topSeparatorColor:uint;
        var topSeparatorAlpha:Number;
        var bottomSeparatorColor:uint;
        var bottomSeparatorAlpha:Number;
        var isFirstItem:Boolean = itemIndex == 0;

        // separators are a highlight on the top and shadow on the bottom
        topSeparatorColor = 0xFFFFFF;
        topSeparatorAlpha = .3;
        bottomSeparatorColor = 0x000000;
        bottomSeparatorAlpha = .3;

        // draw separators
        // don't draw top separator for down and selected states
        // ycabon: and for the first one
        if (!(selected || down) && !isFirstItem)
        {
            graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
            graphics.drawRect(0, 0, unscaledWidth, 1);
            graphics.endFill();
        }

        if (!isLastItem)
        {
            graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
            graphics.drawRect(0, unscaledHeight - (isLastItem ? 0 : 1), unscaledWidth, 1);
            graphics.endFill();
        }

        // add extra separators to the first and last items so that 
        // the list looks correct during the scrolling bounce/pull effect
        // top
    /*if (isFirstItem)
    {
        graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
        graphics.drawRect(0, -1, unscaledWidth, 1);
        graphics.endFill();
    }

    // bottom
    if (isLastItem)
    {
        // we want to offset the bottom by 1 so that we don't get
        // a double line at the bottom of the list if there's a
        // border
        graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
        graphics.drawRect(0, unscaledHeight + 1, unscaledWidth, 1);
        graphics.endFill();
    }*/
    }

    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // figure out backgroundColor
        var backgroundColor:*;
        var backgroundAlpha:Number;
        var downColor:* = getStyle("downColor");
        var downAlpha:Number = getStyle("downAlpha");
        var drawBackground:Boolean = true;
        var opaqueBackgroundColor:* = undefined;

        if (down && downColor !== undefined)
        {
            backgroundColor = downColor;
            backgroundAlpha = downAlpha;
        }
        else if (selected)
        {
            backgroundColor = getStyle("selectionColor");
            backgroundAlpha = downAlpha;
        }
        else if (hovered)
        {
            backgroundColor = getStyle("rollOverColor");
            backgroundAlpha = downAlpha;
        }
        else if (showsCaret)
        {
            backgroundColor = getStyle("selectionColor");
            backgroundAlpha = downAlpha;
        }
        else
        {
            // don't draw background if it is the contentBackgroundColor. The
            // list skin handles the background drawing for us. 
            drawBackground = false;
            backgroundAlpha = 0;
        }

        // draw backgroundColor
        // the reason why we draw it in the case of drawBackground == 0 is for
        // mouse hit testing purposes
        graphics.beginFill(backgroundColor, backgroundAlpha);
        graphics.lineStyle();
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();

        // Draw the separator for the item renderer
        drawBorder(unscaledWidth, unscaledHeight);

        if (drawBackground && backgroundAlpha == 1)
        {
            // If our background is a solid color, use it as the opaqueBackground property
            // for this renderer. This makes scrolling considerably faster.
            opaqueBackgroundColor = backgroundColor;
        }
    }

}
}
