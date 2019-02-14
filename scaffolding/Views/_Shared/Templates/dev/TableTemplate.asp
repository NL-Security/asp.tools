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
<table class="w3-table-all w3-hoverable">
    <thead>
        <% writer.Enclose("with resources.localize(""" & LCase(tableName) & """)") %>
        <tr class="w3-theme">
            <% do while not columns.EOF %>
            <th><% writer.Write(".Item(""" & LCase(columns("Column_Name")) & """)") %></th>
            <% columns.MoveNext %><% loop %>
            <th></th>
        </tr>
        <% writer.Enclose("end with") %>
        <tr class="w3-light-gray">
            <% if columns.RecordCount > 0 then %>
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
            <% htmlInput = "html.day(""" & LCase(columns("Column_Name")) & """).Range()" %>
            <% case adWChar %>
            <% if columns("Character_Maximum_Length") = 6 then %>
            <% htmlInput = "html.number(""" & LCase(columns("Column_Name")) & """)" %>
            <% elseif columns("Character_Maximum_Length") = 15 then %>
            <% htmlInput = "html.tel(""" & LCase(columns("Column_Name")) & """)" %>
            <% elseif columns("Character_Maximum_Length") = 254 then %>
            <% htmlInput = "html.email(""" & LCase(columns("Column_Name")) & """)" %>
            <% else %>
            <% htmlInput = "html.text(""" & LCase(columns("Column_Name")) & """)" %>
            <% end if %>
            <% case adBoolean %>
            <% htmlInput = "html.checklist(""" & LCase(columns("Column_Name")) & """).first(2)" %>
            <% case adInteger, adNumeric %>
            <% htmlInput = "html.number(""" & LCase(columns("Column_Name")) & """)" %>
            <% case adDouble, adSingle %>
            <% htmlInput = "html.number(""" & LCase(columns("Column_Name")) & """).range().float()" %>
            <% case else %>
            <% htmlInput = "html.text(""" & LCase(columns("Column_Name")) & """)" %>
            <% end select %>
            <% end if %>
            <% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %>
            <% htmlInput = htmlInput & ".value(http(""" & LCase(columns("Column_Name")) & """)).tostring" %>
            <th><% writer.Write(htmlInput) %></th>
            <% columns.MoveNext %>
            <% loop %>
            <% end if %>
            <th>
                <% writer.Write("html.hidden(""order"").value(http(""order"")).tostring") %>
                <% writer.Write("html.submit(""search"").value(strings(""ok"")).css(""w3-theme"").tostring") %></th>
        </tr>
    </thead>
    <tbody>
        <% columns.MoveFirst %>
        <% writer.Enclose("do while not view(""" & Pluralize(tableName) & """).EOF") %>
        <tr onclick="location.href='<% writer.Write(requested_area & """/" & tableName & "/details?" & LCase(primKey) & "="" & view(""" & Pluralize(tableName) & """)(""" & LCase(primKey) & """)") %>'">
            <% do while not columns.EOF %>
            <td><% writer.Write(WriteColumn(columns)) %></td>
            <% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %><% columns.MoveNext %><% loop %>
            <td></td>
        </tr>
        <% writer.Enclose("view(""" & Pluralize(tableName) & """).MoveNext") %>
        <% writer.Enclose("loop") %>
    </tbody>
</table>
<% 
function WriteColumn(p_Columns) %>
<% field_value = "view(""" & Pluralize(tableName) & """)(""" & LCase(p_Columns("Column_Name")) & """)" %>
<% select case p_Columns("DATA_TYPE") %>
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
<%
WriteColumn = htmlVar
end function
%>