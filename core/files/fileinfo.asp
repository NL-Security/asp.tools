<%

class FileInfo
    private m_Path
    private m_Filter
    private m_Starts
    private m_Separator
    private m_Position

    public default function Constructor(p_Path)
        m_Path = p_Path
        set Constructor = me
    end function

    public function Starts(p_Starts, p_Separator, p_Position)
        m_Starts = p_Starts
        m_Separator = p_Separator
        set Starts = me
    end function
    
    public function Filter(p_Filter)
        m_Filter = p_Filter
        set Filter = me
    end function

    public function ToList()
        dim files, file
        set result = createobject("system.collections.arraylist")
        set files = (createobject("scripting.filesystemobject")).GetFolder(m_Path).Files
        for each f in files
            file = Substring(f, m_Path)
            if IsEmpty(m_Starts) or Split(file, m_Separator)(m_Position) = m_Starts then
                if not IsEmpty(m_Filter) then
                    if InStr(file, m_Filter) <> 0 then
                        result.Add file
                    end if
                else
                    result.Add file
                end if
            end if
        next
        set ToList = result
    end function

end class
%>