<%
class PriceFormatter
    private m_Value
    private m_Fallback
    private m_Precision
    private m_TypeName
    private m_UseFallback

    sub class_initialize()
        m_Precision = 2
        m_DefaultValue = 0
        m_UseFallback = false
    end sub

    public function Precision(p_Precision)
        m_Precision = p_Precision
        set Precision = me
    end function

    public function UseFallback(p_UseFallback)
        m_UseFallback = p_UseFallback
        set UseFallback = me
    end function

    public function Fallback(p_Fallback)
        m_Fallback = p_Fallback
        set Fallback = me
    end function

    public function Value(p_Value)
        m_Value = p_Value
        set Value = me
    end function

    public default function ToString()
        dim result
        if IsNumeric(m_Value) then
            result = FormatCurrency(m_Value, m_Precision)
        elseif IsNumeric(m_DefaultValue) then
            result = FormatCurrency(m_DefaultValue, m_Precision)
        else
            if m_UseFallback then
                result = m_Fallback
            end if
        end if
        ToString = result
    end function
end class
%>
