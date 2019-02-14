<%
class CryptoServiceProvider
    
    private m_Encoder
    private m_Provider

    sub class_initialize()
        set m_Encoder = server.CreateObject("System.Text.UTF8Encoding")
        set m_Provider = server.CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider")
    end sub

    public default function Constructor(p_Provider)
        set m_Provider = p_Provider
        set Constructor = me
    end function

    public function HashBytes(p_Value)
        dim bytes, result
        bytes = GetBytes(p_Value)
        for i = 1 To LenB(bytes)
            result = result & LCase(Right("0" & Hex(AscB(MidB(bytes, i, 1))), 2))
        next
        HashBytes = UCase(result)
    end function

    private function GetBytes(p_Value)
        dim result
        result = m_Provider.ComputeHash_2((m_Encoder.GetBytes_4(p_Value)))
        GetBytes = result
    end function

end class
%>