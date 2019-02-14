<%
class CdoSmtpClientDelegate
    private m_Options

    public default function CdoSmtpClientDelegate(p_Options)
        set m_Options = p_Options
        set CdoSmtpClientDelegate = me
    end function

    public function Invoke()
        set Invoke = (new CdoSmtpClient)(p_Options)
    end function
end class
%>