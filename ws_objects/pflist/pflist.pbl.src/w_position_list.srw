$PBExportHeader$w_position_list.srw
forward
global type w_position_list from w_tramos_container
end type
type uo_pcgroup from u_pcgroup within w_position_list
end type
type hpb_mail from hprogressbar within w_position_list
end type
type dw_mail_positions from mt_u_datawindow within w_position_list
end type
type cb_update from mt_u_commandbutton within w_position_list
end type
type cbx_profit from mt_u_checkbox within w_position_list
end type
type cb_delete from mt_u_commandbutton within w_position_list
end type
type cb_new from mt_u_commandbutton within w_position_list
end type
type cbx_showarea from mt_u_checkbox within w_position_list
end type
type cb_print from mt_u_commandbutton within w_position_list
end type
type cb_saveas from mt_u_commandbutton within w_position_list
end type
type cb_retrieve from mt_u_commandbutton within w_position_list
end type
type dw_mail_company from mt_u_datawindow within w_position_list
end type
type st_topbar_background from u_topbar_background within w_position_list
end type
type cb_cancel from mt_u_commandbutton within w_position_list
end type
type dw_fixture_subdata from u_popupdw within w_position_list
end type
type dw_position_list from u_datagrid within w_position_list
end type
type dw_mailpositions_html from mt_u_datawindow within w_position_list
end type
type cb_movecargo from commandbutton within w_position_list
end type
type dw_print from u_datagrid within w_position_list
end type
type cb_mailpositions from u_cb_option within w_position_list
end type
end forward

global type w_position_list from w_tramos_container
integer width = 6281
integer height = 3088
string title = "Position List"
string icon = "images\position_list.ico"
event ue_retrieve ( )
event ue_reload ( integer ai_pcgroup )
event type integer ue_update ( )
uo_pcgroup uo_pcgroup
hpb_mail hpb_mail
dw_mail_positions dw_mail_positions
cb_update cb_update
cbx_profit cbx_profit
cb_delete cb_delete
cb_new cb_new
cbx_showarea cbx_showarea
cb_print cb_print
cb_saveas cb_saveas
cb_retrieve cb_retrieve
dw_mail_company dw_mail_company
st_topbar_background st_topbar_background
cb_cancel cb_cancel
dw_fixture_subdata dw_fixture_subdata
dw_position_list dw_position_list
dw_mailpositions_html dw_mailpositions_html
cb_movecargo cb_movecargo
dw_print dw_print
cb_mailpositions cb_mailpositions
end type
global w_position_list w_position_list

type variables
mt_n_dddw_searchasyoutype inv_dddw_search

integer ii_pcgroup, ii_vposition, ii_dwheightorg, ii_prepcgroup, ii_newpcgroup
private boolean _ib_validcompanies = true

Private u_dddw_search iuo_dddw_search_charterer
Private u_dddw_search iuo_dddw_search_openport
Private u_dddw_search iuo_dddw_search_openportext
Private u_dddw_search iuo_dddw_search_vessel
Private u_dddw_search iuo_dddw_search_area
Private u_dddw_search iuo_dddw_search_cargo1
Private u_dddw_search iuo_dddw_search_cargo2
Private u_dddw_search iuo_dddw_search_cargo3
Private u_dddw_search iuo_dddw_search_status


string is_IMOMAIL, is_PUBLICMAIL
string is_sort, is_sort_temp, is_sort_pcnr, is_sort_area
CONSTANT STRING CRLF="~r~n"

mt_n_datastore	ids_wrong_mail_addresses
string	is_labeltext
n_messagebox inv_messagebox




end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_controlbutton (string as_datastatus)
public subroutine wf_dwgroupsetrow ()
public subroutine wf_setheaders (datawindow adw_object)
public function integer wf_validateupdate (long al_row)
public function integer wf_validate (ref integer ai_messagebutton)
public function integer wf_checkdatasave ()
public subroutine wf_setfindrow (long al_positionid, long al_rowid)
public function integer wf_checkdatasave (boolean ab_retrievenochange)
public subroutine of_sendmail (string as_email, mt_n_outgoingmail anv_mail, integer ai_pcgroup, integer ai_mailtype, string as_company, string as_contact, string as_mailtype, long al_id)
end prototypes

event ue_retrieve();/********************************************************************
   ue_retrieve()
   <DESC>  </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author             Comments
   	26/06/2013   CR3244       WWA048        		Duplicate the features specific to profit center group Crude to Nova
		02/11/2016   CR2001       KSH092					UI adjust
   </HISTORY>
********************************************************************/

int 							li_number
datetime						ldt_lastsent
long							ll_rows, ll_row, ll_positionid, ll_selectrow
integer						li_pcnr[], ll_rowcount
string						ls_lastsentby
datawindowchild			ldwc_vessel, ldwc_chart, ldwc_sharechart, ldwc_cargo1, ldwc_cargo2, ldwc_cargo3


// Remember currently selected ID
ll_selectrow = dw_position_list.Getselectedrow(0)
If ll_selectrow > 0 then ll_positionid = dw_position_list.GetItemNumber(ll_selectrow, "position_id")

if ii_pcgroup > 0 then
	SELECT LASTSENT, isnull(LASTSENT_BY,'')
	INTO :ldt_lastsent, :ls_lastsentby
	FROM PF_POSITIONEMAIL
	WHERE PCGROUP_ID = :ii_pcgroup and EMAIL_TYPE = 1;
	
	if sqlca.sqlcode = 0  then
		if isnull(ldt_lastsent) then
			is_IMOMAIL = "IMO - Last sent: none"
		else
			is_IMOMAIL = "IMO - Last sent: " + string(ldt_lastsent,"dd-mm-yy hh:mm ;'none'") + ' by '+ ls_lastsentby 
		end if
		cb_mailpositions.of_modifymenuitem(2,is_IMOMAIL)
	elseif sqlca.sqlcode = 100 then
			is_IMOMAIL = "IMO - Last sent: none" 
		cb_mailpositions.of_modifymenuitem(2,is_IMOMAIL)
	end if
	
	SELECT LASTSENT, isnull(LASTSENT_BY,'')
	INTO :ldt_lastsent, :ls_lastsentby
	FROM PF_POSITIONEMAIL
	WHERE PCGROUP_ID = :ii_pcgroup and EMAIL_TYPE = 0;
	if sqlca.sqlcode = 0 then
		if isnull(ldt_lastsent) then
			is_PUBLICMAIL = "Public - Last sent: none"
		else
			is_PUBLICMAIL = "Public - Last sent: " + string(ldt_lastsent,"dd-mm-yy hh:mm ;'none'") + ' by '+ ls_lastsentby 
		end if
		cb_mailpositions.of_modifymenuitem(1,is_PUBLICMAIL)
	elseif sqlca.sqlcode = 100 then
		is_PUBLICMAIL = "Public -  Last sent: none"
		cb_mailpositions.of_modifymenuitem(1,is_PUBLICMAIL)
	end if
	
end if

dw_position_list.getchild("vessels_vessel_name", ldwc_vessel)
ldwc_vessel.SetTransObject(SQLCA)
ldwc_vessel.retrieve(ii_pcgroup)
dw_position_list.getchild("pf_position_companyid", ldwc_chart)
ldwc_chart.SetTransObject(SQLCA)
ll_rowcount = ldwc_chart.retrieve(ii_pcgroup)

dw_position_list.getchild("pf_position_lastcargo", ldwc_cargo1)
ldwc_cargo1.SetTransObject(sqlca)
ldwc_cargo1.retrieve(ii_pcgroup)

dw_position_list.getchild("pf_position_secondlast", ldwc_cargo2)
ldwc_cargo2.SetTransObject(sqlca)
ldwc_cargo2.retrieve(ii_pcgroup)

dw_position_list.getchild("pf_position_thirdlast", ldwc_cargo3)
ldwc_cargo3.SetTransObject(sqlca)
ldwc_cargo3.retrieve(ii_pcgroup)

dw_print.getchild("charterer", ldwc_sharechart)
ldwc_sharechart.SetTransObject(SQLCA)
ldwc_sharechart.retrieve(ii_pcgroup)

_ib_validcompanies = true

dw_position_list.setredraw(false)
dw_position_list.retrieve(ii_pcgroup)


If ll_rowcount = 0 then 
	_ib_validcompanies = false
end if

wf_controlbutton('Open')

wf_setHeaders(dw_position_list)

dw_position_list.setfocus()
wf_setfindrow(ll_positionid,0)


dw_position_list.setredraw(true)	

end event

event ue_reload(integer ai_pcgroup);///********************************************************************
//   ue_reload(ai_pcgroup)
//   <DESC>	</DESC>
//   <RETURN>	integer:
//           
//   <ACCESS> public </ACCESS>
//   <ARGS>
//   </ARGS>
//   <USAGE>	n_fixture.uf_f_update_position(adw,al_row)	</USAGE>
//   <HISTORY>
//		Date     CR-Ref        Author   Comments
//		25/10/16	CR2001        KSH092   First Version
//   </HISTORY>
//********************************************************************/
//int li_return, li_messagebutton
//
//if ai_pcgroup = ii_pcgroup then
//	li_return = wf_validate(li_messagebutton)
//	if li_return = 1 then
//		if cb_update.event clicked() = -1 then
//			return
//		end if
//	end if
//	if li_return = 2 or li_return = 0 then
//		this.event ue_retrieve()
//	end if
//end if

integer li_return

li_return = wf_checkdatasave()
end event

event type integer ue_update();int ll_rowcount, li_resp, li_public
long ll_vesselid, ll_find, ll_row,ll_selectrow, ll_findnext
long ll_positionid
n_messagebox ln_message
dwItemStatus l_status
n_error_service 		lnv_error
n_service_manager 	lnv_SrvMgr
datawindowchild ldwc_vessel, ldwc_chart, ldwc_sharechart, ldwc_cargo1, ldwc_cargo2, ldwc_cargo3

if dw_position_list.accepttext() = -1 then
	messagebox('Error', "The " + is_labeltext + " does not exist.",StopSign!)
	dw_position_list.setfocus()
	setnull(is_labeltext)
	return C#Return.Failure
end if

//Delete row if row status is new before update
ll_rowcount = dw_position_list.rowcount()

if ll_rowcount > 0 then
	for ll_row = ll_rowcount to 1 step -1
		l_status = dw_position_list.getitemstatus(ll_row,0,Primary!)
		if l_status = New! then
			dw_position_list.rowsdiscard( ll_row, ll_row, primary!)
		end if
	next
end if

if wf_validateupdate(dw_position_list.rowcount()) = C#Return.Failure then
	return C#Return.Failure
end if

ll_rowcount = dw_position_list.rowcount()
if ll_rowcount > 0 then
	for ll_row = 1 to ll_rowcount
		l_status = dw_position_list.getitemstatus(ll_row,0,Primary!)
		if l_status = NewModified! or l_status = DataModified! then
			dw_position_list.setitem(ll_row, "pf_position_lastupdated",today()) 
		end if
		
		choose case l_status
			case NewModified!
				li_public = dw_position_list.getitemnumber(ll_row,'pf_position_categoryid')
				if isnull(li_public) then dw_position_list.setitem(ll_row,'pf_position_categoryid',0)
				dw_position_list.setitem(ll_row,'pf_position_pcgroup_id',ii_newpcgroup)
				ll_vesselid = dw_position_list.getItemNumber(ll_row, "pf_position_vesselid")
				ll_find = dw_position_list.find("pf_position_vesselid=" + string(ll_vesselid),1,w_position_list.dw_position_list.rowcount())
				if ll_find > 0 and ll_find <> ll_row then
					li_resp = MessageBox("Warning", "A position with this vessel name already exists.~r~n~r~nDo you want to add another?", Exclamation!, YesNo!, 2)
					if li_resp<>1 then
						dw_position_list.setfocus()
						dw_position_list.SelectRow(ll_row, True)
						dw_position_list.ScrollToRow(ll_row)
						dw_position_list.SetRow(ll_row)
						dw_position_list.setcolumn("pf_position_vesselid")
						return C#Return.Failure
					end if
				elseif ll_find > 0 and ll_find = ll_row then
					ll_findnext = dw_position_list.find("pf_position_vesselid=" + string(ll_vesselid),ll_row + 1, w_position_list.dw_position_list.rowcount() + 2)
					if ll_findnext > 0 then
						li_resp = MessageBox("Warning", "A position with this vessel name already exists.~r~n~r~nDo you want to add another?", Exclamation!, YesNo!, 2)
						if li_resp<>1 then
							dw_position_list.setfocus()
							dw_position_list.SelectRow(ll_row, True)
							dw_position_list.ScrollToRow(ll_row)
							dw_position_list.SetRow(ll_row)
							dw_position_list.setcolumn("pf_position_vesselid")
							return C#Return.Failure
						end if
					end if
				
				end if
		end choose
	
	next
end if

If  dw_position_list.modifiedcount( ) > 0 then
	If dw_position_list.update() = 1 then
		commit;
		wf_controlbutton( 'Open')
		ll_selectrow = dw_position_list.getselectedrow(0)
		if ll_selectrow > 0 then
			ll_positionid = dw_position_list.GetItemNumber(ll_selectrow, "position_id")
		end if

		dw_position_list.setredraw(false)
		dw_position_list.setfocus()
		
		if ii_pcgroup <> ii_prepcgroup and ii_prepcgroup > 0  then
			dw_position_list.getchild("pf_position_vesselid", ldwc_vessel)
			ldwc_vessel.SetTransObject(SQLCA)
			ldwc_vessel.retrieve(ii_pcgroup)
			dw_position_list.getchild("pf_position_companyid", ldwc_chart)
			ldwc_chart.SetTransObject(SQLCA)
			ll_rowcount = ldwc_chart.retrieve(ii_pcgroup)
			
			dw_position_list.getchild("pf_position_lastcargo", ldwc_cargo1)
			ldwc_cargo1.SetTransObject(sqlca)
			ldwc_cargo1.retrieve(ii_pcgroup)

			dw_position_list.getchild("pf_position_secondlast", ldwc_cargo2)
			ldwc_cargo2.SetTransObject(sqlca)
			ldwc_cargo2.retrieve(ii_pcgroup)

			dw_position_list.getchild("pf_position_thirdlast", ldwc_cargo3)
			ldwc_cargo3.SetTransObject(sqlca)
			ldwc_cargo3.retrieve(ii_pcgroup)
			
			dw_print.getchild("charterer", ldwc_sharechart)
			ldwc_sharechart.SetTransObject(SQLCA)
			ldwc_sharechart.retrieve(ii_pcgroup)
		end if
		
		dw_position_list.retrieve(ii_pcgroup)
		
		// Reselect same position_id
		wf_setfindrow(ll_positionid,0)	
		dw_position_list.setredraw(true)
	Else
		rollback;

		lnv_SrvMgr.of_loadservice( lnv_error, "n_error_service")
		if lnv_error.of_ShowMessages() = c#return.Failure then
			messagebox("Update Error", "Update failure." , StopSign!)
			dw_position_list.setfocus()
		end if
		return C#Return.Failure
	End if
End if

return C#Return.Success

end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_position_list
   <OBJECT> Direct Ancestor: w_tramos_container</OBJECT>
   <DESC>   Main position list</DESC>
   <USAGE>  Used in Calculation Module</USAGE>
   <ALSO>   w_tramos_container, mt_w_main</ALSO>
    Date   		Ref	Author	Comments
  21/04/09 						of_sendmail - added two arguments (mailtype and id) to control the email addresses that fails 
  11/10/10 	2147   	AGL     	Inheriting from base object
  11/10/10 	2147   	AGL     	Make sure that pcgroups with no companies
  									do not have strange sideeffects.
  19/10/10 	2148		RMO		Cleanup of_sendmail when implementing posibility to send  positions 
									to newly created PC Groups
  02/12/10	2213		AGL		data not being saved on update when user updating text. 
  26/06/13	3244		WWA048	Duplicate the features specific to profit center group Crude to Nova
  05/08/14 	CR3708	AGL027	F1 help application coverage - change ancestor, event open() extends ancestor script
  18/09/16	CR2001  	KSH092	New UI and move edit window
  23/12/16  CR4387	KSH092	Add column IMO,Open Ext,Comment Ext and change Mail Positions button
  13/3/17	CR4573	KSH092	User manual sorting is lost when grouping by Profit Center and/or Areas
  17/03/17	CR4572	XSZ004	Apply latest standard for dddw column
  27/04/17	CR4645	XSZ004	Ensure position list is correct in Public/IMO email.  
  20/08/17	CR4654	EPE080	Mask the base class Ctrl+S methos and call the Saveas Button method,change the position_list_print header label. 
********************************************************************/

end subroutine

public subroutine wf_controlbutton (string as_datastatus);	/********************************************************************
   wf_controlbutton()
   <DESC>	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/09/16	CR2001        KSH092   First Version
   </HISTORY>
********************************************************************/

uo_pcgroup.enabled = true



cbx_profit.enabled = true
choose case as_datastatus
	case 'Open'
	
//		cb_new.enabled = true
		cb_update.enabled = false
		cb_cancel.enabled = false
//		cb_retrieve.enabled = true
//		uo_pcgroup.enabled = true
//		cbx_showarea.enabled = true
//		cbx_profit.enabled = true
	
	case 'Edit'
	
//		cb_retrieve.enabled = false
//		cb_new.enabled = true
//		cbx_profit.enabled = false
//		cbx_showarea.enabled = false
		cb_update.enabled = true
		cb_cancel.enabled = true
	
//		uo_pcgroup.enabled = false
	
end choose
if dw_position_list.rowcount() > 0 then
	cb_saveas.enabled = true
	cb_print.enabled = true
	cb_mailpositions.enabled = true
	cb_movecargo.enabled = true
else
	cb_saveas.enabled = false
	cb_print.enabled = false
	cb_mailpositions.enabled = false
	cb_movecargo.enabled = false
end if
If dw_position_list.rowcount( ) > 0 then
	if uo_global.ii_access_level = 3 or (uo_global.ii_access_level = 2 and  uo_global.ii_user_profile = 1) then
		cb_delete.enabled = true
	else
		cb_delete.enabled = false
	end if
else
	cb_delete.enabled = false
End if
end subroutine

public subroutine wf_dwgroupsetrow ();long ll_position, ll_selectrow, ll_rowid
dwItemStatus l_status

this.setredraw(false)

ll_selectrow = dw_position_list.getselectedrow(0)
if ll_selectrow > 0 then
	l_status = dw_position_list.getitemstatus(ll_selectrow, 0, Primary!)
	if l_status = New! or l_status = NewModified! then
		ll_rowid = dw_position_list.getrowidfromrow(ll_selectrow)
	else
		ll_position = dw_position_list.GetItemNumber(ll_selectrow, "position_id")
	end if
end if

wf_setHeaders(dw_position_list)

wf_setfindrow(ll_position, ll_rowid)

this.setredraw(true)

end subroutine

public subroutine wf_setheaders (datawindow adw_object);/********************************************************************
   wf_setHeaders(adw_object)
   <DESC>  
	Using the radio buttons on window control set the computed fields 
	in DW to control the groupings.
	
	</DESC>
   <RETURN> N/A
            <LI> 
            <LI> </RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   N/A</ARGS>
   <USAGE>  Only available from the current object, the function controls
	the headers inside d_position_list accordingly.  Just call the function by name
	
	</USAGE>
 <HISTORY>
		Date     CR-Ref        Author   Comments
		06/09/16	CR2001        KSH092   First Version
   </HISTORY>
********************************************************************/
long ll_rowid, ll_row, ll_return
string ls_sortstring, ls_modifystring[]
int li_group



if len(is_sort) > 0 then
	ls_sortstring = is_sort
end if

if pos(ls_sortstring, "vessels_vessel_name A") <= 0  then ls_sortstring += ",vessels_vessel_name A"

if cbx_profit.checked then
	li_group = li_group + 1
	adw_object.modify("profit_center.Expression = 'profit_c_pc_name'")
	is_sort_pcnr = "profit_c_pc_name A, "
else
	is_sort_pcnr = ""
end if

if cbx_showarea.checked then
	li_group = li_group +1 
	choose case li_group
		case 1
			adw_object.modify("profit_center.Expression = 'area_area_name'")
		case 2
			adw_object.Modify("area.Expression='~"  ~"+area_area_name'")
		
	end choose
	is_sort_area = "area_area_name A, "
else
	is_sort_area = ""
end if

choose case li_group
	case 1		
		adw_object.Modify("area.Expression=''")
		adw_object.modify("datawindow.header.1.height = '64'")
		adw_object.modify("datawindow.header.2.height = '0'")
	case 2
		adw_object.modify("datawindow.header.1.height = '64'")
		adw_object.modify("datawindow.header.2.height = '64'")
	case 0
		adw_object.Modify("profit_center.Expression=''")			
		adw_object.Modify("area.Expression=''")
		adw_object.modify("datawindow.header.1.height = '0'")
		adw_object.modify("datawindow.header.2.height = '0'")
end choose



if cbx_profit.checked or cbx_showarea.checked  then
	adw_object.modify("DataWindow.Grid.Lines=1")
	adw_object.modify("datawindow.processing = '0'")
	adw_object.modify("profit_center.x = '9' profit_center.width = '5544'")
	adw_object.modify("area.x = '9' area.width = '5544'")
	
else
	adw_object.modify("DataWindow.Grid.Lines=0")
	adw_object.modify("datawindow.processing = '1'")
end if

if is_sort_pcnr + is_sort_area + ls_sortstring <> ""  and adw_object.classname() = "dw_position_list" then
	adw_object.setSort(is_sort_pcnr + is_sort_area + ls_sortstring )
	adw_object.Sort()
	adw_object.groupCalc()
end if


end subroutine

public function integer wf_validateupdate (long al_row);/********************************************************************
   wf_validateupdate()
   <DESC>	Validation script for validating user entries when update	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	cb_update.event clicked( )	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		27/10/16 CR2001			KSH092	First Version
		
   </HISTORY>
********************************************************************/
long			ll_row
string		ls_message
integer		li_column, li_return

mt_n_stringfunctions lnv_string


n_service_manager				lnv_svcmgr
n_dw_validation_service 	lnv_validate


if al_row <= 0 then return c#return.Success

lnv_svcmgr.of_loadservice(lnv_validate, "n_dw_validation_service")

lnv_validate.of_registerrulestring("vessels_vessel_name", true, "Vessel Name")
lnv_validate.of_registerrulenumber("pf_position_statusid", true, "Status")
lnv_validate.of_registerrulenumber("pf_position_worldareaid", true, "World Area")
lnv_validate.of_registerrulestring("pf_position_openarea", true, "Open")


li_return = lnv_validate.of_validate(dw_position_list, ls_message, ll_row, li_column)
	
if li_return = C#Return.Failure then
	messagebox("Update Error", ls_message, StopSign!)	
	dw_position_list.setfocus()
	dw_position_list.setrow(ll_row)
	dw_position_list.setcolumn(li_column)
	return C#Return.Failure
end if


return c#return.Success


end function

public function integer wf_validate (ref integer ai_messagebutton);	/********************************************************************
   wf_validate()
   <DESC>	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/09/16	CR2001        KSH092   First Version
   </HISTORY>
********************************************************************/

if dw_position_list.accepttext() = -1 then
	this.bringtotop = true
	if this.windowstate = Minimized! then
		this.windowstate = Normal!
	end if
	messagebox('Error', "The " + is_labeltext + " does not exist.",StopSign!)
	dw_position_list.setfocus()
	setnull(is_labeltext)
	return C#return.Failure
end if

if dw_position_list.modifiedcount() > 0  then
	this.bringtotop = true
	if this.windowstate = Minimized! then
		this.windowstate = Normal!
	end if
	ai_messagebutton = inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_UNSAVED_DATA, '', this)
end if

return C#return.Success
end function

public function integer wf_checkdatasave ();	/********************************************************************
   wf_checkdatasave()
   <DESC>	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/09/16	CR2001        KSH092   First Version
   </HISTORY>
********************************************************************/


return wf_checkdatasave(false)
end function

public subroutine wf_setfindrow (long al_positionid, long al_rowid);///********************************************************************
//   wf_setfindrow(al_positionid)
//   <DESC>	</DESC>
//   <RETURN>	integer:
//           
//   <ACCESS> public </ACCESS>
//   <ARGS>
//   </ARGS>
//   <USAGE>		</USAGE>
//   <HISTORY>
//		Date     CR-Ref        Author   Comments
//		06/09/16	CR2001        KSH092   First Version
//   </HISTORY>
//********************************************************************/
long ll_findrow, ll_vposition, ll_row

if isnull(al_positionid) or al_positionid = 0 then
	ll_findrow = dw_position_list.getrowfromrowid(al_rowid)
else
	ll_findrow = dw_position_list.Find("position_id = " + String(al_positionid), 1, dw_position_list.RowCount())
end if

if ll_findrow > 0 then
	ll_row = dw_position_list.getrow()
	if ll_row > 0 and ll_row = ll_findrow then
		dw_position_list.event rowfocuschanged(ll_row)
	else
		dw_position_list.SetRow(ll_findrow)
		dw_position_list.scrolltorow(ll_findrow)
	end if
	ll_vposition = long(dw_position_list.describe("datawindow.verticalscrollposition"))
	dw_position_list.modify("datawindow.verticalscrollposition='" + string(ll_vposition) + "'")
else
	ll_row = dw_position_list.getrow()
	if ll_row > 0 then
		dw_position_list.event rowfocuschanged(ll_row)
	end if
	
end if	
end subroutine

public function integer wf_checkdatasave (boolean ab_retrievenochange);	/********************************************************************
   wf_checkdatasave()
   <DESC>	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/09/16	CR2001        KSH092   First Version
   </HISTORY>
********************************************************************/

integer li_return, li_messagebutton

li_return = wf_validate(li_messagebutton)
if li_return = C#return.Success then
	choose case li_messagebutton
		case 0
			if ab_retrievenochange then
				this.event ue_retrieve()
			end if
		case 1
			if this.event ue_update() = C#return.Failure then
				return C#return.Failure
			end if
		case 2//, 0
			this.event ue_retrieve()
			
		case 3
			return C#return.Failure
	end choose
else
	return C#return.Failure
end if

return C#return.Success
end function

public subroutine of_sendmail (string as_email, mt_n_outgoingmail anv_mail, integer ai_pcgroup, integer ai_mailtype, string as_company, string as_contact, string as_mailtype, long al_id);/********************************************************************
   of_sendmail
   <DESC> This function generates and sends the position mails</DESC>
   <RETURN> (none) </RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  as_email: Receiver mail address
            		anv_mail: Reference to outgoing mail object
				ai_pcgroup: profit center group
				ai_mailtype: IMO or Public email
				as_company: if wrong mail address use company name to identify
				as_contact:  if wrong mail address use company name to identify
				as_mailtype: which email to use - used when failure
				al_id: used when failure
				</ARGS>
   <USAGE>  </USAGE>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		27/04/17		CR4645		XSZ004		Ensure position list is correct in Public/IMO email.
	</HISTORY>	
********************************************************************/
long		ll_rc
string		ls_message, ls_pcgroup_name, ls_emailfrom, ls_footer, ls_curPath, ls_subject, ls_header, ls_content, ls_datahtml, ls_emailbody
long		ll_row
n_dataexport lnv_exp
mt_n_stringfunctions lnv_string

if as_email <> "" then
	if anv_mail.of_verifyReceiverAddress(as_email, ls_message) = -1 then
		/* if there is a mail address that is wrong, append it to the mail failure datastore */
		ll_row = ids_wrong_mail_addresses.insertRow(0)			
		choose case as_mailtype
			case "pf_company_email", "pf_company_email2", "pf_company_email", "pf_company_charteringemail", "pf_company_operationemail", "pf_company_financeemail"
				ids_wrong_mail_addresses.setItem(ll_row, "company", 1 )   
			case "pf_companycontacts_email"
				ids_wrong_mail_addresses.setItem(ll_row, "company", 0 )   
		end choose
		ids_wrong_mail_addresses.setItem(ll_row, "company_or_contact_id", al_id )
		ids_wrong_mail_addresses.setItem(ll_row, "mail_address", as_email )   
		ids_wrong_mail_addresses.setItem(ll_row, "address_type", as_mailtype )   
		ids_wrong_mail_addresses.setItem(ll_row, "company_name", as_company )   
		ids_wrong_mail_addresses.setItem(ll_row, "errormessage", ls_message )   
		return
	end if
	
	SELECT PCGROUP_NAME
	INTO :ls_pcgroup_name
	FROM PCGROUP
	WHERE PCGROUP_ID = :ai_pcgroup; 
	
	
	SELECT EMAILFROM, SUBJECT, HEADER, CONTENT, FOOTER
	INTO :ls_emailfrom, :ls_subject, :ls_header, :ls_content, :ls_footer
	FROM PF_POSITIONEMAIL
	WHERE PCGROUP_ID = :ai_pcgroup and EMAIL_TYPE = :ai_mailtype;
	
	dw_mailpositions_html.reset()
	dw_mailpositions_html.retrieve(ai_pcgroup)
	if ai_mailtype = 1 then
		dw_mailpositions_html.setfilter("imo_check = 1")
	elseif ai_mailtype = 0 then
		dw_mailpositions_html.setfilter("public_check = 1")
	end if
	
	dw_mailpositions_html.filter()
	dw_mailpositions_html.groupcalc()
	
	dw_mailpositions_html.modify("area_area_name.visible=1 area_area_name.x='0~t5' area_area_name.width='613~t6308'")
	dw_mailpositions_html.modify("DataWindow.Header.1.Height = '72' DataWindow.Grid.Lines=1")
	
	ls_datahtml = lnv_exp.of_datatohtml(dw_mailpositions_html, false, true, true,  true, false)
    
	if isNull(ls_header) then ls_header = ""
	if isNull(ls_content) then ls_content = ""
	if isNull(ls_footer) then ls_footer = ""
	if isnull(ls_subject) then ls_subject = ""
	
	ls_emailbody = lnv_string.of_htmlencode(ls_header + CRLF + CRLF +  ls_content + CRLF + CRLF)
	ls_emailbody = '<html><style> body{FONT:10pt "verdana", sans-serif;}</style><body>' + ls_emailbody  + ls_datahtml + lnv_string.of_htmlencode(CRLF + CRLF + ls_footer) + '</body></html>'

	ll_rc = anv_mail.of_createmail( ls_emailfrom, &
									as_email, & 
									ls_subject, & 
									ls_emailbody, &
									 ls_message)
	//									ls_header + CRLF + CRLF +  ls_content + CRLF + CRLF+ "kindly find the " + ls_pcgroup_name + " positions in the attached PDF file."+ CRLF+CRLF +ls_footer, &
	if ll_rc < 1 then
		messageBox("Error", ls_message)
		return
	end if
	
	ls_curPath = GetCurrentDirectory()
	
	ll_rc = anv_mail.of_addattachment(ls_curPath + "\positions.pdf" , ls_message )


	if ll_rc < 1 then
		messageBox("Error", ls_message)
		return
	end if		
	
	ll_rc = anv_mail.of_sendmail( ls_message )
	if ll_rc < 1 then
		messageBox("Error", ls_message)
		return
	end if
	
	anv_mail.of_reset()
end if
end subroutine

on w_position_list.create
int iCurrent
call super::create
this.uo_pcgroup=create uo_pcgroup
this.hpb_mail=create hpb_mail
this.dw_mail_positions=create dw_mail_positions
this.cb_update=create cb_update
this.cbx_profit=create cbx_profit
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cbx_showarea=create cbx_showarea
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_retrieve=create cb_retrieve
this.dw_mail_company=create dw_mail_company
this.st_topbar_background=create st_topbar_background
this.cb_cancel=create cb_cancel
this.dw_fixture_subdata=create dw_fixture_subdata
this.dw_position_list=create dw_position_list
this.dw_mailpositions_html=create dw_mailpositions_html
this.cb_movecargo=create cb_movecargo
this.dw_print=create dw_print
this.cb_mailpositions=create cb_mailpositions
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pcgroup
this.Control[iCurrent+2]=this.hpb_mail
this.Control[iCurrent+3]=this.dw_mail_positions
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cbx_profit
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_new
this.Control[iCurrent+8]=this.cbx_showarea
this.Control[iCurrent+9]=this.cb_print
this.Control[iCurrent+10]=this.cb_saveas
this.Control[iCurrent+11]=this.cb_retrieve
this.Control[iCurrent+12]=this.dw_mail_company
this.Control[iCurrent+13]=this.st_topbar_background
this.Control[iCurrent+14]=this.cb_cancel
this.Control[iCurrent+15]=this.dw_fixture_subdata
this.Control[iCurrent+16]=this.dw_position_list
this.Control[iCurrent+17]=this.dw_mailpositions_html
this.Control[iCurrent+18]=this.cb_movecargo
this.Control[iCurrent+19]=this.dw_print
this.Control[iCurrent+20]=this.cb_mailpositions
end on

on w_position_list.destroy
call super::destroy
destroy(this.uo_pcgroup)
destroy(this.hpb_mail)
destroy(this.dw_mail_positions)
destroy(this.cb_update)
destroy(this.cbx_profit)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cbx_showarea)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_retrieve)
destroy(this.dw_mail_company)
destroy(this.st_topbar_background)
destroy(this.cb_cancel)
destroy(this.dw_fixture_subdata)
destroy(this.dw_position_list)
destroy(this.dw_mailpositions_html)
destroy(this.cb_movecargo)
destroy(this.dw_print)
destroy(this.cb_mailpositions)
end on

event open;call super::open;string	ls_groupname
datetime	ldt_lastsent
long ll_pcnr, ll_found
datawindowchild ldwc

n_service_manager lnv_servicemanager
n_dw_style_service	lnv_dwstyle

lnv_servicemanager.of_loadservice( lnv_dwstyle , "n_dw_style_service")
lnv_dwstyle.of_dwlistformater(dw_position_list, false)
lnv_dwstyle.of_dwlistformater(dw_print, false)
lnv_dwstyle.of_dwlistformater(dw_fixture_subdata,false)
dw_position_list.of_setallcolumnsresizable(true)
lnv_dwstyle.of_registercolumn("pf_position_vesselid", true)
lnv_dwstyle.of_registercolumn("pf_position_statusid", true)
lnv_dwstyle.of_registercolumn("pf_position_worldareaid", true)
lnv_dwstyle.of_registercolumn("pf_position_openarea", true)

lnv_dwstyle.of_autoadjustdddwwidth(dw_position_list)

iuo_dddw_search_vessel = create u_dddw_search
iuo_dddw_search_vessel.of_register(dw_position_list,"vessels_vessel_name","vessel_name",true)

iuo_dddw_search_charterer = create u_dddw_search
iuo_dddw_search_charterer.of_register(dw_position_list,"pf_position_companyid","shortname",true)

iuo_dddw_search_openport = create u_dddw_search
iuo_dddw_search_openport.of_register(dw_position_list,"pf_position_openarea","open_name",false)

iuo_dddw_search_openportext = create u_dddw_search
iuo_dddw_search_openportext.of_register(dw_position_list,"pf_position_openarea_ext","open_name",false)

iuo_dddw_search_area = create u_dddw_search
iuo_dddw_search_area.of_register(dw_position_list,"pf_position_worldareaid","area_name",true)

iuo_dddw_search_status = create u_dddw_search
iuo_dddw_search_status.of_register(dw_position_list,"pf_position_statusid","name",true)

iuo_dddw_search_cargo1 = create u_dddw_search
iuo_dddw_search_cargo1.of_register(dw_position_list,"pf_position_lastcargo","name",true)

iuo_dddw_search_cargo2 = create u_dddw_search
iuo_dddw_search_cargo2.of_register(dw_position_list,"pf_position_secondlast","name",true)

iuo_dddw_search_cargo3 = create u_dddw_search
iuo_dddw_search_cargo3.of_register(dw_position_list,"pf_position_thirdlast","name",true)



uo_pcgroup.of_setlabelcolor(c#color.MT_LISTHEADER_TEXT)
uo_pcgroup.of_setbackcolor(c#color.MT_LISTHEADER_BG, true)


dw_print.settransobject(sqlca)
dw_position_list.sharedata(dw_print)
dw_mailpositions_html.settransobject(sqlca)
dw_mail_positions.settransobject(SQLCA)

ii_pcgroup=uo_pcgroup.uf_getpcgroup( )

if ii_pcgroup<=0 then
	this.Post Event ue_postopen()
else
	this.post event ue_retrieve()
end if

end event

event closequery;call super::closequery;integer li_return

li_return = wf_checkdatasave()

if li_return = C#return.Failure then
	return 1
end if
return 0


end event

event resize;call super::resize;long ll_mod, ll_dwheight, ll_dwwidth, ll_dwnewwidth, ll_modifywidth, ll_commentwidth
integer li_currvposition

li_currvposition = long(dw_position_list.describe("datawindow.verticalscrollposition"))
if li_currvposition > 0 then
	ii_vposition = li_currvposition
end if
if newwidth = 0 and newheight = 0 then return
ll_dwwidth = dw_position_list.width
ll_dwnewwidth = newwidth - dw_position_list.x - 37
st_topbar_background.width = this.width
ll_dwheight = newheight - dw_position_list.y - 64 - 100 - 16 
ll_mod =mod(ll_dwheight, 64)

if ll_mod <= 32 then
	dw_position_list.resize(ll_dwnewwidth,ll_dwheight - ll_mod + 4)
else
	dw_position_list.resize(ll_dwnewwidth, ll_dwheight + 64 - ll_mod + 4)
end if
ll_modifywidth = ll_dwnewwidth - ll_dwwidth
ll_commentwidth = long(dw_position_list.Describe("pf_position_comment_ext.Width"))
ll_commentwidth = ll_commentwidth + ll_modifywidth
if ll_modifywidth <> 0  and ll_dwnewwidth > 0 then
	if ll_commentwidth < 325 then ll_commentwidth = 325
	dw_position_list.modify("pf_position_comment_ext.width=" + string(ll_commentwidth) )
	
end if
cb_retrieve.x = newwidth - cb_retrieve.width - 37
cb_print.x = newwidth - cb_print.width - 37
cb_saveas.x = cb_print.x - 4 - cb_saveas.width
cb_cancel.x = cb_saveas.x - 4 - cb_cancel.width
cb_delete.x = cb_cancel.x - 4 - cb_delete.width
cb_update.x = cb_delete.x - 4 - cb_update.width
cb_movecargo.x = cb_update.x - 4 - cb_movecargo.width
cb_new.x = cb_movecargo.x - 4 - cb_new.width

cb_print.y = dw_position_list.height + dw_position_list.y + 16 
cb_saveas.y = dw_position_list.height + dw_position_list.y + 16 
cb_cancel.y = dw_position_list.height + dw_position_list.y + 16 
cb_delete.y = dw_position_list.height + dw_position_list.y + 16 
cb_update.y = dw_position_list.height + dw_position_list.y + 16 
cb_movecargo.y = dw_position_list.height + dw_position_list.y + 16 
cb_new.y = dw_position_list.height + dw_position_list.y + 16 
cb_mailpositions.y = dw_position_list.height + dw_position_list.y + 16 

if (sizetype = 0 or sizetype = 2)   then
	dw_position_list.modify("datawindow.verticalscrollposition='" + string(ii_vposition) + "'")
end if


end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;integer li_return

ii_prepcgroup = ii_pcgroup
ii_pcgroup = ai_pcgroupid

li_return = wf_checkdatasave(true)

if li_return = C#return.Failure then
	ii_pcgroup = ii_prepcgroup
	return ii_pcgroup
end if
ii_prepcgroup = ii_pcgroup


return ii_pcgroup



end event

type st_hidemenubar from w_tramos_container`st_hidemenubar within w_position_list
integer x = 18
integer y = 32
end type

type uo_pcgroup from u_pcgroup within w_position_list
integer x = 37
integer y = 32
integer height = 148
integer taborder = 10
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type hpb_mail from hprogressbar within w_position_list
boolean visible = false
integer x = 1893
integer y = 2736
integer width = 654
integer height = 80
unsignedinteger maxposition = 100
integer setstep = 1
end type

type dw_mail_positions from mt_u_datawindow within w_position_list
boolean visible = false
integer x = 37
integer y = 1372
integer width = 3099
integer height = 788
string dataobject = "d_mail_positions"
end type

type cb_update from mt_u_commandbutton within w_position_list
integer x = 4498
integer y = 2824
integer taborder = 100
boolean enabled = false
string text = "&Update"
end type

event clicked;parent.event ue_update()
end event

type cbx_profit from mt_u_checkbox within w_position_list
integer x = 795
integer y = 112
integer width = 558
integer height = 72
integer taborder = 20
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Show Profit Centers"
end type

event clicked;wf_dwgroupsetrow()
end event

type cb_delete from mt_u_commandbutton within w_position_list
integer x = 4841
integer y = 2824
integer taborder = 110
boolean enabled = false
string text = "&Delete"
end type

event clicked;long ll_rc, ll_positionid, ll_row
DWItemStatus le_rowstatus

ll_row = dw_position_list.getselectedRow(0)
if ll_row > 0 then
	le_rowstatus = dw_position_list.getitemstatus( ll_row, 0, primary!)
	if le_rowstatus = New! or le_rowstatus = NewModified! then
		dw_position_list.deleterow(ll_row)
		if dw_position_list.getrow() = ll_row and ll_row > 0 then
			dw_position_list.event rowfocuschanged(ll_row)
		end if
	
	else
		ll_rc = inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_CONFIRM_DELETE, "the selected Position", parent)
		
		if ll_rc = 1 then
			ll_positionid = dw_position_list.getitemnumber(ll_row,'position_id')
			DELETE  
			FROM PF_POSITION
			WHERE POSITIONID = :ll_positionid;
			if sqlca.sqlcode = 0 then
				commit;
				dw_position_list.rowsdiscard( ll_row, ll_row, primary!)
				if dw_position_list.getrow() = ll_row and ll_row > 0 then
					dw_position_list.event rowfocuschanged(ll_row)
				end if
			else
				rollback;
				messagebox("Error", "Delete failed.", StopSign!)
			end if
		end if
	end if
end if

if dw_position_list.modifiedcount( ) > 0 then
	wf_controlbutton( 'Edit')
else
	wf_controlbutton( 'Open')
end if
end event

type cb_new from mt_u_commandbutton within w_position_list
integer x = 3817
integer y = 2824
integer taborder = 80
string text = "&New"
end type

event clicked;long		ll_row

/* Profitcenter grouping */
if ii_pcgroup = 0 then
	MessageBox("Validation Error", "Please select a Profit Center group.")
	return
else 
	ll_row = dw_position_list.insertrow(0)
	
	if ll_row > 0 then
		ii_newpcgroup = ii_pcgroup
		dw_position_list.setrow(ll_row)
		dw_position_list.setfocus( )
		dw_position_list.scrolltorow(ll_row)
		dw_position_list.setcolumn("vessels_vessel_name")
	end if
	
	wf_controlbutton('Edit')
	return 1
end if


end event

type cbx_showarea from mt_u_checkbox within w_position_list
integer x = 1358
integer y = 112
integer width = 553
integer height = 72
integer taborder = 30
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Show Areas"
end type

event clicked;wf_dwgroupsetrow()
end event

type cb_print from mt_u_commandbutton within w_position_list
integer x = 5865
integer y = 2824
integer taborder = 140
boolean enabled = false
string text = "&Print"
end type

event clicked;call super::clicked;n_dataprint ln_print
int li_return
string ls_sort

li_return = wf_checkdatasave()

if li_return = C#return.Failure then
	return
end if

wf_setheaders(dw_print)

ln_print.of_print(dw_print)


end event

type cb_saveas from mt_u_commandbutton within w_position_list
integer x = 5527
integer y = 2824
integer taborder = 130
boolean enabled = false
string text = "&Save As..."
end type

event clicked;n_dataexport lnv_exp
int li_return

li_return = wf_checkdatasave()

if li_return = C#return.Failure then
	return
end if

dw_print.modify("area.visible = 0")

dw_print.modify("datawindow.processing = '0'")
	
dw_print.modify("profit_center.x = '5' ")
lnv_exp.of_export(dw_print)

dw_print.modify("area.visible = 1")

end event

type cb_retrieve from mt_u_commandbutton within w_position_list
integer x = 5865
integer y = 28
integer taborder = 40
string text = "&Refresh"
end type

event clicked;call super::clicked;integer li_return

li_return = wf_checkdatasave(true)
end event

type dw_mail_company from mt_u_datawindow within w_position_list
boolean visible = false
integer x = 3346
integer y = 1376
integer width = 2661
integer height = 996
string dataobject = "d_mail_company"
end type

type st_topbar_background from u_topbar_background within w_position_list
integer width = 6853
end type

type cb_cancel from mt_u_commandbutton within w_position_list
integer x = 5184
integer y = 2824
integer taborder = 120
boolean bringtotop = true
string text = "&Cancel"
end type

event clicked;call super::clicked;wf_controlbutton('Open')

parent.event ue_retrieve()

end event

type dw_fixture_subdata from u_popupdw within w_position_list
integer x = 1033
integer y = 672
integer width = 4178
integer height = 196
boolean bringtotop = true
string dataobject = "d_fixture_subdata"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

type dw_position_list from u_datagrid within w_position_list
integer x = 37
integer y = 244
integer width = 6171
integer height = 2564
integer taborder = 50
string dataobject = "d_position_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
end type

event clicked;dec 	ldc_areapk
long 	ll_selectrow, ll_findrow, ll_positionid, ll_vposition, ll_rowid
string ls_portn, ls_filter
datawindowchild ldwc_openport
dwItemStatus l_status


if row = 0 and dwo.type = "text" then
	
	this.setredraw(false)

	ll_selectrow = this.getselectedrow(0)
	
	if ll_selectrow > 0 then
		l_status = dw_position_list.getitemstatus(ll_selectrow, 0, Primary!)
		if l_status = New! or l_status = NewModified! then
			ll_rowid = dw_position_list.getrowidfromrow(ll_selectrow)
		else
			ll_positionid = this.getitemnumber(ll_selectrow, 'position_id')
		end if
	end if

	if cbx_showarea.checked or cbx_profit.checked then
		if cbx_profit.checked then is_sort_pcnr  = "profit_c_pc_name A, "

		if cbx_showarea.checked then	is_sort_area = "area_area_name A, "
		
		is_sort = dwo.Tag

		if is_sort <> "" then
			if right(is_sort, 1) = "A" then 
				is_sort = replace(is_sort, len(is_sort),1, "D")
			else
				is_sort = replace(is_sort, len(is_sort),1, "A")
			end if
		
			is_sort_temp = is_sort
			
			this.setSort(is_sort_pcnr + is_sort_area + is_sort + ", vessels_vessel_name A")
			this.Sort()

			dwo.Tag = is_sort

			this.groupcalc()
		end if
	else		
		super::event clicked(xpos, ypos, row, dwo)
		is_sort = this.describe("datawindow.table.sort")
	end if
	
	wf_setfindrow(ll_positionid, ll_rowid)
	
	this.setredraw(true)
end if

if row > 0 and this.getrow() <> row then
	setrow(row)
end if

		
	

end event

event itemchanged;long ll_vesselnr, ll_rowport, ll_find, ll_imo, ll_iceclass, ll_fixturestatus
string ls_pcname, ls_type, ls_vesselname, ls_areaname, ls_null
dec   ldc_areapk, ldc_sdwt, ldc_cbm
datawindowchild ldwc

choose case dwo.name
	case 'vessels_vessel_name'
		if iuo_dddw_search_vessel.uf_itemchanged() = 1 then
			return 2
		end if
		ls_vesselname = trim(data)
		SELECT PROFIT_C.PC_NAME, VESSELS.CAL_SDWT, VESSELS.CAL_CBM, VESSELS.VESSEL_NR
		INTO :ls_pcname, :ldc_sdwt, :ldc_cbm, :ll_vesselnr
		FROM PROFIT_C, VESSELS
		WHERE PROFIT_C.PC_NR = VESSELS.PC_NR AND VESSELS.VESSEL_NAME= :ls_vesselname;
		
		SELECT VESSELS_WEB.IMO_ID, VESSELS_WEB.ICECLASSID
		INTO :ll_imo, :ll_iceclass
		FROM VESSELS_WEB, VESSELS
		WHERE VESSELS_WEB.VESSEL_NR = VESSELS.VESSEL_NR AND VESSELS.VESSEL_NR = :ll_vesselnr;
		
		
		SELECT DISTINCT case ISNULL(MAX(PF_FIXTURE.STATUSID),0) when 111 then 'Yes' else 'No' end 
		INTO :ll_fixturestatus
		FROM PF_FIXTURE,PF_FIXTURE_STATUS_CONFIG 
		WHERE PF_FIXTURE.VESSELID = :LL_VESSELNR AND PF_FIXTURE.STATUSID = 111 AND
				PF_FIXTURE.ISFIXTURE = 1 and  
				PF_FIXTURE.STATUSID = PF_FIXTURE_STATUS_CONFIG.STATUSID and 
				PF_FIXTURE.PCGROUP_ID = PF_FIXTURE_STATUS_CONFIG.PCGROUP_ID and
				PF_FIXTURE_STATUS_CONFIG.FIXTURELIST = 1 and
				datediff(day,PF_FIXTURE.FIXTUREREPORTED,getdate()) <= PF_FIXTURE_STATUS_CONFIG.DAYSONLIST;
		
		this.setitem(row, 'profit_c_pc_name', ls_pcname)
		this.setitem(row, 'vessels_cal_sdwt', ldc_sdwt)
		this.setitem(row, 'vessels_cal_cbm', ldc_cbm)
		this.setitem(row, 'vessels_web_imo_id', ll_imo)
		this.setitem(row, 'vessels_web_iceclassid', ll_iceclass)
		this.setitem(row,'fixture_subs', ll_fixturestatus)
		this.setitem(row,'pf_position_vesselid', ll_vesselnr)
		
	case 'pf_position_statusid'
		if iuo_dddw_search_status.uf_itemchanged() = 1 then
			return 2
		end if
		
	case 'pf_position_worldareaid'
		if iuo_dddw_search_area.uf_itemchanged() = 1 then
			return 2
		end if
		
		ldc_areapk = dec(data)
		if isnull(ldc_areapk) then return
		SELECT AREA_NAME
		INTO :ls_areaname
		FROM AREA
		WHERE AREA_PK = :ldc_areapk;
		this.setitem(row, 'area_area_name', ls_areaname)
	case 'pf_position_openarea'
		setnull(ls_null)
		this.setitem(row,'pf_position_openarea_ext',ls_null)
	case "pf_position_companyid"
		if iuo_dddw_search_charterer.uf_itemchanged() = 1 then
			return 2
		end if
end choose

wf_controlbutton('Edit')

end event

event editchanged;
choose case dwo.name
	case 'vessels_vessel_name'
		iuo_dddw_search_vessel.uf_editchanged()
	case 'pf_position_openarea'
		iuo_dddw_search_openport.uf_editchanged()
	case 'pf_position_openarea_ext'
		iuo_dddw_search_openportext.uf_editchanged()
	case 'pf_position_worldareaid'
		iuo_dddw_search_area.uf_editchanged()
	case 'pf_position_companyid'
		iuo_dddw_search_charterer.uf_editchanged()
	case 'pf_position_statusid'
		iuo_dddw_search_status.uf_editchanged()
	case 'pf_position_lastcargo'
		iuo_dddw_search_cargo1.uf_editchanged()
	case 'pf_position_secondlast'
		iuo_dddw_search_cargo2.uf_editchanged()
	case 'pf_position_thirdlast'
		iuo_dddw_search_cargo3.uf_editchanged()
end choose

	wf_controlbutton('Edit')

end event

event rbuttondown;
/********************************************************************
   ue_rbuttondown
   <DESC>	Show fixture on subs data of vessel datawindow	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
   <ACCESS> public </ACCESS>
   <ARGS>
		xpos: Mouse X position
		ypos: Mouse Y position
		row : Data row
		dwo : Datawindow object
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-08-2016 4193         KSH092        		 First Version
   </HISTORY>
********************************************************************/
long 	ll_vessel_nr
datawindowchild ldwc


if row <= 0 then return
ll_vessel_nr = this.getitemnumber(row,'pf_position_vesselid')
if ll_vessel_nr = 0 or isnull(ll_vessel_nr) then return
if dwo.type = "column" and string(dwo.name) = "fixture_subs"  then	
 	if this.getitemstring(row,'fixture_subs') = 'Yes' then
		dw_fixture_subdata.x = xpos * 4  + 100
		dw_fixture_subdata.y = ypos * 4  + 280
		dw_fixture_subdata.getchild("chartererid",ldwc)
		ldwc.settransobject(sqlca)
		ldwc.retrieve(ii_pcgroup)
		dw_fixture_subdata.getchild("brokerid",ldwc)
		ldwc.settransobject(sqlca)
		ldwc.retrieve(ii_pcgroup)
		dw_fixture_subdata.getchild("tradeid",ldwc)
		ldwc.settransobject(sqlca)
		ldwc.retrieve(ii_pcgroup)
		dw_fixture_subdata.retrieve(ll_vessel_nr)
		dw_fixture_subdata.getchild("cargoid",ldwc)
		ldwc.settransobject(sqlca)
		ldwc.retrieve(ii_pcgroup)
		dw_fixture_subdata.visible = true
		dw_fixture_subdata.setfocus()
	end if
end if

return c#return.Success
end event

event itemerror;call super::itemerror;int li_return

li_return = 1

this.selecttext(1,len(data))

choose case dwo.name
	case 'pf_position_categoryid'
		is_labeltext = 'Public'
	case "pf_position_statusid", "pf_position_worldareaid", "vessels_vessel_name", "pf_position_companyid"
		li_return = 3
	case "pf_position_opendate"
		is_labeltext = "Date"
end choose

return li_return
end event

event constructor;call super::constructor;this.setTransObject(SQLCA)


end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	dw_position_list.selectrow(0, false)
	dw_position_list.selectrow(currentrow, true)
end if


end event

event destructor;call super::destructor;DESTROY iuo_dddw_search_charterer
DESTROY iuo_dddw_search_openport
DESTROY iuo_dddw_search_vessel
DESTROY iuo_dddw_search_area
end event

event losefocus;call super::losefocus;if getcolumnname() <> "vessels_vessel_name" then
	dw_position_list.settaborder('vessels_vessel_name',0)
end if
end event

event getfocus;call super::getfocus;this.settaborder('vessels_vessel_name', 1)
this.modify("vessels_vessel_name.protect='0~tif(isRowNew() , 0, 1)' ")
if keydown(KeyTab!) then
	this.setcolumn("vessels_vessel_name")
end if

end event

event ue_set_column;string ls_columnname

ls_columnname = this.getcolumnname()

if ls_columnname = "vessels_vessel_name" &
	or ls_columnname = "pf_position_companyid" &
	or ls_columnname = "pf_position_worldareaid" &
	or ls_columnname = "pf_position_statusid"  then

	this.of_set_column()
end if

end event

event ue_dwkeypress;//block the base class method
pointer oldpointer
if keyflags=3 or keyflags=2 then  
	CHOOSE CASE key
		CASE KeyPeriod!
			of_insert_personal_stamp("full")
		CASE KeyComma!
			of_insert_personal_stamp("short")
		CASE KeyS!
			oldpointer = setpointer(HourGlass!)
			cb_saveas.event post clicked()
			setpointer(oldpointer)
		CASE KeyA!
			of_selectall()
	END CHOOSE
	
	if ib_usectrl0 and keyflags = 2 and (key = Key0! or key = KeyNumpad0!) then
		of_setnull()
	end if
end if
end event

type dw_mailpositions_html from mt_u_datawindow within w_position_list
boolean visible = false
integer x = 1824
integer y = 2032
boolean bringtotop = true
string dataobject = "d_mail_positions_html"
end type

type cb_movecargo from commandbutton within w_position_list
integer x = 4155
integer y = 2824
integer width = 343
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "M&ove Cargo"
end type

event clicked;string		ls_last, ls_second, ls_third

dw_position_list.accepttext( )

if dw_position_list.getrow() < 1 then return

ls_last = dw_position_list.getitemstring(dw_position_list.getrow(), "pf_position_lastcargo")
ls_second = dw_position_list.getitemstring(dw_position_list.getrow(), "pf_position_secondlast")
ls_third = dw_position_list.getitemstring(dw_position_list.getrow(), "pf_position_thirdlast")

dw_position_list.setitem(dw_position_list.getrow(), "pf_position_thirdlast",ls_second ) 
dw_position_list.setitem(dw_position_list.getrow(), "pf_position_secondlast",ls_last ) 
dw_position_list.setitem(dw_position_list.getrow(), "pf_position_lastcargo",ls_third) 

wf_controlbutton('Edit')

end event

type dw_print from u_datagrid within w_position_list
boolean visible = false
integer x = 763
integer y = 2172
integer width = 928
integer height = 548
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_position_list_print"
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
end type

type cb_mailpositions from u_cb_option within w_position_list
integer x = 37
integer y = 2824
integer width = 686
integer taborder = 70
boolean bringtotop = true
string text = "S&end Position List Email >>"
end type

event constructor;call super::constructor;of_addmenuitem(is_IMOMAIL)
of_addmenuitem(is_PUBLICMAIL)
end event

event ue_command;call super::ue_command;mt_n_outgoingmail lnv_mail

string 	ls_message, ls_company, ls_contact 
long 		ll_rc, ll_rows, ll_row, ll_companyid
date		ld_last_update
string		ls_email, ls_printer,ls_curPath
int			li_categoryid, li_return, li_messagebutton, li_mailtype
boolean	lbl_company
s_companyemailtype s_emailtype

if _ib_validcompanies=false then
	MessageBox("Error","There are no companies to email positions to. Please add.")
	return
end if

li_return = wf_checkdatasave()

if li_return = C#return.Failure then
	return
end if

choose case as_text
	case is_IMOMAIL
		li_mailtype = 1// IMO Email
	case is_PUBLICMAIL
		li_mailtype = 0 //Public Email
end choose
s_emailtype.li_emailtype = li_mailtype
s_emailtype.li_pcgroup = ii_pcgroup
If ii_pcgroup <> 0 then
	openwithparm(w_position_email, s_emailtype)
	If Message.DoubleParm <> 1 then Return
End if

dw_mail_positions.reset()
dw_mail_positions.retrieve(ii_pcgroup)
if li_mailtype = 1 then
	dw_mail_positions.setfilter("imo_check = 1")
else
	dw_mail_positions.setfilter("public_check = 1")
end if

dw_mail_positions.filter()
dw_mail_positions.groupcalc()

if dw_mail_positions.rowcount( ) = 0 then
	messagebox("Info","There is no position to mail.")
	return
else
	ls_printer = uo_global.is_pdfdriver
	dw_mail_positions.Object.DataWindow.Export.PDF.Method = Distill!    
	dw_mail_positions.Object.DataWindow.Printer = ls_printer  
	dw_mail_positions.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"	
	ls_curPath = GetCurrentDirectory()
	
	if dw_mail_positions.saveas(ls_curPath + "\positions.pdf", PDF!, false) <> 1 then messagebox("Info","Error when saving daily report.")

end if


lnv_mail = create mt_n_outgoingmail
ids_wrong_mail_addresses = create mt_n_datastore
ids_wrong_mail_addresses.dataObject = "d_failed_emails"

dw_mail_company.settransobject(SQLCA)
dw_mail_company.reset()
dw_mail_company.retrieve(ii_pcgroup)
if li_mailtype = 1 then
	dw_mail_company.setfilter("pf_companycontacts_imo_check = 1")
elseif li_mailtype = 0 then
	dw_mail_company.setfilter("pf_companycontacts_maillist = 1")
end if
dw_mail_company.filter()

ll_rows = dw_mail_company.rowcount()



hpb_mail.maxposition = ll_rows
for ll_row = 1 to ll_rows
	hpb_mail.position = ll_row
	ls_company = dw_mail_company.getitemstring(ll_row,"pf_company_company")
	ls_contact = dw_mail_company.getitemstring(ll_row,"pf_companycontacts_fullname")
	if ll_row = 1 then
		of_sendmail(dw_mail_company.getitemstring(ll_row,"pf_companycontacts_email") ,lnv_mail,ii_pcgroup,li_mailtype, ls_company, ls_contact, "pf_companycontacts_email", dw_mail_company.getitemnumber(ll_row,"pf_companycontacts_contactsid"))
	else
		if dw_mail_company.getitemnumber( ll_row,"pf_company_companyid") = dw_mail_company.getitemnumber( ll_row - 1,"pf_company_companyid") then
			lbl_company = true //same company
		else
			lbl_company = false //different company
		end if
		if lbl_company then
			of_sendmail(dw_mail_company.getitemstring(ll_row,"pf_companycontacts_email") ,lnv_mail,ii_pcgroup,li_mailtype, ls_company, ls_contact, "pf_companycontacts_email", dw_mail_company.getitemnumber(ll_row,"pf_companycontacts_contactsid"))
		else
			of_sendmail(dw_mail_company.getitemstring(ll_row,"pf_companycontacts_email") ,lnv_mail,ii_pcgroup,li_mailtype, ls_company, ls_contact, "pf_companycontacts_email", dw_mail_company.getitemnumber(ll_row,"pf_companycontacts_contactsid"))
		end if
	end if
	UPDATE PF_POSITIONEMAIL
	SET LASTSENT = GETDATE(), LASTSENT_BY = :uo_global.gos_userid
	WHERE PCGROUP_ID = :ii_pcgroup and EMAIL_TYPE = :li_mailtype;
	if SQLCA.SQLCode = 0 then
		COMMIT;
		if li_mailtype = 1 then
			is_IMOMAIL = "IMO - Last sent: " + string(today(),"dd-mm-yy hh:mm ;'none'") + ' by '+ uo_global.gos_userid
			cb_mailpositions.of_modifymenuitem(2,is_IMOMAIL)
		else
			is_PUBLICMAIL = "Public - Last sent: " + string(today(),"dd-mm-yy hh:mm ;'none'") + ' by '+ uo_global.gos_userid
			cb_mailpositions.of_modifymenuitem(1,is_PUBLICMAIL)
		end if
	else
		ROLLBACK;
		messagebox("Update Error","System failed to update LASTSENT date in table PF_POSITIONEMAIL.")
	end if		
next

fileDelete(ls_curPath + "\positions.pdf")


destroy lnv_mail

if ids_wrong_mail_addresses.rowcount() > 0 then openwithparm(w_show_failed_mailaddresses, ids_wrong_mail_addresses )


end event

