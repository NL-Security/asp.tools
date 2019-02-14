<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
response.Write table_name
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
%><div class="w3-card-4">
    <header class="w3-container w3-theme">
        <p><% writer.Write("strings(""general"")") %></p>
    </header>
    <div class="w3-container">
        <form method="post">
            <% writer.Write("html.antiforgerytoken(antiforgery.securitytoken)") %><%=vblf %>
            <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("with resources.localize(""" & table_name & """)") %><% do while not columns.EOF %><% if primaryKey("COLUMN_NAME") <> columns("Column_Name") then %><%=vblf %>
            <%=vbtab %><%=vbtab %><%=vbtab %><%=schemaservice.writehtmlform(columns, true) %><% end if %><% columns.MoveNext %><% loop %><%=vbcrlf %>
            <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Enclose("end with") %><%=vblf %>
            <%=vbtab %><%=vbtab %><%=vbtab %><% writer.Write("Html.submit(""save"").hide") %>
        </form>
    </div>
</div>
<%
set columns = nothing
%>