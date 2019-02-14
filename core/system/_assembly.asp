<!--#include virtual="/Core/System/Common.asp"-->
<!--#include virtual="/Core/System/RedirectionHandler.asp"-->
<!--#include virtual="/Core/System/Types/_Assembly.asp"-->
<!--#include virtual="/Core/System/Converters/_Assembly.asp"-->
<!--#include virtual="/Core/System/Formatters/_Assembly.asp"-->
<!--#include virtual="/Core/System/Collections/_Assembly.asp"-->
<!--#include virtual="/Core/System/Operators/_Assembly.asp"-->
<% 
set redirect = new RedirectionHandler
set messages = server.CreateObject("scripting.dictionary")
set view = server.CreateObject("scripting.dictionary")
%>