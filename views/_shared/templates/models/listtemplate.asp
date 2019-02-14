<table class="w3-table">
    <tr>
        <th class="w3-cursor" style="width: 24px">
            <i class="fas fa-check-square"></i>
            <input type="checkbox" class="w3-check w3-hide" /></th>
        <% for each column in models.Columns %>
        <% TableHeaderComponent column, "name" %>
        <% next %>
        <th>View</th>
        <th></th>
    </tr>
    <% do while not models.Items.EOF %>
    <tr <% Html.Href("/setup/models/details?object_id=" & models.Items.Fields("object_id")) %>>
        <th class="w3-cursor">
            <i class="fas fa-square"></i>
            <input type="checkbox" class="w3-check w3-hide" /></th>
        <% for each column in models.Columns %>
        <% TableDataComponent column, "name", models.Items.Fields("name") %>
        <% next %>
        <td></td>
        <td></td>
    </tr>
    <% models.Items.MoveNext %>
    <% loop %>
</table>
