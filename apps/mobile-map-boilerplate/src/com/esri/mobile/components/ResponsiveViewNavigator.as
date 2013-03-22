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

import com.esri.mobile.components.supportClasses.SlidingMenuController;
import com.esri.mobile.managers.ApplicationContext;
import com.esri.mobile.utils.DeviceUtil;

import flash.display.Scene;
import flash.events.Event;

import mx.core.mx_internal;

import spark.components.Group;
import spark.components.SkinnablePopUpContainer;
import spark.components.View;
import spark.components.ViewNavigator;
import spark.components.supportClasses.ViewNavigatorBase;
import spark.events.ElementExistenceEvent;

use namespace mx_internal;

//--------------------------------------
//  SkinStates
//--------------------------------------

[SkinState("portrait")]

[SkinState("portrait-SlidingMenu")]

[SkinState("portraitTablet")]

[SkinState("portraitTablet-SlidingMenu")]

[SkinState("portrait-SecondaryViewNavigator")]

[SkinState("portrait-SlidingMenu-SecondaryViewNavigator")]

[SkinState("portraitTablet-SecondaryViewNavigator")]

[SkinState("portraitTablet-SlidingMenu-SecondaryViewNavigator")]

[SkinState("landscape")]

[SkinState("landscape-SlidingMenu")]

[SkinState("landscapeTablet")]

[SkinState("landscapeTablet-SlidingMenu")]

[SkinState("landscape-SecondaryViewNavigator")]

[SkinState("landscape-SlidingMenu-SecondaryViewNavigator")]

[SkinState("landscapeTablet-SecondaryViewNavigator")]

[SkinState("landscapeTablet-SlidingMenu-SecondaryViewNavigator")]

//--------------------------------------
//  Other Metadata
//--------------------------------------

[DefaultProperty("mainViewNavigator")]

public class ResponsiveViewNavigator extends ViewNavigatorBase
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
    public function ResponsiveViewNavigator()
    {
        super();
        m_slidingMenuInteractionHandler = new SlidingMenuController(this);
    }

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    [SkinPart(required="false")]
    public var slidingMenuViewNavigatorGroup:Group;

    [SkinPart(required="false")]
    public var mainViewNavigatorGroup:Group;

    [SkinPart(required="false")]
    public var tabletViewNavigatorGroup:Group;

    [SkinPart(required="false")]
    public var viewNavigatorPopUp:SkinnablePopUpContainer;

    [SkinPart(required="false")]
    public var popUpCallout:PopUpCallout;

    [SkinPart(required="false")]
    public var calloutViewNavigator:ViewNavigator;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var m_popUpNavigatorIndex:int = -1;

    private var m_popUpNavigator:ViewNavigatorBase = null;

    private var m_popUpNavigatorSizeCache:Object = null;
    
    // TODO move to skin.
    private var m_slidingMenuInteractionHandler:SlidingMenuController;

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    // 
    //--------------------------------------------------------------------------

    //----------------------------------
    //  initialized
    //----------------------------------
    /**
     *  @private
     */
    override public function set initialized(value:Boolean):void
    {
        // Add application resize event listener.  We want this navigator's
        // resize ha-r to run before any others due to conflicts with
        // states.  See SDK-31575.
        /*FlexGlobals.topLevelApplication.addEventListener(ResizeEvent.RESIZE,
            application_resizeHandler, false, EventPriority.BINDING, true);*/

        super.initialized = value;
    }

    //----------------------------------
    //  numViewNavigators
    //----------------------------------
    /*public function get numViewNavigators():int
    {
        return m_popUpNavigatorIndex == -1 ? numElements : numElements + 1;
    }*/

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  context
    //----------------------------------
    
    private var m_applicationContext:ApplicationContext

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
    //  slidingMenuNavigator
    //----------------------------------

    private var m_slidingMenuNavigator:ViewNavigator;

    /**
     *  The number of view navigators managed by this container.
     */
    public function get slidingMenuNavigator():ViewNavigator
    {
        return m_slidingMenuNavigator;
    }

    /**
     * @private
     */
    public function set slidingMenuNavigator(value:ViewNavigator):void
    {
        if (m_slidingMenuNavigator !== value)
        {
            m_slidingMenuNavigator = value;
            if (slidingMenuViewNavigatorGroup)
            {
                slidingMenuViewNavigatorGroup.mxmlContent = [ m_slidingMenuNavigator ];
            }
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
        if (m_mainViewNavigator !== value)
        {
            m_mainViewNavigator = value;
            if (mainViewNavigatorGroup)
            {
                mainViewNavigatorGroup.mxmlContent = [ m_mainViewNavigator ];
            }
        }
    }

    //----------------------------------
    //  secondaryNavigator
    //----------------------------------

    private var m_tabletViewNavigator:ViewNavigator;

    /**
     * View Navigator instance that is displayed only when in a tablet context.
     */
    public function get tabletViewNavigator():ViewNavigator
    {
        return m_tabletViewNavigator;
    }
    
    //----------------------------------
    //  hasSlidingMenu
    //----------------------------------
    
    public function get hasSlidingMenu():Boolean
    {
        return m_slidingMenuNavigator != null;
    }

    //----------------------------------
    //  isSlidingMenuOpened
    //----------------------------------

    public function get isSlidingMenuOpened():Boolean
    {
        return m_slidingMenuInteractionHandler.isSlidingMenuOpened;
    }
    

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods: ViewNavigatorBase
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override mx_internal function canRemoveCurrentView():Boolean
    {
        return false;
    }

    /**
     *  @private
     */
    override mx_internal function get exitApplicationOnBackKey():Boolean
    {
        return false;
    }
    

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods: UIComponent
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function getCurrentSkinState():String
    {
        var state:String;

        // portrait or landscape
        state = DeviceUtil.aspectRatio;

        if (DeviceUtil.isTablet)
        {
            state += "Tablet";
        }

        if (isSlidingMenuOpened)
        {
            state += "-SlidingMenu";
        }
        
        if (DeviceUtil.isTablet && (m_tabletViewNavigator && m_tabletViewNavigator.length > 0))
        {
            state += "-SecondaryViewNavigator";
        }

        return state;
    }

    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        // Add event listeners before the child are added to the contentGroup
        if (instance == mainViewNavigatorGroup)
        {
            mainViewNavigatorGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
            mainViewNavigatorGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, elementRemoveHandler);
            if (m_mainViewNavigator)
            {
                mainViewNavigatorGroup.mxmlContent = [ m_mainViewNavigator ];
            }
        }
        else if (instance == tabletViewNavigatorGroup)
        {
            tabletViewNavigatorGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
            tabletViewNavigatorGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, elementRemoveHandler);
            if (!m_tabletViewNavigator)
            {
                m_tabletViewNavigator = new ViewNavigator();
                m_tabletViewNavigator.id = "tabletViewNavigator";
                m_tabletViewNavigator.transitionsEnabled = false;
            }
            tabletViewNavigatorGroup.mxmlContent = [ m_tabletViewNavigator ];
        }
        else if (instance == slidingMenuViewNavigatorGroup)
        {
            slidingMenuViewNavigatorGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
            slidingMenuViewNavigatorGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, elementRemoveHandler);
            if (m_slidingMenuNavigator)
            {
                slidingMenuViewNavigatorGroup.mxmlContent = [ m_slidingMenuNavigator ];
            }
        }
        else if (instance == calloutViewNavigator)
        {
            setupNavigator(calloutViewNavigator);
        }

        super.partAdded(partName, instance);
    }

    /**
     *  @private
     */
    override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);

        if (instance == contentGroup)
        {
            contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
            contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, elementRemoveHandler);
        }
        else if (instance == tabletViewNavigatorGroup)
        {
            tabletViewNavigatorGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
            tabletViewNavigatorGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, elementRemoveHandler);
            tabletViewNavigatorGroup.mxmlContent = null;
        }
        else if (instance == slidingMenuViewNavigatorGroup)
        {
            slidingMenuViewNavigatorGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, elementAddHandler);
            slidingMenuViewNavigatorGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, elementRemoveHandler);
            slidingMenuViewNavigatorGroup.mxmlContent = null;
        }
    }

    /**
     *  @private
     */
    /*override public function validateNow():void
    {
        // If a navigator is currently inside a popup, force a validation on it as well.
        // This was added because ViewNavigator will call validateNow on its parentNavigator
        // when preparing to do a view transition.  Since the popup navigator is no longer
        // a child of this SplitViewNavigator, the navigator in the popup isn't validated
        // as expected.
        if (_popUpNavigatorIndex != -1)
            _popUpNavigator.validateNow();

        super.validateNow();
    }*/
    
    override public function backKeyUpHandler():void
    {
        if (popUpCallout.isOpen)
        {
            // Case 1: Close the popup if it's open.
            popUpCallout.close();
        }
        else if (DeviceUtil.isTablet && tabletViewNavigator.length > 0)
        {
            // Case 2: Delegate to the tabletViewNavigator if in a tablet context
            tabletViewNavigator.backKeyUpHandler();
            // if the navigationStack of the tabletViewNavigator hits 0, it will be closed.
            m_tabletViewNavigator.addEventListener("viewChangeComplete", viewChangeCompleteHandler);
        }
        else if (mainViewNavigator.length > 1)
        {
            mainViewNavigator.backKeyUpHandler();
        }
        else
        {
            super.backKeyUpHandler();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    public function pushView(viewClass:Class, data:Object = null, isPopUp:Boolean = false):void
    {
        if (DeviceUtil.isTablet)
        {
            // openSecondaryViewNavigator();
            m_tabletViewNavigator.replaceView(viewClass, data);
            m_tabletViewNavigator.addEventListener("viewChangeComplete", viewChangeCompleteHandler);
        }
        else
        {
            if (isPopUp)
            {
                calloutViewNavigator.firstView = viewClass;
                calloutViewNavigator.firstViewData = data;
                calloutViewNavigator.popToFirstView();
                popUpCallout.open(this, true);
            }
            else
            {
                mainViewNavigator.pushView(viewClass, data);
            }
        }
    }
    
    public function isViewInPopUp(view:spark.components.View):Boolean
    {
        return calloutViewNavigator && calloutViewNavigator.activeView === view;
    }
    
    /*public function openSecondaryViewNavigator():void
    {
        if (!isSecondaryViewNavigatorOpened)
        {
            m_isSecondaryViewNavigatorOpened = true;
            invalidateSkinState();
        }
    }

    public function closeSecondaryViewNavigator():void
    {
        if (isSecondaryViewNavigatorOpened)
        {
            m_isSecondaryViewNavigatorOpened = false;
            invalidateSkinState();
        }
    }*/

    public function openSlidingMenu():void
    {
        m_slidingMenuInteractionHandler.open();
    }

    public function closeSlidingMenu():void
    {
        m_slidingMenuInteractionHandler.close();
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function setupNavigator(navigator:ViewNavigatorBase):void
    {
        navigator.setParentNavigator(this);

        // Add weak listeners for hide and show events on the navigator.  When
        // a navigator is hidden, its container is removed from layout.
        //navigator.addEventListener(FlexEvent.HIDE, navigator_visibilityChangedHandler, false, EventPriority.DEFAULT, true);
        //navigator.addEventListener(FlexEvent.SHOW, navigator_visibilityChangedHandler, false, EventPriority.DEFAULT, true);

        // Remove the navigator from layout if it isn't visible
    /*if (navigator.visible == false)
    {
        navigator.includeInLayout = false;
    }*/
    }

    /**
     *  @private
     */
    private function cleanUpNavigator(navigator:ViewNavigatorBase):void
    {
        navigator.setParentNavigator(null);
        //navigator.removeEventListener(FlexEvent.HIDE, navigator_visibilityChangedHandler);
        //navigator.removeEventListener(FlexEvent.SHOW, navigator_visibilityChangedHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function elementAddHandler(event:ElementExistenceEvent):void
    {
        var navigator:ViewNavigatorBase = event.element as ViewNavigatorBase;

        if (navigator)
        {
            setupNavigator(navigator);
        }
    }

    /**
     *  @private
     */
    private function elementRemoveHandler(event:ElementExistenceEvent):void
    {
        if (event.element != m_popUpNavigator)
        {
            var navigator:ViewNavigatorBase = event.element as ViewNavigatorBase;

            if (navigator)
            {
                cleanUpNavigator(event.element as ViewNavigatorBase);
            }
        }
    }
    
    private function viewChangeCompleteHandler(event:Event):void
    {
        m_tabletViewNavigator.removeEventListener("viewChangeComplete", viewChangeCompleteHandler);
        // if the navigationStack of the tabletViewNavigator hits 0, it will be closed.
        invalidateSkinState();
    }

}
}
