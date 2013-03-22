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


public class GeocoderRemoveButtonSkin extends TransparentButtonSkin
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
    public function GeocoderRemoveButtonSkin()
    {
        super();
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                layoutPaddingLeft = 20;
                layoutPaddingRight = 20;
                layoutPaddingTop = 20;
                layoutPaddingBottom = 20;

                break;
            }
            case DPIClassification.DPI_240:
            {
                layoutPaddingLeft = 15;
                layoutPaddingRight = 15;
                layoutPaddingTop = 15;
                layoutPaddingBottom = 15;

                break;
            }
            default:
            {
                layoutPaddingTop = 1;
                layoutPaddingBottom = 1;
                layoutPaddingLeft = 1;
                layoutPaddingRight = 1;
                measuredDefaultWidth = 34;
                measuredDefaultHeight = 34;

                break;
            }
        }
    }



}
}
