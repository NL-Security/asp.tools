﻿<%
class PercentFormatter
    private m_Value
    private m_Fallback
    private m_Precision
    private m_TypeName
    private m_UseFallback
    private m_DefaultValue

    sub class_initialize()
        m_Precision = 0
        m_DefaultValue = 0
        m_UseFallback = false
    end sub

    public function DefaultValue(p_DefaultValue)
        m_DefaultValue = p_DefaultValue
        set DefaultValue = me
    end function

    public function UseFallback(p_UseFallback)
        m_UseFallback = p_UseFallback
        set UseFallback = me
    end function

    public function NoFallback()
        m_Fallback = empty
        set NoFallback = me
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
            result = FormatNumber(m_Value, m_Precision) & " %"
        elseif IsNumeric(m_DefaultValue) then
            result = FormatNumber(m_DefaultValue, m_Precision) & " %"
        else
            if m_UseFallback then
                result = m_Fallback
            end if
        end if
        ToString = result
    end function
end class
%>
