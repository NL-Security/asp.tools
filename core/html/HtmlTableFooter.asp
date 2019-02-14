<%
class htmltableFooter
    
    private m_Records

    public function Records(p_Records)
        set m_Records = p_Records
        if m_Records.RecordCount > 0 then
            if isempty(http.querystring("page")) then
                m_Records.absolutepage = 1
            else
                m_Records.absolutepage = CInt(querystring("page"))
            end if
        end if
        set Records = me
    end function

    sub Footer() %>
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

end class
%>