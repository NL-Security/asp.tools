<%
class List

    private m_Items
    private m_Value
    private m_Text
    
    sub class_initialize()
        set m_Items = server.CreateObject("adodb.recordset")
    end sub
    
    public default function Constructor(p_Items, p_Value, p_Text)
        set m_Items = p_Items
        m_Value = p_Value
        m_Text = p_Text
        set Constructor = me
    end function

    public property get Text() Text = m_Text end property
    public property let Text(p_Text) m_Text = p_Text end property
    public property get Value() Value = m_Value end property
    public property let Value(p_Value) m_Value = p_Value end property
    public property get Items() set Items = m_Items end property
    public property let Items(p_Items) set m_Items = p_Items end property

    public function Item(p_Value)
        do while not m_Items.eof
            if m_Items(m_Value) = p_Value then
                Item = m_Items(m_Text)
                exit do
            end if
            m_Items.MoveNext
        loop
    end function
    
    sub class_terminate()
        set m_Items = nothing
    end sub

end class
%>
