<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<%
set schemaservice = (new schemaservicebase).connectjsonconfig(request.QueryString("project"))
table_name = request.QueryString("table_name")
set columns = schemaservice.GetColumns(table_name)
set primaryKey = schemaservice.GetPrimaryKey(table_name)
set foreignKeys = schemaservice.GetForeignKeys(table_name, "FK")
area_name = appservice.virtual_area(request.QueryString("area"))
%>
<%="<!--#include virtual=""startup.asp""-->" %><%=vblf %>
<%=vbenc %>
view("title") = strings("<%=writer.pluralize(table_name) %>")
set <%=table_name %> = db.entity("<%=table_name %>").where("<%=lcase(primaryKey("COLUMN_NAME")) %> = " & http.querystring("<%=lcase(primaryKey("COLUMN_NAME")) %>"))<%=schemaservice.sqljoin(table_name) %>.first
<%=vbend & vblf %>
<%="<!--#include virtual=""" & area_name & "/views/_shared/header.asp""-->" %>
<div class="w3-row">
    <div class="w3-bar">
        <%=Writer.Write("html.navitem(""index"").label(strings(""" & writer.Pluralize(table_name) & """)).css(""w3-theme"")") %>
        <div class="w3-dropdown-hover">
            <button class="w3-btn w3-theme">Editions</button>
            <div class="w3-dropdown-content w3-bar-block w3-card-4 w3-theme">
                <%=Writer.Write("html.navitem(""edit?" & lcase(primaryKey("COLUMN_NAME")) & "="" & " & table_name & "(""" & lcase(primaryKey("COLUMN_NAME")) & """)).label(strings(""modifier"")).css(""w3-theme"")") %><%=vbcrlf %>
                <%=vbtab %><%=vbtab %><%=vbtab %><%=vbtab %><%=Writer.Write("html.deleteitem(""delete?" & lcase(primaryKey("COLUMN_NAME")) & "="" & " & table_name & "(""" & lcase(primaryKey("COLUMN_NAME")) & """)).css(""w3-theme"")") %>
            </div>
        </div>
    </div>
</div>
<div class="w3-row w3-padding">
    <div class="w3-col m3">
        <%="<!--#include virtual=""" & area_name & "/views/_shared/templates/" & table_name & "/itemtemplate.asp""-->" %>
    </div>
    <div class="w3-col m9">
        <% set foreignKeys = schemaservice.GetForeignKeys(table_name, "PK") : do while not foreignKeys.EOF %>
        <%=writer.Start %>set <%=writer.Pluralize(foreignKeys("FK_TABLE_NAME")) %> = db.entity("<%=foreignKeys("FK_TABLE_NAME") %>").where("<%=foreignKeys("FK_COLUMN_NAME") %> = " & <%=table_name %>("<%=lcase(primaryKey("COLUMN_NAME")) %>"))<%=schemaservice.sqljoin(foreignKeys("FK_TABLE_NAME")) %>.list<%=writer.Terminate %>
        <%=vblf & vbtab & vbtab %><%="<!--#include virtual=""" & area_name & "/views/_shared/templates/" & foreignKeys("FK_TABLE_NAME") & "/listtemplate.asp""-->" %>
        <%=vblf & vbtab & vbtab %><%=writer.Start %>close <%=writer.pluralize(foreignKeys("FK_TABLE_NAME")) %><%=writer.terminate %><% foreignKeys.MoveNext %><% if not foreignkeys.eof then %><%=vblf & vbtab & vbtab %><% end if %><% loop : set foreignKeys = Nothing %>
    </div>
</div>
<%="<!--#include virtual=""" & area_name & "/views/_shared/footer.asp""-->" %><%=vbcrlf %>
<%=vbenc %>
close <%=table_name %><%=vbcrlf %>
<%=vbend %>
