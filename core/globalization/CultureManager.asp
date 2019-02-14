<%
class CultureManager

    private m_Cultures
    private m_Current
    private m_Provider

    sub class_initialize()
        set m_Cultures = new Dictionary
        m_Cultures.Add "fr-FR", Array("France", "France", "fr-FR", 1036, "{dd/mm/yyyy}", "fr")
        m_Cultures.Add "en-US", Array("France", "France", "en-US", 1033, "{dd/mm/yyyy}", "us")
    end sub

    public default function Constructor(p_Provider)
        set m_Provider = p_Provider
    end function

    public function GetCulture(p_Name)
        set GetCulture = m_Cultures(p_Name)
    end if

end class
%>