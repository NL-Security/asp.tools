<% 
class SQLGuardian

    private m_ErrorPage
    private m_BlackList

    sub class_initialize
        m_BlackList = Array("--", ";", "/*", "*/", "@@",_
            "char", "nchar", "varchar", "nvarchar",_
            "alter", "begin", "cast", "create", "cursor",_
            "declare", "delete", "drop", "end", "exec",_
            "execute", "fetch", "insert", "kill", "open",_
            "select", "sys", "sysobjects", "syscolumns",_
            "table", "update", "union")
    end sub

    public function ErrorPage(p_ErrorPage)
        m_ErrorPage = p_ErrorPage
        set ErrorPage = me
    end function

    private function IsBlack(p_String)
      
        if (IsEmpty(p_String)) then
            IsBlack = false
            exit function
        elseif (StrComp(p_String, "") = 0) then
            IsBlack = false
            exit function
        end if
        p_String = lcase(p_String)
  
        for each black in m_BlackList
            if (InStr(p_String, black) <> 0) then
                IsBlack = true
                exit function
            end if
        next
  
        IsBlack = false
  
    end function 

    public function Scan()

        for each key in Request.Form
            if (IsBlack(Request.Form(key))) then
                Response.Redirect(m_ErrorPage & "?exception=INVALID_KEY&args=" & key & "&value=" & Request.Form(key))
            end if
        next

        for each key in Request.QueryString
            if (IsBlack(Request.QueryString(key))) then
                Response.Redirect(m_ErrorPage & "?exception=INVALID_KEY&key=" & key & "&value=" & Request.QueryString(key))
            end if
        next

        for each key in Request.Cookies
            if (IsBlack(Request.Cookies(key))) then
                Response.Redirect(m_ErrorPage & "?exception=INVALID_KEY&key=" & key & "&value=" & Request.Cookies(key))
            end if  
        next

        set Scan = me

    end function
end class
%>
