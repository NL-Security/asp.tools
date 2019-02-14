<div class="w3-col m6">
    <table class="w3-table-all w3-hoverable w3-card-4">
        <tr class="w3-theme">
            <% for each column in ViewData("Columns").Columns %>
            <% TableHeaderComponent column, "name" %>
            <% TableHeaderComponent column, "user_type_id" %>
            <% TableHeaderComponent column, "max_length" %>
            <% TableHeaderComponent column, "precision" %>
            <% TableHeaderComponent column, "is_nullable" %>
            <% TableHeaderComponent column, "is_identity" %>
            <% TableHeaderComponent column, "is_computed" %>
            <% next %>
            <th></th>
        </tr>
        <tr class="w3-light-gray">
            <% for each column in ViewData("Columns").Columns %>
            <% TableInputComponent column, "name", html.text("name") %>
            <% TableInputComponent column, "user_type_id", html.text("user_type_id") %>
            <% TableInputComponent column, "max_length", html.text("max_length").Range() %>
            <% TableInputComponent column, "precision", html.text("precision").Range() %>
            <% TableInputComponent column, "is_nullable", html.checklist("is_nullable") %>
            <% TableInputComponent column, "is_identity", html.checklist("is_identity") %>
            <% TableInputComponent column, "is_computed", html.checklist("is_computed") %>
            <% next %>
            <th><% html.Submit("client_rechercher").Value(App.Localizer.Strings("Search")).tostring %></th>
        </tr>
        <% do while not ViewData("Columns").Items.EOF %>
        <tr <% Html.Href("/models/details?name=" & ViewData("Columns").Items.Fields("name")) %>>
            <% for each column in ViewData("Columns").Columns %>
            <% TableDataComponent column, "name", ViewData("Columns").Items.Fields("name") %>
            <% TableDataComponent column, "user_type_id", ViewData("Columns").Items.Fields("user_type_id") %>
            <% TableDataComponent column, "max_length", ViewData("Columns").Items.Fields("max_length") %>
            <% TableDataComponent column, "precision", ViewData("Columns").Items.Fields("precision") %>
            <% TableDataComponent column, "is_nullable", ViewData("Columns").Items.Fields("is_nullable") %>
            <% TableDataComponent column, "is_identity", ViewData("Columns").Items.Fields("is_identity") %>
            <% TableDataComponent column, "is_computed", ViewData("Columns").Items.Fields("is_computed") %>
            <% next %>
            <td></td>
        </tr>
        <% ViewData("Columns").Items.MoveNext %><% loop %>
    </table>
    <% TableFooterComponent ViewData("Columns") %>
</div>
