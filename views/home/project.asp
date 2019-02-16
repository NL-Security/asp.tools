<!--#include virtual="/startup.asp"-->
<%
redirect.when(session("project") = "").url("/home/index")
view("title") = "Scaffolding project"
if request.ServerVariables("request_method") = "POST" then
    dim path
    scaffolding_directory = session("project")
    if request.QueryString("area") <> "" then
        scaffolding_directory = scaffolding_directory & "\areas\" & request.QueryString("area")
    end if
    scaffolding_directory = LCase(scaffolding_directory)
    if request.Form("controllers") = "1" then
        appservice.CreateControllers scaffolding_directory, request.Form("models"), "View", true
        appservice.CreateControllersAssembly scaffolding_directory & "/", request.Form("models")
    end if
    if request.Form("views") = "1" then
        appservice.CreateViews scaffolding_directory, request.Form("models"), empty
    end if
    if request.Form("templates") = "1" then
        appservice.CreateTemplates scaffolding_directory, request.Form("models"), empty
    end if
    if request.Form("resources") = "1" then
        appservice.CreateResources session("project") & "/Resources/models", request.Form("models")
    end if
    if request.Form("resources_assembly") = "1" then
        appservice.CreateResourcesAssembly session("project") & "/", request.Form("models")
    end if
    if request.Form("repositories") = "1" then
        appservice.CreateRepositories session("project") & "/", request.Form("models"), empty
        appservice.CreateRepositoriesAssembly session("project") & "/", request.Form("models")
    end if
    if request.Form("navigation") = "1" then
        appservice.CreateNavigationLinks session("project") & "/views/_shared", request.Form("models")
    end if
end if
views_path = session("project") & "\views\"
if request.QueryString("area") <> "" then
    views_path = session("project") & "\Areas\" & request.QueryString("area") & "\views\"
else
    views_path = session("project") & "\views\"
end if
set tables = schemaservice.gettables(empty)
%>
<!--#include virtual="/views/_shared/header.asp"-->
<div class="w3-row">
    <div class="w3-bar">
        <a onclick="$('#save').click()" class="w3-btn w3-primary">Valider</a>
    </div>
</div>
<div id="page" class="w3-row w3-padding">
    <form method="post">
        <div class="w3-col m3">
            <input type="submit" id="save" name="save" class="w3-hide" value="Valider" />
            <div class="w3-card-4">
                <header class="w3-container w3-primary w3-left-align">
                    <a href="?cmd=refresh&area=<%=request.QueryString("area") %>"><i class="fa fa-sync w3-text-green"></i></a>
                </header>
                <table class="w3-table w3-bordered w3-hoverable w3-cursor">
                    <% do while not tables.EOF %>
                    <% if tables("table_name") <> "sysdiagrams" then %>
                    <tr class="table_name <% if request.QueryString("cmd") = "refresh" and files.folderexists(views_path & tables("table_name")) then %>active<% end if %>" id="<%=tables("table_name") %>">
                        <td><i class="fas fa-table w3-margin-right <% if files.folderexists(views_path & tables("table_name")) then %>w3-text-yellow<% else %>w3-text-white<% end if %>"></i><%=tables("table_name") %>
                            <i id="icon_<%=tables("table_name") %>" class="fas fa-check-circle w3-margin-left w3-text-green"></i>
                            <input type="checkbox" <% if request.QueryString("cmd") = "refresh" and files.folderexists(views_path & tables("table_name")) then %>checked<% end if %> id="checkbox_<%=tables("table_name") %>" name="models" value="<%=tables("table_name") %>" class="w3-hide" />
                        </td>
                    </tr>
                    <% end if %>
                    <% tables.MoveNext %>
                    <% loop %>
                </table>
            </div>
        </div>
        <% set logs = server.CreateObject("scripting.dictionary") %>
        <div class="w3-col m9">
            <div class="w3-card-4">
                <header class="w3-container w3-primary w3-left-align">
                    Setup
                </header>
                <table class="w3-table w3-hoverable w3-cursor">
                    <tr class="table_name <% if request.Form("views") = "1" then %>active<% end if %>" id="Views">
                        <td><span>Views</span>
                            <i id="icon_Views" class="fas fa-check-circle w3-margin-left w3-text-green w3-hide"></i>
                            <input type="checkbox" id="checkbox_Views" name="views" value="1" class="w3-hide" />
                        </td>
                    </tr>
                    <tr class="table_name <% if request.Form("templates") = "1" then %>active<% end if %>" id="Templates">
                        <td><span>Templates</span>
                            <i id="icon_Templates" class="fas fa-check-circle w3-margin-left w3-text-green w3-hide"></i>
                            <input type="checkbox" id="checkbox_Templates" name="templates" value="1" class="w3-hide" />
                        </td>
                    </tr>
                    <tr class="table_name <% if request.Form("resources") = "1" then %>active<% end if %>" id="Resources">
                        <td><span>Resources</span>
                            <i id="icon_Resources" class="fas fa-check-circle w3-margin-left w3-text-green w3-hide"></i>
                            <input type="checkbox" id="checkbox_Resources" name="resources" value="1" class="w3-hide" />
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            <div class="w3-card-4">
                <header class="w3-container w3-primary w3-left-align">
                    Log
                </header>
                <% if logs.count > 0 then %>
                <div class="w3-container">
                    <p>
                        <% for each k in logs.Keys() %>
                        <var><%=k %></var><br />
                        <% next %>
                    </p>
                </div>
                <% end if %>
            </div>
        </div>
        <% close logs %>
    </form>
</div>
<!--#include virtual="/views/_shared/footer.asp"-->
<script type="text/javascript">
    $(document).ready(function () {
        $('.table_name').each(function () {
            $(this).click(function () {
                table_name = $(this).attr('id');
                $('#checkbox_' + table_name).attr('checked', !$('#checkbox_' + table_name).is(':checked'));
                $(this).toggleClass('active');
            });
        });
    });
</script>
