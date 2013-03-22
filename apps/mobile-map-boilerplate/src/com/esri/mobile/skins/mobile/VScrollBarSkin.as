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

import spark.components.Button;
import spark.skins.mobile.VScrollBarSkin;

/**
 * Skin for the VScrollBar to add color support.
 */
public class VScrollBarSkin extends spark.skins.mobile.VScrollBarSkin
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function VScrollBarSkin()
    {
        super();
        thumbSkinClass = com.esri.mobile.skins.mobile.VScrollBarThumbSkin;
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
            thumb.minHeight = minThumbHeight;
            thumb.setStyle("skinClass", thumbSkinClass);
            thumb.width = minWidth;
            thumb.height = minWidth;
            addChild(thumb);
        }
        super.createChildren();
    }

}
}
