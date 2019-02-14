<%
class MD5CryptoServiceProvider

    private m_Provider

    sub class_initialize()
        set m_Provider = (new CryptoServiceProvider)(server.CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider"))
    end sub

    public function HashBytes(p_Value)
        HashBytes = m_Provider.HashBytes(p_Value)
    end function

end class
%>
