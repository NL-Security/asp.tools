<!DOCTYPE html>
<html>
<head>
    <title><%=view("title") %></title>
    <meta charset="Windows-1252">
    <meta name="robots" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/wwwroot/css/w3.css" />
    <link rel="stylesheet" href="/wwwroot/css/roboto.css" />
    <link rel="stylesheet" href="/wwwroot/css/site.css?time=<%=Time %>" />
    <link rel="stylesheet" href="/wwwroot/css/themes/1a1a1a.css?time=<%=Time %>" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" />
    <style type="text/css">
        #page .w3-bar-block .w3-bar-item {
            padding: 1px 16px;
        }
    </style>
</head>
<body>
    <div class="w3-bar w3-top w3-theme-d3 w3-large" style="z-index: 4">
        <a href="/Home/Index"><span class="w3-bar-item w3-left"><%=config("application_name") %><%=" | " & View("title") %></span></a>
        <button class="w3-bar-item w3-btn w3-hide-large w3-hover-none w3-hover-text-light-grey w3-right" onclick="w3_open();"><i class="fa fa-bars"></i></button>
    </div>
    <nav class="w3-sidebar w3-collapse w3-theme-d1" style="z-index: 3; width: 270px" id="mySidebar">
        <% if not isempty(session("project")) then %>
        <br />
        <div class="w3-bar-block">
            <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="Fermer"><i class="fa fa-remove fa-fw"></i>Fermer</a>
            <a href="/home/project" class="w3-bar-item w3-btn <% if http.route.route = "Home/Index" then %>w3-black<% end if %>">Project</a>
            <% if files.FolderExists(session("project") & "/areas") then %>
            <% set folder = files.GetFolder(session("project") & "/areas") %>
            <% for each subfolder in folder.SubFolders %>
            <a href="/home/project?area=<%=subfolder.Name %>" class="w3-bar-item w3-btn"><%=subfolder.Name %></a>
            <% next %>
            <% close folder %>
            <% end if %>
            <a href="/Schema/Explorer" class="w3-bar-item w3-btn <% if http.route.route = "home/schema" then %>w3-black<% end if %>">Schema</a>
        </div>
        <% end if %>
    </nav>
    <div class="w3-overlay w3-hide-large w3-animate-opacity" onclick="w3_close()" style="cursor: pointer" title="close side menu" id="myOverlay"></div>
    <div class="w3-main" style="margin-left: 270px; margin-top: 43px;">
