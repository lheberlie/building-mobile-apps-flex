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

import flash.display.DisplayObject;
import flash.events.FocusEvent;

import mx.core.DPIClassification;
import mx.core.mx_internal;

import spark.components.TextArea;
import spark.components.TextInput;
import spark.components.supportClasses.StyleableStageText;
import spark.components.supportClasses.StyleableTextField;

use namespace mx_internal;

public class StageTextAreaSkin extends com.esri.mobile.skins.mobile.StageTextSkinBase
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
    public function StageTextAreaSkin()
    {
        super();
        multiline = true;
        
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification

                measuredDefaultHeight = 66;
                
                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification
                
                measuredDefaultHeight = 50;

                */
                break;
            }
            default:
            {
                measuredDefaultHeight = 96;
                break;
            }
        }
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:TextArea;


    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();
        measureTextComponent(hostComponent);
    }

    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number,
                                               unscaledHeight:Number):void
    {
        // base class handles border position & size
        super.layoutContents(unscaledWidth, unscaledHeight);
        
        // position & size the text
        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingRight:Number = getStyle("paddingRight");
        var paddingTop:Number = getStyle("paddingTop");
        var paddingBottom:Number = getStyle("paddingBottom");
        
        var unscaledTextWidth:Number = Math.max(0, unscaledWidth - paddingLeft - paddingRight);
        var unscaledTextHeight:Number = Math.max(0, unscaledHeight - paddingTop - paddingBottom);
        
        if (textDisplay)
        {
            var verticalPosAdjustment:Number = 0;
            var heightAdjustment:Number = 0;
            /*
            if (Capabilities.version.indexOf("IOS") == 0)
            {
                verticalPosAdjustment = Math.min(iOSVerticalPaddingAdjustment, paddingTop);
                heightAdjustment = verticalPosAdjustment + Math.min(iOSVerticalPaddingAdjustment, paddingBottom);
            }*/
            
            textDisplay.commitStyles();
            setElementSize(textDisplay, unscaledTextWidth, unscaledTextHeight + heightAdjustment);
            setElementPosition(textDisplay, paddingLeft, paddingTop - verticalPosAdjustment);
        }
        
        if (promptDisplay)
        {
            if (promptDisplay is StyleableTextField)
                StyleableTextField(promptDisplay).commitStyles();
            
            setElementSize(promptDisplay, unscaledTextWidth, unscaledTextHeight);
            setElementPosition(promptDisplay, paddingLeft, paddingTop);
        }
    }

}
}
