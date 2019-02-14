<%
class AntiForgeryToken
    
    private m_SecurityToken

    sub class_initialize()
    end sub
    
    public property get SecurityToken() SecurityToken = m_SecurityToken end property
    
    public function SetCookie()
        m_SecurityToken = CreateWindowsGuid()
        Response.Cookies("RequestVerificationToken") =  m_SecurityToken
        Response.Cookies("RequestVerificationToken").Secure = True
        Response.AddHeader "X-Frame-Options", "SAMEORIGIN"
    end function

    public function GetCookie()
        GetCookie = Request.Cookies("RequestVerificationToken")
    end function
    
    private function CreateWindowsGuid()
        CreateWindowsGuid = CreateGuid(8) & "-" & _
        CreateGuid(4) & "-" & _
        CreateGuid(4) & "-" & _
        CreateGuid(4) & "-" & _
        CreateGuid(12)
    end function
    
    private function CreateGuid(p_Length)
        Randomize Timer
        dim counter
        dim guid
        Const Valid = "0123456789ABCDEF"
        For counter = 1 To p_Length
            guid = guid & Mid(Valid, Int(Rnd(1) * Len(Valid)) + 1, 1)
        Next        
        CreateGuid = guid
    end function
    
    function Validate
        dim formValue
        formValue = Request.Form("RequestVerificationToken")
        dim cookieValue
        cookieValue = GetCookie()
        Response.Write "cookieValue = " & cookieValue & vbCrLf
        Response.Write "formValue = " & formValue & vbCrLf
        Validate = (cookieValue = formValue and Len(cookieValue) > 0)        
    end function
    
end Class
%>