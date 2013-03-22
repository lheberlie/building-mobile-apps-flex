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

package com.esri.mobile.managers.supportClasses
{

import com.esri.ags.Graphic;

[Bindable]

public class InfoWindowData
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
    public function InfoWindowData()
    {
    }


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  graphic
    //----------------------------------

    public var graphic:Graphic;

    //----------------------------------
    //  labelField
    //----------------------------------

    public var labelField:String;
    
    //----------------------------------
    //  subLabelField
    //----------------------------------
    
    public var subLabelField:String;

    //----------------------------------
    //  iconSource
    //----------------------------------

    public var icon:Object;

    //----------------------------------
    //  formattedAttributes
    //----------------------------------

    public var formattedAttributes:Object;


    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    public function getAttribute(attributeName:String):*
    {
        if (formattedAttributes)
        {
            return formattedAttributes[attributeName];
        }
        else
        {
            return graphic.attributes[attributeName];
        }
    }

}
}
