<%
class DatetimeType
    private m_Date
    private m_Datetime

    public function Constructor(p_Value)
        if not IsDate(p_Value) then exit function
        m_Datetime = CDate(p_Value) 'new dateime!
    end function

    public function IsIsoDate(p_Value)
        dim regex
        IsIsoDate = false
        if len(p_Value) > 9 then
            set regex = new RegExp
            regex.Pattern = "^\d{4}\-\d{2}\-\d{2}(T\d{2}:\d{2}:\d{2}(Z|\+\d{4}|\-\d{4})?)?$"
            if regex.Test(p_Value) then
                IsIsoDate = not IsEmpty(CIsoDate(p_Value))
            end if
            set regex = nothing
        end if
    end function

    public function CIsoDate(p_Value)
        CIsoDate = CDate(replace(Mid(p_Value, 1, 19) , "T", " "))
    end function

    public function Format(value, precision, default_value)
        if IsEmpty(precision) then precision = 0
        if IsDate(value) then
            m_Datetime = FormatDateTime(value, precision)
        else
            m_Datetime = default_value
        end if
    end function
    
    public function FormatChrome(p_Value)
        'mettre une cdate dans dateime et les format en sortie!
        DateInput = null
        if not IsDate(p_Value) then exit function
        m_Datetime = CDate(p_Value)
        DateInput = Year(p_Value) & "-" & FormatDigit(Month(p_Value), 2) & "-" & FormatDigit(Day(p_Value), 2)

    end function

    public function remainingdaysofmonth(p_date)
        dateend = dateadd("m", 1, p_date)
        remainingdaysofmonth = datediff("d", dateend, p_date)
    end function

    public function firstdayofmonth(p_date, p_next)
        datestart = dateadd("m", p_next, p_date)
        firstdayofmonth = dateadd("d", -day(datestart), datestart)
    end function

    public function getdaysbymonth(p_Month)
        datestart = dateserial(year(date), p_Month, 1)
        dateend = dateadd("m", 1, datestart)
        getdaysbymonth = datediff("d", datestart, dateend)
    end function

    public default function ToString(p_Pattern)
        set ToString = m_Datetime
    end function

end class
%>
