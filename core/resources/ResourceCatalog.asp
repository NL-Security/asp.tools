<%
class ResourceCatalog
    private m_Resources

    public function Resources(p_Resources)
        set m_Resources = p_Resources
        set Resources = me
    end function

    public default function Item(p_Key)
        Item = m_Resources(p_Key)
    end function
end class
%>
