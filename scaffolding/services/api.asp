<!--#include virtual="/Core/_Assembly.asp"-->
<!--#include virtual="/Data/AdodbContext.asp"-->
<%
set debugger = new DefaultDebugger
set options = new DbContextOptions
with options
    .ConnectionString = (new JsonReader).Read(request.QueryString("project") & "\appsettings.json")("ConnectionStrings")("DefaultConnection")
end with
set db = (new AdodbContext)(options)
set writer = new ASPWriter
%>
<%="<!--#include virtual=""/Program.asp""-->" %>
<%="<!--#include virtual=""/Repositories/" & writer.pluralize(request.QueryString("table_name")) & "repository.asp""-->" %>
<%="<" & "%" %>
class <%=writer.pluralize(request.QueryString("table_name")) %>controller

    private m_<%=writer.pluralize(request.QueryString("table_name")) %>repository

	sub class_initialize()
        set m_<%=writer.pluralize(request.QueryString("table_name")) %>repository = new <%=writer.pluralize(request.QueryString("table_name")) %>repository
	end sub

    'Index
	public function Index()
        set json = new JSONArray
        json.LoadRecordset m_<%=writer.pluralize(request.QueryString("table_name")) %>repository.Get<%=writer.pluralize(request.QueryString("table_name")) %>(empty, empty)
        json.Write
        set json = nothing
	end function

    'Details
	public function Details()
        set json = new JSONObject
        json.LoadRecordset m_<%=writer.pluralize(request.QueryString("table_name")) %>repository.Get<%=TableName %>ById(request.QueryString("<%=lcase(request.QueryString("table_name")) %>_id"))
        json.Write()
        set json = nothing
	end function

    'Create
	public function Create()
		if request.ServerVariables("request_method") = "POST" then
            set <%=lcase(request.QueryString("table_name")) %> = m_<%=writer.pluralize(request.QueryString("table_name")) %>repository.AddNew<%=TableName %>()
			if ModelState.IsValid(<%=lcase(request.QueryString("table_name")) %>) then
                m_<%=writer.pluralize(request.QueryString("table_name")) %>repository.Update<%=TableName %>(<%=lcase(request.QueryString("table_name")) %>)
			end if
		end if
	end function

    'Edit
	public function Edit()
		if request.ServerVariables("request_method") = "POST" then
            set <%=lcase(request.QueryString("table_name")) %> = m_<%=writer.pluralize(request.QueryString("table_name")) %>repository.Get<%=TableName %>ById(request.QueryString("<%=lcase(request.QueryString("table_name")) %>_id"))
			if ModelState.IsValid(<%=lcase(request.QueryString("table_name")) %>) then
                m_<%=writer.pluralize(request.QueryString("table_name")) %>repository.Update<%=TableName %>(<%=lcase(request.QueryString("table_name")) %>)
			end if
		end if
	end function

    'Delete
	public function Delete()
        m_<%=writer.pluralize(request.QueryString("table_name")) %>repository.Delete<%=TableName %>(request.QueryString("<%=lcase(request.QueryString("table_name")) %>_id"))
	end function

	sub class_terminate()
        set m_<%=writer.pluralize(request.QueryString("table_name")) %>repository = nothing
	end sub

end class
response.ContentType="application/json"
set controller = new <%=writer.pluralize(request.QueryString("table_name")) %>controller
eval "controller." & request.QueryString("action")
<%="%" & ">" %>