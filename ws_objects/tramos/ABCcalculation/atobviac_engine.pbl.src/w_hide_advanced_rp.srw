$PBExportHeader$w_hide_advanced_rp.srw
$PBExportComments$This sheet is to maintain if Advanced Routing Point shall be shown or not.
forward
global type w_hide_advanced_rp from w_sheet
end type
type cb_update from commandbutton within w_hide_advanced_rp
end type
type cb_close from commandbutton within w_hide_advanced_rp
end type
type dw_advanced_rp from u_dw within w_hide_advanced_rp
end type
end forward

global type w_hide_advanced_rp from w_sheet
integer x = 214
integer y = 221
integer width = 1879
integer height = 2504
string title = "Hide Advanced Routing Points"
boolean maxbox = false
boolean resizable = false
boolean center = true
cb_update cb_update
cb_close cb_close
dw_advanced_rp dw_advanced_rp
end type
global w_hide_advanced_rp w_hide_advanced_rp

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Description	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14		CR3781	CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_hide_advanced_rp.create
int iCurrent
call super::create
this.cb_update=create cb_update
this.cb_close=create cb_close
this.dw_advanced_rp=create dw_advanced_rp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_update
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_advanced_rp
end on

on w_hide_advanced_rp.destroy
call super::destroy
destroy(this.cb_update)
destroy(this.cb_close)
destroy(this.dw_advanced_rp)
end on

event open;call super::open;n_service_manager lnv_serviceMgr
n_dw_style_service lnv_style

//  Set the Transaction Object for all the dws 
dw_advanced_rp.of_SetTransObject(sqlca)

//  Call the retrieve on the top-level datawindow.  This 
//  will retrieve all the datawindows in the linked chain 
dw_advanced_rp.of_Retrieve()

//Set-up user access
Choose case uo_global.ii_access_level
	Case 2, 3 // Supervisor, // Administration
		cb_update.enabled = TRUE
		dw_advanced_rp.Object.DataWindow.ReadOnly="No"
	Case 1 // User
		cb_update.enabled = FALSE
		dw_advanced_rp.Object.DataWindow.ReadOnly="Yes"
End choose

lnv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_advanced_rp,false)

end event

type cb_update from commandbutton within w_hide_advanced_rp
integer x = 1129
integer y = 2300
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;parent.event pfc_save()
end event

type cb_close from commandbutton within w_hide_advanced_rp
integer x = 1481
integer y = 2300
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
end type

event clicked;close(parent)
end event

type dw_advanced_rp from u_dw within w_hide_advanced_rp
integer x = 46
integer y = 32
integer width = 1774
integer height = 2244
integer taborder = 10
string dataobject = "d_sq_hide_advanced_routing_point"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event pfc_retrieve;call super::pfc_retrieve;return this.retrieve()
end event

