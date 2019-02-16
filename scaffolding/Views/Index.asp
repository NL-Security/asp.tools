<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
model_name = table_name
if request.QueryString("jointures") = "0" then
    model_name = model_name & "_liste"
end if
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
area_name = appservice.virtual_area(request.QueryString("area"))
%>
<%="<!--#include virtual=""startup.asp""-->" %><%=vblf %>
<%="<!--#include virtual=""" & area_name & "/views/_shared/header.asp""-->" %>
[ view("title") = strings("<%=pluralize(table_name) %>") ]
<div class="w3-row">
    <div class="w3-bar">
        [=html.navitem("<%=area_name %>/<%=table_name %>/create").label(strings("ajouter")).css("w3-theme") ]
    </div>
</div>
<div class="w3-row w3-padding">
    <div class="w3-col m12">
        <div class="w3-card-4">
            [
            set <%=pluralize(table_name) %> = new htmltable
            with <%=pluralize(table_name) %>
                .id = "<%=pluralize(table_name) %>"
                .records = db.entity("<%=model_name %>")<% if request.QueryString("jointures") = "1" then %><%=schemaservice.sqljoin(model_name, false) %><% end if %>.find(http.querystrings).pagedlist
                .rowhref = "<%=request.QueryString("area") %>/<%=table_name %>/details?<%=lcase(primaryKey("column_name")) %>={<%=lcase(primaryKey("column_name")) %>}"<% do while not columns.eof %>
                .col("<%=lcase(columns("column_name")) %>")<% columns.movenext %><% loop %>
                .build
            end with
            ]
            <%="<!--#include virtual=""" & area_name & "/views/_shared/templates/" & table_name & "/tabletemplate.asp""-->" %>
            [ close <%=pluralize(table_name) %>]
        </div>
    </div>
</div>
<%="<!--#include virtual=""" & area_name & "/views/_shared/footer.asp""-->" %>
