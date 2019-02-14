<%
class htmltable

    private m_ID
    private m_Sorting
    private m_DefaultOrder
    private m_OnRowClick
    private m_CanPaginate
    private m_CanFilter
    private m_CanOrder

    private m_Records
    private m_Columns
    private m_RowLocation
    private m_PageIndex
    private m_PageCount
    private m_Filter
    private m_QueryString
    private m_Paging
    private m_ViewName
    private m_Filters
    private m_DisplayHeader
    private m_footerQuery

    public function HideHeader()
        m_DisplayHeader = false
        set HideHeader = me
    end function

    sub class_initialize()
        m_DisplayHeader = true
        m_CanPaginate = true
        m_CanFilter = true
        m_CanOrder = true
        m_QueryString = request.QueryString
        set m_Columns = server.CreateObject("system.collections.arraylist")
        set m_Filters = server.CreateObject("scripting.dictionary")
    end sub

    public default function Constructor(p_Id)
        m_ID = p_ID
        set Constructor = me
    end function
    
    public property get DisplayHeader() DisplayHeader = m_DisplayHeader end property
    public property let DisplayHeader(p_DisplayHeader) m_DisplayHeader = p_DisplayHeader end property
    public property get ID() ID = m_ID end property
    public property let ID(p_ID) m_ID = p_ID end property
    public property get CanFilter() CanFilter = m_CanFilter end property
    public property let CanFilter(p_CanFilter) m_CanFilter = p_CanFilter end property
    public property get CanOrder() CanOrder = m_CanOrder end property
    public property let CanOrder(p_CanOrder) m_CanOrder = p_CanOrder end property
    public property get CanPaginate() CanPaginate = m_CanPaginate end property
    public property let CanPaginate(p_CanPaginate) m_CanPaginate = p_CanPaginate end property
    public property get Columns() set Columns = m_Columns end property
    public property get Records() set Records = m_Records end property
    public property let Records(p_Records) 
        set m_Records = p_Records
        setPage
    end property
    private function setPage()
        if m_Records.RecordCount > 0 then
            if isempty(http.querystring("page")) then
                m_Records.absolutepage = 1
            else
                m_Records.absolutepage = CInt(querystring("page"))
            end if
        end if
    end function
    public property get RowLocation() RowLocation = m_RowLocation end property
    public property let RowLocation(p_RowLocation) m_RowLocation = p_RowLocation end property
    public property get URLFilter() URLFilter = m_URLFilter end property
    
    public property 

    public property get Query()
        for each f in m_Records.Fields
            if Trim(request.QueryString(f.Name)) <> "" then
                result = result & "&" & f.Name & "=" & request.QueryString(f.Name)
            end if
        next
        if Right(result, 1) = "&" then result = Left(result, Len(result) - 1)
        if Left(result, 1) = "&" then result = Right(result, Len(result) - 1)
        Query = result
        dim result
        result = request.QueryString
        result = Replace(Replace(result, "page=" & request.QueryString("page"), ""), "&&", "&")
        result = Replace(Replace(result, "affichage=" & request.QueryString("affichage"), ""), "&&", "&")
        result = Replace(Replace(result, "order=" & request.QueryString("order"), ""), "&&", "&")
        result = Replace(Replace(result, "search=" & request.QueryString("search"), ""), "&&", "&")
        if Right(result, 1) = "&" then result = Left(result, Len(result) - 1)
    end property

    public function Recordset(p_Records)
        set m_Records = p_Records
        set Recordset = me
    end function

    public function Filter(p_CanFilter)
        m_CanFilter = p_CanFilter
        set Filter = me
    end function

    public function Paginate(p_CanPaginate)
        m_CanPaginate = p_CanPaginate
        set Paginate = me
    end function

    public function Location(p_RowLocation)
        m_RowLocation = p_RowLocation
        set Location = me
    end function

    public function ToList()
        m_CanFilter = true
        m_CanPaginate = false
        m_ID = p_ID
        for each f in m_Records.Fields
            if not f.Properties.Item("ISAUTOINCREMENT").Value then
                AddColumn f.Name
            end if
        next
        set ToList = me
    end function

    public function AddColumn(p_Name)
        set column = new htmltableColumn
        column.WithName(p_Name)
        column.ThenOrder(p_Name)
        m_Columns.Add column
        set AddColumn = column
    end function

    public function Build()
        response.Cookies(m_ID) = ""
        for each column in m_Columns
            if request.QueryString(column.Name) <> "" then
                stringBuilder = stringBuilder & "&" & column.Name & "=" & request.QueryString(column.Name)
            else
                if request.QueryString(column.Name & "1") <> "" then
                    stringBuilder = stringBuilder & "&" & column.Name & "1" & "=" & request.QueryString(column.Name & "1")
                end if
                if request.QueryString(column.Name & "2") <> "" then
                    stringBuilder = stringBuilder & "&" & column.Name & "2" & "=" & request.QueryString(column.Name & "2")
                end if
            end if
        next
        if not IsEmpty(stringBuilder) then stringBuilder = Mid(stringBuilder, 2)
        if not IsEmpty(m_ID) then
            if request.QueryString("order") <> "" then
                response.Cookies(m_ID) = "order=" & request.QueryString("order")
                if request.QueryString("page") <> "" then
                    response.Cookies(m_ID) = "page=" & request.QueryString("page")
                end if
            else
                if request.QueryString("page") <> "" then
                    response.Cookies(m_ID) = "page=" & request.QueryString("page")
                end if
            end if
            if not IsEmpty(stringBuilder) then
                if not IsEmpty(request.Cookies(m_ID)) then response.Cookies(m_ID) =  request.Cookies(m_ID) & "&"
                response.Cookies(m_ID) =  request.Cookies(m_ID) & stringBuilder
            end if
        end if
        set Build = me
    end function

    public property get Order()
        Order = empty
        if not IsEmpty(request.QueryString("order")) then
            Order = m_Columns(request.QueryString("order")).SortName
        end if
    end property

    private function FormatValue(p_DataType, p_Value)
        select case p_DataType
            case aspNumber or aspBoolean
                FormatValue = p_Value
            case else
                FormatValue = "'" & p_Value & "'"
        end select
    end function

    public function Href(p_URL)
        Href = "onclick=""location.href='" & p_URL & "'"""
    end function

    public property get Route()
        if not IsEmpty(m_RowLocation) then
            route = (new TemplateParser).expression(m_RowLocation).object(m_Records).parse
        end if
    end property

    function footerQuery()
        dim result
        if isempty(m_footerquery) then
            for each k in request.QueryString
                if k <> "page" and k <> "search" then
                    result = result & "&" & k & "=" & request.QueryString(k)
                end if
            next
            m_footerQuery = result
        end if
        footerQuery = m_footerquery
    end function

    sub Footer() %>
<% setPage %>
<% if m_Records.RecordCount > 0 then %>
<% if m_CanPaginate and m_Records.RecordCount > 1 then %>
<nav class="w3-card w3-right w3-margin-top">
    <div class="w3-bar w3-border">
        <% if m_Records.PageCount > 1 then %>
        <a class="w3-btn">
            <span><%=m_Records.AbsolutePage %> / <%=m_Records.PageCount %></span>
        </a>
        <a <% if m_Records.PageCount = 1 then %>disabled<% end if %> class="w3-btn <% if m_Records.AbsolutePage = 1 then %>w3-disabled<% end if %>" <% if m_Records.AbsolutePage = 1 then %>onclick="return false;" <% end if %> href="?page=<%=m_Records.AbsolutePage - 1 %><% if not IsEmpty(footerQuery) then %><%=footerQuery %><% end if %>">
            <span>&larr;</span>
        </a>
        <select <% if m_Records.PageCount = 1 then %>disabled<% end if %> class="w3-btn <% if m_Records.PageCount = 1 then %>w3-disabled<% end if %>" id="page" name="page" onchange="this.form.submit();">
            <% dim i %>
            <% for i = 1 to m_Records.PageCount %>
            <option value="<%=i %>" <% if m_Records.AbsolutePage = i then %>selected<% end if %>><%=format.digit(i, 2).tostring() %></option>
            <% next %>
        </select>
        <a <% if m_Records.PageCount = 1 then %>disabled<% end if %> class="w3-btn <% if m_Records.AbsolutePage = m_Records.PageCount then %>w3-disabled<% end if %>" <% if m_Records.AbsolutePage = m_Records.PageCount then %>onclick="return false;" <% end if %> href="?page=<%=m_Records.AbsolutePage + 1 %><% if not IsEmpty(footerQuery) then %><%=footerQuery %><% end if %>">
            <span>&rarr;</span>
        </a>
        <% end if %>
        <a class="w3-btn">
            <span><%=m_Records.RecordCount & " " & "trouvés" %></span>
        </a>
    </div>
</nav>
<% end if %>
<% end if %>
<% end sub

    sub class_terminate
        set m_columns = nothing
    end sub

end class

class htmltableColumn

    private m_Name
    private m_Order
    private m_Display
    private m_URL
    private m_Label
    private m_Format
    private m_ForeignValue
    private m_DataType
    private m_Css
    private m_Style
    private m_Align

    sub class_initialize()
    end sub
    
    public property get Css() Css = m_Css end property
    public property get Style() Style = m_Style end property
    public property get Name() Name = m_Name end property
    public property get Label() Label = m_Label end property
    public property get SortName() SortName = m_SortName end property
    
    public function WithStyle(p_Style)
        if not IsEmpty(m_Style) then
            m_Style = m_Style & " "
        end if
        m_Style = p_Style
        set WithStyle = me
    end function
    public function WithCss(p_Css)
        if not IsEmpty(m_Css) then
            m_Css = m_Css & " "
        end if
        m_Css = p_Css
        set WithCss = me
    end function

    public property get Href()
        dim result
        if request.QueryString("order") = m_Name then
            order_name = m_Name & "2"
        else
            order_name = m_Name
        end if
        result = "?order=" & order_name
        if request.QueryString.Count > 0 then
            result = result & "&" & Replace(Replace(request.QueryString, "order=" & request.QueryString("order"), ""), "&&", "&")
        end if
        result = Replace(result, "&&", "&")
        if right(result, 1) = "&" then result = Left(result, Len(result) - 1)
        Href = result
    end property

    public function AlignRight()
        m_Align = "right-align"
        set AlignRight = me
    end function

    public function URL()
        dim result
        if request.QueryString("order") = m_Name then
            order_name = m_Name & "2"
        else
            order_name = m_Name
        end if
        result = "?order=" & order_name
        if request.QueryString.Count > 0 then
            result = result & "&" & Replace(Replace(request.QueryString, "order=" & request.QueryString("order"), ""), "&&", "&")
        end if
        URL = Replace(result, "&&", "&")
        if right(URL, 1) = "&" then URL = Left(URL, Len(URL) - 1)
    end function
    
    public function WithDataType(p_DataType)
        m_DataType = p_DataType
        set WithDataType = me
    end function

    public function WithName(p_Name)
        m_Name = p_Name
        set WithName = me
    end function
    
    public function WithForeignValue(p_ForeignValue)
        m_ForeignValue = p_ForeignValue
        set WithForeignValue = me
    end function
    
    public function FormatAs(p_Format)
        m_Name = p_Name
        set WithName = me
    end function

    public function WithLabel(p_Label)
        m_Label = p_Label
        set WithLabel = me
    end function

    public function ThenOrder(p_SortName)
        m_Order = p_SortName
        set ThenOrder = me
    end function

    public function Display(p_Display)
        m_Display = p_Display
        set Display = me
    end function

    public function CanDisplay(p_Display)
        CanDisplay = (m_Display and p_Display) = 0
    end function

    public function Header(p_ColumnName, p_Label)
        dim result
        if LCase(m_Name) <> LCase(p_ColumnName) then exit function
        result = result & "<th class=""" & GetDisplay() & """><a href=""" & URL() & """>" & p_Label
        if ArrayContains(request.QueryString("order"), p_ColumnName) then
            result = result & "<i class=""fa fa-arrow-down w3-margin-left""></i></a></th>"
        elseif ArrayContains(request.QueryString("order"), p_ColumnName & "2") then
            result = result & "<i class=""fa fa-arrow-up w3-margin-left""></i></a></th>"
        end if
        response.Write result
    end function

    public function Form2(p_ColumnName, p_Content)
        dim display
        if m_Name <> p_ColumnName then exit function
        response.Write "<th class=""" & GetDisplay() & """>" & p_Content & "</th>"
    end function

    public function Form(p_ColumnName, p_Content)
        dim display
        if m_Name <> p_ColumnName then exit function
        response.Write "<th class=""" & GetDisplay() & """>" & p_Content.tostring() & "</th>"
    end function

    public function Data(p_ColumnName, p_Value)
        if LCase(m_Name) <> LCase(p_ColumnName) then exit function
        dim result
        result = result & "<td class=""" & GetDisplay() & """>" & p_Value & "</td>"
        response.Write result
    end function

    private function GetDisplay()
        if m_Display = 1 then GetDisplay = GetDisplay & "w3-hide-small w3-hide-medium"
        if m_Display = 2 then GetDisplay = GetDisplay & "w3-hide-small"
        if not isempty(m_Align) then
            GetDisplay = GetDisplay & " w3-" & m_Align
        end if
    end function
end class
%>