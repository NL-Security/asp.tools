<% 
set config = createobject("scripting.dictionary")
config("application_name") = "IDEA"
config("home_page") = "/home/admin"
config("login_page") = "/account/login"
config("error_page") = "/home/error"
config("authorization_error_page") = "/home/authorizationerror"
config("default_culture") = "fr-FR"
config("default_uiculture") = "fr-FR"
set config("supported_cultures") = createobject("system.collections.arraylist")
with config("supported_cultures")
    .add "fr-FR"
    .add "en-US"
end with
config("scandirectory") = "C:\inetpub\wwwroot\idea\files\scan\"
config("filesdirectory") = "C:\inetpub\wwwroot\idea\files\"
config("homedirectory") = "C:\inetpub\wwwroot\idea\files\home\"
config("themepath") = "/wwwroot/css/themes"
set config("profiles") = createobject("scripting.dictionary")
set config("profiles")("production") = createobject("scripting.dictionary")
with config("profiles")("production")
    .item("application_url") = "http://ideadev.savati.net/"
    .item("application_url_ssl") = "http://ideadev.savati.net:443/"
end with
set config("mailagent") = createobject("scripting.dictionary")
with config("mailagent")
    .item("host") = "82.97.16.91"
    .item("port") = 25
    .item("enablessl") = true
    .item("username") = empty
    .item("password") = empty
end with
%>