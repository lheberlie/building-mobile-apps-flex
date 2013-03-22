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

package com.esri.mobile.skins.mobile
{

import com.esri.mobile.components.PopUpCallout;
import com.esri.mobile.components.ResponsiveViewNavigator;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;
import com.esri.mobile.utils.DeviceUtil;

import mx.core.DPIClassification;
import mx.core.EventPriority;
import mx.core.FlexGlobals;
import mx.events.EffectEvent;
import mx.events.ResizeEvent;

import spark.components.Group;
import spark.components.SkinnablePopUpContainer;
import spark.components.ViewNavigator;
import spark.effects.Move;

public class ResponsiveViewNavigatorSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
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
    public function ResponsiveViewNavigatorSkin()
    {
        super();
        FlexGlobals.topLevelApplication.addEventListener(ResizeEvent.RESIZE,
                                                         application_resizeHandler,
                                                         false,
                                                         EventPriority.BINDING,
                                                         true);

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO DPI
                phoneSlidingMenuRightMargin = 56;
                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO DPI
                phoneSlidingMenuRightMargin = 56;
                */
                break;
            }
            default:
            {
                // TODO DPI
                phoneSlidingMenuRightMargin = 56;
                tabletViewNavigatorGroupWidth = 400;
                slidingMenuTabletWidth = 320;
                break;
            }
        }
    }


    //--------------------------------------------------------------------------
    //
    //  SkinParts
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.components.SkinnableContainer#contentGroup
     */
    public var contentGroup:Group;

    /**
     *  @copy spark.components.ResponsiveViewNavigator#slidingMenuViewNavigatorGroup
     */
    public var slidingMenuViewNavigatorGroup:Group;

    /**
     *  @copy spark.components.ResponsiveViewNavigator#mainViewNavigatorGroup
     */
    public var mainViewNavigatorGroup:Group;

    /**
     *  @copy spark.components.ResponsiveViewNavigator#tabletViewNavigatorGroup
     */
    public var tabletViewNavigatorGroup:Group;

    /**
     *  @copy spark.components.ResponsiveViewNavigator#secondaryViewNavigatorGroup
     */
    public var popUpCallout:PopUpCallout;

    /**
     *  @copy spark.components.ResponsiveViewNavigator#secondaryViewNavigatorGroup
     */
    public var calloutViewNavigator:ViewNavigator;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:ResponsiveViewNavigator;

    /**
     *  Sliding effect when opening the drawer
     */
    private var slideEffect:Move;

    /**
     *  Right margin of the drawer when opened
     */
    protected var phoneSlidingMenuRightMargin:int;

    /**
     *  The width of the secondary ViewNavigator when in a tablet context.
     */
    protected var tabletViewNavigatorGroupWidth:int;

    /**
     *  The width of the SlidingMenu when in a tablet context.
     */
    protected var slidingMenuTabletWidth:int;

    private var m_slidingMenuWidth:int;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        // Create the contentGroup
        contentGroup = new Group();
        contentGroup.id = "contentGroup";
        contentGroup.percentWidth = contentGroup.percentHeight = 100;
        addChild(contentGroup);

        // Create the drawerViewNavigatorGroup;
        slidingMenuViewNavigatorGroup = new Group();
        slidingMenuViewNavigatorGroup.width = m_slidingMenuWidth;
        slidingMenuViewNavigatorGroup.percentHeight = 100;
        slidingMenuViewNavigatorGroup.id = "slidingMenuViewNavigatorGroup";
        contentGroup.addElement(slidingMenuViewNavigatorGroup);

        // Create the drawerViewNavigatorGroup;
        mainViewNavigatorGroup = new Group();
        mainViewNavigatorGroup.percentWidth = mainViewNavigatorGroup.percentHeight = 100;
        mainViewNavigatorGroup.id = "mainViewNavigatorGroup";
        contentGroup.addElement(mainViewNavigatorGroup);

        // Create the drawerViewNavigatorGroup;
        tabletViewNavigatorGroup = new Group();
        tabletViewNavigatorGroup.id = "tabletViewNavigatorGroup";
        tabletViewNavigatorGroup.visible = tabletViewNavigatorGroup.includeInLayout = false;
        addChild(tabletViewNavigatorGroup);

        // Create the callout but don't add it to display list
        if (!popUpCallout)
        {
            popUpCallout = new PopUpCallout();
            popUpCallout.id = "popUpCallout";
            // m_popUpCallout.moveForSoftKeyboard = true;
            calloutViewNavigator = new ViewNavigator();
            calloutViewNavigator.id = "calloutViewNavigator";
            calloutViewNavigator.percentWidth = calloutViewNavigator.percentHeight = 100;
            popUpCallout.addElement(calloutViewNavigator);
        }

        slideEffect = new Move();
        slideEffect.disableLayout = true;
        slideEffect.duration = 250;
        slideEffect.xFrom = 0;
        slideEffect.xTo = m_slidingMenuWidth;
        // Add handlers to the effect to hide and show the SlidingMenu.
        // By doing so we prevent the StageText instances to be kept on screen.
        slideEffect.addEventListener(EffectEvent.EFFECT_START, slideEffectStartHandler);
        slideEffect.addEventListener(EffectEvent.EFFECT_END, slideEffectEndHandler);
    }

    override protected function commitProperties():void
    {
        super.commitProperties();

        slideEffect.xTo = m_slidingMenuWidth;
        slidingMenuViewNavigatorGroup.width = m_slidingMenuWidth;
    }

    override protected function commitCurrentState():void
    {
        var state:String = currentState;
        if (state.lastIndexOf("SlidingMenu") != -1)
        {
            if (mainViewNavigatorGroup.x == 0)
            {
                slideEffect.xTo = m_slidingMenuWidth;
                slideEffect.play([ mainViewNavigatorGroup ]);
                    // TODO: optimizations
            }
        }
        else
        {
            if (mainViewNavigatorGroup.x != 0)
            {
                slideEffect.xTo = mainViewNavigatorGroup.getLayoutBoundsX();
                slideEffect.play([ mainViewNavigatorGroup ], true);
                    // TODO: optimizations
            }
        }

        if (tabletViewNavigatorGroup)
        {
            var oldValue:Boolean = tabletViewNavigatorGroup.visible;
            tabletViewNavigatorGroup.visible = tabletViewNavigatorGroup.includeInLayout = state.lastIndexOf("SecondaryViewNavigator") != -1;
            if (tabletViewNavigatorGroup.visible != oldValue)
            {
                invalidateDisplayList();
            }
        }
        
        invalidateSize();
        invalidateDisplayList();
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        var drawerOpen:Boolean = currentState.lastIndexOf("SlidingMenu") != -1;

        var drawerWidth:Number = drawerOpen ? slidingMenuViewNavigatorGroup.getPreferredBoundsWidth() : 0;
        var drawerHeight:Number = slidingMenuViewNavigatorGroup.getPreferredBoundsHeight();
        var mainWidth:Number = mainViewNavigatorGroup.getPreferredBoundsWidth();
        var mainHeight:Number = mainViewNavigatorGroup.getPreferredBoundsHeight();

        measuredWidth = drawerWidth + mainWidth;
        measuredHeight = drawerHeight + mainHeight;
    }

    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);

        var drawerOpen:Boolean = currentState.lastIndexOf("SlidingMenu") != -1;

        var drawerWidth:Number = drawerOpen ? getElementPreferredWidth(slidingMenuViewNavigatorGroup) : 0;
        slidingMenuViewNavigatorGroup.setLayoutBoundsPosition(0, 0);
        slidingMenuViewNavigatorGroup.setLayoutBoundsSize(drawerWidth, unscaledHeight);

        var mainHeight:Number = getElementPreferredWidth(mainViewNavigatorGroup);
        mainViewNavigatorGroup.setLayoutBoundsPosition(drawerWidth, 0);
        mainViewNavigatorGroup.setLayoutBoundsSize(unscaledWidth, unscaledHeight);

        if (tabletViewNavigatorGroup.includeInLayout)
        {
            var secondaryHeight:Number = getElementPreferredHeight(tabletViewNavigatorGroup);
            tabletViewNavigatorGroup.setLayoutBoundsPosition(unscaledWidth - tabletViewNavigatorGroupWidth - 8, 56);
            (tabletViewNavigatorGroup.getElementAt(0) as ViewNavigator).minWidth = 
                (tabletViewNavigatorGroup.getElementAt(0) as ViewNavigator).maxWidth = tabletViewNavigatorGroupWidth;
            (tabletViewNavigatorGroup.getElementAt(0) as ViewNavigator).maxHeight = unscaledHeight - 56 - 8;
        }

        contentGroup.setLayoutBoundsPosition(0, 0);
        contentGroup.setLayoutBoundsSize(drawerWidth + unscaledWidth, unscaledHeight);
    }

    /**
     *  @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Background is used to draw the divider between each navigator
        var color:uint = getStyle("backgroundColor");
        graphics.beginFill(color);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();

        opaqueBackground = color;
    }


    //--------------------------------------------------------------------------
    //
    //  Event Handler
    //
    //--------------------------------------------------------------------------

    private function application_resizeHandler(event:ResizeEvent):void
    {
        FlexGlobals.topLevelApplication.removeEventListener(ResizeEvent.RESIZE,
                                                            application_resizeHandler, false);

        var newSlidingMenuWidth:int;
        if (isPhone)
        {
            newSlidingMenuWidth = DeviceUtil.screenWidth - phoneSlidingMenuRightMargin;
        }
        else
        {
            newSlidingMenuWidth = slidingMenuTabletWidth;
        }
        if (newSlidingMenuWidth != m_slidingMenuWidth)
        {
            m_slidingMenuWidth = newSlidingMenuWidth;
            invalidateProperties();
            invalidateDisplayList();
        }
    }

    private function slideEffectStartHandler(event:EffectEvent):void
    {
        if (hostComponent.isSlidingMenuOpened)
        {
            slidingMenuViewNavigatorGroup.visible = true;
        }
    }

    private function slideEffectEndHandler(event:EffectEvent):void
    {
        if (hostComponent.isSlidingMenuOpened)
        {
            slidingMenuViewNavigatorGroup.visible = true;
        }
        else
        {
            slidingMenuViewNavigatorGroup.visible = false;
        }
    }


}
}
