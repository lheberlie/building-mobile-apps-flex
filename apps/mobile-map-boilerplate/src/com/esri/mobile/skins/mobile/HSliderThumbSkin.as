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

import spark.skins.mobile.HSliderThumbSkin;


public class HSliderThumbSkin extends spark.skins.mobile.HSliderThumbSkin
{
    
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    [Embed(source="../mobile160/assets/scrubber_control_normal_holo_light.png")]
    private static const hsliderthumb_normal_160:Class;
    
    [Embed(source="../mobile160/assets/scrubber_control_pressed_holo_light.png")]
    private static const hsliderthumb_pressed_160:Class;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function HSliderThumbSkin()
    {
        super();

        // set the right assets and dimensions to use based on the screen density
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification
                
                thumbImageWidth = 58;
                thumbImageHeight = 58;

                thumbNormalClass = spark.skins.mobile320.assets.HSliderThumb_normal;
                thumbPressedClass = spark.skins.mobile320.assets.HSliderThumb_pressed;

                hitZoneOffset = 10;
                hitZoneSideLength = 80;

                // chromeColor ellipse goes up to the thumb border
                chromeColorEllipseWidth = chromeColorEllipseHeight = 56;
                chromeColorEllipseX = 1;
                chromeColorEllipseY = 1;
                */
                
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification
                
                thumbImageWidth = 44;
                thumbImageHeight = 44;

                thumbNormalClass = spark.skins.mobile240.assets.HSliderThumb_normal;
                thumbPressedClass = spark.skins.mobile240.assets.HSliderThumb_pressed;

                hitZoneOffset = 10;
                hitZoneSideLength = 65;

                // chromeColor ellipse goes up to the thumb border
                chromeColorEllipseWidth = chromeColorEllipseHeight = 42;
                chromeColorEllipseX = chromeColorEllipseY = 1;
                */

                break;
            }
            default:
            {
                // default DPI_160
                thumbImageWidth = 32;
                thumbImageHeight = 32;

                thumbNormalClass = hsliderthumb_normal_160;
                thumbPressedClass = hsliderthumb_pressed_160;

                hitZoneOffset = 2;
                hitZoneSideLength = 28; // ycabon: thumbImageWidth - hitZoneOffset * 2

                // chromeColor ellipse goes up to the thumb border
                //chromeColorEllipseWidth = chromeColorEllipseHeight = 32;
                //chromeColorEllipseX = chromeColorEllipseY = 0;

                break;
            }

        }
    }
    
    /**
     * @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Do nothing here.
    }
    
    /**
     * @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Do nothing here.
    }

}
}
