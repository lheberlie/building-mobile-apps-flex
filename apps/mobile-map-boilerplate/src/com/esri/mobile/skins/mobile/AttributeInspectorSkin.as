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

import com.esri.ags.components.AttributeInspector;
import com.esri.ags.skins.fieldClasses.CodedValueDomainField;
import com.esri.ags.skins.fieldClasses.DoubleField;
import com.esri.ags.skins.fieldClasses.IntegerField;
import com.esri.ags.skins.fieldClasses.LabelField;
import com.esri.ags.skins.fieldClasses.RangeDomainField;
import com.esri.ags.skins.fieldClasses.StringField;
import com.esri.ags.skins.fieldClasses.TextField;
import com.esri.ags.skins.fieldClasses.TypeField;
import com.esri.ags.skins.supportClasses.AttributeInspectorRenderer;
import com.esri.mobile.skins.mobile.supportClasses.MobileSkin;

import mx.core.ClassFactory;
import mx.core.IFactory;

import spark.components.Button;
import spark.components.Label;
import spark.components.List;
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalLayout;

public class AttributeInspectorSkin extends MobileSkin
{

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function AttributeInspectorSkin()
    {
        super();
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:AttributeInspector;

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    public var list:List;

    public var nextButton:Button;

    public var previousButton:Button;

    public var deleteButton:Button;

    public var okButton:Button;

    public var editSummaryLabel:Label;


    public var labelField:IFactory = new ClassFactory(LabelField);

    public var memoField:IFactory = new ClassFactory(TextField); //fieldClasses:MemoField

    public var typeField:IFactory = new ClassFactory(TypeField);

    public var codedValueDomainField:IFactory = new ClassFactory(CodedValueDomainField);

    public var dateField:IFactory = new ClassFactory(TextField); //fieldClasses:CalendarField

    public var textField:IFactory = new ClassFactory(TextField);

    public var stringField:IFactory = new ClassFactory(StringField);

    public var integerField:IFactory = new ClassFactory(IntegerField);

    public var doubleField:IFactory = new ClassFactory(DoubleField);

    public var rangeDomainField:IFactory = new ClassFactory(RangeDomainField);

    public var singleField:IFactory = new ClassFactory(DoubleField);

    public var smallIntegerField:IFactory = new ClassFactory(IntegerField);


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  label
    //----------------------------------

    public var aProperty:Number;

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void
    {
        super.createChildren();

        if (!list)
        {
            list = new List();
            var layout:VerticalLayout = new VerticalLayout();
            layout.gap = layoutGap;
            layout.horizontalAlign = HorizontalAlign.JUSTIFY;
            list.layout = layout;
            list.setStyle("horizontalScrollPolicy", "off");
            list.itemRenderer = new ClassFactory(com.esri.mobile.skins.mobile.supportClasses.AttributeInspectorRenderer);
            addChild(list);
        }
    }

    override protected function measure():void
    {
        super.measure();

        measuredWidth = getElementPreferredWidth(list);
        measuredHeight = getElementPreferredHeight(list);
    }

    override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
    {
        setElementPosition(list, 0, 0);
        setElementSize(list, unscaledWidth, unscaledHeight);
    }

    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------




}
}
