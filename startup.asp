<!--#include virtual="/core/_assembly.asp"-->
<!--#include virtual="/services/_assembly.asp"-->
<!--#include virtual="/config.asp"-->
<%
server.ScriptTimeout = 3600
response.codepage = 65001
response.charset = "utf-8"
if not isempty(session("project")) then
    set json = (new jsonreader).read(session("project") & "\config.json")
    with schemaservice
        .connect json("ConnectionStrings")("DefaultConnection")
    end with
    close json
end if
with html
    .textareaiseditor = true
    .errormessages db.errors
    .antiforgery(new antiforgerytoken)
end with
with logger
    .enable
end with
with debugger
    .handle
end with
%>