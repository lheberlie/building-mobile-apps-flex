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

import com.esri.ags.skins.supportClasses.DirectionsImageUtil;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import flash.events.Event;
import flash.utils.getQualifiedClassName;

import mx.core.DPIClassification;
import mx.core.FlexGlobals;
import mx.core.IDataRenderer;

import spark.components.DataGroup;
import spark.components.IItemRenderer;
import spark.components.Image;
import spark.components.supportClasses.InteractionState;
import spark.components.supportClasses.InteractionStateDetector;
import spark.components.supportClasses.StyleableTextField;

public class DirectionsDataGroupRenderer extends com.esri.mobile.skins.mobile.supportClasses.MobileSkin implements IDataRenderer, IItemRenderer
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
    public function DirectionsDataGroupRenderer()
    {
        super();

        percentWidth = 100;

        var applicationDPI:Number = FlexGlobals.topLevelApplication.applicationDPI;
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /*
                TODO: DPIClassification
                measuredDefaultHeight = 135;
                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /*
                TODO: DPIClassification
                measuredDefaultHeight = 68;
                */
                break;
            }
            default:
            {
                measuredDefaultHeight = 68;
                break;
            }
        }

        interactionStateDetector = new InteractionStateDetector(this);
        interactionStateDetector.addEventListener(Event.CHANGE, interactionStateDetector_changeHandler);

        cacheAsBitmap = true;
    }

    //--------------------------------------------------------------------------
    //
    //  Private Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Helper class to help determine when we are in the hovered or down states.
     */
    private var interactionStateDetector:InteractionStateDetector;

    /**
     *  @private
     *  Whether or not we're the last element in the list.
     */
    private var isLastItem:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var maneuver:Image;

    public var directionLabel:StyleableTextField;

    public var distanceLabel:StyleableTextField;

    //--------------------------------------------------------------------------
    //
    //  Public Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------

    private var m_data:Object;
    private var m_dataChanged:Boolean = false;

    /**
     * @copy mx.core.IDataRenderer#data
     */
    public function get data():Object
    {
        return m_data;
    }

    /**
     * @private
     */
    public function set data(value:Object):void
    {
        if (m_data != value)
        {
            m_data = value;
            m_dataChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
    }


    //----------------------------------
    //  itemIndex
    //----------------------------------

    private var m_itemIndex:int;

    public function get itemIndex():int
    {
        return m_itemIndex;
    }

    public function set itemIndex(value:int):void
    {
        if (m_itemIndex !== value)
        {
            m_itemIndex = value;
        }

        var wasLastItem:Boolean = isLastItem;
        var dataGroup:DataGroup = parent as DataGroup;
        isLastItem = (dataGroup && (value == dataGroup.numElements - 1));

        if (wasLastItem != isLastItem)
        {
            invalidateDisplayList();
        }

        if (value == m_itemIndex)
        {
            return;
        }

        m_itemIndex = value;
    }

    //----------------------------------
    //  dragging
    //----------------------------------

    private var m_dragging:Boolean;

    public function get dragging():Boolean
    {
        return m_dragging;
    }

    public function set dragging(value:Boolean):void
    {
        if (m_dragging !== value)
        {
            m_dragging = value;
        }
    }

    //----------------------------------
    //  label
    //----------------------------------

    private var m_label:String;

    public function get label():String
    {
        return m_label;
    }

    public function set label(value:String):void
    {
        if (m_label !== value)
        {
            m_label = value;
        }
    }

    //----------------------------------
    //  selected
    //----------------------------------

    private var m_selected:Boolean;

    public function get selected():Boolean
    {
        return m_selected;
    }

    public function set selected(value:Boolean):void
    {
        if (m_selected !== value)
        {
            m_selected = value;
        }
    }

    //----------------------------------
    //  showsCaret
    //----------------------------------

    private var m_showsCaret:Boolean;

    public function get showsCaret():Boolean
    {
        return m_showsCaret;
    }

    public function set showsCaret(value:Boolean):void
    {
        if (m_showsCaret !== value)
        {
            m_showsCaret = value;
        }
    }

    //----------------------------------
    //  down
    //----------------------------------

    private var m_down:Boolean = false;

    protected function get down():Boolean
    {
        return m_down;
    }

    protected function set down(value:Boolean):void
    {
        if (value == m_down)
        {
            return;
        }

        m_down = value;
        invalidateDisplayList();
    }

    //----------------------------------
    //  hovered
    //----------------------------------

    private var m_hovered:Boolean = false;

    protected function get hovered():Boolean
    {
        return m_hovered;
    }

    protected function set hovered(value:Boolean):void
    {
        if (value == m_hovered)
        {
            return;
        }

        m_hovered = value;
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

        if (!maneuver)
        {
            maneuver = new Image();
            maneuver.mouseEnabled = false;
            maneuver.mouseChildren = false;
            addChild(maneuver);
        }

        if (!directionLabel)
        {
            createDirectionLabel();
        }

        if (!distanceLabel)
        {
            createDistanceLabel();
        }
    }

    /**
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (m_dataChanged)
        {
            m_dataChanged = false;
            if (maneuver)
            {
                maneuver.source = DirectionsImageUtil.getManeuverBitmapData(m_data.maneuverType);
            }
            if (directionLabel)
            {
                directionLabel.text = data.text;
            }
            if (distanceLabel)
            {
                distanceLabel.text = data.distanceText;
            }
        }
    }

    /**
     * @private
     */
    override protected function measure():void
    {
        super.measure();

        if (directionLabel)
        {
            // reset text if it was truncated before.
            if (directionLabel.isTruncated)
            {
                directionLabel.text = data ? data.text : "";
            }

            // Text respects padding right, left, top, and bottom
            directionLabel.commitStyles();
            distanceLabel.commitStyles();

                //measuredWidth = getElementPreferredWidth(directionLabel) * 1.5 + horizontalPadding;
                // We only care about the "real" ascent
                //measuredHeight = getElementPreferredHeight(directionLabel) + verticalPadding;
        }

        //measuredMinWidth = 0;
    }

    /**
     * @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        if (!data)
        {
            return;
        }

        var viewWidth:Number = unscaledWidth - layoutGap * 2;
        var viewHeight:Number = unscaledHeight - layoutGap * 2;

        var maneuverWidth:Number = getElementPreferredWidth(maneuver);
        var maneuverHeight:Number = getElementPreferredHeight(maneuver);
        
        var labelWidth:Number = Math.max(viewWidth, 0) - maneuverWidth - layoutGap;
        var labelHeight:Number = 0;
        var distanceLabelHeight:Number = getElementPreferredHeight(distanceLabel);
        
        if (data.text != "")
        {
            directionLabel.commitStyles();
            if (directionLabel.isTruncated)
            {
                directionLabel.text = data.text;
            }
            labelHeight = getElementPreferredHeight(directionLabel);
        }
        
        var labelGap:Number = Math.min(viewHeight - labelHeight - distanceLabelHeight, layoutGap);
        var labelHeights:Number = labelHeight + distanceLabelHeight + labelGap;
        
        var maneuverY:Number = Math.round(0.5 * (viewHeight - maneuverHeight) + layoutGap);
        setElementPosition(maneuver, layoutGap, maneuverY);
        setElementSize(maneuver, maneuverWidth, maneuverHeight);

        var labelY:Number = Math.max(Math.round(0.5 * (viewHeight - labelHeights) + layoutGap), layoutGap);
        setElementPosition(directionLabel, maneuverWidth + 2 * layoutGap, labelY);
        setElementSize(directionLabel, labelWidth, labelHeight);

        labelY += labelHeight + labelGap;
        setElementPosition(distanceLabel, maneuverWidth + 2 * layoutGap, labelY);
        setElementSize(distanceLabel, labelWidth, labelHeight);
    }

    /**
     * @private
     */
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        var backgroundColor:uint;
        var backgroundAlpha:Number;
        
        if (down || hovered)
        {
            backgroundColor = getStyle("downColor");
            backgroundAlpha = getStyle("downAlpha");
        }
        else
        {
            backgroundColor = getStyle("contentBackgroundColor");
            backgroundAlpha = getStyle("contentBackgroundAlpha");
        }
        
        graphics.beginFill(backgroundColor, backgroundAlpha);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();

        graphics.beginFill(getStyle("borderColor"), getStyle("borderAlpha"));
        graphics.drawRect(0, 0, unscaledWidth, 1);
        if (isLastItem)
        {
            graphics.drawRect(0, unscaledHeight - 1, unscaledWidth, 1);
        }
        graphics.endFill();
    }

    protected function createDirectionLabel():void
    {
        directionLabel = StyleableTextField(createInFontContext(StyleableTextField));
        directionLabel.styleName = this;
        directionLabel.editable = false;
        directionLabel.selectable = false;
        directionLabel.multiline = false;
        directionLabel.wordWrap = true;
        directionLabel.mouseEnabled = false;

        addChild(directionLabel);
    }

    private static const SUBLABEL_SELECTOR:String = getQualifiedClassName(DirectionsDataGroupRenderer).replace("::", ".") + " .subLabel";

    protected function createDistanceLabel():void
    {
        // ycabon:
        // Create the sublabel with the style declaration of the renderer and some extra prop in the .subLabel one.
        distanceLabel = StyleableTextField(createInFontContext(StyleableTextField));
        distanceLabel.styleName = this;
        distanceLabel.styleDeclaration = styleManager.getStyleDeclaration(SUBLABEL_SELECTOR);
        distanceLabel.editable = false;
        distanceLabel.selectable = false;
        distanceLabel.multiline = false;
        distanceLabel.wordWrap = true;
        distanceLabel.mouseEnabled = false;

        addChild(distanceLabel);
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function interactionStateDetector_changeHandler(event:Event):void
    {
        down = (interactionStateDetector.state == InteractionState.DOWN);
        hovered = (interactionStateDetector.state == InteractionState.OVER);
    }
}
}
