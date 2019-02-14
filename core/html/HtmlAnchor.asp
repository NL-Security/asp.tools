<%
class HtmlAnchor

    private m_Label
    private m_Url
    private m_Result
    private m_Css
    private m_Click
    private m_Forbidden
    private m_area
    private m_controller
    private m_action
    private m_params
    private m_Route
    private m_Authorizor
    private m_Icon
    private m_Title

    sub class_initialize()
        m_Forbidden = false
        m_Paragraph = false
    end sub
    
    public function Build()
        if IsEmpty(m_Route) then
            dim result
            if not IsEmpty(m_Area) then
                result = "/" & m_Area
            end if
            if not IsEmpty(m_Controller) then
                result = "/" & m_Controller
            end if
            if not IsEmpty(m_Action) then
                result = "/" & m_Action
            end if
            if not IsEmpty(m_Params) then
                result = "?" & m_Params
            end if
            if not IsEmpty(result) then
                m_Route = result
            end if
        end if
    end function
    
    public function Title(p_Title) m_Title = p_Title : set Title = me end function
    public function Icon(p_Icon) m_Icon = p_Icon : set Icon = me end function
    public function GetArea() GetArea = m_Area end function
    public function GetController() GetController = m_Controller end function
    public function GetAction() GetAction = m_Action end function
    public function GetParams() GetParams = m_Params end function
    public function Area(p_Area) m_Area = p_Area : set Area = me end function
    public function Controller(p_Controller) m_Controller = p_Controller : set Controller = me end function
    public function Action(p_Action) m_Action = p_Action : set Action = me end function
    public function Params(p_Params) m_Params = p_Params : set Params = me end function
    public function Forbidden(p_Forbidden) m_Forbidden = p_Forbidden : set Forbidden = me end function
    public function Click(p_Click) m_Click = p_Click : set Click = me end function
    public function Label(p_Label) m_Label = p_Label : set Label = me end function
    public function Url(p_Url)
        p_Url = replace(p_Url, "&&", "&")
        p_Url = replace(p_Url, "?&", "?")
        m_Url = p_Url
        set Url = me
    end function

    public function Css(p_Css)
        if IsEmpty(m_Css) then
            m_Css = p_Css
        else
            m_Css = m_Css & " " & p_Css
        end if
        set Css = me
    end function

    function Append(p_PropertyName, p_Value)
        if not IsEmpty(p_Value) then
            m_Result = m_Result & " " & p_PropertyName & "=""" & p_Value & """"
        end if
    end function

    public default function ToString()
        if not IsEmpty(m_Authorizor) then
        else
            if m_Forbidden then
                ToString = empty
                exit function
            end if
        end if
        Build
        Append "href", m_URL
        Append "href", m_Route
        Append "onclick", m_Click
        Append "class", m_Css
        m_Result = "<a " & m_Result
        if not IsEmpty(m_Title) then
            m_Result = m_Result & " title=""" & m_Title & """"
        end if
        m_Result = m_Result & ">"
        if not IsEmpty(m_Icon) then
            m_Result = m_Result & "<i class=""" & m_Icon & """></i>"
        else
            m_Result =  m_Result & m_Label
        end if
        m_Result =  m_Result & "</a>"
        ToString = m_Result
    end function

end class
%>
