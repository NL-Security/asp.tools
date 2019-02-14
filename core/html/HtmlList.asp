<%
class HtmlList

    private m_Items
    private m_Properties
    private m_Result
    private m_Key
    private m_Text
    private m_Label
    private m_Paragraph
    private m_Required
    private m_First
    private m_FirstName
    private m_Autosubmit

    sub class_initialize()
        m_First = 0
        m_required = false
        m_Autosubmit = false
        set m_Properties = new HtmlElement
    end sub
    
    public property get Properties() set Properties = m_Properties end property
    
    public function choose() m_first = 1 : set choose = me end function
    public function all() m_first = 2 : set all = me end function
    public function Autosubmit() m_Autosubmit = true : set Autosubmit = me end function
    public function FirstName(p_FirstName) m_FirstName = p_FirstName : set FirstName = me end function
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
    public function Float(p_Float) m_Properties.Float = true : set Float = me end function

    public function First(p_First) m_First = p_First : set First = me end function
    public function Text(p_Text) m_Text = p_Text : set Text = me end function
    public function Key(p_Key) m_Key = p_Key : set Key = me end function
    public function Items(p_Items) set m_Items = p_Items : set Items = me end function

    public default function ToString()
        if m_Properties.Paragraph then
            m_Result = m_Result & "<p>" & vbcrlf
        end if
        if not IsEmpty(m_Properties.Label) then
            m_Result = m_Result & vtab & "<label>" & m_Properties.Label & "</label>" & vbcrlf
        end if
        if not IsEmpty(m_Properties.Required) then
            m_Result = m_Result & "<span class=""w3-text-red""><b>*</b></span>" & vbcrlf
        end if
        if not IsEmpty(m_Properties.Error) then
            m_Result = m_Result & "<span class=""w3-text-red"">" & m_Properties.Error & "</span>" & vbcrlf
        end if
        m_Result = m_Result & vtab & "<select " & m_Properties.ToString
        if m_Autosubmit then
            m_Result = m_Result & " onchange=""this.form.submit()"""
        end if
        m_Result = m_Result & ">" & vbcrlf
        if m_First > 0 then
            m_Result = m_Result & vtab & vtab & "<option value="""">"
            if m_First = 1 then
                m_Result = m_Result & m_FirstName
            else
                m_Result = m_Result & "*"
            end if
            m_Result = m_Result & "</option>" & vbcrlf
        end if
        do while not m_Items.eof
            if vartype(m_Properties.Value) = 11 then
                m_Properties.Value = convert.bit(m_Properties.Value)
            end if
            m_Result = m_Result & vtab & vtab & "<option value=""" & m_Items.Fields(m_Key) & """"
            m_Result = m_Result & " data-value-query=""" & m_Properties.Value & """"
            m_Result = m_Result & " data-value-field=""" & m_Items.Fields(m_Key) & """"
            if not IsNull(m_Properties.Value) then
                if not IsEmpty(m_Properties.Value) and not IsNull(m_Items.Fields(m_Key)) then
                    if CStr(m_Properties.Value) = CStr(m_Items.Fields(m_Key)) then
                        m_Result = m_Result & " selected=""selected"" "
                    end if
                end if    
            end if    
            m_Result = m_Result & ">" & m_Items.Fields(m_Text) & "</option>" & vbcrlf
            m_Items.MoveNext
        loop
        m_Result = m_Result & vtab & "</select>"
        if m_Properties.Paragraph then
            m_Result = m_Result & "</p>" & vbcrlf
        end if
        ToString = m_Result
    end function

end class
%>
