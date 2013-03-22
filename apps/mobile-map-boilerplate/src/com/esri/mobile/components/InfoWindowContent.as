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

import com.esri.mobile.components.supportClasses.MenuItem;
import com.esri.mobile.utils.IconUtil;

import flash.events.MouseEvent;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.IList;
import mx.core.DPIClassification;
import mx.core.FlexGlobals;
import mx.core.IFactory;
import mx.core.UIComponent;

import spark.components.Button;
import spark.components.CalloutButton;
import spark.components.CalloutPosition;
import spark.components.Group;
import spark.components.IItemRenderer;
import spark.components.List;
import spark.events.IndexChangeEvent;
import spark.layouts.HorizontalAlign;
import spark.layouts.HorizontalLayout;

//--------------------------------------
//  Events
//--------------------------------------

[Event(name="change", type="spark.events.IndexChangeEvent")]

[Event(name="changing", type="spark.events.IndexChangeEvent")]

/**
 * Chromeless component containing a list of features.
 *
 */
public class InfoWindowContent extends UIComponent
{
    
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
    private static const OVERFLOW_THRESHOLD:uint = 5;


    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function InfoWindowContent()
    {
        super();
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification

                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification

                */

                break;
            }
            default:
            {
                // default DPI_160
                layoutGap = 8;
                separatorSize = 1;

                break;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    public var list:List;

    public var actionGroup:Group;
    
    private var m_actionItemsMap:Dictionary;
    
    private var m_actionButtonsMap:Dictionary;
    
    private var m_overflowButton:CalloutButton;
    
    private var m_overflowList:List;
    
    private var m_overflowActionItems:ArrayCollection;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  applicationDPI
    //----------------------------------

    /**
     *  @copy spark.skins.mobile.supportClasses.MobileSkin#applicationDPI
     */
    protected function get applicationDPI():Number
    {
        return FlexGlobals.topLevelApplication.applicationDPI;
    }

    //----------------------------------
    //  layoutGap
    //----------------------------------

    protected var layoutGap:int;

    //----------------------------------
    //  separatorSize
    //----------------------------------

    protected var separatorSize:uint;

    //----------------------------------
    //  actionContent
    //----------------------------------

    protected var actionContent:Array;

    //----------------------------------
    //  dataProvider
    //----------------------------------

    private var m_dataProvider:IList;

    public function get dataProvider():IList
    {
        return list ? list.dataProvider : m_dataProvider;
    }

    public function set dataProvider(value:IList):void
    {
        m_dataProvider = value;
        if (list)
        {
            list.dataProvider = m_dataProvider;
        }
    }

    //----------------------------------
    //  itemRenderer
    //----------------------------------

    private var m_itemRenderer:IFactory;

    public function get itemRenderer():IFactory
    {
        return list ? list.itemRenderer : m_itemRenderer;
    }

    public function set itemRenderer(value:IFactory):void
    {
        m_itemRenderer = value;
        if (list)
        {
            list.itemRenderer = m_itemRenderer;
        }
    }

    //----------------------------------
    //  menuItems
    //----------------------------------

    private var m_menuItems:Array;
    private var m_menuItemsChanged:Boolean = false;

    [ArrayElementType("com.esri.mobile.components.supportClasses.MenuItem")]

    /**
     * @copy com.esri.mobile.components.View#menuItems
     */
    public function get menuItems():Array
    {
        return m_menuItems;
    }

    /**
     *  @private
     */
    public function set menuItems(value:Array):void
    {
        m_menuItems = value;
        m_menuItemsChanged = true;

        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (!list)
        {
            list = new HorizontalPagingList();
            list.id = "list";
            list.dataProvider = m_dataProvider;
            list.itemRenderer = m_itemRenderer;
            list.addEventListener(IndexChangeEvent.CHANGE, eventRedispatcher);
            list.addEventListener(IndexChangeEvent.CHANGING, eventRedispatcher);
            addChild(list);
        }

        if (!actionGroup)
        {
            actionGroup = new Group();
            actionGroup.id = "actionGroup";
            actionGroup.minWidth = actionGroup.minHeight = 0;
            var layout:HorizontalLayout = new HorizontalLayout();
            layout.horizontalAlign = HorizontalAlign.RIGHT;
            actionGroup.layout = layout;
            addChild(actionGroup);
        }
        
        if (!m_overflowButton)
        {
            m_overflowButton = new CalloutButton();
            m_overflowButton.id = "overflow";
            m_overflowButton.styleName = "overflow";
            m_overflowButton.horizontalPosition = CalloutPosition.END;
            m_overflowList = new List();
            m_overflowList.percentHeight = 100;
            m_overflowList.addEventListener(IndexChangeEvent.CHANGING, overflowListIndexChangingHandler);
            m_overflowActionItems = new ArrayCollection();
            m_overflowActionItems.filterFunction = function(item:MenuItem):Boolean {return item.visible};
            m_overflowList.dataProvider = m_overflowActionItems;
            m_overflowButton.calloutContent = [
                m_overflowList
            ];
        }
    }

    /**
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (m_menuItemsChanged)
        {
            m_menuItemsChanged = false;

            // Remove the previous buttons
            var actionContent:Array;
            var numItems:int;
            var actionItemButton:Button;
            var actionItem:MenuItem;
            var items:Array;
            var i:int;

            // Remove the previous actionContent
            actionContent = this.actionContent;
            if (actionContent)
            {
                numItems = actionContent.length;
                for (i = 0; i < numItems; i++)
                {
                    actionItemButton = actionContent[i] as Button;
                    if (actionItemButton)
                    {
                        actionItemButton.removeEventListener(MouseEvent.CLICK, actionItemClickHandler);
                    }
                }
            }

            actionContent = null;
            m_actionItemsMap = null;
            m_actionButtonsMap = null;

            // Add the new actionContent based on the ActionItems
            if (m_menuItems && m_menuItems.length > 0)
            {
                actionContent = [];
                m_actionItemsMap = new Dictionary(true);
                m_actionButtonsMap = new Dictionary(true);
                var isOverflow:Boolean = m_menuItems.length > OVERFLOW_THRESHOLD;

                // If more than 5 ActionItems, display "OVERFLOW_THRESHOLD - 1" of them then put the rest in overflow.
                numItems = isOverflow ? OVERFLOW_THRESHOLD - 1 : m_menuItems.length;
                for (i = 0; i < numItems; i++)
                {
                    actionItem = m_menuItems[i] as MenuItem;
                    actionItemButton = new Button();
                    actionItemButton.id = actionItem.uid;
                    if (actionItem.icon)
                    {
                        actionItemButton.setStyle("icon", IconUtil.getIconPath(actionItem.icon));
                    }
                    else if (actionItem.label)
                    {
                        actionItemButton.label = actionItem.label;
                    }
                    else
                    {
                        actionItemButton.label = "_";
                    }
                    actionItemButton.addEventListener(MouseEvent.CLICK, actionItemClickHandler);

                    actionContent[i] = actionItemButton;
                    m_actionItemsMap[actionItem.uid] = actionItem;
                    m_actionButtonsMap[actionItem.uid] = actionItemButton;
                }

                if (isOverflow)
                {
                    items = m_menuItems.slice(OVERFLOW_THRESHOLD - 1);
                    m_overflowActionItems.removeAll();
                    m_overflowActionItems.source = items;
                    actionContent[OVERFLOW_THRESHOLD - 1] = m_overflowButton;
                }
            }

            this.actionContent = actionContent;
            if (actionGroup)
            {
                actionGroup.mxmlContent = this.actionContent;
            }
        }
    }

    /**
     * @private
     */
    override protected function measure():void
    {
        super.measure();

        if (actionGroup.numChildren)
        {
            measuredWidth = Math.max(actionGroup.getPreferredBoundsWidth(), list.getPreferredBoundsWidth());
            measuredHeight = actionGroup.getPreferredBoundsHeight() + list.getPreferredBoundsHeight() + 2 * separatorSize;
        }
        else
        {
            measuredWidth = list.getPreferredBoundsWidth();
            measuredHeight = list.getPreferredBoundsHeight();
        }
    }

    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        graphics.clear();

        var listY:Number = 0;

        if (actionGroup.numChildren)
        {
            var actionBarHeight:Number = actionGroup.getPreferredBoundsHeight();
            listY = actionBarHeight + 2 * separatorSize;
            actionGroup.setLayoutBoundsPosition(0, 0);
            actionGroup.setLayoutBoundsSize(unscaledWidth, actionBarHeight);

            graphics.beginFill(getStyle("chromeColor"));
            graphics.drawRect(0, actionBarHeight, unscaledWidth, separatorSize);
            graphics.endFill();
            graphics.beginFill(0xFFFFFF, 0.5);
            graphics.drawRect(0, actionBarHeight + separatorSize, unscaledWidth, separatorSize);
            graphics.endFill();
        }
        list.move(0, listY);
        list.setActualSize(unscaledWidth, unscaledHeight - listY);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    private function eventRedispatcher(event:IndexChangeEvent):void
    {
        dispatchEvent(event);
    }
    
    private function actionItemClickHandler(event:MouseEvent):void
    {
        var actionItemButton:Button = event.currentTarget as Button;
        var actionItem:MenuItem = m_actionItemsMap[actionItemButton.id];
        
        actionItem.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false));
        if (actionItem.actionViewClass)
        {
            actionItem.expandActionView();
        }
    }
    
    private function overflowListIndexChangingHandler(event:IndexChangeEvent):void
    {
        // Prevent the selection
        event.preventDefault();
        var actionItem:MenuItem = m_menuItems[OVERFLOW_THRESHOLD - 1 + event.newIndex];
        
        actionItem.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false));
    }

}
}
