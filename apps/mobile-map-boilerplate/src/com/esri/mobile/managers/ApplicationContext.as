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

package com.esri.mobile.managers
{

import com.esri.ags.Map;
import com.esri.ags.esri_internal;
import com.esri.ags.events.PortalEvent;
import com.esri.ags.portal.Portal;
import com.esri.ags.portal.supportClasses.PortalItem;
import com.esri.ags.tasks.supportClasses.CallResponder;
import com.esri.mobile.events.ApplicationEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.IExternalizable;

import mx.collections.IList;
import mx.core.mx_internal;
import mx.rpc.events.ResultEvent;

import spark.components.IconItemRenderer;
import spark.core.ContentCache;

use namespace esri_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 * Fires when the context is loaded.
 *
 * @eventType com.esri.mobile.events.ApplicationEvent.LOAD
 */
[Event(name="load", type="com.esri.mobile.events.ApplicationEvent")]

[Event(name="featureSelected", type="com.esri.mobile.events.ApplicationEvent")]


//--------------------------------------
//  Other Metadata
//--------------------------------------

[DefaultProperty("map")]

/**
 * Application context class.
 * TODO doc
 */
public class ApplicationContext extends EventDispatcher implements IExternalizable /*, IMXMLObject*/
{
    
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    public static var contentCache:ContentCache;
    {
        contentCache = new ContentCache();
        contentCache.enableCaching = true;
        contentCache.maxCacheEntries = 100;
        IconItemRenderer.mx_internal::_imageCache = contentCache;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function ApplicationContext()
    {
        super();
        itemLoadResponder.addEventListener(ResultEvent.RESULT, itemLoadHandler);
        itemDataLoadResponder.addEventListener(ResultEvent.RESULT, itemDataLoadHandler);
        mapCreationResponder.addEventListener(ResultEvent.RESULT, mapCreationHandler);
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var itemLoadResponder:CallResponder = new CallResponder();

    private var itemDataLoadResponder:CallResponder = new CallResponder();

    private var mapCreationResponder:CallResponder = new CallResponder();

    private var item:PortalItem;

    private var itemData:Object;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  portal
    //----------------------------------
    
    [Bindable("load")]
    public var portal:Portal;

    //----------------------------------
    //  map
    //----------------------------------

    private var m_map:Map;

    [Bindable(event="mapCreate")]
    public function get map():Map
    {
        return m_map;
    }

    public function set map(value:Map):void
    {
        if( m_map !== value)
        {
            m_map = value;
            m_map.esri_internal::mapMouseClickTolerance = 6;
            dispatchEvent(new Event("mapCreate"));
        }
    }


    //----------------------------------
    //  navigator
    //----------------------------------

    [Bindable("mapCreate")]
    public var bookmarks:IList; /* of Bookmark */

    /*private var m_navigator:ViewNavigator;

    public function get navigator():ViewNavigator
    {
        return m_navigator;
    }

    public function set navigator(value:ViewNavigator):void
    {
        if (m_navigator !== value)
        {
            if (m_navigator)
            {
                m_navigator.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, navigatorElementAddHandler);
                m_navigator.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, navigatorElementRemoveHandler);
            }
            m_navigator = value;
            if (m_navigator)
            {
                if (m_navigator.activeView && m_navigator.activeView.hasOwnProperty("map"))
                {
                    m_navigator.activeView["map"] = map;
                }
                m_navigator.addEventListener(ElementExistenceEvent.ELEMENT_ADD, navigatorElementAddHandler);
                m_navigator.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, navigatorElementRemoveHandler);
            }
        }
    }

    private function navigatorElementAddHandler(event:ElementExistenceEvent):void
    {
        var view:View = event.element as View;
        if (view && view.hasOwnProperty("map"))
        {
            view["map"] = map;
        }
    }

    private function navigatorElementRemoveHandler(event:ElementExistenceEvent):void
    {
        var view:View = event.element as View;
        if (view && view.hasOwnProperty("map"))
        {
            view["map"] = null;
        }
    }*/

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    public function startUp():void
    {
        if (!portal)
        {
            portal = new Portal();
        }
        portal.load();
        portal.addEventListener(PortalEvent.LOAD, portalLoadHandler);
    }

    /*public function initialized(document:Object, id:String):void
    {

    }*/

    public function openWebMap(itemId:String):void
    {
        itemLoadResponder.token = portal.getItem(itemId);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: IExternalizable
    //
    //--------------------------------------------------------------------------

    public function writeExternal(output:IDataOutput):void
    {
        output.writeObject(portal);
    }

    public function readExternal(input:IDataInput):void
    {
        portal = input.readObject() as Portal;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function createDefaultPortalBasemap():void
    {
        var map:Map = new Map();
        var defaultBasemap:Object = portal.info.defaultBasemap;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function portalLoadHandler(event:PortalEvent):void
    {
        portal.removeEventListener(PortalEvent.LOAD, portalLoadHandler);
        dispatchEvent(new ApplicationEvent(ApplicationEvent.LOAD));
        //createDefaultPortalBasemap();
    }

    private function itemLoadHandler(event:ResultEvent):void
    {
        this.item = event.result as PortalItem;
        itemDataLoadResponder.token = this.item.getJSONData();
    }

    private function itemDataLoadHandler(event:ResultEvent):void
    {
        this.itemData = event.result;
    }

    private function mapCreationHandler(event:ResultEvent):void
    {

    }
}
}
