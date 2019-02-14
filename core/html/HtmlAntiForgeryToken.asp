<%
class HtmlAntiForgeryToken

    private m_Token

    sub class_initialize()
        m_Paragraph = false
    end sub    
    
    public function Token(p_Token) m_Token = p_Token : set Token = me end function

    public default function ToString()
        ToString = "<input name=""RequestVerificationToken"" type=""hidden"" value=""" & m_Token & """ />"
    end function

end class
%>
