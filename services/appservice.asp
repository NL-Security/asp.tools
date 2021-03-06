﻿<%
class appservicebase

    private db
    private m_FileManager
    private writer
    private fileSystem
    private m_Logs

	sub class_initialize()
        set m_Logs = server.CreateObject("scripting.dictionary")
        set fileSystem = server.CreateObject("Scripting.FileSystemObject") 
        set m_FileManager = new FileManager
        set writer = new ASPWriter
	end sub

    public function real_area(p_area)
        if p_area <> "" then
            real_area = lcase("/" & p_area)
        else
            real_area = empty
        end if
    end function

    public function virtual_area(p_area)
        if not isempty(p_area) and p_area <> "" then
            virtual_area = lcase("/areas/" & p_area)
        else
            virtual_area = empty
        end if
    end function

    'CreateNavigationLinks
    public function CreateNavigationLinks(p_Path, p_Models)
        if fileSystem.FileExists(p_Path) then
            set file = fileSystem.OpenTextFile(p_Path & "/Navigation.asp", true)
        else
            set file = fileSystem.CreateTextFile(p_Path & "/Navigation.asp", true)
        end if
        set tables = schemaservice.GetTables(empty)
        do while not tables.eof
            m_Logs.add tables("Table_Name").Value, empty
            table_name = lcase(tables("Table_Name").Value)
            if table_name <> "sysdiagrams" then
                string_builder = "<%=html.navitem(""" & real_area(request.QueryString("area")) & "/" & table_name & """).label(strings(""" & pluralize(table_name) & """)).tostring" &  " %" & ">"
                file.WriteLine string_builder
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
        file.close
        set file = nothing
    end function

    'CreateResources
    public function CreateResources(p_Path, p_Models)
        set tables = schemaservice.GetModels(empty)
        do while not tables.EOF
            if ArrayContains(p_Models, tables("Table_Name").Value) then
                table_name = lcase(tables("Table_Name").Value)
                if fileSystem.FileExists(p_Path) then
                    set file = fileSystem.OpenTextFile(p_Path & "/" & lcase(tables("Table_Name").Value) & ".asp", true)
                else
                    set file = fileSystem.CreateTextFile(p_Path & "/" & lcase(tables("Table_Name").Value) & ".asp", true)
                end if
                file.WriteLine "<%"
                file.WriteLine "resources.addcatalog ""fr"", """ & table_name & """"
                file.WriteLine "with resources.Item(""fr"")(""" & table_name & """)"
                set columns = schemaservice.GetColumns(table_name)
                do while not columns.EOF
                    file.WriteLine vbtab & ".add """ & lcase(columns("Column_Name")) & """, """ & lcase(columns("Column_Name")) & """"
                    columns.MoveNext
                loop
                set columns = nothing
                file.WriteLine "end with"
                file.WriteLine "%" & ">"
                file.close
                set file = nothing
                m_Logs.add p_Path & "/" & tables("Table_Name").Value & ".asp", tables("Table_Name").Value
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
    end function

    'CreateResourcesAssembly
    public function CreateResourcesAssembly(p_Path, p_Models)
        if fileSystem.FileExists(p_Path) then
            set file = fileSystem.OpenTextFile(p_Path & "/resources/models/_assembly.asp", true)
        else
            set file = fileSystem.CreateTextFile(p_Path & "/resources/models/_assembly.asp", true)
        end if
        set tables = schemaservice.GetTables(empty)
        do while not tables.EOF
            if ArrayContains(p_Models, CStr(tables("Table_Name").Value)) then
                table_name = lcase(tables("Table_Name").Value)
                if table_name <> "sysdiagrams" then
                    file.WriteLine "<!--#include virtual=""/resources/models/" & tables("Table_Name") & ".asp""-->"
                end if
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
        file.close
        set file = nothing
    end function

    'CreateControllers
	public function CreateControllers(p_Path, p_Models, p_Prefix, p_WithViews)
        engine_URL = empty
        set tables = schemaservice.GetTables(empty)
        engine_URL = request.ServerVariables("SERVER_NAME")
        if request.ServerVariables("HTTPS") = "on" then
            engine_URL = "https://" & engine_URL
        else
            engine_URL = "http://" & engine_URL
        end if
        engine_URL = engine_URL & ":" & request.ServerVariables("SERVER_PORT")
        engine_URL = engine_URL & "/Scaffolding/Controllers"
        do while not tables.EOF
            if ArrayContains(p_Models, CStr(tables("Table_Name").Value)) then
                if tables("table_name") <> "sysdiagrams" then
                    m_FileManager.TryCreatePath p_Path & "\controllers\"
                    CreateFile p_Path & "\Controllers\" & tables("table_name") & "controller.asp", engine_URL & "/" & p_Prefix & "controller.asp?table_name=" & tables("table_name") & "&project=" & session("project") & "&area=" & request.QueryString("area")
                end if
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
	end function

    'CreateControllersAssembly
    public function CreateControllersAssembly(p_Path, p_Models)
        if request.QueryString("area") <> "" then
            area_directory = lcase(scaffolding_directory & "/areas/" & request.QueryString("area"))
        end if
        if fileSystem.FileExists(p_Path) then
            set file = fileSystem.OpenTextFile(p_Path & "/Controllers/_assembly.asp", true)
        else
            set file = fileSystem.CreateTextFile(p_Path & "/Controllers/_assembly.asp", true)
        end if
        set tables = schemaservice.GetTables(empty)
        do while not tables.EOF
            if ArrayContains(p_Models, CStr(tables("Table_Name").Value)) then
                table_name = lcase(tables("Table_Name").Value)
                if table_name <> "sysdiagrams" then
                    file.WriteLine "<!--#include virtual=""" & area_directory & "/controllers/" & lcase(tables("Table_Name")) & "controller.asp""-->"
                end if
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
        file.close
        set file = nothing
    end function

    'CreateViews
	public function CreateViews(p_Path, p_Models, p_Templates)
        engine_URL = request.ServerVariables("SERVER_NAME")
        if request.ServerVariables("HTTPS") = "on" then
            engine_URL = "https://" & engine_URL
        else
            engine_URL = "http://" & engine_URL
        end if
        engine_URL = engine_URL & ":" & request.ServerVariables("SERVER_PORT")
        engine_URL = engine_URL & "/Scaffolding/Views"
        set tables = schemaservice.GetTables(empty)
        do while not tables.EOF
            if ArrayContains(p_Models, CStr(tables("Table_Name").Value)) then
                set folder = fileSystem.GetFolder(server.MapPath("/Scaffolding/Views"))
                for each f in folder.Files
                    if ArrayContains(p_Templates, f.Name) or IsEmpty(p_Templates) then
                        m_FileManager.TryCreatePath p_Path & "\views\" & tables("table_name")
                        CreateFile p_Path & "\views\" & tables("table_name") & "\" & f.Name, engine_URL & "/" & f.Name & "?table_name=" & tables("table_name") & "&project=" & session("project") & "&area=" & request.QueryString("area") & "&jointures=" & session("jointures")
                    end if
                next
                close folder
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
	end function

    'CreateTemplates
	public function CreateTemplates(p_Path, p_Models, p_Templates)
        engine_URL = request.ServerVariables("SERVER_NAME")
        if request.ServerVariables("HTTPS") = "on" then
            engine_URL = "https://" & engine_URL
        else
            engine_URL = "http://" & engine_URL
        end if
        engine_URL = engine_URL & ":" & request.ServerVariables("SERVER_PORT")
        engine_URL = engine_URL & "/Scaffolding/Views/_shared/" & "Templates"
        set tables = schemaservice.GetTables(empty)
        do while not tables.EOF
            if ArrayContains(p_Models, CStr(tables("Table_Name").Value)) then
                set folder = fileSystem.GetFolder(server.MapPath("/Scaffolding/Views/_shared/" & "templates"))
                for each f in folder.Files
                    if ArrayContains(p_Templates, f.Name) or IsEmpty(p_Templates) then
                        m_FileManager.TryCreatePath p_Path & "\views\_shared\templates\" & tables("table_name")
                        CreateFile p_Path & "\views\_shared\templates\" & tables("table_name") & "\" & f.Name, engine_URL & "/" & f.Name & "?table_name=" & tables("table_name") & "&project=" & session("project") & "&area=" & request.QueryString("area")
                    end if
                next
                close folder
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
	end function

    'CreateRepositories
	public function CreateRepositories(p_Path, p_Models, p_Prefix)
        '+ créer fichier _assembly dans le dossier
        engine_URL = empty
        set tables = schemaservice.GetTables(empty)
        engine_URL = request.ServerVariables("SERVER_NAME")
        if request.ServerVariables("HTTPS") = "on" then
            engine_URL = "https://" & engine_URL
        else
            engine_URL = "http://" & engine_URL
        end if
        engine_URL = engine_URL & ":" & request.ServerVariables("SERVER_PORT")
        engine_URL = engine_URL & "/Scaffolding/Repositories"
        do while not tables.EOF
            if ArrayContains(p_Models, CStr(tables("Table_Name").Value)) then
                if tables("table_name") <> "sysdiagrams" then
                    m_FileManager.TryCreatePath p_Path & "/Repositories/"
                    CreateFile p_Path & "/repositories/" & tables("table_name") & "repository.asp", engine_URL & "/" & p_Prefix & "Repository.asp?table_name=" & tables("table_name") & "&project=" & session("project")
                end if
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
	end function

    'CreateRepositoriesAssembly
    public function CreateRepositoriesAssembly(p_Path, p_Models)
        if fileSystem.FileExists(p_Path) then
            set file = fileSystem.OpenTextFile(p_Path & "/Repositories/_assembly.asp", true)
        else
            set file = fileSystem.CreateTextFile(p_Path & "/Repositories/_assembly.asp", true)
        end if
        set tables = schemaservice.GetTables(empty)
        do while not tables.EOF
            if ArrayContains(p_Models, CStr(tables("Table_Name").Value)) then
                table_name = lcase(tables("Table_Name").Value)
                if table_name <> "sysdiagrams" then
                    file.WriteLine "<!--#include virtual=""/repositories/" & tables("Table_Name") & "repository.asp""-->"
                end if
            end if
            tables.MoveNext
        loop
        tables.Close
        set tables = nothing
        file.close
        set file = nothing
    end function
    
    'CreateFile
    private function CreateFile(p_FileName, p_URL)
        p_FileName = lcase(p_FileName)
        m_Logs.add p_FileName, p_URL
        set engine = new TemplateEngine
        engine.FileName = p_FileName
        engine_URL = p_URL
        engine.exe engine_URL, 2
    end function

	sub class_terminate()
        set db = nothing
        set fileSystem = nothing
        set m_FileManager = nothing
	end sub

end class
%>