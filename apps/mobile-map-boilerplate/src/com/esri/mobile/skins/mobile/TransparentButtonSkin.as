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

import mx.core.DPIClassification;

import spark.skins.mobile.supportClasses.ButtonSkinBase;

public class TransparentButtonSkin extends spark.skins.mobile.supportClasses.ButtonSkinBase
{

    /**
     *  Constructor.
     *
     */
    public function TransparentButtonSkin()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO

                layoutGap = 10;
                layoutPaddingLeft = 20;
                layoutPaddingRight = 20;
                layoutPaddingTop = 20;
                layoutPaddingBottom = 20;
                layoutBorderSize = 2;
                measuredDefaultWidth = 64;
                measuredDefaultHeight = 86;

                */
                
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO

                layoutGap = 7;
                layoutPaddingLeft = 15;
                layoutPaddingRight = 15;
                layoutPaddingTop = 15;
                layoutPaddingBottom = 15;
                layoutBorderSize = 1;
                measuredDefaultWidth = 48;
                measuredDefaultHeight = 65;
                
                */

                break;
            }
            default:
            {
                // default DPI_160
                layoutGap = 8;
                
                layoutPaddingLeft = 8;
                layoutPaddingRight = 8;
                layoutPaddingTop = 8;
                layoutPaddingBottom = 8;
                
                measuredDefaultWidth = 56;
                measuredDefaultHeight = 48;
                minWidth = 56;
                minHeight = 48;

                break;
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */
    override protected function commitCurrentState():void
    {   
        super.commitCurrentState();
        
        // update borderClass and background
        invalidateDisplayList();
    }
    
    /**
     * @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // omit super.drawBackground() to drawRect instead
        // only draw chromeColor in down state (transparent hit zone otherwise)
        var isDown:Boolean = (currentState == "down");
        var chromeColor:uint = isDown ? getStyle("downColor") : 0;
        var chromeAlpha:Number = isDown ? getStyle("downAlpha") : 0;
        
        graphics.beginFill(chromeColor, chromeAlpha);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
    }
}
}
