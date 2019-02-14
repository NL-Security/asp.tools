<%
class DatabaseEntity
    private m_Connection
    private m_Entity
    private m_Where
    private m_Order
    private m_PageSize
    private m_Columns
    private m_SQL
    private m_Model
    private m_Top
    private m_Result
    private m_Filter
    private m_Sort
    private m_Join
    private m_validationErrors

    sub class_initialize()
        set m_Connection = server.CreateObject("adodb.connection")
        m_PageSize = 17
    end sub

    public function ValidationErrors(byref p_ValidationErrors)
        set m_validationErrors = p_ValidationErrors
        set ValidationErrors = me
    end function

    public default function Constructor(byref p_Connection)
        set m_Connection = p_Connection
        set Constructor = me
    end function

    public function automap(byref p_recordset, p_Data)
        dim columns, primaryKey, errors
        set columns = m_Connection.OpenSchema(adSchemaColumns, Array(empty, "dbo", m_Entity, empty))
        set primaryKey = m_Connection.OpenSchema(adSchemaPrimaryKeys, Array(empty, empty, m_Entity))
        debug p_Data
        do while not columns.eof
            column_name = CStr(columns("COLUMN_NAME"))
            if column_name <> primaryKey("COLUMN_NAME") then
                if not p_data.exists(column_name) then
                    if p_recordset.EditMode = 2 then
                        if columns("COLUMN_HASDEFAULT") then
                            COLUMN_HASDEFAULT = Replace(Replace(columns("COLUMN_DEFAULT"), "(", ""), ")", "")
                            if COLUMN_HASDEFAULT = "getdate" then
                                COLUMN_HASDEFAULT = Date
                            end if
                            p_recordset(column_name) = COLUMN_HASDEFAULT
                        end if
                    end if
                else
                    debug column_name
                    'on error resume next
                    if columns("Data_Type") = 5 then
                        p_recordset(column_name) = Replace(p_Data(column_name), ".", ",")
                    else
                        p_recordset(column_name) = p_Data(column_name)
                    end if
                    if err.number <> 0 then
                        debug column_name & " in error" & "<br>"
                        logger(column_name & ":" & err.Description).error
                        m_validationErrors.Add column_name, "invalid2"
                        err.Clear
                    end if
                    on error goto 0
                end if
            end if
            columns.MoveNext
        loop
        close primaryKey
        close columns
        automap = (m_connection.errors.count = 0)
    end function

    public function GetSQL() GetSQL = m_SQL end function

    public function PageSize(p_PageSize) m_PageSize = p_PageSize end function

    public property get EntityName() EntityName = m_Entity end property

    public function Entity(p_Entity)
        m_Entity = p_Entity
        set Entity = me
    end function

    public function Clone(p_Entity)
        dim result
        SQL = SQL & "select top 1 * from " & m_Entity
        if not IsEmpty(m_Where) then SQL = SQL & " where " & m_Where
        if not IsEmpty(m_Order) then SQL = SQL & " order by " & m_Order
        set result = server.CreateObject("adodb.recordset")
        result.ActiveConnection = m_connection
        result.Open SQL, m_connection, 3, 3
        for each field in result.Fields
            if not field.Properties.Item("ISAUTOINCREMENT").Value then
                result.Fields(field.Name) = p_Entity(field.Name)
            end if
        next
        set Clone = result
    end function

    private function FormatValue(p_DataType, p_Value, p_Comparer)
        if IsEmpty(p_Comparer) then
            select case p_DataType
                case adDouble, adSingle, adInteger, adNumeric, adBoolean
                    FormatValue = " = " & p_Value
                case adDBTimeStamp
                    FormatValue = " = '" & p_Value & "'"
                case adWChar, adVarWChar
                    FormatValue = " like '%" & p_Value & "%'"
            end select
        else
            select case p_DataType
                case adDouble, adSingle, adInteger, adNumeric, adCurrency
                    FormatValue = " " & p_Comparer & " " & p_Value
                case adDate, adDBDate, adDBTime, adDBTimeStamp
                    FormatValue = " " & p_Comparer & " '" & p_Value & "'"
            end select
        end if
    end function

    private function GetById(p_Id)
        set primaryKey = m_Connection.OpenSchema(adSchemaPrimaryKeys, Array(empty, empty, m_Entity))
        m_Where = m_Where & " " & primaryKey("COLUMN_NAME") & " = " & p_Id
        primaryKey.Close
        set primaryKey = nothing
    end function

    public function Join(p_Join)
        m_Join = p_Join
        set Join = me
    end function

    public function Find(p_Find)
        Filter p_Find
        Sort p_Find
        set Find = me
    end function
    
    public function Filter(p_Filters)
        dim recordset
        set recordset = server.CreateObject("adodb.recordset")
        recordset.Open "select top 0 * from " & m_Entity, m_Connection, 3, 3
        if p_Filters.count > 0 then
            for each column in recordset.Fields
                columnName = CStr(column.Name)
                dataType = column.Type
                if p_Filters.Exists(columnName) then
                    m_Filter = m_Filter & " and " & columnName & FormatValue(dataType, p_Filters(columnName), empty)
                else
                    if p_Filters.Exists(columnName & "1") then
                        m_Filter = m_Filter & " and " & columnName & FormatValue(dataType, p_Filters(columnName & "1"), ">=")
                    end if
                    if p_Filters.Exists(columnName & "2") then
                        m_Filter = m_Filter & " and " & columnName & FormatValue(dataType, p_Filters(columnName & "2"), "<=")
                    end if
                end if
            next
            if (not IsEmpty(m_Filter) or Trim(m_Filter) <> "") then
                if IsEmpty(m_Where) then
                    m_Where = m_Where & Mid(m_Filter, 5)
                else
                    m_Where = m_Where & m_Filter
                end if
            end if 
            set Filter = me
        end if
    end function

    public function Sort(p_Sort)
        set Sort = me
        if IsEmpty(p_Sort("order")) then exit function
        dim recordset
        set recordset = server.CreateObject("adodb.recordset")
        recordset.Open "select top 0 * from " & m_Entity, m_Connection, 3, 3
        for each column in recordset.Fields
            if ArrayContains(p_Sort("order"), column.Name & "2") then
                if not IsEmpty(m_Sort) then m_Sort = m_Sort & ", "
                m_Sort = m_Sort & column.Name & " desc"
            elseif ArrayContains(p_Sort("order"), column.Name) then
                if not IsEmpty(m_Sort) then m_Sort = m_Sort & ", "
                m_Sort = m_Sort & column.Name
            end if
        next
        'if not IsEmpty(m_Sort) or Trim(m_Sort) <> "" then m_Order = m_Order & Mid(m_Sort, 5)
        if not IsEmpty(m_Sort) then
            if not IsEmpty(m_Order) then
                m_Order = m_Order & ","
            end if
            m_Order = m_Order & " " & m_Sort
        end if
    end function

    public function Top(p_Top)
        m_Top = p_Top
        set Top = me
    end function
    
    public function Where(p_Where)
        if not IsEmpty(m_Where) then m_Where = p_Where & " and "
        m_Where = m_Where & p_Where
        set Where = me
    end function

    public function Asc(p_Order)
        if not IsEmpty(m_Order) then m_Order = m_Order & ", "
        m_Order = m_Order & p_Order
        set Asc = me
    end function

    public function Desc(p_Order)
        if not IsEmpty(m_Order) then m_Order = m_Order & ","
        m_Order = m_Order & " " & p_Order & " desc"
        set Desc = me
    end function

    public function OrderBy(p_Order)
        if not IsEmpty(m_Order) then m_Order = m_Order & ", "
        m_Order = m_Order & p_Order
        set OrderBy = me
    end function

    public function OrderByDescending(p_Order)
        if not IsEmpty(m_Order) then m_Order = m_Order & ","
        m_Order = m_Order & " " & p_Order & " desc"
        set OrderByDescending = me
    end function

    public function create()
        dim result
        set result = server.CreateObject("adodb.recordset")
        result.Open "select top 0 * from " & m_Entity, m_connection, 1, 2
        result.AddNew
        set Create = result
    end function

    public function Delete()    
        m_Sql = m_Sql & "delete from " & m_Entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
        end if
        set result = server.CreateObject("adodb.recordset")
        result.Open m_Sql, m_connection, 3, 3
        close result
    end function

    private function PrepareSQL()
        dim result
        if not IsEmpty(m_Top) then
            result = result & " top " & m_Top & " "
        end if
        result = result & " * from " & m_Entity
        if not IsEmpty(m_Where) then
            result = result & " where " & m_Where
        end if
        if not IsEmpty(m_Order) then
            result = result & " order by " & m_Order
        end if
        PrepareSQL = result
    end function

    public function Max(p_Column)
        dim result
        m_Sql = m_Sql & "select case when max(" & p_Column & ") is null then 0 else max(" & p_Column & ") end as value from " & m_Entity
        set result = server.CreateObject("adodb.recordset")
        result.Open m_Sql, m_connection, 3, 3
        Max = result("value")
    end function

    public function countas()
        dim result
        m_Sql = m_Sql & "select count(*) as total from " & m_entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
        end if
        set result = server.CreateObject("adodb.recordset")
        result.Open m_Sql, m_connection, 3, 3
        countas = result("total")
    end function

    public function count(p_count)
        dim result
        m_Sql = m_Sql & "select count(*) as result from " & m_entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
            if not IsEmpty(p_count) then
                m_Sql = m_Sql & " and " & p_count
            end if
        end if
        if not IsEmpty(p_count) then
            m_Sql = m_Sql & " where " & p_count
        end if
        debug m_Sql
        set result = server.CreateObject("adodb.recordset")
        result.Open m_Sql, m_connection, 3, 3
        count = result("result")
    end function

    public function Exists()
        Exists = not Count.eof
    end function

    public function list()
        dim result
        m_Sql = m_Sql & "select "
        if not IsEmpty(m_Top) then
            m_Sql = m_Sql & " top " & m_Top & " "
        end if
        m_Sql = m_Sql & " * from " & m_Entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
        end if
        if not IsEmpty(m_Order) then
            m_Sql = m_Sql & " order by " & m_Order
        end if
        set result = server.CreateObject("adodb.recordset")
        result.CursorLocation = 3
        debug m_sql
        logger(m_Sql).warn
        result.Open m_Sql, m_connection, 3, 3
        set list = result
    end function

    public function pagedlist()
        dim result
        m_Sql = m_Sql & "select "
        if not IsEmpty(m_Top) then
            m_Sql = m_Sql & " top " & m_Top & " "
        end if
        m_Sql = m_Sql & " * from " & m_Entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
        end if
        if not IsEmpty(m_Order) then
            m_Sql = m_Sql & " order by " & m_Order
        end if
        set result = server.CreateObject("adodb.recordset")
        result.CursorLocation = 3
        result.CursorType = 3
        result.CacheSize = m_PageSize
        debug m_Sql
        logger(m_Sql).warn
        result.Open m_Sql, m_connection, 3, 3
        if result.RecordCount > 0 then
            result.PageSize = m_PageSize
            if querystring("page") = "" then
                result.AbsolutePage = 1
            else
                result.AbsolutePage = CInt(querystring("page"))
            end if
        end if
        set pagedlist = result
    end function

    public function query(p_query)
        dim result
        m_Sql = m_Sql & "select * from " & m_Entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
            if not IsEmpty(p_query) then
                m_Sql = m_Sql & " and " & p_query
            end if
        else
            if not IsEmpty(p_query) then
                m_Sql = m_Sql & " where " & p_query
            end if
        end if
        set result = server.CreateObject("adodb.recordset")
        logger(m_Sql).warn
        debug m_Sql
        result.Open m_Sql, m_connection, 3, 3
        set query = result
    end function

    public function First()
        dim result
        m_Sql = m_Sql & "select top 1 * from " & m_Entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
        end if
        if not IsEmpty(m_Order) then
            m_Sql = m_Sql & " order by " & m_Order
        end if
        set result = server.CreateObject("adodb.recordset")
        logger(m_Sql).warn
        debug m_Sql
        result.Open m_Sql, m_connection, 3, 3
        set First = result
    end function

    public function Load()    
        dim result
        m_Sql = m_Sql & "select "
        if not IsEmpty(m_Top) then
            m_Sql = m_Sql & " top " & m_Top & " "
        end if
        m_Sql = m_Sql & " * from " & m_Entity
        if not IsEmpty(m_Where) then
            m_Sql = m_Sql & " where " & m_Where
        end if
        if not IsEmpty(m_Order) then
            m_Sql = m_Sql & " order by " & m_Order
        end if
        set result = server.CreateObject("adodb.recordset")
        result.CacheSize = m_PageSize
        result.Open m_Sql, m_connection, 3, 3
        result.PageSize = m_PageSize
        set Load = result
    end function

end class
%>
