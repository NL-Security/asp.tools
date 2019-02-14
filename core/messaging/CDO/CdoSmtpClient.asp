<%
class CdoSmtpClient
    private m_Sender
    private m_error
    private m_Host
    private m_Port

    sub class_initialize()
        set m_Attachments = server.CreateObject("cdo.configuration")
    end sub

    public property get Host() Host = m_Host end property
    public property let Host(p_Host) m_Host = p_Host end property
    public property get Port() Port = m_Port end property
    public property let Port(p_Port) m_Port = p_Port end property

    public default function Constructor(p_Host, p_Port)
        m_Host = p_Options.Host
        m_Port = p_Options.Port
        set Constructor = me
    end function

    function Send(message)
        set errors = server.CreateObject("scripting.dictionary")
        for each recipient in p_Message.Recipient
            set message = CreateObject("CDO.Message")
            message.Configuration.Fields.Item(cdoSendUsingMethod) = cdoSendUsingPort
            message.Configuration.Fields.Item(cdoSMTPServer) = m_Host
            message.Configuration.Fields.Item(cdoSMTPServerPort) = m_Port
            if not IsEmpty(p_Message.UserName) then
                message.Configuration.Fields.Item(cdoSendUserName) = p_Message.UserName
            end if
            if not IsEmpty(p_Message.Password) then
                message.Configuration.Fields.Item(cdoSendPassword) = p_Message.Password
            end if
            message.Configuration.Fields.Update
            message.Sender = p_Message.Sender
            message.Recipient = p_Message.Recipient
            message.Subject = p_Message.Subject
            if not IsEmpty(p_Message.Body) then
                message.Body = p_Message.Body
            end if
            if not IsEmpty(p_Message.HtmlBody) then
                message.HTMLBody = p_Message.HtmlBody
            end if
            for each attachment in attachments
                message.AddAttachment attachment
            next
            message.Send
            if err.Number <> 0 then
                errors.Add r, err.Description
            end if
            set message = nothing
        next
        set SendHtml = errors
    end function

    sub class_terminate()
        set m_Configuration = nothing
    end sub

end class

class MailMessage

    private m_Sender
    private m_Recipient
    private m_Subject
    private m_Body
    private m_HtmlBody
    private m_UserName
    private m_Password
    private m_Attachments

    sub class_initialize()
        set m_Recipient = server.CreateObject("system.collections.arraylist")
        set m_Attachments = server.CreateObject("system.collections.arraylist")
    end sub
    
    public property get Sender() Sender = m_Sender end property
    public property let Sender(p_Sender) m_Sender = p_Sender end property
    public property get UserName() UserName = m_UserName end property
    public property let UserName(p_UserName) m_UserName = p_UserName end property
    public property get Password() Password = m_Password end property
    public property let Password(p_Password) m_Password = p_Password end property
    public property get Body() Body = m_Body end property
    public property let Body(p_Body) m_Body = p_Body end property
    public property get HtmlBody() HtmlBody = m_HtmlBody end property
    public property let HtmlBody(p_HtmlBody) m_HtmlBody = p_HtmlBody end property
    public property get Subject() Subject = m_Subject end property
    public property let Subject(p_Subject) m_Subject = p_Subject end property
    public property get Recipient() Recipient = m_Recipient end property
    public property let Recipient(p_Recipient) m_Recipient = p_Recipient end property
    public property get Attachments() Attachments = m_Attachments end property
    public property let Attachments(p_Attachments) m_Attachments = p_Attachments end property

    public function ImportFromUrl(p_Url)
        set httpRequest = CreateObject("MSXML2.XMLHTTP") 
        httpRequest.Open "GET", p_URL, false
        httpRequest.Send
        m_HtmlBody = httpRequest.ResponseBody
        set httpRequest = nothing
    end function

end class
%>