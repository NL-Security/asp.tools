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
<%=Writer.Enclose("set " & LCase(tableName) & "_strings = localizer.Localize(""Models\" & LCase(tableName) & """)") %>
<table class="w3-table-all w3-hoverable">
    <thead>
        <tr class="w3-theme">
            <% do while not columns.EOF %>
            <th><% writer.Write(LCase(tableName) & "_strings(""" & columns("Column_Name") & """)") %></th><% columns.MoveNext %><% loop %><%=vbcrlf %>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <% columns.MoveFirst %>
        <% writer.Enclose("do while not " & Pluralize(tableName) & ".EOF") %>
        <tr onclick="location.href='<% writer.Write(requested_area & """/" & tableName & "/details?" & primKey & "="" & " & Pluralize(tableName) & "(""" & primKey & """))") %>'"><% do while not columns.EOF %>                
            <td><% writer.Write(WriteColumn(columns)) %></td><% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %><% columns.MoveNext %><% loop %>
            <td></td>
        </tr>
        <% writer.Enclose("" & Pluralize(tableName) & ".MoveNext") %><%=vbcrlf %>
        <% writer.Enclose("loop") %>
    </tbody>
</table>
<% 
function WriteColumn(p_Columns) %>
<% field_value = Pluralize(tableName) & "(""" & p_Columns("Column_Name") & """)" %>
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