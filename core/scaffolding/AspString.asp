<%
class ASPString
    private m_Writer
    private m_Value

    public default function Value(p_Value)
        m_Value = p_Value
        set Value = me
    end function

    public function Lower()
        m_Value = LCase(Mid(m_Value, 1, 1)) & Mid(m_Value, 2)
        set Lower = me
    end function

    public function Upper()
        m_Value = UCase(Mid(m_Value, 1, 1)) & Mid(m_Value, 2)
        set Upper = me
    end function

    public function Pluralize()
        if right(m_Value, 1) = "y" then
            m_Value = Left(m_Value, Len(m_Value) - 1) & "ie"
        elseif right(m_Value, 1) = "s" then
            Pluralize = m_Value
            exit function
        end if
        m_Value = m_Value & "s"
        set Pluralize = me
    end function

    public function ToString()
        ToString = m_Value
    end function

end class

class ASPStringBuilder

    private m_Value

    public function Value(p_Value)
        m_Value = p_Value
        set Value = me
    end function

    public default function Create()
        set Create = (new ASPString).Value(m_Value)
    end function

end class
%>