$PBExportHeader$w_search.srw
forward
global type w_search from window
end type
type st_3 from statictext within w_search
end type
type cb_print from commandbutton within w_search
end type
type st_tiptext from statictext within w_search
end type
type st_tiphead from statictext within w_search
end type
type em_limit from editmask within w_search
end type
type st_9 from statictext within w_search
end type
type sle_im from singlelineedit within w_search
end type
type st_8 from statictext within w_search
end type
type cbx_closed from checkbox within w_search
end type
type cbx_def from checkbox within w_search
end type
type st_7 from statictext within w_search
end type
type cb_search from commandbutton within w_search
end type
type cb_clear from commandbutton within w_search
end type
type cb_open from commandbutton within w_search
end type
type dw_result from datawindow within w_search
end type
type cbx_case from checkbox within w_search
end type
type sle_either from singlelineedit within w_search
end type
type sle_all from singlelineedit within w_search
end type
type sle_q from singlelineedit within w_search
end type
type cbx_foll from checkbox within w_search
end type
type cbx_opr from checkbox within w_search
end type
type cbx_insp from checkbox within w_search
end type
type st_5 from statictext within w_search
end type
type st_4 from statictext within w_search
end type
type st_2 from statictext within w_search
end type
type st_1 from statictext within w_search
end type
type gb_1 from groupbox within w_search
end type
type gb_2 from groupbox within w_search
end type
end forward

global type w_search from window
integer width = 3675
integer height = 2260
boolean titlebar = true
string title = "Search Inspections"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Bino.ico"
boolean center = true
st_3 st_3
cb_print cb_print
st_tiptext st_tiptext
st_tiphead st_tiphead
em_limit em_limit
st_9 st_9
sle_im sle_im
st_8 st_8
cbx_closed cbx_closed
cbx_def cbx_def
st_7 st_7
cb_search cb_search
cb_clear cb_clear
cb_open cb_open
dw_result dw_result
cbx_case cbx_case
sle_either sle_either
sle_all sle_all
sle_q sle_q
cbx_foll cbx_foll
cbx_opr cbx_opr
cbx_insp cbx_insp
st_5 st_5
st_4 st_4
st_2 st_2
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_search w_search

type variables
Integer ii_Limit, ii_All, ii_Either
String is_All[], is_Either[]
Boolean ibool_tipvis
end variables

forward prototypes
public function string wf_makeclause (string as_colname, boolean abool_case)
end prototypes

public function string wf_makeclause (string as_colname, boolean abool_case);String ls_Comp
Integer li_Count

If Not abool_case then   // If case insensitive
	as_colname = "Upper(" + as_colname + ")"
	For li_Count = 1 to ii_All
		is_All[li_count] = Upper(is_All[li_count])
	Next
	For li_Count = 1 to ii_Either
		is_Either[li_count] = Upper(is_Either[li_count])
	Next
End If

ls_Comp = "("      // Open bracket for 'All' words section

For li_Count = 1 to ii_All  //  Add the 'all' clauses
	ls_Comp += "(PatIndex('%" + is_All[li_Count] + "%', " + as_colname + ") > 0) and "
Next

If Len(ls_Comp) > 1 then // If 'all' clauses were added
	ls_Comp = left(ls_Comp, len(ls_comp) - 5) 	// Remove last 'and'
	ls_Comp += ")"    //  Close bracket for 'all' section
Else
	ls_Comp = ""   // If no 'all' clauses, then keep blank
End If

If ii_Either > 0 then  //  Check if any 'either' words
	If ls_Comp>"" then ls_Comp += " and (" else ls_comp = "("  //  Attach clause and open bracket
	For li_Count = 1 to ii_Either  //  Add all 'either' clauses
		ls_Comp += "(PatIndex('%" + is_Either[li_Count] + "%', " + as_colname + ") > 0) or "
	Next
	ls_Comp = left(ls_Comp, len(ls_comp) - 4) + ")"   // remove last 'or' and close bracket
End If

Return ls_Comp
end function

on w_search.create
this.st_3=create st_3
this.cb_print=create cb_print
this.st_tiptext=create st_tiptext
this.st_tiphead=create st_tiphead
this.em_limit=create em_limit
this.st_9=create st_9
this.sle_im=create sle_im
this.st_8=create st_8
this.cbx_closed=create cbx_closed
this.cbx_def=create cbx_def
this.st_7=create st_7
this.cb_search=create cb_search
this.cb_clear=create cb_clear
this.cb_open=create cb_open
this.dw_result=create dw_result
this.cbx_case=create cbx_case
this.sle_either=create sle_either
this.sle_all=create sle_all
this.sle_q=create sle_q
this.cbx_foll=create cbx_foll
this.cbx_opr=create cbx_opr
this.cbx_insp=create cbx_insp
this.st_5=create st_5
this.st_4=create st_4
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_3,&
this.cb_print,&
this.st_tiptext,&
this.st_tiphead,&
this.em_limit,&
this.st_9,&
this.sle_im,&
this.st_8,&
this.cbx_closed,&
this.cbx_def,&
this.st_7,&
this.cb_search,&
this.cb_clear,&
this.cb_open,&
this.dw_result,&
this.cbx_case,&
this.sle_either,&
this.sle_all,&
this.sle_q,&
this.cbx_foll,&
this.cbx_opr,&
this.cbx_insp,&
this.st_5,&
this.st_4,&
this.st_2,&
this.st_1,&
this.gb_1,&
this.gb_2}
end on

on w_search.destroy
destroy(this.st_3)
destroy(this.cb_print)
destroy(this.st_tiptext)
destroy(this.st_tiphead)
destroy(this.em_limit)
destroy(this.st_9)
destroy(this.sle_im)
destroy(this.st_8)
destroy(this.cbx_closed)
destroy(this.cbx_def)
destroy(this.st_7)
destroy(this.cb_search)
destroy(this.cb_clear)
destroy(this.cb_open)
destroy(this.dw_result)
destroy(this.cbx_case)
destroy(this.sle_either)
destroy(this.sle_all)
destroy(this.sle_q)
destroy(this.cbx_foll)
destroy(this.cbx_opr)
destroy(this.cbx_insp)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;
f_Write2Log("w_Search Open")

dw_result.SetTransObject(SQLCA)

end event

event mousemove;
If ibool_tipvis then 
	st_Tiphead.Visible = False
	st_Tiptext.Visible = False
	ibool_tipvis = False
End If
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 3100)
end event

event close;
f_Write2Log("w_Search Close")
end event

type st_3 from statictext within w_search
integer x = 3401
integer y = 512
integer width = 128
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Obs"
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_search
integer x = 713
integer y = 2032
integer width = 658
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print Search Results"
end type

event clicked;
f_Write2Log("w_Search > cb_Print")

dw_result.Print(True, True)
end event

type st_tiptext from statictext within w_search
boolean visible = false
integer x = 55
integer y = 704
integer width = 1115
integer height = 256
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388736
long backcolor = 15793151
string text = "none"
boolean focusrectangle = false
end type

type st_tiphead from statictext within w_search
boolean visible = false
integer x = 18
integer y = 624
integer width = 1189
integer height = 352
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388736
long backcolor = 15793151
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type em_limit from editmask within w_search
integer x = 3163
integer y = 496
integer width = 219
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "50"
borderstyle borderstyle = stylelowered!
string mask = "##0"
boolean spin = true
double increment = 1
string minmax = "10~~100"
end type

event modified;
If Integer(This.Text) > 100 then This.Text = "100"
If Integer(This.Text) < 10 then This.Text = "10"
end event

type st_9 from statictext within w_search
integer x = 3163
integer y = 432
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Result Limit:"
boolean focusrectangle = false
end type

type sle_im from singlelineedit within w_search
event ue_keydown pbm_keydown
event ue_mousemove pbm_mousemove
integer x = 731
integer y = 208
integer width = 494
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If key = KeyEnter! then cb_Search.event clicked( )
end event

event ue_mousemove;
If not ibool_tipvis then
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
	st_Tiphead.Text = "Inspection Model"
	st_TipText.Text = "Enter the first few characters of the Inspection Model name. All inspection models beginning with the specified characters will be retrieved. E.g. Entering SIRE will retrieve all SIRE inspections."	
End If
end event

event getfocus;
st_Tiphead.Text = "Inspection Model"
st_TipText.Text = "Enter the first few characters of the Inspection Model name. All inspection models beginning with the specified characters will be retrieved. E.g. Entering SIRE will retrieve all SIRE inspections."

If not ibool_tipvis then
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
End If
end event

type st_8 from statictext within w_search
integer x = 73
integer y = 224
integer width = 475
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Model:"
boolean focusrectangle = false
end type

type cbx_closed from checkbox within w_search
integer x = 3163
integer y = 336
integer width = 421
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Closed Only"
end type

type cbx_def from checkbox within w_search
integer x = 3163
integer y = 256
integer width = 421
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valid Obs Only"
end type

type st_7 from statictext within w_search
integer x = 3090
integer y = 96
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Options"
boolean focusrectangle = false
end type

type cb_search from commandbutton within w_search
integer x = 1280
integer y = 656
integer width = 1097
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Start Search"
end type

event clicked;Integer li_Found, li_Count, li_Num[], li_Index
String ls_Where, ls_Clause, ls_Temp
Boolean lbool_CaseSens

This.Enabled = False
cb_Search.Text = "Searching..."

// Trim all text
sle_q.Text = Trim(sle_q.Text)
sle_im.Text = Trim(sle_im.Text)
sle_all.Text = Trim(sle_all.Text)
sle_either.Text = Trim(sle_either.Text)

If sle_q.Text > "" then    // If searching by Question number
	ls_Clause = sle_q.Text
	
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
	ls_Where = "((Str(CHAPNUM,4) + IsNull(Str(SECTNUM,4), '') + IsNull(Str(QPARNUM1,4),'') + IsNull(Str(QPARNUM2,4), '') + IsNull(Str(QPARNUM3,4),'') + Str(QNUM,4)) like '" + ls_Clause + "%')"	
End If

// Check for Inspection Model
If sle_im.Text > "" then
	ls_Clause = "(Upper(IMNAME) like '" + Upper(sle_im.Text) + "%')"
	If ls_Where > "" then ls_Where += " and " + ls_Clause else ls_Where = ls_Clause
End If

//  Parse 'All' words
If sle_all.Text > "" then
	ls_Clause = sle_All.Text
	ls_Temp = ""
	ii_All = 0
	For li_Count = 1 to Len(ls_Clause)
		If Mid(ls_Clause, li_Count, 1) > " " then
			ls_Temp += Mid(ls_Clause, li_Count, 1)
		Else
			If ls_Temp>"" then
				ii_All++
				is_All[ii_All] = ls_Temp
				ls_Temp = ""
			End If
		End If
	Next
	If ls_Temp>"" then
		ii_All++
		is_All[ii_All] = ls_Temp
	End If
Else
	ii_all = 0
End If

//  Parse 'Either' words
If sle_Either.Text > "" then
	ls_Clause = sle_Either.Text
	ls_Temp = ""
	ii_Either = 0
	For li_Count = 1 to Len(ls_Clause)
		If Mid(ls_Clause, li_Count, 1) > " " then
			ls_Temp += Mid(ls_Clause, li_Count, 1)
		Else
			If ls_Temp>"" then
				ii_Either++
				is_Either[ii_Either] = ls_Temp
				ls_Temp = ""
			End If
		End If
	Next
	If ls_Temp>"" then
		ii_Either++
		is_Either[ii_Either] = ls_Temp
	End If
Else
	ii_Either = 0
End If

lbool_CaseSens = (cbx_case.Checked)

ls_Clause = ""
ls_Temp = ""

If cbx_Def.Checked then
	ls_clause = "(DEF = 1)"
	If ls_Where > "" then ls_Where += " and " + ls_Clause else ls_Where = ls_Clause
End If

If cbx_Closed.Checked then
	ls_clause = "(CLOSED = 1)"
	If ls_Where > "" then ls_Where += " and " + ls_Clause else ls_Where = ls_Clause
End If

// Create text SQL string
If cbx_insp.Checked then ls_Temp += "Cast(IsNull(INSPCOMM,'') as VarChar(8000))+"
If cbx_opr.Checked then ls_Temp += "Cast(IsNull(OWNCOMM,'') as VarChar(8000))+"
If cbx_foll.Checked then ls_Temp += "Cast(IsNull(FOLLOWUP,'') as VarChar(8000))+"

If ls_Temp > "" then 
	ls_Temp = Left(ls_Temp, Len(ls_Temp)-1)   // Remove last +
	ls_Clause = wf_Makeclause(ls_Temp, lbool_CaseSens)
End If

If ls_Clause > "" then 
	ls_Clause = "(" + ls_Clause + ")"
	If ls_Where > "" then ls_Where += " and " + ls_Clause else ls_Where = ls_Clause
End If

If ls_Where > "" then ls_Where = " and " + ls_Where

// Set Retrieve limit
ii_Limit = Integer(em_limit.Text)

SetPointer(HourGlass!)

dw_result.SetRedraw(False)

clipboard(ls_Where)

dw_result.SetSQLSelect("SELECT VETT_MASTER.CHAPNUM, VETT_MASTER.SECTNUM,"&
  + "VETT_MASTER.QPARNUM1, VETT_MASTER.QPARNUM2, VETT_MASTER.QNAME,"&
  + "VETT_MASTER.QNUM, VETT_MASTER.ANS, VETT_MASTER.INSPCOMM, "&
  + "VETT_MASTER.OWNCOMM, VETT_MASTER.FOLLOWUP, VETT_MASTER.DEF, VETT_MASTER.CAUSETEXT, VETT_MASTER.RESPTEXT,"&
  + "VETT_MASTER.RISK, VETT_MASTER.CLOSED, VETT_MASTER.CLOSEDATE, VETT_MASTER.REQTYPE,"&
  + "VETT_MASTER.QPARNUM3, VETT_MASTER.INSP_ID, VETT_MASTER.INSPDATE, VETT_MASTER.IMNAME, VETT_MASTER.EDITION,"&
  + "VETT_COMP.NAME, VETT_MASTER.RATING "&
  + "FROM VETT_MASTER INNER JOIN VETT_COMP ON (VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID)"&
  + "WHERE (VETT_MASTER.QNUM is not Null) and (VETT_MASTER.VESSEL_ACTIVE = 1)" + ls_Where + " ORDER BY VETT_MASTER.INSPDATE DESC")

li_Found = dw_result.Retrieve( )
If li_Found < 0 then li_Found = 0

f_Write2Log("w_Search > cb_Search; ls_Where: " + ls_Where)

dw_result.SetRedraw(True)


end event

type cb_clear from commandbutton within w_search
integer x = 2944
integer y = 2032
integer width = 658
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Clear Search Results"
end type

event clicked;
f_Write2Log("w_Search > cb_Clear")

dw_result.Reset( )
end event

type cb_open from commandbutton within w_search
integer x = 55
integer y = 2032
integer width = 658
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Open Inspection Report"
end type

event clicked;Long ll_InspID

SetPointer(HourGlass!)

ll_InspID = dw_result.GetItemNumber( dw_result.GetRow(), "insp_id")

f_Write2Log("w_Search > cb_Open")

OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.DataObject = "d_rep_insprep"

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve(ll_InspID)

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer   //  Set the report footer

w_preview.wf_ShowReport()


end event

type dw_result from datawindow within w_search
integer x = 55
integer y = 864
integer width = 3547
integer height = 1152
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_search"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieverow;
If row = ii_Limit then Return 1
end event

event retrieveend;
If rowcount = 0 then 
	cb_open.Enabled = False 
	cb_Print.Enabled = False
else 
	cb_open.Enabled = True
	cb_Print.Enabled = True
End If

cb_Search.Enabled = True
cb_Search.Text = "Start Search"
end event

event doubleclicked;

If (row > 0) and cb_open.Enabled then cb_open.event clicked( )
end event

event scrollvertical;
This.SetRow(Integer(This.Object.Datawindow.FirstRowOnPage))
end event

type cbx_case from checkbox within w_search
integer x = 3163
integer y = 176
integer width = 421
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Sensitive"
end type

type sle_either from singlelineedit within w_search
event ue_keydown pbm_keydown
event ue_mousemove pbm_mousemove
integer x = 731
integer y = 400
integer width = 1317
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;If key = KeyEnter! then cb_Search.event clicked( )
end event

event ue_mousemove;

If not ibool_tipvis then
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
	st_Tiphead.Text = "Either of these words"
	st_TipText.Text = "Enter words or partial words separated by spaces. Any of the words given may be present for a match to occur."
End If
end event

event getfocus;
st_Tiphead.Text = "Either of these words"
st_TipText.Text = "Enter words or partial words separated by spaces. Any of the words given may be present for a match to occur."

If not ibool_tipvis then
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
End If
end event

type sle_all from singlelineedit within w_search
event ue_keydown pbm_keydown
event ue_mousemove pbm_mousemove
integer x = 731
integer y = 304
integer width = 1317
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;If key = KeyEnter! then cb_Search.event clicked( )
end event

event ue_mousemove;

If not ibool_tipvis then
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
	st_Tiphead.Text = "All these words"
	st_TipText.Text = "Enter words or partial words separated by spaces. All the words given must be present for a match to occur."	
End If
end event

event getfocus;
st_Tiphead.Text = "All these words"
st_TipText.Text = "Enter words or partial words separated by spaces. All the words given must be present for a match to occur."

If not ibool_tipvis then
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
End If
end event

type sle_q from singlelineedit within w_search
event ue_keydown pbm_keydown
event ue_mousemove pbm_mousemove
integer x = 731
integer y = 112
integer width = 494
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If key = KeyEnter! then cb_Search.event clicked( )
end event

event ue_mousemove;
If not ibool_tipvis then
	st_Tiphead.Text = "Question Number"
	st_TipText.Text = "Enter the partial or full question number. All question numbers beginning with the number will be retrieved."
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
End If
end event

event getfocus;st_Tiphead.Text = "Question Number"
st_TipText.Text = "Enter the partial or full question number. All question numbers beginning with the number will be retrieved."

If not ibool_tipvis then
	st_TipHead.Visible = True
	st_TipText.Visible = True
	ibool_tipvis = True
End If
end event

type cbx_foll from checkbox within w_search
integer x = 2322
integer y = 336
integer width = 622
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Follow-up Comments"
boolean checked = true
end type

type cbx_opr from checkbox within w_search
integer x = 2322
integer y = 256
integer width = 622
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Operator~'s Comments"
boolean checked = true
end type

type cbx_insp from checkbox within w_search
integer x = 2322
integer y = 176
integer width = 622
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspector~'s Comments"
boolean checked = true
end type

type st_5 from statictext within w_search
integer x = 2267
integer y = 96
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Search in"
boolean focusrectangle = false
end type

type st_4 from statictext within w_search
integer x = 73
integer y = 128
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Question Number:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_search
integer x = 73
integer y = 416
integer width = 539
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Either of these words:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_search
integer x = 73
integer y = 320
integer width = 407
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "All these words:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_search
event ue_mousemove pbm_mousemove
integer x = 18
integer y = 16
integer width = 3621
integer height = 592
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Criteria"
end type

event ue_mousemove;
If ibool_tipvis then 
	st_Tiphead.Visible = False
	st_Tiptext.Visible = False
	ibool_tipvis = False
End If
end event

type gb_2 from groupbox within w_search
event ue_mousemove pbm_mousemove
integer x = 18
integer y = 784
integer width = 3621
integer height = 1360
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Results"
end type

event ue_mousemove;If ibool_tipvis then 
	st_Tiphead.Visible = False
	st_Tiptext.Visible = False
	ibool_tipvis = False
End If
end event

