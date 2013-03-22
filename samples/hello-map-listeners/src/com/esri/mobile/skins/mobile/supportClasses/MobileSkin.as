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

package com.esri.mobile.skins.mobile.supportClasses
{

import com.esri.mobile.utils.DeviceUtil;

import mx.core.DPIClassification;

import spark.skins.mobile.supportClasses.MobileSkin;


public class MobileSkin extends spark.skins.mobile.supportClasses.MobileSkin
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
    public function MobileSkin()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO
                layoutGap = 8;
                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO
                layoutGap = 8;
                */
                break;
            }
            default:
            {
                layoutGap = 8;
                break;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  layoutGap
    //----------------------------------

    /**
     *  TODO
     */
    protected var layoutGap:int;

    //----------------------------------
    //  aspectRatio
    //----------------------------------

    /**
     *  Returns the aspect ratio of the application.
     *
     */
    protected function get aspectRatio():String
    {
        return DeviceUtil.aspectRatio;
    }

    //----------------------------------
    //  isPortrait
    //----------------------------------

    protected function get isPortrait():Boolean
    {
        return DeviceUtil.isPortrait;
    }

    //----------------------------------
    //  isLandscape
    //----------------------------------

    protected function get isLandscape():Boolean
    {
        return DeviceUtil.isLandscape;
    }

    //----------------------------------
    //  isTablet
    //----------------------------------

    protected function get isPhone():Boolean
    {
        return DeviceUtil.isPhone;
    }

    //----------------------------------
    //  isTablet
    //----------------------------------

    protected function get isTablet():Boolean
    {
        return DeviceUtil.isTablet;
    }

}
}
