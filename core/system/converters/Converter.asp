<%
class Converter

    private m_FallBack
    private m_UseFallback

    sub class_initialize()
        m_UseFallback = false
    end sub

    public function UseFallback(p_UseFallback)
        m_UseFallback = p_UseFallback
        set UseFallback = me
    end function

    public function WithFallback(p_fallback)
        m_FallBack = p_Fallback
        set WithFallback = me
    end function

    public property get Fallback() Fallback = m_Fallback end property
    public property let Fallback(p_Fallback) m_Fallback = p_Fallback end property

    public function Bit(p_Value)
        set Bit = (new BitConverter).Value(p_Value)
    end function

end class
%>
