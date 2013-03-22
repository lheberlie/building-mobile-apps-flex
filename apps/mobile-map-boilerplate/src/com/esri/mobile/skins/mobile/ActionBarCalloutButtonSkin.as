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

import mx.core.ClassFactory;
import mx.core.IFactory;

import spark.components.Callout;
import spark.components.CalloutButton;


public class ActionBarCalloutButtonSkin extends TransparentButtonSkin
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
    public function ActionBarCalloutButtonSkin()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var dropDown:IFactory;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void
    {        
        var dropDown:ClassFactory = new ClassFactory(Callout);
        dropDown.properties = { styleName: "dropDownList" };
        this.dropDown = dropDown;
        
        super.createChildren();
    }

}
}
