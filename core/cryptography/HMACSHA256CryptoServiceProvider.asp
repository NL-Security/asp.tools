<%
class HMACSHA256CryptoServiceProvider
    
    private m_Provider

    public default function Constructor(p_Key)
        set provider = server.CreateObject("System.Security.Cryptography.HMACSHA256")
        provider.Key = p_Key
        set m_Provider = (new CryptoServiceProvider)(provider)
        set Constructor = me
    end function

    public function HashBytes(p_Value)
        HashBytes = m_Provider.HashBytes(p_Value)
    end function

end class
%>
