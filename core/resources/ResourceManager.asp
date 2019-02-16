<%
class ResourceManager

    private m_Resources
    private m_Prefix

    sub class_initialize()
        set m_Resources = server.CreateObject("scripting.dictionary")
        m_Resources.Add "fr", server.CreateObject("scripting.dictionary")
        m_Resources.Add "us", server.CreateObject("scripting.dictionary")
    end sub
    
	public property get Prefix() Prefix = m_Prefix end property
	public property let Prefix(p_Prefix) m_Prefix = p_Prefix end property
    public property get Resources() set Resources = m_Resources end property
    
    public function AddLocale(p_Prefix)
        m_Resources.Add p_Prefix, server.CreateObject("scripting.dictionary")
        set AddLocale = me
    end function

    public function AddCatalog(p_Prefix, p_Key)
        if not m_Resources(p_Prefix).Exists(lcase(p_Key)) then
            m_Resources(p_Prefix).Add lcase(p_Key), server.CreateObject("scripting.dictionary")
        end if
        set AddCatalog = me
    end function

    public function Item(p_Prefix)
        set Item = m_Resources(p_Prefix)
    end function

    public function Write()
        for each k in m_Resources.Keys()
            response.Write k & ":" & m_Resources.Item(k) & vbcrlf
        next
    end function

    public function Localize(p_Catalog)
        set Localize = (new ResourceCatalog).Resources(m_Resources(m_Prefix)(lcase(p_Catalog)))
    end function

    public function Exists(p_Prefix, p_Key)
        Exists = m_Resources(p_Prefix).Exists(lcase(p_Key))
    end function

end class
%>
