$PBExportHeader$w_group_deductions.srw
$PBExportComments$Group deductions. Used with Laytime Statements
forward
global type w_group_deductions from mt_w_response
end type
type p_dot from picture within w_group_deductions
end type
type cb_delete from commandbutton within w_group_deductions
end type
type cb_new from commandbutton within w_group_deductions
end type
type cb_update from commandbutton within w_group_deductions
end type
type cb_cancel from commandbutton within w_group_deductions
end type
type dw_group_deductions from uo_datawindow within w_group_deductions
end type
end forward

global type w_group_deductions from mt_w_response
integer x = 32
integer y = 140
integer width = 1509
integer height = 984
string title = "Group deductions"
long backcolor = 81324524
event ue_retrieve pbm_custom01
event ue_update pbm_custom02
event ue_insert pbm_custom03
event ue_delete pbm_custom04
p_dot p_dot
cb_delete cb_delete
cb_new cb_new
cb_update cb_update
cb_cancel cb_cancel
dw_group_deductions dw_group_deductions
end type
global w_group_deductions w_group_deductions

type variables
s_group_deductions_parm  istr_parametre

end variables

forward prototypes
public subroutine documentation ()
end prototypes

on ue_retrieve;long ll_row
ll_row = dw_group_deductions.Retrieve(istr_parametre.vessel_nr, istr_parametre.voyage_nr, istr_parametre.chart_nr, istr_parametre.port_code, istr_parametre.pcn, istr_parametre.reason_nr)
COMMIT USING SQLCA;
if ll_row = 0 THEN
	cb_new.TriggerEvent(Clicked!)
END IF
end on

on ue_update;IF dw_group_deductions.Update() = 1 THEN
	COMMIT USING SQLCA;
ELSE
	ROLLBACK USING SQLCA;
END IF
end on

public subroutine documentation ();/********************************************************************
	w_group_deductions
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on open;istr_parametre = message.PowerObjectParm
dw_group_deductions.SetTransObject(SQLCA)
dw_group_deductions.SetRowFocusIndicator(p_dot,10,15)
PostEvent("ue_retrieve")

end on

on w_group_deductions.create
int iCurrent
call super::create
this.p_dot=create p_dot
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.dw_group_deductions=create dw_group_deductions
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_dot
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.dw_group_deductions
end on

on w_group_deductions.destroy
call super::destroy
destroy(this.p_dot)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.dw_group_deductions)
end on

event activate;m_tramosmain.mf_setcalclink(False)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_group_deductions
end type

type p_dot from picture within w_group_deductions
boolean visible = false
integer x = 18
integer y = 752
integer width = 41
integer height = 36
string picturename = "images\dot.bmp"
boolean focusrectangle = false
end type

type cb_delete from commandbutton within w_group_deductions
integer x = 768
integer y = 780
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

long ll_row
ll_row = dw_group_deductions.GetRow()
IF ll_row > 0 THEN
	dw_group_deductions.DeleteRow(ll_row)
END IF
end event

type cb_new from commandbutton within w_group_deductions
integer x = 37
integer y = 780
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
boolean default = true
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_group_deductions.InsertRow(0)
IF ll_row > 0 THEN
	dw_group_deductions.SetItem(ll_row,"vessel_nr",istr_parametre.vessel_nr)
	dw_group_deductions.SetItem(ll_row,"voyage_nr",istr_parametre.voyage_nr)
	dw_group_deductions.SetItem(ll_row,"chart_nr",istr_parametre.chart_nr)
	dw_group_deductions.SetItem(ll_row,"port_code",istr_parametre.port_code)
	dw_group_deductions.SetItem(ll_row,"pcn",istr_parametre.pcn)
	dw_group_deductions.SetItem(ll_row,"reason_nr",istr_parametre.reason_nr)
	dw_group_deductions.SetItem(ll_row,"group_pct",100)
	dw_group_deductions.SetFocus()
	dw_group_deductions.ScrollToRow(ll_row)
	dw_group_deductions.SetColumn("group_start")
END IF
end event

type cb_update from commandbutton within w_group_deductions
integer x = 402
integer y = 780
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;long ll_null

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

SetNull(ll_null)

dw_group_deductions.AcceptText()
IF dw_group_deductions.RowCount() > 0 THEN
	IF istr_parametre.modify THEN
		w_laytime.dw_lay_deductions.SetItem(istr_parametre.modify_rownr,"reason_start", dw_group_deductions.GetItemDateTime(1,"group_start"))
		w_laytime.dw_lay_deductions.SetItem(istr_parametre.modify_rownr,"reason_end", dw_group_deductions.GetItemDateTime(dw_group_deductions.RowCount(),"group_end"))
		w_laytime.dw_lay_deductions.SetItem(istr_parametre.modify_rownr,"deduction_pct",ll_null)
		w_laytime.dw_lay_deductions.SetItem(istr_parametre.modify_rownr,"deduction_minutes",dw_group_deductions.GetItemNumber(1,"total_minutes"))
		w_laytime.TriggerEvent("ue_update_modified")
	ELSE
		w_laytime.dw_new_deductions.SetItem(1,"reason_start", dw_group_deductions.GetItemDateTime(1,"group_start"))
		w_laytime.dw_new_deductions.SetItem(1,"reason_end", dw_group_deductions.GetItemDateTime(dw_group_deductions.RowCount(),"group_end"))
		w_laytime.dw_new_deductions.SetItem(1,"deduction_pct",ll_null)
		w_laytime.dw_new_deductions.SetItem(1,"deduction_minutes",dw_group_deductions.GetItemNumber(1,"total_minutes"))
		w_laytime.TriggerEvent("ue_update_new")
	END IF
	Parent.TriggerEvent("ue_update")
ELSE
	IF istr_parametre.modify THEN
		Parent.TriggerEvent("ue_update")
		w_laytime.dw_lay_deductions.DeleteRow(istr_parametre.modify_rownr)
		w_laytime.TriggerEvent("ue_update_modified")
	ELSE					
		Parent.TriggerEvent("ue_update")
		w_laytime.cb_cancel.TriggerEvent(Clicked!)
	END IF
END IF
Close(parent)
end event

type cb_cancel from commandbutton within w_group_deductions
integer x = 1134
integer y = 780
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

on clicked;Close(parent)
end on

type dw_group_deductions from uo_datawindow within w_group_deductions
integer x = 37
integer width = 1440
integer height = 752
integer taborder = 10
string dataobject = "dw_group_deductions"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

on itemchanged;call uo_datawindow::itemchanged;decimal {2} ld_pct
long ll_minutes
long ll_row
AcceptText()
ll_row = GetRow()
IF ll_row > 0 THEN
	ll_minutes = f_timedifference(GetItemDateTime(ll_row,"group_start"), GetItemDateTime(ll_row,"group_end"))
	ld_pct = GetItemNumber(ll_row,"group_pct")
	SetItem(ll_row,"group_minutes",Round(ll_minutes * ld_pct / 100,0))
END IF
end on

