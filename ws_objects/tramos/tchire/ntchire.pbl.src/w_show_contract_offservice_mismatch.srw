$PBExportHeader$w_show_contract_offservice_mismatch.srw
$PBExportComments$Shows off-services not inside contract periode, if periode is changed. Used in validation of TC Contract
forward
global type w_show_contract_offservice_mismatch from mt_w_response
end type
type cb_ok from commandbutton within w_show_contract_offservice_mismatch
end type
type st_1 from statictext within w_show_contract_offservice_mismatch
end type
type dw_1 from u_ntchire_dw within w_show_contract_offservice_mismatch
end type
end forward

global type w_show_contract_offservice_mismatch from mt_w_response
integer width = 1033
integer height = 924
string title = "Off-Hire Mismatch"
cb_ok cb_ok
st_1 st_1
dw_1 dw_1
end type
global w_show_contract_offservice_mismatch w_show_contract_offservice_mismatch

type variables
datastore 	ids_data

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_show_contract_offservice_mismatch
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
		Date			CR-Ref		Author 		Comments
     	11/08/2014	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

event open;n_service_manager inv_servicemgr
n_dw_style_service   lnv_style

ids_data = CREATE datastore
ids_data = message.powerobjectparm

ids_data.sharedata(dw_1)
inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_1, false)

f_center_window(this)
end event

on w_show_contract_offservice_mismatch.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_show_contract_offservice_mismatch.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.dw_1)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_show_contract_offservice_mismatch
end type

type cb_ok from commandbutton within w_show_contract_offservice_mismatch
integer x = 654
integer y = 732
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;close(parent)
end event

type st_1 from statictext within w_show_contract_offservice_mismatch
integer x = 37
integer y = 32
integer width = 955
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Off-Hire period(s) listed below in red do not match any TC contract periods. Please correct and try again."
boolean focusrectangle = false
end type

type dw_1 from u_ntchire_dw within w_show_contract_offservice_mismatch
integer x = 37
integer y = 224
integer width = 942
integer height = 500
integer taborder = 10
string dataobject = "d_list_unsettled_offservice"
boolean border = false
borderstyle borderstyle = stylebox!
end type

