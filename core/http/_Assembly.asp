<!--#include virtual="/Core/Http/HttpContext.asp"-->
<!--#include virtual="/Core/Http/HttpRoute.asp"-->
<% set Http = new HttpContext %>
<% set form = http.forms %>
<% set querystring = http.querystrings %>
<% 
sub action(p_Action)
    dim result
    if not isempty(http.route.area) then
        result = result & "/" & http.route.area
    end if
    result = result & "/" & http.route.controller & "/" & p_action
    response.Redirect result
end sub
%>