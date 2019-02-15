<%
class schemaservicebase

    private m_Connection

	sub class_initialize()
        set m_Connection = server.CreateObject("adodb.connection")
	end sub

    public function ConnectJsonConfig(p_ConfigPath)
        set json = (new jsonreader).read(p_ConfigPath & "\config.json")
        me.connect json("ConnectionStrings")("DefaultConnection")
        close json
        set ConnectJsonConfig = me
    end function

    public function Connect(p_ConnectionString)
        m_Connection.Open p_ConnectionString
        set Connect = me
    end function
    
    'Join
    public function sqljoin(p_tablename)
         dim foreignKeys
         sqljoin = empty 
         set foreignKeys = getforeignkeys(p_tablename, "FK")
         do while not foreignKeys.eof 
         sqljoin = sqljoin & ".join(""" & foreignKeys("PK_TABLE_NAME") & " on " & foreignKeys("PK_COLUMN_NAME") & " = " & foreignKeys("FK_COLUMN_NAME") & """)" 
         foreignKeys.movenext 
         loop 
         set foreignKeys = nothing
    end function

    'GetModels
	public function GetModels(p_TableName)
        if IsEmpty(p_TableName) then
            set GetModels = m_Connection.OpenSchema(adSchemaTables, Array(empty, "dbo", empty, empty))
        else
            set GetModels = m_Connection.OpenSchema(adSchemaTables, Array(empty, "dbo", p_TableName, empty))
        end if
	end function

    'GetTables
	public function GetTables(p_TableName)
        set GetTables = m_Connection.OpenSchema(adSchemaTables, Array(empty, "dbo", p_TableName, "table"))
	end function

    'GetViews
	public function GetViews(p_TableName)
        set GetViews = m_Connection.OpenSchema(adSchemaTables, Array(empty, "dbo", p_TableName, "view"))
	end function

    'GetColumns
	public function GetColumns(p_TableName)
        set GetColumns = m_Connection.OpenSchema(adSchemaColumns, Array(empty, "dbo", p_TableName, empty))
	end function

    'GetNameColumn
	public function GetNamingColumn(columns)
        do while not columns.EOF
            if columns("Data_Type") = 130 then
                GetNamingColumn = columns("column_name")
                columns.MoveFirst
                exit function
            end if
            columns.MoveNext
        loop
	end function

    'GetForeignKeys
	public function GetForeignKeys(p_TableName, p_KeyType)
        if p_KeyType = "PK" then
            set GetForeignKeys = m_Connection.OpenSchema(adSchemaForeignKeys, array(empty, empty, cstr(p_TableName), empty, empty, empty))
        elseif p_KeyType = "FK" then
            set GetForeignKeys = m_Connection.OpenSchema(adSchemaForeignKeys, array(empty, empty, empty, empty, empty, cstr(p_TableName)))
        end if
	end function

    'GetPrimaryKey
	public function GetPrimaryKey(p_TableName)
        set GetPrimaryKey = m_Connection.OpenSchema(adSchemaPrimaryKeys, Array(empty, empty, cstr(p_TableName)))
	end function
    
    'writehtmlbody
    function writehtmlbody(p_Columns, p_Recordset)
        namingColumn = empty
        for i = 0 to foreignKeys.RecordCount - 1
            if foreignKeys("FK_COLUMN_NAME") = columns("Column_Name") then
                set cols = GetColumns(CStr(foreignKeys("PK_TABLE_NAME")))
                namingColumn = GetNamingColumn(cols)
                if IsEmpty(namingColumn) then
                    namingColumn = foreignKeys("FK_COLUMN_NAME")
                end if
                set cols = nothing
                exit for
            end if
            foreignKeys.MoveNext
        next
        if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst
        if not IsEmpty(namingColumn) then
            result = "format.text(" & p_Recordset & "(""" & LCase(namingColumn) & """)" & ")"
        else
            field_value = p_Recordset & "(""" & LCase(p_Columns("Column_Name")) & """)"
            select case p_Columns("DATA_TYPE")
                case adCurrency
                    result = "format.price(" & field_value & ")"
                case adDate, adDBDate, adDBTime, adDBTimeStamp
                    result = "format.day(" & field_value & ")"
                case adBoolean
                    result = "format.bool(" & field_value & ")"
                case adInteger, adDouble, adNumeric
                    result = "format.number(" & field_value & ")"
                case else
                    result = "format.text(" & field_value & ")"
            end select
        end if
        writehtmlbody = result
    end function

    'writehtmlform
    function writehtmlform(p_Columns, p_withlabel)
        dim result, column_name
        column_name = empty
        for i = 0 to foreignKeys.RecordCount - 1
            if foreignKeys("FK_COLUMN_NAME") = columns("Column_Name") then
                set cols = GetColumns(CStr(foreignKeys("PK_TABLE_NAME")))
                column_name = GetNamingColumn(cols)
                if IsEmpty(column_name) then
                    column_name = foreignKeys("FK_COLUMN_NAME")
                end if
                set cols = nothing
                exit for
            end if
            foreignKeys.MoveNext
        next
        if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst
        if not IsEmpty(column_name) then
            result = "html.list(""" & foreignKeys("FK_COLUMN_NAME") & """).items(db.entity(""" & foreignKeys("PK_TABLE_NAME") & """).list).key(""" & foreignKeys("PK_COLUMN_NAME") & """).text(""" & column_name & """).first(2)"
        else
            column_name = lcase(columns("Column_Name"))
            select case p_Columns("DATA_TYPE")
                case adDate, adDBDate, adDBTime, adDBTimeStamp
                    result = "html.day(""" & column_name & """).Range()"
                case adWChar
                    if p_Columns("Character_Maximum_Length") = 6 then
                        result = "html.number(""" & column_name & """)"
                    elseif p_Columns("Character_Maximum_Length") = 15 then
                        result = "html.tel(""" & column_name & """)"
                    elseif p_Columns("Character_Maximum_Length") = 254 then
                        result = "html.email(""" & column_name & """)"
                    else
                        result = "html.text(""" & column_name & """)"
                    end if
                case adBoolean
                    result = "html.checklist(""" & column_name & """).first(2)"
                case adInteger, adNumeric
                    result = "html.number(""" & column_name & """)"
                case adDouble, adSingle
                    result = "html.number(""" & column_name & """).range().float()"
                case else
                    result = "html.text(""" & column_name & """)"
            end select
        end if
        if p_withlabel then
            result = result & ".label(.item(" & column_name & ")).p"
        end if
        writehtmlform = "<%=" & result & ".value(http.querystring(""" & column_name & """)) %" & ">"
    end function

	sub class_terminate()
        set m_Connection = nothing
	end sub

end class
%>