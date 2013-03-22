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

import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import flash.display.DisplayObject;

import mx.core.DPIClassification;

import spark.components.Button;

public class HSliderTrackSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
{

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    [Embed(source="../mobile160/assets/scrubber_primary_holo_light.png")]
    private static const hslidertrackskin_primary_160:Class;
    
    [Embed(source="../mobile160/assets/scrubber_track_holo_light.png")]
    private static const hslidertrackskin_track_160:Class;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function HSliderTrackSkin()
    {
        super();
        
        // set the right assets and dimensions to use based on the screen density
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification
                
                measuredDefaultWidth = 600;
                measuredDefaultHeight = 18;
                
                visibleTrackOffset = 20;
                
                trackClass = spark.skins.mobile320.assets.HSliderTrack;
                */
                
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification
                
                measuredDefaultWidth = 440;
                measuredDefaultHeight = 13;
                
                visibleTrackOffset = 16;
                
                trackClass = spark.skins.mobile240.assets.HSliderTrack;
                */
                
                break;
            }
            default:
            {
                // default DPI_160
                measuredDefaultWidth = 300;
                measuredDefaultHeight = 12;
                
                visibleTrackOffset = 16;
                
                trackClass = hslidertrackskin_track_160;
                primaryClass = hslidertrackskin_primary_160;
                
                break;
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /** 
     * @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:Button;
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Specifies the FXG class to use for the track image.
     */
    protected var trackClass:Class;
    
    /**
     *  Specifies the DisplayObject for the track image.
     */
    protected var trackSkin:DisplayObject;

    /**
     *  Specifies the FXG class to use for the primary image.
     */
    protected var primaryClass:Class;
    
    /**
     *  Specifies the DisplayObject for the primary image.
     */
    protected var primarySkin:DisplayObject;
    
    /**
     *  Specifies the offset from the left and right edge to where
     *  the visible track begins. This should match the offset in the FXG assets.
     */
    protected var visibleTrackOffset:int;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */ 
    override protected function createChildren():void
    {
        trackSkin = new trackClass();
        addChild(trackSkin);
        
        primarySkin = new primaryClass();
        addChild(primarySkin);
    }
    
    /**
     *  @private 
     */ 
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        setElementPosition(trackSkin, visibleTrackOffset, 0);
        setElementSize(trackSkin, unscaledWidth - 2 * visibleTrackOffset, unscaledHeight);

        var thumb:Button = hostComponent.owner.hasOwnProperty("thumb") ? hostComponent.owner["thumb"] as Button : null;
        if (thumb)
        {
            var primarySkinWidth:int = thumb.x;
            if (primarySkinWidth < 0)
            {
                primarySkin.visible = false;
            }
            else
            {
                primarySkin.visible = true;
                setElementPosition(primarySkin, visibleTrackOffset, 0);
                setElementSize(primarySkin, primarySkinWidth, unscaledHeight);
            }
        }
        else
        {
            primarySkin.visible = false;
        }
    }

}
}
