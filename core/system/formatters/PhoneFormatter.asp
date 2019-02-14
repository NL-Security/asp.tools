<%
class PhoneFormatter

    private m_Value
    private m_Fallback
    private m_UseFallback

    sub class_initialize()
        m_UseFallback = false
    end sub

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
        dim result, stringformat, i
        stringformat = "## ## ## ## ##"
        if IsNull(m_Value) or IsEmpty(m_Value) then
            if m_UseFallback then
                result = m_Fallback
            end if
        else
            index = 1
            for i = 1 to len(stringformat)
                if index > len(m_value) then exit for
                character = mid(stringformat, i, 1)
                if character = "#" then
                    result = result & mid(m_Value, index, 1)
                    index = index + 1
                else
                    result = result & character
                end if
            next
        end if
        ToString = result
    end function

end class
%>
