$PBExportHeader$w_calc_vessel_detail.srw
$PBExportComments$Window for the vessel detail datawindow
forward
global type w_calc_vessel_detail from mt_w_response_calc
end type
type cb_ok from uo_cb_base within w_calc_vessel_detail
end type
type cb_cancel from commandbutton within w_calc_vessel_detail
end type
type cb_update from commandbutton within w_calc_vessel_detail
end type
type dw_1 from uo_datawindow within w_calc_vessel_detail
end type
end forward

global type w_calc_vessel_detail from mt_w_response_calc
integer x = 672
integer y = 264
integer width = 1189
integer height = 640
string title = "Vessel Detail"
long backcolor = 81324524
event ue_update pbm_custom01
event ue_retrieve pbm_custom01
cb_ok cb_ok
cb_cancel cb_cancel
cb_update cb_update
dw_1 dw_1
end type
global w_calc_vessel_detail w_calc_vessel_detail

type variables
s_list istr_parametre
end variables

forward prototypes
public subroutine documentation ()
end prototypes

on ue_update;dw_1.Accepttext()

IF dw_1.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
END IF
end on

on ue_retrieve;If Not (IsNull(istr_parametre.edit_key_text)) And (istr_parametre.edit_key_text<>"") Then
	dw_1.retrieve(istr_parametre.edit_key_text)
	COMMIT;
Elseif Not(IsNull(istr_parametre.edit_key_number)) And (istr_parametre.edit_key_number<>0) Then
	dw_1.retrieve(istr_parametre.edit_key_number) 
	COMMIT;
Else
	// New record
	dw_1.insertRow(0)
	Return
End if


end on

public subroutine documentation ();/********************************************************************
	w_calc_vessel_detail
	
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
     	08/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

event open;istr_parametre = Message.PowerObjectParm
//this.move(1,1)

f_center_window(this)

dw_1.DataObject = istr_parametre.edit_datawindow
dw_1.SetTransObject(sqlca)
this.title = istr_parametre.edit_window_title
If This.Title = "" Then This.Title = "Ship data"

PostEvent("ue_retrieve")

long antal_kolonner, max_bredde= 0, xx, xpos, bredde 
long max_hojde= 0, hojde, ypos
antal_kolonner = long(dw_1.describe("datawindow.column.count"))
for xx = 1 to antal_kolonner
	xpos = long(dw_1.describe("#"+string(xx)+".X"))
	bredde = long(dw_1.describe("#"+string(xx)+".width"))
	ypos = long(dw_1.describe("#"+string(xx)+".Y"))
	hojde = long(dw_1.describe("#"+string(xx)+".height"))
	if max_bredde < (xpos + bredde) then max_bredde = (xpos + bredde)
	if max_hojde < (ypos + hojde) then max_hojde = (ypos + hojde)
next

This.Width = max_bredde + 100 + dw_1.x
This.Height = max_hojde + 300
dw_1.Width = max_bredde + 50
dw_1.Height = max_hojde + 50

long xmove
xmove = cb_update.x
cb_update.move(xmove,max_hojde + 100)
xmove = cb_cancel.x
cb_cancel.move(xmove,max_hojde + 100)
xmove = cb_ok.x
cb_ok.move(xmove,max_hojde + 100)


cb_update.Hide()
cb_cancel.Hide()

f_center_window(this)

dw_1.Modify("DataWindow.ReadOnly = Yes")
end event

on w_calc_vessel_detail.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.dw_1
end on

on w_calc_vessel_detail.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_1)
end on

type cb_ok from uo_cb_base within w_calc_vessel_detail
integer x = 37
integer y = 400
integer width = 293
integer height = 80
integer taborder = 20
string text = "&Close"
end type

on clicked;call uo_cb_base::clicked;dw_1.Modify("DataWindow.ReadOnly = No")
Close(parent)
end on

type cb_cancel from commandbutton within w_calc_vessel_detail
integer x = 366
integer y = 400
integer width = 274
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "C&ancel"
boolean cancel = true
end type

on clicked;Close(parent)
end on

type cb_update from commandbutton within w_calc_vessel_detail
integer x = 37
integer y = 400
integer width = 293
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
boolean default = true
end type

on clicked;Parent.TriggerEvent("ue_update")
close(parent)
end on

type dw_1 from uo_datawindow within w_calc_vessel_detail
integer x = 18
integer y = 16
integer taborder = 10
string dataobject = "dw_agent"
borderstyle borderstyle = stylelowered!
end type

