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
    <% writer.Enclose("with resources.localize(""" & LCase(tableName) & """)") %>
    <thead>
        <tr class="w3-theme">
            <% do while not columns.EOF %>
            <th><% writer.Write(".item(""" & columns("Column_Name") & """)") %></th>
            <% columns.MoveNext %><% loop %><%=vbcrlf %>
            <th></th>
        </tr>
    </thead>
    <% writer.Enclose("end with") %>
    <tbody>
        <% columns.MoveFirst %>
        <% writer.Enclose("do while not view(""" & Pluralize(tableName) & """).EOF") %>
        <tr onclick="location.href='<% writer.Write(requested_area & """/" & tableName & "/details?" & primKey & "="" & view(""" & Pluralize(tableName) & """)(""" & primKey & """)") %>'">
            <% do while not columns.EOF %>
            <td><% writer.Write("html.span(" & WriteColumn(columns) & ")") %></td>
            <% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %><% columns.MoveNext %><% loop %>
            <td></td>
        </tr>
        <% writer.Enclose("view(""" & Pluralize(tableName) & """).MoveNext") %><%=vbcrlf %>
        <%=vbtab %><%=vbtab %><% writer.Enclose("loop") %>
    </tbody>
</table>
<% 
function WriteColumn(p_Columns) %>
<% field_value = "view(""" & Pluralize(tableName) & """)(""" & p_Columns("Column_Name") & """)" %>
<% select case p_Columns("DATA_TYPE") %>
<% case adCurrency %>
<% htmlVar = "format.price(" & field_value & ")" %>
<% case adDate, adDBDate, adDBTime, adDBTimeStamp %>
<% htmlVar = "format.day(" & field_value & ")" %>
<% case adBoolean %>
<% htmlVar = "format.bool(" & field_value & ")" %>
<% case adInteger, adDouble, adNumeric %>
<% htmlVar = "format.number(" & field_value & ")" %>
<% case else %>
<% htmlVar = "format.text(" & field_value & ")" %>
<% end select %>
<%
WriteColumn = htmlVar
end function
%>