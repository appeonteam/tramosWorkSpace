$PBExportHeader$w_pool_reg.srw
$PBExportComments$Window for Pool Registration
forward
global type w_pool_reg from window
end type
type cb_close from commandbutton within w_pool_reg
end type
type cb_delete_member from commandbutton within w_pool_reg
end type
type cb_new_member from commandbutton within w_pool_reg
end type
type cb_new_vessel from commandbutton within w_pool_reg
end type
type cb_new_pool from commandbutton within w_pool_reg
end type
type cb_delete_vessel from commandbutton within w_pool_reg
end type
type cb_update from commandbutton within w_pool_reg
end type
type cb_delete_pool from commandbutton within w_pool_reg
end type
type st_1 from statictext within w_pool_reg
end type
type st_pool_vessels from statictext within w_pool_reg
end type
type st_pool from statictext within w_pool_reg
end type
type dw_member_list from datawindow within w_pool_reg
end type
type dw_pool_detail from datawindow within w_pool_reg
end type
type dw_vessel_list from datawindow within w_pool_reg
end type
type dw_pool_list from datawindow within w_pool_reg
end type
type gb_pool_detail from groupbox within w_pool_reg
end type
end forward

global type w_pool_reg from window
integer width = 3817
integer height = 1856
boolean titlebar = true
string title = "Pool Registration"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
cb_close cb_close
cb_delete_member cb_delete_member
cb_new_member cb_new_member
cb_new_vessel cb_new_vessel
cb_new_pool cb_new_pool
cb_delete_vessel cb_delete_vessel
cb_update cb_update
cb_delete_pool cb_delete_pool
st_1 st_1
st_pool_vessels st_pool_vessels
st_pool st_pool
dw_member_list dw_member_list
dw_pool_detail dw_pool_detail
dw_vessel_list dw_vessel_list
dw_pool_list dw_pool_list
gb_pool_detail gb_pool_detail
end type
global w_pool_reg w_pool_reg

type variables
/* TC Pool Registration Non-Visual*/
n_tc_pool_registration inv_pool_reg
end variables

forward prototypes
public subroutine wf_update_poollist ()
public function integer wf_modified_pool ()
public function integer wf_modified_vessels ()
public function integer wf_modified_members ()
end prototypes

public subroutine wf_update_poollist ();long ll_row

ll_row = dw_pool_list.getSelectedRow(0)
if ll_row > 0 then
	dw_pool_list.setItem(ll_row, "pool_name", dw_pool_detail.getItemstring(1, "pool_name"))
	dw_pool_list.setItem(ll_row, "pool_id", dw_pool_detail.getItemnumber(1, "pool_id"))
	dw_pool_list. event clicked(0,0,ll_row,dw_pool_list.object) //will add a new vessel, if pool is new
end if
end subroutine

public function integer wf_modified_pool ();/*-----------------
Tests if data has been modified in Pool Details and notifies user.

Returns 1 if: 	Data has not been modified
					Data has been modified, but user wants to ignore changes
					Data has been modified, user wanted to save changes, and update went okay
Returns - 1 if:Data has been modified, user wanted to save changes, but update failed
------------------*/


dw_pool_detail.accepttext()

if dw_pool_detail.modifiedcount() > 0 then
	if messagebox("Data not saved!","Data has been modified in the Pool Details, "+&
					  "but not saved. ~r~rWould you like to update data before switching?", &
					  Question!,YesNo!,1) = 2 then
		Return 1
	else //user responds Yes - save data
		if inv_pool_reg.of_update()=1 then
			wf_update_poollist()
			return 1
		else //update went wrong
			return -1
		end if
	end if
End if //Members list has not been modified
return 1
end function

public function integer wf_modified_vessels ();/*-----------------
Tests if data has been modified in Pool Vessels and notifies user.

Returns 1 if: 	Data has not been modified
					Data has been modified, but user wants to ignore changes
					Data has been modified, user wanted to save changes, and update went okay
Returns - 1 if:Data has been modified, user wanted to save changes, but update failed
------------------*/
dw_vessel_list.AcceptText()

if dw_vessel_list.modifiedcount() > 0 then
	if messagebox("Data not saved!","Data has been modified in the Pool Vessels list, "+&
					  "but not saved. ~r~rWould you like to update data before switching?", &
					  exclamation!,YesNo!,1) = 2 then
		Return 1
	else //user responds Yes - save data
		if inv_pool_reg.of_update()=1 then
			return 1
		else //update went wrong
			return -1
		end if //update
	end if
End if //Members list has not been modified
return 1
end function

public function integer wf_modified_members ();/*-----------------
Tests if data has been modified in Vessel Members and notifies user.

Returns 1 if: 	Data has not been modified
					Data has been modified, but user wants to ignore changes
					Data has been modified, user wanted to save changes, and update went okay
Returns - 1 if:Data has been modified, user wanted to save changes, but update failed
------------------*/

dw_member_list.AcceptText()

if dw_member_list.modifiedcount() > 0 then
	if messagebox("Data not saved!","Data has been modified in the Vessel Members list, "+&
					  "but not saved. ~r~rWould you like to update data before switching?", &
					  Question!,YesNo!,1) = 2 then
		dw_member_list.ResetUpdate()
		Return 1
	else //user responds Yes - save data
		if inv_pool_reg.of_update()= 1 then 
			wf_update_poollist()
			return 1
		else //update went wrong
			return -1
		end if //update
	end if
End if //Members list has not been modified
return 1
end function

on w_pool_reg.create
this.cb_close=create cb_close
this.cb_delete_member=create cb_delete_member
this.cb_new_member=create cb_new_member
this.cb_new_vessel=create cb_new_vessel
this.cb_new_pool=create cb_new_pool
this.cb_delete_vessel=create cb_delete_vessel
this.cb_update=create cb_update
this.cb_delete_pool=create cb_delete_pool
this.st_1=create st_1
this.st_pool_vessels=create st_pool_vessels
this.st_pool=create st_pool
this.dw_member_list=create dw_member_list
this.dw_pool_detail=create dw_pool_detail
this.dw_vessel_list=create dw_vessel_list
this.dw_pool_list=create dw_pool_list
this.gb_pool_detail=create gb_pool_detail
this.Control[]={this.cb_close,&
this.cb_delete_member,&
this.cb_new_member,&
this.cb_new_vessel,&
this.cb_new_pool,&
this.cb_delete_vessel,&
this.cb_update,&
this.cb_delete_pool,&
this.st_1,&
this.st_pool_vessels,&
this.st_pool,&
this.dw_member_list,&
this.dw_pool_detail,&
this.dw_vessel_list,&
this.dw_pool_list,&
this.gb_pool_detail}
end on

on w_pool_reg.destroy
destroy(this.cb_close)
destroy(this.cb_delete_member)
destroy(this.cb_new_member)
destroy(this.cb_new_vessel)
destroy(this.cb_new_pool)
destroy(this.cb_delete_vessel)
destroy(this.cb_update)
destroy(this.cb_delete_pool)
destroy(this.st_1)
destroy(this.st_pool_vessels)
destroy(this.st_pool)
destroy(this.dw_member_list)
destroy(this.dw_pool_detail)
destroy(this.dw_vessel_list)
destroy(this.dw_pool_list)
destroy(this.gb_pool_detail)
end on

event open;inv_pool_reg = CREATE n_tc_pool_registration
inv_pool_reg.of_share_on(dw_pool_list, dw_vessel_list, dw_member_list, dw_pool_detail)
inv_pool_reg.of_retrieve_pool_list()

this.move(0,0)
dw_member_list.setrowfocusindicator( focusRect!)
if dw_pool_list.rowcount() = 0 then 
   inv_pool_reg.of_newpool()
else
	dw_pool_list. event clicked(0,0,1,dw_pool_list.object)
end if
end event

event closequery;if wf_modified_vessels()=1 then //data in Pool Vessels List has not been modified (or user wants to ignore)
	if wf_modified_members()=1 then //data in Vessel Members List has not been modified (or user wants to ignore)
		if wf_modified_pool()=1 then //data in Pool Details has not been modified (or user wants to ignore changes)
			if inv_pool_reg.of_validate_close() = 1 then
				return 0 //allow the window to be closed
			else
				return 1
			end if
		else //data in Pool Details has been modified and user do not want to ignore changes
			end if //changes in Pool Details
	else //data in Vessel Members List has been modified and user do not want to ignore changes
		Return 1
	end if //changes in Vessel Members List
else //data in Pool Vessels list has been modified and user do not want to ignore changes
	return 1
end if //changes in Pool Vessel list
end event

type cb_close from commandbutton within w_pool_reg
integer x = 3369
integer y = 1628
integer width = 389
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_delete_member from commandbutton within w_pool_reg
integer x = 3369
integer y = 980
integer width = 389
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Mem&ber"
end type

event clicked;string ls_error_text

if messagebox("Confirm Delete","Are you sure you want to delete this record?",Question!,yesno!,2) = 1 then
		if inv_pool_reg.of_deletemember(ls_error_text, dw_member_list.getrow()) = -1 then 
			MessageBox ("Delete Error", ls_error_text )
		Return
		end if
else
	return
end if

inv_pool_reg.of_retrieve_members()
//dw_pool_list.POST EVENT clicked(0,0,1,dw_pool_list.object)
end event

type cb_new_member from commandbutton within w_pool_reg
integer x = 3369
integer y = 860
integer width = 389
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add  &Member"
end type

event clicked;dw_member_list.selectrow(0,false)
dw_member_list.scrollToRow(inv_pool_reg.of_newmember())
dw_member_list.setfocus()
end event

type cb_new_vessel from commandbutton within w_pool_reg
integer x = 3369
integer y = 80
integer width = 389
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add &Vessel"
end type

event clicked;if wf_modified_members()=1 then //Data in Vessel Members list has not been modified (or user wants to ignore, or update went OK)
	dw_vessel_list.selectRow(0, false)
	dw_vessel_list.scrollToRow(inv_pool_reg.of_newvessel())
	dw_member_list.reset()
	dw_vessel_list.setfocus()
else //Data was not updated because of some error
	return
end if
end event

type cb_new_pool from commandbutton within w_pool_reg
integer x = 247
integer y = 1628
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ne&w Pool"
end type

event clicked;long ll_row

if wf_modified_vessels()=1 then //data in Pool Vessels List has not been modified, or data has been updated (or user wants to ignore)
	if wf_modified_members()=1 then //data in Vessel Members List has not been modified, or data has been updated (or user wants to ignore)
		if wf_modified_pool()=1 then //data in Pool Details has not been modified, or data has been updated (or user wants to ignore changes)
			inv_pool_reg.of_newpool()
			ll_row = dw_pool_list.insertrow(0)
			dw_pool_list.selectRow(0, false)
			dw_pool_list.scrollToRow(ll_row)
			dw_pool_list.selectrow(ll_row,true)
			setfocus(dw_pool_detail)
		else //update in Pool Detail went wrong for some reason
			Return
		end if //changes in Pool Details
	else //update in Vessel Members went wrong for some reason
		Return
	end if //changes in Vessel Members List
else //update in Pool Vessels went wrong for some reason
	return
end if //changes in Pool Vessel list
end event

type cb_delete_vessel from commandbutton within w_pool_reg
integer x = 3369
integer y = 196
integer width = 389
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Ve&ssel"
end type

event clicked;string ls_error_text

if inv_pool_reg.of_deletevessel(ls_error_text, dw_vessel_list.getrow()) = -1 then 
	MessageBox ("Delete Error", ls_error_text, StopSign!)
	Return
end if

end event

type cb_update from commandbutton within w_pool_reg
integer x = 3369
integer y = 1496
integer width = 389
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
end type

event clicked;dw_pool_detail.AcceptText()
dw_vessel_list.AcceptText()
dw_member_list.AcceptText()

if inv_pool_reg.of_update()= 1 then 
	wf_update_poollist()
end if
end event

type cb_delete_pool from commandbutton within w_pool_reg
integer x = 635
integer y = 1628
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "De&lete Pool"
end type

event clicked;string ls_error_text

if inv_pool_reg.of_deletepool(ls_error_text) = -1 then 
	MessageBox ("Delete Error", ls_error_text )
	Return
end if

inv_pool_reg.of_retrieve_pool_list()
dw_pool_list.POST EVENT clicked(0,0,1,dw_pool_list.object)
end event

type st_1 from statictext within w_pool_reg
integer x = 1344
integer y = 800
integer width = 462
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Members:"
boolean focusrectangle = false
end type

type st_pool_vessels from statictext within w_pool_reg
integer x = 1344
integer y = 12
integer width = 416
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pool Vessels:"
boolean focusrectangle = false
end type

type st_pool from statictext within w_pool_reg
integer x = 27
integer y = 16
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pools:"
boolean focusrectangle = false
end type

type dw_member_list from datawindow within w_pool_reg
event ue_insertrow ( )
event ue_update ( )
event ue_deleterow ( )
event ue_keydown pbm_dwnkey
integer x = 1344
integer y = 860
integer width = 1998
integer height = 432
integer taborder = 80
string title = "none"
string dataobject = "d_tc_pool_member_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;if key = KeySpaceBar! then 
	choose case this.getColumnName()
		case "tcowner_sn"
			this.Event DoubleClicked(0,0, this.getRow(), this.object.tcowner_sn)
	end choose
end if
end event

event doubleclicked;STRING ls_rc, ls_fullname, ls_shortname
LONG	ll_rc

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "tcowner_sn" //open list to choose a pool member
			ls_rc = f_select_from_list("dw_tcowner_list", 2, "Short Name", 3, "Long Name", 1, "Select TC Owner", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT TCOWNER_N_1, TCOWNER_SN INTO :ls_fullname, :ls_shortname
				FROM TCOWNERS WHERE TCOWNER_NR = :ll_rc;
				this.SetItem(row, "tcowner_ln", ls_fullname)
				this.SetItem(row, "tcowner_sn", ls_shortname)
				this.SetItem(row, "tcowner_nr", ll_rc)
			END IF
    END CHOOSE
end if
end event

event clicked;if row > 0 then
 if row = 1 and this.rowcount() = 0 then //used when triggered from dw_vessel_list.clicked and no members are attached to the vessel
   inv_pool_reg.of_newmember()
	return
 end if
	scrolltorow(row)
	//this.selectrow(0,false)
	//this.selectrow(row,true)
end if
end event

type dw_pool_detail from datawindow within w_pool_reg
event ue_update ( )
event ue_insertrow ( )
event ue_deleterow ( )
integer x = 37
integer y = 940
integer width = 1193
integer height = 660
integer taborder = 20
string title = "none"
string dataobject = "d_tc_pool_detail"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vessel_list from datawindow within w_pool_reg
event ue_insertrow ( )
event ue_update ( )
event ue_deleterow ( )
event ue_keydown pbm_dwnkey
integer x = 1344
integer y = 80
integer width = 1998
integer height = 620
integer taborder = 50
string title = "none"
string dataobject = "d_tc_pool_vessel_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;if key = KeySpaceBar! then 
	choose case this.getColumnName()
		case "vessel_ref_nr" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.vessel_nr)
	end choose
end if
end event

event clicked;if row > 0 then
	if row = 1 and this.rowcount() = 0 then //when triggered from dw_pool_list.clicked
   	inv_pool_reg.of_newvessel()
		SetNull(inv_pool_reg.ii_vessel_nr) //prevents adding new member
		dw_member_list.reset()
		return
	end if
end if //row>0

end event

event doubleclicked;STRING ls_rc, ls_vesselname, ls_vessel_ref_nr
LONG	ll_rc

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "vessel_ref_nr" //open list to add a vessel to the pool
			ls_rc = f_select_from_list("dw_vessel_list", 2, "Vessel Name", 1, "Vessel No", 1, "Select Vessel", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT VESSEL_NAME, VESSEL_REF_NR INTO :ls_vesselname, :ls_vessel_ref_nr
				FROM VESSELS WHERE VESSEL_NR = :ll_rc;
				this.SetItem(row, "vessel_name", ls_vesselname)
				this.SetItem(row,"vessel_ref_nr", ls_vessel_ref_nr)
				this.SetItem(row,"vessel_nr", ll_rc)
			END IF
    END CHOOSE
end if
end event

event rowfocuschanged;if currentrow > 0 then
	this.selectRow(0, false)
	this.selectRow(currentrow, true)
	if wf_modified_members() = 1 then //Data has not been modified in Member List (or changes have been updated)
			inv_pool_reg.of_SetVesselNr(this.getitemnumber(currentrow,"ntc_pool_vessels_pool_vessel_id"))
			inv_pool_reg.of_retrieve_members()
	else //Data has been modified in Member List and user do not want to ignore changes
			return
	end if
end if
end event

type dw_pool_list from datawindow within w_pool_reg
event ue_insertrow ( )
event ue_update ( )
integer x = 18
integer y = 76
integer width = 1157
integer height = 772
integer taborder = 10
string title = "none"
string dataobject = "d_tc_pool_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	if row = 1 and this.rowcount() = 0 then //used when triggered from window open event with empty list
		cb_new_pool.event clicked()
		return
	end if
	if wf_modified_vessels()=1 then //data in Pool Vessels List has not been modified (or user wants to ignore)
		if wf_modified_members()=1 then //data in Vessel Members List has not been modified (or user wants to ignore)
			if wf_modified_pool()=1 then //data in Pool Details has not been modified (or user wants to ignore changes)
				this.selectrow(0,false)
				this.selectrow(row,true)
				inv_pool_reg.of_retrieve_pool_detail(this.getitemnumber(row,"pool_id"))
				inv_pool_reg.of_setpoolid(this.getitemnumber(row,"pool_id"))
				inv_pool_reg.of_retrieve_vessels()
				dw_vessel_list. event clicked(0,0,1,dw_vessel_list.object)
				dw_vessel_list.scrolltorow(1)
				setfocus(dw_vessel_list)
			else //update in Pool Detail went wrong for some reason
				return
			end if //changes in Pool Details
		else //update in Vessel Members List went wrong for some reason
			Return
		end if //changes in Vessel Members List
	else //update in Pool Vessel list went wrong for some reason
		return
	end if //changes in Pool Vessel list
end if
end event

type gb_pool_detail from groupbox within w_pool_reg
event ue_update ( )
integer x = 18
integer y = 876
integer width = 1221
integer height = 736
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pool Details"
end type

