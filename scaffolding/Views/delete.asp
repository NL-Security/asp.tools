<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
response.Write table_name
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
area_name = appservice.virtual_area(request.QueryString("area"))
%>
<%="<!--#include virtual=""startup.asp""-->" %><%=vblf %>
<%=vbstart %>
view("title") = strings("<%=pluralize(table_name) %>")
db.entity("<%=table_name %>").where("<%=primaryKey("COLUMN_NAME") %> = " & http.querystring("<%=primaryKey("COLUMN_NAME") %>")).delete
action "index"
