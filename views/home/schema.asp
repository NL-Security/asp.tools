<!--#include virtual="/startup.asp"-->
<%
set models = new DataTable
with models
    .ID = "/models/Index"
    .Items = db.GetModels()
    .RowLocation = "/setup/models/details?object_id={object_id}"
    .AddColumn("name").WithLabel(App.Localizer.Model("name")).ThenDisplay(dispXS or dispMD)
    .AddColumn("type_desc").WithLabel(App.Localizer.Model("type_desc")).ThenDisplay(dispXS or dispMD)
end with
%>
<div class="w3-row w3-padding">
    <form>
        <div class="w3-col m12">
            <!--#include virtual="/views/_shared/templates/models/listtemplate.asp"-->
        </div>
    </form>
</div>
<% set controller = nothing %>