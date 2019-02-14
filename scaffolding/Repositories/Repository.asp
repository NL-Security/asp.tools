<!--#include virtual="/Core/_Assembly.asp"-->
<!--#include virtual="/Data/AdodbContext.asp"-->
<%
'Oui important parce que par ex : Utilisateurs.GetActivateUtilisateurs() <= prend que les ouverts (pas répérer plusieurs fois)
set debugger = new DefaultDebugger
set options = new DbContextOptions
with options
    .ConnectionString = (new JsonReader).Read(request.QueryString("project") & "\appsettings.json")("ConnectionStrings")("DefaultConnection")
end with
set db = (new AdodbContext)(options)
if request.QueryString("table_name") <> "" then
    table_name = request.QueryString("table_name")
end if
set writer = new ASPWriter
%>
<%="<" & "%" %>
class <%=table_name %>repository

    private m_database

    public default function constructor(p_database)
        set m_database = p_database
        set constructor = me
    end function
<%
set tables = db.GetTables(table_name)
do while not tables.EOF
tableName = tables("TABLE_NAME")
set primaryKey = db.GetPrimaryKey(tableName)
primKey = primaryKey("COLUMN_NAME")
%>
    'findall
	public function findall(p_Parameters)
        set findall = m_database.entity("<%=LCase(tableName) %>").Filter(p_Parameters).Sort(p_Parameters).topagedlist
	end function

    'getall
	public function getall()
        set getall = m_database.entity("<%=LCase(tableName) %>").tolist
	end function

    'getbyid
	public function getbyid(p_Id)
        set getbyid = m_database.entity("<%=LCase(tableName) %>").where("<%=primKey %> = " & p_Id).first
	end function

<% if false then %>
    'canadd
	public function canadd()
        set canadd = true
	end function

    'add
	public function add(p_<%=tableName %>)
        p_<%=LCase(tableName) %>.update
	end function

    'canedit
	public function canedit(p_Id)
        set canedit = true
	end function

    'edit
	public function edit(p_<%=tableName %>)
        p_<%=LCase(tableName) %>.update
	end function

    'candelete
	public function candelete(p_Id)
        set candelete = true
	end function

    'delete
	public function delete(p_Id)
        m_database.entity("<%=LCase(tableName) %>").where("<%=primKey %> = " & p_Id).delete()
	end function
<% end if %>
<%
tables.moveNext
loop
%>
	sub class_terminate()
        set connection = nothing
	end sub

end class
%>