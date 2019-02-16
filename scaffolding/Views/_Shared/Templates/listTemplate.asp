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
            <a href="/<%=table_name %>/create?<%=lcase(primaryKey("column_name")) %>=[ http.querystring("<%=lcase(primaryKey("column_name")) %>") ]" title="[ strings("create") ]" class="w3-right"><i class="fa fa-plus"></i></a>
            [=strings("<%=pluralize(table_name) %>") ]
        </p>
    </header>
    <table class="w3-table-all w3-hoverable">
        [ with resources.localize("<%=lcase(table_name) %>") ]
        <thead>
            <tr class="w3-theme"><% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
                <th>[=.item("<%=lcase(columns("column_name")) %>") ]</th><% end if %><% columns.movenext %><% loop %>
                <th></th>
            </tr>
        </thead>
        [ end with ]
        <tbody>
            <% columns.movefirst %>
            <% writer.Enclose("do while not " & pluralize(table_name) & ".eof") %>
            <tr onclick="location.href='<%=requested_area %>/<%=table_name %>/details?<%=lcase(primaryKey("column_name")) %>=[=<%=pluralize(table_name) %>("<%=lcase(primaryKey("column_name")) %>") ]'"><% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
                <td>[ <%=schemaservice.writehtmlbody(columns, pluralize(table_name)) %> ]</td><% if foreignKeys.RecordCount > 0 then foreignKeys.movefirst %><% end if %><% columns.movenext %><% loop %>
                <td></td>
            </tr>
            [ <%=pluralize(table_name) %>.movenext ]
            [ loop ]
        </tbody>
    </table>
</div>