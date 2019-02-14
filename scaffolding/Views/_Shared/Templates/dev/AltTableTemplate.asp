<!--#include virtual="/Core/_Assembly.asp"-->
<!--#include virtual="/Data/AdodbContext.asp"-->
<%
set writer = new ASPWriter
set debugger = new DefaultDebugger
set options = new DbContextOptions
with options
    .ConnectionString = (new JsonReader).Read(request.QueryString("project") & "\appsettings.json")("ConnectionStrings")("DefaultConnection")
end with
set db = (new AdodbContext)(options)
table_name = request.QueryString("table_name")
tableName = request.QueryString("table_name")
set primaryKey = db.GetPrimaryKey(tableName)
set primaryKey = db.GetPrimaryKey(tableName)'pas de clé primaire sur view => dessiner toutes les views sur sql
if primaryKey.recordcount = 0 then
    primKey = "Id"
else
    primKey = primaryKey("COLUMN_NAME")
end if
set columns = db.GetColumns(tableName)
set foreignKeys = db.GetForeignKeys(tableName, "FK")
if request.QueryString("area") <> "" then
    requested_area = "/" & request.QueryString("area")
    requested_area_virtual = "/Areas/" & request.QueryString("area")
end if
%>
<form method="get">
    <table class="w3-table-all w3-hoverable w3-card-4">
        <thead>
            <tr class="w3-theme">
                <% writer.Enclose("with resources.localize(""" & LCase(tableName) & """)") %><%=vbcrlf %>
                <% writer.Enclose("for each column in " & Pluralize(tableName) & ".Columns") %><%=vbcrlf %>
                <% do while not columns.EOF %>
                <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("column.Header """ & columns("Column_Name") & """, " & ".Item(""" & columns("Column_Name") & """)") %><%=vbcrlf %>
                <% columns.MoveNext %>
                <% loop %>
                <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("next") %>
                <% writer.Enclose("end with") %><%=vbcrlf %>
                <th></th>
            </tr>
        </thead>
        <tr class="w3-light-gray">
            <% writer.Enclose("for each column in " & Pluralize(tableName) & ".Columns") %><%=vbcrlf %>
            <% columns.MoveFirst %>
            <% do while not columns.EOF %>


            <% namingColumn = empty %>
            <% for i = 0 to foreignKeys.RecordCount - 1 %>
            <% if foreignKeys("FK_COLUMN_NAME") = columns("Column_Name") then %>
            <% set cols = db.GetColumns(CStr(foreignKeys("PK_TABLE_NAME"))) %>
            <% namingColumn = db.GetNamingColumn(cols) %>
            <% if IsEmpty(namingColumn) then %>
            <% namingColumn = foreignKeys("FK_COLUMN_NAME") %>
            <% end if %>
            <% set cols = nothing %>
            <% exit for %>
            <% end if %>
            <% foreignKeys.MoveNext %>
            <% next %>
            <% if not IsEmpty(namingColumn) then %>
            <% htmlInput = "html.list(""" & foreignKeys("FK_COLUMN_NAME") & """).Items(db.entity(""" & foreignKeys("PK_TABLE_NAME") & """).list).key(""" & foreignKeys("FK_COLUMN_NAME") & """).text(""" & namingColumn & """).first(2)" %>
            <% else %>
            <% select case columns("DATA_TYPE") %>
            <% case adDate, adDBDate, adDBTime, adDBTimeStamp %>
            <% htmlInput = "html.day(""" & columns("Column_Name") & """).Range()" %>
            <% case adWChar %>
            <% if columns("Character_Maximum_Length") = 6 then %>
            <% htmlInput = "html.number(""" & columns("Column_Name") & """)" %>
            <% elseif columns("Character_Maximum_Length") = 15 then %>
            <% htmlInput = "html.tel(""" & columns("Column_Name") & """)" %>
            <% elseif columns("Character_Maximum_Length") = 254 then %>
            <% htmlInput = "html.email(""" & columns("Column_Name") & """)" %>
            <% else %>
            <% htmlInput = "html.text(""" & columns("Column_Name") & """)" %>
            <% end if %>
            <% case adBoolean %>
            <% htmlInput = "html.checklist(""" & columns("Column_Name") & """).first(2)" %>
            <% case adInteger, adNumeric %>
            <% htmlInput = "html.number(""" & columns("Column_Name") & """)" %>
            <% case adDouble, adSingle %>
            <% htmlInput = "html.number(""" & columns("Column_Name") & """).range().float()" %>
            <% case else %>
            <% htmlInput = "html.text(""" & columns("Column_Name") & """)" %>
            <% end select %>
            <% end if %>
            <% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %>
            <% htmlInput = htmlInput & ".value(query(""" & columns("Column_Name") & """))" %>
            <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("column.Form """ & columns("Column_Name") & """, " & htmlInput & "") %><%=vbcrlf %>
            <% columns.MoveNext %>
            <% loop %>
            <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("next") %>
            <th>
                <% writer.Write("html.Hidden(""order"").value(query(""order"")).tostring") %>
                <% writer.Write("html.Submit(""search"").value(""OK"").css(""w3-theme"").tostring") %></th>
        </tr>
        <tbody>
            <% writer.Enclose("do while not " & Pluralize(tableName) & ".Records.EOF") %>
            <tr onclick="location.href='<% writer.Write(Pluralize(tableName) & ".Route") %>'">
                <% writer.Enclose("for each column in " & Pluralize(tableName) & ".Columns") %><%=vbcrlf %>
                <% columns.MoveFirst %>
                <% do while not columns.EOF %>
                <% foreignKey = empty %>
                <% for i = 0 to foreignKeys.RecordCount - 1 %>
                <% if foreignKeys("FK_COLUMN_NAME") = columns("Column_Name") then %>
                <% set cols = db.GetColumns(CStr(foreignKeys("PK_TABLE_NAME"))) %>
                <% namingColumn = db.GetNamingColumn(cols) %>
                <% if IsEmpty(namingColumn) then %>
                <% namingColumn = foreignKeys("FK_COLUMN_NAME") %>
                <% end if %>
                <% set cols = nothing %>
                <% foreignKey = foreignKeys %>
                <% exit for %>a
                <% end if %>
                <% foreignKeys.MoveNext %>
                <% next %>
                <% if not IsEmpty(foreignKey) then %>
                <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("if column.Name = """ & columns("Column_Name") & """ then") %><% writer.Enclose("column.Data """ & columns("Column_Name") & """, " & Pluralize(tableName) & ".Records.Fields(""" & namingColumn & """)") %><% writer.Enclose("end if") %><%=vbcrlf %>
                <% else %>
                <% field_value = Pluralize(tableName) & ".Records.Fields(""" & columns("Column_Name") & """)" %>
                <% select case columns("DATA_TYPE") %>
                <% case adCurrency %>
                <% htmlVar = "format.price(" & field_value & ").tostring" %>
                <% case adDate, adDBDate, adDBTime, adDBTimeStamp %>
                <% htmlVar = "format.day(" & field_value & ").tostring" %>
                <% case adBoolean %>
                <% htmlVar = "format.bool(" & field_value & ").tostring" %>
                <% case adInteger, adDouble, adNumeric %>
                <% htmlVar = "format.number(" & field_value & ").tostring" %>
                <% case else %>
                <% htmlVar = "format.text(" & field_value & ").tostring" %>
                <% end select %>
                <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("if column.Name = """ & columns("Column_Name") & """ then") %><% writer.Enclose("column.Data """ & columns("Column_Name") & """, " & htmlVar) %><% writer.Enclose("end if") %><%=vbcrlf %>
                <% end if %>
                <% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %>
                <% columns.MoveNext %>
                <% loop %>
                <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("next") %>
                <td></td>
            </tr>
            <% writer.Enclose("" & Pluralize(tableName) & ".Records.MoveNext") %>
            <% writer.Enclose("loop") %>
        </tbody>
    </table>
</form>
<% writer.Enclose(Pluralize(tableName) & ".Footer") %>
