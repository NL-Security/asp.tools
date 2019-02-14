<%
class BoolFormatter

    private m_Value
    private m_DefaultValue
    private m_Fallback
    private m_UseFallback

    sub class_initialize()
        m_UseFallback = false
    end sub

    public function Value(p_Value)
        m_Value = p_Value
        set Value = me
    end function

    public function UseFallback(p_UseFallback)
        m_UseFallback = p_UseFallback
        set UseFallback = me
    end function

    public function Fallback(p_Fallback)
        m_Fallback = p_Fallback
        set Fallback = me
    end function

    public default function ToString()
        dim result
        result = false
        if IsNull(m_Value) or IsEmpty(m_Value) then
            if m_UseFallback then
                if not IsEmpty(m_Fallback) then
                    result = m_Fallback
                end if
            end if
        else
            if vartype(m_Value) = 11 then
                if m_Value then
                    result = m_Value
                end if
            elseif m_Value = 1 or m_Value = "1" then
                result = true
            end if        
            if result then
                ToString = "Oui"
            else
                ToString = "Non"
            end if
        end if

    end function

end class
%>
