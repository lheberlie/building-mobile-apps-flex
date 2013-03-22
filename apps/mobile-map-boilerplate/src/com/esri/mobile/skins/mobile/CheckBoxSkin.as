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

import spark.skins.mobile.supportClasses.SelectableButtonSkinBase;

/**
 * Holo light skin for the Checkbox
 */
public class CheckBoxSkin extends SelectableButtonSkinBase
{
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    [Embed(source="../mobile160/assets/btn_check_off_holo_light.png")]
    private static const checkbox_up_160:Class;
    
    [Embed(source="../mobile160/assets/btn_check_off_pressed_holo_light.png")]
    private static const checkbox_down_160:Class;
    
    [Embed(source="../mobile160/assets/btn_check_on_holo_light.png")]
    private static const checkbox_up_selected_160:Class;
    
    [Embed(source="../mobile160/assets/btn_check_on_pressed_holo_light.png")]
    private static const checkbox_down_selected_160:Class;
    
    private static const exclusions:Array = ["labelDisplay", "labelDisplayShadow"];
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function CheckBoxSkin()
    {
        super();
        
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification
                
                upIconClass = checkbox_up_320;
                upSelectedIconClass = checkbox_up_selected_320;
                downIconClass = checkbox_down_320;
                downSelectedIconClass = checkbox_down_selected_320;
                
                layoutGap = 8;
                minWidth = 48;
                minHeight = 48;
                */
                
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification
                
                upIconClass = checkbox_up_240;
                upSelectedIconClass = checkbox_up_selected_240;
                downIconClass = checkbox_down_240;
                downSelectedIconClass = checkbox_down_selected_240;
                
                layoutGap = 8;
                minWidth = 48;
                minHeight = 48;
                */
                
                break;
            }
            default:
            {
                // default DPI_160
                upIconClass = checkbox_up_160;
                upSelectedIconClass = checkbox_up_selected_160;
                downIconClass = checkbox_down_160;
                downSelectedIconClass = checkbox_down_selected_160;

                layoutGap = 8;
                minWidth = 48;
                minHeight = 48;
                
                break;
            }
        }
        
        layoutPaddingLeft = layoutGap;
        layoutPaddingRight = layoutGap;
        layoutPaddingTop = layoutGap;
        layoutPaddingBottom = layoutGap;
        layoutBorderSize = 0;
    }
    
}
}
