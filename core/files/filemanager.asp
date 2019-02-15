<%
class filemanager

    private m_Directory
    private m_Manager

    sub class_initialize()
        set m_Manager = server.CreateObject("Scripting.FileSystemObject") 
    end sub

    public default function Constructor(p_Directory)
        m_Directory = p_Directory
        set Constructor = me
    end function

    public function GetFiles(p_Extension)
    set folder = m_Manager.GetFolder(m_Directory)
        set GetFiles = folder.files
    end function

    public function TryCreatePath(p_Path)
        dim index
        p_Path = lcase(p_Path)
     
        if Right(p_Path, 1) <> "\" then p_Path = p_Path & "\" 
        if Left(p_Path, 2) = "\\" then 
            index = InStr(3, p_Path, "\") 
        else 
            index = 3 
        end if

        do while index > 0 
            index = InStr(index + 1, p_Path, "\") 
            if not m_Manager.FolderExists(Left(p_Path, index)) and index > 0 then 
                m_Manager.CreateFolder Left(p_Path, index)
            end if 
        loop 

    end function

    public function GetRandomFile()
        set folder = m_Manager.GetFolder(m_Directory)
        set randoms = createobject("system.collections.arraylist")
        index = 0
        for each f in folder.files
            randoms.add f.name
        next
        randomize
        index = int((randoms.count - 1) * rnd)
        GetRandomFile = randoms(index)
        close randoms
    end function

    public function OpenFile(p_FileName)
        dim stream
        set stream = Server.CreateObject("ADODB.Stream")
        with stream
            Response.ContentType = GetMimeTypes(GetExtension(p_FileName))
            Response.AddHeader "content-disposition", "inline;title=" & p_FileName & ";filename=" & p_FileName
            .Open
            .Type = 1
            .LoadFromFile(m_Directory & "\" & replace(p_FileName, "/", "\"))
            Response.BinaryWrite .Read
            Response.Flush()
            .Close
        end with
        set stream = Nothing
    end function

    function GetMimeTypes(p_Extension)
        set mimeTypes = server.CreateObject("scripting.dictionary")
        mimeTypes.Add "dwf", "drawing/x-dwf"
        mimeTypes.Add "jpeg", "image/jpeg"
        mimeTypes.Add "jpg", "image/jpg"
        mimeTypes.Add "png", "image/png"
        mimeTypes.Add "pdf", "application/pdf"
        mimeTypes.Add "doc", "application/msword"
        mimeTypes.Add "docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        GetMimeTypes = mimeTypes(p_Extension)
    end function

    function GetExtension(p_FileName)
        dim items
        items = Split(p_FileName, ".")
        GetExtension = items(UBound(items))
    end function

end class
%>