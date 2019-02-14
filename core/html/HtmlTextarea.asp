<%
class HtmlTextarea
    
    private m_Label
    private m_Paragraph
    private m_Rows
    private m_Properties
    private m_ItemProperties
    private m_Result
    private m_Value
    private m_IsEditor

    sub class_initialize()
        m_IsEditor = false
        set m_Properties = new HtmlElement
    end sub
    
    public function Editor(p_Editor)
        if p_Editor then
            m_IsEditor = true
            m_Properties.Css = "w3-editor"
        else
            m_IsEditor = false
        end if
        set Editor = me
    end function
    public function Label(p_Label) m_Label = p_Label : set Label = me end function
    public function P() m_Paragraph = true : set P = me end function
    public function Rows(p_Rows) m_Properties.Rows = p_Rows : set Rows = me end function
    public function Typename(p_Typename) m_Properties.TypeName = p_Typename : set Typename = me end function
    public function Id(p_Id) m_Properties.id = p_Id : set Id = me end function
    public function Name(p_Name) m_Properties.Name = p_Name : set Name = me end function
    public function Value(p_Value) m_Value = p_Value : set Value = me end function
    public function Required() m_Properties.Required = true : set Required = me end function
    public function Script(p_Script) m_Properties.Script = p_Script : set Script = me end function
    public function Css(p_Css) m_Properties.Css = p_Css : set Css = me end function

    function Append(p_PropertyName, p_Value)
        if not IsEmpty(p_Value) then
            m_ItemProperties = m_ItemProperties & " " & p_PropertyName & "=""" & p_Value & """"
        end if
    end function

    public default function ToString()
        Css "w3-input w3-border"
        if m_Paragraph then
            m_Result = m_Result & "<p>" & vbcrlf
        end if
        if not IsEmpty(m_Label) then
            m_Result = m_Result & vtab & "<label>" & m_Label & "</label><br>" & vbcrlf
        end if
        m_Result = m_Result & "<textarea "
        if not IsEmpty(m_Properties.ToString) then
            m_Result = m_Result & " " & m_Properties.ToString
        end if
        if not IsEmpty(m_ItemProperties) then
            m_Result = m_Result & " " & m_ItemProperties
        end if
        m_Result = m_Result & ">" & m_Value
        m_Result = m_Result & "</textarea>"
        if m_Paragraph then
            m_Result = m_Result & "</p>" & vbcrlf
        end if
        ToString = m_Result
    end function

end class
%>
