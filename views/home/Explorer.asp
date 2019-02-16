<!--#include virtual="/startup.asp"-->
<!--#include virtual="/views/_shared/header.asp"-->
<div class="w3-row">
    <% set tables = schemaservice.GetModels(empty) %>
    <% do while not tables.EOF %>
    <div class="w3-col m12 w3-margin-bottom">
        <header class="w3-container">
            <p class="w3-text-red"><%=lcase(tables("Table_Name").Value) %></p>
        </header>
        <div class="w3-col m9" style="padding: 0!important">
            <% set columns = schemaservice.GetColumns(tables("Table_Name").Value) %>
            <table class="w3-table w3-bordered w3-card-4">
                <tr class="w3-primary">
                    <th>Name</th>
                    <th>GUID</th>
                    <th>Datatype</th>
                    <th>Length</th>
                    <th>Numeric Precision</th>
                    <th>DateTime Precision</th>
                    <th>Scale</th>
                    <th>Allow Nulls</th>
                    <th>HasDefault</th>
                    <th>Default Value</th>
                    <th>Description</th>
                </tr>
                <% do while not columns.EOF %>
                <tr>
                    <td><%=lcase(columns("Column_Name")) %></td>
                    <td><%=columns("Column_Guid") %></td>
                    <td><%=columns("Data_Type") %></td>
                    <td><%=columns("Character_Maximum_Length") %></td>
                    <td><%=columns("Numeric_Precision") %></td>
                    <td><%=columns("Datetime_Precision") %></td>
                    <td><%=columns("Numeric_Scale") %></td>
                    <td><%=columns("Is_Nullable") %></td>
                    <td><%=columns("Column_HasDefault") %></td>
                    <td><%=columns("Column_Default") %></td>
                    <td><%=columns("Description") %></td>
                </tr>
                <% columns.MoveNext %>
                <% loop %>
                <% set columns = nothing %>
            </table>
        </div>
        <div class="w3-col m3" style="padding: 0!important">
            <table class="w3-table w3-bordered w3-card-4">
                <% set foreignKeys = schemaservice.GetForeignKeys(tables("Table_Name").Value, "FK") %>
                <% if foreignKeys.RecordCount > 0 then %>
                <tr class="w3-primary">
                    <th colspan="2">Objects dont depend <%=tables("Table_Name").Value %></th>
                </tr>
                <% end if %>
                <% do while not foreignKeys.EOF %>
                <tr>
                    <td><%=lcase(foreignKeys("PK_TABLE_NAME")) %></td>
                    <td><%=lcase(foreignKeys("FK_COLUMN_NAME")) %></td>
                </tr>
                <% foreignKeys.MoveNext %>
                <% Loop %>
                <% set foreignKeys = Nothing %>
                <% set foreignKeys = schemaservice.GetForeignKeys(tables("Table_Name").Value, "PK") %>
                <% if foreignKeys.RecordCount > 0 then %>
                <tr class="w3-primary">
                    <th colspan="2">Objects dependants de <%=tables("Table_Name").Value %></th>
                </tr>
                <% end if %>
                <% do while not foreignKeys.EOF %>
                <tr>
                    <td><%=lcase(foreignKeys("FK_TABLE_NAME")) %></td>
                    <td><%=lcase(foreignKeys("FK_COLUMN_NAME")) %></td>
                </tr>
                <% foreignKeys.MoveNext %>
                <% loop %>
                <% set foreignKeys = Nothing %>
            </table>
        </div>
    </div>
    <% tables.MoveNext %>
    <% loop %>
    <% tables.Close %>
    <% set tables = Nothing %>
</div>
<!--#include virtual="/views/_shared/footer.asp"-->
