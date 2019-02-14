<%
function test(p_Value)
    debugger.test p_Value
end function
function testkey(p_key, p_value)
    debugger.testkey p_key, p_value
end function
function testend()
    debugger.testend
end function
function debug(p_Value)
    debugger.debug p_Value
end function
function debugkey(p_key, p_value)
    debugger.debugkey p_key, p_value
end function
function debugend()
    debugger.testend
end function
%>
<%
public function vbenc() vbenc = "<% " end function
public function vbend() vbend = " %" & ">" end function
public function vbwr() vbwr = "<%=" end function
%>
<%
public function Pluralize(p_value)
    if right(p_Value, 1) = "y" then
        p_Value = Left(p_value, Len(p_Value) - 1) & "ie"
    elseif right(p_Value, 1) = "s" then
        Pluralize = p_Value
        exit function
    end if
    Pluralize = p_value & "s"
end function
function ConvertToList(p_data)
    set result = server.CreateObject("system.collections.arraylist")
    data_array = split(p_data, ",")
    for i = 0 to UBound(data_array)
        if data_array(i) <> "" then
            result.add trim(data_array(i))
        end if
    next
    set ConvertToList = result
end function
%>
<%
function SwitchList(p_listitem, p_list, p_range)
    dim range, list, index
    set range = converttolist(p_Range)
    set list = converttolist(p_list)
    index = list.indexof(CStr(p_listitem), 0)
    list.insertrange index, (range)
    set result = list
    set SwitchList = result
end function
%>
<%
function Kill()
    response.End
end function
sub Close(p_Object)
    if vartype(p_object) = 9 then
        set p_Object = nothing
    end if
end sub
public function SectionExists(p_Section)
    SectionExists = false
    on error resume next
    SectionExists = not GetRef(p_Section) is nothing
    if err.number <> 0 then
        err.Clear
    end if
    on error goto 0
end function

function DateInput(value_date)
    DateInput = null
    if not IsDate(value_date) then exit function
    value_date = CDate(value_date)
    DateInput = Year(value_date) & "-" & FormatDigit(Month(value_date), 2) & "-" & FormatDigit(Day(value_date), 2)
end function


private function NextDateOpenDays(p_Date, p_Days)
    dim result
    select case datepart("w", dateadd("d", p_Days, p_Date))
        case 6
	        result = dateadd("d", p_Days + 2, p_Date)
        case 7
		    result = dateadd("d", p_Days + 1, p_Date)
        case else
		    result = dateadd("d", p_Days, p_Date)
    end select
    NextDateOpenDays = result
end function
%>
<%  
function CreateGuid()
	set typeLib = server.CreateObject("Scriptlet.TypeLib")
	CreateGuid = Mid(server.CreateObject("Scriptlet.TypeLib").Guid, 2, 36)
	set typeLib = nothing
end function
%>

<%
function FormatPath(p_path)
    formatpath = p_path
    formatpath = replace(formatpath, "/", "\")
    formatpath = replace(formatpath, "\\", "\")
end function
%>
<%
function formatTableText(p_text)
    if isnull(p_text) then
        exit function
    end if
    p_text = replace(p_text, "<p>", "")
    p_text = replace(p_text, "</p>", "<br />")
    formatTableText = p_text
end function
%>
<%'DateInput - formatte la date au format du calendrier HTML %>
<%'DateInput(value_date) %>
<%
function DateInput(value_date)
    DateInput = null
    if not IsDate(value_date) then exit function
    value_date = CDate(value_date)
    DateInput = Year(value_date) & "-" & FormatDigit(Month(value_date), 2) & "-" & FormatDigit(Day(value_date), 2)
end function
function FormatDigit(digit, length)
    ratio = length - Len(digit)
    do while ratio > 0
        digit = "0" & digit
        ratio = ratio - 1
    loop
    FormatDigit = digit
end function    
%>
<%'NumberInput %>
<%'NumberInput(value, default_value) %>
<% 
function NumberInput(value, default_value)
    NumberInput = default_value
    if IsNull(value) then exit function
    NumberInput = Replace(value, ",", ".")
end function
function ArrayContains(p_Values, p_Value)
    dim arr
    if IsNull(p_Values) then
        ArraysContains = false
        exit function
    end if
    dim i
    arr = Split(p_Values, ",")
    ArrayContains = false
    if IsNull(p_Value) or p_Value = "" then
        exit function
    end if
    for i = 0 to UBound(arr)
        arr(i) = Trim(arr(i))   
        if CStr(arr(i)) = CStr(p_Value) then
            ArrayContains = true
            exit function
        end if
    next
end function
%>
<%
class TemplateParser
    private m_expression
    private m_object
    private m_result
    public function expression(p_expression)
        m_expression = p_expression
        set expression = me
    end function
    public function object(p_object)
        set m_object = p_object
        set object = me
    end function
    public property get result()
        result = m_result
    end property
    function Find()
        set regex = new regexp
        regex.pattern = "\{.*?\}"
        regex.ignoreCase = false
        regex.global = false
        set Find = regex.Execute(m_expression)
    end function
    function Parse()
        dim matches
        m_result = m_expression
        set regex = new regexp
        regex.pattern = "\{.*?\}"
        regex.ignoreCase = false
        regex.global = true
        set matches = regex.Execute(m_expression)
        for each m in matches
            if not m_object.eof then
                if not isnull(m_object(clean(m.value))) and not isempty(m_object(clean(m.value))) then
                    m_result = Replace(m_result, m.value, m_object(clean(m.value)))
                end if
            end if
        next
        parse = m_result
    end function
    function clean(value)
        dim i
        delimiters = "{}"
        for i = 1 to Len(delimiters)
            value = Replace(value, Mid(delimiters, i, 1), "")
        next
        clean = value
    end function
end class
%>
<%
function Concat(p_Value, p_Term)
    if not IsEmpty(p_Value) then
        Concat = p_Term
    end if
    Concat = Concat & p_Value
end function
%>
<%
function Routes(p_Route)
    response.Redirect p_Route
end function
%>

<%
function Substring(p_Value, p_Scheme)
    Substring = Replace(p_Value, p_Scheme, "")
end function

Function ControleIban(LeNumIban)
	LeNumIban = CStr(LeNumIban)
	Dim x
	LeNumIban = Replace(LeNumIban, " ", "")
	LeNumIban = Replace(LeNumIban, "-", "")
	if Len(LeNumIban) < 4 then
		ControleIban = False
		exit function
	end if
	LeNumIban = Right(LeNumIban, Len(LeNumIban) - 4) & Left(LeNumIban, 4)
	n = 1
	While n <= Len(LeNumIban)
		x = Mid(LeNumIban, n, 1)
		If Not IsNumeric(x) Then
			LeNumIban = Replace(LeNumIban, x, Asc(CStr(x)) - 55, 1, 1)
		End If
		n = n + 1
	Wend
	n_iban = Mod97(LeNumIban)
	If n_iban = 1 Then
		ControleIban = True
	Else
		ControleIban = False
	End If
		ControleIban = True
End Function

Function Mod97(ByVal vIban)
    Dim i, m, digit
    m = 0
    For i = 1 To Len(vIban)
		if not IsNumeric(Mid(vIban, i, 1)) then
			Mod97 = m
			exit function
		end if
        digit = CInt(Mid(vIban, i, 1))
        m = (10*m + digit) Mod 97
    Next
    Mod97 = m
End Function
%>