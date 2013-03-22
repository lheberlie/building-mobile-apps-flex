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

import spark.skins.mobile.HScrollBarThumbSkin;

[Style(name="backgroundColor", inherit="no", type="uint")]
[Style(name="backgroundAlpha", inherit="no", type="Number")]

/**
 * Skin for the HScrollBarThumbSkin.
 * Add support of backgroundColor and backgroundAlpha to the original skin
 */
public class HScrollBarThumbSkin extends spark.skins.mobile.HScrollBarThumbSkin
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
    public function HScrollBarThumbSkin()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var backgroundAlpha:Number;

    private var backgroundColor:uint;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        if (!styleProp ||
            styleProp == "styleName")
        {
            backgroundColor = getStyle("backgroundColor");
            backgroundAlpha = getStyle("backgroundAlpha");
        }
        else if (styleProp == "backgroundColor")
        {
            backgroundColor = getStyle("backgroundColor");
        }
        else if (styleProp == "backgroundAlpha")
        {
            backgroundAlpha = getStyle("backgroundAlpha");
        }

        super.styleChanged(styleProp);
    }

    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Omit super
        // super.drawBackground(unscaledWidth, unscaledHeight);
        graphics.beginFill(backgroundColor, backgroundAlpha);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
    }

}
}
