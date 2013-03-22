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
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.collections.IList;
import mx.core.FlexGlobals;
import mx.core.IFactory;
import mx.managers.IFocusManagerComponent;

import spark.components.Application;
import spark.components.CalloutButton;
import spark.components.List;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.DropDownEvent;
import spark.events.IndexChangeEvent;

[DefaultProperty("dataProvider")]

public class DropDownList extends SkinnableComponent implements IFocusManagerComponent
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
    public function DropDownList()
    {
        super();
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    [SkinPart(required="true")]
    public var calloutButton:CalloutButton;

    [SkinPart(required="true")]
    public var list:List;
    
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var m_backKeyWasPressed:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  dataProvider
    //----------------------------------

    private var m_dataProvider:IList;

    private var m_listDataProvider:ArrayCollection;

    private var m_dataProviderChanged:Boolean;

    [Bindable("dataProviderChanged")]

    public function get dataProvider():IList
    {
        return m_dataProvider
    }

    public function set dataProvider(value:IList):void
    {
        if (m_dataProvider != value)
        {
            if (m_dataProvider)
            {
                // TODO ycabon: remove listeners on COLLECTION_CHANGE
            }
            m_dataProvider = value;
            if (m_dataProvider)
            {
                // TODO ycabon: add listeners on COLLECTION_CHANGE
            }

            m_dataProviderChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("dataProviderChanged"));
        }
    }
    
    //----------------------------------
    //  labelField
    //----------------------------------
    
    private var m_labelField:String;
    
    public function get labelField():String
    {
        return (list)
        ? list.labelField
            : m_labelField;
    }
    
    public function set labelField(value:String):void
    {
        m_labelField = value;
        if (list)
        {
            list.labelField = value;
        }
    }
    
    //----------------------------------
    //  typicalItem
    //----------------------------------
    
    private var m_typicalItem:Object;
    
    public function get typicalItem():Object
    {
        return (list)
        ? list.typicalItem
            : m_typicalItem;
    }
    
    public function set typicalItem(value:Object):void
    {
        m_typicalItem = value;
        if (list)
        {
            list.typicalItem = value;
        }
    }


    //----------------------------------
    //  itemRenderer
    //----------------------------------

    private var m_itemRenderer:IFactory;

    public function get itemRenderer():IFactory
    {
        return (list)
            ? list.itemRenderer
            : m_itemRenderer;
    }

    /**
     *  @private
     */
    public function set itemRenderer(value:IFactory):void
    {
        if (list)
        {
            list.itemRenderer = value;
        }
        else
        {
            m_itemRenderer = value;
        }
    }

    //----------------------------------
    //  selectedItem
    //----------------------------------

    private var m_selectedItem:*;

    private var m_selectedItemChanged:Boolean;

    public function get selectedItem():*
    {
        return m_selectedItem;
    }

    /**
     *  @private
     */
    public function set selectedItem(value:*):void
    {
        if (m_selectedItem != value)
        {
            m_selectedItem = value;
            m_selectedItemChanged = true;
            invalidateProperties();
        }
    }

    //----------------------------------
    //  requireSelection
    //----------------------------------

    private var m_requireSelection:Boolean = false;
    private var m_requireSelectionChanged:Boolean = false;

    [Inspectable(category="General", defaultValue="false")]

    public function get requireSelection():Boolean
    {
        return m_requireSelection;
    }

    /**
     *  @private
     */
    public function set requireSelection(value:Boolean):void
    {
        if (value != m_requireSelection)
        {
            m_requireSelection = value;
            m_requireSelectionChanged = true;
            invalidateProperties();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);

        if (instance == list)
        {
            if (m_listDataProvider)
            {
                list.dataProvider = m_listDataProvider;
            }
            if (m_itemRenderer)
            {
                list.itemRenderer = m_itemRenderer;
            }
            if (m_labelField)
            {
                list.labelField = m_labelField;
            }
            if (m_typicalItem)
            {
                list.typicalItem = m_typicalItem;
            }
            list.addEventListener(IndexChangeEvent.CHANGE, indexChangeEventHandler);
        }
        else if (instance == calloutButton)
        {
            calloutButton.addEventListener(DropDownEvent.OPEN, dropDownOpenHandler);
            if (list)
            {
                if (selectedItem)
                {
                    calloutButton.label = list.itemToLabel(selectedItem);
                }
            }
        }
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (m_requireSelectionChanged)
        {
            m_requireSelectionChanged = false;
            if (!m_selectedItem && m_dataProvider && m_dataProvider.length > 0)
            {
                m_selectedItem = m_dataProvider.getItemAt(0);
                m_selectedItemChanged = true;
            }
        }

        if (m_dataProviderChanged)
        {
            if (m_dataProvider)
            {
                m_listDataProvider = new ArrayCollection(m_dataProvider.toArray());
                m_listDataProvider.filterFunction = function(item:Object):Boolean
                {
                    if (item == selectedItem)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                };
                m_listDataProvider.refresh();
            }
            else
            {
                m_listDataProvider = null;
            }

            if (list)
            {
                list.dataProvider = m_listDataProvider;
            }

            if (calloutButton && calloutButton.iconDisplay)
            {
                calloutButton.iconDisplay.visible = m_listDataProvider.length > 0;
            }
        }

        if (m_selectedItemChanged)
        {
            // We don't refresh the collection twice.
            if (!m_dataProviderChanged && m_listDataProvider)
            {
                m_listDataProvider.refresh();
            }

            if (calloutButton)
            {
                calloutButton.label = list.itemToLabel(selectedItem);
                if (calloutButton.iconDisplay)
                {
                    calloutButton.iconDisplay.visible = m_dataProvider.length > 0;
                }
            }
        }

        m_dataProviderChanged = false;
        m_selectedItemChanged = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handler
    //
    //--------------------------------------------------------------------------

    private function indexChangeEventHandler(event:IndexChangeEvent):void
    {
        if (!calloutButton.hasEventListener(DropDownEvent.CLOSE))
        {
            calloutButton.addEventListener(DropDownEvent.CLOSE, dropDownCloseHandler);
        }
        calloutButton.closeDropDown();
    }
    
    private function removedFromStageHandler(event:Event):void
    {
        systemManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, backKeyDownHandler);
        systemManager.stage.removeEventListener(KeyboardEvent.KEY_UP, backKeyUpHandler);
        calloutButton.removeEventListener(DropDownEvent.CLOSE, dropDownCloseHandler);
        calloutButton.closeDropDown();
    }

    private function dropDownCloseHandler(event:DropDownEvent):void
    {
        calloutButton.removeEventListener(DropDownEvent.CLOSE, dropDownCloseHandler);
        selectedItem = m_listDataProvider.getItemAt(list.selectedIndex);
    }
    
    private function dropDownOpenHandler(event:DropDownEvent):void
    {
        systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, backKeyDownHandler);
        systemManager.stage.addEventListener(KeyboardEvent.KEY_UP, backKeyUpHandler);
    }
    
    private function backKeyDownHandler(event:KeyboardEvent):void
    {
        if (event.keyCode == Keyboard.BACK)
        {
            m_backKeyWasPressed = true;
            event.preventDefault();
        }
    }
    
    private function backKeyUpHandler(event:KeyboardEvent):void
    {
        if (m_backKeyWasPressed && event.keyCode == Keyboard.BACK)
        {
            event.preventDefault();
            m_backKeyWasPressed = false;
            
            systemManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, backKeyDownHandler);
            systemManager.stage.removeEventListener(KeyboardEvent.KEY_UP, backKeyUpHandler);
            
            calloutButton.removeEventListener(DropDownEvent.CLOSE, dropDownCloseHandler);
            calloutButton.closeDropDown();
        }
    }
}
}
