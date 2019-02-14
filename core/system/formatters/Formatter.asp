<%
class Formatter

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

    public function Bool(p_Value)
        set Bool = (new BoolFormatter).Value(p_Value).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

    public function Day(p_Value)
        set Day = (new DayFormatter).Value(p_Value).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

    public function Price(p_Value)
        set Price = (new PriceFormatter).Value(p_Value).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

    public function Number(p_Value)
        set Number = (new NumberFormatter).Value(p_Value).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

    public function Percent(p_Value)
        set Percent = (new PercentFormatter).Value(p_Value).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

    public function Text(p_Value)
        set Text = (new TextFormatter).Value(p_Value).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

    public function Phone(p_Value)
        set Phone = (new PhoneFormatter).Value(p_Value).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

    public function Digit(p_Value, p_Digits)
        set Digit = (new DigitFormatter).Value(p_Value).Digits(p_Digits).fallback(m_FallBack).UseFallback(m_UseFallback)
    end function

end class
%>
