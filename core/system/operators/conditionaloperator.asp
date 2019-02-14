<%
class conditionaloperator

    private m_condition

    public default function constructor(p_Condition)
        m_condition = p_condition
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
