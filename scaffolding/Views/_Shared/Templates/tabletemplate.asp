<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
if session("jointures") = 0 then
    model_name & "_liste"
end if
set columns = schemaservice.GetColumns(model_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
if request.QueryString("area") <> "" then
    requested_area = "/" & request.QueryString("area")
    requested_area_virtual = "/areas/" & request.QueryString("area")
end if
%><table class="w3-table-all w3-hoverable">
    <thead>
        [ with resources.localize("<%=lcase(table_name) %>") ]
        <tr class="w3-theme">
            [ for each c in <%=pluralize(table_name) %>.columns ]<% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
            [ if c = "<%=lcase(columns("column_name")) %>" then ]<th>[=html.tableheader("<%=lcase(lcase(columns("column_name"))) %>").label(.item("<%=lcase(lcase(columns("column_name"))) %>")) ]</th>[ end if ]<% end if %><% columns.movenext %><% loop %><% columns.movefirst %>
            [ next ]
            <th></th>
        </tr>
        <% writer.Enclose("end with") %>
        <tr class="w3-light-gray">
            [ for each c in <%=pluralize(table_name) %>.columns ]<% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
            [ if c = "<%=lcase(columns("column_name")) %>" then ]<th>[=<%=schemaservice.writehtmlform(columns, false) %> ]</th>[ end if ]<% end if %><% columns.movenext %><% loop %>
            [ next ]
            <th>
                [=html.hidden("page").value(http.querystring("page")) ]
                [=html.hidden("order").value(http.querystring("order")) ]
                [=html.submit("search").value(strings("ok")).css("w3-theme") ]
            </th>
        </tr>
    </thead>
    <tbody><% columns.movefirst %>
        [ for i = 1 to <%=pluralize(table_name) %>.pagesize ]
        [ if <%=pluralize(table_name) %>.eof then exit for ]
        <tr [=<%=pluralize(table_name) %>.onrowclick ]>
            [ for each c in <%=pluralize(table_name) %>.columns ]<% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
            [ if c = "<%=lcase(columns("column_name")) %>" then ]<td>[=<%=schemaservice.writehtmlbody(columns, pluralize(table_name)) %> ]</td>[ end if ]<% if foreignKeys.RecordCount > 0 then foreignKeys.movefirst %><% end if %><% columns.movenext %><% loop %>
            [ next ]
            <td></td>
        </tr>
        [ <%=pluralize(table_name) %>.movenext ]
        [ next ]
    </tbody>
</table>
<% writer.Enclose("html.tablefooter(" & pluralize(table_name) & ")") %>
