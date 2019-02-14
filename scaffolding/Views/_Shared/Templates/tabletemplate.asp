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
    requested_area_virtual = "/areas/" & request.QueryString("area")
end if
%><table class="w3-table-all w3-hoverable">
    <thead>
        <% writer.Enclose("with resources.localize(""" & LCase(table_name) & """)") %>
        <tr class="w3-theme"><% do while not columns.EOF %><% if primaryKey("COLUMN_NAME") <> columns("Column_Name") then %>
            <th><% writer.Write("html.tableheader(""" & LCase(columns("Column_Name")) & """).label(.item(""" & LCase(columns("Column_Name")) & """))") %></th><% end if %><% columns.MoveNext %><% loop %><% columns.MoveFirst %>
            <th></th>
        </tr>
        <% writer.Enclose("end with") %>
        <tr class="w3-light-gray"><% do while not columns.EOF %><% if primaryKey("COLUMN_NAME") <> columns("Column_Name") then %>
            <th><%=db.writehtmlform(columns, false) %></th><% end if %><% columns.MoveNext %><% loop %>
            <th>
                <% writer.Write("html.hidden(""page"").value(http.querystring(""page""))") %><%=vblf %>
                <%=vbtab %><%=vbtab %><%=vbtab %><%=vbtab %><% writer.Write("html.hidden(""order"").value(http.querystring(""order""))") %><%=vblf %>
                <%=vbtab %><%=vbtab %><%=vbtab %><%=vbtab %><% writer.Write("html.submit(""search"").value(strings(""ok"")).css(""w3-theme"")") %>
            </th>
        </tr>
    </thead>
    <tbody>
        <% columns.MoveFirst %>
        <% writer.Enclose("do while not " & Pluralize(table_name) & ".eof") %>
        <tr onclick="location.href='<% writer.Write("""" & requested_area & "/" & table_name & "/details?" & LCase(primKey) & "="" & " & Pluralize(table_name) & "(""" & LCase(primKey) & """)") %>'"><% do while not columns.EOF %><% if primaryKey("COLUMN_NAME") <> columns("Column_Name") then %>
            <td><% writer.Write(db.writehtmlbody(columns, Pluralize(table_name))) %></td><% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %><% end if %><% columns.MoveNext %><% loop %>
            <td></td>
        </tr>
        <% writer.Enclose(Pluralize(table_name) & ".movenext") %><%=vblf %>
        <%=vbtab %><%=vbtab %><% writer.Enclose("loop") %>
    </tbody>
</table>
<% writer.Enclose("html.tablefooter(" & Pluralize(table_name) & ")") %>
