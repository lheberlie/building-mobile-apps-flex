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

package com.esri.mobile.events
{

import com.esri.ags.Graphic;
import com.esri.mobile.managers.supportClasses.InfoWindowData;

import flash.events.Event;

import mx.collections.IList;


public class ApplicationEvent extends Event
{

	//--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    public static const LOAD:String = "load";
    
    public static const FEATURE_SELECTED:String = "featureSelected";
    
	//--------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------
    
    
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor. 
     *  
     */
	public function ApplicationEvent(type:String, infoWindowDataProvider:IList = null, selectedInfoWindowData:InfoWindowData = null)
	{
	    super(type);
        m_infoWindowDataProvider = infoWindowDataProvider;
        m_selectedInfoWindowData = selectedInfoWindowData;
	}
	
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  infoWindowDataProvider
    //----------------------------------
    
    private var m_infoWindowDataProvider:IList;
    
    public function get infoWindowDataProvider():IList
    {
        return m_infoWindowDataProvider;
    }
    
    //----------------------------------
    //  selectedInfoWindowData
    //----------------------------------
    
    private var m_selectedInfoWindowData:InfoWindowData;

    public function get selectedInfoWindowData():InfoWindowData
    {
        return m_selectedInfoWindowData;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    override public function clone():Event
    {
        return new ApplicationEvent(type, infoWindowDataProvider, selectedInfoWindowData);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------
    
    
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    
    
    
}
}