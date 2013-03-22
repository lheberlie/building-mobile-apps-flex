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

import com.esri.mobile.skins.mobile.supportClasses.ButtonSkinBase;

import flash.display.DisplayObject;

import mx.core.DPIClassification;

public class ButtonSkin extends com.esri.mobile.skins.mobile.supportClasses.ButtonSkinBase
{

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    [Embed(source="../mobile160/assets/btn_default_normal_holo_light.png", scaleGridTop="6", scaleGridLeft="6", scaleGridBottom="25", scaleGridRight="20")]
    private static const button_up_160:Class;
    
    [Embed(source="../mobile160/assets/btn_default_pressed_holo_light.png", scaleGridTop="6", scaleGridLeft="6", scaleGridBottom="25", scaleGridRight="20")]
    private static const button_down_160:Class;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function ButtonSkin()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO
                
                upBorderSkin = android.skins.mobile320.assets.Button_up;
                downBorderSkin = android.skins.mobile320.assets.Button_down;

                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO
                
                upBorderSkin = android.skins.mobile240.assets.Button_up;
                downBorderSkin = android.skins.mobile240.assets.Button_down;

                */

                break;
            }
            default:
            {
                // default DPI_160
                upBorderSkin = button_up_160;
                downBorderSkin = button_down_160;

                break;
            }
        }
    }
}
}
