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

import com.esri.mobile.components.ResponsiveViewNavigator;

import flash.events.MouseEvent;
import flash.geom.Point;

import mx.core.EventPriority;

import spark.components.Group;
import spark.components.ViewNavigator;

/**
 * Utility class to handle mouse interaction while the sliding menu is open.
 * If the user tap on the main view navigator then the sliding menu closes.
 */
public final class SlidingMenuController
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
    public function SlidingMenuController(navigator:ResponsiveViewNavigator)
    {
        this.navigator = navigator;
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var navigator:ResponsiveViewNavigator;
    
    /**
     * x position of the group of the main navigator when starting sliding
     */
    private var m_originX:Number;
    
    /**
     * last x-coordinate of the mouse on the navigator
     */
    private var m_positionX:Number;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  isSlidingMenuOpened
    //----------------------------------

    private var m_isSlidingMenuOpened:Boolean = false;

    public function get isSlidingMenuOpened():Boolean
    {
        return m_isSlidingMenuOpened;
    }

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

    public function open():void
    {
        if (!isSlidingMenuOpened)
        {
            m_isSlidingMenuOpened = true;
            const mainViewNavigator:ViewNavigator = navigator.mainViewNavigator;
            const mainViewNavigatorGroup:Group = navigator.mainViewNavigatorGroup;

            // Deploy mouse handling on the main view navigator.
            // The user can only click on it, no panning etc
            if (mainViewNavigator)
            {
                mainViewNavigator.activeView.mouseEnabled = false;
                mainViewNavigator.activeView.mouseChildren = false;
                mainViewNavigatorGroup.callLater(mainViewNavigatorGroup.addEventListener,
                                                 [ MouseEvent.MOUSE_DOWN,
                                                   mainGroupMouseDownHandler,
                                                   false,
                                                   EventPriority.BINDING ]);
                mainViewNavigatorGroup.callLater(mainViewNavigatorGroup.addEventListener,
                                                 [ MouseEvent.CLICK,
                                                   mainGroupMouseClickHandler,
                                                   false,
                                                   EventPriority.BINDING ]);

                // Disable the actionbar to prevent actions to be launched.
                if (mainViewNavigator.actionBar)
                {
                    mainViewNavigator.actionBar.actionGroup.mouseEnabled = false;
                    mainViewNavigator.actionBar.actionGroup.mouseChildren = false;
                }
            }

            navigator.invalidateSkinState();
        }
    }

    public function close():void
    {
        if (isSlidingMenuOpened)
        {
            m_isSlidingMenuOpened = false;
            const mainViewNavigator:ViewNavigator = navigator.mainViewNavigator;
            const mainViewNavigatorGroup:Group = navigator.mainViewNavigatorGroup;

            if (mainViewNavigator)
            {
                navigator.removeEventListener(MouseEvent.MOUSE_MOVE, navigatorMouseMoveHandler);
                navigator.removeEventListener(MouseEvent.MOUSE_UP, navigatorMouseUpHandler);
                
                mainViewNavigator.activeView.mouseEnabled = true;
                mainViewNavigator.activeView.mouseChildren = true;
                mainViewNavigatorGroup.removeEventListener(MouseEvent.MOUSE_DOWN, mainGroupMouseDownHandler);
                mainViewNavigatorGroup.removeEventListener(MouseEvent.CLICK, mainGroupMouseClickHandler);

                if (mainViewNavigator.actionBar)
                {
                    mainViewNavigator.actionBar.actionGroup.mouseEnabled = true;
                    mainViewNavigator.actionBar.actionGroup.mouseChildren = true;
                }
            }

            navigator.invalidateSkinState();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------


    private function mainGroupMouseClickHandler(event:MouseEvent):void
    {
        // TODO: if the user started sliding the menu then put it back, then don't close it.
        close();
    }

    private function mainGroupMouseDownHandler(event:MouseEvent):void
    {
        const mainGroup:Group = navigator.mainViewNavigatorGroup;
        m_originX = mainGroup.getLayoutBoundsX();
        m_positionX = navigator.mouseX;
        navigator.addEventListener(MouseEvent.MOUSE_MOVE, navigatorMouseMoveHandler, false, EventPriority.BINDING);
        navigator.addEventListener(MouseEvent.MOUSE_UP, navigatorMouseUpHandler, false, EventPriority.BINDING);
    }

    private function navigatorMouseMoveHandler(event:MouseEvent):void
    {
        const mainGroup:Group = navigator.mainViewNavigatorGroup;
        var x:Number = mainGroup.getLayoutBoundsX() - (m_positionX - navigator.mouseX);
        x = Math.min(m_originX, x);
        x = Math.max(x, 0);
        mainGroup.setLayoutBoundsPosition(x, mainGroup.y);
        m_positionX = navigator.mouseX;
    }

    private function navigatorMouseUpHandler(event:MouseEvent):void
    {
        navigator.removeEventListener(MouseEvent.MOUSE_MOVE, navigatorMouseMoveHandler, false);
        navigator.removeEventListener(MouseEvent.MOUSE_UP, navigatorMouseUpHandler, false);
    }


}
}
