$PBExportHeader$w_rep.srw
forward
global type w_rep from window
end type
type sle_desc from singlelineedit within w_rep
end type
type st_1 from statictext within w_rep
end type
type cbx_na from checkbox within w_rep
end type
type cbx_ns from checkbox within w_rep
end type
type cbx_no from checkbox within w_rep
end type
type cbx_yes from checkbox within w_rep
end type
type st_11 from statictext within w_rep
end type
type cbx_sql from checkbox within w_rep
end type
type ole_rmc from olecustomcontrol within w_rep
end type
type st_imtip from statictext within w_rep
end type
type cb_reset from commandbutton within w_rep
end type
type em_sub from editmask within w_rep
end type
type st_10 from statictext within w_rep
end type
type st_tip from statictext within w_rep
end type
type st_tiphead from statictext within w_rep
end type
type sle_title from singlelineedit within w_rep
end type
type st_8 from statictext within w_rep
end type
type cbx_hidefilter from checkbox within w_rep
end type
type dw_insp from datawindow within w_rep
end type
type cbx_insp from checkbox within w_rep
end type
type cbx_rep from checkbox within w_rep
end type
type ddlb_def from dropdownlistbox within w_rep
end type
type st_7 from statictext within w_rep
end type
type ddlb_close from dropdownlistbox within w_rep
end type
type st_6 from statictext within w_rep
end type
type dw_risk from datawindow within w_rep
end type
type dw_cause from datawindow within w_rep
end type
type dw_resp from datawindow within w_rep
end type
type dw_port from datawindow within w_rep
end type
type cbx_port from checkbox within w_rep
end type
type dw_comp from datawindow within w_rep
end type
type dw_im from datawindow within w_rep
end type
type st_5 from statictext within w_rep
end type
type rb_bet from radiobutton within w_rep
end type
type dp_2 from datepicker within w_rep
end type
type sle_insptype from singlelineedit within w_rep
end type
type st_4 from statictext within w_rep
end type
type cbx_cause from checkbox within w_rep
end type
type cbx_resp from checkbox within w_rep
end type
type cbx_risk from checkbox within w_rep
end type
type st_3 from statictext within w_rep
end type
type cbx_comp from checkbox within w_rep
end type
type dp_1 from datepicker within w_rep
end type
type rb_bef from radiobutton within w_rep
end type
type rb_aft from radiobutton within w_rep
end type
type cbx_date from checkbox within w_rep
end type
type cbx_im from checkbox within w_rep
end type
type st_2 from statictext within w_rep
end type
type cb_close from commandbutton within w_rep
end type
type cb_gen from commandbutton within w_rep
end type
type gb_1 from groupbox within w_rep
end type
type gb_2 from groupbox within w_rep
end type
type lb_rep from listbox within w_rep
end type
end forward

global type w_rep from window
integer width = 3858
integer height = 1700
boolean titlebar = true
string title = "Report Generator"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Rep.ico"
boolean center = true
event ue_retrieve ( )
sle_desc sle_desc
st_1 st_1
cbx_na cbx_na
cbx_ns cbx_ns
cbx_no cbx_no
cbx_yes cbx_yes
st_11 st_11
cbx_sql cbx_sql
ole_rmc ole_rmc
st_imtip st_imtip
cb_reset cb_reset
em_sub em_sub
st_10 st_10
st_tip st_tip
st_tiphead st_tiphead
sle_title sle_title
st_8 st_8
cbx_hidefilter cbx_hidefilter
dw_insp dw_insp
cbx_insp cbx_insp
cbx_rep cbx_rep
ddlb_def ddlb_def
st_7 st_7
ddlb_close ddlb_close
st_6 st_6
dw_risk dw_risk
dw_cause dw_cause
dw_resp dw_resp
dw_port dw_port
cbx_port cbx_port
dw_comp dw_comp
dw_im dw_im
st_5 st_5
rb_bet rb_bet
dp_2 dp_2
sle_insptype sle_insptype
st_4 st_4
cbx_cause cbx_cause
cbx_resp cbx_resp
cbx_risk cbx_risk
st_3 st_3
cbx_comp cbx_comp
dp_1 dp_1
rb_bef rb_bef
rb_aft rb_aft
cbx_date cbx_date
cbx_im cbx_im
st_2 st_2
cb_close cb_close
cb_gen cb_gen
gb_1 gb_1
gb_2 gb_2
lb_rep lb_rep
end type
global w_rep w_rep

type prototypes
Private Function Long RMC_CreateChart(Long nParentHndl, Long nCtrlId, Long nX, Long nY, Long nWidth, Long nHeight, Long nBackColor, Long nCtrlStyle, Long nExportOnly, Ref String sBgImage, Ref String sFontName, Long nToolTipWidth, Long nBitmapBKColor) Library "RMChart.dll"


end prototypes

type variables

Long il_White, il_Gray
String is_Where

Integer ii_Def, ii_Close, ii_RepNum

Boolean ibool_TipVisible
end variables

forward prototypes
public subroutine wf_processdw (ref checkbox acbx_box, ref datawindow adw_arg, string as_id, string as_dbid, integer ai_idtype)
public subroutine wf_populatefilter (ref datawindowchild adwc_filter)
public subroutine wf_setsubtype (integer ai_max)
end prototypes

event ue_retrieve();
dw_IM.SetTransObject(SQLCA)
dw_comp.SetTransObject(SQLCA)
dw_port.SetTransObject(SQLCA)
dw_insp.SetTransObject(SQLCA)
dw_resp.SetTransObject(SQLCA)
dw_Cause.SetTransObject(SQLCA)

dw_IM.Retrieve( )
dw_Comp.Retrieve( )
dw_Port.Retrieve( )
dw_Insp.Retrieve( )
dw_Resp.Retrieve( )
dw_Cause.Retrieve( )

il_gray = 15790320
il_White = 16777215

ddlb_close.Selectitem(1)
ddlb_def.SelectItem(1)

dp_1.Value = DateTime(Today())
dp_2.Value = DateTime(Today())

ii_Repnum = 0
ii_Def = 1

end event

public subroutine wf_processdw (ref checkbox acbx_box, ref datawindow adw_arg, string as_id, string as_dbid, integer ai_idtype);Integer li_Count, li_Sel
String ls_Clause

If not acbx_box.Checked then Return

ls_Clause = ""
li_Sel = 0

If ai_idtype = 1 then   // String ID
	// Join all strings in a string separated by commas
	For li_Count = 1 to adw_arg.RowCount()
		If adw_arg.IsSelected(li_Count) then 
			li_Sel++
			ls_Clause += "'" + adw_arg.GetItemString(li_Count, as_id) + "', "
		End If
	Next	
Else
	// Join all ID numbers in a string separated by commas
	For li_Count = 1 to adw_arg.RowCount()
		If adw_arg.IsSelected(li_Count) then 
			li_Sel++
			ls_Clause += String(adw_arg.GetItemNumber(li_Count, as_id)) + ", "
		End If
	Next
End If

// If nothing selected or all selected, de-select the checkbox
If (li_Sel = adw_arg.RowCount()) or (li_Sel = 0) then 
	acbx_box.Checked = False
	acbx_box.Event Clicked()
	Return
End If

ls_Clause = left(ls_Clause, Len(ls_Clause) - 2)  // Cut off ending comma

If is_where > "" then is_Where += " and ((" else is_Where = "(("   // Check if where clause already exists

If li_Sel = 1 then is_Where += as_dbid + " = " + ls_Clause + ")" else is_Where += as_dbid + " in (" + ls_Clause + "))"

is_Where += " or (" + as_dbid + " is Null))"
	
end subroutine

public subroutine wf_populatefilter (ref datawindowchild adwc_filter);String ls_Sel
Integer li_Count

adwc_filter.Reset( )

If cbx_im.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_im.RowCount()
		If dw_im.IsSelected(li_Count) then ls_Sel += dw_im.GetItemString(li_Count, "imname") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Insp. Type:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Comp.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Comp.RowCount()
		If dw_Comp.IsSelected(li_Count) then ls_Sel += dw_Comp.GetItemString(li_Count, "Comp_name") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Insp. Company:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Port.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Port.RowCount()
		If dw_Port.IsSelected(li_Count) then ls_Sel += dw_Port.GetItemString(li_Count, "Port_n") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Insp. Port:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_insp.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_insp.RowCount()
		If dw_insp.IsSelected(li_Count) then ls_Sel += dw_insp.GetItemString(li_Count, "fname") + "; "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Inspectors:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_date.Checked then
	If rb_aft.Checked then ls_Sel = "After "
	If rb_bef.Checked then ls_Sel = "Before "
	If rb_bet.Checked then ls_Sel = "Between "
	ls_Sel += String(dp_1.Value, "dd mmm yyyy")
	if rb_bet.checked then ls_Sel += " and " + String(dp_2.Value, "dd mmm yyyy")
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Insp. Date:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If
	
If cbx_Risk.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Risk.RowCount()
		If dw_Risk.IsSelected(li_Count) then ls_Sel += dw_Risk.GetItemString(li_Count, "risktext") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Item Risk:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Resp.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Resp.RowCount()
		If dw_Resp.IsSelected(li_Count) then ls_Sel += dw_Resp.GetItemString(li_Count, "resptext") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Item Resp:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If cbx_Cause.Checked then
	ls_Sel = ""
	For li_Count = 1 to dw_Cause.RowCount()
		If dw_Cause.IsSelected(li_Count) then ls_Sel += dw_Cause.GetItemString(li_Count, "causetext") + ", "
	Next
	ls_Sel = Left(ls_Sel, Len(ls_Sel) - 2)
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Cause:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If ii_close > 1 then 
	If ii_close = 2 then ls_Sel = "Open Items Only" else ls_Sel = "Closed Items Only" 
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Status:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If

If ii_def > 1 then 
	If ii_def = 2 then ls_Sel = "Non-Valid Obs Only" else ls_Sel = "Valid and Non-Valid Obs" 
	li_Count = adwc_filter.Insertrow(0)
	adwc_filter.SetItem(li_Count, "fType", "Valid/Non-Valid:")
	adwc_filter.SetItem(li_Count, "fSelect", ls_Sel)
End If
end subroutine

public subroutine wf_setsubtype (integer ai_max);
// Set the sub-type of report

st_10.TextColor = 0   // Set label color to 'enabled'
em_sub.Enabled = True  // Enabled control
em_sub.Text = '1'  // Set value
em_sub.Minmax = '1 ~~ ' + String(ai_Max) // Set minmax values

end subroutine

on w_rep.create
this.sle_desc=create sle_desc
this.st_1=create st_1
this.cbx_na=create cbx_na
this.cbx_ns=create cbx_ns
this.cbx_no=create cbx_no
this.cbx_yes=create cbx_yes
this.st_11=create st_11
this.cbx_sql=create cbx_sql
this.ole_rmc=create ole_rmc
this.st_imtip=create st_imtip
this.cb_reset=create cb_reset
this.em_sub=create em_sub
this.st_10=create st_10
this.st_tip=create st_tip
this.st_tiphead=create st_tiphead
this.sle_title=create sle_title
this.st_8=create st_8
this.cbx_hidefilter=create cbx_hidefilter
this.dw_insp=create dw_insp
this.cbx_insp=create cbx_insp
this.cbx_rep=create cbx_rep
this.ddlb_def=create ddlb_def
this.st_7=create st_7
this.ddlb_close=create ddlb_close
this.st_6=create st_6
this.dw_risk=create dw_risk
this.dw_cause=create dw_cause
this.dw_resp=create dw_resp
this.dw_port=create dw_port
this.cbx_port=create cbx_port
this.dw_comp=create dw_comp
this.dw_im=create dw_im
this.st_5=create st_5
this.rb_bet=create rb_bet
this.dp_2=create dp_2
this.sle_insptype=create sle_insptype
this.st_4=create st_4
this.cbx_cause=create cbx_cause
this.cbx_resp=create cbx_resp
this.cbx_risk=create cbx_risk
this.st_3=create st_3
this.cbx_comp=create cbx_comp
this.dp_1=create dp_1
this.rb_bef=create rb_bef
this.rb_aft=create rb_aft
this.cbx_date=create cbx_date
this.cbx_im=create cbx_im
this.st_2=create st_2
this.cb_close=create cb_close
this.cb_gen=create cb_gen
this.gb_1=create gb_1
this.gb_2=create gb_2
this.lb_rep=create lb_rep
this.Control[]={this.sle_desc,&
this.st_1,&
this.cbx_na,&
this.cbx_ns,&
this.cbx_no,&
this.cbx_yes,&
this.st_11,&
this.cbx_sql,&
this.ole_rmc,&
this.st_imtip,&
this.cb_reset,&
this.em_sub,&
this.st_10,&
this.st_tip,&
this.st_tiphead,&
this.sle_title,&
this.st_8,&
this.cbx_hidefilter,&
this.dw_insp,&
this.cbx_insp,&
this.cbx_rep,&
this.ddlb_def,&
this.st_7,&
this.ddlb_close,&
this.st_6,&
this.dw_risk,&
this.dw_cause,&
this.dw_resp,&
this.dw_port,&
this.cbx_port,&
this.dw_comp,&
this.dw_im,&
this.st_5,&
this.rb_bet,&
this.dp_2,&
this.sle_insptype,&
this.st_4,&
this.cbx_cause,&
this.cbx_resp,&
this.cbx_risk,&
this.st_3,&
this.cbx_comp,&
this.dp_1,&
this.rb_bef,&
this.rb_aft,&
this.cbx_date,&
this.cbx_im,&
this.st_2,&
this.cb_close,&
this.cb_gen,&
this.gb_1,&
this.gb_2,&
this.lb_rep}
end on

on w_rep.destroy
destroy(this.sle_desc)
destroy(this.st_1)
destroy(this.cbx_na)
destroy(this.cbx_ns)
destroy(this.cbx_no)
destroy(this.cbx_yes)
destroy(this.st_11)
destroy(this.cbx_sql)
destroy(this.ole_rmc)
destroy(this.st_imtip)
destroy(this.cb_reset)
destroy(this.em_sub)
destroy(this.st_10)
destroy(this.st_tip)
destroy(this.st_tiphead)
destroy(this.sle_title)
destroy(this.st_8)
destroy(this.cbx_hidefilter)
destroy(this.dw_insp)
destroy(this.cbx_insp)
destroy(this.cbx_rep)
destroy(this.ddlb_def)
destroy(this.st_7)
destroy(this.ddlb_close)
destroy(this.st_6)
destroy(this.dw_risk)
destroy(this.dw_cause)
destroy(this.dw_resp)
destroy(this.dw_port)
destroy(this.cbx_port)
destroy(this.dw_comp)
destroy(this.dw_im)
destroy(this.st_5)
destroy(this.rb_bet)
destroy(this.dp_2)
destroy(this.sle_insptype)
destroy(this.st_4)
destroy(this.cbx_cause)
destroy(this.cbx_resp)
destroy(this.cbx_risk)
destroy(this.st_3)
destroy(this.cbx_comp)
destroy(this.dp_1)
destroy(this.rb_bef)
destroy(this.rb_aft)
destroy(this.cbx_date)
destroy(this.cbx_im)
destroy(this.st_2)
destroy(this.cb_close)
destroy(this.cb_gen)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.lb_rep)
end on

event open;
f_Write2Log("w_Rep Open")
This.Postevent("ue_retrieve")
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 3000)
end event

type sle_desc from singlelineedit within w_rep
integer x = 73
integer y = 1232
integer width = 695
integer height = 80
integer taborder = 270
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 300
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_rep
integer x = 73
integer y = 1168
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
string text = "Descriptive Text:"
boolean focusrectangle = false
end type

type cbx_na from checkbox within w_rep
integer x = 3456
integer y = 1248
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "NA"
end type

type cbx_ns from checkbox within w_rep
integer x = 3200
integer y = 1248
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "NS"
end type

type cbx_no from checkbox within w_rep
integer x = 3456
integer y = 1184
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
boolean checked = true
end type

type cbx_yes from checkbox within w_rep
integer x = 3200
integer y = 1184
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
end type

type st_11 from statictext within w_rep
integer x = 2725
integer y = 1184
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item Answer:"
boolean focusrectangle = false
end type

type cbx_sql from checkbox within w_rep
boolean visible = false
integer x = 73
integer y = 1504
integer width = 347
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Copy SQL"
end type

type ole_rmc from olecustomcontrol within w_rep
event mousedown ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y,  ref oleobject tinfo )
event mouseup ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y,  ref oleobject tinfo )
event mousemove ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y,  ref oleobject tinfo )
event dblclick ( )
event mousedowna ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y,  ref oleobject oinfo )
event mouseupa ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y,  ref oleobject oinfo )
event mousemovea ( ref integer button,  ref integer shift,  ref real ocx_x,  ref real ocx_y,  ref oleobject oinfo )
boolean visible = false
integer x = 256
integer y = 1936
integer width = 494
integer height = 112
integer taborder = 140
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_rep.win"
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type st_imtip from statictext within w_rep
boolean visible = false
integer x = 1463
integer y = 1264
integer width = 933
integer height = 224
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 15793151
string text = "Type a few characters from the Inspection Model name and press ~'Enter~'. All model names that contain these characters will be selected."
boolean border = true
boolean focusrectangle = false
end type

type cb_reset from commandbutton within w_rep
integer x = 3365
integer y = 32
integer width = 439
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset All &Filters"
end type

event clicked;
cbx_Im.Checked = False
cbx_Im.event clicked( )
sle_insptype.Text = ""

cbx_comp.Checked = False
cbx_Comp.event clicked( )

cbx_Port.Checked = False
cbx_Port.event clicked( )

cbx_Insp.Checked = False
cbx_Insp.event clicked( )

cbx_Date.Checked = False
cbx_Date.event clicked( )

cbx_Risk.Checked = False
cbx_Risk.event clicked( )

cbx_Resp.Checked = False
cbx_Resp.event clicked( )

cbx_Cause.Checked = False
cbx_Cause.event clicked( )

ddlb_close.Selectitem(1)
ii_Close = 1

ddlb_def.SelectItem(1)
ii_Def = 1

If cbx_Rep.Enabled then cbx_Rep.Checked = False

lb_rep.selectitem(0)
sle_title.Text = ""
ii_RepNum = 0

cbx_no.Checked = True
cbx_Yes.Checked = False
cbx_NS.Checked = False
cbx_NA.Checked = False
end event

type em_sub from editmask within w_rep
integer x = 329
integer y = 848
integer width = 183
integer height = 80
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#0"
boolean spin = true
double increment = 1
string minmax = "1~~4"
end type

type st_10 from statictext within w_rep
integer x = 73
integer y = 864
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217745
long backcolor = 67108864
string text = "Sub Type:"
boolean focusrectangle = false
end type

type st_tip from statictext within w_rep
boolean visible = false
integer x = 823
integer y = 240
integer width = 1792
integer height = 720
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 134217752
boolean enabled = false
string text = "This is Help text"
boolean focusrectangle = false
end type

type st_tiphead from statictext within w_rep
boolean visible = false
integer x = 786
integer y = 128
integer width = 1865
integer height = 864
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 134217752
boolean enabled = false
string text = "Chapter Statistics"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_title from singlelineedit within w_rep
integer x = 73
integer y = 1056
integer width = 695
integer height = 80
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type st_8 from statictext within w_rep
integer x = 73
integer y = 992
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Title:"
boolean focusrectangle = false
end type

type cbx_hidefilter from checkbox within w_rep
integer x = 73
integer y = 1360
integer width = 567
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide filters in report"
end type

type dw_insp from datawindow within w_rep
integer x = 2670
integer y = 272
integer width = 530
integer height = 528
integer taborder = 160
string dataobject = "d_sq_tb_rep_inspname"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_insp.Checked then cbx_insp.Checked = True

If (li_Sel = 0) and cbx_insp.Checked then cbx_insp.Checked = False
end event

type cbx_insp from checkbox within w_rep
integer x = 2670
integer y = 208
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Inspector:"
end type

event clicked;
If not This.Checked then dw_Insp.SelectRow(0, False)


end event

type cbx_rep from checkbox within w_rep
integer x = 2725
integer y = 1360
integer width = 635
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include Non-Report Items"
end type

type ddlb_def from dropdownlistbox within w_rep
integer x = 3200
integer y = 1072
integer width = 549
integer height = 320
integer taborder = 240
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Valid Only","Non-Valid only","All Obs"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Def = index
end event

type st_7 from statictext within w_rep
integer x = 2725
integer y = 1088
integer width = 466
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Obs Validity:"
boolean focusrectangle = false
end type

type ddlb_close from dropdownlistbox within w_rep
integer x = 3200
integer y = 976
integer width = 549
integer height = 320
integer taborder = 230
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"All Items","Open Only","Closed Only"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Close = index

end event

type st_6 from statictext within w_rep
integer x = 2725
integer y = 992
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Close-Out Status:"
boolean focusrectangle = false
end type

type dw_risk from datawindow within w_rep
integer x = 914
integer y = 976
integer width = 530
integer height = 448
integer taborder = 200
string dataobject = "d_ext_rep_risk"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_risk.Checked then cbx_risk.Checked = True

If (li_Sel = 0) and cbx_risk.Checked then cbx_risk.Checked = False
end event

type dw_cause from datawindow within w_rep
integer x = 2085
integer y = 976
integer width = 530
integer height = 448
integer taborder = 220
string dataobject = "d_sq_tb_rep_cause"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_cause.Checked then cbx_cause.Checked = True

If (li_Sel = 0) and cbx_cause.Checked then cbx_cause.Checked = False
end event

type dw_resp from datawindow within w_rep
integer x = 1499
integer y = 976
integer width = 530
integer height = 448
integer taborder = 210
string dataobject = "d_sq_tb_rep_resp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_resp.Checked then cbx_resp.Checked = True

If (li_Sel = 0) and cbx_resp.Checked then cbx_resp.Checked = False
end event

type dw_port from datawindow within w_rep
integer x = 2085
integer y = 272
integer width = 530
integer height = 528
integer taborder = 140
string dataobject = "d_sq_tb_rep_port"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_port.Checked then cbx_port.Checked = True
If (li_Sel = 0) and cbx_port.Checked then cbx_port.Checked = False
end event

type cbx_port from checkbox within w_rep
integer x = 2085
integer y = 208
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Port:"
end type

event clicked;
If not This.Checked then dw_port.SelectRow(0, False)


end event

type dw_comp from datawindow within w_rep
integer x = 1499
integer y = 272
integer width = 530
integer height = 528
integer taborder = 120
string dataobject = "d_sq_tb_rep_comp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_comp.Checked then cbx_comp.Checked = True

If (li_Sel = 0) and cbx_comp.Checked then cbx_comp.Checked = False
end event

type dw_im from datawindow within w_rep
integer x = 914
integer y = 272
integer width = 530
integer height = 448
integer taborder = 110
string dataobject = "d_sq_tb_rep_im"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_Count, li_Sel

If Row > 0 then
  This.SelectRow(Row, not This.IsSelected( Row ))
End If

li_Sel = 0

For li_Count = 1 to This.RowCount( )
	If This.IsSelected( li_Count) then li_Sel++
Next

If (li_Sel > 0) and not cbx_im.Checked then cbx_im.Checked = True

If (li_Sel = 0) and cbx_im.Checked then cbx_im.Checked = False
end event

type st_5 from statictext within w_rep
integer x = 3237
integer y = 464
integer width = 91
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217745
long backcolor = 67108864
boolean enabled = false
string text = "and"
boolean focusrectangle = false
end type

type rb_bet from radiobutton within w_rep
integer x = 3639
integer y = 288
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Bet"
boolean checked = true
end type

event clicked;
st_5.Visible = True
dp_2.Visible = True
end event

type dp_2 from datepicker within w_rep
integer x = 3346
integer y = 448
integer width = 402
integer height = 80
integer taborder = 130
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2000-01-01")
datetime value = DateTime(Date("2007-07-09"), Time("00:00:00.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

event valuechanged;
If dp_1.Value > dp_2.Value then dp_1.Value = dp_2.Value
end event

type sle_insptype from singlelineedit within w_rep
event ue_keydown pbm_keydown
integer x = 914
integer y = 720
integer width = 530
integer height = 80
integer taborder = 150
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If Key = KeyEnter! then 
	This.event modified( )
	st_IMTip.Visible = False
End If
end event

event modified;
Integer li_Count, li_Sel
String ls_IM, ls_Search

ls_Search = Trim(sle_insptype.Text)

if ls_Search = "" then Return

li_Sel = 0

For li_Count = 1 to dw_im.Rowcount( )
	ls_IM = Upper(dw_im.GetItemString(li_Count, "IMNAME"))
	If Pos(ls_IM, ls_Search) > 0 then
		dw_im.SelectRow(li_Count, True) 
		li_Sel++
	Else 
		dw_im.SelectRow(li_Count, False)
	End If
Next

If li_Sel = 0 then cbx_Im.Checked = False else cbx_Im.Checked = True
end event

event getfocus;st_IMTip.Visible = True

end event

event losefocus;st_IMTip.Visible = False
end event

type st_4 from statictext within w_rep
integer x = 2670
integer y = 912
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Other Options:"
boolean focusrectangle = false
end type

type cbx_cause from checkbox within w_rep
integer x = 2085
integer y = 912
integer width = 453
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Cause:"
end type

event clicked;
If not This.Checked then dw_cause.SelectRow(0, False)
end event

type cbx_resp from checkbox within w_rep
integer x = 1499
integer y = 912
integer width = 453
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Responsibility:"
end type

event clicked;
If not This.Checked then dw_resp.SelectRow(0, False)
end event

type cbx_risk from checkbox within w_rep
integer x = 914
integer y = 912
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Risk:"
end type

event clicked;
If not This.Checked then dw_risk.SelectRow(0, False)
end event

type st_3 from statictext within w_rep
integer x = 859
integer y = 832
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Items:"
boolean focusrectangle = false
end type

type cbx_comp from checkbox within w_rep
integer x = 1499
integer y = 208
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Company:"
end type

event clicked;
If not This.Checked then dw_Comp.SelectRow(0, False)


end event

type dp_1 from datepicker within w_rep
integer x = 3346
integer y = 368
integer width = 402
integer height = 80
integer taborder = 170
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2000-01-01")
datetime value = DateTime(Date("2007-07-09"), Time("00:00:00.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

event valuechanged;
If dp_1.Value > dp_2.Value then dp_2.Value = dp_1.Value
end event

type rb_bef from radiobutton within w_rep
integer x = 3291
integer y = 288
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Bef"
end type

event clicked;
st_5.Visible = False
dp_2.Visible = False
end event

type rb_aft from radiobutton within w_rep
integer x = 3474
integer y = 288
integer width = 165
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Aft"
end type

event clicked;
st_5.Visible = False
dp_2.Visible = False
end event

type cbx_date from checkbox within w_rep
integer x = 3255
integer y = 208
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Date"
end type

event clicked;

rb_Bef.Enabled = This.Checked
rb_Aft.Enabled = This.Checked
rb_Bet.Enabled = This.Checked
dp_1.Enabled = This.Checked
dp_2.Enabled = This.Checked

If This.Checked then st_5.TextColor = 33554432 else st_5.TextColor = 134217745

end event

type cbx_im from checkbox within w_rep
integer x = 914
integer y = 208
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Type:"
end type

event clicked;
If not This.Checked then
	dw_IM.SelectRow(0, False)
	sle_insptype.Text = ""
End If

end event

type st_2 from statictext within w_rep
integer x = 859
integer y = 128
integer width = 503
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspections:"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_rep
integer x = 2341
integer y = 1504
integer width = 549
integer height = 96
integer taborder = 260
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;
f_Write2Log("w_Rep Close")
Close(Parent)

end event

type cb_gen from commandbutton within w_rep
integer x = 951
integer y = 1504
integer width = 603
integer height = 96
integer taborder = 250
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Generate &Report"
end type

event clicked;
Integer li_Sub, li_Val[], li_Count
String ls_Clause, ls_dw, ls_dwc, ls_SQL, ls_Rep, ls_Data, ls_FinalSQL
DatawindowChild ldwc_child
DataStore lds_gr

If ii_RepNum = 0 then   // Nothing selected
	MessageBox("Report Selection", "Please select a report to generate!", Exclamation!)
	Return
End If

sle_title.Text = Trim(sle_title.Text)  // Trim down textboxes

If sle_Title.Text = "" then   // Check report title
	MessageBox("Title Required", "The report requires a title. Please specify a title and description (optional) for the report.")
	sle_Title.Setfocus( )
	Return
End If

li_Sub = Integer(em_sub.Text)    // Get report subtype

Choose Case ii_RepNum  // Choose on report type
	Case 1
		if mod(li_Sub,2) = 1 then ls_dw = "d_rep_chapstatrisk" else ls_dw = "d_rep_chapstatim"
		If (li_Sub < 1) or (li_Sub > 4) then li_Sub = 999
	Case 2
		ls_dw = "d_rep_general"
		If (li_Sub < 1) or (li_Sub > 8) then li_Sub = 999
	Case 3
		ls_dw = "d_rep_pie"
	Case 4
		ls_dw = "d_rep_vettstat"
	Case 5
		ls_dw = "d_rep_approval"
		If (li_Sub < 1) or (li_Sub > 2) then li_Sub = 999
	Case 7
		ls_dw = "d_rep_itemstat"
		If (li_Sub < 1) or (li_Sub > 2) then li_Sub = 999
	Case 11
		ls_dw = "d_rep_comparison"
End Choose

If li_Sub = 999 then   // Invalid subtype
	MessageBox("Report Sub-Type", "An invalid report sub-type is selected. Please choose a valid sub-type")
	Return
End If


SetPointer(HourGlass!)

ls_Rep = ""
is_Where = ""

// Process all DW

If ii_Repnum <> 9 then  // Ignore the following for benchmark report
	wf_processdw(cbx_im, dw_im, "im_id", "IM_ID", 0)
	wf_processdw(cbx_comp, dw_comp, "comp_id", "VETT_MASTER.COMP_ID", 0)
	wf_processdw(cbx_port, dw_port, "port_code", "PORT", 1)
	wf_processdw(cbx_risk, dw_risk, "riskid", "RISK", 0)
	wf_processdw(cbx_resp, dw_resp, "resp_id", "RESP_ID", 0)
	wf_processdw(cbx_cause, dw_cause, "cause_id", "CAUSE_ID", 0)
	wf_processdw(cbx_insp, dw_insp, "fullnameid", "(INSP_FNAME+INSP_LNAME)", 1)

	If is_Where > "" then is_Where += " and "
	is_Where += "((REQTYPE > 0) or (REQTYPE is Null))" // Exclude all information items

	If cbx_date.Checked then
		If rb_aft.Checked then ls_Clause = "(INSPDATE > '" + String(dp_1.Value, "dd mmm yyyy") + "')"
		If rb_bef.Checked then ls_Clause = "(INSPDATE < '" + String(dp_1.Value, "dd mmm yyyy") + "')"
		If rb_bet.Checked then ls_Clause = "(INSPDATE >= '" + String(dp_1.Value, "dd mmm yyyy") + "' and INSPDATE <= '" + String(dp_2.Value, "dd mmm yyyy") + "')"	
		is_Where += " and " + ls_Clause
	End If

	If ii_Close > 1 then
		If ii_Close = 2 then ls_Clause = "((CLOSED = 0) or (CLOSED is Null))"
		If ii_Close = 3 then ls_Clause = "((CLOSED = 1) or (CLOSED is Null))"
		is_Where += " and " + ls_Clause
	End If
	
	If ii_Def < 3 then
		If ii_Def = 1 then ls_Clause = "((DEF = 1) or (DEF is Null))"
		If ii_Def = 2 then ls_Clause = "((DEF = 0) or (DEF is Null))"
		is_Where += " and " + ls_Clause
	End If
		
	If cbx_Rep.Checked then ls_Rep = "" else ls_Rep = " and ((REPORT = 1) or (REPORT is Null))"
		
	ls_Clause = "((ANS is Null)"
	If cbx_No.Checked then ls_Clause += " or (ANS = 1)"
	If cbx_Yes.Checked then ls_Clause += " or (ANS = 0)"
	If cbx_NS.Checked then ls_Clause += " or (ANS = 2)"
	If cbx_NA.Checked then ls_Clause += " or (ANS = 3)"
	ls_Clause += ")"
	
	If Len(ls_Clause) = 15 then   // Nothing selected for answer
		MessageBox("Answer Selection", "At least one item answer must be selected!", Exclamation!)
		Return
	End If

	// If not all answers selected, add to where clause
	If Not (cbx_No.Checked and cbx_Yes.Checked and cbx_NS.Checked and cbx_NA.Checked) then	is_Where += " and " + ls_Clause		
End If

// Point of no return  !!!!

// By now, is_Where contains the where clause for the filters with no leading 'and'
// Messagebox("is_Where", is_Where)

ls_FinalSQL = ""  // to hold all SQL for debug purposes

OpenSheet(w_preview, w_main, 0, Original!)  // Open Report Preview
w_preview.dw_rep.DataObject = ls_dw   //  Set the master DW
w_preview.dw_rep.SetTransObject(SQLCA)   
w_preview.dw_rep.Retrieve(sle_Title.Text, '') // Retrieve master DW 

If not cbx_HideFilter.Checked then  // Get filter child (if it exists) and populate it
	If w_preview.dw_rep.GetChild("dw_filter", ldwc_child) = 1 then wf_PopulateFilter(ldwc_child)
End If

Choose Case ii_RepNum    //  Set Select clauses for child reports and retrieve
	Case 1 // Chapter Statistics
		is_where = " and " + is_where
		If mod(li_Sub,2) = 1 then  // If by Risk
		  ls_SQL = "Select CHAPNUM, Sum(Case when (RISK = 0) then 1 else 0 end) as LOW,"&
        + "Sum(Case when (RISK = 1) then 1 else 0 end) as MED, Sum(Case when (RISK = 2) then 1 else 0 end) as HIGH"
		Else  // If by Insp Model
		  ls_SQL = "Select CHAPNUM, Sum(Case when (CharIndex('Pet', IMNAME)>0) then 1 else 0 end) as LOW,"&
        + "Sum(Case when (CharIndex('Gas', IMNAME)>0) then 1 else 0 end) as MED, Sum(Case when (CharIndex('Chem', IMNAME)>0) then 1 else 0 end) as HIGH"
		End If
		ls_SQL += " From VETT_MASTER Where (IMNAME like ('"
		If li_Sub < 3 then ls_SQL += "SIRE" else ls_SQL += "CDI"
		ls_SQL += "%')) and (CHAPNUM is not Null)" + is_where + " Group By CHAPNUM Order By CHAPNUM"
		w_preview.dw_rep.GetChild("dw_chap", ldwc_child)  // Get main child
//		If (li_Ret < 0) then Messagebox("DW Error", "Unable to set SQL. Rep: " + String(ii_RepNum),Exclamation!)
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject		
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		If li_Sub > 2 then ldwc_child.Retrieve("CDI") else ldwc_child.Retrieve("SIRE")  // Retrieve child
		w_preview.dw_rep.GetChild("dw_key", ldwc_child)  // Get other child
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		If li_Sub > 2 then ldwc_child.Retrieve("CDI") else ldwc_child.Retrieve("SIRE")  // Retrieve child		
				
	Case 2 // General Report
		is_where = " and " + is_where
		If li_Sub < 8 then
			ls_SQL = "Select VETT_MASTER.CHAP, VETT_MASTER.CHAPNUM, VETT_MASTER.SECT,"& 
			 + "VETT_MASTER.SECTNUM, VETT_MASTER.QPAR1, VETT_MASTER.QPARNUM1,"&
			 + "VETT_MASTER.QPAR2, VETT_MASTER.QNAME,"&
			 + "VETT_MASTER.QNUM, VETT_MASTER.INSPCOMM, VETT_MASTER.OWNCOMM,"&
			 + "VETT_MASTER.FOLLOWUP,VETT_MASTER.DEF,"&
			 + "VETT_MASTER.RESPTEXT, VETT_MASTER.RISK, VETT_MASTER.CLOSED,"&
			 + "VETT_MASTER.CLOSEDATE, VETT_MASTER.REQTYPE, VETT_MASTER.IMNAME,"&   
			 + "VETT_MASTER.EDITION, VETT_MASTER.QPARNUM2, VETT_MASTER.QPAR3,"&
			 + "VETT_MASTER.QPARNUM3, INSPDATE, EXTNUM FROM VETT_MASTER "&
			 + "Where (ANS is not Null)"			
		Else
			ls_SQL = "SELECT CHAPNUM,SECTNUM,QPARNUM1,QPARNUM2,INSPCOMM,QPARNUM3,QNUM,EXTNUM,IMNAME,REQTYPE "&
          + "FROM VETT_MASTER WHERE (ANS is not Null) and (VESSEL_ACTIVE <> 0)"
		End If
		ls_SQL += is_Where + ls_Rep
		If li_Sub < 4 then w_preview.dw_rep.object.dw_insp.dataobject = "d_sq_tb_inspgen2"	// Switch report	 
		If (li_Sub > 3) and (li_Sub < 8) then li_Sub -= 3  // To obtain correct retrieval argument
		If li_Sub = 8 then w_preview.dw_rep.object.dw_insp.dataobject = "d_sq_tb_inspectorcomm"  // Switch report
		w_preview.dw_rep.GetChild("dw_insp", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve(li_Sub) // Retrieve child
			
	Case 3 // Graphical report
		is_where = " and " + is_where 		
		
		ls_SQL = "Select Count(ANS), VETT_COMP.NAME FROM VETT_MASTER,"&
		 + "VETT_COMP Where (VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID)"&
		 + is_where + " Group By VETT_COMP.NAME Order By VETT_COMP.NAME ASC"
		w_preview.dw_rep.GetChild("dw_comp", ldwc_child)  // Get 3rd child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child	
					
		ls_SQL = "Select Count(ANS), (Case RISK When 0 Then 'Low' When 1 Then 'Medium' When 2 Then 'High' End) as RISK "&
		 + "From VETT_MASTER Where (ANS is not null)" + is_where + " Group By RISK"
		w_preview.dw_rep.GetChild("dw_risk", ldwc_child)  // Get 4th child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child		
		
		ls_SQL = "Select Count(ANS), RESPTEXT "&
		 + "From VETT_MASTER Where (ANS is not null)" + is_where + " Group By RESPTEXT Order By RESPTEXT"
		w_preview.dw_rep.GetChild("dw_resp", ldwc_child)  // Get 5th child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child		
  
		ls_SQL = "Select Count(ANS), CLOSED as ITEMSTATUS "&
		 + "From VETT_MASTER Where (ANS is not null)" + is_where + " Group By CLOSED"
		w_preview.dw_rep.GetChild("dw_status", ldwc_child)  // Get 6th child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child	

	Case 4 // Vetting Statistics
		is_where = " and " + is_where
		ls_SQL = "Select VESSELS.VESSEL_ID as VSLID, INSP_ID,"&   
       + "Count(ANS) as ITEMTOTAL,"&
       + "Sum(Case When (RISK=0) Then 1 Else 0 End) as LOWRISK,"&
       + "Sum(Case When (RISK=1) Then 1 Else 0 End) as MEDRISK,"&   
       + "Sum(Case When (RISK=2) Then 1 Else 0 End) as HIRISK,"&   
       + "Sum(Case When (RISK=0) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as LOWVSL,"&
       + "Sum(Case When (RISK=1) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as MEDVSL,"& 
       + "Sum(Case When (RISK=2) and (RESPTEXT = 'Vessel') Then 1 Else 0 End) as HIVSL,"&
       + "INSPDATE,IMNAME,VESSELS.VESSEL_NAME, VESSELS.VETT_SCORE,TYPE_NAME,LASTSIRE,LASTVSLSCORE FROM VETT_MASTER, VESSELS, VETT_VSLTYPE "&
       + "Where (VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID) and (VETT_VSLTYPE.TYPE_ID = VETT_MASTER.VETT_TYPE)" + is_where&
		 + " Group By VESSELS.VESSEL_ID,INSP_ID,INSPDATE,IMNAME,VESSEL_NAME,VETT_SCORE,TYPE_NAME,LASTSIRE,LASTVSLSCORE"&
		 + " Order By TYPE_NAME, VETT_SCORE DESC"
		w_preview.dw_rep.GetChild("dw_vstat", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ls_FinalSQL = ls_SQL
		ldwc_child.Retrieve( )  // Retrieve child	
			
	Case 5 // Inspection Summary
		is_where = " and " + is_where
		ls_SQL = "Select VESSEL_NAME,INSPDATE,IMNAME,EDITION,VETT_COMP.NAME,IsNull(PORT_N, '< ' + VETT_MASTER.PORT + ' >') PORT_N,RATING "&
       + "FROM VETT_MASTER INNER JOIN VESSELS ON VETT_MASTER.VESSELIMO = VESSELS.IMO_NUMBER "&
			 + "INNER JOIN VETT_COMP ON VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID "&
			 + "LEFT OUTER JOIN PORTS ON VETT_MASTER.PORT = PORTS.PORT_CODE "&
       + "Where (VESSELS.VESSEL_ACTIVE <> 0) and (COMPLETED = 1)" + is_where&
		 + " Group By VESSEL_NAME, INSPDATE, IMNAME, EDITION, VETT_COMP.NAME, PORT_N, VETT_MASTER.PORT, RATING"&
		 + " Order By VESSELS.VESSEL_NAME ASC,INSPDATE ASC" 		 
		If li_Sub = 2 then w_preview.dw_rep.object.dw_appr.dataobject = "d_sq_tb_inspsummary"		 		
		w_preview.dw_rep.GetChild("dw_appr", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		ldwc_child.Retrieve( )  // Retrieve child			
						
	Case 7 // Item Statistics
		is_where = " and " + is_where
		ls_SQL = "Select IMNAME, EDITION, CHAP, CHAPNUM, SECT, SECTNUM,QPAR1,QPARNUM1,"&   
       + "QPAR2,QPARNUM2,QPARNUM3,QPAR3,QNAME,QNUM "&
       + "FROM VETT_MASTER Where (QNUM is not null) " + is_where&
		 + " Order By IMNAME,EDITION,CHAPNUM,SECTNUM,QPARNUM1,QPARNUM2,QPARNUM3,QNUM" 		 
		w_preview.dw_rep.GetChild("dw_istat", ldwc_child)  // Get main child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL = ls_SQL
		ldwc_child.SetTransobject(SQLCA)   //  Set Child TransObject
		Choose Case li_Sub
			Case 1; ldwc_child.SetFilter( "")
			Case 2; ldwc_child.SetFilter( "repc>1")
		End Choose
		ldwc_child.Filter( )
		ldwc_child.Retrieve( )  // Retrieve child		
		
	Case 11  // SIRE-MIRE comparison
		ls_SQL = "SELECT VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE,VETT_MASTER.IMNAME,VETT_MASTER.EDITION,"&
		 + "VETT_COMP.NAME,VETT_MASTER.INSP_FNAME,VETT_MASTER.INSP_LNAME,(Count(ANS)) as OBS,"&
		 + "(Sum(Case When (RISK = 0) and (RESPTEXT = 'Vessel') Then 1 Else 0 End)) AS VLOWRISK,"&
		 + "(Sum(Case When (RISK = 1) and (RESPTEXT = 'Vessel') Then 1 Else 0 End)) AS VMEDRISK,"&
		 + "(Sum(Case When (RISK = 2) and (RESPTEXT = 'Vessel') Then 1 Else 0 End)) AS VHIRISK,"&
		 + "(Sum(Case RISK When 0 Then 1 Else 0 End)) AS LOWRISK,(Sum(Case RISK When 1 Then 1 Else 0 End)) AS MEDRISK,(Sum(Case RISK When 2 Then 1 Else 0 End)) AS HIRISK,"&
		 + "VETT_MASTER.RATING,VETT_MASTER.VSLSCORE "&
       + "FROM VETT_MASTER INNER JOIN VESSELS ON VESSELS.IMO_NUMBER = VESSELIMO INNER JOIN VETT_COMP ON VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID "&
			 + "Where (VETT_MASTER.VESSEL_ACTIVE <> 0) and (COMPLETED=1) and " + is_where + " GROUP BY "&
		 + "VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE,VETT_MASTER.IMNAME,VETT_MASTER.EDITION,VETT_COMP.NAME,VETT_MASTER.INSP_FNAME,VETT_MASTER.INSP_LNAME,"&
		 + "VETT_MASTER.RATING,VETT_MASTER.VSLSCORE "&
		 + "ORDER BY VESSELS.VESSEL_NAME,VETT_MASTER.INSPDATE"
		w_preview.dw_rep.GetChild("dw_comparison", ldwc_child)  // Get first child
		ldwc_child.SetSQLSelect(ls_SQL)  // Set child SQL
		ls_FinalSQL += ls_SQL
		ldwc_child.SetTransobject(SQLCA)   // Set Child Transobject		
		ldwc_child.Retrieve( )  // Retrieve child	
//		ldwc_child.Modify("vslscore.Color = '0 ~t If( vslscore >= " + String(g_obj.ScoreGreen) + ", 49152, If( vslscore >= " + String(g_obj.ScoreYellow ) + ", 49344, 255))'")
//		ldwc_child.Modify("rating.color = '0 ~t If( Left(rating,1) <= ~"" + g_obj.InspGreen + "~", 49152, If(Left(rating,1) <=~"" + g_obj.InspYellow + "~", 49344, 192))'")
	
		w_preview.dw_rep.GetChild("dw_anomalies", ldwc_child)  // Get 2nd child
		ls_SQL = "SELECT VESSELS.VESSEL_NAME, VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME,Count(ANS) as ITEMCOUNT "&
		+ "FROM VETT_MASTER INNER JOIN VESSELS ON VETT_MASTER.VESSELIMO = VESSELS.IMO_NUMBER WHERE (VETT_MASTER.QNUM is not Null) and (VETT_MASTER.VESSEL_ACTIVE <> 0) and (COMPLETED=1) and " + is_Where + " GROUP BY "&
		+ "VESSELS.VESSEL_NAME,VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME "&
		+ "HAVING Count(ANS) > 1 ORDER BY VESSELS.VESSEL_NAME,VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM"
		ldwc_child.SetSQLSelect(ls_SQL)   //  Set SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   // Set Child Transobject		
		ldwc_child.Retrieve( )  // Retrieve child	
         
		w_preview.dw_rep.GetChild("dw_highrisk", ldwc_child)  // Get 3rd child
		ls_SQL = "SELECT VESSELS.VESSEL_NAME,Left(VETT_MASTER.IMNAME, 4) as IM_NAME,VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME,Count(ANS) as ITEMCOUNT "&
		+ "FROM VETT_MASTER INNER JOIN VESSELS ON VETT_MASTER.VESSELIMO = VESSELS.IMO_NUMBER WHERE (VETT_MASTER.QNUM is not Null) and (RISK = 2) and (VETT_MASTER.VESSEL_ACTIVE <> 0) and (COMPLETED=1) and " + is_Where + " GROUP BY "&
		+ "VESSELS.VESSEL_NAME,Left(VETT_MASTER.IMNAME, 4),VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM,VETT_MASTER.QNAME "&
		+ "ORDER BY VESSELS.VESSEL_NAME,Left(VETT_MASTER.IMNAME, 4),VETT_MASTER.CHAPNUM,VETT_MASTER.SECTNUM,VETT_MASTER.QPARNUM1,VETT_MASTER.QPARNUM2,VETT_MASTER.QPARNUM3,VETT_MASTER.QNUM"
		ldwc_child.SetSQLSelect(ls_SQL)   //  Set SQL
		ls_FinalSQL += "~r~n~r~n" + ls_SQL
		ldwc_child.SetTransobject(SQLCA)   // Set Child Transobject		
		ldwc_child.Retrieve( )  // Retrieve child	
End Choose

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer + " - " + lb_rep.Selecteditem( )  //  Set the report footer

f_Write2Log("w_Rep > cb_Gen; SQL: " + ls_FinalSQL)

w_preview.wf_ShowReport()

If cbx_Sql.Checked then Clipboard(ls_FinalSQL)

end event

type gb_1 from groupbox within w_rep
event ue_mousemove pbm_mousemove
integer x = 37
integer y = 32
integer width = 768
integer height = 1456
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Type"
end type

event ue_mousemove;
If ibool_TipVisible then
	st_Tip.Visible = False
	st_TipHead.Visible = False
	ibool_TipVisible = False
End If
end event

type gb_2 from groupbox within w_rep
event ue_mousemove pbm_mousemove
integer x = 823
integer y = 32
integer width = 2999
integer height = 1456
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Filters"
end type

event ue_mousemove;If ibool_TipVisible then
	st_Tip.Visible = False
	st_TipHead.Visible = False
	ibool_TipVisible = False
End If
end event

type lb_rep from listbox within w_rep
integer x = 73
integer y = 128
integer width = 695
integer height = 704
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string item[] = {"Chapter Statistics","General Report","Graphical Report","Inspection Summary","Item Statistics","SIRE/MIRE Comparison"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_text
Integer li_TipHeight

ls_text = lb_rep.Selecteditem( )  // By default, set report title
sle_title.Text = ls_Text
cbx_Rep.Enabled = False   //  Include non-report items
cbx_Rep.Checked = True 
st_10.Textcolor = 12632256  // Sub-Type label to be disabled
em_Sub.Enabled = False	 // Sub-Type selection disabled
em_sub.Text = "1"       // Sub-Type selected as 1
cbx_im.Enabled = True   // Inspection model checkbox to be enabled
dw_im.Enabled = True    // Inspection model DW to be enabled
dw_im.Modify("DataWindow.Color='16777215'" )  // Inspection Model DW back color to be white
sle_insptype.Enabled = True   // enable text box for model selection
sle_insptype.Text = ""        // empty text box
cbx_risk.Enabled = True       // Enable risk checkbox
ddlb_def.SelectItem(1)  // Valid-Obs only by default
ii_Def = 1
ddlb_def.Enabled = True     // Enable Valid/non-valid selection

Choose Case ls_text
	Case "Chapter Statistics"
		ii_RepNum = 1
		cbx_im.Checked = False  // No inspection model selection
		cbx_im.event clicked( ) // Call event to de-select all rows in DW
		cbx_im.Enabled = False  // Disable checkbox
		dw_im.Enabled = False  // Disable DW
		dw_im.Modify("DataWindow.Color='14737632'")  // Change DW backcolor to gray
		sle_insptype.Enabled = False  // Disable model selection textbox
		wf_SetSubType(4)     // Set subreports
	Case "General Report"
		ii_RepNum = 2
		sle_title.Text = ""      // Remove report title
		cbx_Rep.Enabled = True   // Enable option to include non-report items
		cbx_Rep.Checked = False  // By default, do not include non-report items
		wf_SetSubType(8)          // Set subreports
	Case "Graphical Report"
		ii_RepNum = 3
		sle_title.Text = ""      // Remove report title
	Case "Inspection Summary"
		ii_Repnum = 5
		ddlb_def.SelectItem(3)        // Include all observations
		ii_Def = 3
		wf_SetSubType(2)                // Set subreports
	Case "Item Statistics"
		ii_Repnum = 7
		wf_SetSubType(2)                // Set subreports
	Case "SIRE/MIRE Comparison"
		ii_RepNum = 11
		ddlb_def.SelectItem(1)       // Valid obs only
		ii_Def = 1
		ddlb_def.Enabled = False     // Disable valid/nonvalid selection
		sle_Insptype.Text = "IRE"       // Select SIRE and MIRE
		sle_Insptype.event modified( )  // Call event to select in DW
		sle_Insptype.Text = ""      // Empty textbox
End Choose

st_TipHead.Text = lb_rep.Selecteditem( )

Choose Case ii_repnum
	Case 1  
		st_Tip.Text = "A Bar-graph report of total observations grouped by chapters and stacked as per below.~n~nType 1: SIRE Inspections - Stacked by Risk~n~nType 2: SIRE Inspections - Stacked by Type~n~nType 3: CDI Inspections - Stacked by Risk~n~nType 4: CDI Inspections - Stacked by Type"
		li_TipHeight = 700	
	Case 2
		st_Tip.Text = "A listing of all observations grouped by Risk, Inspection Model, Chapter and Section. Seven report sub-types are available. The fields included are as follows:~n~n"&
		+ "Type 1: Valid Obs, Vessel Type, Risk, Closed Status, Responsibility, Inspection Date, Inspector's Comments, Initial and Further Operator Comments. (For internal circulation only)~n~n"&
		+ "Type 2: Same as Type 1 but without the 'Closed' field. (For distribution to fleet)~n~n"&
		+ "Type 3: Same as Type 2 but without Initial and Further Operator comments. (For distribution to fleet)~n~n"&		
		+ "Type 4: Same as Type 1, but without grouping by Risk.~n~n"&
		+ "Type 5: Same as Type 2, but without grouping by Risk.~n~n"&
		+ "Type 6: Same as Type 3, but without grouping by Risk.~n~n"&
		+ "Type 7: Same as Type 1, but without grouping by Risk and without any headers. (For external customers)~n~n"&
		+ "Type 8: A list of inspector's comments grouped by only by Inspection Model"
		li_TipHeight = 1300			
	Case 3
		st_Tip.Text = "A report of various graphs categorized by following criteria: Vessel Type, Flag, Company, Risk, Responsibility and Item Status."
		li_TipHeight = 300		
	Case 5
		st_Tip.Text = "The Inspection Summary is list with the following columns: Vessel Type/Name, Inspection Dates, Inspection Company, Port of Inspection, Type of Inspection, Date of Expiry and Inspection Rating.~n~nType 1: Grouped by Vessel Type and Vessel Name~n~nType 2: No grouping and sorted by Inspection date"
		li_TipHeight = 600
	Case 7
		st_Tip.Text = "A listing of all questions (grouped by Inspection Model, Chapter and Section) and the number of times the question is repeated.~n~nType 1: All questions~n~nType 2: All questions repeated more than once."
		li_TipHeight = 500		
	Case 11
		st_Tip.Text = "A list of inspections (only SIRE & MIRE by default) grouped by Vessel Type and Vessel. Total observations are displayed as well as number of observation by risk for Vessel and Overall. Consistent anomalies and high risk items in SIRE and MIRE are displayed."
		li_TipHeight = 400				
End Choose

st_TipHead.Height = li_TipHeight
st_Tip.Height = li_TipHeight - st_Tip.y + st_TipHead.y - 20
st_TipHead.Visible = True
st_Tip.Visible = True

ibool_TipVisible = True 
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
04w_rep.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14w_rep.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
