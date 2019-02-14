<%
class debugmanager
    private m_Messages
    private m_StartTime

    sub class_initialize()
        m_StartTime = Timer
        set m_Messages = server.CreateObject("system.collections.arraylist")
    end sub

    public property get Messages() set Messages = m_Messages end property

    sub Debug(p_value)
        if request.Cookies("mode") = "debug" then
            response.Write "<div style=""z-index: 10000; background: #00ff90;padding: 2px 5px"">" & p_value & "</div>"
        end if
    end sub

    sub DebugKey(p_key, p_value)
        if request.Cookies("mode") = "debug" then
            response.Write "<div style=""background: #00ff90;padding: 2px 5px"">" & p_key & " : " & p_value & "</div>"
        end if
    end sub

    sub Test(p_value)
        response.Write "<div style=""background: #00ff90;padding: 2px 5px"">" & p_value & "</div>"
    end sub

    sub TestKey(p_key, p_value)
        response.Write "<div style=""background: #ffd800;padding: 2px 5px"">" & p_key & " : " & p_value & "</div>"
    end sub

    sub TestType(p_var)
        Test TypeName(p_var)
    end sub

    sub TestEnd()
        response.End
    end sub

    sub DebugEnd()
        if request.Cookies("mode") = "debug" then
            response.End
        end if
    end sub

    sub DebugType(p_var)
        Debug TypeName(p_var)
    end sub

    sub DebugTime()
        Debug (Timer - m_StartTime)
    end sub

    sub Log(p_Message)
        if true or request.Cookies("mode") = "debug" then
            m_Messages.Add (Timer - m_StartTime) & " : " & p_Message
        end if
    end sub

    function Handle()
        if request.QueryString("mode") <> "" then
            if request.QueryString("mode") = "debug" then
                response.Cookies("mode") = "debug"
            elseif request.QueryString("mode") = "normal" then
                response.Cookies("mode") = ""
            end if
            Redirect
        end if
    end function

    function Redirect()
        dim result
        for each k in request.QueryString
            if k <> "mode" then
                result = result & "&" & k & "=" & request.QueryString(k)
            end if
        next
        if not isempty(result) then
            response.Redirect "?" & right(result, len(result) - 1)
        else
            response.Redirect "?"
        end if
    end function

    sub Start()
        response.Cookies("mode") = "debug"
    end sub

    sub Terminate()
        response.Cookies("mode") = ""
    end sub

end class
%>