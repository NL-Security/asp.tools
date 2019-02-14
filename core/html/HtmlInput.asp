<%
class HtmlInput
    
    private m_Properties
    private m_Result

    sub class_initialize()
        set m_Properties = new HtmlElement
    end sub    
    
    public property get Properties() set Properties = m_Properties end property
    
    public function OnChange(p_OnChange) m_Properties.OnChange = p_OnChange : set OnChange = me end function
    public function OnClick(p_OnClick) m_Properties.OnClick = p_OnClick : set OnClick = me end function
    public function Error(p_Error) m_Properties.Error = p_Error : set Error = me end function
    public function Label(p_Label) m_Properties.Label = p_Label : set Label = me end function
    public function P() m_Properties.Paragraph = true : set P = me end function
    public function TypeName(p_TypeName) m_Properties(p_TypeName) : set TypeName = me end function
    public function Id(p_Id) m_Properties.id = p_Id : set Id = me end function
    public function Name(p_Name) m_Properties.Name = p_Name : set Name = me end function
    public function Value(p_Value) m_Properties.Value = p_Value : set Value = me end function
    public function Required() m_Properties.Required = "required" : set Required = me end function
    public function Script(p_Script) m_Properties.Script = p_Script : set Script = me end function
    public function Css(p_Css) m_Properties.Css = p_Css : set Css = me end function
    public function Style(p_Style) m_Properties.Style = p_Style : set Style = me end function
    public function Hide() m_Properties.Css = "w3-hide" : set Hide = me end function
    public function Range() m_Properties.Range = true : set Range = me end function
    public function Float() m_Properties.Float = "any" : set Float = me end function
    public function Checked() m_Properties.Checked = "checked" : set Checked = me end function
    
    function Append(p_PropertyName, p_Value)
        if not IsEmpty(p_Value) then
            m_Result = m_Result & " " & p_PropertyName & "=""" & p_Value & """"
        end if
    end function

    private function WriteLabel()
        if not IsEmpty(m_Properties.Label) then
            m_Result = m_Result & vtab & "<label>" & m_Properties.Label & "</label>" & vbcrlf
        end if
        if not IsEmpty(m_Properties.Required) then
            m_Result = m_Result & "<span class=""w3-text-red""><b>*</b></span>" & vbcrlf
        end if
        if not IsEmpty(m_Properties.Error) then
            m_Result = m_Result & "<span class=""w3-text-red"">" & m_Properties.Error & "</span>" & vbcrlf
        end if
    end function

    public function Build()
        if m_Properties.Paragraph then
            m_Result = m_Result & "<p>" & vbcrlf
        end if
        if m_Properties.TypeName <> "checkbox" then
            WriteLabel
        end if
        m_Properties.Float = "any"
        m_Result = m_Result & vtab & "<input " & m_Properties.ToString() & " />"
        if m_Properties.TypeName = "checkbox" then
            WriteLabel
        end if
        if m_Properties.Paragraph then
            m_Result = m_Result & "</p>" & vbcrlf
        end if
    end function

    public default function ToString()
        Build()
        if m_Properties.Range then
            ToString = Replace(m_Result, m_Properties.Name, m_Properties.Name & "1") & vbcrlf & Replace(m_Result, m_Properties.Name, m_Properties.Name & "2")
        else
            ToString = m_Result
        end if
    end function

end class
%>
