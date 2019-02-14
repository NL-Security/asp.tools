<%
class fusionoperator

    private m_condition

    public default function constructor(p_value)
        m_condition = not isnull(p_value) and not isempty(p_value)
        set constructor = me
    end function

    function text(p_text)
        text = empty
        if m_condition then
            text = p_text
        end if
    end function

end class
%>
