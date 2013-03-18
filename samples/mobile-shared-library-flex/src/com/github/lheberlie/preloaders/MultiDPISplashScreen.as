///////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008-2013 Esri. All Rights Reserved.
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
package com.github.lheberlie.preloaders
{

import flash.display.StageAspectRatio;
import flash.system.Capabilities;

import mx.core.mx_internal;

import spark.preloaders.SplashScreen;

use namespace mx_internal;

/**
 *
 * @author lheberlie
 *
 */
public class MultiDPISplashScreen extends SplashScreen
{
    [Embed(source="assets/splashscreens/Default.png")]
    private var Default:Class;

    [Embed(source="assets/splashscreens/Default@2x.png")]
    private var Default_2x:Class;

    [Embed(source="assets/splashscreens/Default-568h@2x.png")]
    private var Default_568_2x:Class;

    [Embed(source="assets/splashscreens/Default-Portrait.png")]
    private var Default_Portrait:Class;

    [Embed(source="assets/splashscreens/Default-Landscape.png")]
    private var Default_Landscape:Class;

    [Embed(source="assets/splashscreens/Default-Portrait@2x.png")]
    private var Default_Portrait_2x:Class;

    [Embed(source="assets/splashscreens/Default-Landscape@2x.png")]
    private var Default_Landscape_2x:Class;


    /**
     *
     *
     */
    public function MultiDPISplashScreen()
    {
        super();
    }

    /**
     *
     * @param aspectRatio
     * @param dpi
     * @param resolution
     * @return
     *
     */
    mx_internal override function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class
    {
        /*
         * iPad simulator:
         * orientation:landscape, dpi:160, res:500, diagonal:14, w:768, h:1024
         * orientation:portrait, dpi:160, res:1004, diagonal:14, w:768, h:1024
        */
        /*
         * iPad (Retina) simulator:
         * orientation:landscape, dpi:240, res:1000, diagonal:14, w:1536, h:2048
         * orientation:portrait, dpi:240, res:2008, diagonal:14, w:1536, h:2048
        */

        /*
         * iPhone simulator
         * orientation:landscape, dpi:160, res:500, diagonal:7, w:320, h:480
         * orientation:portrait, dpi:160, res:460, diagonal:7, w:320, h:480
         */

        /*
        * iPhone (Retina 3.5 inch) simulator
        * orientation:landscape, dpi:320, res:1000, diagonal:7, w:640, h:960
        * orientation:portrait, dpi:320, res:920, diagonal:7, w:640, h:960
        */
        /*
        * iPhone (Retina 4 inch) simulator
        * orientation:landscape, dpi:320, res:1000, diagonal:6, w:640, h:1136
        * orientation:portrait, dpi:320, res:1096, diagonal:6, w:640, h:1136
        */

        /*
        iPhone, iPod
        Default (320x480)
        Default@2x (640x960)

        iPhone, iPod (5th generation)
        Default-568h@2x(640x1136)

        iPad
        Default-Portrait (768x1004)
        Default-Landscape (1024x748)

        Default-Portrait@2x (1536x2008)
        Default-Landscape@2x (2048 x 1496)
        */
        var isTablet:Boolean = (screenDiagonalInches() > 7 ? true : false);

        trace("orientation:" + aspectRatio + ", dpi:" + dpi + ", res:" + resolution + ", diagonal:" + screenDiagonalInches() + ", w:" + Capabilities.screenResolutionX + ", h:" + Capabilities.screenResolutionY + ", os:" + Capabilities.os);

        if (isTablet)
        {
            if (aspectRatio == StageAspectRatio.PORTRAIT)
            {
                trace("Tablet:Portrait");
                switch (dpi)
                {
                    case 320:
                    {

                        break;
                    }
                    case 240:
                    {
                        return Default_Portrait_2x;
                        break;
                    }
                    case 160:
                    {
                        return Default_Portrait;
                        break;
                    }
                }
            }
            else
            {
                trace("Tablet:Landscape");
                //landscape
                switch (dpi)
                {
                    case 320:
                    {

                        break;
                    }
                    case 240:
                    {
                        return Default_Landscape_2x;
                        break;
                    }
                    case 160:
                    {
                        return Default_Landscape;
                        break;
                    }
                }
            }
        }
        else
        {
            //phone
            if (aspectRatio == StageAspectRatio.PORTRAIT && resolution > 920)
            {
                trace("Phone:Portrait");
                switch (dpi)
                {
                    case 320:
                    {
                        return Default_568_2x;
                        break;
                    }
                    case 240:
                    {

                        break;
                    }
                    case 160:
                    {

                        break;
                    }
                }
            }
            else if (aspectRatio == StageAspectRatio.PORTRAIT)
            {
                trace("Phone:Portrait");
                switch (dpi)
                {
                    case 320:
                    {
                        return Default_2x;
                        break;
                    }
                    case 240:
                    {

                        break;
                    }
                    case 160:
                    {
                        return Default;
                        break;
                    }
                }
            }
            else
            {
                trace("Phone:Landscape");
                //landscape
                switch (dpi)
                {
                    case 320:
                    {
                        return Default_2x;
                        break;
                    }
                    case 240:
                    {

                        break;
                    }
                    case 160:
                    {
                        return Default;
                        break;
                    }
                }
            }
        }

        return Default;
    }

    /**
     * Returns the width of the screen in inches.
     **/
    private function screenWidthInches():Number
    {
        return Capabilities.screenResolutionX / Capabilities.screenDPI;
    }

    /**
     * Returns the height of the screen in inches.
     **/
    private function screenHeightInches():Number
    {
        return Capabilities.screenResolutionY / Capabilities.screenDPI;
    }

    /**
     * Returns the diagonal screen size in inches.
     **/
    private function screenDiagonalInches():Number
    {
        return (screenWidthInches() ^ 2 + screenHeightInches() ^ 2) ^ 0.5;
    }
}
}
