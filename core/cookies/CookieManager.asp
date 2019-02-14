<%
class CookieManagerBase

    private m_Policy
    private m_Secure
    private m_Domain
    private m_Path
    private m_Expires
    private m_ConsentCookie

    sub class_initialize()
        m_Expires = 365
        m_Secure = false
        m_ConsentCookie = true
        'm_Domain = request.ServerVariables("SERVER_NAME")
    end sub
    
    public property get Domain() Domain = m_Domain end property
    public property let Domain(p_Domain) m_Domain = p_Domain end property
    public property get Path() Path = m_Path end property
    public property let Path(p_Path) m_Path = p_Path end property
    public property get Expires() Expires = m_Expires end property
    public property let Expires(p_Expires) m_Expires = p_Expires end property
    public property get Secure() Secure = m_Secure end property
    public property let Secure(p_Secure) m_Secure = p_Secure end property

    public function Exists(p_Key)
        Exists = Trim(request.Cookies(p_Key)) <> ""
    end function

    public default function Item(p_Key)
        Item = empty
        if Exists(p_Key) then
            Item = request.Cookies(p_Key)
        end if
    end function

    public function Add(p_Key, p_Value, p_SubKey)
        if m_ConsentCookie then
            if not IsEmpty(m_Domain) then
                response.Cookies(p_Key).Domain = m_Domain
            end if
            if not IsEmpty(m_Expires) then
                response.Cookies(p_Key).Expires = Date + m_Expires
            end if
            if not IsEmpty(m_Path) then
                response.Cookies(p_Key).Path = m_Path
            end if
            if m_Secure then
                response.Cookies(p_Key).Secure = True
            end if
            if IsEmpty(p_SubKey) then
                response.Cookies(p_Key) = p_Value
            else
                response.Cookies(p_Key)(p_SubKey) = p_Value
            end if
        end if
    end function

    public function Clear(p_Key)
        if Exists(p_Key) then
            response.Cookies(p_Key).Domain = m_Domain
            response.Cookies(p_Key).Expires = date - 1
        end if
    end function

    public function ClearAll()
        for each k in request.Cookies
            response.Cookies(k).Expires = date - 1
            Clear(k)
        next
    end function

    sub class_terminate()
    end sub

end class
%>