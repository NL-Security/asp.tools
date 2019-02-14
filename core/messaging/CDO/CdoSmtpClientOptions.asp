<%
class CdoSmtpClientOptions
    private m_Host
    private m_Port
    private m_Username
    private m_Password

    public property get Host() Host = m_Host end property
    public property let Host(p_Host) m_Host = p_Host end property
    public property get Port() Port = m_Port end property
    public property let Port(p_Port) m_Port = p_Port end property
    public property get Username() Username = m_Username end property
    public property let Username(p_Username) m_Username = p_Username end property
    public property get Password() Password = m_Password end property
    public property let Password(p_Password) m_Password = p_Password end property
end class
%>