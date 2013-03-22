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

package com.esri.mobile.components
{

import flash.events.Event;

import mx.collections.IList;
import mx.events.FlexEvent;
import mx.events.TouchInteractionEvent;

import spark.components.List;

[Style(name="indicatorPosition", inherit="no", type="String", enumeration="top,bottom")]

[Event(name="pageChanged", type="flash.events.Event")]

public class HorizontalPagingList extends List
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
	public function HorizontalPagingList()
	{
	    super();
        pageScrollingEnabled = true;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dataProvider
    //----------------------------------
    
    /**
     * @private
     */
    override public function set dataProvider(value:IList):void
    {
        super.dataProvider = value;
        updatePageNumber(true);
    }
    
    //----------------------------------
    //  pageNumber
    //----------------------------------
    
    private var m_pageNumber:uint;
    
    [Bindable("pageChanged")]
    
    public function get pageNumber():uint
    {
        return m_pageNumber;
    }
    
    //----------------------------------
    //  numPages
    //----------------------------------
    
    private var m_numPages:uint;
    
    [Bindable("dataProviderChanged")]

    public function get numPages():uint
    {
        return dataProvider ? dataProvider.length : 0;
    }
    
    //----------------------------------
    //  visibleItem
    //----------------------------------
    
    public function get visibleItem():*
    {
        return dataProvider ? dataProvider.getItemAt(pageNumber -1) : null;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        if (instance == dataGroup)
        {
            // listen for changes to the list
            dataGroup.addEventListener(FlexEvent.UPDATE_COMPLETE, dataGroupUpdateComplete);   
        }
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
    
    /**
     * @private
     */
    private function updatePageNumber(forceEvent:Boolean = false):void
    {
        if (scroller)
        {
            var pos:Number = scroller.viewport.horizontalScrollPosition;
            var viewportSize:Number = scroller.viewport.width;
            var pageNumber:uint = Math.round(pos / viewportSize) +1;
            
            if (forceEvent || m_pageNumber != pageNumber)
            {
                m_pageNumber = pageNumber;
                dispatchEvent(new Event("pageChanged"));
                invalidateDisplayList();
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    private function dataGroupUpdateComplete(event:FlexEvent):void
    {
        updatePageNumber();
    }
    
}
}