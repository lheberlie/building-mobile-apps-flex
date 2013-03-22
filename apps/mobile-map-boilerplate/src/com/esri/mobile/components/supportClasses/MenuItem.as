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

package com.esri.mobile.components.supportClasses
{

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.core.IFactory;
import mx.core.IMXMLObject;
import mx.utils.NameUtil;
import mx.core.UIComponent;

//--------------------------------------
//  Events
//--------------------------------------

[Event(name="click", type="flash.events.MouseEvent")]

[Event(name="propertyChange", type="mx.events.PropertyChangeEvent")]

[Event(name="expand", type="flash.events.Event")]

[Event(name="collapse", type="flash.events.Event")]

//--------------------------------------
//  Other Metadata
//--------------------------------------

[DefaultProperty("actionViewClass")]

/**
 *
 */
public class MenuItem extends EventDispatcher implements IMXMLObject
{

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     * @see http://developer.android.com/reference/android/view/MenuItem.html#SHOW_AS_ACTION_ALWAYS
     */
    public static const SHOW_AS_ACTION_ALWAYS:uint = 0x000002;
    public static const SHOW_AS_ACTION_COLLAPSE_ACTION_VIEW:uint = 0x000008;
    public static const SHOW_AS_ACTION_IF_ROOM:uint = 0x000001;
    public static const SHOW_AS_ACTION_NEVER:uint = 0x000000;
    public static const SHOW_AS_ACTION_WITH_TEXT:uint = 0x000004;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function MenuItem()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  uid
    //----------------------------------

    private var m_uid:String;

    /**
     * @private
     */
    public function get uid():String
    {
        if (!m_uid)
        {
            m_uid = NameUtil.createUniqueName(this);
        }
        return m_uid;
    }


    //----------------------------------
    //  id
    //----------------------------------

    public var id:String;

    //----------------------------------
    //  title
    //----------------------------------

    public var label:String;

    //----------------------------------
    //  icon
    //----------------------------------

    public var icon:Object;

    //----------------------------------
    //  data
    //----------------------------------

    public var data:Object;
    
    //----------------------------------
    //  showAsAction
    //----------------------------------
    
    public var showAsAction:uint;

    //----------------------------------
    //  actionViewClass
    //----------------------------------

    private var m_actionViewClass:IFactory;

    public function get actionViewClass():IFactory
    {
        return m_actionViewClass;
    }

    public function set actionViewClass(value:IFactory):void
    {
        if (m_actionViewClass !== value)
        {
            var collapsed:Boolean = collapseActionView();
            m_actionViewClass = value;
            if (collapsed)
            {
                expandActionView();
            }
        }
    }
    
    //----------------------------------
    //  visible
    //----------------------------------
    
    public var visible:Boolean = true;

    //--------------------------------------------------------------------------
    //
    //  Public functions
    //
    //--------------------------------------------------------------------------

    public function expandActionView():Boolean
    {
        var expanded:Boolean = false;
        if (actionViewClass)
        {
            if (hasEventListener("expand"))
            {
                expanded = dispatchEvent(new Event("expand"));
            }
        }
        else
        {
            trace("call expandActionView() failed.");
        }
        return expanded;
    }

    public function collapseActionView():Boolean
    {
        var collapsed:Boolean = false;
        if (actionViewClass)
        {
            if (hasEventListener("collapse"))
            {
                collapsed = dispatchEvent(new Event("collapse"));
            }
        }
        else
        {
            trace("call collapseActionView() failed.");
        }
        return collapsed;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function initialized(document:Object, id:String):void
    {
        this.id = id;
    }

}
}
