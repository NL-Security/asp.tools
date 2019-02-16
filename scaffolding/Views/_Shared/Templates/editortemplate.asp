<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
%><div class="w3-card-4">
    <header class="w3-container w3-theme-d4">
        <p><% writer.Write("strings(""general"")") %></p>
    </header>
    <div class="w3-container">
        <form method="post">
            <% writer.Write("html.antiforgerytoken(antiforgery.securitytoken)") %>
            [ with resources.localize("<%=table_name %>") ]<% do while not columns.eof %><% if lcase(primaryKey("column_name")) <> lcase(columns("column_name")) then %>
            [=<%=schemaservice.writehtmlform(columns, true) %> ]<% end if %><% columns.movenext %><% loop %>
            [ end with ]
            [=html.submit("save").hide ]
        </form>
    </div>
</div>
<%
set columns = nothing
%>