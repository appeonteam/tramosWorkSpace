$PBExportHeader$w_modify_trade.srw
forward
global type w_modify_trade from window
end type
type cb_cancel from mt_u_commandbutton within w_modify_trade
end type
type cb_update from mt_u_commandbutton within w_modify_trade
end type
type dw_trade from datawindow within w_modify_trade
end type
end forward

global type w_modify_trade from window
integer width = 2574
integer height = 1644
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_update cb_update
dw_trade dw_trade
end type
global w_modify_trade w_modify_trade

type variables
s_trade 		istr_trade
mt_n_dddw_searchasyoutype inv_dddw_search
end variables

on w_modify_trade.create
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_trade=create dw_trade
this.Control[]={this.cb_cancel,&
this.cb_update,&
this.dw_trade}
end on

on w_modify_trade.destroy
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_trade)
end on

event open;datawindowchild	ldwc
long 					ll_row
int						li_pc_nr[]




istr_trade = message.powerobjectparm
// li_pc_nr[1] = istr_trade.pc_nr
	
dw_trade.setTransObject(SQLCA)

this.width = 2557
this.height = 1680
this.move(0,100)

if isNull(istr_trade.id) then
	this.title = "Create New Trade"
	dw_trade.Object.t_new.Visible='1'
	dw_trade.Object.t_edit.Visible='0'
	/* retrieve DDDW*/
	dw_trade.getchild("pf_fixture_trade_loadareaid", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve(istr_trade.pcgroup)
	dw_trade.getchild("pf_fixture_trade_dischargeareaid", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve(istr_trade.pcgroup)
	dw_trade.getchild("pf_fixture_flatrate_flatrateyear", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve(istr_trade.pcgroup)
	if ldwc.rowcount( )=0 then
		ldwc.insertrow( 0)
		ldwc.setitem(1,"flatrateyear",2009)
	end if
	
	dw_trade.getchild("pf_fixture_trade_bunkerid", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve(istr_trade.pcgroup)
	
	/* retrieve DW - position*/
	//dw_trade.retrieve(0)
	ll_row = dw_trade.InsertRow(0)
	if ll_row < 1 then return
	dw_trade.setitem(1,"pf_fixture_flatrate_pcgroup_id",istr_trade.pcgroup)
	dw_trade.resetUpdate()    //set status to notModified!
	dw_trade.setitemstatus( 1,0, Primary!, New!)  //set status back to New!
else
	this.title = "Modify Trade #"+string(istr_trade.id)
	dw_trade.Object.t_new.Visible='0'
	dw_trade.Object.t_edit.Visible='1'
	/* retrieve DDDW*/
	dw_trade.getchild("pf_fixture_trade_loadareaid", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve()
	dw_trade.getchild("pf_fixture_trade_dischargeareaid", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve()
	dw_trade.getchild("pf_fixture_flatrate_flatrateyear", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve(istr_trade.pcgroup)
	dw_trade.getchild("pf_fixture_trade_bunkerid", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve(istr_trade.pcgroup)
	/* retrieve DW - position*/
	dw_trade.retrieve(istr_trade.id, istr_trade.year)
	dw_trade.setitem( 1,"pf_fixture_flatrate_tradeid", istr_trade.id)
end if
end event

event closequery;dw_trade.accepttext()
if dw_trade.modifiedcount() > 1 then
	if MessageBox("Confirmation", "Data Changed but not saved. Close anyway?", question!, YesNo!,2) = 2 then
		dw_trade.POST setFocus()
		return 1
	end if
end if
end event

type cb_cancel from mt_u_commandbutton within w_modify_trade
integer x = 2103
integer y = 1404
integer width = 402
integer height = 112
integer taborder = 30
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_update from mt_u_commandbutton within w_modify_trade
integer x = 1701
integer y = 1404
integer width = 402
integer height = 112
integer taborder = 20
string facename = "Arial"
string text = "&Update"
end type

event clicked;int li_rc
string ls_err
string ls_mod
long	ll_flatrateyear, ll_flatratevalue, ll_flatrateid
long 	ll_areaid

dw_trade.accepttext( )

//check if flatrate information is fullfilled correctly
ll_flatrateyear = dw_trade.getitemnumber( 1, "pf_fixture_flatrate_flatrateyear")
ll_flatratevalue=dw_trade.getitemnumber( 1, "pf_fixture_flatrate_flatrate")
IF isnull(ll_flatrateyear) and ll_flatratevalue<>0 then
	messagebox("Warning", "Please select the flat rate year.")
	return
end if

if isnull(dw_trade.getitemstring( 1, "pf_fixture_trade_name")) then
	messagebox("Warning", "Please insert a trade description.")
	return
end if
if dw_trade.getitemstring( 1, "pf_fixture_trade_name")="" then
	messagebox("Warning", "Please insert a trade description.")
	return
end if

ll_areaid = dw_trade.getitemnumber( 1, "pf_fixture_trade_loadareaid")
if isnull(ll_areaid) then
	messagebox("Warning", "Please select a Load Area.")
	return
end if
ll_areaid = dw_trade.getitemnumber( 1, "pf_fixture_trade_dischargeareaid")
if isnull(ll_areaid) then
	messagebox("Warning", "Please select a Discharge Area.")
	return
end if

	
if isNull(istr_trade.id) then
	dw_trade.setitem( 1, "pf_fixture_trade_pcgroup_id", istr_trade.pcgroup)
	dw_trade.accepttext( )
end if
	
//The DataWindow is setup to update the trade table first. 
//Perform that update
li_rc =dw_trade.Update(true,false)
if li_rc<>1 then
	Messagebox("Update of Trade Failed","Rolling back changes to " +&
		"Trade Table")
	ROLLBACK using sqlca;
	return
end if

If  ll_flatrateyear>0 Then
	//turn off update of trade columns
	ls_mod = "pf_fixture_trade_name.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_bunkerid.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_loadareaid.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_dischargeareaid.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_lportcode.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_dportcode.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_days.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_distance.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_comment.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_commission.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_daysinport.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_expenses.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_pcgroup_id.Update=No "
	ls_mod= ls_mod + "pf_fixture_trade_trade_active.Update=No "
	
	ls_mod= ls_mod + "trade_id.Key=No "
		
	//make flatrate table the new update table and set its key.
	ls_mod= ls_mod + "DataWindow.Table.UpdateTable='PF_FIXTURE_FLATRATE' "
	ls_mod= ls_mod + "pf_fixture_flatrate_fixtureflatrateid.Key=Yes "

	//Turn on update for flatrate columns
	ls_mod= ls_mod + "pf_fixture_flatrate_flatrate.Update=Yes "
	ls_mod= ls_mod + "pf_fixture_flatrate_flatrateyear.Update=Yes "
	ls_mod= ls_mod + "pf_fixture_flatrate_tradeid.Update=Yes "
	ls_mod= ls_mod + "pf_fixture_flatrate_pcgroup_id.Update=Yes "

	//update DataWindow and check return code
	ls_err = dw_trade.modify(ls_mod)
	If ls_err <> "" Then Messagebox("DataWindow Modify Error",ls_err)
	
	if isNull(istr_trade.id) then
		dw_trade.setitem( 1, "pf_fixture_flatrate_pcgroup_id", istr_trade.pcgroup)
		dw_trade.setitem( 1, "pf_fixture_flatrate_tradeid",dw_trade.getitemnumber( 1, "trade_id"))
		dw_trade.accepttext( )
	end if
	
	//for adding new flatrate
	if dw_trade.getitemnumber(1,"pf_fixture_flatrate_fixtureflatrateid")= 0  then
		dw_trade.setitemstatus( 1,0, Primary!, NewModified!	)
	else
		dw_trade.setitemstatus( 1,0, Primary!, DataModified!	)
	end if

	//Update the flatrate table
	li_rc = dw_trade.Update(true, false)
	If li_rc = 1 Then
		dw_trade.resetUpdate( )
		COMMIT using sqlca;
		If sqlca.sqlcode <> 0 Then
			Messagebox("Error on Commit",Sqlca.sqlerrtext)
//		else
//			if isValid(w_trade_list) then	
//				w_trade_list.post event ue_refreshonerow( dw_trade.getitemnumber(1, "trade_id") )
//			end if
		End If
	else
		Messagebox("Update of Flatrate Table Failed","Rolling back changes to " +&
			"Flatrate and Trade Tables")
		ROLLBACK using sqlca;
	End If
	
	//Reset the DataWindow back to its original state.
//turn on update of trade columns
	ls_mod = "pf_fixture_trade_name.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_bunkerid.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_loadareaid.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_dischargeareaid.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_lportcode.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_dportcode.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_days.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_distance.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_comment.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_commission.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_daysinport.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_expenses.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_pcgroup_id.Update=yes "
	ls_mod= ls_mod + "pf_fixture_trade_trade_active.Update=yes "
	
	ls_mod= ls_mod + "trade_id.Key=yes "

	//Turn off update for flatrate columns
	ls_mod= ls_mod + "pf_fixture_flatrate_flatrate.Update=no "
	ls_mod= ls_mod + "pf_fixture_flatrate_flatrateyear.Update=no "
	ls_mod= ls_mod + "pf_fixture_flatrate_tradeid.Update=no "
	ls_mod= ls_mod + "pf_fixture_flatrate_pcgroup_id.Update=no "
	
	//	//reset datawindow modify property
	//	dw_trade.setitemstatus( 1,0, Primary!, DataModified!	)
	
	//update DataWindow and check return code
	ls_err = dw_trade.modify(ls_mod)
	If ls_err <> "" Then Messagebox("DataWindow Modify Error",ls_err)

Else 
	//delete flatrate
	ll_flatrateid = dw_trade.getitemnumber( 1,"pf_fixture_flatrate_fixtureflatrateid")
	if ll_flatrateid>0 then
			DELETE FROM PF_FIXTURE_FLATRATE WHERE FIXTUREFLATRATEID=:ll_flatrateid
			COMMIT USING SQLCA;
	end if
End If

if isValid(w_trade_list) then	
	w_trade_list.post event ue_refreshonerow( dw_trade.getitemnumber(1, "trade_id") )
end if
			
close(parent)

end event

type dw_trade from datawindow within w_modify_trade
integer x = 23
integer y = 20
integer width = 2482
integer height = 1360
integer taborder = 10
string title = "none"
string dataobject = "d_trade"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;int			li_year
long		li_tradeid, li_flatrateid
decimal	ld_flatrate

dw_trade.accepttext( )

if dwo.name= "pf_fixture_flatrate_flatrateyear"  then
		
	li_year = dw_trade.getitemnumber( 1,"pf_fixture_flatrate_flatrateyear")
	li_tradeid = dw_trade.getitemnumber( 1,"trade_id")
	
	SELECT FLATRATE, FIXTUREFLATRATEID
	INTO :ld_flatrate, :li_flatrateid
	FROM PF_FIXTURE_FLATRATE
	WHERE FLATRATEYEAR = :li_year AND TRADEID = :li_tradeid
	;
	if isnull(ld_flatrate) = false then
		dw_trade.setitem( 1,"pf_fixture_flatrate_flatrate", ld_flatrate)
		dw_trade.setitem( 1,"pf_fixture_flatrate_fixtureflatrateid", li_flatrateid)
		dw_trade.setItemStatus(1,"pf_fixture_flatrate_fixtureflatrateid",Primary!, notModified!)
	else
		dw_trade.setitem( 1,"pf_fixture_flatrate_fixtureflatrateid", "NULL")
	end if
end if


end event

event sqlpreview;//MESSAGEBOX("", SQLSYNTAX)
end event

event editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_trade)
end event

