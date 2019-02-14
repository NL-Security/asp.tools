<%
class ASPWriter
    public function Lower(p_value)
        Lower = LCase(Mid(p_value, 1, 1)) & Mid(p_value, 2)
    end function

    public function Pluralize(p_value)
        dim value
        value = p_value
        if right(value, 1) = "y" then
            value = Left(value, Len(value) - 1) & "ie"
        elseif right(value, 1) = "s" then
            Pluralize = value
            exit function
        end if
        Pluralize = value & "s"
    end function

    public function Enclose(p_ASP)
        response.Write "<% " & p_ASP & " %" & ">"
    end function

    public function Write(p_ASP)
        response.Write "<%=" & p_ASP & " %" & ">"
    end function
    
    public property get StartWrite() Start = "<% " end property
    public property get Start() Start = "<% " end property
    public property get Terminate() Terminate = " %" & ">" end property

    
end class
%>