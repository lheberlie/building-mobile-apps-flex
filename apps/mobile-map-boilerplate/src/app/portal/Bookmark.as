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

package app.portal
{

import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Extent;
import com.esri.ags.utils.IJSONSupport;

[DefaultProperty("extent")]

/**
 * A saved geographic extent that allows end users to quickly navigate to a particular area of interest. 
 * 
 * @see http://resources.arcgis.com/en/help/arcgis-web-map-json/#/bookmark/02qt00000009000000/
 */
public class Bookmark implements IJSONSupport
{
    //--------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------

    public static function fromJSON(obj:Object):Bookmark
    {
        var bookmark:Bookmark;
        if (obj)
        {
            bookmark = new Bookmark();
            bookmark.name = obj.name;
            bookmark.extent = Extent.fromJSON(obj.extent);
        }
        return bookmark;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function Bookmark(name:String = null, extent:Extent = null)
    {
        this.name = name;
        this.extent = extent;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  extent
    //----------------------------------
    
    /**
     * An envelope object containing a spatial reference, a lower left coordinate, 
     * and an upper right coordinate defining the rectangular area of the bookmark.
     * The spatial reference is the same as that used in the basemap layers.
     * 
     * Documentation for the envelope is in the Geometry Objects topic of the ArcGIS REST API help.
     * 
     */
    public var extent:Extent;

    //----------------------------------
    //  name
    //----------------------------------

    /**
     * A string name for the bookmark.
     */
    public var name:String;


    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    public function toJSON(key:String = null):Object
    {
        return null;
    }

}
}
