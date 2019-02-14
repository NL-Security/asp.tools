<%
class ArrayList

    private m_Items

    sub class_initialize()
        m_Items = Array
    end sub

    public default function Item(p_Index) 
        if IsObject(m_Items(p_Index)) then
            set Item = m_Items(p_Index)
        else
            Item = m_Items(p_Index)
        end if
    end function

    public function Replace(p_Index, p_Value) 
        if IsObject(p_Value) then
            set m_Items(p_Index) = p_Value
        else
            m_Items(p_Index) = p_Value
        end if
    end function

    public property get Items() Items = m_Items end property

    public property get Count() Count = UBound(m_Items) end property

    public function Add(p_Item)
        newSize = UBound(m_Items) + 1
        redim preserve m_Items(newSize)
        if IsObject(p_Item) then
            set m_Items(newSize) = p_Item
        else
            m_Items(newSize) = p_Item
        end if
        set Add = me
    end function

    public function Remove(p_Item)
        itemIndex = GetIndex(p_Item)
        if itemIndex <> - 1 then
            RemoveAt itemIndex
        end if
        set Remove = me
    end function

    public function TryRemove(p_Item)
        itemIndex = GetIndex(p_Item)
        if itemIndex <> - 1 then
            me.RemoveAt itemIndex
        else
            err.Raise 1200, "Item not found"
        end if
        set TryRemove = me
    end function

    public function RemoveAt(p_Index)
        if p_Index >= 0 and p_Index <= UBound(m_Items) then
            for i = p_Index to UBound(m_Items) - 1
                if IsObject(m_Items(i + 1)) then
                    set m_Items(i) = m_Items(i + 1)
                else
                    m_Items(i) = m_Items(i + 1)
                end if
            next
            redim preserve m_Items(UBound(m_Items) - 1)
        end if
    end function

    public function Exists(p_Item)
        Exists = GetIndex(p_Item) <> -1
    end function

    public function GetIndex(p_Item)
        GetIndex = -1
        for i = 0 to UBound(m_Items)
            if m_Items(i) = p_Item then
                GetIndex = i
                exit function
            end if
        next
    end function

    public function InsertAt(p_Index, byval p_Item)
        if p_Index > UBound(m_Items) then
            me.Add p_Item
        elseif p_Index >= 0 then
            redim preserve m_Items(UBound(m_Items) + 1)
            for i = UBound(m_Items) to p_Index + 1 step -1
                if IsObject(m_Items(i - 1)) then
                    set m_Items(i) = m_Items(i - 1)
                else
                    m_Items(i) = m_Items(i - 1)
                end if
            next
            m_Items(p_Index) = p_Item
        end if
    end function

end class
%>