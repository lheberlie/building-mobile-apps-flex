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

import flash.display.DisplayObject;

import mx.core.DPIClassification;

import spark.skins.mobile.supportClasses.ButtonSkinBase;

public class ButtonSkinBase extends spark.skins.mobile.supportClasses.ButtonSkinBase
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
    public function ButtonSkinBase()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO
                
                upBorderSkin = android.skins.mobile320.assets.Button_up;
                downBorderSkin = android.skins.mobile320.assets.Button_down;

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
                
                upBorderSkin = android.skins.mobile240.assets.Button_up;
                downBorderSkin = android.skins.mobile240.assets.Button_down;

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

                layoutBorderSize = 10;
                layoutPaddingTop = 16;
                layoutPaddingBottom = 16;
                layoutPaddingLeft = layoutGap;
                layoutPaddingRight = layoutGap;
                measuredDefaultWidth = 96;
                measuredDefaultHeight = 48;

                break;
            }
        }
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var m_border:DisplayObject;
    
    private var m_borderChanged:Boolean = false;
    
    private var borderClass:Class;
    
    /**
     *  Read-only button border graphic. Use getBorderClassForCurrentState()
     *  to specify a graphic per-state.
     * 
     *  @see #getBorderClassForCurrentState()
     */
    protected function get border():DisplayObject
    {
        return m_border;
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Class to use for the border in the up state.
     * 
     *  @default button_up_160
     */  
    protected var upBorderSkin:Class;
    
    /**
     *  Class to use for the border in the down state.
     * 
     *  @default button_down_160
     */ 
    protected var downBorderSkin:Class;
    
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
        super.createChildren();
        
        setStyle("textAlign", "center");
    }
    
    /**
     *  @private 
     */
    override protected function commitCurrentState():void
    {   
        super.commitCurrentState();
        
        borderClass = getBorderClassForCurrentState();
        
        if (!(m_border is borderClass))
            m_borderChanged = true;
        
        // update borderClass and background
        invalidateDisplayList();
    }
    
    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);
        
        // size the background image
        if (m_borderChanged)
        {
            m_borderChanged = false;
            
            if (m_border)
            {
                removeChild(m_border);
                m_border = null;
            }
            
            if (borderClass)
            {
                m_border = new borderClass();
                addChildAt(m_border, 0);
            }
        }
        
        layoutBorder(unscaledWidth, unscaledHeight);
    }
    

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Returns the borderClass to use based on the currentState.
     */
    protected function getBorderClassForCurrentState():Class
    {
        if (currentState == "down") 
            return downBorderSkin;
        else
            return upBorderSkin;
    }
    
    /**
     *  Position the background of the skin. Override this function to re-position the background.
     */ 
    protected function layoutBorder(unscaledWidth:Number, unscaledHeight:Number):void
    {
        setElementSize(border, unscaledWidth, unscaledHeight);
        setElementPosition(border, 0, 0);
    }
}
}
