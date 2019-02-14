<%
class HttpContext

    private m_Cookies
    private m_QueryString
    private m_Form
    private m_Route
    private m_Post

    sub class_initialize()
        if instr(1, request.servervariables("HTTP_CONTENT_TYPE"), "multipart", 1) = 1 then
            set m_Post = createobject("aspsmartupload.smartupload")
            poster.maxfilesize = 2000000000
            poster.upload
        else
            set m_Post = request
        end if
        set m_QueryString = server.CreateObject("scripting.dictionary")
        for each k in request.QueryString
            if Trim(request.QueryString(k)) <> "" then
                m_QueryString.Add k, request.QueryString(k)
            end if
        next
        set m_Form = server.CreateObject("scripting.dictionary")
        for each k in m_Post.Form
            if Trim(m_Post.Form(k)) <> "" then
                m_Form.Add k, m_Post.Form(k)
            end if
        next
        set m_Cookies = server.CreateObject("scripting.dictionary")
        for each k in request.Cookies
            if Trim(request.Cookies(k)) <> "" then
                m_Cookies.Add k, request.Cookies(k)
            end if
        next
    end sub

    public function Post()
        set Post = m_Post
    end function

    function andcookies(p_Key)
        andcookies = empty
        if Trim(request.Cookies(p_Key)) <> "" then
            andcookies = "&" & request.Cookies(p_key)
        end if
    end function

    function cookies(p_Key)
        cookies = empty
        if m_Cookies.Exists(p_key) then
            cookies = m_Cookies(p_key)
        end if
    end function

    function form(p_Key)
        form = empty
        if m_Form.Exists(p_key) then
            form = m_Form(p_key)
        end if
    end function

    function querystring(p_Key)
        p_Key = cstr(p_Key)
        querystring = empty
        if m_QueryString.Exists(p_key) then
            querystring = m_QueryString(p_key)
        end if
    end function

    function andquerystring(p_Key)
        p_Key = cstr(p_Key)
        andquerystring = empty
        if m_QueryString.Exists(p_key) then
            andquerystring = "&" & p_key & "=" & m_QueryString.Item(p_key)
        end if
    end function

    function withcookies(p_Key)
        p_Key = cstr(p_Key)
        withcookies = empty
        if Trim(request.Cookies(p_Key)) <> "" then
            withcookies = "?" & request.Cookies(p_key)
        end if
    end function

    public property get Route() 
        if isempty(m_Route) then
            set m_Route = new HttpRoute
        end if
        set Route = m_Route
    end property

    public property get QueryStrings()
        set QueryStrings = m_QueryString
    end property

    public property get Forms()
        set Forms = m_Form
    end property

end class
%>
