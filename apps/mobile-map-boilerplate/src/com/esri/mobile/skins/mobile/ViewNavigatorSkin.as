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

import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import mx.core.DPIClassification;

import spark.components.ActionBar;
import spark.components.Group;
import spark.components.ViewNavigator;
import spark.primitives.RectangularDropShadow;

/**
 *  The ActionScript-based skin for view navigators in mobile
 *  applications.  This skin lays out the action bar and content
 *  group in a vertical fashion, where the action bar is on top.
 *  This skin also supports navigator overlay modes.
 *
 *  @langversion 3.0
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class ViewNavigatorSkin extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------  

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function ViewNavigatorSkin()
    {
        super();

        m_dropShadowAlpha = 0.7;

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO DPIClassification

                m_dropShadowBlurX = 32;
                m_dropShadowBlurY = 32;
                m_dropShadowDistance = 6;
                */

                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO DPIClassification

                m_dropShadowBlurX = 24;
                m_dropShadowBlurY = 24;
                m_dropShadowDistance = 4;
                */

                break;
            }
            default:
            {
                m_dropShadowBlurX = 4;
                m_dropShadowBlurY = 4;
                m_dropShadowDistance = 1;
                break;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.components.SkinnableContainer#contentGroup
     */
    public var contentGroup:Group;

    /**
     *  @copy spark.components.ViewNavigator#actionBar
     */
    public var actionBar:ActionBar;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:ViewNavigator;

    /**
     * 
     */
    public function get useSplitMode():Boolean
    {
        return hostComponent.activeView && hostComponent.activeView.actionContent != null
            && (unscaledWidth < 480 || (isPhone && isPortrait));
    }


    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------

    private var m_isOverlay:Boolean;

    private var m_dropShadowVisible:Boolean = false;

    private var m_dropShadow:RectangularDropShadow;

    private var m_dropShadowBlurX:Number;

    private var m_dropShadowBlurY:Number;

    private var m_dropShadowDistance:Number;

    private var m_dropShadowAlpha:Number;

    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------


    /**
     *  @private
     */
    override protected function createChildren():void
    {
        contentGroup = new Group();
        contentGroup.id = "contentGroup";

        actionBar = new ActionBar();
        actionBar.id = "actionBar";

        if (m_dropShadowVisible)
        {
            m_dropShadow = new RectangularDropShadow();
            m_dropShadow.angle = 90;
            m_dropShadow.distance = m_dropShadowDistance;
            m_dropShadow.blurX = m_dropShadowBlurX;
            m_dropShadow.blurY = m_dropShadowBlurY;
            m_dropShadow.tlRadius = m_dropShadow.trRadius = m_dropShadow.blRadius =
                m_dropShadow.brRadius = 0;
            m_dropShadow.mouseEnabled = false;
            m_dropShadow.alpha = m_dropShadowAlpha;
            addChild(m_dropShadow);
        }

        addChild(contentGroup);
        addChild(actionBar);
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        var allStyles:Boolean = !styleProp || styleProp == "styleName";
        if (allStyles || styleProp == "dropShadowVisible")
        {
            m_dropShadowVisible = getStyle("dropShadowVisible");
            if ((m_dropShadowVisible && !m_dropShadow) || (!m_dropShadowVisible && m_dropShadow))
            {
                invalidateDisplayList();
            }
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        measuredWidth = Math.max(actionBar.getPreferredBoundsWidth(),
                                 contentGroup.getPreferredBoundsWidth());

        if (currentState == "portraitAndOverlay" || currentState == "landscapeAndOverlay")
        {
            measuredHeight = Math.max(actionBar.getPreferredBoundsHeight(),
                                      contentGroup.getPreferredBoundsHeight());
        }
        else
        {
            measuredHeight = actionBar.getPreferredBoundsHeight() +
                contentGroup.getPreferredBoundsHeight();

            if (useSplitMode)
            {
                measuredHeight += actionBar.getPreferredBoundsHeight();
            }
        }
    }

    /**
     *  @private
     */
    override protected function commitCurrentState():void
    {
        super.commitCurrentState();

        m_isOverlay = (currentState.indexOf("Overlay") >= 1);

        // Force a layout pass on the components
        invalidateProperties();
        invalidateSize();
        invalidateDisplayList();
    }

    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);

        var actionBarHeight:Number = 0;
        var splitMode:Boolean = useSplitMode;

        if (m_dropShadowVisible && !m_dropShadow)
        {
            m_dropShadow = new RectangularDropShadow();
            m_dropShadow.angle = 90;
            m_dropShadow.distance = m_dropShadowDistance;
            m_dropShadow.blurX = m_dropShadowBlurX;
            m_dropShadow.blurY = m_dropShadowBlurY;
            m_dropShadow.tlRadius = m_dropShadow.trRadius = m_dropShadow.blRadius =
                m_dropShadow.brRadius = 0;
            m_dropShadow.mouseEnabled = false;
            m_dropShadow.alpha = m_dropShadowAlpha;
            addChild(m_dropShadow);
        }
        if (!m_dropShadowVisible && m_dropShadow)
        {
            removeChild(m_dropShadow);
            m_dropShadow = null;
        }
        if (m_dropShadow)
        {
            setElementSize(m_dropShadow, unscaledWidth, unscaledHeight);
        }

        if (actionBar.includeInLayout)
        {
            actionBarHeight = actionBar.measuredHeight;
            if (splitMode)
            {
                actionBar.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
            }
            else
            {
                actionBar.setLayoutBoundsSize(unscaledWidth, actionBarHeight);
            }
            actionBar.setLayoutBoundsPosition(0, 0);

            var backgroundAlpha:Number = (m_isOverlay) ? 0.8 : 1;
            actionBar.setStyle("backgroundAlpha", backgroundAlpha);
        }

        if (contentGroup.includeInLayout)
        {
            var contentGroupPosition:Number = (m_isOverlay) ? 0 : actionBarHeight;
            var contentGroupHeight:Number;
            if (m_isOverlay)
            {
                contentGroupHeight = unscaledHeight;
            }
            else if (splitMode)
            {
                contentGroupHeight = unscaledHeight - actionBarHeight * 2;
            }
            else
            {
                contentGroupHeight = unscaledHeight - actionBarHeight;
            }
            contentGroupHeight = Math.max(contentGroupHeight, 0);

            contentGroup.setLayoutBoundsSize(unscaledWidth, contentGroupHeight);
            contentGroup.setLayoutBoundsPosition(0, contentGroupPosition);
        }
    }
}
}
