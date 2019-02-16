<%
class CultureInfo

    private m_Name
    private m_DisplayName
    private m_Culture
    private m_LCID
    private m_DateTimeFormat
    private m_WeekFormat
    private m_DayFormat
    private m_PhoneFormat
    private m_TwoLetterISOLanguageName
    private m_CultureInfoProvider
    private m_Prefix
    private m_Cultures

    sub class_initialize()
        set m_Cultures = new Dictionary
        m_Cultures.Add "fr-FR", Array("France", "France", "fr-FR", 1036, "{dd/mm/yyyy}", "fr")
        m_Cultures.Add "en-US", Array("France", "France", "en-US", 1033, "{dd/mm/yyyy}", "us")
    end sub

    public function Build(p_Name)
        Constructor m_Cultures(p_Name)
        set Build = me
    end function

    public default function Constructor(p_Culture)
        m_Name = m_Cultures(p_Culture)(0)
        m_DisplayName = m_Cultures(p_Culture)(1)
        m_Culture = m_Cultures(p_Culture)(2)
        m_LCID = m_Cultures(p_Culture)(3)
        m_DateTimeFormat = m_Cultures(p_Culture)(4)
        m_TwoLetterISOLanguageName = m_Cultures(p_Culture)(5)
        set Constructor = me
    end function

    public property get Name() Name = m_Name end property
    public property let Name(p_Name) Name = p_Name end property

    public property get DisplayName() DisplayName = m_DisplayName end property
    public property let DisplayName(p_DisplayName) m_DisplayName = p_DisplayName end property

    public property get Culture() Culture = m_Culture end property
    public property let Culture(p_Culture) m_Culture = p_Culture end property

    public property get LCID() LCID = m_LCID end property
    public property let LCID(p_LCID) m_LCID = p_LCID end property

    public property get DateTimeFormat() DateTimeFormat = m_DateTimeFormat end property
    public property let DateTimeFormat(p_DateTimeFormat) p_DateTimeFormat = m_DateTimeFormat end property

    public property get WeekFormat() WeekFormat = m_WeekFormat end property
    public property let WeekFormat(p_WeekFormat) p_WeekFormat = m_WeekFormat end property

    public property get DayFormat() DayFormat = m_DayFormat end property
    public property let DayFormat(p_DayFormat) p_DayFormat = m_DayFormat end property

    public property get PhoneFormat() PhoneFormat = m_PhoneFormat end property
    public property let PhoneFormat(p_PhoneFormat) p_PhoneFormat = m_PhoneFormat end property

    public property get TwoLetterISOLanguageName() TwoLetterISOLanguageName = m_TwoLetterISOLanguageName end property
    public property let TwoLetterISOLanguageName(p_TwoLetterISOLanguageName) m_TwoLetterISOLanguageName = p_TwoLetterISOLanguageName end property

    public property get Prefix()
        if IsEmpty(m_Prefix) then
            m_Prefix = lcase(m_TwoLetterISOLanguageName)
        end if
        Prefix = m_Prefix
    end property
end class
%>