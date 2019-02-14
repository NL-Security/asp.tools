<%
class HtmlElement

    private m_Id
    private m_Name
    private m_TypeName
    private m_Value
    private m_Required
    private m_Hide
    private m_Script
    private m_Css
    private m_Result
    private m_Style
    private m_Paragraph
    private m_Label
    private m_Range
    private m_Error
    private m_Rows
    private m_Checked
    private m_OnClick
    private m_OnChange
    private m_Editor
    private m_Icon
    private m_Float

    sub class_initialize()
        m_Range = false
        m_Paragraph = false
        m_Float = empty
    end sub

    public default function Constructor(p_TypeName)
        m_TypeName = p_TypeName
    end function
    
    public property get Icon() Icon = m_Icon end property
    public property let Icon(p_Icon) m_Icon = p_Icon end property
    public property get OnChange() OnChange = m_OnChange end property
    public property let OnChange(p_OnChange) m_OnChange = p_OnChange end property
    public property get OnClick() OnClick = m_OnClick end property
    public property let OnClick(p_OnClick) m_OnClick = p_OnClick end property
    public property get Checked() Checked = m_Checked end property
    public property let Checked(p_Checked) m_Checked = p_Checked end property
    public property get Rows() Rows = m_Rows end property
    public property let Rows(p_Rows) m_Rows = p_Rows end property
    public property get Error() Error = m_Error end property
    public property let Error(p_Error) m_Error = p_Error end property
    public property get Range() Range = m_Range end property
    public property let Range(p_Range) m_Range = p_Range end property
    public property get Label() Label = m_Label end property
    public property let Label(p_Label) m_Label = p_Label end property
    public property get Paragraph() Paragraph = m_Paragraph end property
    public property let Paragraph(p_Paragraph) m_Paragraph = p_Paragraph end property
    public property get Style() Style = m_Style end property
    public property let Style(p_Style) m_Style = p_Style end property
    public property get TypeName() TypeName = m_TypeName end property
    public property let TypeName(p_TypeName) m_TypeName = p_TypeName end property
    public property get Id() Id = m_Id end property
    public property let Id(p_Id) m_Id = p_Id end property
    public property get Name() Name = m_Name end property
    public property let Name(p_Name) m_Name = p_Name end property
    public property get Value() Value = m_Value end property
    public property let Value(p_Value) m_Value = p_Value end property
    public property get Float() Float = m_Float end property
    public property let Float(p_Float) m_Float = p_Float end property
    public property get Required() Required = m_Required end property
    public property let Required(p_Required) m_Required = p_Required end property
    public property get Script() Script = m_Script end property
    public property let Script(p_Script) m_Script = p_Script end property
    public property get Css() Css = m_Css end property
    public property let Css(p_Css) m_Css = m_Css & " " & p_Css end property
    public property get Editor() Editor = m_Editor end property
    public property let Editor(p_Editor) m_Editor = p_Editor end property

    public function Hide() m_Properties.Css = "w3-hide" : set Hide = me end function

    function Append(p_PropertyName, p_Value)
        if not IsEmpty(p_Value) then
            m_Result = m_Result & " " & p_PropertyName & "=""" & p_Value & """"
        end if
    end function

    public function ToString()
        Append "id", m_Id
        Append "name", m_Name
        Append "type", m_TypeName
        Append "value", FormatValue(m_TypeName, m_Value)
        Append "step", m_float
        Append "required", m_Required
        Append "class", m_Css
        Append "rows", m_Rows
        Append "script", m_Script
        Append "style", m_Style
        Append "onchange", m_OnChange
        ToString = m_Result
    end function

    private function FormatValue(p_TypeName, p_Value)
        if p_TypeName = "date" then
            FormatValue = DateInput(p_Value)
        elseif p_TypeName = "number" then
            if not isnull(p_Value) then
                FormatValue = Replace(p_Value, ",", ".")
            end if
        else
            FormatValue = p_Value
        end if
    end function

end class
%>
