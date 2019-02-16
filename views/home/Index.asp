<!--#include virtual="/startup.asp"-->
<%
if not isempty(http.form("project")) then
    session("project") = http.form("project")
    session("jointures") = http.form("jointures")
    action "project"
end if
%>
<!--#include virtual="/views/_shared/header.asp"-->
<div class="w3-row">
    <div class="w3-col m3">
        <div class="w3-container">
            <form method="post">
                <%=html.text("project").label("Repertoire de travail").required.p %>
                <%=html.checklist("jointures").label("Utiliser les jointures").value(0).required.p %>
                <%=html.submit("save").p %>
            </form>
        </div>
    </div>
</div>
<!--#include virtual="/views/_shared/footer.asp"-->