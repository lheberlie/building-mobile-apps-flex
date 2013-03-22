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

import com.esri.ags.components.Geocoder;
import com.esri.ags.components.supportClasses.DirectionsStop;
import com.esri.ags.skins.supportClasses.DirectionsImageUtil;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import mx.containers.utilityClasses.ConstraintColumn;
import mx.core.DPIClassification;

import spark.components.Button;
import spark.components.Group;
import spark.components.Image;
import spark.components.supportClasses.StyleableTextField;
import spark.layouts.ConstraintLayout;

public class DirectionsStopSkin extends MobileSkin
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
    public function DirectionsStopSkin()
    {
        super();

        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                /* TODO
                measuredDefaultHeight = 48;
                */
                break;
            }
            case DPIClassification.DPI_240:
            {
                /* TODO
                measuredDefaultHeight = 48;
                */
                break;
            }
            default:
            {
                measuredDefaultHeight = 48;
                break;
            }
        }
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    protected var stopIconWidth:int = 32;


    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    private var contentGroup:Group;

    public var stopIcon:Image;
    
    public var geocoder:Geocoder;
    
    public var labelDisplay:StyleableTextField;

    public var deleteStop:Button;

    // public var addStop:Image;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  hostComponent
    //----------------------------------

    public var hostComponent:DirectionsStop;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void
    {
        super.createChildren();

        contentGroup = new Group();

        var layout:ConstraintLayout = new ConstraintLayout();
        var constraintColumns:Vector.<ConstraintColumn> = new Vector.<ConstraintColumn>(3, true);

        var column:ConstraintColumn = new ConstraintColumn();
        column.id = "col1";
        column.width = stopIconWidth;
        constraintColumns[0] = column;

        column = new ConstraintColumn();
        column.id = "col2";
        column.percentWidth = 100;
        constraintColumns[1] = column;

        column = new ConstraintColumn();
        column.id = "col3";
        column.width = measuredDefaultHeight;
        constraintColumns[2] = column;

        layout.constraintColumns = constraintColumns;
        contentGroup.layout = layout;

        stopIcon = new Image();
        stopIcon.id = "stopIcon";
        stopIcon.mouseEnabled = false;
        stopIcon.mouseChildren = false;
        stopIcon.source = DirectionsImageUtil.getStopBitmapData(hostComponent.stopId);
        stopIcon.top = stopIcon.bottom = 0;
        stopIcon.left = "col1:" + layoutGap;
        contentGroup.addElement(stopIcon);
        
        geocoder = new Geocoder();
        geocoder.visible = geocoder.includeInLayout = hostComponent.editable;
        geocoder.id = "geocoder";
        geocoder.autoNavigate = false;
        geocoder.clearButtonVisible = false;
        geocoder.left = "col2:0";
        geocoder.right = "col2:0";
        contentGroup.addElement(geocoder);
        
        labelDisplay = createInFontContext(StyleableTextField) as StyleableTextField;
        labelDisplay.selectable = false;
        labelDisplay.editable = false;
        labelDisplay.wordWrap = false;
        labelDisplay.multiline = false;
        labelDisplay.visible = labelDisplay.includeInLayout = !hostComponent.editable;
        labelDisplay.left = "col2:" + 2 * layoutGap;
        labelDisplay.right = "col2:0";
        contentGroup.addElement(labelDisplay);

        deleteStop = new Button();
        deleteStop.id = "deleteStop";
        deleteStop.styleName = "transparent remove";
        deleteStop.left = "col3:0";
        deleteStop.right = "0";
        contentGroup.addElement(deleteStop);

        addChild(contentGroup);
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        labelDisplay.text = hostComponent.searchTerm;
        labelDisplay.visible = labelDisplay.includeInLayout = !hostComponent.editable;
        geocoder.visible = geocoder.includeInLayout = hostComponent.editable;
        
        invalidateDisplayList();
    }
    
    override protected function measure():void
    {
        super.measure();
        
        measuredWidth = getElementPreferredWidth(contentGroup);
        measuredHeight = getElementPreferredHeight(contentGroup);
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.layoutContents(unscaledWidth, unscaledHeight);

        (contentGroup.layout as ConstraintLayout).constraintColumns[2].explicitWidth = deleteStop.visible ? measuredDefaultHeight : 0;

        contentGroup.setLayoutBoundsPosition(0, 0);
        contentGroup.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
        
        var unscaledTextHeight:Number = Math.max(0, unscaledHeight - 2 * layoutGap);
        var unscaledTextWidth:Number = getElementPreferredWidth(labelDisplay);
        
        // default vertical positioning is centered
        var textHeight:Number = getElementPreferredHeight(labelDisplay);
        var textY:Number = Math.round(0.5 * (unscaledTextHeight - textHeight)) + layoutGap;
        
        // Vertical Alignement
        labelDisplay.commitStyles();
        setElementSize(labelDisplay, unscaledTextWidth, unscaledTextHeight);
        setElementPosition(labelDisplay, layoutGap * 2, textY);
    }

    // Debug
    /*override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0 ,0 , unscaledWidth, unscaledHeight);
        graphics.endFill();
    }*/

}
}
