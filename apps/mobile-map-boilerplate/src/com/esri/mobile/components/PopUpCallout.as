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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.core.DPIClassification;
import mx.core.FlexGlobals;
import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.managers.PopUpManager;
import mx.managers.SystemManager;
import mx.utils.MatrixUtil;
import mx.utils.PopUpUtil;

import spark.components.SkinnablePopUpContainer;

use namespace mx_internal;

public class PopUpCallout extends SkinnablePopUpContainer
{

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static var decomposition:Vector.<Number> = new <Number>[ 0, 0, 0, 0, 0 ];

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     * 
     */
    public function PopUpCallout()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  margin
    //----------------------------------

    private var m_margin:Number = NaN;

    /**
     *  @private
     *  Defines a margin around the Callout to nudge it's position away from the
     *  edge of the screen.
     */
    mx_internal function get margin():Number
    {
        if (isNaN(m_margin))
        {
            var dpi:Number = FlexGlobals.topLevelApplication["applicationDPI"];

            if (dpi)
            {
                switch (dpi)
                {
                    case DPIClassification.DPI_320:
                    {
                        m_margin = 16;
                        break;
                    }
                    case DPIClassification.DPI_240:
                    {
                        m_margin = 12;
                        break;
                    }
                    default:
                    {
                        // default DPI_160
                        m_margin = 8;
                        break;
                    }
                }
            }
            else
            {
                m_margin = 8;
            }
        }

        return m_margin;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        // Do not commit position changes if closed (no owner) or owner was 
        // removed from the display list.
        if (!owner || !owner.parent)
        {
            return;
        }

        // Compute max size
        explicitMaxWidth = screen.right - 2 * margin;
        explicitMaxHeight = screen.bottom - 2 * margin;
    }
    
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        if (isOpen)
        {
            updatePopUpPosition();
        }
    }

    /**
     *  @private
     */
    override public function open(owner:DisplayObjectContainer, modal:Boolean = false):void
    {
        if (isOpen)
        {
            return;
        }

        // Add to PopUpManager, calls updatePopUpPosition(), and change state
        super.open(owner, modal);

        // Reposition the callout when the screen changes
        var systemManagerParent:SystemManager = this.parent as SystemManager;

        if (systemManagerParent)
        {
            systemManagerParent.addEventListener(Event.RESIZE, systemManager_resizeHandler);
        }
    }

    /**
     *  @private
     */
    override public function close(commit:Boolean = false, data:* = null):void
    {
        if (!isOpen)
        {
            return;
        }

        var systemManagerParent:SystemManager = this.parent as SystemManager;

        if (systemManagerParent)
        {
            systemManagerParent.removeEventListener(Event.RESIZE, systemManager_resizeHandler);
        }

        super.close(commit, data);
    }
    
    /**
     *  @private
     */
    override public function updatePopUpPosition():void
    {
        if (!owner || !systemManager)
        {
            return;
        }
        
        var popUpPoint:Point = new Point();
        popUpPoint.x = (screen.width - getLayoutBoundsWidth()) * 0.5;
        popUpPoint.y = (screen.height - calloutHeight) * 0.5;

        var ownerComponent:UIComponent = owner as UIComponent;
        var concatenatedColorTransform:ColorTransform =
            (ownerComponent) ? ownerComponent.$transform.concatenatedColorTransform : null;
        
        PopUpUtil.applyPopUpTransform(owner, concatenatedColorTransform,
            systemManager, this, popUpPoint);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function get calloutHeight():Number
    {
        return (isSoftKeyboardEffectActive) ? softKeyboardEffectCachedHeight : getLayoutBoundsHeight();
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function systemManager_resizeHandler(event:Event):void
    {
        // Remove explicit settings if due to Resize effect
        softKeyboardEffectResetExplicitSize();

        invalidateDisplayList();

        if (!isSoftKeyboardEffectActive)
        {
            validateNow();
        }
    }
}
}
