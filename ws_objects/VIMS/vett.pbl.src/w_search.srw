$PBExportHeader$w_search.srw
forward
global type w_search from window
end type
type cbx_3p from checkbox within w_search
end type
type st_6 from statictext within w_search
end type
type cbx_tc from checkbox within w_search
end type
type st_found from statictext within w_search
end type
type cb_menu from commandbutton within w_search
end type
type dw_im from datawindow within w_search
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
type cb_close from commandbutton within w_search
end type
type gb_1 from groupbox within w_search
end type
type gb_2 from groupbox within w_search
end type
end forward

global type w_search from window
integer width = 3675
integer height = 2624
boolean titlebar = true
string title = "Search Inspections"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Bino.ico"
boolean center = true
event ue_contextmenuclick ( integer ai_menu )
cbx_3p cbx_3p
st_6 st_6
cbx_tc cbx_tc
st_found st_found
cb_menu cb_menu
dw_im dw_im
st_3 st_3
cb_print cb_print
st_tiptext st_tiptext
st_tiphead st_tiphead
em_limit em_limit
st_9 st_9
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
cb_close cb_close
gb_1 gb_1
gb_2 gb_2
end type
global w_search w_search

type variables
Integer ii_Limit, ii_All, ii_Either
String is_All[], is_Either[]
Boolean ibool_tipvis, ibool_Cancel

m_selection_im im_Select
end variables

forward prototypes
public function string wf_makeclause (string as_colname, boolean abool_case)
end prototypes

event ue_contextmenuclick(integer ai_menu);
Integer li_Count

dw_im.SetRedraw(False)

Choose Case ai_Menu
	Case 10
		For li_Count = 1 to dw_im.RowCount()
			dw_im.SetItem(li_Count, "Sel", 1)
		Next
	Case 20
		For li_Count = 1 to dw_im.RowCount()
			dw_im.SetItem(li_Count, "Sel", 0)
		Next
	Case 30
		For li_Count = 1 to dw_im.RowCount()
			dw_im.SetItem(li_Count, "Sel", 1 - dw_im.GetItemNumber(li_Count, "Sel"))
		Next
	Case 100
		For li_Count = 1 to dw_im.RowCount()
			If Left(dw_im.GetItemString(li_Count, "imname"), 4) = "SIRE" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
		Next
	Case 110
		For li_Count = 1 to dw_im.RowCount()
			If Left(dw_im.GetItemString(li_Count, "imname"), 3) = "CDI" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
		Next				
	Case 120
		For li_Count = 1 to dw_im.RowCount()
			If Left(dw_im.GetItemString(li_Count, "imname"), 4) = "MIRE" then dw_im.SetItem(li_Count, "Sel", 1) Else dw_im.SetItem(li_Count, "Sel", 0)
		Next		
End Choose

dw_im.SetRedraw(True)
end event

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

If Len(ls_Comp) > 1 then // If 'all' clauses were added above
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
this.cbx_3p=create cbx_3p
this.st_6=create st_6
this.cbx_tc=create cbx_tc
this.st_found=create st_found
this.cb_menu=create cb_menu
this.dw_im=create dw_im
this.st_3=create st_3
this.cb_print=create cb_print
this.st_tiptext=create st_tiptext
this.st_tiphead=create st_tiphead
this.em_limit=create em_limit
this.st_9=create st_9
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
this.cb_close=create cb_close
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cbx_3p,&
this.st_6,&
this.cbx_tc,&
this.st_found,&
this.cb_menu,&
this.dw_im,&
this.st_3,&
this.cb_print,&
this.st_tiptext,&
this.st_tiphead,&
this.em_limit,&
this.st_9,&
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
this.cb_close,&
this.gb_1,&
this.gb_2}
end on

on w_search.destroy
destroy(this.cbx_3p)
destroy(this.st_6)
destroy(this.cbx_tc)
destroy(this.st_found)
destroy(this.cb_menu)
destroy(this.dw_im)
destroy(this.st_3)
destroy(this.cb_print)
destroy(this.st_tiptext)
destroy(this.st_tiphead)
destroy(this.em_limit)
destroy(this.st_9)
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
destroy(this.cb_close)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;Integer li_Count

dw_im.SetTransObject(SQLCA)
dw_result.SetTransObject(SQLCA)

dw_im.Retrieve( )
For li_Count = 1 to dw_im.RowCount()
	dw_im.SetItem(li_Count, "Sel", 1)
Next

im_Select = Create m_selection_im
end event

event mousemove;
If ibool_tipvis then 
	st_Tiphead.Visible = False
	st_Tiptext.Visible = False
	ibool_tipvis = False
End If
end event

event close;
Destroy im_Select
ibool_Cancel = True
end event

event closequery;
If st_found.Visible then 
	ibool_Cancel = True
	Return 1
End If
end event

event key;
//If Key = KeyF1! then guo_Global.of_LaunchWiki("Search%20Inspection.aspx")
end event

type cbx_3p from checkbox within w_search
integer x = 2706
integer y = 448
integer width = 329
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include 3P"
end type

type st_6 from statictext within w_search
integer x = 2267
integer y = 384
integer width = 603
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Other Vessel Inspections:"
boolean focusrectangle = false
end type

type cbx_tc from checkbox within w_search
integer x = 2322
integer y = 448
integer width = 366
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include T/C"
end type

type st_found from statictext within w_search
boolean visible = false
integer x = 1298
integer y = 752
integer width = 1061
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "Searching..."
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_menu from commandbutton within w_search
integer x = 1993
integer y = 160
integer width = 73
integer height = 64
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;
im_Select.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())
end event

type dw_im from datawindow within w_search
integer x = 1170
integer y = 160
integer width = 823
integer height = 400
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_rep_im"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If Row > 0 then This.SetItem(Row, "Sel", 1 - This.GetItemNumber(Row, "Sel"))
end event

type st_3 from statictext within w_search
integer x = 3401
integer y = 464
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
integer y = 2272
integer width = 658
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Print Search Results"
end type

event clicked;
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
integer y = 448
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
string minmax = "10~~999"
end type

event modified;
If Integer(This.Text) > 999 then This.Text = "999"
If Integer(This.Text) < 10 then This.Text = "10"
end event

type st_9 from statictext within w_search
integer x = 3163
integer y = 384
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

type st_8 from statictext within w_search
integer x = 1170
integer y = 96
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
string text = "Inspection Models:"
boolean focusrectangle = false
end type

type cbx_closed from checkbox within w_search
integer x = 3163
integer y = 288
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
integer y = 224
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
string text = "Start Search"
end type

event clicked;Integer li_Found, li_Count, li_Num[], li_Index
String ls_SQL, ls_Clause, ls_Temp
Boolean lbool_CaseSens

If st_Found.Visible then
	ibool_Cancel = True
	Return
End If

ibool_Cancel = False

// Check for Inspection Model
li_Found = 0
For li_Count = 1 to dw_im.RowCount( )
	If dw_im.GetItemNumber(li_Count, "Sel")>0 then
		ls_Clause += String(dw_im.GetItemNumber(li_Count, "Im_ID")) + ","
		li_Found ++
	End If
Next
If ls_Clause > "" then
	ls_Clause = Left(ls_Clause, Len(ls_Clause)-1)
	ls_Clause = "(IM_ID in (" + ls_Clause + "))"
Else
	MessageBox("Inspection Models", "At least one Inspection Model must be selected.", Exclamation!)
	Return
End If
If li_Found = dw_im.RowCount( ) then ls_Clause = ""

cb_Search.Text = "Cancel Search"
st_Found.Visible = True
cb_Close.Enabled = False
cb_Clear.Enabled = False

ls_SQL = ls_Clause

// Trim all text
sle_q.Text = Trim(sle_q.Text)
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
	ls_Clause = "((Str(CHAPNUM,4) + Str(SECTNUM,4) + Str(QPARNUM1,4) + Str(QPARNUM2,4) + Str(QPARNUM3,4) + Str(QNUM,4)) like '" + ls_Clause + "%')"	
	If ls_SQL > "" then ls_SQL += " and " + ls_Clause else ls_SQL = ls_Clause
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
	If ls_SQL > "" then ls_SQL += " and " + ls_Clause else ls_SQL = ls_Clause
End If

If cbx_Closed.Checked then
	ls_clause = "(CLOSED = 1)"
	If ls_SQL > "" then ls_SQL += " and " + ls_Clause else ls_SQL = ls_Clause
End If

// If excluding 3P vessels
If Not cbx_3P.Checked then
	ls_Clause = "(TYPE_NAME not like '%3P%')"
	If ls_SQL > "" then ls_SQL += " and " + ls_Clause else ls_SQL = ls_Clause
End If

// If excluding T/C vessels
If Not cbx_TC.Checked then
	ls_Clause = "(TYPE_NAME not like '%T/C%')"
	If ls_SQL > "" then ls_SQL += " and " + ls_Clause else ls_SQL = ls_Clause
End If

// Create text SQL string
If cbx_insp.Checked then ls_Temp += "IsNull(Cast(INSPCOMM as VarChar(10000)),'')+"
If cbx_opr.Checked then ls_Temp += "IsNull(Cast(OWNCOMM as VarChar(10000)),'')+"
If cbx_foll.Checked then ls_Temp += "IsNull(Cast(FOLLOWUP as VarChar(10000)),'')+"

If ls_Temp > "" then 
	ls_Temp = Left(ls_Temp, Len(ls_Temp)-1)   // Remove last +
	ls_Clause = wf_Makeclause(ls_Temp, lbool_CaseSens)
End If

If ls_Clause > "" then 
	ls_Clause = "(" + ls_Clause + ")"
	If ls_SQL > "" then ls_SQL += " and " + ls_Clause else ls_SQL = ls_Clause
End If

If g_Obj.DeptID > 1 then // If not vetting dept, restrict results to reviewed inspections
	If ls_SQL > "" then ls_SQL += " and "
	ls_SQL += "(VETT_MASTER.COMPLETED = 1)"
End If

If ls_SQL > "" then ls_SQL = " and " + ls_SQL

// Set Retrieve limit
ii_Limit = Integer(em_limit.Text)

dw_result.SetRedraw(False)

ls_SQL = "SELECT VETT_MASTER.CHAPNUM, VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1, VETT_MASTER.QPARNUM2, VETT_MASTER.QNAME,"&
  + "VETT_MASTER.QNUM, VETT_MASTER.ANS, VETT_MASTER.INSPCOMM,VETT_MASTER.OWNCOMM, VETT_MASTER.FOLLOWUP, VETT_MASTER.DEF, VETT_MASTER.CAUSETEXT, VETT_MASTER.RESPTEXT,"&
  + "VETT_MASTER.RISK, VETT_MASTER.CLOSED, VETT_MASTER.CLOSEDATE, VETT_MASTER.REQTYPE,"&
  + "VETT_MASTER.QPARNUM3, VETT_MASTER.INSP_ID, VETT_MASTER.INSPDATE, VETT_MASTER.IMNAME, VETT_MASTER.EDITION,"&
  + "VESSELS.VESSEL_NAME, VETT_COMP.NAME, VETT_MASTER.RATING, VETT_MASTER.IM_ID FROM VETT_MASTER, VESSELS, VETT_COMP, VETT_VSLTYPE "&
  + "WHERE (VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID) and (VETT_MASTER.VETT_TYPE = VETT_VSLTYPE.TYPE_ID) and (VETT_MASTER.ANS = 1) and (VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID) and "&
  + "(VETT_MASTER.QNUM is not Null) and (VETT_MASTER.VESSEL_ACTIVE = 1)" + ls_SQL + " ORDER BY VETT_MASTER.INSPDATE DESC"
 

//Clipboard(ls_SQL)  // For debug purposes

dw_result.SetSQLSelect(ls_SQL)

li_Found = dw_result.Retrieve( )
If li_Found < 0 then li_Found = 0

dw_result.SetRedraw(True)


end event

type cb_clear from commandbutton within w_search
integer x = 2944
integer y = 2272
integer width = 658
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear Search Results"
end type

event clicked;
dw_result.Reset( )
end event

type cb_open from commandbutton within w_search
integer x = 55
integer y = 2272
integer width = 658
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Open Inspection Report"
end type

event clicked;Long ll_InspID

SetPointer(HourGlass!)

ll_InspID = dw_result.GetItemNumber( dw_result.GetRow(), "insp_id")

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
integer height = 1408
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_search"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount = 0 then 
	cb_open.Enabled = False 
	cb_Print.Enabled = False
else 
	cb_open.Enabled = True
	cb_Print.Enabled = True
End If

cb_Search.Text = "Start Search"
st_Found.Visible = False
st_Found.Text = "Searching..."
ibool_Cancel = False
cb_Clear.Enabled = True
cb_Close.Enabled = True
end event

event doubleclicked;

If (row > 0) and cb_open.Enabled then cb_open.event clicked( )
end event

event scrollvertical;
This.SetRow(Integer(This.Object.Datawindow.FirstRowOnPage))
end event

event retrieverow;
If (row = ii_Limit) or (ibool_Cancel) then Return 1
st_Found.Text = "Searching...  (" + string(row) + " found)"


end event

type cbx_case from checkbox within w_search
integer x = 3163
integer y = 160
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
integer x = 73
integer y = 480
integer width = 951
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
integer x = 73
integer y = 320
integer width = 951
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
integer x = 73
integer y = 160
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
integer y = 288
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
integer y = 224
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
integer y = 160
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
long textcolor = 33554432
long backcolor = 67108864
string text = "Search In:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_search
integer x = 73
integer y = 96
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
integer y = 256
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

type cb_close from commandbutton within w_search
integer x = 1536
integer y = 2416
integer width = 576
integer height = 104
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type gb_1 from groupbox within w_search
event ue_mousemove pbm_mousemove
integer x = 18
integer y = 16
integer width = 3621
integer height = 592
integer taborder = 40
integer textsize = -10
integer weight = 700
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
integer height = 1600
integer taborder = 80
integer textsize = -10
integer weight = 700
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

