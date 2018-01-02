$PBExportHeader$w_bunker.srw
forward
global type w_bunker from w_events_pcgroup
end type
type cb_save from mt_u_commandbutton within w_bunker
end type
type cb_delete from mt_u_commandbutton within w_bunker
end type
type cb_new from mt_u_commandbutton within w_bunker
end type
type dw_bunker from datawindow within w_bunker
end type
type uo_pcgroup from u_pcgroup within w_bunker
end type
end forward

global type w_bunker from w_events_pcgroup
integer width = 1326
integer height = 1200
string title = "Bunker Prices"
cb_save cb_save
cb_delete cb_delete
cb_new cb_new
dw_bunker dw_bunker
uo_pcgroup uo_pcgroup
end type
global w_bunker w_bunker

type variables
integer ii_pcgroup
end variables

on w_bunker.create
int iCurrent
call super::create
this.cb_save=create cb_save
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_bunker=create dw_bunker
this.uo_pcgroup=create uo_pcgroup
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_save
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.dw_bunker
this.Control[iCurrent+5]=this.uo_pcgroup
end on

on w_bunker.destroy
call super::destroy
destroy(this.cb_save)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_bunker)
destroy(this.uo_pcgroup)
end on

event open;ii_pcgroup=uo_pcgroup.uf_getpcgroup( )

if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else

	dw_bunker.settransobject(SQLCA)
	dw_bunker.retrieve(ii_pcgroup)
		
	if SQLCA.sqlcode=-1 then
		messagebox("Error",SQLCA.sqlerrtext)
		return -1
	end if
	
	
		if  dw_bunker.rowcount( ) > 0 then
			cb_save.enabled = true
			cb_delete.enabled = true
		else 
			cb_save.enabled = false
			cb_delete.enabled = false
		end if
		
end if
end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;datawindowchild	ldwc

ii_pcgroup=ai_pcgroupid

dw_bunker.settransobject(SQLCA)
dw_bunker.retrieve(ii_pcgroup)
		
	if SQLCA.sqlcode=-1 then
		messagebox("Error",SQLCA.sqlerrtext)
		cb_save.enabled = false
	cb_delete.enabled = false
else
	if  dw_bunker.rowcount( ) > 0 then
	cb_save.enabled = true
	cb_delete.enabled = true
else 
	cb_save.enabled = false
	cb_delete.enabled = false
end if
end if
return 0
end event

type cb_save from mt_u_commandbutton within w_bunker
integer x = 562
integer y = 968
integer height = 96
integer taborder = 30
string facename = "Arial"
boolean enabled = false
string text = "&Save"
end type

event clicked;if  dw_bunker.rowcount( ) <> 0 then
	dw_bunker.acceptText()
	if dw_bunker.update() = 1 then
		cb_delete.enabled = true
		commit;
	else
		MessageBox("Update Error", "Error updating bunker.")
		rollback;
		return -1
	end if
end if
end event

type cb_delete from mt_u_commandbutton within w_bunker
integer x = 905
integer y = 964
integer taborder = 40
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long	ll_row

ll_row = dw_bunker.getRow()
if ll_row < 1 then return

if MessageBox("Confirmation", "Are you sure you you want to delete the bunker?", question!, YesNo!,2) = 1 then 
	if dw_bunker.deleterow(ll_row) = 1 then
		dw_bunker.update( )
		commit;	
		dw_bunker.retrieve(ii_pcgroup)
		return 1
	else
		MessageBox("Delete Error", "Error deleting bunker.")
		return -1
	end if
end if

end event

type cb_new from mt_u_commandbutton within w_bunker
integer x = 215
integer y = 972
integer height = 92
integer taborder = 20
string facename = "Arial"
string text = "&New"
end type

event clicked;int			li_row

li_row = dw_bunker.insertrow( 0)

dw_bunker.setitem( li_row,"pcgroup_id",ii_pcgroup)
dw_bunker.setitem( 1,"bunkerdate",today())

dw_bunker.setfocus( )
dw_bunker.scrolltorow(li_row)

cb_save.enabled = true



end event

type dw_bunker from datawindow within w_bunker
integer x = 41
integer y = 196
integer width = 1202
integer height = 752
integer taborder = 10
string title = "none"
string dataobject = "d_bunker_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)	
end if
end event

event clicked;if row > 0 then
	post event rowfocuschanged( row )
end if
end event

event dberror;long ll_errCode

if sqldbcode=547 then  // dependent foreign key error
	messagebox("Error","The bunker place is referenced in Trades.~r~nPlease remove all these references before deleting this record")
	return 1
end if

end event

type uo_pcgroup from u_pcgroup within w_bunker
event destroy ( )
integer x = 41
integer y = 4
integer width = 887
integer taborder = 30
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

