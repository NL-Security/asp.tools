<%
class ConsoleLogger

    private m_Logs
    private m_StartTime
    private m_IsActive

    sub class_initialize()
        m_IsActive = false
        m_StartTime = Timer
        set m_Logs = server.CreateObject("system.collections.arraylist")
    end sub

    public function Enable()
        m_IsActive = true
        set Activate = me
    end function

    public function Disable()
        m_IsActive = true
        set Disable = me
    end function

    public property get Logs() set Logs = m_Logs end property

    public function GetTime()
        GetTime = (Timer - m_StartTime)
    end function

    sub Log(p_Key, p_Log)
        if m_IsActive then
            m_Logs.Add p_Key, p_Log
        end if
    end sub

    sub ToString()
        dim result
        result = result & "<script type=""text/javascript"">" & vbcrlf
        for each l in m_Logs
            result = result & vbtab & vbtab & "console." & l.Level & "('" & l.Message & "');" & vbcrlf
        next
        result = result & vbtab & "</script>"
        response.Write result
    end sub

    public default function AddLog(p_Message)
        set AddLog = new ConsoleLog
        AddLog.SetMessage(p_Message)
        m_Logs.Add AddLog
    end function

end class

class ConsoleLog
    
    private m_Level
    private m_Message

    sub class_initialize()
        m_Level = "info"
    end sub

    public function Log()
        response.Write "<script type=""text/javascript"">console." & m_Level & "('" & m_Message & "');</script>"
    end function
    
    public property get Message() Message = m_Message end property
    public property get Level() Level = m_Level end property

    public function SetMessage(p_Message)
        m_Message = p_Message
    end function

    public function Error()
        m_Level = "error"
        set Error = me
    end function
    public function Info()
        m_Level = "info"
        set Info = me
    end function
    public function Warn()
        m_Level = "warn"
        set Warn = me
    end function

end class
%>