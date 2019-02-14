<%
class HtmlSpan

    private m_Label
    private m_Value
    private m_Result
    private m_Paragraph
    private m_Fallback
    private m_Separator
    private m_br

    sub class_initialize()
        m_br = false
        m_Paragraph = false
    end sub    
    
    public function Fallback(p_Fallback) m_Fallback = p_Fallback : set Fallback = me end function
    public function Label(p_Label) m_Label = p_Label : set Label = me end function
    public function P() m_Paragraph = true : set P = me end function
    public function br() m_br = true : set br = me end function
    public function Value(p_Value) m_Value = p_Value : set Value = me end function
    public function Script(p_Script) m_Properties.Script = p_Script : set Script = me end function

    public default function ToString()
        dim result
        if m_Paragraph then
            result = result & "<p>" & vbcrlf
        end if
        if not IsEmpty(m_Label) then
            result = result & vtab & "<label>"
            if not IsEmpty(m_Separator) then
                result = result & " " & m_Separator & " "
            end if
            result = result & m_Label & "</label> : " & vbcrlf
        end if
        if IsNull(m_Value) or IsEmpty(m_Value) then
            result = result & vtab & "<span>" & m_Fallback & "</span>" & vbcrlf
        else
            result = result & vtab & "<span>" & m_Value & "</span>" & vbcrlf
        end if
        if m_br then
            result = result & "<br />" & vbcrlf
        end if
        if m_Paragraph then
            result = result & "</p>" & vbcrlf
        end if
        ToString = result
    end function

end class
%>
