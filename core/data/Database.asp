<%
class Database

    private m_Connection
    private m_Errors
    private m_ConnectionString
    
    sub class_initialize()
        set m_Connection = server.CreateObject("adodb.connection")
        set m_Errors = server.CreateObject("scripting.dictionary")
    end sub

    public property get Errors() set Errors = m_Errors end property

    public function WriteErrors()
        for each e in m_Errors.Keys()
            response.Write e & " : " & m_Errors(e) & "<br>"
        next
    end function

    public function copy()
        set copy = (new database)(m_ConnectionString)
    end function

    public function script(p_SQL)
        set result = server.CreateObject("adodb.recordset")
        result.Open p_SQL, m_connection, 3, 3
        set script = result
    end function

    public function Connect()
        m_Connection.Open m_ConnectionString
        set Connect = me
    end function

    public function ConnectionString(p_ConnectionString)
        m_ConnectionString = p_ConnectionString
        set ConnectionString = me
    end function

    public default function Constructor(p_ConnectionString)
        m_ConnectionString = p_ConnectionString
        m_Connection.Open p_ConnectionString
        set Constructor = me
    end function

    public function Entity(p_Entity)
        set Entity = (new DatabaseEntity)(m_Connection).ValidationErrors(m_Errors).Entity(p_Entity)
    end function

    public function BeginTrans()
        m_Connection.BeginTrans()
    end function

    public function CommitTrans()
        m_Connection.CommitTrans()
    end function

    public function RollbackTrans()
        m_Connection.RollbackTrans()
    end function

end class
%>
