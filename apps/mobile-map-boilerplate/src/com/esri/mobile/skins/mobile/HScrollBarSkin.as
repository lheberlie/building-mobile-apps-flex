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
import mx.core.mx_internal;

import spark.components.Button;
import spark.skins.mobile.HScrollBarSkin;
import spark.skins.mobile.HScrollBarThumbSkin;

use namespace mx_internal;

/**
 * Skin for the HScrollBar to add color support.
 */
public class HScrollBarSkin extends spark.skins.mobile.HScrollBarSkin
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */
    public function HScrollBarSkin()
    {
        // omit super
        super();
        
        minWidth = 20;
        thumbSkinClass = com.esri.mobile.skins.mobile.HScrollBarThumbSkin;
        
        // Depending on density set our measured height
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
                // default DPI_160
                minHeight = 3;
                break;
            }
        }
        
        minThumbWidth = minHeight;   
    }
    

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {        
        if (!thumb)
        {
            thumb = new Button();
            thumb.id = "thumb";
            thumb.minWidth = minThumbWidth;
            thumb.setStyle("skinClass", thumbSkinClass);
            thumb.width = minHeight;
            thumb.height = minHeight;
            addChild(thumb);
        }
        super.createChildren();
    }

}
}
