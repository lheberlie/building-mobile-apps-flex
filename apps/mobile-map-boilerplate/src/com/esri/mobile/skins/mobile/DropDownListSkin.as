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

import com.esri.mobile.components.DropDownList;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import mx.core.ClassFactory;
import mx.core.mx_internal;

import spark.components.Callout;
import spark.components.CalloutButton;
import spark.components.List;

use namespace mx_internal;

public class DropDownListSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
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
    public function DropDownListSkin()
    {
        super();
    }
    

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var calloutButton:CalloutButton;
    
    public var list:List;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  hostComponent
    //----------------------------------

    public var hostComponent:DropDownList;
    

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void    
    {
        super.createChildren();
        
        list = new List();
        list.id = "list";
        list.percentHeight = 100;

        calloutButton = new CalloutButton();
        calloutButton.id = "calloutButton";
        calloutButton.calloutContent = [ list ];
        calloutButton.horizontalPosition = "start";
        
        var dropDown:ClassFactory = new ClassFactory(Callout);
        dropDown.properties = { styleName: "dropDownList" };
        calloutButton.dropDown = dropDown;
        
        addChild(calloutButton);
    }
    
    override protected function measure():void
    {
        super.measure();
        
        measuredMinWidth = measuredWidth = getElementPreferredWidth(calloutButton);
        measuredMinHeight = measuredHeight = getElementPreferredHeight(calloutButton);
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        setElementSize(calloutButton, unscaledWidth, unscaledHeight);
    }
}
}
