<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
model_name = table_name
if request.QueryString("jointures") = "0" then
    model_name = model_name & "_details"
end if
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
area_name = appservice.virtual_area(request.QueryString("area"))
%>
<%="<!--#include virtual=""startup.asp""-->" %>
[
view("title") = strings("<%=pluralize(table_name) %>")
set <%=table_name %> = db.entity("<%=model_name %>").query("<%=lcase(primaryKey("column_name")) %> = " & http.querystring("<%=lcase(primaryKey("column_name")) %>"))
]
<%="<!--#include virtual=""" & area_name & "/views/_shared/header.asp""-->" %>
<div class="w3-row">
    <div class="w3-bar">
        [=html.navitem("index").label(strings("<%=pluralize(table_name) %>")).css("w3-theme") ]
        <div class="w3-dropdown-hover">
            <button class="w3-btn w3-theme">Editions</button>
            <div class="w3-dropdown-content w3-bar-block w3-card-4 w3-theme">
                [=html.navitem("edit?<%=lcase(primaryKey("column_name")) %>=" & http.querystring("<%=lcase(primaryKey("column_name")) %>")).label(strings("modifier")).css("w3-theme") ]
                [=html.deleteitem("delete?<%=lcase(primaryKey("column_name")) %>=" & http.querystring("<%=lcase(primaryKey("column_name")) %>")).css("w3-theme") ]
            </div>
        </div>
    </div>
</div>
<div class="w3-row w3-padding">
    <div class="w3-col m3">
        <%="<!--#include virtual=""" & area_name & "/views/_shared/templates/" & table_name & "/itemtemplate.asp""-->" %>
    </div>
    <div class="w3-col m9">
        <% set foreignKeys = schemaservice.GetForeignKeys(table_name, "PK") : do while not foreignKeys.eof %>
        [ set <%=pluralize(foreignKeys("FK_TABLE_NAME")) %> = db.entity("<%=foreignKeys("FK_TABLE_NAME") %>")<% if request.QueryString("jointures") = "1" then %><%=schemaservice.sqljoin(foreignKeys("FK_TABLE_NAME"), false) %><% end if %>.where("<%=foreignKeys("FK_COLUMN_NAME") %> = " & <%=table_name %>("<%=lcase(primaryKey("column_name")) %>")).list]
        <%="<!--#include virtual=""" & area_name & "/views/_shared/templates/" & foreignKeys("FK_TABLE_NAME") & "/listtemplate.asp""-->" %>
        [ close <%=pluralize(foreignKeys("FK_TABLE_NAME")) %> ]<% foreignKeys.movenext %><% if not foreignkeys.eof then %><% end if %><% loop : set foreignKeys = Nothing %>
    </div>
</div>
<%="<!--#include virtual=""" & area_name & "/views/_shared/footer.asp""-->" %>
[ close <%=table_name %> ]
