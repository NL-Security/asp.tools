<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
%>
<%=vbenc %>with resources.localize("<%=table_name %>")<%=vbend %>
<div class="w3-card-4">
    <header class="w3-container w3-theme-d4">
        <p><%=vbwrite %>strings("general")<%=vbend %></p>
    </header>
    <div class="w3-container"><% do while not columns.EOF %><% if primaryKey("COLUMN_NAME") <> columns("Column_Name") then %><%=vblf %>
        <%=vbtab %><%=vbtab %><% writer.Write(schemaservice.writehtmlbody(columns, table_name)) %><% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %><% end if %><% columns.MoveNext %><% loop %>
    </div>
</div>
<%=vbenc %>end with<%=vbend %>
<%
set columns = nothing
%>