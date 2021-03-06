<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
model_name = table_name
if request.QueryString("jointures") = "0" then
    model_name = model_name & "_details"
end if
set columns = schemaservice.GetColumns(model_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
%>[ with resources.localize("<%=table_name %>") ]
<div class="w3-card-4">
    <header class="w3-container w3-theme-d4">
        <p>[=strings("general") ]</p>
    </header>
    <div class="w3-container"><% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
        [=html.var(<%=schemaservice.writehtmlbody(columns, table_name) %>).label(.item("<%=lcase(columns("column_name")) %>")).p ]<% if foreignKeys.RecordCount > 0 then foreignKeys.movefirst %><% end if %><% columns.movenext %><% loop %>
    </div>
</div>
[ end with ]
<%
set columns = nothing
%>