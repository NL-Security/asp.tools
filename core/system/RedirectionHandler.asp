<%
class GenericRedirection
    private m_URL
    private m_When

    sub class_initialize()
        m_When = true
    end sub

    public function URL(p_URL)
        if m_When then response.Redirect p_URL
        set URL = me
    end function

    public function When(p_When)
        m_When = p_When
        set When = me
    end function
end class

class RedirectionHandler
    public default function Url(p_URL)
        set Url = (new GenericRedirection).URL(p_URL)
    end function

    public function When(p_When)
        set When = (new GenericRedirection).When(p_When)
    end function
end class
%>