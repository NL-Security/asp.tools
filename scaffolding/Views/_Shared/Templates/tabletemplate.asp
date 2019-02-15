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
        <tr class="w3-theme">
            <%=vbenc %>for each c in <%=pluralize(table_name) %>.columns<%=vbend %><%=vbcrlf %><% do while not columns.EOF %><% if lcase(primaryKey("COLUMN_NAME")) <> lcase(columns("Column_Name")) then %>
            <%=vbtab %><%=vbtab %><%=vbtab %><%=vbenc %>if c = "<%=lcase(columns("Column_Name")) %>" then<%=vbend %><th><% writer.Write("html.tableheader(""" & LCase(lcase(columns("Column_Name"))) & """).label(.item(""" & LCase(lcase(columns("Column_Name"))) & """))") %></th><%=vbenc %>end if<%=vbend %><%=vblf %><% end if %><% columns.MoveNext %><% loop %><% columns.MoveFirst %>
            <%=vbtab %><%=vbtab %><%=vbtab %><%=vbenc %>next<%=vbend %>
            <th></th>
        </tr>
        <% writer.Enclose("end with") %>
        <tr class="w3-light-gray">
            <%=vbenc %>for each c in <%=pluralize(table_name) %>.columns<%=vbend %><%=vbcrlf %><% do while not columns.EOF %><% if lcase(primaryKey("COLUMN_NAME")) <> lcase(columns("Column_Name")) then %>
            <%=vbtab %><%=vbtab %><%=vbtab %><%=vbenc %>if c = "<%=lcase(columns("Column_Name")) %>" then<%=vbend %><th><%=schemaservice.writehtmlform(columns, false) %></th><%=vbenc %>end if<%=vbend %><%=vblf %><% end if %><% columns.MoveNext %><% loop %>
            <%=vbtab %><%=vbtab %><%=vbtab %><%=vbenc %>next<%=vbend %>
            <th>
                <% writer.Write("html.hidden(""page"").value(http.querystring(""page""))") %><%=vblf %>
                <%=vbtab %><%=vbtab %><%=vbtab %><%=vbtab %><% writer.Write("html.hidden(""order"").value(http.querystring(""order""))") %><%=vblf %>
                <%=vbtab %><%=vbtab %><%=vbtab %><%=vbtab %><% writer.Write("html.submit(""search"").value(strings(""ok"")).css(""w3-theme"")") %>
            </th>
        </tr>
    </thead>
    <tbody>
        <% columns.MoveFirst %>
        <%=vbenc %>for i = 1 to <%=pluralize(table_name) %>.pagesize<%=vbend %><%=vblf %>
        <%=vbtab %><%=vbtab %><%=vbenc %>if <%=pluralize(table_name) %>.eof then exit for<%=vbend %>
        <tr <%=vbwr %><%=pluralize(table_name) %>.onrowclick<%=vbend %>>
            <%=vbenc %>for each c in <%=pluralize(table_name) %>.columns<%=vbend %><%=vbcrlf %><% do while not columns.EOF %><% if lcase(primaryKey("COLUMN_NAME")) <> lcase(columns("Column_Name")) then %>
            <%=vbtab %><%=vbtab %><%=vbtab %><%=vbenc %>if c = "<%=lcase(columns("Column_Name")) %>" then<%=vbend %><td><% writer.Write(schemaservice.writehtmlbody(columns, Pluralize(table_name))) %></td><%=vbenc %>end if<%=vbend %><%=vbcrlf %><% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %><% end if %><% columns.MoveNext %><% loop %>
            <%=vbtab %><%=vbtab %><%=vbtab %><%=vbenc %>next<%=vbend %>
            <td></td>
        </tr>
        <%=vbenc %><%=pluralize(table_name) %>.movenext<%=vbend %><%=vblf %>
        <%=vbtab %><%=vbtab %><%=vbenc %>next<%=vbend %>
    </tbody>
</table>
<% writer.Enclose("html.tablefooter(" & Pluralize(table_name) & ")") %>
