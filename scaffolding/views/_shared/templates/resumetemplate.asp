<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
if request.QueryString("area") <> "" then
    requested_area = "/" & request.QueryString("area")
    requested_area_virtual = "/Areas/" & request.QueryString("area")
end if
%><div class="w3-card-4">
    <header class="w3-container w3-theme-d4">
        <p>
            <a href="/<%=table_name %>/create?<%=lcase(primaryKey("column_name")) %>=<%=writer.write("http.querystring(""" & lcase(primaryKey("column_name")) & """)") %>" title="<%=writer.write("strings(""create"")") %>" class="w3-right"><i class="fa fa-plus"></i></a>
            [=strings("<%=pluralize(table_name) %>") ]
        </p>
    </header>
    <table class="w3-table-all w3-hoverable">
        <% writer.Enclose("with resources.localize(""" & lcase(table_name) & """)") %>
        <tbody>
            <% writer.Enclose("do while not " & pluralize(table_name) & ".eof") %>
            <tr onclick="location.href='<% writer.Write("""" & requested_area & "/" & table_name & "/details?" & lcase(primaryKey("column_name")) & "="" & " & pluralize(table_name) & "(""" & lcase(primaryKey("column_name")) & """)") %>'">
                <td><% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
                    [=html.span(<%=schemaservice.writehtmlbody(columns, table_name) %>).label(.item("<%=lcase(columns("column_name")) %>")).br ]<% end if %><% columns.movenext %><% loop %>
                </td>
                <td onclick="event.stopPropagation()">html.trashicon("/<%=table_name %>/delete?<%=primaryKey("column_name") %>=<%=pluralize(table_name) %>("<%=primaryKey("column_name") %>")).title(strings("suprimmer") & strings("<%=table_name %>")).css("w3-text-theme")</td>
            </tr>
            [ <%=pluralize(table_name) %>.movenext ]
            [ next ]
        </tbody>
        <% writer.Enclose("end with") %>
    </table>
</div>
