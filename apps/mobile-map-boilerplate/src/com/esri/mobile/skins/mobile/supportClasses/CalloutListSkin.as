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

import com.esri.mobile.components.LabelItemRenderer;

import mx.core.ClassFactory;
import mx.managers.IFocusManagerComponent;

import spark.components.DataGroup;
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalLayout;
import spark.skins.mobile.ListSkin;

public class CalloutListSkin extends ListSkin implements IFocusManagerComponent
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
    public function CalloutListSkin()
    {
        super();
    }


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
        if (!dataGroup)
        {
            // Create data group layout
            // ycabon: Create the list layout to override the requestedMinRowCount
            // This will calculate the exact list height we need for the list inside the callout.
            var layout:VerticalLayout = new VerticalLayout();
            layout.requestedMinRowCount = 1;
            layout.horizontalAlign = HorizontalAlign.JUSTIFY;
            layout.gap = 0;

            // Create data group
            dataGroup = new DataGroup();
            dataGroup.layout = layout;
            dataGroup.itemRenderer = new ClassFactory(com.esri.mobile.components.LabelItemRenderer);
        }

        super.createChildren();
    }

}
}
