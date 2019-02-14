<!--#include virtual="/Core/Security/AntiForgery.asp"-->
<!--#include virtual="/Core/Security/SqlInjection.asp"-->
<% set antiforgery = new AntiForgeryToken %>
<% set sqlguard = new sqlguardian %>