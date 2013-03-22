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

import com.esri.mobile.managers.ApplicationContext;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.KeyboardEvent;

import mx.core.mx_internal;

import spark.components.View;
import spark.components.ViewNavigator;
import spark.components.supportClasses.ViewNavigatorApplicationBase;

use namespace mx_internal;

//--------------------------------------
//  Other Metadata
//--------------------------------------

[DefaultProperty("mainViewNavigator")]

public class ResponsiveViewNavigatorApplication extends ViewNavigatorApplicationBase
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
    public function ResponsiveViewNavigatorApplication()
    {
        super();
        NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activateHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    [Bindable]
    [SkinPart(required="false")]
    /**
     *  The main view navigator for the application.  This component is
     *  responsible for managing the view navigation model for the application.
     */
    public var navigator:ResponsiveViewNavigator;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  exitApplicationOnBackKey
    //----------------------------------
    /**
     *  @private
     */
    override mx_internal function get exitApplicationOnBackKey():Boolean
    {
        trace("false");
        if (navigator)
        {
            return navigator.exitApplicationOnBackKey;
        }

        return super.exitApplicationOnBackKey;
    }

    //----------------------------------
    //  applicationContext
    //----------------------------------

    private var m_applicationContext:ApplicationContext;

    public function get applicationContext():ApplicationContext
    {
        return m_applicationContext;
    }

    public function set applicationContext(value:ApplicationContext):void
    {
        if (m_applicationContext !== value)
        {
            m_applicationContext = value;
        }
    }
    
    //----------------------------------
    //  mainNavigator
    //----------------------------------
    
    private var m_mainViewNavigator:ViewNavigator;
    
    public function get mainViewNavigator():ViewNavigator
    {
        return m_mainViewNavigator;
    }
    
    public function set mainViewNavigator(value:ViewNavigator):void
    {
        m_mainViewNavigator = value;
    }

    //----------------------------------
    //  activeView
    //----------------------------------

    /**
     *  @private
     */
    override mx_internal function get activeView():spark.components.View
    {
        if (navigator)
        {
            return navigator.activeView;
        }

        return null;
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

        if (instance == navigator)
        {
            navigator.applicationContext = applicationContext;
            navigator.mainViewNavigator = mainViewNavigator;
            
            // Set the stage focus to the navigator
            systemManager.stage.focus = navigator;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods: ViewNavigatorApplicationBase
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function invokeHandler(event:InvokeEvent):void
    {
        super.invokeHandler(event);

        if (navigator)
        {
            if (navigator.activeView)
            {
                systemManager.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
            }

            // Set the stage focus to the navigator's active view
            navigator.updateFocus();
        }
    }

    /**
     *  @private
     */
    override protected function deactivateHandler(event:Event):void
    {
        if (navigator && navigator.activeView)
        {
            navigator.activeView.setActive(false);
        }

        super.deactivateHandler(event);
    }

    /**
     *  @private
     */
    override protected function backKeyUpHandler(event:KeyboardEvent):void
    {
        super.backKeyUpHandler(event);

        if (navigator)
        {
            navigator.backKeyUpHandler();
        }
    }

    /**
     *  @private
     */
    override protected function saveNavigatorState():void
    {
        super.saveNavigatorState();

        if (navigator)
        {
            persistenceManager.setProperty("navigatorState", navigator.saveViewData());
        }
    }

    /**
     * @private
     */
    override protected function loadNavigatorState():void
    {
        super.loadNavigatorState();

        var savedState:Object = persistenceManager.getProperty("navigatorState");

        if (savedState)
        {
            navigator.loadViewData(savedState);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function activateHandler(event:Event):void
    {
        if (navigator && navigator.activeView)
        {
            if (!navigator.activeView.isActive)
            {
                navigator.activeView.setActive(true);
            }

            // Set the stage focus to the navigator's active view
            navigator.updateFocus();
        }
    }

    private function stage_resizeHandler(event:Event):void
    {
        systemManager.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);

        // Update the orientaion state of the view at launch because at this
        // point the runtime doesn't dispatch stage orientation events.
        activeView.updateOrientationState();
    }

}
}
