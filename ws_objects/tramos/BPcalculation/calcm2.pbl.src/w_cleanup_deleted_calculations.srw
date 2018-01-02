$PBExportHeader$w_cleanup_deleted_calculations.srw
$PBExportComments$This function gives the administrator the ability to "physically" delete calculations from the tables.
forward
global type w_cleanup_deleted_calculations from mt_w_response_calc
end type
type hpb_1 from hprogressbar within w_cleanup_deleted_calculations
end type
type st_1 from statictext within w_cleanup_deleted_calculations
end type
type cb_close from commandbutton within w_cleanup_deleted_calculations
end type
type cb_delete from commandbutton within w_cleanup_deleted_calculations
end type
type cb_retrieve from commandbutton within w_cleanup_deleted_calculations
end type
type dw_delete from datawindow within w_cleanup_deleted_calculations
end type
end forward

global type w_cleanup_deleted_calculations from mt_w_response_calc
integer width = 2766
integer height = 2704
string title = "Delete Calculations Marked as Deleted"
string icon = "AppIcon!"
hpb_1 hpb_1
st_1 st_1
cb_close cb_close
cb_delete cb_delete
cb_retrieve cb_retrieve
dw_delete dw_delete
end type
global w_cleanup_deleted_calculations w_cleanup_deleted_calculations

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_cleanup_deleted_calculations
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

event open;dw_delete.setTransobject( sqlca )
end event

on w_cleanup_deleted_calculations.create
int iCurrent
call super::create
this.hpb_1=create hpb_1
this.st_1=create st_1
this.cb_close=create cb_close
this.cb_delete=create cb_delete
this.cb_retrieve=create cb_retrieve
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_retrieve
this.Control[iCurrent+6]=this.dw_delete
end on

on w_cleanup_deleted_calculations.destroy
call super::destroy
destroy(this.hpb_1)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.cb_delete)
destroy(this.cb_retrieve)
destroy(this.dw_delete)
end on

type hpb_1 from hprogressbar within w_cleanup_deleted_calculations
integer x = 969
integer y = 2476
integer width = 1303
integer height = 68
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type st_1 from statictext within w_cleanup_deleted_calculations
integer x = 96
integer y = 40
integer width = 2057
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "This function will allow an Administrator to ~"physically~" delete all calculations marked as deleted. Calculations marked as deleted can not be seen by the users."
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_cleanup_deleted_calculations
integer x = 2391
integer y = 2460
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_delete from commandbutton within w_cleanup_deleted_calculations
integer x = 517
integer y = 2460
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

event clicked;long 	ll_rows, ll_row, ll_calc_id

if MessageBox("Confirm Delete", "Are You sure that You will delete the Calculations?", Question!, YesNo!, 2) = 2 then return

ll_rows = dw_delete.rowCount()
hpb_1.maxposition = ll_rows

for ll_row = 1 to ll_rows
	hpb_1.position = ll_row
	ll_calc_id = dw_delete.getItemNumber(1, "cal_calc_cal_calc_id")
	if isNull(ll_calc_id) then 
		return
	end if
	if f_cleanup_calculation(ll_calc_id) = false then 
		MessageBox("Delete Failed", "System failed to delete calculation.")
		return
	end if
	dw_delete.DeleteRow(1)
next

end event

type cb_retrieve from commandbutton within w_cleanup_deleted_calculations
integer x = 23
integer y = 2460
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
boolean default = true
end type

event clicked;if dw_delete.retrieve() > 0 then
	cb_delete.POST setFocus()
end if
	
end event

type dw_delete from datawindow within w_cleanup_deleted_calculations
integer x = 23
integer y = 216
integer width = 2711
integer height = 2176
integer taborder = 10
string title = "none"
string dataobject = "d_cleanup_deleted_calculations"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

