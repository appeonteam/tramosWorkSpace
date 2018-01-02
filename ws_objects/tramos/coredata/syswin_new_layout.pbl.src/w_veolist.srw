$PBExportHeader$w_veolist.srw
forward
global type w_veolist from mt_w_response
end type
type dw_veolist from u_datagrid within w_veolist
end type
type cb_delete from mt_u_commandbutton within w_veolist
end type
type cb_update from mt_u_commandbutton within w_veolist
end type
type cb_new from mt_u_commandbutton within w_veolist
end type
end forward

global type w_veolist from mt_w_response
integer width = 1207
integer height = 1396
string title = "VEOs List"
boolean ib_setdefaultbackgroundcolor = true
dw_veolist dw_veolist
cb_delete cb_delete
cb_update cb_update
cb_new cb_new
end type
global w_veolist w_veolist

type variables
long il_vessel_nr
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_veolist	
  	<OBJECT>	Vessel's VEO list	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date				CR-Ref		Author		Comments
		20/12/2013		CR3240		XSZ004		First Version
		21/02/2014		CR3240UAT	LHG008		Show only active Operator, user
   </HISTORY>
********************************************************************/
end subroutine

on w_veolist.create
int iCurrent
call super::create
this.dw_veolist=create dw_veolist
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_new=create cb_new
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_veolist
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.cb_new
end on

on w_veolist.destroy
call super::destroy
destroy(this.dw_veolist)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_new)
end on

event open;call super::open;n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style
datawindowchild		ldwc_child

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_veolist)

il_vessel_nr = message.doubleparm

dw_veolist.of_registerdddw("vessel_veos_userid", "user_profile = 2 and user_group <> 2 and user_group > 0 and deleted <> 1")

dw_veolist.retrieve(il_vessel_nr)

end event

event closequery;call super::closequery;if dw_veolist.modifiedcount() + dw_veolist.deletedcount() > 0 then
	if messagebox("Change Request Updates Pending", "Data has been changed, but not saved. ~n~nWould you like to save data?", Question!, YesNo!, 1) = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if
end event

type dw_veolist from u_datagrid within w_veolist
integer x = 18
integer y = 32
integer width = 1152
integer height = 1136
integer taborder = 10
string dataobject = "d_sq_tb_veolist"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemerror;call super::itemerror;return 1
end event

type cb_delete from mt_u_commandbutton within w_veolist
integer x = 827
integer y = 1200
integer taborder = 30
string text = "&Delete"
end type

event clicked;call super::clicked;int li_row

li_row = dw_veolist.getrow()

if li_row < 1 then return
dw_veolist.deleterow(li_row)
end event

type cb_update from mt_u_commandbutton within w_veolist
integer x = 475
integer y = 1200
integer taborder = 20
string text = "&Update"
end type

event clicked;call super::clicked;n_service_manager          lnv_svcmgr
n_dw_validation_service    lnv_rules

if dw_veolist.accepttext() = -1 then return 

lnv_svcmgr.of_loadservice(lnv_rules, "n_dw_validation_service")
lnv_rules.of_registerrulestring("vessel_veos_userid", false, "VEO", true)

if lnv_rules.of_validate(dw_veolist, true) = c#return.Failure then return

if dw_veolist.modifiedcount() + dw_veolist.deletedcount() > 0 then 
	if dw_veolist.update() = 1 then
		COMMIT;
	else
		ROLLBACK;
		messagebox("Update Error", "Update failure.")	
	end if
end if

dw_veolist.retrieve(il_vessel_nr)

end event

type cb_new from mt_u_commandbutton within w_veolist
integer x = 123
integer y = 1200
integer taborder = 10
string text = "&New"
end type

event clicked;call super::clicked;int li_insertrow

li_insertrow = dw_veolist.insertrow(0)

dw_veolist.scrolltorow(li_insertrow)
dw_veolist.setrow(li_insertrow)

dw_veolist.setitem(li_insertrow, "vessel_veos_vessel_nr", il_vessel_nr)
//Set status for insert row to be not modified 
dw_veolist.setitemstatus(li_insertrow, 0, primary!, notmodified!)

dw_veolist.setfocus( )


end event

