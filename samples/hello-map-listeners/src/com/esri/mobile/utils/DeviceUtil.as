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

package com.esri.mobile.utils
{

import flash.display.Stage;
import flash.events.Event;
import flash.system.Capabilities;

import mx.core.FlexGlobals;
import mx.events.ResizeEvent;

import spark.components.Application;


public class DeviceUtil
{

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    private static var IS_TABLET:Boolean = false;

    private static var DEVICE_SCREEN_WIDTH:int;

    private static var DEVICE_SCREEN_HEIGHT:int;

    private static var SCREEN_WIDTH:int;

    private static var SCREEN_HEIGHT:int;

    {
        staticInit();
    }

    private static function staticInit():void
    {
        const application:Application = FlexGlobals.topLevelApplication as Application;

        if (application.stage)
        {
            DEVICE_SCREEN_WIDTH = application.stage.stageWidth;
            DEVICE_SCREEN_HEIGHT = application.stage.stageHeight;
            const width:Number = DEVICE_SCREEN_WIDTH / application.runtimeDPI;
            const height:Number = DEVICE_SCREEN_HEIGHT / application.runtimeDPI;
            SCREEN_WIDTH = width * application.applicationDPI;
            SCREEN_HEIGHT = height * application.applicationDPI;
            IS_TABLET = (width >= 5 || height >= 5);
        }
        else
        {
            application.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void
            {
                DEVICE_SCREEN_WIDTH = application.stage.stageWidth;
                DEVICE_SCREEN_HEIGHT = application.stage.stageHeight;
                const width:Number = DEVICE_SCREEN_WIDTH / application.runtimeDPI;
                const height:Number = DEVICE_SCREEN_HEIGHT / application.runtimeDPI;
                SCREEN_WIDTH = width * application.applicationDPI;
                SCREEN_HEIGHT = height * application.applicationDPI;
                IS_TABLET = (width >= 5 || height >= 5);

                FlexGlobals.topLevelApplication.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE, false));
            });
        }
    }

    private static const LANDSCAPE:String = "landscape";

    private static const PORTRAIT:String = "portrait";


    //----------------------------------
    //  isAndroid
    //----------------------------------

    public static var isAndroid:Boolean = Capabilities.version.indexOf("AND") == 0;

    //----------------------------------
    //  isIOS
    //----------------------------------

    public static var isIOS:Boolean = Capabilities.version.indexOf("IOS") == 0;

    //----------------------------------
    //  aspectRatio
    //----------------------------------

    /**
     *  Returns the aspect ratio of the application.
     *
     */
    public static function get aspectRatio():String
    {
        return FlexGlobals.topLevelApplication.aspectRatio;
    }

    //----------------------------------
    //  applicationDPI
    //----------------------------------

    public static function get applicationDPI():Number
    {
        return FlexGlobals.topLevelApplication.applicationDPI;
    }

    //----------------------------------
    //  screenWidth
    //----------------------------------

    public static function get screenWidth():Number
    {
        return SCREEN_WIDTH;
    }

    //----------------------------------
    //  screenHeight
    //----------------------------------

    public static function get screenHeight():Number
    {
        return SCREEN_HEIGHT;
    }

    //----------------------------------
    //  deviceScreenWidth
    //----------------------------------

    public static function get deviceScreenWidth():Number
    {
        return DEVICE_SCREEN_WIDTH;
    }

    //----------------------------------
    //  deviceScreenWidth
    //----------------------------------

    public static function get deviceScreenHeight():Number
    {
        return DEVICE_SCREEN_HEIGHT;
    }

    //----------------------------------
    //  isPortrait
    //----------------------------------

    public static function get isPortrait():Boolean
    {
        return aspectRatio == PORTRAIT;
    }

    //----------------------------------
    //  isLandscape
    //----------------------------------

    public static function get isLandscape():Boolean
    {
        return aspectRatio == LANDSCAPE;
    }

    //----------------------------------
    //  isPhone
    //----------------------------------

    public static function get isPhone():Boolean
    {
        return !IS_TABLET;
    }

    //----------------------------------
    //  isTablet
    //----------------------------------

    public static function get isTablet():Boolean
    {
        return IS_TABLET;
    }

}
}
