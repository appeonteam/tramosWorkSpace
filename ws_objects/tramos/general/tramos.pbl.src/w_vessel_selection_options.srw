$PBExportHeader$w_vessel_selection_options.srw
$PBExportComments$Small window for vessel selection option settings such as active and profitcenter
forward
global type w_vessel_selection_options from mt_w_response
end type
type gb_vessels from mt_u_groupbox within w_vessel_selection_options
end type
type st_users from mt_u_statictext within w_vessel_selection_options
end type
type cb_ok from commandbutton within w_vessel_selection_options
end type
type cb_cancel from commandbutton within w_vessel_selection_options
end type
type cb_deselect_all from commandbutton within w_vessel_selection_options
end type
type cb_select_all from commandbutton within w_vessel_selection_options
end type
type dw_vessels from u_datagrid within w_vessel_selection_options
end type
type sle_bg from u_topbar_background within w_vessel_selection_options
end type
type uo_user from u_user within w_vessel_selection_options
end type
type rb_vessel_active from radiobutton within w_vessel_selection_options
end type
type rb_vessel_inactive from radiobutton within w_vessel_selection_options
end type
type rb_vessel_all from radiobutton within w_vessel_selection_options
end type
end forward

global type w_vessel_selection_options from mt_w_response
integer width = 2533
integer height = 1908
string title = "User Vessel Selection"
event ue_userchanged ( string as_userid,  integer ai_userprofile )
gb_vessels gb_vessels
st_users st_users
cb_ok cb_ok
cb_cancel cb_cancel
cb_deselect_all cb_deselect_all
cb_select_all cb_select_all
dw_vessels dw_vessels
sle_bg sle_bg
uo_user uo_user
rb_vessel_active rb_vessel_active
rb_vessel_inactive rb_vessel_inactive
rb_vessel_all rb_vessel_all
end type
global w_vessel_selection_options w_vessel_selection_options

type variables
long 		il_user_profile, il_vessels_all
long		il_lastclickedrow
boolean	ib_vessel_all, ib_vessel_my
private 	n_service_manager inv_servicemgr

mt_n_datastore ids_uservessels
s_vessel_selection istr_vessel_selection

boolean	ib_ismvv_window, ib_isvc_window

end variables

forward prototypes
public subroutine wf_markselected ()
public function string wf_getalluservessels ()
public subroutine documentation ()
public function string wf_getfilter (string as_filter, string as_filtervessel)
public function integer wf_setvesselstatus ()
public function integer wf_markallvessels (integer ai_flag)
end prototypes

event ue_userchanged(string as_userid, integer ai_userprofile);/********************************************************************
   ue_userchanged
   <DESC>	Retrive the vessels for current user refer to business defined rule	</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_userid:user login id
		ai_userprofile:user profile
   </ARGS>
   <USAGE>	Dynamic trigger from the object:uo_user	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	08-06-2011 	2406          JMY014        		First Version
   </HISTORY>
********************************************************************/
string		ls_filter

dw_vessels.setredraw(false)
if (isnull(as_userid)) then
	istr_vessel_selection.as_filter = "" 
else
	istr_vessel_selection.as_filter = " (vessels_vessel_operator ='" + as_userid + "' or vessels_vessel_fin_resp='" + as_userid + "' or vessels_vessel_dem_analyst='" + as_userid + "' or vessels_vessel_charterer='" + as_userid + "') "
end if
dw_vessels.setfilter(wf_getfilter(istr_vessel_selection.as_filter, istr_vessel_selection.as_filtervessel))
dw_vessels.filter()
dw_vessels.setredraw(true)
end event

public subroutine wf_markselected ();/********************************************************************
   wf_markselected
   <DESC>	Mark the vessels that has been selected by user.	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call directly	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	08-06-2011 	2406          JMY014		    First Version
		22-11-2012	CR2582		 LHC010				 Differentiate vessels filter selection in MVV
		19-10-2013	CR3340		 LHC010				 Differentiate vessels filter selection in VC
	</HISTORY>
********************************************************************/

long	ll_row, ll_vescount, ll_found, ll_rowcount
integer	li_vesselstatus

ll_vescount = ids_uservessels.rowcount()
ll_rowcount = dw_vessels.rowcount()
for ll_row = 2 to ll_vescount
	ll_found = dw_vessels.find("vessels_vessel_nr = " + string(ids_uservessels.getitemnumber(ll_row, "vessel_nr")), 1, ll_rowcount)
	if ll_found > 0 then 
		dw_vessels.selectrow(ll_found, true)
		dw_vessels.setitem(ll_found, "vessel_select", 0)
	end if
next

dw_vessels.setsort(" selected_vessels ")
dw_vessels.sort()

if ib_ismvv_window then
	li_vesselstatus = uo_global.ii_mvv_vesselstatus
elseif ib_isvc_window then
	li_vesselstatus = uo_global.ii_vc_vesselstatus
else
	li_vesselstatus = uo_global.ii_vesselstatus
end if

if li_vesselstatus = 1 then
	rb_vessel_all.checked = true
	dw_vessels.setfilter('')
	dw_vessels.filter()
elseif li_vesselstatus = 2 then
	rb_vessel_active.checked = true
	dw_vessels.setfilter("vessels_vessel_active = 1")
	dw_vessels.filter()
elseif (li_vesselstatus = 3) then
	rb_vessel_inactive.checked = true
	dw_vessels.setfilter("vessels_vessel_active = 0")
	dw_vessels.filter()
end if

end subroutine

public function string wf_getalluservessels ();/********************************************************************
   wf_getalluservessels
   <DESC>	Return the vessels has been selected	</DESC>
   <RETURN>	string: The vessels has been seperated by comma</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call directly	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	08-06-2011 	2406          JMY014	        First Version
		22-11-2012	CR2582		 LHC010			  Differentiate vessels filter selection in MVV
		18-10-2013	CR3340		 LHC010			  Differentiate vessels filter selection in VC
  </HISTORY>
********************************************************************/

integer	li_empty[], li_vesselnumber[]
long		ll_row, ll_rowcount
long		ll_vessel_nr
string	ls_vessels

dw_vessels.setfilter("selected_vessels = 'S'")
dw_vessels.filter()
ll_rowcount = dw_vessels.rowcount()

for ll_row = 1 to ll_rowcount
	ll_vessel_nr = dw_vessels.getitemnumber(ll_row, "vessels_vessel_nr")
	li_vesselnumber[ll_row] = ll_vessel_nr
	ls_vessels += string(ll_vessel_nr) + ","
next

//Reset the vessel global array and transfer selected vessel_nr to global array.
if ib_ismvv_window then
	uo_global.ii_mvv_vesselnumber = li_empty	
	uo_global.ii_mvv_vesselnumber = li_vesselnumber	
elseif ib_isvc_window then
	uo_global.ii_vc_vesselnumber = li_empty	
	uo_global.ii_vc_vesselnumber = li_vesselnumber	
else
	uo_global.ii_vesselnumber = li_empty
	uo_global.ii_vesselnumber = li_vesselnumber
end if

ls_vessels = left(ls_vessels, len(ls_vessels) - len(","))

return ls_vessels

end function

public subroutine documentation ();/********************************************************************
   w_vessel_selection_options
   <OBJECT>Personalized vessels filter selection</OBJECT>
   <USAGE>	</USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	08-06-2011 	CR2406       JMY014     	    First Version
		22-11-2012	CR2582		 LHC010				 Differentiate vessels filter selection in MVV
		18-10-2013	CR3340		 LHC010				 Differentiate vessels filter selection in VC
 		03-01-2014	CR3240 		 XSZ004				 Same vessel filter selection as in VC for Alerts view and Rules configuration
 </HISTORY>
********************************************************************/

end subroutine

public function string wf_getfilter (string as_filter, string as_filtervessel);/********************************************************************
   wf_getfilter
   <DESC>	Filter vessels by resposible user and vessel status	</DESC>
   <RETURN>	string: Vessel filter	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_filter
		as_filtervessel
   </ARGS>
   <USAGE>	Call directly from other event or function	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       		Author             Comments
   	22-06-2011 	2406            	JMY014        	First Version
   </HISTORY>
********************************************************************/

if len(as_filter) = 0 then
	if len(as_filtervessel) = 0 then
		return ""
	else
		return as_filtervessel
	end if
else
	if len(as_filtervessel) = 0 then
		return as_filter
	end if
end if

return as_filter + " and " + as_filtervessel
end function

public function integer wf_setvesselstatus ();/********************************************************************
   wf_checkmyvessels
   <DESC>	Check my vessels status	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by ok button	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       		Author             Comments
   	13-06-2011 CR2406            JMY014        	First Version
		22-11-2012	CR2582		 LHC010				 Differentiate vessels filter selection in MVV
		19-10-2013	CR3340		 LHC010				 Differentiate vessels filter selection in VC  		
  </HISTORY>
********************************************************************/

long ll_row, ll_rowcount, ll_found
integer li_vesselnumber[]

//Check my vessels status
dw_vessels.setfilter(" vessels_vessel_operator ='" + uo_global.is_userid + "' or vessels_vessel_fin_resp='" + uo_global.is_userid + "' or vessels_vessel_dem_analyst='" + uo_global.is_userid + "' or vessels_vessel_charterer='" + uo_global.is_userid + "' ")
dw_vessels.filter()
ll_rowcount = dw_vessels.rowcount()
ib_vessel_my = true

if ib_ismvv_window then
	li_vesselnumber = uo_global.ii_mvv_vesselnumber
elseif ib_isvc_window then
	li_vesselnumber = uo_global.ii_vc_vesselnumber
else
	li_vesselnumber = uo_global.ii_vesselnumber	
end if

if ll_rowcount > 0 and ll_rowcount = upperbound(li_vesselnumber) then
	for ll_row = 1 to ll_rowcount
		ll_found = dw_vessels.find("vessels_vessel_nr=" + string(li_vesselnumber[ll_row]), 1, ll_rowcount)
		if ll_found <= 0 then 
			ib_vessel_my = false
			continue
		end if
	next
else
	ib_vessel_my = false
end if

//Check all vessels status
if (il_vessels_all =  upperbound(li_vesselnumber)) then 
	ib_vessel_all = true
else
	ib_vessel_all = false
end if

return c#return.Success
end function

public function integer wf_markallvessels (integer ai_flag);/********************************************************************
   wf_markallvessels
   <DESC>	Select vessels and deselect all vessels	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_flag
   </ARGS>
   <USAGE>	Called by cb_select_all and cb_deselect_all	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-07-2011 2406         JMY014        		 First Version
   </HISTORY>
********************************************************************/
long		ll_row, ll_rows, ll_array[]
boolean	lb_select

//Select all or de-select all
if ai_flag = 0 then 
	lb_select = true
elseif ai_flag = 1 then 
	lb_select = false
else
	return c#return.Failure
end if
dw_vessels.selectrow( 0, lb_select )

//Change the value of vessel_select value
ll_rows = dw_vessels.rowcount()
if ll_rows <= 0 then return c#return.Success

for ll_row = 1 to ll_rows
	ll_array[ll_row] = ai_flag
next
dw_vessels.object.vessel_select.primary = ll_array[]

return c#return.Success
end function

on w_vessel_selection_options.create
int iCurrent
call super::create
this.gb_vessels=create gb_vessels
this.st_users=create st_users
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cb_deselect_all=create cb_deselect_all
this.cb_select_all=create cb_select_all
this.dw_vessels=create dw_vessels
this.sle_bg=create sle_bg
this.uo_user=create uo_user
this.rb_vessel_active=create rb_vessel_active
this.rb_vessel_inactive=create rb_vessel_inactive
this.rb_vessel_all=create rb_vessel_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_vessels
this.Control[iCurrent+2]=this.st_users
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_deselect_all
this.Control[iCurrent+6]=this.cb_select_all
this.Control[iCurrent+7]=this.dw_vessels
this.Control[iCurrent+8]=this.sle_bg
this.Control[iCurrent+9]=this.uo_user
this.Control[iCurrent+10]=this.rb_vessel_active
this.Control[iCurrent+11]=this.rb_vessel_inactive
this.Control[iCurrent+12]=this.rb_vessel_all
end on

on w_vessel_selection_options.destroy
call super::destroy
destroy(this.gb_vessels)
destroy(this.st_users)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cb_deselect_all)
destroy(this.cb_select_all)
destroy(this.dw_vessels)
destroy(this.sle_bg)
destroy(this.uo_user)
destroy(this.rb_vessel_active)
destroy(this.rb_vessel_inactive)
destroy(this.rb_vessel_all)
end on

event open;call super::open;long	ll_row, ll_rowcount, ll_currentrow
integer	li_vesselnumber[], li_vesselfilterstatus, li_vesselstatus
n_dw_style_service   lnv_style
string ls_classname

ls_classname = message.stringparm
choose case ls_classname
	 case "w_port_of_call_list"
		 this.title = "MVV User Vessel Selection"
		  ib_ismvv_window = true		  
	 case "w_msps_messages_list", "w_alerts_view", "w_rules_configuration"
		 this.title = "VC User Vessel Selection"
		 ib_isvc_window = true
end choose 

ids_uservessels = create mt_n_datastore
ids_uservessels.dataobject = "d_sq_gr_user_vessels"
ids_uservessels.settransobject(sqlca)
if ids_uservessels.retrieve(uo_global.is_userid) = 0 then
	ll_currentrow = ids_uservessels.insertrow(0)
	ids_uservessels.setitem(ll_currentrow, "userid", uo_global.is_userid)
end if
//CR2406 Added by JMY014 on 14-06-2011. Change desc: Load selected vessels from array to datastore

if ib_ismvv_window then
	li_vesselnumber = uo_global.ii_mvv_vesselnumber
	li_vesselfilterstatus = uo_global.ii_mvv_vesselfilterstatus
	li_vesselstatus = uo_global.ii_mvv_vesselstatus
elseif ib_isvc_window then
	li_vesselnumber = uo_global.ii_vc_vesselnumber
	li_vesselfilterstatus = uo_global.ii_vc_vesselfilterstatus
	li_vesselstatus = uo_global.ii_vc_vesselstatus
else
	li_vesselnumber = uo_global.ii_vesselnumber
	li_vesselfilterstatus = uo_global.ii_vesselfilterstatus
	li_vesselstatus = uo_global.ii_vesselstatus
end if

ll_rowcount = upperbound(li_vesselnumber)
for ll_row = 1 to ll_rowcount
	ll_currentrow = ids_uservessels.insertrow(0)
	ids_uservessels.setitem(ll_currentrow, "userid", uo_global.is_userid)
	ids_uservessels.setitem(ll_currentrow, "vessel_nr", li_vesselnumber[ll_row])
next

dw_vessels.settransobject(sqlca)
il_vessels_all = dw_vessels.retrieve(0, uo_global.is_userid)
if (il_vessels_all > 0) then  wf_markselected()

inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_vessels, false)

if (li_vesselfilterstatus = 1) then			//All Vessels
	ib_vessel_all = true
	ib_vessel_my = false
elseif (li_vesselfilterstatus = 2) then		//My Vessels
	ib_vessel_my = true
	ib_vessel_all = false
elseif (li_vesselfilterstatus = 0) then		//Filter Active
	ib_vessel_all = false
	ib_vessel_my = false
end if

if li_vesselstatus = 1 then						//All
	rb_vessel_all.checked = true
	istr_vessel_selection.as_filtervessel =""
elseif li_vesselstatus = 2 then					//Active
	rb_vessel_active.checked = true
	istr_vessel_selection.as_filtervessel = " vessels_vessel_active = 1 "
else																	//Inactive
	rb_vessel_inactive.checked = true
	istr_vessel_selection.as_filtervessel = " vessels_vessel_active = 0 "
end if
end event

type gb_vessels from mt_u_groupbox within w_vessel_selection_options
integer x = 1751
integer y = 16
integer width = 736
integer height = 160
integer taborder = 40
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Vessels"
end type

type st_users from mt_u_statictext within w_vessel_selection_options
integer x = 55
integer y = 80
integer width = 165
integer height = 56
long textcolor = 16777215
long backcolor = 22628899
string text = "Users"
end type

type cb_ok from commandbutton within w_vessel_selection_options
integer x = 1797
integer y = 1696
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;long		ll_row, ll_rows
string 	ls_returntext
string 	ls_returntext_vessel
string	ls_filter
string 	ls_vessels
integer	li_vesselstatus, li_vesselfilterstatus

//Don't change the dw_vessels display status before closing.
dw_vessels.setredraw(false)

if rb_vessel_active.checked then			//Active
	li_vesselstatus = 2
elseif rb_vessel_inactive.checked then	//Inactive
	li_vesselstatus = 3
else												//All
	li_vesselstatus = 1
end if

if ib_ismvv_window then
	uo_global.ii_mvv_vesselstatus = li_vesselstatus
elseif ib_isvc_window then
	uo_global.ii_vc_vesselstatus = li_vesselstatus
else
	uo_global.ii_vesselstatus = li_vesselstatus
end if

ls_filter = ""

//Transfering vessel_nr to global array, and combining vessel_nr to string
ls_vessels = wf_getalluservessels()

if len(ls_filter) > 0 then
	ls_filter += " vessel_nr in ("+ls_vessels + ")" 
else
	ls_filter += " vessel_nr in (9999999)"
end if

wf_setvesselstatus()

if (ib_vessel_all) then
	ls_returntext_vessel = "All Vessels"
	li_vesselfilterstatus = 1
elseif (ib_vessel_my) then
	ls_returntext_vessel = "My Vessels"
	li_vesselfilterstatus = 2
elseif (not ib_vessel_my and not ib_vessel_all) then
	ls_returntext_vessel = "Filter Active"
	li_vesselfilterstatus = 0
end if

if ib_ismvv_window then
	uo_global.ii_mvv_vesselfilterstatus = li_vesselfilterstatus
	ls_returntext += ls_returntext_vessel + " (" + String(upperbound(uo_global.ii_mvv_vesselNumber)) + "/" + String(il_vessels_all) + ")"
	uo_global.is_mvv_showtext = ls_returntext	
elseif ib_isvc_window then
	uo_global.ii_vc_vesselfilterstatus = li_vesselfilterstatus
	ls_returntext += ls_returntext_vessel + " (" + String(upperbound(uo_global.ii_vc_vesselNumber)) + "/" + String(il_vessels_all) + ")"
	uo_global.is_vc_showtext = ls_returntext	
else
	uo_global.ii_vesselfilterstatus = li_vesselfilterstatus
	ls_returntext += ls_returntext_vessel + " (" + String(upperbound(uo_global.ii_vesselNumber)) + "/" + String(il_vessels_all) + ")"
	uo_global.is_showtext = ls_returntext	
end if

//Reset datastore for saving vessels string
if (ids_uservessels.retrieve(uo_global.is_userid) = 0) then
	messagebox("Warning", "Current user has no vessel configuration, operation canceled!", Information!)
	return
end if

ids_uservessels.setitem(1, "userid", uo_global.is_userid)

if ib_ismvv_window then
	ids_uservessels.setitem(1, "mvv_vessel_list", ls_vessels)
	ids_uservessels.setitem(1, "mvv_vessel_selection_status", uo_global.ii_mvv_vesselstatus)
	ids_uservessels.setitem(1, "mvv_vessel_filter_status", uo_global.ii_mvv_vesselfilterstatus)
elseif ib_isvc_window  then
	ids_uservessels.setitem(1, "vc_vessel_list", ls_vessels)
	ids_uservessels.setitem(1, "vc_vessel_selection_status", uo_global.ii_vc_vesselstatus)
	ids_uservessels.setitem(1, "vc_vessel_filter_status", uo_global.ii_vc_vesselfilterstatus)
else
	ids_uservessels.setitem(1, "vessel_list", ls_vessels)
	ids_uservessels.setitem(1, "vessel_selection_status", uo_global.ii_vesselstatus)
	ids_uservessels.setitem(1, "vessel_filter_status", uo_global.ii_vesselfilterstatus)
end if

if (ids_uservessels.update() <> 1) then
	rollback;
	_addmessage( this.classdefinition, "click()", "Error, when saving the vessel selection to USER_VESSELS table.! [sqlcode=" + string(sqlca.sqlcode) + " sqltext=" + sqlca.sqlerrtext + "]", "could not save!")
	return
end if

commit;

destroy ids_uservessels

close(parent)
end event

type cb_cancel from commandbutton within w_vessel_selection_options
integer x = 2144
integer y = 1696
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_deselect_all from commandbutton within w_vessel_selection_options
integer x = 370
integer y = 1696
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Deselect All"
end type

event clicked;wf_markallvessels(1)
end event

type cb_select_all from commandbutton within w_vessel_selection_options
integer x = 23
integer y = 1696
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Select All"
end type

event clicked;wf_markallvessels(0)
end event

type dw_vessels from u_datagrid within w_vessel_selection_options
integer x = 37
integer y = 240
integer width = 2450
integer height = 1440
integer taborder = 70
string dataobject = "d_sq_gr_user_vessel_selection"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event ue_lbuttondown;//
end event

event clicked;call super::clicked;long ll_index

if left(this.getbandatpointer(), 6)  = "header" then
	return
end if
if row = 0 then return
if keydown(keyshift!) then
	this.setredraw(false) 
	if il_lastclickedrow = 0 then
		 this.selectrow(row, true)
		 il_lastclickedrow = row
		 dw_vessels.setitem(row, "vessel_select", 0)
	else    
		if  il_lastclickedrow > row then
			for ll_index = il_lastclickedrow to row step -1
				this.selectrow (ll_index, true) 
				dw_vessels.setitem(ll_index, "vessel_select", 0)
			next
		else
			for ll_index = il_lastclickedrow to row
				this.selectrow (ll_index, true) 
				dw_vessels.setitem(ll_index, "vessel_select", 0)
			next 
		end if
	end if
	this.setredraw(true) 
else
	if not this.isselected(row) then 
		il_lastclickedrow = row
		dw_vessels.setitem(row, "vessel_select", 0)
	else
		dw_vessels.setitem(row, "vessel_select", 1)
	end if
	this.selectrow(row, not this.isselected(row))
end if
end event

type sle_bg from u_topbar_background within w_vessel_selection_options
integer width = 2619
end type

type uo_user from u_user within w_vessel_selection_options
integer x = 219
integer y = 80
integer taborder = 30
boolean bringtotop = true
end type

on uo_user.destroy
call u_user::destroy
end on

event constructor;of_setuserid(uo_global.is_userid)
of_getuser()
end event

type rb_vessel_active from radiobutton within w_vessel_selection_options
integer x = 1810
integer y = 80
integer width = 251
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Active"
end type

event clicked;dw_vessels.setredraw(false)
istr_vessel_selection.as_filtervessel = " vessels_vessel_active = 1 "
dw_vessels.setfilter( wf_getfilter(istr_vessel_selection.as_filter, istr_vessel_selection.as_filtervessel))
dw_vessels.filter()
if ib_ismvv_window then
	uo_global.ii_mvv_vesselstatus = 2
elseif ib_isvc_window then
	uo_global.ii_vc_vesselstatus = 2
else
	uo_global.ii_vesselstatus = 2
end if
dw_vessels.setredraw(true)
end event

type rb_vessel_inactive from radiobutton within w_vessel_selection_options
integer x = 2048
integer y = 80
integer width = 306
integer height = 56
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Inactive"
end type

event clicked;dw_vessels.setredraw(false)
istr_vessel_selection.as_filtervessel = " vessels_vessel_active = 0 "
dw_vessels.setfilter( wf_getfilter(istr_vessel_selection.as_filter, istr_vessel_selection.as_filtervessel))
dw_vessels.filter()
if ib_ismvv_window then
	uo_global.ii_mvv_vesselstatus = 3
elseif ib_isvc_window then
	uo_global.ii_vc_vesselstatus = 3
else
	uo_global.ii_vesselstatus = 3
end if
dw_vessels.setredraw(true)
end event

type rb_vessel_all from radiobutton within w_vessel_selection_options
integer x = 2322
integer y = 80
integer width = 142
integer height = 56
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "All"
end type

event clicked;dw_vessels.setredraw(false)
istr_vessel_selection.as_filtervessel = ""
dw_vessels.setfilter( wf_getfilter(istr_vessel_selection.as_filter, istr_vessel_selection.as_filtervessel))
dw_vessels.filter()
if ib_ismvv_window then
	uo_global.ii_mvv_vesselstatus = 1
elseif ib_isvc_window then
	uo_global.ii_vc_vesselstatus = 1
else
	uo_global.ii_vesselstatus = 1
end if
dw_vessels.setredraw(true)
end event

