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

package com.esri.mobile.skins.mobile.supportClasses
{

import com.esri.ags.components.supportClasses.FormField;
import com.esri.ags.events.FormFieldEvent;
import com.esri.mobile.components.DropDownList;
import com.esri.mobile.components.supportClasses.ItemRenderer;

import flash.utils.getQualifiedClassName;

import mx.controls.DateField;
import mx.core.IDataRenderer;
import mx.core.UIComponent;

import spark.components.DateSpinner;
import spark.components.DropDownList;
import spark.components.supportClasses.StyleableTextField;


public class AttributeInspectorRenderer extends ItemRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Class Contants
    //
    //--------------------------------------------------------------------------

    /**
     *  CSS Selector use for the subLabel.
     */
    private static const SUBLABEL_SELECTOR:String = getQualifiedClassName(AttributeInspectorRenderer).replace("::", ".") + " .subLabel";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function AttributeInspectorRenderer()
    {
        super();
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var m_renderer:UIComponent;

    private var m_refreshRenderer:Boolean = false;

    private var m_refreshRendererData:Boolean = false;


    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var labelDisplay:StyleableTextField;


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  label
    //----------------------------------

    /**
     * @private
     */
    override public function set label(value:String):void
    {
        if (value == label)
        {
            return;
        }

        super.label = value;

        // Push the label down into the labelTextField,
        // if it exists
        if (labelDisplay)
        {
            labelDisplay.text = label;
            invalidateSize();
        }
    }

    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     */
    override public function set data(value:Object):void
    {
        if (this.data != value)
        {
            var formField:FormField = data as FormField;
            if (formField)
            {
                formField.removeEventListener(FormFieldEvent.DATA_CHANGE, handleFieldDataChange);
                formField.removeEventListener(FormFieldEvent.RENDERER_CHANGE, handleFieldRendererChange);
            }
            super.data = value;
            formField = data as FormField;
            if (formField)
            {
                // listen to change of the viewed data
                formField.addEventListener(FormFieldEvent.DATA_CHANGE, handleFieldDataChange, false, 0, true);
                formField.addEventListener(FormFieldEvent.RENDERER_CHANGE, handleFieldRendererChange, false, 0, true);
            }
            m_refreshRenderer = true;
            m_refreshRendererData = true;
        }
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

        if (!labelDisplay)
        {
            labelDisplay = createInFontContext(StyleableTextField) as StyleableTextField;
            labelDisplay.styleName = this;
            labelDisplay.styleDeclaration = styleManager.getStyleDeclaration(SUBLABEL_SELECTOR);
            labelDisplay.editable = false;
            labelDisplay.selectable = false;
            labelDisplay.multiline = false;
            labelDisplay.wordWrap = false;
            labelDisplay.mouseEnabled = false;
            addChild(labelDisplay);
        }
    }


    /**
     * @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (m_refreshRenderer || m_refreshRendererData)
        {
            const formField:FormField = data as FormField;

            var rendererData:Object;

            // Save the renderer data
            if (m_renderer && !m_refreshRendererData && m_renderer is IDataRenderer)
            {
                rendererData = (m_renderer as IDataRenderer).data;
            }

            // Change of activeFeature in the same FeatureLayer
            if (!m_refreshRenderer && m_refreshRendererData)
            {
                formField.updateRenderer(m_renderer);
            }

            // Change of Renderer
            else if (m_refreshRenderer)
            {
                m_refreshRenderer = false;

                // remove the field renderer
                if (m_renderer)
                {
                    removeChild(m_renderer);
                    m_renderer = null;
                }

                if (formField)
                {
                    // add a pre-filled field renderer to the renderer
                    m_renderer = formField.getRendererInstance();
                    m_renderer = swapNonMobileFriendlyComponent(m_renderer);
                    if (m_renderer)
                    {
                        if (!m_refreshRendererData)
                        {
                            (m_renderer as IDataRenderer).data = rendererData;
                        }
                        addChild(m_renderer);
                    }
                }
            }

            m_refreshRenderer = false;
            m_refreshRendererData = false;
        }
    }

    /**
     * @private
     */
    override protected function measure():void
    {
        measuredWidth = 0;
        measuredHeight = 0;

        var labelWidth:Number = 0;
        var labelHeight:Number = 0;
        if (labelDisplay)
        {
            labelWidth = getElementPreferredWidth(labelDisplay);
            labelHeight = getElementPreferredHeight(labelDisplay);
        }

        var rendererWidth:Number = 0;
        var rendererHeight:Number = 0;
        if (m_renderer)
        {
            rendererWidth = getElementPreferredWidth(m_renderer);
            rendererHeight = getElementPreferredHeight(m_renderer);
        }

        measuredWidth = Math.max(labelWidth, rendererWidth) + 2 * layoutGap;
        measuredHeight = layoutGap + labelHeight + rendererHeight + layoutGap * 1.5;
        if (labelDisplay && m_renderer)
        {
            measuredHeight += layoutGap * 1.5;
        }
    }

    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        /* graphics.beginFill(0xEEEEEE, 1.0);
         graphics.drawRect(layoutGap, 0, unscaledWidth - 2 * layoutGap, unscaledHeight);
         graphics.endFill();
         */
        var seperatorY:Number = 0;
        if (labelDisplay)
        {
            seperatorY = getElementPreferredHeight(labelDisplay) + 1.5 * layoutGap;
        }
        graphics.beginFill(0xCCCCCC, 1.0);
        graphics.drawRect(layoutGap, seperatorY, unscaledWidth - 2 * layoutGap, 1);
        graphics.endFill();
    }


    /**
     * @private
     */
    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        var viewWidth:int = unscaledWidth - layoutGap * 2;
        var viewHeight:int = unscaledHeight - layoutGap * 2;

        // Update the Label
        var labelWidth:Number = 0;
        var labelHeight:Number = 0;
        if (labelDisplay)
        {
            labelWidth = getElementPreferredWidth(labelDisplay);
            labelHeight = getElementPreferredHeight(labelDisplay);
            setElementPosition(labelDisplay, layoutGap, layoutGap);
            setElementSize(labelDisplay, Math.min(labelWidth, viewWidth), labelHeight);
        }

        // Update the renderer/editor
        if (m_renderer)
        {
            var rendererWidth:Number = getElementPreferredWidth(m_renderer);
            var rendererHeight:Number = getElementPreferredHeight(m_renderer);
            setElementPosition(m_renderer, layoutGap, 2 * layoutGap * 1.5 + labelHeight);
            setElementSize(m_renderer, Math.min(rendererWidth, viewWidth), viewHeight - labelHeight - layoutGap * 1.5);
        }
    }


    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *
     *
     * @param renderer
     * @return
     */
    private function swapNonMobileFriendlyComponent(renderer:UIComponent):UIComponent
    {
        var result:UIComponent;
        if (renderer is spark.components.DropDownList)
        {
            var dropDownList:spark.components.DropDownList = renderer as spark.components.DropDownList;
            var newDropDownList:com.esri.mobile.components.DropDownList = new com.esri.mobile.components.DropDownList();
            newDropDownList.dataProvider = dropDownList.dataProvider;
            newDropDownList.typicalItem = dropDownList.typicalItem;
            newDropDownList.selectedItem = dropDownList.selectedItem;
            newDropDownList.labelField = "name";
            newDropDownList.enabled = dropDownList.enabled;
            result = newDropDownList;
        }
        else if (renderer is DateField)
        {
            var dateField:DateField = renderer as DateField;
            var dateSpinner:DateSpinner = new DateSpinner();
            var selectedDate:Date = new Date();
            selectedDate.time = dateField.data as Number;
            dateSpinner.selectedDate = selectedDate;
            result = dateSpinner;
        }
        else
        {
            result = renderer;
        }
        return result;
    }


    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * Event handler called when the field renderer updates
     */
    protected function handleFieldRendererChange(event:FormFieldEvent):void
    {
        m_refreshRenderer = true;
        invalidateProperties();
        invalidateDisplayList();
    }

    /**
     * Event handler called when the field renderer updates
     */
    protected function handleFieldDataChange(event:FormFieldEvent):void
    {
        m_refreshRendererData = true;
        invalidateProperties();
        invalidateDisplayList();
    }


}
}
