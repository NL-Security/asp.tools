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
            <a href="/<%=table_name %>/create?<%=lcase(primaryKey("COLUMN_NAME")) %>=<%=writer.write("http.querystring(""" & lcase(primaryKey("COLUMN_NAME")) & """)") %>" title="<%=writer.write("strings(""create"")") %>" class="w3-right"><i class="fa fa-plus"></i></a>
            <%=vbwr %>strings("<%=pluralize(table_name) %>")<%=vbend %>
        </p>
    </header>
    <table class="w3-table-all w3-hoverable">
        <% writer.Enclose("with resources.localize(""" & LCase(table_name) & """)") %>
        <thead>
            <tr class="w3-theme"><% do while not columns.EOF %><% if lcase(primaryKey("COLUMN_NAME")) <> lcase(columns("Column_Name")) then %>
                <th><% writer.Write(".item(""" & lcase(columns("Column_Name")) & """)") %></th><% end if %><% columns.MoveNext %><% loop %>
                <th></th>
            </tr>
        </thead>
        <% writer.Enclose("end with") %>
        <tbody>
            <% columns.MoveFirst %>
            <% writer.Enclose("do while not " & Pluralize(table_name) & ".eof") %>
            <tr onclick="location.href='<% writer.Write("""" & requested_area & "/" & table_name & "/details?" & lcase(primaryKey("COLUMN_NAME")) & "="" & " & Pluralize(table_name) & "(""" & lcase(primaryKey("COLUMN_NAME")) & """)") %>'"><% do while not columns.EOF %><% if lcase(primaryKey("COLUMN_NAME")) <> lcase(columns("Column_Name")) then %>
                <td><% writer.Write(schemaservice.writehtmlbody(columns, Pluralize(table_name))) %></td><% if foreignKeys.RecordCount > 0 then foreignKeys.MoveFirst %><% end if %><% columns.MoveNext %><% loop %>
                <td></td>
            </tr>
            <% writer.Enclose(Pluralize(table_name) & ".movenext") %><%=vbcrlf %>
            <%=vbtab %><%=vbtab %><% writer.Enclose("loop") %>
        </tbody>
    </table>
</div>