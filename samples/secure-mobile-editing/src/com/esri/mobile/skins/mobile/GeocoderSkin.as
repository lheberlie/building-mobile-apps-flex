///////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008-2013 Esri. All Rights Reserved.
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

import com.esri.ags.components.Geocoder;

import flash.display.BlendMode;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayList;
import mx.core.DPIClassification;

import spark.components.BusyIndicator;
import spark.components.Button;
import spark.components.Callout;
import spark.components.CalloutPosition;
import spark.components.Label;
import spark.components.List;
import spark.components.supportClasses.ButtonBase;
import spark.components.supportClasses.DropDownController;
import spark.components.supportClasses.ListBase;
import spark.components.supportClasses.StyleableTextField;
import spark.core.IDisplayText;
import spark.events.DropDownEvent;
import spark.events.IndexChangeEvent;
import spark.skins.mobile.StageTextInputSkin;
import spark.skins.mobile.TextInputSkin;

public class GeocoderSkin extends StageTextInputSkin
{

    protected var layoutGap:Number = 8;
    protected var isFocused:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function GeocoderSkin()
    {
        super();

        addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO

                upBorderSkin = android.skins.mobile320.assets.Button_up;
                downBorderSkin = android.skins.mobile320.assets.Button_down;

                layoutGap = 10;
                layoutPaddingLeft = 20;
                layoutPaddingRight = 20;
                layoutPaddingTop = 20;
                layoutPaddingBottom = 20;
                layoutBorderSize = 2;
                measuredDefaultWidth = 64;
                measuredDefaultHeight = 86;

                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO

                upBorderSkin = android.skins.mobile240.assets.Button_up;
                downBorderSkin = android.skins.mobile240.assets.Button_down;

                layoutGap = 7;
                layoutPaddingLeft = 15;
                layoutPaddingRight = 15;
                layoutPaddingTop = 15;
                layoutPaddingBottom = 15;
                layoutBorderSize = 1;
                measuredDefaultWidth = 48;
                measuredDefaultHeight = 65;

                */

                break;
            }
            default:
            {
                measuredDefaultHeight = 48;
                measuredDefaultWidth = 300;
                layoutBorderSize = 1;
                layoutGap = 8;
                break;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var m_dropDownController:DropDownController;

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    /**
     * @copy com.esri.ags.components.Geocoder#resultList
     */
    public var resultList:ListBase;

    /**
     * @copy com.esri.ags.components.Geocoder#clearButton
     */
    public var clearButton:ButtonBase;

    public var callout:Callout;

    public var busyIndicator:BusyIndicator;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------


    override protected function createChildren():void
    {
        super.createChildren();

        if (!resultList)
        {
            resultList = new List();
            resultList.percentHeight = 100;
            resultList.addEventListener(IndexChangeEvent.CHANGING, listIndexChangeHandler);
            resultList.id = "resultList";
        }

        if (!clearButton)
        {
            clearButton = new Button();
            clearButton.id = "clearButton";
            clearButton.top = 0;
            clearButton.bottom = layoutBorderSize;
            clearButton.styleName = "transparent remove";
            clearButton.addEventListener(MouseEvent.CLICK, clearButtonClickHandler);

            addChild(clearButton);
        }

        if (!busyIndicator)
        {
            busyIndicator = new BusyIndicator();
            busyIndicator.visible = false;
            busyIndicator.includeInLayout = false;
            busyIndicator.blendMode = BlendMode.INVERT;
            busyIndicator.top = layoutBorderSize;
            busyIndicator.bottom = layoutBorderSize;
            addChild(busyIndicator);
        }

        if (!callout)
        {
            callout = new Callout();
            callout.moveForSoftKeyboard = false;
            callout.resizeForSoftKeyboard = true;
            callout.styleName = "dropDownList";
            callout.verticalPosition = CalloutPosition.AFTER;
            callout.horizontalPosition = CalloutPosition.START;
            callout.addElement(resultList);

            m_dropDownController = new DropDownController();
            m_dropDownController.systemManager = systemManager;
            m_dropDownController.closeOnResize = false;
            m_dropDownController.dropDown = callout;
            m_dropDownController.addEventListener(DropDownEvent.OPEN, dropDownControllerOpenHandler);
            m_dropDownController.addEventListener(DropDownEvent.CLOSE, dropDownControllerCloseHandler);
            if (callout)
            {
                m_dropDownController.dropDown = callout;
            }
        }
    }

    override protected function commitCurrentState():void
    {
        super.commitCurrentState();

        if (currentState == "normal" || currentState == "showingSearchResults")
        {
            if (!clearButton.visible)
            {
                invalidateDisplayList();
            }
            clearButton.visible = isFocused;
            busyIndicator.visible = false;
        }
        else
        {
            if (currentState == "searching")
            {
                busyIndicator.visible = true;
            }
            if (clearButton.visible)
            {
                invalidateDisplayList();
            }
            clearButton.visible = false;
        }

        if (currentState == "searching")
        {
            resultList.visible = false;
            resultList.includeInLayout = false;
            m_dropDownController.closeDropDown(false);
        }
        if (currentState == "showingSearchResults")
        {
            resultList.visible = true;
            resultList.includeInLayout = true;
            resultList.dataProvider = (hostComponent as Geocoder).searchResults;
            m_dropDownController.openDropDown();
        }
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);

    }

    //--------------------------------------------------------------------------
    //
    //  Event Handler
    //
    //--------------------------------------------------------------------------

    private function clearButtonClickHandler(event:MouseEvent):void
    {
        m_dropDownController.closeDropDown(false);
    }

    private function removeFromStageHandler(event:Event):void
    {
        m_dropDownController.closeDropDown(false);
    }

    private function listIndexChangeHandler(event:IndexChangeEvent):void
    {
        m_dropDownController.closeDropDown(false);
    }

    private function dropDownControllerOpenHandler(event:Event):void
    {
        callout.open(this, false);
    }

    private function dropDownControllerCloseHandler(event:Event):void
    {
        callout.close();
    }
}
}
