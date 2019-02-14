<%
class JsonReader
    public function Read(p_Path)
        set fileSystem = server.CreateObject("Scripting.FileSystemObject")
        set json = new JsonObject
        if UCase(p_Path) = UCase(fileSystem.GetAbsolutePathName(p_Path)) then
            set Read = json.Parse(server.CreateObject("Scripting.FileSystemObject").OpenTextFile(p_Path, 1).ReadAll())
        else
            set Read = json.Parse(server.CreateObject("Scripting.FileSystemObject").OpenTextFile(server.MapPath(p_Path), 1).ReadAll())
        end if
        set json = nothing
        set fileSystem = nothing
    end function
end class
%>