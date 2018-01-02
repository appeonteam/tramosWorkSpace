$PBExportHeader$w_f_status.srw
forward
global type w_f_status from w_events_pcgroup
end type
type uo_pcgroup from u_pcgroup within w_f_status
end type
type cb_edit from mt_u_commandbutton within w_f_status
end type
type cb_delete from mt_u_commandbutton within w_f_status
end type
type cb_new from mt_u_commandbutton within w_f_status
end type
type cb_close from mt_u_commandbutton within w_f_status
end type
type dw_status from datawindow within w_f_status
end type
end forward

global type w_f_status from w_events_pcgroup
integer width = 1870
integer height = 1492
string title = "Fixture Status"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
uo_pcgroup uo_pcgroup
cb_edit cb_edit
cb_delete cb_delete
cb_new cb_new
cb_close cb_close
dw_status dw_status
end type
global w_f_status w_f_status

type variables
integer ii_pcgroup
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_f_status
	
   <OBJECT></OBJECT>
   <DESC></DESC>
   <USAGE>
	
   </USAGE>
   <ALSO></ALSO>
    	Date   	Ref		Author		Comments
  	00/00/07	?      		Name Here	First Version
  	02/03/16	 CR4561		KSH092	   Change the access rights for this window so only 
	  											Advanced_Users should be allowed to modify/update the window
	
********************************************************************/
end subroutine

on w_f_status.create
int iCurrent
call super::create
this.uo_pcgroup=create uo_pcgroup
this.cb_edit=create cb_edit
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_close=create cb_close
this.dw_status=create dw_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pcgroup
this.Control[iCurrent+2]=this.cb_edit
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_new
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.dw_status
end on

on w_f_status.destroy
call super::destroy
destroy(this.uo_pcgroup)
destroy(this.cb_edit)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.dw_status)
end on

event open;
ii_pcgroup=uo_pcgroup.uf_getpcgroup( )
if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else
	dw_status.settransobject(SQLCA)
	dw_status.retrieve(ii_pcgroup)
	if uo_global.ii_access_level <> C#usergroup.#SUPERUSER then
		dw_status.modify("Datawindow.ReadOnly = 'Yes'")
		cb_edit.enabled = false
	end if
	
end if
end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;ii_pcgroup=ai_pcgroupid

dw_status.settransobject(SQLCA)
dw_status.retrieve(ii_pcgroup)

if SQLCA.SQLcode = 0 and dw_status.rowcount( ) > 0 then
	//cb_save.enabled = true
	//cb_delete.enabled = true
//else 
//	cb_save.enabled = false
//	cb_delete.enabled = false
end if



return 0
end event

type st_hidemenubar from w_events_pcgroup`st_hidemenubar within w_f_status
end type

type uo_pcgroup from u_pcgroup within w_f_status
integer x = 23
integer y = 20
integer taborder = 20
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cb_edit from mt_u_commandbutton within w_f_status
integer x = 1143
integer y = 1288
integer taborder = 50
string facename = "Arial"
string text = "&Save All"
end type

event clicked;call super::clicked;int			li_x
long ll_days, ll_statusid
integer li_fixturelist, li_cargolist
boolean lb_flagnew
lb_flagnew=false

if  dw_status.rowcount( ) <> 0 then
	dw_status.acceptText()
	for li_x = 1 to dw_status.rowcount( )
		if isnull(dw_status.getitemstring( li_x,"name")) or dw_status.getitemstring( li_x,"name") = "" then
			MessageBox("Info", "The status name can not be empty, please fill out the status name.")
			dw_status.setfocus( )
			dw_status.scrolltorow(li_x)
			return -1
		elseif isnull(dw_status.getitemnumber( li_x,"pf_fixture_status_config_id")) then
			//add row
			ll_statusid = dw_status.getitemnumber( li_x,"pf_fixture_status_statusid")
			li_fixturelist = dw_status.getitemnumber( li_x,"fixturelist")
			li_cargolist = dw_status.getitemnumber( li_x,"cargolist")
			ll_days = dw_status.getitemnumber( li_x,"daysonlist")
	
			INSERT INTO PF_FIXTURE_STATUS_CONFIG (STATUSID, FIXTURELIST, CARGOLIST, DAYSONLIST, PCGROUP_ID) 
			VALUES(  :ll_statusid  , :li_fixturelist, :li_cargolist, :ll_days, :ii_pcgroup
			)
			commit using SQLCA;
			lb_flagnew =true
		end if
	next

if lb_flagnew = true then
	dw_status.retrieve(ii_pcgroup)
	return
end if

	if dw_status.update() = 1 then
		commit;
		dw_status.retrieve(ii_pcgroup)
	else
		rollback;
		MessageBox("Update Error", "Error updating status.")
		return -1
	end if
end if
end event

type cb_delete from mt_u_commandbutton within w_f_status
boolean visible = false
integer x = 105
integer y = 1288
integer taborder = 60
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long	ll_row, ll_trade_id

ll_row = dw_status.getRow()
if ll_row < 1 then return

if MessageBox("Confirmation", "Are you sure you want to delete the status?", question!, YesNo!,2) = 1 then 
	if dw_status.deleterow(ll_row) = 1 then
		if dw_status.update( ) = 1 then
			commit;
		else
			rollback;
		end if
		return 1
	else
		rollback;
		MessageBox("Delete Error", "Error deleting status.")
		return -1
	end if

end if

end event

type cb_new from mt_u_commandbutton within w_f_status
boolean visible = false
integer x = 443
integer y = 1288
integer taborder = 40
string facename = "Arial"
boolean enabled = false
string text = "&New"
end type

event clicked;call super::clicked;int			li_row

li_row = dw_status.insertrow( 0)

dw_status.setitem( li_row,"pf_fixture_status_config_pcgroup_id",ii_pcgroup)

dw_status.setfocus( )
dw_status.scrolltorow(li_row)

end event

type cb_close from mt_u_commandbutton within w_f_status
integer x = 1486
integer y = 1288
integer taborder = 60
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_status from datawindow within w_f_status
integer x = 18
integer y = 204
integer width = 1810
integer height = 1072
integer taborder = 10
string title = "none"
string dataobject = "d_f_status"
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

