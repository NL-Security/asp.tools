<%
class Dictionary

    private m_Keys
    private m_Items

    sub class_initialize()
        set m_Keys = new ArrayList
        set m_Items = new ArrayList
    end sub
    
    public property get Count() Count = m_Keys.Count end property
    public property get Keys() Keys = m_Keys.Items end property
    public property get Items() Items = m_Items.Items end property

    public function FromRecordset(p_Recordset)
        do while not p_Recordset.eof
            Add p_Recordset.F
            p_Recordset.MoveNext
        loop
    end function

    public function WithKey(p_Key)
        set WithKey = new ArrayList
        for each k in m_Keys
            if k = p_Key then
                index = m_Keys.GetIndex(k)
                if index <> - 1 then
                    WithKey.Add m_Items(index)
                end if
            end if
        next
    end function

    public function Replace(p_Key, p_Value)
        index = m_Keys.GetIndex(p_Key)
        if index = - 1 then
            err.Raise 1280, "'Replace' - DICTIONARY KEY NOT '" & p_Key & "' FOUND"
        end if
        m_Items.Replace index, p_Value
    end function

    public default function Item(p_Key)
        index = m_Keys.GetIndex(p_Key)
        if index = - 1 then
            err.Raise 1280, "'Item' - DICTIONARY KEY '" & p_Key & "' NOT FOUND"
        end if
        if IsObject(m_Items(index)) then
            set Item = m_Items(index)
        else
            Item = m_Items(index)
        end if
    end function

    public function ItemAt(p_Index)
        Item = m_Items.Item(p_Index)
    end function

    public function Add(p_Key, p_Item)
        if m_Keys.Exists(p_Key) then
            err.Raise 1200, "'Add' - DICTIONARY KEY NOT '" & p_Key & "' FOUND"
        else
            m_Keys.Add p_Key
            m_Items.Add p_Item
        end if
        set Add = me
    end function

    public function Remove(p_Key)
        if m_Keys.Exists(p_Key) then
            index = m_Keys.GetIndex(p_Key)
            m_Keys.RemoveAt index
            m_Items.RemoveAt index
        else
            err.Raise 1200, "'Remove' - DICTIONARY KEY NOT '" & p_Key & "' FOUND"
        end if
    end function
    
    public function InsertAt(p_Index, p_Item, p_Array)
        m_Keys.InsertAt p_Index, p_Key
        m_Items.InsertAt p_Index, p_Item
    end function

    public function RemoveAt(p_Index)
        m_Keys.RemoveAt p_Index
        m_Items.RemoveAt p_Index
    end function

    public function Exists(p_Key)
        Exists = m_Keys.Exists(p_key)
    end function

    sub class_terminate()
        set m_Keys = nothing
        set m_Items = nothing
    end sub

end class
%>