<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
area_name = appservice.virtual_area(request.QueryString("area"))
%>
<%="<!--#include virtual=""startup.asp""-->" %>
[
view("title") = strings("<%=pluralize(table_name) %>")
db.entity("<%=table_name %>").where("<%=lcase(primaryKey("column_name")) %> = " & http.querystring("<%=lcase(primaryKey("column_name")) %>")).delete
action "index"
]