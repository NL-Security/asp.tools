<%
class HttpRoute
    
    private m_Route
    private m_Area
    private m_Controller
    private m_Action
    
	public property get Area() Area = m_Area end property
	public property let Area(p_Area) m_Area = p_Area end property
	public property get Controller() Controller = m_Controller end property
	public property let Controller(p_Controller) m_Controller = p_Controller end property
	public property get Action() Action = m_Action end property
	public property let Action(p_Action) m_Action = p_Action end property
	public property get Route() Route = m_Route end property
	public property let Route(p_Route) m_Route = p_Route end property

    sub class_initialize()
        dim script_name
        script_name = request.ServerVariables("SCRIPT_NAME")
        start_index = 3
        script_array = Split(request.ServerVariables("SCRIPT_NAME"), "/")
        if UBound(script_array) > 3 then
            m_Area = lcase(script_array(2))
        end if
        m_Action = Replace(lcase(script_array(UBound(script_array))), ".asp", "")
        m_Controller = Replace(lcase(script_array(UBound(script_array) - 1)), ".asp", "")
        m_Route = m_Area & "/" & m_Controller & "/" & m_Action
    end sub

end class
%>
