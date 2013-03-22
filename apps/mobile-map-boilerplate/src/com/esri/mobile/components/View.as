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
import com.esri.mobile.managers.ApplicationContext;
import com.esri.mobile.utils.DeviceUtil;
import com.esri.mobile.utils.IconUtil;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;

import spark.components.Button;
import spark.components.CalloutButton;
import spark.components.CalloutPosition;
import spark.components.List;
import spark.components.SplitViewNavigator;
import spark.components.View;
import spark.components.ViewNavigator;
import spark.events.IndexChangeEvent;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------


/**
 *  Class or instance to use as the home button icon.
 *  The icon can render from various graphical sources, including the following:
 *  <ul>
 *   <li>A Bitmap or BitmapData instance.</li>
 *   <li>A class representing a subclass of DisplayObject. The BitmapFill
 *       instantiates the class and creates a bitmap rendering of it.</li>
 *   <li>An instance of a DisplayObject. The BitmapFill copies it into a
 *       Bitmap for filling.</li>
 *   <li>The name of an external image file. </li>
 *  </ul>
 *
 *  @default null
 *
 *  @see spark.primitives.BitmapImage.source
 */
[Style(name="icon", type="Object", inherit="no")]


//--------------------------------------
//  Other Metadata
//--------------------------------------

[Exclude(kind="property", name="navigationContent")]
[Exclude(kind="property", name="navigationLayout")]
[Exclude(kind="property", name="titleContent")]
[Exclude(kind="property", name="titleLayout")]

/**
 *
 */
public class View extends spark.components.View
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
    public function View()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        addEventListener(FlexEvent.BACK_KEY_PRESSED, backKeyHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var m_viewIcon:Button;

    private var m_actionItemsMap:Dictionary;

    private var m_actionButtonsMap:Dictionary;

    private var m_overflowButton:CalloutButton;

    private var m_overflowList:List;

    private var m_overflowActionItems:ArrayCollection;

    private var m_homeButton:Button;

    private var m_activeActionView:MenuItem;

    private var m_fakeViewDescriptorInNavigator:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  applicationContext
    //----------------------------------

    public function get applicationContext():ApplicationContext
    {
        if (navigator.parentNavigator.hasOwnProperty("applicationContext"))
        {
            return navigator.parentNavigator["applicationContext"] as ApplicationContext;
        }
        return null;
    }

    //----------------------------------
    //  menuItems
    //----------------------------------

    private var m_menuItems:Array;
    private var m_menuItemsChanged:Boolean = false;

    [Inspectable(arrayType="com.esri.mobile.components.supportClasses.MenuItem")]

    /**
     * TODO doc
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
    }

    //----------------------------------
    //  navigationContent
    //----------------------------------

    /**
     * @private
     */
    override public function get navigationContent():Array
    {
        // Check if a drawer is available in the application
        var hasSlidingMenu:Boolean = false;
        if (navigator.parentNavigator is ResponsiveViewNavigator)
        {
            var rvn:ResponsiveViewNavigator = navigator.parentNavigator as ResponsiveViewNavigator;
            hasSlidingMenu = rvn.hasSlidingMenu;
        }

        // the navigation content depends on the drawer or the num of views in the stack.
        m_homeButton.mouseEnabled = hasSlidingMenu || navigator.length > 1;
        return [ m_homeButton ];
    }

    /**
     * @private
     */
    override public function set navigationContent(value:Array):void
    {
        throw new Error("Setting the navigation content is not supported. " +
                        "Use the icon style to define the view icon. ");
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        if (!styleProp ||
            styleProp == "styleName" ||
            styleProp == "icon")
        {
            if (m_homeButton)
            {
                m_homeButton.setStyle("icon", IconUtil.getIconPath(getStyle("icon")));
            }
        }

        super.styleChanged(styleProp);
    }

    /**
     * @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (!m_homeButton)
        {
            m_homeButton = new Button();
            m_homeButton.setStyle("icon", IconUtil.getIconPath(getStyle("icon")));
            m_homeButton.addEventListener(MouseEvent.CLICK, homeClickHandler);
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
                    // Don't treat the overflow button
                    if (actionContent[i] == m_overflowButton)
                    {
                        items = m_overflowList.dataProvider.toArray();
                        numItems = items.length;
                        for (i = 0; i < numItems; i++)
                        {
                            actionItem = items[i] as MenuItem;
                            removeActionItemHandlers(actionItem);
                        }
                    }
                    else
                    {
                        actionItemButton = actionContent[i] as Button;
                        actionItem = m_actionItemsMap[actionItemButton.id];
                        removeActionItemHandlers(actionItem);
                        if (actionItemButton)
                        {
                            actionItemButton.removeEventListener(MouseEvent.CLICK, actionItemClickHandler);
                        }
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

                    addActionItemHandlers(actionItem);
                }

                if (isOverflow)
                {
                    items = m_menuItems.slice(OVERFLOW_THRESHOLD - 1);
                    numItems = items.length;
                    for (i = 0; i < numItems; i++)
                    {
                        actionItem = items[i] as MenuItem;
                        addActionItemHandlers(actionItem);
                    }

                    m_overflowActionItems.removeAll();
                    m_overflowActionItems.source = items;
                    actionContent[OVERFLOW_THRESHOLD - 1] = m_overflowButton;
                }
            }

            this.actionContent = actionContent;
        }

        super.commitProperties();
    }

    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Pushes a new view onto the top of the navigation stack.
     * The view pushed onto the stack becomes the current view.
     *
     * @param viewClass
     * @param data
     * @param popUp
     */
    protected function pushView(viewClass:Class, data:Object = null, isPopUp:Boolean = false):void
    {
        if (navigator.parentNavigator is ResponsiveViewNavigator)
        {
            const rvn:ResponsiveViewNavigator = navigator.parentNavigator as ResponsiveViewNavigator;
            rvn.pushView(viewClass, data, isPopUp);
        }
        else
        {
            navigator.pushView(viewClass, data, navigator.context);
        }
    }
    
    protected function showMainView():void
    {
        if (!DeviceUtil.isTablet)
        {
            navigator.popToFirstView();
        }
    }
    
    protected function setActionMode(actionModeClass:Class, data:Object = null):void
    {
        
    }

    protected function closeViewIfPopUp():void
    {
        if (navigator.parentNavigator is ResponsiveViewNavigator)
        {
            const rvn:ResponsiveViewNavigator = navigator.parentNavigator as ResponsiveViewNavigator;
            if (rvn.isViewInPopUp(this))
            {
                rvn.backKeyUpHandler();
            }
        }
        else
        {
            navigator.popView();
        }
    }

    /*public function startActionMode(viewClass:Class,
                                    data:Object = null):void
    {
        const actionViewProxy:ViewDescriptor = new ViewDescriptor(viewClass, data, navigator.context);

        var actionView:spark.components.View;

        if (actionViewProxy.instance == null)
        {
            actionView = new actionViewProxy.viewClass();
            actionViewProxy.instance = actionView;
        }
        else
        {
            actionView = actionViewProxy.instance;

            // Need to update the view's orientation state if it was saved
            actionView.setCurrentState(actionView.getCurrentViewState(), false);
        }

        // Restore persistence data if necessary
        if (actionViewProxy.data == null && actionViewProxy.persistenceData != null)
            actionViewProxy.data = actionView.deserializeData(actionViewProxy.persistenceData);

        actionView.setNavigator(this.navigator);
        actionView.data = actionViewProxy.data;
        actionView.percentWidth = actionView.percentHeight = 100;

        //actionView.addEventListener(FlexEvent.CREATION_COMPLETE, actionViewCreationComplete);
        // addElement(view);

        if (actionView.titleContent)
        {
            this.titleContent = actionView.titleContent;
        }
    }*/

    /*private function actionViewCreationComplete(event:FlexEvent):void
    {
        var actionView:spark.components.View = event.currentTarget as spark.components.View;
        if (actionView)
        {
            if (actionView.titleContent)
            {
                this.titleContent = actionView.titleContent;
            }
        }
    }*/

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    protected function actionItemSelected(item:MenuItem):void
    {
        // Can be overridden by sub-classes.
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------


    private function addActionItemHandlers(actionItem:MenuItem):void
    {
        actionItem.addEventListener("expand", actionItemExpandHandler);
        actionItem.addEventListener("collapse", actionItemCollapseHandler);
    }

    private function removeActionItemHandlers(actionItem:MenuItem):void
    {
        actionItem.removeEventListener("expand", actionItemExpandHandler);
        actionItem.removeEventListener("collapse", actionItemExpandHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handler
    //
    //--------------------------------------------------------------------------

    private function actionItemClickHandler(event:MouseEvent):void
    {
        var actionItemButton:Button = event.currentTarget as Button;
        var actionItem:MenuItem = m_actionItemsMap[actionItemButton.id];

        actionItem.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false));
        if (actionItem.actionViewClass)
        {
            actionItem.expandActionView();
        }
        actionItemSelected(actionItem);
    }

    private function overflowListIndexChangingHandler(event:IndexChangeEvent):void
    {
        // Prevent the selection
        event.preventDefault();
        var actionItem:MenuItem = m_menuItems[OVERFLOW_THRESHOLD - 1 + event.newIndex];

        actionItem.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false));
        actionItemSelected(actionItem);
    }

    private function actionItemExpandHandler(event:Event):void
    {
        var actionItem:MenuItem = event.currentTarget as MenuItem;
        if (actionItem.actionViewClass)
        {
            // The event is processed.
            event.preventDefault();

            m_activeActionView = actionItem;

            actionItem.visible = false;

            var actionButton:Button = m_actionButtonsMap[actionItem.uid] as Button;
            if (actionButton)
            {
                actionButton.visible = false;
                actionButton.includeInLayout = false;
            }
            else
            {
                m_overflowActionItems.refresh();
            }

            const actionView:UIComponent = actionItem.actionViewClass.newInstance() as UIComponent;
            titleContent = [ actionView ];
            // Set the focus on the component when it's created.
            if (actionView.initialized)
            {
                actionView.setFocus();
            }
            else
            {
                actionView.addEventListener(FlexEvent.CREATION_COMPLETE, actionViewCreationCompleteHandler);
            }
            m_homeButton.mouseEnabled = true;
        }
    }

    private function actionItemCollapseHandler(event:Event):void
    {
        var actionItem:MenuItem = event.currentTarget as MenuItem;
        if (m_activeActionView === actionItem)
        {
            m_activeActionView = null;
            
            if (m_fakeViewDescriptorInNavigator)
            {
                m_fakeViewDescriptorInNavigator = false;
                navigator.navigationStack.source.shift();
            }

            titleContent = null;
            m_homeButton.mouseEnabled = navigator.length > 1;

            actionItem.visible = true;

            var actionButton:Button = m_actionButtonsMap[actionItem.uid] as Button;
            if (actionButton)
            {
                actionButton.visible = true;
                actionButton.includeInLayout = true;
            }
            else
            {
                m_overflowActionItems.refresh();
            }
        }
    }


    private function addedToStageHandler(event:Event):void
    {
        systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyDownHandler, false);
    }

    private function removedFromStageHandler(event:Event):void
    {
        systemManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stageKeyDownHandler, false);
    }

    private function stageKeyDownHandler(event:KeyboardEvent):void
    {
        if (event.keyCode == Keyboard.BACK)
        {
            // An actionView is active
            if (m_activeActionView)
            {
                // Fake the navigator by miking
                // him think there is at least an extra view
                if (navigator.length == 1)
                {
                    m_fakeViewDescriptorInNavigator = true;
                    navigator.navigationStack.source.unshift(null);
                }
            }
        }
    }

    private function homeClickHandler(event:Event):void
    {
        if (navigator.length > 1 || m_activeActionView)
        {
            // Fake the dispatching of the back key
            systemManager.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, Keyboard.BACK, Keyboard.BACK));
            systemManager.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, Keyboard.BACK, Keyboard.BACK));
            //backKeyHandler(event);
        }
        else
        {
            if (navigator.parentNavigator is ResponsiveViewNavigator)
            {
                var rvn:ResponsiveViewNavigator = navigator.parentNavigator as ResponsiveViewNavigator;
                if (rvn.hasSlidingMenu)
                {
                    if (!rvn.isSlidingMenuOpened)
                    {
                        rvn.openSlidingMenu();
                    }
                    else
                    {
                        rvn.closeSlidingMenu();
                    }
                }
            }

        }
    }

    private function backKeyHandler(event:Event):void
    {
        // An actionView is active
        if (m_activeActionView)
        {
            // The event is processed.
            event.preventDefault();

            // will trigger actionItemCollapseHandler
            m_activeActionView.dispatchEvent(new Event("collapse"));
        }
    }

    private function actionViewCreationCompleteHandler(event:FlexEvent):void
    {
        var actionView:UIComponent = event.currentTarget as UIComponent;
        actionView.removeEventListener(FlexEvent.CREATION_COMPLETE, actionViewCreationCompleteHandler);
        actionView.setFocus();
    }

}
}
