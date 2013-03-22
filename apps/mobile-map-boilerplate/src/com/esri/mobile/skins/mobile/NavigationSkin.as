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

import com.esri.ags.components.Navigation;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import spark.components.Button;

public class NavigationSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
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
    public function NavigationSkin()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var zoomInButton:Button;

    public var zoomOutButton:Button;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:Navigation;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void
    {
        if (!zoomInButton)
        {
            zoomInButton = new Button();
            zoomInButton.id = "zoomInButton";
            addChild(zoomInButton);
        }

        if (!zoomOutButton)
        {
            zoomOutButton = new Button();
            zoomOutButton.id = "zoomOutButton";
            addChild(zoomOutButton);
        }
    }

    override protected function commitCurrentState():void
    {
        zoomInButton.enabled = zoomOutButton.enabled = currentState.lastIndexOf("disabled") == -1;
    }

    override protected function measure():void
    {
        measuredWidth = Math.max(getElementPreferredWidth(zoomInButton), getElementPreferredWidth(zoomInButton));
        measuredHeight = Math.max(getElementPreferredHeight(zoomInButton), getElementPreferredHeight(zoomInButton)) * 2;
        
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        var halfHeight:Number = unscaledHeight * 0.5;
        setElementSize(zoomInButton, unscaledWidth, halfHeight);
        setElementSize(zoomOutButton, unscaledWidth, halfHeight);
        setElementPosition(zoomOutButton, 0, halfHeight);
    }


}
}
