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

package com.esri.mobile.utils
{

import flash.events.Event;

import mx.core.FlexGlobals;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;
import mx.styles.StyleManager;

import spark.components.Application;

/**
 * Utility class to handle multiDPI image sources.
 */
public class IconUtil
{

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    public static var ICON_DIR_PREFIX:String = "assets/icons/";
    
    public static var ICON_DPI_PREFIXES:Array = [];
    {
        ICON_DPI_PREFIXES[160] = "mdpi/";
        ICON_DPI_PREFIXES[240] = "hdpi/";
        ICON_DPI_PREFIXES[320] = "xhdpi/";
    }

    
    //--------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Get an icon full file path from a <code>@xxxxx.xyz</code> format.
     *  The returned path is built with the <code>ICON_DIR_PREFIX</code> and <code>ICON_DIR_PREFIXES</code>.
     * 
     *  The chosen ICON_DIR_PREFIXES value depends on the applicationDPI.
     * 
     *  @param fileName TODO
     *  @return TODO
     */
    public static function getIconPath(fileName:Object):Object
    {
        var icon:Object;
        if (!fileName || !(fileName is String) || !(fileName as String).length)
        {
            icon = fileName;
        }
        else if ((fileName as String).charAt(0) == "@")
        {
            icon = ICON_DIR_PREFIX + ICON_DPI_PREFIXES[DeviceUtil.applicationDPI] + fileName.substr(1);
        }
        else if ((fileName as String).charAt(0) == ".")
        {
            var styleManager:IStyleManager2 = StyleManager.getStyleManager(null);
            if (styleManager)
            {
                var styleDeclaration:CSSStyleDeclaration = styleManager.getStyleDeclaration(fileName as String);
                if (styleDeclaration)
                {
                    icon = styleDeclaration.getStyle("icon");
                }
            }
        }
        return icon;
    }

}
}
