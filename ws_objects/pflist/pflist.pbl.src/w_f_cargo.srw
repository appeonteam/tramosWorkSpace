$PBExportHeader$w_f_cargo.srw
forward
global type w_f_cargo from w_events_pcgroup
end type
type uo_pcgroup from u_pcgroup within w_f_cargo
end type
type cb_close from mt_u_commandbutton within w_f_cargo
end type
type cb_new from mt_u_commandbutton within w_f_cargo
end type
type cb_delete from mt_u_commandbutton within w_f_cargo
end type
type cb_edit from mt_u_commandbutton within w_f_cargo
end type
type dw_cargo from datawindow within w_f_cargo
end type
end forward

global type w_f_cargo from w_events_pcgroup
integer width = 1897
integer height = 1576
string title = "Cargo Types"
uo_pcgroup uo_pcgroup
cb_close cb_close
cb_new cb_new
cb_delete cb_delete
cb_edit cb_edit
dw_cargo dw_cargo
end type
global w_f_cargo w_f_cargo

type variables
integer ii_pcgroup
boolean ib_existCargoTypes
end variables

on w_f_cargo.create
int iCurrent
call super::create
this.uo_pcgroup=create uo_pcgroup
this.cb_close=create cb_close
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_edit=create cb_edit
this.dw_cargo=create dw_cargo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pcgroup
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_edit
this.Control[iCurrent+6]=this.dw_cargo
end on

on w_f_cargo.destroy
call super::destroy
destroy(this.uo_pcgroup)
destroy(this.cb_close)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_edit)
destroy(this.dw_cargo)
end on

event open;datawindowchild	ldwc


ii_pcgroup=uo_pcgroup.uf_getpcgroup( )

if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else
	dw_cargo.settransobject(SQLCA)
	dw_cargo.getchild("cleaningtypeid", ldwc)
	ldwc.SetTransObject(SQLCA)
	if ldwc.retrieve(ii_pcgroup) > 0 then
		dw_cargo.retrieve(ii_pcgroup)	
	else
		return
	end if
	if SQLCA.SQLcode = 0 and dw_cargo.rowcount( ) > 1 then
		cb_edit.enabled = true
		cb_delete.enabled = true
	else 
		cb_edit.enabled = false
		cb_delete.enabled = false
	end if
end if


end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;datawindowchild	ldwc

ii_pcgroup=ai_pcgroupid
dw_cargo.reset( )
if  ii_pcgroup < 0 then
	Messagebox("test","Error geting the PC Group ")
else
	dw_cargo.settransobject(SQLCA)
	dw_cargo.getchild("cleaningtypeid", ldwc)
	ldwc.reset( )
	ldwc.SetTransObject(SQLCA)
	if ldwc.retrieve(ii_pcgroup) > 0 then
		dw_cargo.retrieve(ii_pcgroup)	
		ib_existCargoTypes = true 
	else
		ib_existCargoTypes = false
		return 0
	end if
	if SQLCA.SQLcode = 0 and dw_cargo.rowcount( ) > 1 then
		cb_edit.enabled = true
		cb_delete.enabled = true
	else 
		cb_edit.enabled = false
		cb_delete.enabled = false
	end if
end if
return 0
end event

type uo_pcgroup from u_pcgroup within w_f_cargo
integer x = 37
integer y = 36
integer taborder = 20
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cb_close from mt_u_commandbutton within w_f_cargo
integer x = 1477
integer y = 1348
integer taborder = 50
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_new from mt_u_commandbutton within w_f_cargo
integer x = 448
integer y = 1348
integer taborder = 30
string facename = "Arial"
string text = "&New"
end type

event clicked;call super::clicked;int			li_row

cb_edit.enabled = true

if ib_existCargoTypes = false then
	MessageBox("Warning","Cargo Grades list is empty. (Menu Go - Fixture List - Admin - Cargo Grades)")
	return
end if

li_row = dw_cargo.insertrow( 0)

dw_cargo.setitem( li_row,"pcgroup_id",ii_pcgroup)
dw_cargo.setitem( li_row,"cpp",0)

dw_cargo.setfocus( )
dw_cargo.scrolltorow(li_row)
end event

type cb_delete from mt_u_commandbutton within w_f_cargo
integer x = 1134
integer y = 1348
integer taborder = 40
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long	ll_row

ll_row = dw_cargo.getRow()
if ll_row < 1 then return

if MessageBox("Confirmation", "Are you sure you want to delete the cargo?", question!, YesNo!,2) = 1 then 
	if dw_cargo.deleterow(ll_row) = 1 then
		if dw_cargo.update( ) = 1 then
			commit;
		else
			rollback;
		end if
		return 1
	else
		rollback;
		MessageBox("Delete Error", "Error deleting cargo.")
		return -1
	end if

end if

end event

type cb_edit from mt_u_commandbutton within w_f_cargo
integer x = 791
integer y = 1348
integer taborder = 30
string facename = "Arial"
boolean enabled = false
string text = "&Save All"
end type

event clicked;call super::clicked;int			li_x
if  dw_cargo.rowcount( ) <> 0 then
	dw_cargo.acceptText()
	for li_x = 1 to dw_cargo.rowcount( )
		if isnull(dw_cargo.getitemstring( li_x,"pf_fixture_cargo_name")) or dw_cargo.getitemstring( li_x,"pf_fixture_cargo_name") = "" then
			MessageBox("Info", "The cargo name can not be empty, please fill out the cargo name.")
			dw_cargo.setfocus( )
			dw_cargo.scrolltorow(li_x)
			return -1
		end if
	next
	if dw_cargo.update() = 1 then
		commit;
		dw_cargo.retrieve(ii_pcgroup)
	else
		rollback;
		MessageBox("Update Error", "Error updating cargo.")
		return -1
	end if
end if
end event

type dw_cargo from datawindow within w_f_cargo
integer x = 37
integer y = 236
integer width = 1783
integer height = 1084
integer taborder = 10
string title = "none"
string dataobject = "d_f_cargo"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	post event rowfocuschanged( row )
end if
end event

event rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)	
end if
end event

