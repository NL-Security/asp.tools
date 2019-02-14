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
<%=vbenc %>
view("title") = strings("<%=pluralize(table_name) %>")
set <%=table_name %> = db.entity("<%=table_name %>").where("<%=primaryKey("COLUMN_NAME") %> = " & http.querystring("<%=primaryKey("COLUMN_NAME") %>")).first
if request.servervariables("request_method") = "POST" then
	if db.entity("<%=table_name %>").automap(<%=table_name %>, http.forms) then
        <%=table_name %>.update
		action "details?<%=primaryKey("COLUMN_NAME") %>=" & <%=table_name %>("<%=primaryKey("COLUMN_NAME") %>")
	end if
end if
<%=vbend & vblf %>
<%="<!--#include virtual=""/views/_shared/header.asp""-->" %>
<div class="w3-row">
    <div class="w3-bar">
        <%=Writer.Write("html.navitem(""details?" & primaryKey("COLUMN_NAME") & "="" & " & table_name & "(""" & primaryKey("COLUMN_NAME") & """)).label(strings(""" & table_name & """)).css(""w3-theme"")") %><%=vbcrlf %>
        <%=vbtab %><%=vbtab %><%=Writer.Write("html.triggeritem(""save"").label(strings(""save"")).css(""w3-theme"")") %>
    </div>
</div>
<div class="w3-row w3-padding">
    <div class="w3-col m3">
        <%="<!--#include virtual=""" & area_name & "/views/_shared/templates/" & table_name & "/editortemplate.asp""-->" %>
    </div>
</div>
<%="<!--#include virtual=""/views/_shared/footer.asp""-->" %><%=vbcrlf %>
<%=vbenc %>
close <%=table_name %><%=vbcrlf %>
<%=vbend %>
<% set primaryKey = nothing %>