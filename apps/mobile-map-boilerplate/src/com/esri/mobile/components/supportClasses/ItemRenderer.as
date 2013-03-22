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

import flash.events.Event;

import mx.core.DPIClassification;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.ILayoutElement;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import spark.components.IItemRenderer;
import spark.components.supportClasses.InteractionState;
import spark.components.supportClasses.InteractionStateDetector;
import spark.components.supportClasses.StyleableTextField;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Color of the text.
 * 
 *  <p><b>For the Mobile theme, If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style color,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style color.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#color
 *  @see spark.components.supportClasses.StyleableTextField#style:color
 *  @see spark.components.supportClasses.StyleableStageText#style:color
 * 
 *  @default 0x000000
 */
[Style(name="color", type="uint", format="Color", inherit="yes")]

/**
 *  The name of the font to use, or a comma-separated list of font names.
 *
 *  <p><b>If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontFamily,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontFamily.</b></p>
 * 
 *  <p>The default value for the Spark theme is <code>Arial</code>.
 *  The default value for the Mobile theme is <code>_sans</code>.</p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontFamily
 *  @see spark.components.supportClasses.StyleableStageText#style:fontFamily
 *  @see spark.components.supportClasses.StyleableTextField#style:fontFamily
 */
[Style(name="fontFamily", type="String", inherit="yes")]

/**
 *  Height of the text, in pixels.
 * 
 *  <p><b>For the Mobile theme, If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontSize,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontSize.</b></p>
 * 
 *  <p>The default value for the Spark theme is <code>12</code>.
 *  The default value for the Mobile theme is <code>24</code>.</p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontSize
 *  @see spark.components.supportClasses.StyleableStageText#style:fontSize
 *  @see spark.components.supportClasses.StyleableTextField#style:fontSize
 */
[Style(name="fontSize", type="Number", format="Length", inherit="yes", minValue="1.0", maxValue="720.0")]

/**
 *  Determines whether the text is italic font.
 *
 *  <p><b>If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontStyle,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontStyle.</b></p>
 * 
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontStyle
 *  @see spark.components.supportClasses.StyleableStageText#style:fontStyle
 *  @see spark.components.supportClasses.StyleableTextField#style:fontStyle
 */
[Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]

/**
 *  Determines whether the text is boldface.
 *
 *  <p><b>If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style fontWeight,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style fontWeight.</b></p>
 * 
 *  @see flashx.textLayout.formats.ITextLayoutFormat#fontWeight
 *  @see spark.components.supportClasses.StyleableStageText#style:fontWeight
 *  @see spark.components.supportClasses.StyleableTextField#style:fontWeight
 */
[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]

/**
 *  Additional vertical space between lines of text.
 *
 *  <p><b>If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableStageText Style fontWeight
 *  and if using StyleableStageText, this is not supported.</b></p>
 * 
 *  @see spark.components.supportClasses.StyleableTextField#style:leading
 *  @see #style:lineHeight
 */
[Style(name="leading", type="Number", format="Length", inherit="yes", theme="mobile")]

/**
 *  The number of additional pixels to appear between each character.
 * 
 *  <p><b>If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField.letterSpacing 
 *  and if using StyleableStageText, this is not supported.</b></p>
 *
 *  @see spark.components.supportClasses.StyleableTextField#style:letterSpacing
 */
[Style(name="letterSpacing", type="Number", inherit="yes", theme="mobile")]


/**
 *  Alignment of text within a container.
 *
 *  <p><b>If using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style textAlign,
 *  and if using StyleableStageText,
 *  see spark.components.supportClasses.StyleableStageText Style textAlign.</b></p>
 * 
 *  @see flashx.textLayout.formats.ITextLayoutFormat#textAlign
 *  @see spark.components.supportClasses.StyleableStageText#style:textAlign
 *  @see spark.components.supportClasses.StyleableTextField#style:textAlign
 */
[Style(name="textAlign", type="String", enumeration="start,end,left,right,center,justify", inherit="yes")]

/**
 *  Determines whether the text is underlined.
 *
 *  <p><b>For the Mobile theme, if using StyleableTextField,
 *  see spark.components.supportClasses.StyleableTextField Style textDecoration,
 *  and if using StyleableStageText, this is not supported.</b></p>
 *
 *  @see flashx.textLayout.formats.ITextLayoutFormat#textDecoration
 *  @see spark.components.supportClasses.StyleableTextField#style:textDecoration
 */
[Style(name="textDecoration", type="String", enumeration="none,underline", inherit="yes")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>data</code> property changes.
 * 
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]


/**
 * 
 */
public class ItemRenderer extends UIComponent implements IItemRenderer
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
    public function ItemRenderer()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO
                layoutGap = 8;
                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO
                layoutGap = 8;
                */
                break;
            }
            default:
            {
                layoutGap = 8;
                measuredDefaultWidth = 300;
                measuredDefaultHeight = 48;
                break;
            }
        }

        interactionStateDetector = new InteractionStateDetector(this);
        interactionStateDetector.addEventListener(Event.CHANGE, interactionStateDetectorChangeHandler);

        cacheAsBitmap = true;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var interactionStateDetector:InteractionStateDetector;

    /**
     *  @copy spark.skins.mobile.supportClasses.MobileSkin#measuredDefaultWidth
     */
    protected var measuredDefaultWidth:Number = 0;

    /**
     *  @copy spark.skins.mobile.supportClasses.MobileSkin#measuredDefaultHeight
     */
    protected var measuredDefaultHeight:Number = 0;

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
    //  data
    //----------------------------------

    private var m_data:Object;
    private var m_dataChanged:Boolean = false;

    /**
     *  @private
     */
    public function get data():Object
    {
        return m_data;
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        if (m_data != value)
        {
            m_data = value;
            m_dataChanged = true;
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            invalidateProperties();
        }
    }

    //----------------------------------
    //  itemIndex
    //----------------------------------

    private var m_itemIndex:int;

    /**
     *  @private
     */
    public function get itemIndex():int
    {
        return m_itemIndex;
    }

    /**
     *  @private
     */
    public function set itemIndex(value:int):void
    {
        m_itemIndex = value;
    }

    //----------------------------------
    //  dragging
    //----------------------------------

    private var m_dragging:Boolean;

    /**
     *  @private
     */
    public function get dragging():Boolean
    {
        return m_dragging;
    }

    /**
     *  @private
     */
    public function set dragging(value:Boolean):void
    {
        m_dragging = value;
    }

    //----------------------------------
    //  label
    //----------------------------------

    private var m_label:String;

    /**
     *  @private
     */
    public function get label():String
    {
        return m_label;
    }

    /**
     *  @private
     */
    public function set label(value:String):void
    {
        m_label = value;
    }

    //----------------------------------
    //  selected
    //----------------------------------

    private var m_selected:Boolean;

    /**
     *  @private
     */
    public function get selected():Boolean
    {
        return m_selected;
    }

    /**
     *  @private
     */
    public function set selected(value:Boolean):void
    {
        m_selected = value;
    }

    //----------------------------------
    //  showsCaret
    //----------------------------------

    private var m_showCaret:Boolean;

    /**
     *  @private
     */
    public function get showsCaret():Boolean
    {
        return m_showCaret;
    }

    /**
     *  @private
     */
    public function set showsCaret(value:Boolean):void
    {
        m_showCaret = value;
    }

    //----------------------------------
    //  down
    //----------------------------------

    /**
     *  @private
     */
    private var m_down:Boolean = false;

    /**
     *  @private
     */
    protected function get down():Boolean
    {
        return m_down;
    }

    /**
     *  @private
     */
    protected function set down(value:Boolean):void
    {
        if (value != m_down)
        {
            m_down = value;
            invalidateDisplayList();
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
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (m_dataChanged)
        {
            m_dataChanged = false;
            commitData();
            invalidateDisplayList();
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        measuredWidth = measuredDefaultWidth;
        measuredHeight = measuredDefaultHeight;
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        graphics.clear();

        super.updateDisplayList(unscaledWidth, unscaledHeight);

        layoutContents(unscaledWidth, unscaledHeight);

        /*if (useSymbolColor)
        applySymbolColor();*/

        drawBackground(unscaledWidth, unscaledHeight);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    protected function positionAndSizeLabel(labelDisplay:StyleableTextField,
                                            viewWidth:Number,
                                            viewHeight:Number,
                                            startX:Number,
                                            layoutGap:int,
                                            verticalAlign:String = "middle"):void
    {
        var vAlign:Number;
        var labelWidth:Number;
        var labelHeight:Number;
        var labelY:int;

        if (verticalAlign == "top")
        {
            vAlign = 0;
        }
        else if (verticalAlign == "bottom")
        {
            vAlign = 1;
        }
        else // if (verticalAlign == "middle")
        {
            vAlign = 0.5;
        }

        // measure the label component
        // text should take up the rest of the space width-wise, but only let it take up
        // its measured textHeight so we can position it later based on verticalAlign
        labelWidth = Math.max(viewWidth, 0);
        labelHeight = 0;

        if (labelDisplay.text != "")
        {
            labelDisplay.commitStyles();

            // reset text if it was truncated before.
            if (labelDisplay.isTruncated)
            {
                labelDisplay.text = labelDisplay.text;
            }

            labelHeight = getElementPreferredHeight(labelDisplay);
        }

        setElementSize(labelDisplay, labelWidth, labelHeight);

        // We want to center using the "real" ascent
        labelY = Math.round(vAlign * (viewHeight - labelHeight)) + layoutGap;
        setElementPosition(labelDisplay, startX + layoutGap, labelY);

        // attempt to truncate the text now that we have its official width
        labelDisplay.truncateToFit();
    }

    /**
     *  @copy spark.skins.mobile.supportClasses.MobileSkin#getElementPreferredWidth()
     */
    protected function getElementPreferredWidth(element:Object):Number
    {
        var result:Number;

        if (element is ILayoutElement)
        {
            result = ILayoutElement(element).getPreferredBoundsWidth();
        }
        else if (element is IFlexDisplayObject)
        {
            result = IFlexDisplayObject(element).measuredWidth;
        }
        else
        {
            result = element.width;
        }

        return Math.round(result);
    }

    /**
     *  @copy spark.skins.mobile.supportClasses.MobileSkin#getElementPreferredHeight()
     */
    protected function getElementPreferredHeight(element:Object):Number
    {
        var result:Number;

        if (element is ILayoutElement)
        {
            result = ILayoutElement(element).getPreferredBoundsHeight();
        }
        else if (element is IFlexDisplayObject)
        {
            result = IFlexDisplayObject(element).measuredHeight;
        }
        else
        {
            result = element.height;
        }

        return Math.ceil(result);
    }

    /**
     *  @copy spark.skins.mobile.supportClasses.MobileSkin#setElementPosition()
     */
    protected function setElementPosition(element:Object, x:Number, y:Number):void
    {
        if (element is ILayoutElement)
        {
            ILayoutElement(element).setLayoutBoundsPosition(x, y, false);
        }
        else if (element is IFlexDisplayObject)
        {
            IFlexDisplayObject(element).move(x, y);
        }
        else
        {
            element.x = x;
            element.y = y;
        }
    }


    /**
     *  @copy spark.skins.mobile.supportClasses.MobileSkin#setElementSize()
     */
    protected function setElementSize(element:Object, width:Number, height:Number):void
    {
        if (element is ILayoutElement)
        {
            ILayoutElement(element).setLayoutBoundsSize(width, height, false);
        }
        else if (element is IFlexDisplayObject)
        {
            IFlexDisplayObject(element).setActualSize(width, height);
        }
        else
        {
            element.width = width;
            element.height = height;
        }
    }

    /**
     * @private
     */
    protected function commitData():void
    {

    }

    /**
     * @private
     */
    protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {

    }

    /**
     * @private
     */
    protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {

    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    protected function interactionStateDetectorChangeHandler(event:Event):void
    {
        down = (interactionStateDetector.state == InteractionState.DOWN);
    }
}
}
