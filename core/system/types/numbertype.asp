<%
class NumberType

    private m_Value
    
    function Format(p_Value, p_Precision, p_DefaultValue)
        if IsEmpty(p_Precision) then p_Precision = 0
        number = p_Value
        if querylike("action", "exporter") then
            if IsNullOrEmpty(p_Value) then
                m_Value = numerable(p_DefaultValue, p_Precision)
            else
                m_Value = numerable(p_Value, p_Precision)
            end if
        else
            if IsNullOrEmpty(p_Value) then
                m_Value = p_DefaultValue
            else
                m_Value = FormatNumber(p_Value, p_Precision)
            end if
        end if
    end function

    public default function ToString()
        set ToString = m_Value
    end function

end class
%>
