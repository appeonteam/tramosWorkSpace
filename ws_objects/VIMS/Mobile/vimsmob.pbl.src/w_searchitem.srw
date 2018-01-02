$PBExportHeader$w_searchitem.srw
forward
global type w_searchitem from window
end type
type st_1 from statictext within w_searchitem
end type
type dw_result from datawindow within w_searchitem
end type
end forward

global type w_searchitem from window
integer width = 3488
integer height = 2460
boolean titlebar = true
string title = "Search Result"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Bino.ico"
boolean center = true
st_1 st_1
dw_result dw_result
end type
global w_searchitem w_searchitem

forward prototypes
public subroutine wf_search (string as_qnum)
end prototypes

public subroutine wf_search (string as_qnum);Integer li_Count, li_Num[], li_Index
String ls_Where, ls_Clause, ls_Temp, ls_SQL

SetPointer(HourGlass!)

ls_Clause = as_QNum

// Set all to 0
For li_Count = 1 to 6
	li_Num[li_Count] = 0
Next

li_Index = 0

//Parse string
For li_Count = 1 to Len(ls_Clause)
	If Pos("0123456789", Mid(ls_Clause, li_Count, 1)) > 0 then
		ls_Temp += Mid(ls_Clause, li_Count, 1)
	Else
		If ls_Temp>"" then
			li_Index++
			li_Num[li_Index] = Integer(ls_Temp)
			ls_Temp = ""
		End If
	End If
Next
If ls_Temp>"" then
	li_Index++
	li_Num[li_Index] = Integer(ls_Temp)
End If

ls_Temp = ""
ls_Clause = ""
//Recreate number
For li_Count = 1 to 6
	If li_Num[li_Count] > 0 then 
		If li_Num[li_Count] > 9999 then
			MessageBox("Search Error", "Invalid question number specfied.",Exclamation!)
			Return
		End If
		ls_Temp = String(li_Num[li_Count])
		ls_Temp = Space(4 - Len(ls_Temp)) + ls_Temp
		ls_Clause += ls_Temp
	End If
Next
// Create SQL string
ls_Where = " and ((Str(CHAPNUM,4) + Str(SECTNUM,4) + Str(QPARNUM1,4) + Str(QPARNUM2,4) + Str(QPARNUM3,4) + Str(QNUM,4)) like '" + ls_Clause + "%')"	

ls_SQL += "SELECT VETT_MASTER.CHAPNUM, VETT_MASTER.SECTNUM,"&
  + "VETT_MASTER.QPARNUM1, VETT_MASTER.QPARNUM2, VETT_MASTER.QNAME,"&
  + "VETT_MASTER.QNUM, VETT_MASTER.ANS, VETT_MASTER.INSPCOMM, "&
  + "VETT_MASTER.OWNCOMM, VETT_MASTER.FOLLOWUP, VETT_MASTER.DEF, VETT_MASTER.CAUSETEXT, VETT_MASTER.RESPTEXT,"&
  + "VETT_MASTER.RISK, VETT_MASTER.CLOSED, VETT_MASTER.CLOSEDATE, VETT_MASTER.REQTYPE,"&
  + "VETT_MASTER.QPARNUM3, VETT_MASTER.INSP_ID, VETT_MASTER.INSPDATE, VETT_MASTER.IMNAME, VETT_MASTER.EDITION,"&
  + "VETT_COMP.NAME, VETT_MASTER.RATING "&
  + "FROM VETT_MASTER INNER JOIN VETT_COMP ON (VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID) "&
  + "WHERE (VETT_MASTER.QNUM is not Null) and (VETT_MASTER.VESSEL_ACTIVE = 1)" + ls_Where + " ORDER BY VETT_MASTER.INSPDATE DESC"
  
dw_result.SetSQLSelect(ls_SQL)
f_Write2Log("w_SearchItem > wf_Search: ls_SQL = " + ls_SQL)

dw_result.Retrieve()

end subroutine

on w_searchitem.create
this.st_1=create st_1
this.dw_result=create dw_result
this.Control[]={this.st_1,&
this.dw_result}
end on

on w_searchitem.destroy
destroy(this.st_1)
destroy(this.dw_result)
end on

event open;
f_Write2Log("w_SearchItem Open")

dw_result.SetTransObject(SQLCA)

Post wf_Search(g_Obj.ParamString)
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 3100)
end event

event close;
f_Write2Log("w_SearchItem Close")
end event

type st_1 from statictext within w_searchitem
integer x = 18
integer y = 32
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Results:"
boolean focusrectangle = false
end type

type dw_result from datawindow within w_searchitem
integer x = 18
integer y = 96
integer width = 3438
integer height = 2256
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_search"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

