<%
class HtmlBuilder
    private m_AuthorizationService
    private m_FallBack
    private m_Antiforgery
    private m_DisplayIfNull
    private m_TextareaIsEditor
    private m_ErrorMessages
    private m_FirstName

    sub class_initialize()
        m_DisplayIfNull = true
        m_TextareaIsEditor = false
    end sub

    public function ErrorMessages(p_ErrorMessages)
        set m_ErrorMessages = p_ErrorMessages
        set ErrorMessages = me
    end function

    public default function Constructor(p_AuthorizationService)
        set m_AuthorizationService = p_AuthorizationService
        set Constructor = me
    end function
    
    public function FirstName(p_FirstName) m_FirstName = p_FirstName : set FirstName = me end function

    public property get TextareaIsEditor() TextareaIsEditor = m_TextareaIsEditor end property
    public property let TextareaIsEditor(p_TextareaIsEditor) m_TextareaIsEditor = p_TextareaIsEditor end property

    public property get DisplayIfNull() DisplayIfNull = m_DisplayIfNull end property
    public property let DisplayIfNull(p_DisplayIfNull) m_DisplayIfNull = p_DisplayIfNull end property

    public property get Fallback() Fallback = m_Fallback end property
    public property let Fallback(p_Fallback) m_Fallback = p_Fallback end property

    public function Antiforgery(p_Antiforgery)
        set m_Antiforgery = p_Antiforgery
        set Antiforgery = me
    end function

    public function WithFallback(p_fallback)
        m_FallBack = p_Fallback
        set WithFallback = me
    end function
    
    public function AntiForgeryToken(p_Token)
        m_Antiforgery.SetCookie()
        set AntiForgeryToken = (new HtmlAntiForgeryToken).Token(m_Antiforgery.SecurityToken)
    end function

    public function TableFooter(p_Records)
        set footer = new htmltableFooter
        footer.records(p_Records).footer
        close footer
    end function

    public function Editor(p_Name)
        set Editor = (new HtmlEditor).Name(p_Name).id(p_Name).Css("w3-editor w3-input w3-border")
    end function

    public function Textarea(p_Name)
        set Textarea = (new HtmlTextarea).Name(p_Name).id(p_Name).Css("w3-input w3-border").Editor(m_TextareaIsEditor)
    end function
    public function List(p_Name)
        set List = (new HtmlList).Name(p_Name).id(p_Name).Css("w3-input w3-border").FirstName(m_FirstName)
    end function
    public function Hidden(p_Name)
        set Hidden = GetInput(p_Name, "hidden")
    end function
    public function Text(p_Name)
        set Text = GetInput(p_Name, "text").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function Url(p_Name)
        set Url = GetInput(p_Name, "url").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function File(p_Name)
        set File = GetInput(p_Name, "file").Css("w3-input").Error(GetError(p_Name))
    end function
    public function CheckBox(p_Name)
        set CheckBox = GetInput(p_Name, "checkbox").Css("w3-check w3-margin-right").Error(GetError(p_Name))
    end function
    public function Password(p_Name)
        set Password = GetInput(p_Name, "password").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function Number(p_Name)
        set Number = GetInput(p_Name, "number").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function Email(p_Name)
        set Email = GetInput(p_Name, "email").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function Tel(p_Name)
        set Tel = GetInput(p_Name, "tel").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function Submit(p_Name)
        set Submit = GetInput(p_Name, "submit").Css("w3-btn w3-theme")
    end function
    public function Time()
        set Time = new HtmlTime
    end function
    public function Day(p_Name)
        set Day = GetInput(p_Name, "date").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function DayTime(p_Name)
        set DayTime = GetInput(p_Name, "datetime-local").Css("w3-input w3-border").Error(GetError(p_Name))
    end function
    public function Week()
        set Week = new HtmlWeek
    end function
    public function Month()
        set Month = new HtmlMonth
    end function
    public function Year()
        set Year = new HtmlMonth
    end function
    public function Span(p_Value)
        if not m_DisplayIfNull and IsNull(p_Value) then
            exit function
        end if
        set Span = (new HtmlSpan).Value(p_Value).fallback(m_FallBack)
    end function
    public function Var(p_Value)
        if not m_DisplayIfNull and IsNull(p_Value) then
            exit function
        end if
        set Var = (new HtmlVar).Value(p_Value).fallback(m_FallBack)
    end function
    private function GetInput(p_Name, p_TypeName)
        set GetInput = (new HtmlInput).id(p_Name).Name(p_Name).TypeName(p_TypeName)
    end function

    public function Anchor(p_Label)
        set Anchor = (new HtmlAnchor).label(p_Label)
    end function

    public function TrashIcon(p_Url)
        set TrashIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-trash w3-text-red").Click("return window.confirm('Voulez-vous vraiment supprimer cet enregistrement ?');")
    end function

    public function SearchIcon(p_Url)
        set SearchIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-search")
    end function

    public function PlusIcon(p_Url)
        set PlusIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-plus")
    end function

    public function FileIcon(p_Url)
        set FileIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-file")
    end function

    public function ListIcon(p_Url)
    set ListIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-list")
    end function

    public function CloneIcon(p_Url)
        set CloneIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-clone")
    end function

    public function BoxIcon(p_Url)
        set BoxIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-box")
    end function

    public function Icon(p_Url, p_Icon)
        set Icon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-" & p_Icon)
    end function

    public function arrowdownIcon(p_Url)
        set arrowdownIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-arrow-down")
    end function

    public function arrowupIcon(p_Url)
        set arrowupIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-arrow-up")
    end function

    public function checkIcon(p_Url)
        set checkIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("fas fa-check")
    end function

    public function checkkIcon
        set checkkIcon = (new HtmlAnchor).Css("w3-right").Icon("fas fa-check")
    end function

    public function squareIcon(p_Url)
        set squareIcon = (new HtmlAnchor).Url(p_Url).Css("w3-right").Icon("far fa-square")
    end function


    public function NavItem(p_Url)
        set NavItem = (new HtmlAnchor).Url(p_Url).Css("w3-bar-item w3-btn")
    end function

    public function Route(p_Route, p_Parameters)
        dim url
        url = p_Route
        if not IsEmpty(p_Parameters) then
            url = url & "?" & p_Parameters
        end if
        set Route = (new HtmlAnchor).Url(url).Css("w3-bar-item w3-btn")
    end function

    public function ActionString(p_Action, p_Parameters)
        dim url
        if not IsEmpty(http.Route.Area) then
            url = url & "/" & http.Route.Area
        end if
        url = url & "/" & http.Route.Controller
        if IsEmpty(p_Action) then
            url = url & "/index"
        else
            url = url & "/" & p_Action
        end if
        if not IsEmpty(p_Parameters) then
            url = url & "?" & p_Parameters
        end if
        set ActionString = (new HtmlAnchor).Url(url).Css("w3-bar-item w3-btn")
    end function

    public function Action(p_Action)
        dim url
        if not IsEmpty(http.Route.Area) then
            url = url & "/" & http.Route.Area
        end if
        url = url & "/" & http.Route.Controller
        if IsEmpty(p_Action) then
            url = url & "/index"
        else
            url = url & "/" & p_Action
        end if
        set Action = (new HtmlAnchor).Url(url).Css("w3-bar-item w3-btn")
    end function
    
    public function TriggerItem(p_Id)
        set TriggerItem = (new HtmlAnchor).Click("$('#" & p_Id & "').click()").Css("w3-bar-item w3-btn w3-theme")
    end function
    
    public function Link()
        set Link = (new HtmlAnchor).Css("w3-bar-item w3-btn")
    end function

    public function DeleteItem(p_Url)
        set DeleteItem = (new HtmlAnchor).Url(p_Url).label("Supprimer").Css("w3-bar-item w3-btn w3-theme").Click("return window.confirm('Voulez-vous vraiment supprimer cet enregistrement ?');")
    end function

    public function CheckList(p_Name)
        dim items
        set items = server.CreateObject("adodb.recordset")
        with items
            .Fields.Append "Value", adInteger
            .Fields.Append "Text", adVarChar, 5
            .Open , , adOpenDynamic, adLockOptimistic
            .AddNew
            .Fields("Value") = 1
            .Fields("Text") = "Oui"
            .AddNew
            .Fields("Value") = 0
            .Fields("Text") = "Non"
        end with
        items.MoveFirst
        set CheckList = (new HtmlList).Name(p_Name).id(p_Name).Items(items).Key("Value").Text("Text").Css("w3-input w3-border")
    end function

    public function GetError(p_Name)
        if m_ErrorMessages.Exists(p_Name) then
            if m_ErrorMessages(p_Name) = "required" then
                GetError = "Ce champ est obligatoire"
            elseif m_ErrorMessages(p_Name) = "invalid" then
                GetError = "Ce champ est invalide"
            end if
        end if
    end function

    public function Authorize(p_Url)
        Authorize = true
    end function
end class
%>
