$PBExportHeader$w_changerequest.srw
forward
global type w_changerequest from mt_w_sheet
end type
type cb_switchview from mt_u_commandbutton within w_changerequest
end type
type dw_export from mt_u_datawindow within w_changerequest
end type
type sle_version from mt_u_singlelineedit within w_changerequest
end type
type st_descript from mt_u_statictext within w_changerequest
end type
type dw_type from u_datagrid within w_changerequest
end type
type cbx_groupby from mt_u_checkbox within w_changerequest
end type
type uo_filter_owner from u_user within w_changerequest
end type
type st_owner from mt_u_statictext within w_changerequest
end type
type dw_submodule from u_datagrid within w_changerequest
end type
type cbx_selectall_submodule from mt_u_checkbox within w_changerequest
end type
type cbx_selectall_businessunit from mt_u_checkbox within w_changerequest
end type
type dw_businessunit from u_datagrid within w_changerequest
end type
type cb_saveas from mt_u_commandbutton within w_changerequest
end type
type dw_assignto from mt_u_datawindow within w_changerequest
end type
type dw_module from u_datagrid within w_changerequest
end type
type st_assignto from mt_u_statictext within w_changerequest
end type
type gb_module from mt_u_groupbox within w_changerequest
end type
type cbx_selectall_module from mt_u_checkbox within w_changerequest
end type
type dw_status from u_datagrid within w_changerequest
end type
type pb_search from picturebutton within w_changerequest
end type
type st_search from statictext within w_changerequest
end type
type gb_status from mt_u_groupbox within w_changerequest
end type
type sle_search from mt_u_singlelineedit within w_changerequest
end type
type uo_filter_show from u_filter_show within w_changerequest
end type
type cb_print from mt_u_commandbutton within w_changerequest
end type
type cb_modify from mt_u_commandbutton within w_changerequest
end type
type cb_new from mt_u_commandbutton within w_changerequest
end type
type cb_print_list from mt_u_commandbutton within w_changerequest
end type
type cb_save from mt_u_commandbutton within w_changerequest
end type
type cb_refresh from mt_u_commandbutton within w_changerequest
end type
type dw_request from mt_u_datawindow within w_changerequest
end type
type dw_list from u_datagrid within w_changerequest
end type
type cbx_selectall_status from mt_u_checkbox within w_changerequest
end type
type gb_type from groupbox within w_changerequest
end type
type gb_businessunit from mt_u_groupbox within w_changerequest
end type
type gb_submodule from mt_u_groupbox within w_changerequest
end type
type st_banner from u_topbar_background within w_changerequest
end type
type st_footer from mt_u_statictext within w_changerequest
end type
type st_rows from mt_u_statictext within w_changerequest
end type
type cbx_current_version from mt_u_checkbox within w_changerequest
end type
type ids_useroption from mt_n_datastore within w_changerequest
end type
end forward

global type w_changerequest from mt_w_sheet
integer width = 4599
integer height = 2568
string title = "List of Errors & Changes"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
string icon = "images\change_request.ICO"
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
event ue_postopen ( )
event ue_refresh_all_rows ( long al_requestid )
event ue_userchanged ( string as_userid,  integer ai_userprofile )
event ue_savefilters pbm_custom01
cb_switchview cb_switchview
dw_export dw_export
sle_version sle_version
st_descript st_descript
dw_type dw_type
cbx_groupby cbx_groupby
uo_filter_owner uo_filter_owner
st_owner st_owner
dw_submodule dw_submodule
cbx_selectall_submodule cbx_selectall_submodule
cbx_selectall_businessunit cbx_selectall_businessunit
dw_businessunit dw_businessunit
cb_saveas cb_saveas
dw_assignto dw_assignto
dw_module dw_module
st_assignto st_assignto
gb_module gb_module
cbx_selectall_module cbx_selectall_module
dw_status dw_status
pb_search pb_search
st_search st_search
gb_status gb_status
sle_search sle_search
uo_filter_show uo_filter_show
cb_print cb_print
cb_modify cb_modify
cb_new cb_new
cb_print_list cb_print_list
cb_save cb_save
cb_refresh cb_refresh
dw_request dw_request
dw_list dw_list
cbx_selectall_status cbx_selectall_status
gb_type gb_type
gb_businessunit gb_businessunit
gb_submodule gb_submodule
st_banner st_banner
st_footer st_footer
st_rows st_rows
cbx_current_version cbx_current_version
ids_useroption ids_useroption
end type
global w_changerequest w_changerequest

type variables
string   is_currentversion
integer	ii_bu_setpriority = 0
integer	ii_bu_setimpl = 0

string	is_assignto
string	is_type_selection
string	is_sub_module_selection
string	is_status_selection
integer	ii_show_selection
integer	ii_groupbyproject_selection
integer	ii_showcurrentver_selection
string	is_owner_selection
string	is_module_selection
string	is_list_sorting
string	is_business_unit_selection
string	is_userid
string	is_search_selection

constant string is_DELIMITER = ","
constant string is_IMPL = "IMPL"
constant string is_NOTIMPL = "NOTIMPL"
constant string is_NORMALTITLE = "List of Errors & Changes"
constant string is_TECHNICALTITLE = "Technical Overview"

constant long il_QUEUED_STATUS = 14  			//Queued
constant long il_BU_REVIEWED_STATUS = 32		//Business Reviewed

s_parm_request	istr_parms

n_service_manager inv_servicemgr

mt_n_dddw_searchasyoutype inv_dddw_search

integer ii_test= 0

boolean ib_ignoredefaultbutton
boolean ib_firstexec = true
string	is_tablesort
string	is_statussort	


end variables

forward prototypes
public subroutine wf_filter ()
public subroutine documentation ()
public subroutine wf_selectall (u_datagrid adw_filter, checkbox acbx_selectall)
public subroutine wf_filter (string as_filter)
public function boolean wf_filter (u_datagrid adw_filter, ref string as_filter)
private function integer _initparm ()
private function integer _savefilter ()
private subroutine _show_implorprio (string as_implorprio)
private subroutine _groupbyproject ()
private function integer _datamodified (string as_message)
private subroutine _highlightcr (long al_requestid)
private subroutine _selectedfilterrow (u_datagrid adw_source, string as_filter, string as_column)
private subroutine _selectedfilterrow (u_datagrid adw_source, string as_filter, string as_column, boolean ab_includenull)
end prototypes

event ue_postopen();SELECT isnull(BU_ID,0)
INTO :istr_parms.bu_id
FROM USERS 
WHERE USERID=:uo_global.is_userid;

if istr_parms.bu_id <> 0 then
	SELECT isnull(BU_SETPRIORITY,0), isnull(BU_SETIMPL,0), 	BU_ACCESSSTATUS, BU_DEV, BU_BSO,
			 BU_CONTROLTIMEREG, 		BU_ACCESSTYPES,		BU_CHANGETYPE
	INTO :ii_bu_setpriority, :ii_bu_setimpl, :istr_parms.bu_accessstatus, :istr_parms.b_bu_dev, :istr_parms.b_bu_bso, 
		  :istr_parms.bu_controltimereg, :istr_parms.bu_accesstypes, :istr_parms.bu_changetype
	FROM CREQ_BUSINESS_UNIT
	WHERE BU_ID = :istr_parms.bu_id;
end if

uo_filter_show.of_setbusinessunit(istr_parms.bu_id)

if istr_parms.b_bu_dev then cb_switchview.visible = true
if uo_global.ii_access_level < 0 then cb_new.enabled = false

//If user save filter option with only Status '32'(Business Reviewed) selected, then show prio. column else show impl. column.
if is_status_selection = string(il_BU_REVIEWED_STATUS) then
	_show_implorprio(is_NOTIMPL)
else
	_show_implorprio(is_IMPL)
end if

if len(trim(sle_search.text)) > 0 then
	dw_list.retrieve("%" + sle_search.text + "%")
else
	dw_list.retrieve("%")
end if

wf_filter()

end event

event ue_refresh_all_rows(long al_requestid);long ll_found

setpointer(hourglass!)

this.setredraw(false)

pb_search.triggerevent(clicked!)

//Highlight CR and Retrieve the CR's description
_highlightcr(al_requestid)

this.post setredraw(true)

setpointer(Arrow!)

dw_list.post setfocus()

end event

event ue_userchanged(string as_userid, integer ai_userprofile);/********************************************************************
   ue_userchanged
   <DESC>	User filter when changing user	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_userid: User id no use.
		ai_userprofile: User profile, no use here, just for other objects function.
		
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-26-2012 2614         LHC010             First Version
   </HISTORY>
********************************************************************/
is_userid = as_userid
wf_filter()
end event

event ue_savefilters;_savefilter()
end event

public subroutine wf_filter ();/********************************************************************
   wf_filter
   <DESC>	Filter the data of dw_list datawindow	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
				1. Called by filter user object dynamicly.
				2. Initial dw_list data in open event.
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28-07-2011 2438         JMY014        First Version
   	17-12-2012 2614         LHC010        Add string constant ls_AND
   </HISTORY>
********************************************************************/
string	ls_filter, ls_filter_temp
constant string	ls_AND = " and "

this.setredraw(false)
//One of business unit/Module/Sub module/Type filter must has filter value
if wf_filter(dw_businessunit, ls_filter) and &
	wf_filter(dw_module, ls_filter) and &
	wf_filter(dw_submodule, ls_filter) and &
	wf_filter(dw_status, ls_filter) and &
	wf_filter(dw_type, ls_filter) then
	
	//Show filter
	ls_filter_temp = uo_filter_show.of_getfilter()
	if len(ls_filter_temp) > 0 then  ls_filter += ls_filter_temp + ls_AND
	
	//Owner filter
	if len(is_userid) > 0 then  ls_filter += "owner = '" + is_userid + "'" + ls_AND
	
	//Assign to filter
	if len(is_assignto) > 0 then ls_filter += "lower(assigned_to) = '" + lower(is_assignto) + "'" + ls_AND
	
	//Cut out the "and" word at the end of the filter string
	if len(ls_filter) > 0 then ls_filter = left(ls_filter, len(ls_filter) - len(ls_AND))
	
	//Version filter
	if cbx_current_version.checked then
		if len(ls_filter) = 0 then
			ls_filter = "release_version like '" + sle_version.text + "%'"
		else
			ls_filter += " and release_version like'" + sle_version.text + "%'"
		end if
	end if
//Or not filter out all change request
else
	ls_filter = " 1=2 "
end if

//Execute change request list filter action
wf_filter(ls_filter)

st_footer.text = "Estimated man-hrs: "  + dw_list.describe("Evaluate('sum(est_hrs_min for all)',0)") + &
					  " to " + dw_list.describe("Evaluate('sum( est_hrs_max for all)',0)") 
st_rows.text = string(dw_list.rowcount(), "#") + " Row(s)"

//group by project
_groupbyproject()

this.post setredraw(true)


end subroutine

public subroutine documentation ();/********************************************************************
   w_changerequest
   <OBJECT>		Change request maintenance	</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		04-08-2011	2438  		JMY014		First Version
		07-10-2011	2438  		AGL027		Remove existing sorting code and 
														apply multi column sort service instead
		23-08-2012	2917  		AGL027		Set priority changing onto business unit instead of Admin group
														Allow multiple column sorting
		19-06-2013	3267  		LGX001		FIX bug : All usd value fields that are EMPTY comes out on the export list as value 0.01. Obviously the value on the
														export sheet should be 0.00.
		10/07/2013	CR3254		LHG008		1. Change some functions access to private(function name prefixed _)
														2. Change display logic in Column Attachments
														3. Fix bug for change impl./prio.
		15/08/2013	CR3306		WWA048		Add new "Print Task" button in Task tab.
		30/08/2013	CR3147		ZSW001		In the report generated from the Change request module we should have "release date" included next to "release version". 
		                                   	Equally we should have a "created date" next to the "Created by".
		12/09/14  	CR3773		XSZ004		Change icon absolute path to reference path					
	</HISTORY>
********************************************************************/

end subroutine

public subroutine wf_selectall (u_datagrid adw_filter, checkbox acbx_selectall);/********************************************************************
   wf_selectall
   <DESC>	Change select all checkbox text and 
				filter change request report	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_filter: Filter datawindow
		acbx_selectall: checkbox for select all
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19-08-2011 2438         JMY014        First Version
   </HISTORY>
********************************************************************/
if acbx_selectall.checked then	
	acbx_selectall.text = "Deselect all"
else
	acbx_selectall.text = "Select all"
end if

acbx_selectall.textcolor = c#color.White

//Change the filter selection status
adw_filter.selectrow(0, acbx_selectall.checked)

//Generate filter constation
adw_filter.inv_filter_multirow.of_dofilter()

//Call combined filter condtions function for filtering on change request
wf_filter()
end subroutine

public subroutine wf_filter (string as_filter);/********************************************************************
   wf_filter
   <DESC>	Filter change request report, and initial description datawindow	</DESC>
   <RETURN>	(None):	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_filter: Fitler condition string
   </ARGS>
   <USAGE>	Deal with such exception:One filter is deselected all,
				filtered out all change request completely.
			</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	18-08-2011 CR2438       JMY014        First Version
		19-02-2013 CR2614			LHC010
   </HISTORY>
********************************************************************/

long ll_row, ll_requestid

ll_row = dw_list.getselectedrow(0)

if ll_row > 0 then
	//get the selected row
elseif dw_list.rowcount( ) > 0 then
	ll_row = 1
end if

if ll_row > 0 then
	ll_requestid = dw_list.getitemnumber(ll_row, "request_id")
end if

//Filter report
dw_list.setfilter(as_filter)
dw_list.filter()

dw_list.sort()

//Highlight CR and retrieve the CR's description
post _highlightcr(ll_requestid)

end subroutine

public function boolean wf_filter (u_datagrid adw_filter, ref string as_filter);/********************************************************************
   wf_filter
   <DESC>	Generate filter condition string	</DESC>
   <RETURN>	boolean:
            <LI> True, Filter has filter condition
            <LI> False, Fitler has no filter condition	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_filter: Filter datawindow
		as_filter:	Filter condition string
   </ARGS>
   <USAGE> as_filter is a reference type value	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19-08-2011 2438         JMY014        First Version
   </HISTORY>
********************************************************************/
string	ls_filter_temp

ls_filter_temp = adw_filter.inv_filter_multirow.of_getfilter()
if len(ls_filter_temp) > 0 then 
	as_filter += ls_filter_temp + " and "
else
	return false
end if
return true
end function

private function integer _initparm ();/********************************************************************
   _initparm
   <DESC>	get the filter condition and parameter values </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	windows open	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-12-2012 2614         LHC010        First Version
   </HISTORY>
********************************************************************/

//get the user's filter option
if ids_useroption.rowcount() = 1 then
	is_type_selection	 		= ids_useroption.getitemstring(1, "creq_type_selection")              																																									
	is_sub_module_selection	= ids_useroption.getitemstring(1, "creq_sub_module_selection")
	is_status_selection	 	= ids_useroption.getitemstring(1, "creq_status_selection")
	ii_show_selection	 		= ids_useroption.getitemnumber(1, "creq_show_selection")
	is_owner_selection	 	= ids_useroption.getitemstring(1, "creq_owner_selection")
	is_module_selection	 	= ids_useroption.getitemstring(1, "creq_module_selection")
	is_list_sorting	 	 	= ids_useroption.getitemstring(1, "creq_list_sorting")
	is_search_selection		= ids_useroption.getitemstring(1, "creq_search_selection")	
	is_business_unit_selection		= ids_useroption.getitemstring(1, "creq_business_unit_selection")
	is_assignto							= ids_useroption.getitemstring(1, "creq_assigned_to_selection")
	ii_groupbyproject_selection 	= ids_useroption.getitemnumber(1, "creq_groupbyproject_selection")
	ii_showcurrentver_selection 	= ids_useroption.getitemnumber(1, "creq_showcurrentver_selection")
	
	is_tablesort =	is_list_sorting
end if

//highlight rows
_selectedfilterrow(dw_businessunit, is_business_unit_selection, "bu_id")
_selectedfilterrow(dw_module, is_module_selection, "module_id")
_selectedfilterrow(dw_submodule, is_sub_module_selection, "submodule_id", true)
_selectedfilterrow(dw_status, is_status_selection, "status_id")
_selectedfilterrow(dw_type, is_type_selection, "type_id")

dw_assignto.setitem( 1, "assign_to", is_assignto)
uo_filter_owner.dw_user.setitem(1, "userid", is_owner_selection)
uo_filter_owner.of_setuserid(is_owner_selection)
is_userid = is_owner_selection

if ii_groupbyproject_selection > 0 then 
	cbx_groupby.checked = true
	dw_list.ib_sortbygroup = cbx_groupby.checked
end if

if ii_showcurrentver_selection > 0 then 
	cbx_current_version.checked = true
	sle_version.text = is_currentversion
	sle_version.enabled = true
end if

sle_search.text = is_search_selection

if len(is_list_sorting) > 0 then
	dw_list.Modify("DataWindow.Table.Sort='" + is_list_sorting + "'")
end if

choose case ii_show_selection
	case 0 // all
		uo_filter_show.rb_all.checked = true;
		uo_filter_show.rb_all.triggerevent(clicked!)
	case 1 // my
		uo_filter_show.rb_my.checked = true;
		uo_filter_show.rb_my.triggerevent(clicked!)
	case 2 // my bu's
		uo_filter_show.rb_bu.checked = true;
		uo_filter_show.rb_bu.triggerevent(clicked!)
end choose

//retrieve workflow status data
istr_parms.ds_typestatus = create mt_n_datastore
istr_parms.ds_typestatus.dataobject = "d_sq_gr_typestatus"
istr_parms.ds_typestatus.settransobject(sqlca)
istr_parms.ds_typestatus.retrieve( )

return c#return.NoAction
end function

private function integer _savefilter ();/********************************************************************
   _savefilter
   <DESC>	save user's filter option	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16-01-2013 2614         LHC010        First Version
   </HISTORY>
********************************************************************/

string	ls_type_selection
string	ls_sub_module_selection
string	ls_status_selection
integer	li_show_selection, li_row, li_groupbyproject_selection, li_showcurrentver_selection
string	ls_owner_selection
string	ls_module_selection
string	ls_list_sorting
string	ls_business_unit_selection
string	ls_assigned_to_selection
string	ls_search_selection

//generate the filter option according to the highlight rows
dw_businessunit.of_get_selectedvalues( "bu_id", ls_business_unit_selection, is_DELIMITER)
dw_module.of_get_selectedvalues( "module_id", ls_module_selection, is_DELIMITER)
dw_submodule.of_get_selectedvalues( "submodule_id", ls_sub_module_selection, is_DELIMITER, true)
dw_status.of_get_selectedvalues( "status_id", ls_status_selection, is_DELIMITER)
dw_type.of_get_selectedvalues( "type_id", ls_type_selection, is_DELIMITER)

ls_assigned_to_selection = dw_assignto.getitemstring( 1, "assign_to")
ls_search_selection = trim(sle_search.text)
ls_owner_selection = uo_filter_owner.dw_user.getitemstring(1, "userid")

if cbx_groupby.checked then li_groupbyproject_selection = 1
if cbx_current_version.checked then  li_showcurrentver_selection = 1

ls_list_sorting = dw_list.Object.DataWindow.Table.Sort

if uo_filter_show.rb_all.checked then
	li_show_selection = 0 
elseif uo_filter_show.rb_my.checked then
	li_show_selection = 1
elseif uo_filter_show.rb_bu.checked then
	li_show_selection = 2
end if

if ids_useroption.rowcount() <= 0 then
	li_row = ids_useroption.insertrow(0)
	ids_useroption.setitem(li_row, "userid", uo_global.is_userid)
else
	li_row = ids_useroption.rowcount()
end if

ids_useroption.setitem(li_row, "creq_type_selection", ls_type_selection)              																																									
ids_useroption.setitem(li_row, "creq_sub_module_selection", ls_sub_module_selection)
ids_useroption.setitem(li_row, "creq_status_selection", ls_status_selection)
ids_useroption.setitem(li_row, "creq_show_selection", li_show_selection)
ids_useroption.setitem(li_row, "creq_owner_selection", ls_owner_selection)
ids_useroption.setitem(li_row, "creq_module_selection", ls_module_selection)
ids_useroption.setitem(li_row, "creq_list_sorting", ls_list_sorting)
ids_useroption.setitem(li_row, "creq_business_unit_selection", ls_business_unit_selection)
ids_useroption.setitem(li_row, "creq_assigned_to_selection", ls_assigned_to_selection)
ids_useroption.setitem(li_row, "creq_search_selection", ls_search_selection)
ids_useroption.setitem(li_row, "creq_groupbyproject_selection", li_groupbyproject_selection)
ids_useroption.setitem(li_row, "creq_showcurrentver_selection", li_showcurrentver_selection)

if ids_useroption.update( ) = 1 then
	commit;
	return c#return.Success
else
	rollback;
	return c#return.Failure
end if

return c#return.Noaction
end function

private subroutine _show_implorprio (string as_implorprio);/********************************************************************
   _show_implorprio
   <DESC> Adjust the dw_list UI, show and control the column 'Impl' or 'Prio.'</DESC>
   <RETURN>	None </RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		string:	"Impl" or other string 
   </ARGS>
   <USAGE>	
				1. window open
				2. dw_status clicked event
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	17-12-2012 2614         LHC010        First Version
   </HISTORY>
********************************************************************/
string ls_syntax
string ls_impl_x
long ll_selectrow, ll_statusid, ll_returnrow
//return
dw_list.of_ignoreredraw( true )
dw_list.of_setallcolumnsresizable(true)
dw_list.of_setcolumnorder()
dw_list.of_setallcolumnsresizable(false) 


if as_implorprio = is_IMPL then
	ls_syntax = "bu_seq.visible='0' bu_seq_t.visible='0' impl_seq.visible='1' impl_seq_t.visible='1'"
else
	ls_syntax = "bu_seq.visible='1' bu_seq_t.visible='1' impl_seq.visible='0' impl_seq_t.visible='0'"	
end if

if this.title = is_TECHNICALTITLE then
	ls_syntax = "impl_seq.visible='0' bu_seq.visible='0' bu_name.visible='0' name.visible='0' assigned_to.visible='0' " &
		+ "dev_priority.visible='1' devstatus.visible='1' delivered_date.visible='1' dev_branch.visible='1'" + " " + ls_syntax
else
	ls_syntax = "dev_priority.visible='0' devstatus.visible='0' delivered_date.visible='0' dev_branch.visible='0'" + " " + ls_syntax
end if

dw_list.modify(ls_syntax)

dw_list.settaborder("bu_seq", 0)
dw_list.settaborder("impl_seq", 0)	

ll_selectrow = dw_status.getselectedrow(0)

if ll_selectrow > 0 then
	ll_statusid = dw_status.getitemnumber(ll_selectrow, "status_id")
	ll_returnrow = dw_status.of_getnumberofselectedrows( )
	
	//change request order can be changed when only one row is selected and status is (32:business reviewed or 14:quened)
	if ll_returnrow = 1 then
		if ii_bu_setpriority = 1 and ll_statusid = il_BU_REVIEWED_STATUS then dw_list.settaborder("bu_seq", 10)

		if ii_bu_setimpl = 1 and ll_statusid = il_QUEUED_STATUS then dw_list.settaborder("impl_seq", 10)	
	end if	
end if

dw_list.of_ignoreredraw( false )


end subroutine

private subroutine _groupbyproject ();/********************************************************************
   _groupbyproject
   <DESC></DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS>private</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-05-2013 CR2614       LHC010        First Version
   </HISTORY>
********************************************************************/

string ls_sortstring, ls_tablesort
long	ll_selectrow, ll_requestid

ll_selectrow = dw_list.getselectedrow(0)

if ll_selectrow > 0 then
	ll_requestid = dw_list.getitemnumber(ll_selectrow, "request_id")
end if

if isnull(is_tablesort) or len(is_tablesort) <= 0 then 
	ls_sortstring = "request_id D"
else
	ls_sortstring = is_tablesort
end if

if pos(ls_sortstring, "request_id D") <= 0 then ls_sortstring += ", request_id D"

dw_list.modify("project_name.visible=1 project_name.x='0~t15' project_name.width='329~t1300'")
if cbx_groupby.checked then
	dw_list.modify("DataWindow.Header.1.Height = '64' DataWindow.Grid.Lines=1")
	ls_sortstring = "project_name A, " + ls_sortstring
else
	dw_list.modify("DataWindow.Header.1.Height = '0' DataWindow.Grid.Lines=0")
end if

if len(is_statussort) > 0 then ls_sortstring = is_statussort

dw_list.setsort(ls_sortstring)
dw_list.sort( )
dw_list.groupcalc( )

if ll_requestid > 0  then
	_highlightcr(ll_requestid)
end if

end subroutine

private function integer _datamodified (string as_message);/********************************************************************
   _datamodified
   <DESC> if dw_list is changed then show messagebox	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_message : message string
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16-01-2013 2614         LHC010        First Version
   </HISTORY>
********************************************************************/

if dw_list.modifiedcount( ) > 0 then
	Messagebox("Info", as_message)
	return c#return.failure
end if
Return c#return.Success
end function

private subroutine _highlightcr (long al_requestid);/********************************************************************
   _highlightcr
   <DESC> Highlight the CR  </DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_requestid
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19-02-2013 CR2614       LHC010        First Version
   </HISTORY>
********************************************************************/

long ll_found

if isnull(al_requestid) or al_requestid <= 0 then return 

ll_found = dw_list.find("request_id =" + string(al_requestid), 1, dw_list.rowcount())

if ll_found > 0 then
	//highlight the finded row
elseif dw_list.rowcount() > 0 then 
	ll_found = 1
	al_requestid = dw_list.getitemnumber(ll_found, "request_id")
end if

if ll_found > 0 then
	dw_list.setrow(ll_found)
	dw_list.scrolltorow(ll_found)
	dw_list.selectrow(0, false)
	dw_list.selectrow(ll_found, true)
	dw_request.retrieve(al_requestid)
end if

end subroutine

private subroutine _selectedfilterrow (u_datagrid adw_source, string as_filter, string as_column);/********************************************************************
   _selectedfilterrow
   <DESC>	</DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		adw_source
		as_filter
		as_column
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16-01-2013 2614         LHC010        First Version
   </HISTORY>
********************************************************************/

_selectedfilterrow(adw_source, as_filter, as_column, false)
end subroutine

private subroutine _selectedfilterrow (u_datagrid adw_source, string as_filter, string as_column, boolean ab_includenull);/********************************************************************
   _selectedfilterrow
   <DESC>	select rows according to filter option  </DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		adw_source
		as_filter
		as_column
		ab_includenull: true->replace filter option with 'isnull()' if filter option includes 'null'
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16-01-2013 2614         LHC010        First Version
   </HISTORY>
********************************************************************/
long	ll_pos
constant string ls_NULLCOMMA = "null,"
constant string ls_COMMANULL = ",null"

if isnull(as_filter) or len(as_filter) <= 0 then 
	as_filter = "" 
elseif as_filter = "null" then
	as_filter = "isnull(" + as_column + ")"
else
	//replace filter option with 'isnull()' if filter option includes 'null'
	if ab_includenull then
		ll_pos = pos(as_filter, ls_NULLCOMMA)
		if ll_pos > 0 then as_filter = replace(as_filter, ll_pos, len(ls_NULLCOMMA), "")
		
		ll_pos = pos(as_filter, ls_COMMANULL)
		if ll_pos > 0 then as_filter = replace(as_filter, ll_pos, len(ls_COMMANULL), "")
		
		if len(as_filter) > 0 then as_filter = "isnull(" + as_column + ") or " + as_column + " in(" + as_filter +  ")"
	else
		as_filter = as_column + " in(" + as_filter +  ")"	
	end if
end if

adw_source.setfilter(as_filter)
adw_source.filter()

adw_source.selectrow(0, true)

adw_source.setfilter("")
adw_source.filter()
end subroutine

on w_changerequest.create
int iCurrent
call super::create
this.cb_switchview=create cb_switchview
this.dw_export=create dw_export
this.sle_version=create sle_version
this.st_descript=create st_descript
this.dw_type=create dw_type
this.cbx_groupby=create cbx_groupby
this.uo_filter_owner=create uo_filter_owner
this.st_owner=create st_owner
this.dw_submodule=create dw_submodule
this.cbx_selectall_submodule=create cbx_selectall_submodule
this.cbx_selectall_businessunit=create cbx_selectall_businessunit
this.dw_businessunit=create dw_businessunit
this.cb_saveas=create cb_saveas
this.dw_assignto=create dw_assignto
this.dw_module=create dw_module
this.st_assignto=create st_assignto
this.gb_module=create gb_module
this.cbx_selectall_module=create cbx_selectall_module
this.dw_status=create dw_status
this.pb_search=create pb_search
this.st_search=create st_search
this.gb_status=create gb_status
this.sle_search=create sle_search
this.uo_filter_show=create uo_filter_show
this.cb_print=create cb_print
this.cb_modify=create cb_modify
this.cb_new=create cb_new
this.cb_print_list=create cb_print_list
this.cb_save=create cb_save
this.cb_refresh=create cb_refresh
this.dw_request=create dw_request
this.dw_list=create dw_list
this.cbx_selectall_status=create cbx_selectall_status
this.gb_type=create gb_type
this.gb_businessunit=create gb_businessunit
this.gb_submodule=create gb_submodule
this.st_banner=create st_banner
this.st_footer=create st_footer
this.st_rows=create st_rows
this.cbx_current_version=create cbx_current_version
this.ids_useroption=create ids_useroption
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_switchview
this.Control[iCurrent+2]=this.dw_export
this.Control[iCurrent+3]=this.sle_version
this.Control[iCurrent+4]=this.st_descript
this.Control[iCurrent+5]=this.dw_type
this.Control[iCurrent+6]=this.cbx_groupby
this.Control[iCurrent+7]=this.uo_filter_owner
this.Control[iCurrent+8]=this.st_owner
this.Control[iCurrent+9]=this.dw_submodule
this.Control[iCurrent+10]=this.cbx_selectall_submodule
this.Control[iCurrent+11]=this.cbx_selectall_businessunit
this.Control[iCurrent+12]=this.dw_businessunit
this.Control[iCurrent+13]=this.cb_saveas
this.Control[iCurrent+14]=this.dw_assignto
this.Control[iCurrent+15]=this.dw_module
this.Control[iCurrent+16]=this.st_assignto
this.Control[iCurrent+17]=this.gb_module
this.Control[iCurrent+18]=this.cbx_selectall_module
this.Control[iCurrent+19]=this.dw_status
this.Control[iCurrent+20]=this.pb_search
this.Control[iCurrent+21]=this.st_search
this.Control[iCurrent+22]=this.gb_status
this.Control[iCurrent+23]=this.sle_search
this.Control[iCurrent+24]=this.uo_filter_show
this.Control[iCurrent+25]=this.cb_print
this.Control[iCurrent+26]=this.cb_modify
this.Control[iCurrent+27]=this.cb_new
this.Control[iCurrent+28]=this.cb_print_list
this.Control[iCurrent+29]=this.cb_save
this.Control[iCurrent+30]=this.cb_refresh
this.Control[iCurrent+31]=this.dw_request
this.Control[iCurrent+32]=this.dw_list
this.Control[iCurrent+33]=this.cbx_selectall_status
this.Control[iCurrent+34]=this.gb_type
this.Control[iCurrent+35]=this.gb_businessunit
this.Control[iCurrent+36]=this.gb_submodule
this.Control[iCurrent+37]=this.st_banner
this.Control[iCurrent+38]=this.st_footer
this.Control[iCurrent+39]=this.st_rows
this.Control[iCurrent+40]=this.cbx_current_version
end on

on w_changerequest.destroy
call super::destroy
destroy(this.cb_switchview)
destroy(this.dw_export)
destroy(this.sle_version)
destroy(this.st_descript)
destroy(this.dw_type)
destroy(this.cbx_groupby)
destroy(this.uo_filter_owner)
destroy(this.st_owner)
destroy(this.dw_submodule)
destroy(this.cbx_selectall_submodule)
destroy(this.cbx_selectall_businessunit)
destroy(this.dw_businessunit)
destroy(this.cb_saveas)
destroy(this.dw_assignto)
destroy(this.dw_module)
destroy(this.st_assignto)
destroy(this.gb_module)
destroy(this.cbx_selectall_module)
destroy(this.dw_status)
destroy(this.pb_search)
destroy(this.st_search)
destroy(this.gb_status)
destroy(this.sle_search)
destroy(this.uo_filter_show)
destroy(this.cb_print)
destroy(this.cb_modify)
destroy(this.cb_new)
destroy(this.cb_print_list)
destroy(this.cb_save)
destroy(this.cb_refresh)
destroy(this.dw_request)
destroy(this.dw_list)
destroy(this.cbx_selectall_status)
destroy(this.gb_type)
destroy(this.gb_businessunit)
destroy(this.gb_submodule)
destroy(this.st_banner)
destroy(this.st_footer)
destroy(this.st_rows)
destroy(this.cbx_current_version)
destroy(this.ids_useroption)
end on

event open;call super::open;n_dw_style_service   lnv_style

dw_list.settransobject(sqlca)
dw_request.settransobject(sqlca)

SELECT TRAMOS_VERSION.CURRENT_VERSION
INTO :is_currentversion
FROM TRAMOS_VERSION;

_initparm()

inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_list, false)

//Initial filter condition
dw_businessunit.inv_filter_multirow.of_dofilter()
dw_module.inv_filter_multirow.of_dofilter()
dw_submodule.inv_filter_multirow.of_dofilter()
dw_status.inv_filter_multirow.of_dofilter()
dw_type.inv_filter_multirow.of_dofilter()

postevent("ue_postopen")


end event

event ue_addignoredcolorandobject;call super::ue_addignoredcolorandobject;anv_guistyle.of_addignoredobject(cbx_selectall_status)
anv_guistyle.of_addignoredobject(cbx_selectall_module)
anv_guistyle.of_addignoredobject(cbx_selectall_businessunit)
anv_guistyle.of_addignoredobject(cbx_selectall_submodule)
anv_guistyle.of_addignoredobject(uo_filter_show.gb_show)
anv_guistyle.of_addignoredobject(uo_filter_show.rb_my)
anv_guistyle.of_addignoredobject(uo_filter_show.rb_all)
anv_guistyle.of_addignoredobject(uo_filter_show.rb_bu)

end event

event activate;call super::activate;if w_tramos_main.MenuName <> "m_creqmain" then
	w_tramos_main.ChangeMenu(m_creqmain)
end if

m_creqmain.mf_controlreport()

m_creqmain.m_menutop2.m_savefilter.visible = true
m_creqmain.m_menutop2.m_savefilter.toolbaritemvisible = true

if this.title = is_TECHNICALTITLE then
	m_creqmain.m_menutop2.m_savefilter.enabled = false
else
	m_creqmain.m_menutop2.m_savefilter.enabled = true
end if

end event

event deactivate;call super::deactivate;if w_tramos_main.MenuName = "m_creqmain" then
	m_creqmain.m_menutop2.m_savefilter.visible = false
	m_creqmain.m_menutop2.m_savefilter.toolbaritemvisible = false
end if

end event

event key;call super::key;graphicobject	lgo_focus

//If the current input places the cursor in the version, ignoring the default button functions
if key = keyenter! then
	lgo_focus = getfocus()
	choose case lgo_focus.classname() 
		case 'sle_version'
			ib_ignoredefaultbutton = true
			wf_filter()
		case 'dw_list'
			ib_ignoredefaultbutton = true
			dw_list.accepttext()
	end choose
end if 
end event

type cb_switchview from mt_u_commandbutton within w_changerequest
boolean visible = false
integer x = 2825
integer y = 2364
integer taborder = 230
string text = "Switch &View"
end type

event clicked;call super::clicked;string	ls_exp

w_changerequest.setredraw(false)

dw_list.of_ignoreredraw( true )
dw_list.of_setallcolumnsresizable(true)
dw_list.of_setcolumnorder()
dw_list.of_setallcolumnsresizable(false) 

if parent.title = is_NORMALTITLE then
	parent.title = is_TECHNICALTITLE
	st_descript.text = "Technical Description:"
	dw_request.modify("tech_desc.visible='1' problem_desc.visible='0'")
	m_creqmain.m_menutop2.m_savefilter.enabled = false
	
	ls_exp = "impl_seq.visible='1' impl_seq_t.visible='1' bu_seq.visible='0' bu_name.visible='0' name.visible='0' assigned_to.visible='0' " &
		+ "dev_priority.visible='1' devstatus.visible='1' delivered_date.visible='1' dev_branch.visible='1' p_attach.visible='1~tif (dev_attachment = 0, 0, 1)'"	
	
	ls_exp += " release_date.x = " + string(long(dw_list.describe("release_version.x")) + long(long(dw_list.describe("release_version.width")) / 2))
else
	parent.title = is_NORMALTITLE
	st_descript.text = "Problem Description:"
	dw_request.modify("tech_desc.visible='0' problem_desc.visible='1'")
	m_creqmain.m_menutop2.m_savefilter.enabled = true
	
	ls_exp = "impl_seq.visible='1' bu_seq.visible='1' bu_name.visible='1' name.visible='1' assigned_to.visible='1' " &
		+ "dev_priority.visible='0' devstatus.visible='0' delivered_date.visible='0' dev_branch.visible='0' p_attach.visible='1~tif (creq_att_attachment = 0, 0, 1)'"
end if

dw_list.modify(ls_exp)

_groupbyproject()

dw_list.of_ignoreredraw(false)

IF parent.title = is_NORMALTITLE then
	dw_status.event clicked(0, 0, 0, dw_status.object)
end if

w_changerequest.post setredraw(true)


end event

type dw_export from mt_u_datawindow within w_changerequest
boolean visible = false
integer x = 1961
integer y = 1104
integer taborder = 190
string dataobject = "d_sq_gr_export_request"
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

type sle_version from mt_u_singlelineedit within w_changerequest
integer x = 3602
integer y = 128
integer width = 293
integer height = 56
integer taborder = 110
boolean enabled = false
string text = ""
boolean border = false
borderstyle borderstyle = stylebox!
end type

type st_descript from mt_u_statictext within w_changerequest
integer x = 55
integer y = 1832
integer width = 1481
integer height = 48
string text = "Problem Description:"
end type

type dw_type from u_datagrid within w_changerequest
integer x = 3186
integer y = 80
integer width = 256
integer height = 448
integer taborder = 90
string dataobject = "d_dddw_type"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve( )

lstr_module.self_dw = dw_type
lstr_module.self_column_name = 'type_id'       // The column name is getitem column name.
lstr_module.report_column_name = 'type_id'

this.inv_filter_multirow.of_register( lstr_module )
end event

event clicked;call super::clicked;wf_filter()
end event

event ue_hscroll;call super::ue_hscroll;return 1
end event

type cbx_groupby from mt_u_checkbox within w_changerequest
integer x = 3515
integer y = 224
integer width = 494
integer height = 56
integer taborder = 120
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Group by Project"
end type

event clicked;call super::clicked;parent.setredraw(false)
dw_list.ib_sortbygroup = this.checked
_groupbyproject()
parent.post setredraw(true)
end event

type uo_filter_owner from u_user within w_changerequest
integer x = 3799
integer y = 348
integer height = 56
integer taborder = 140
end type

event constructor;of_setuserid(uo_global.is_userid)
of_getuser()
end event

on uo_filter_owner.destroy
call u_user::destroy
end on

type st_owner from mt_u_statictext within w_changerequest
integer x = 3511
integer y = 348
integer width = 274
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Owner"
alignment alignment = right!
end type

type dw_submodule from u_datagrid within w_changerequest
integer x = 1627
integer y = 80
integer width = 677
integer height = 448
integer taborder = 60
string dataobject = "d_dddw_submodule"
boolean vscrollbar = true
boolean border = false
boolean ib_multirow = true
end type

event clicked;call super::clicked;wf_filter()
end event

event constructor;call super::constructor;integer li_submodule_id
s_filter_multirow lstr_module

//Initial a empty row for sub module
this.retrieve(0)
this.insertrow(1)
setnull(li_submodule_id)
this.setitem(1, "submodule_id", li_submodule_id)
this.setitem(1, "sub_module_desc", "<Empty...>")
this.setitem(1, "sub_module_active", 1)

lstr_module.self_dw = this
lstr_module.self_column_name = 'submodule_id'       // The column name is getitem column name.
lstr_module.report_column_name = 'submodule_id'
lstr_module.include_null = true

this.inv_filter_multirow.of_register( lstr_module )


end event

event ue_hscroll;call super::ue_hscroll;return 1
end event

type cbx_selectall_submodule from mt_u_checkbox within w_changerequest
integer x = 1993
integer y = 16
integer width = 329
integer height = 56
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Deselect all"
boolean checked = true
end type

event clicked;call super::clicked;wf_selectall(dw_submodule, this)
end event

type cbx_selectall_businessunit from mt_u_checkbox within w_changerequest
integer x = 439
integer y = 16
integer width = 329
integer height = 56
integer taborder = 10
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Deselect all"
boolean checked = true
end type

event clicked;call super::clicked;wf_selectall(dw_businessunit, this)

end event

type dw_businessunit from u_datagrid within w_changerequest
integer x = 73
integer y = 80
integer width = 677
integer height = 448
integer taborder = 20
string dataobject = "d_dddw_businessunit"
boolean vscrollbar = true
boolean border = false
boolean ib_multirow = true
end type

event clicked;call super::clicked;wf_filter()
end event

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve( )

lstr_module.self_dw = dw_businessunit
lstr_module.self_column_name = 'bu_id'       // The column name is getitem column name.
lstr_module.report_column_name = 'bu_id'

this.inv_filter_multirow.of_register( lstr_module )
end event

event ue_hscroll;call super::ue_hscroll;return 1
end event

type cb_saveas from mt_u_commandbutton within w_changerequest
integer x = 3867
integer y = 2364
integer taborder = 260
string text = "&Save As..."
end type

event clicked;call super::clicked;long		ll_requestid[], ll_rows
n_dataexport	lnv_dataexport


ll_rows = dw_list.rowcount()

if ll_rows > 0 then
	if parent.title = is_TECHNICALTITLE then
		lnv_dataexport.of_export(dw_list)
	else
		ll_requestid = dw_list.Object.request_id.primary
		if dw_export.retrieve(ll_requestid) > 0 then
			dw_export.setsort(dw_list.describe("datawindow.table.sort"))
			dw_export.sort()
			dw_export.saveas("", Excel8!, true)
		end if
	end if
end if
end event

type dw_assignto from mt_u_datawindow within w_changerequest
integer x = 3799
integer y = 428
integer width = 759
integer height = 56
integer taborder = 150
string dataobject = "d_ff_ex_assignto"
boolean border = false
end type

event constructor;call super::constructor;datawindowchild ldwc

this.getchild("assign_to", ldwc)
ldwc.settransobject(sqlca)
ldwc.retrieve()

end event

event editchanged;call super::editchanged;this.accepttext( )
is_assignto = data
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_assignto)

end event

event itemchanged;call super::itemchanged;//Saving assign to
is_assignto = data
if isnull(is_assignto) then is_assignto = ""

wf_filter()
end event

type dw_module from u_datagrid within w_changerequest
integer x = 850
integer y = 80
integer width = 677
integer height = 448
integer taborder = 40
string dataobject = "d_dddw_module"
boolean vscrollbar = true
boolean border = false
boolean ib_multirow = true
end type

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve( )

lstr_module.self_dw = dw_module
lstr_module.self_column_name = 'module_id'       // The column name is getitem column name.
lstr_module.cascade_dw[1] = dw_submodule     // The datawinodw is cascade datawindow.
lstr_module.cascade_column_name[1] = 'module_id'  // The column name is filter cascade datawindow column name.
lstr_module.report_column_name = 'module_id'

this.inv_filter_multirow.of_register( lstr_module )

end event

event clicked;call super::clicked;if row <= 0 then return

//Generate filter constation
dw_module.inv_filter_multirow.of_dofilter()

wf_filter()
end event

event ue_hscroll;call super::ue_hscroll;return 1
end event

type st_assignto from mt_u_statictext within w_changerequest
integer x = 3511
integer y = 428
integer width = 274
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Assigned To"
alignment alignment = right!
end type

type gb_module from mt_u_groupbox within w_changerequest
integer x = 814
integer y = 16
integer width = 754
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Module"
end type

type cbx_selectall_module from mt_u_checkbox within w_changerequest
integer x = 1216
integer y = 16
integer width = 329
integer height = 56
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Deselect all"
boolean checked = true
end type

event clicked;call super::clicked;wf_selectall(dw_module, this)
end event

type dw_status from u_datagrid within w_changerequest
integer x = 2409
integer y = 80
integer width = 677
integer height = 448
integer taborder = 80
string dataobject = "d_dddw_status"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multirow = true
end type

event clicked;call super::clicked;long ll_selectrow, ll_statusid, ll_returnrow
blob lbb_full

//if row <= 0 then return

//Generate filter constation
dw_status.inv_filter_multirow.of_dofilter()

parent.setredraw(false)

wf_filter()

ll_selectrow = this.getselectedrow(0)

if ll_selectrow > 0 then
	ll_statusid = this.getitemnumber(ll_selectrow,"status_id")
	ll_returnrow = this.of_getnumberofselectedrows( )

	is_statussort = ""
	
	if ll_returnrow = 1 then
		choose case ll_statusid
			case il_BU_REVIEWED_STATUS //if Selected one row and status = business reviewed
				_show_implorprio(is_NOTIMPL)
				is_statussort = "bu_seq A"				
			case il_QUEUED_STATUS
				_show_implorprio(is_IMPL)
				is_statussort = "impl_seq A"
			case else //if Selected one row and status <> business reviewed
				_show_implorprio(is_IMPL)
		end choose
	else
		_show_implorprio(is_IMPL)
	end if
	_groupbyproject()
end if

parent.post setredraw(true)

end event

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve( )

lstr_module.self_dw = dw_status
lstr_module.self_column_name = 'status_id'       // The column name is getitem column name.
lstr_module.report_column_name = 'status_id'


this.inv_filter_multirow.of_register( lstr_module )
end event

event ue_hscroll;call super::ue_hscroll;return 1
end event

type pb_search from picturebutton within w_changerequest
integer x = 4485
integer y = 504
integer width = 73
integer height = 64
integer taborder = 170
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean default = true
string picturename = "BrowseClasses!"
alignment htextalign = left!
end type

event clicked;long ll_requestid, ll_row, ll_findrow, ll_countrows

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

parent.setredraw(false)

ll_row = dw_list.getselectedrow(0)
if ll_row > 0 then
	ll_requestid = dw_list.getitemnumber(ll_row, "request_id")
end if

if len(trim(sle_search.text)) > 0 then
	ll_countrows = dw_list.retrieve("%" + sle_search.text + "%")
else
	ll_countrows = dw_list.retrieve("%")
end if	

if ll_countrows > 0 then
	ll_findrow = dw_list.find("request_id =" + string(ll_requestid), 1, ll_countrows)
	if ll_findrow > 0 then 
		dw_list.selectrow(0, false)
		dw_list.selectrow(ll_findrow, true)
	end if
end if
	
wf_filter()
parent.post setredraw(true)

end event

type st_search from statictext within w_changerequest
integer x = 3511
integer y = 508
integer width = 274
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Search"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_status from mt_u_groupbox within w_changerequest
integer x = 2368
integer y = 16
integer width = 754
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Status"
end type

type sle_search from mt_u_singlelineedit within w_changerequest
integer x = 3799
integer y = 508
integer width = 690
integer height = 56
integer taborder = 160
string text = ""
boolean border = false
end type

type uo_filter_show from u_filter_show within w_changerequest
integer x = 4110
integer y = 16
integer width = 457
integer height = 320
integer taborder = 130
long backcolor = 553648127
end type

on uo_filter_show.destroy
call u_filter_show::destroy
end on

type cb_print from mt_u_commandbutton within w_changerequest
integer x = 4215
integer y = 2364
integer taborder = 270
string text = "Print &CR"
end type

event clicked;call super::clicked;long		ll_row
string	ls_request_id

ll_row = dw_list.getselectedrow(0)
if ll_row <= 0 then return

ls_request_id = string(dw_list.getItemNumber(ll_row, "request_id"))

opensheetwithparm(w_print_request, ls_request_id, parent.parentWindow(), 5, Original!)
dw_list.POST setfocus()
end event

type cb_modify from mt_u_commandbutton within w_changerequest
integer x = 3520
integer y = 2364
integer taborder = 250
string text = "&Open CR"
end type

event clicked;call super::clicked;long	ll_row

ll_row = dw_list.getselectedrow( 0 )
if ll_row < 1 then return

istr_parms.request_id = dw_list.getItemNumber(ll_row, "request_id")
istr_parms.operation = "modify"

if isvalid(w_modify_changerequest) then
	w_modify_changerequest.bringtotop = true
	if w_modify_changerequest.event closequery() = 0 then
		message.powerobjectparm = istr_parms
		w_modify_changerequest.event open()
	end if
else
	opensheetwithparm(w_modify_changerequest, istr_parms, parent.parentwindow(), 5, original!)
end if
end event

type cb_new from mt_u_commandbutton within w_changerequest
integer x = 3173
integer y = 2364
integer taborder = 240
string text = "&New CR"
end type

event clicked;call super::clicked;if uo_global.ii_access_level < 0 then	/* External APM and External Other no access */
	messagebox("Infomation","As an external user you do not have access to this functionality.")
	return
end if

istr_parms.operation = "new"

if isvalid(w_modify_changerequest) then
	w_modify_changerequest.bringtotop = true
	if w_modify_changerequest.event closequery() = 0 then
		message.powerobjectparm = istr_parms
		w_modify_changerequest.event open()
	end if
else
	opensheetwithparm(w_modify_changerequest, istr_parms, parent.parentwindow(), 5, original!)
end if
end event

type cb_print_list from mt_u_commandbutton within w_changerequest
integer x = 4215
integer y = 1768
integer taborder = 210
string text = "&Print List"
end type

event clicked;call super::clicked;mt_n_datastore lds_print
blob lblb_temp

if dw_list.rowcount() > 0 then
	lds_print = create mt_n_datastore
	lds_print.dataobject = dw_list.dataobject
	lds_print.settransobject(sqlca)
	
	dw_list.getfullstate(lblb_temp)
	lds_print.setfullstate(lblb_temp)
	
	lds_print.print()
	
	destroy lds_print
end if
end event

type cb_save from mt_u_commandbutton within w_changerequest
boolean visible = false
integer x = 3520
integer y = 1768
boolean enabled = false
string text = "&Update"
end type

event clicked;call super::clicked;dw_list.accepttext( )
if dw_list.modifiedcount( ) > 0 then
	if dw_list.update() = 1 then
		commit;
		messagebox("Confirmation","Saved sucessfully!")
		this.enabled = false
		//dw_list.retrieve("%")
	else
		rollback;
		dw_list.POST setFocus()
	end if
end if

end event

type cb_refresh from mt_u_commandbutton within w_changerequest
integer x = 3867
integer y = 1768
integer taborder = 200
string text = "Re&fresh"
end type

event clicked;call super::clicked;long ll_found
long ll_row, ll_request_id

ll_row = dw_list.getrow()

if ll_row > 0 then ll_request_id = dw_list.getitemnumber(ll_row, "request_id")

parent.event ue_refresh_all_rows( ll_request_id )

end event

type dw_request from mt_u_datawindow within w_changerequest
integer x = 37
integer y = 1900
integer width = 4521
integer height = 448
integer taborder = 220
string dataobject = "d_request_list_detail"
boolean border = false
end type

type dw_list from u_datagrid within w_changerequest
integer x = 37
integer y = 624
integer width = 4521
integer height = 1132
integer taborder = 180
string dataobject = "d_request_list"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
end type

event rowfocuschanged;If currentrow <= 0 then 
	dw_request.reset()
	Return
else
	setrow(currentrow)
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	dw_request.retrieve(getitemnumber(currentrow, "request_id"))
end if
end event

event doubleclicked;if row < 1 then return

cb_modify.triggerevent(clicked!)
end event

event ue_clicked;call super::ue_clicked;
if row = 0 then
	if dwo.type = "text" then this.event rowfocuschanged(this.getrow())
	
	is_tablesort = this.Object.DataWindow.Table.Sort
	//Don't want user to change column with manually
	// return 1
end if
if row > 0 then
	selectrow(0, false)
	selectrow(row, true)
	post event rowfocuschanged(row)
end if

end event

event retrieveend;call super::retrieveend;st_footer.text = "Estimated man-hrs: "  + dw_list.describe("Evaluate('sum(est_hrs_min for all)',0)") + &
					  " to " + dw_list.describe("Evaluate('sum( est_hrs_max for all)',0)")
st_rows.text = string(dw_list.rowcount(), "#") + " Row(s)"

end event

event itemchanged;call super::itemchanged;long ll_request_id
n_creq_request lnv_request

lnv_request = create n_creq_request

if dwo.name = "impl_seq" or dwo.name = 'bu_seq' then
	if isnumber(data) then
		this.of_ignoreredraw(true)
		ll_request_id = this.getitemnumber(row, "request_id")
		if lnv_request.of_modify_seq(ll_request_id, dwo.name, long(data)) = c#return.Success then
			parent.post event ue_refresh_all_rows(ll_request_id)
		end if
		this.of_ignoreredraw(false)
	else
		messagebox("Info", "Item '" + data + "' does not pass the validation test.")
		destroy n_creq_request
		return 1
	end if
end if

destroy n_creq_request
end event

event itemerror;call super::itemerror;return 2
end event

event losefocus;call super::losefocus;this.accepttext()
end event

type cbx_selectall_status from mt_u_checkbox within w_changerequest
integer x = 2775
integer y = 16
integer width = 329
integer height = 56
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Deselect all"
boolean checked = true
end type

event clicked;call super::clicked;parent.setredraw(false)
if this.checked then
	_show_implorprio(is_IMPL)
end if

wf_selectall(dw_status, this)
parent.post setredraw(true)


end event

type gb_type from groupbox within w_changerequest
integer x = 3150
integer y = 16
integer width = 329
integer height = 548
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Type"
end type

type gb_businessunit from mt_u_groupbox within w_changerequest
integer x = 37
integer y = 16
integer width = 754
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Business Unit"
end type

type gb_submodule from mt_u_groupbox within w_changerequest
integer x = 1591
integer y = 16
integer width = 754
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Sub Module"
end type

type st_banner from u_topbar_background within w_changerequest
integer width = 4590
integer height = 592
integer textsize = -10
end type

type st_footer from mt_u_statictext within w_changerequest
integer x = 55
integer y = 1768
integer width = 1481
integer height = 48
string text = ""
end type

type st_rows from mt_u_statictext within w_changerequest
integer x = 2962
integer y = 1768
integer width = 457
integer height = 52
string text = ""
end type

type cbx_current_version from mt_u_checkbox within w_changerequest
integer x = 3511
integer y = 32
integer width = 512
integer height = 64
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Show only version"
end type

event clicked;call super::clicked;if this.checked then 
	sle_version.text = is_currentversion
	sle_version.enabled = true
else
	sle_version.enabled = false
end if
wf_filter()
end event

type ids_useroption from mt_n_datastore within w_changerequest descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_creq_filter"
end type

on ids_useroption.create
call super::create
end on

on ids_useroption.destroy
call super::destroy
end on

event constructor;call super::constructor;this.settransobject(sqlca)
this.retrieve(uo_global.is_userid)
end event

