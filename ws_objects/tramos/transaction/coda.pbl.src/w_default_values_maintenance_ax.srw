$PBExportHeader$w_default_values_maintenance_ax.srw
forward
global type w_default_values_maintenance_ax from mt_w_response
end type
type cb_cancel from mt_u_commandbutton within w_default_values_maintenance_ax
end type
type cb_update from mt_u_commandbutton within w_default_values_maintenance_ax
end type
type dw_voyage from mt_u_datawindow within w_default_values_maintenance_ax
end type
type gb_1 from groupbox within w_default_values_maintenance_ax
end type
end forward

global type w_default_values_maintenance_ax from mt_w_response
integer width = 1239
integer height = 1136
string title = "AX Configurations"
boolean ib_setdefaultbackgroundcolor = true
cb_cancel cb_cancel
cb_update cb_update
dw_voyage dw_voyage
gb_1 gb_1
end type
global w_default_values_maintenance_ax w_default_values_maintenance_ax

type variables

end variables

on w_default_values_maintenance_ax.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_voyage=create dw_voyage
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.dw_voyage
this.Control[iCurrent+4]=this.gb_1
end on

on w_default_values_maintenance_ax.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_voyage)
destroy(this.gb_1)
end on

event open;call super::open;dw_voyage.settransobject(sqlca)
dw_voyage.retrieve()
end event

event closequery;call super::closequery;dw_voyage.accepttext()

if dw_voyage.deletedcount( ) + dw_voyage.modifiedcount( ) > 0 then
	if messagebox("Changes Made", "Changes have been made to the table.~n~nDo you want to close without saving changes?", Question!, YesNo!) = 2 then return 1
end if


end event

type cb_cancel from mt_u_commandbutton within w_default_values_maintenance_ax
integer x = 859
integer y = 928
integer taborder = 30
string text = "&Cancel"
end type

event clicked;call super::clicked;dw_voyage.retrieve()
end event

type cb_update from mt_u_commandbutton within w_default_values_maintenance_ax
integer x = 512
integer y = 928
integer taborder = 20
string text = "&Update"
end type

event clicked;call super::clicked;if dw_voyage.update() > 0 then 
	COMMIT;
	close(parent)
else
	messagebox("Update Error", "Could not save changes.", Exclamation!)
	ROLLBACK;
end if
end event

type dw_voyage from mt_u_datawindow within w_default_values_maintenance_ax
integer x = 37
integer y = 80
integer width = 1152
integer height = 800
integer taborder = 10
string dataobject = "d_sq_ff_ax_default_values"
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

type gb_1 from groupbox within w_default_values_maintenance_ax
integer x = 18
integer y = 16
integer width = 1189
integer height = 896
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "AX Categories for Voyage estimates"
end type

