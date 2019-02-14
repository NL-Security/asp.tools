<%
class CdoSmtpMessage

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