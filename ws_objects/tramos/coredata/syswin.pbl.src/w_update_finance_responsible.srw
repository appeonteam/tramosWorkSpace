$PBExportHeader$w_update_finance_responsible.srw
forward
global type w_update_finance_responsible from mt_w_sheet
end type
type st_type from statictext within w_update_finance_responsible
end type
type ddlb_type from dropdownlistbox within w_update_finance_responsible
end type
type dw_userlist from datawindow within w_update_finance_responsible
end type
type cb_update from commandbutton within w_update_finance_responsible
end type
type st_bk from u_topbar_background within w_update_finance_responsible
end type
type uo_finance_resp from u_drag_drop_boxes_finance_responsible within w_update_finance_responsible
end type
end forward

global type w_update_finance_responsible from mt_w_sheet
integer width = 4594
integer height = 2300
string title = "Update Responsible by Vessel and Charterer"
long backcolor = 80269524
boolean ib_setdefaultbackgroundcolor = true
st_type st_type
ddlb_type ddlb_type
dw_userlist dw_userlist
cb_update cb_update
st_bk st_bk
uo_finance_resp uo_finance_resp
end type
global w_update_finance_responsible w_update_finance_responsible

type variables
string is_userid
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();
/******************************************************************************
     	Date   		Ref    	Author   		Comments
  		00/00/07 	??? 		RMO      		First Version
		02/08/11  	CR2411	ZSW001			UI Adjust 
*******************************************************************************/


end subroutine

event open;call super::open;dw_userlist.settransobject(SQLCA)
if dw_userlist.retrieve(3) > 0 then
	dw_userlist.selectrow(0, false)
	dw_userlist.selectrow(1, true)
end if

end event

on w_update_finance_responsible.create
int iCurrent
call super::create
this.st_type=create st_type
this.ddlb_type=create ddlb_type
this.dw_userlist=create dw_userlist
this.cb_update=create cb_update
this.st_bk=create st_bk
this.uo_finance_resp=create uo_finance_resp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_type
this.Control[iCurrent+2]=this.ddlb_type
this.Control[iCurrent+3]=this.dw_userlist
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.st_bk
this.Control[iCurrent+6]=this.uo_finance_resp
end on

on w_update_finance_responsible.destroy
call super::destroy
destroy(this.st_type)
destroy(this.ddlb_type)
destroy(this.dw_userlist)
destroy(this.cb_update)
destroy(this.st_bk)
destroy(this.uo_finance_resp)
end on

event closequery;if uo_finance_resp.dw_right.modifiedCount() > 0 or &
	uo_finance_resp.dw_right.deletedCount() > 0 then
	if MessageBox("Closing window", "Data modified but not saved. Are you sure you want to close?", Question!, YesNo!) = 2 then
		RETURN 1
	else
		RETURN 0
	end if
end if

end event

type st_type from statictext within w_update_finance_responsible
integer x = 37
integer y = 76
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Select the type"
boolean focusrectangle = false
end type

type ddlb_type from dropdownlistbox within w_update_finance_responsible
integer x = 402
integer y = 64
integer width = 987
integer height = 1000
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean sorted = false
boolean vscrollbar = true
string item[] = {"Vessel Finance Responsible","Vessel Responsible Operator","Vessel Demurrage Analyst","Charterer Demurrage Analyst"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;string	ls_leftdw, ls_rightdw
integer	li_arg

n_service_manager		inv_servicemgr
n_dw_style_service	lnv_style

choose case index
	case 1			//Vessel Finance Responsible
		li_arg = 3	//Finance
		
		ls_leftdw  = "d_update_finance_responsible"
		ls_rightdw = "d_update_finance_responsible"
	case 2			//Vessel Responsible Operator
		li_arg = 2	//Operator
		
		ls_leftdw  = "d_update_operator"
		ls_rightdw = "d_update_operator"
	case 3			//Vessel Demurrage Analyst
		li_arg = 3	//Finance
		
		ls_leftdw  = "d_update_dem_analyst"
		ls_rightdw = "d_update_dem_analyst"
	case 4			//Charterer Demurrage Analyst
		li_arg = 3	//Finance
		
		ls_leftdw  = "d_sq_gr_update_chart_dem_analyst"
		ls_rightdw = "d_sq_gr_update_chart_dem_analyst"
end choose

parent.setredraw(false)

uo_finance_resp.uf_setleft_datawindow(ls_leftdw)
uo_finance_resp.uf_setright_datawindow(ls_rightdw)
if index = 4 then //charterer
	uo_finance_resp.uf_set_frame_label("Select Charterer(s)")
else              //Vessel
	uo_finance_resp.uf_set_frame_label("Select Vessel(s)")
end if

inv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(uo_finance_resp.dw_left, false)
lnv_style.of_dwlistformater(uo_finance_resp.dw_right, false)

uo_finance_resp.dw_left.retrieve(uo_global.is_userid)
if dw_userlist.retrieve(li_arg) > 0 then
	dw_userlist.selectrow(0, false)
	dw_userlist.selectrow(1, true)
end if

parent.setredraw(true)

end event

type dw_userlist from datawindow within w_update_finance_responsible
integer x = 3758
integer y = 300
integer width = 763
integer height = 1752
integer taborder = 20
string title = "none"
string dataobject = "d_finance_responsible_userlist"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row > 0 then
	this.selectRow(0, false)
	this.selectRow(row, true)
end if
end event

event constructor;n_service_manager		inv_servicemgr
n_dw_style_service	lnv_style

inv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_userlist, false)

end event

type cb_update from commandbutton within w_update_finance_responsible
integer x = 4178
integer y = 2068
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;long 		ll_rows, ll_row, ll_userrow
string	ls_type, ls_userid, ls_demfrom
integer  li_retCode

//CR2411 Begin added by ZSW001 on 05/08/2011
ls_type = ddlb_type.text
ls_demfrom = lower(left(ls_type, pos(ls_type, " ") - 1)) + "s"
//CR2411 End added by ZSW001 on 05/08/2011

/* Check om der er valgt skibe for update */
ll_rows = uo_finance_resp.dw_right.rowCount()
if ll_rows < 1 then
	MessageBox("Selection missing", "Please select one or more " + ls_demfrom + " for update")
	return
end if
	
/* Check if user selected */
ll_userrow = dw_userlist.getSelectedRow(0)
if ll_userrow < 1 then
	MessageBox("Selection missing", "Please select a user for update")
	return
end if

li_retCode = MessageBox("Update ?","Are you sure you want to~n~r" +&
									"update the selected " + ls_demfrom + " with~n~r~n~r" +&
									ls_type + " = "+dw_userlist.getItemString(ll_userrow,"name") + " ?", Question!, YesNo!)

if li_retCode <> 1 then return

ls_userid = dw_userlist.getItemString(ll_userrow, "userid")
for ll_row = 1 to ll_rows
	uo_finance_resp.dw_right.setItemStatus(ll_row, 0, primary!, dataModified!)
	uo_finance_resp.dw_right.setItem(ll_row, "userid", ls_userid)
next

if uo_finance_resp.dw_right.Update() = 1 then
	COMMIT;
	uo_finance_resp.dw_right.Reset()
	uo_finance_resp.dw_left.Retrieve( uo_global.is_userid )
else 
	ROLLBACK;
	MessageBox("Error","Update error. No update made !")
end if

end event

type st_bk from u_topbar_background within w_update_finance_responsible
integer height = 208
end type

type uo_finance_resp from u_drag_drop_boxes_finance_responsible within w_update_finance_responsible
event destroy ( )
integer x = 37
integer y = 236
integer width = 3698
integer height = 1836
integer taborder = 10
end type

on uo_finance_resp.destroy
call u_drag_drop_boxes_finance_responsible::destroy
end on

event constructor;call super::constructor;n_service_manager		inv_servicemgr
n_dw_style_service	lnv_style

this.uf_setleft_datawindow("d_update_finance_responsible")
this.uf_setright_datawindow("d_update_finance_responsible")
this.uf_set_frame_label("Select Vessel(s)")

inv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(uo_finance_resp.dw_left, false)
lnv_style.of_dwlistformater(uo_finance_resp.dw_right, false)

ddlb_type.SelectItem(1)

end event

event ue_retrieve;call super::ue_retrieve;dw_left.retrieve( uo_global.is_userid )
end event

