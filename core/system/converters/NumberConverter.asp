<%
class BitConverter
    private m_Value

    sub class_initialize()
        m_DefaultValue = 0
        m_UseFallback = false
    end sub

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
        result = 0
        if vartype(m_Value) = 8 then
            if Trim(m_Value) = "1" then
                result = 1
            else
                result = 0
            end if
        elseif vartype(m_Value) = 11 then
            if m_Value then
                result = 1
            else
                result = 0
            end if
        elseif IsNumeric(m_Value) then
            if m_Value = 1 then
                result = 1
            else
                result = 0
            end if
            exit function
        end if
    end function
end class
%>
