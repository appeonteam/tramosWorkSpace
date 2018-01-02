$PBExportHeader$w_port_bak.srw
$PBExportComments$Maintainance of port coredata
forward
global type w_port_bak from w_coredata_ancestor
end type
type cb_3 from commandbutton within tabpage_1
end type
type cb_4 from commandbutton within tabpage_1
end type
type tabpage_2 from userobject within tab_1
end type
type cb_2 from commandbutton within tabpage_2
end type
type dw_2 from u_datagrid within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_2 cb_2
dw_2 dw_2
end type
type tabpage_4 from userobject within tab_1
end type
type gb_2 from groupbox within tabpage_4
end type
type st_3 from statictext within tabpage_4
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
gb_2 gb_2
st_3 st_3
dw_4 dw_4
end type
type tabpage_port_details from userobject within tab_1
end type
type dw_ports_details from mt_u_datawindow within tabpage_port_details
end type
type gb_1 from groupbox within tabpage_port_details
end type
type uo_port_att from u_fileattach within tabpage_port_details
end type
type tabpage_port_details from userobject within tab_1
dw_ports_details dw_ports_details
gb_1 gb_1
uo_port_att uo_port_att
end type
type tabpage_details_log from userobject within tab_1
end type
type dw_details_log_desc from mt_u_datawindow within tabpage_details_log
end type
type dw_details_log from mt_u_datawindow within tabpage_details_log
end type
type tabpage_details_log from userobject within tab_1
dw_details_log_desc dw_details_log_desc
dw_details_log dw_details_log
end type
type cb_withoutarea from commandbutton within w_port_bak
end type
type cb_1 from commandbutton within w_port_bak
end type
type st_2 from u_topbar_background within w_port_bak
end type
end forward

global type w_port_bak from w_coredata_ancestor
integer width = 4608
integer height = 2568
string title = "Ports"
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
cb_withoutarea cb_withoutarea
cb_1 cb_1
st_2 st_2
end type
global w_port_bak w_port_bak

type variables
integer 	 ii_max_no_of_tanks = 18
n_comment in_comment
n_service_manager inv_servicemgr

end variables

forward prototypes
public function integer uf_validategeneral ()
public function integer uf_updatespending ()
public subroutine uf_updatepicklist ()
public function datawindow uf_getdatawindow (userobject arg_object, integer arg_dw_no)
public function datawindow uf_getdatawindow (userobject arg_object)
public subroutine uf_enabletabpages (boolean arg_enable, integer arg_first_tab, integer arg_last_tab)
public function long uf_gui_control (integer arg_tabpage, string arg_command)
public function integer uf_deleteport (integer al_row)
public subroutine documentation ()
private subroutine _set_permission ()
public subroutine wf_insert_portdetailhistory (datastore ds_port_detail_history, string as_new, string as_old, string as_port_code, datetime adt_today, string as_type)
end prototypes

public function integer uf_validategeneral ();string 	ls_null; long		ll_null
string 	ls_portcode, ls_check_portname
long		ll_AtoBviaC_portid,ll_count
long		ll_#of_Areas, ll_areaRow, ll_#of_primaryAreas=0

setNull(ls_null) ; setNull(ll_null) ; setNull(ls_check_portname)  
tab_1.tabpage_1.dw_1.Accepttext()
	
/* Type is mandatory {Port, Via-point, Canal} */
if isnull(tab_1.tabpage_1.dw_1.object.via_point[1]) then
	MessageBox("Error","You must select a type")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("via_point")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

/* Port Code is mandatory eighter 2 or 3 characters */
ls_portcode = tab_1.tabpage_1.dw_1.object.port_code[1]
if isnull(tab_1.tabpage_1.dw_1.object.port_code[1]) then
	MessageBox("Error","You must enter a port code")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("port_code")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
else//port code if exists database

	if tab_1.tabpage_1.dw_1.getitemstatus(1,"port_code",Primary!) = Datamodified! then
		SELECT count(*) 
		INTO :ll_count
		FROM PORTS
		WHERE PORT_CODE = :ls_portcode;
		if ll_count > 0 then
			messagebox("Error","Port code already exists.")
			tab_1.post selectTab(1)
			tab_1.tabpage_1.dw_1.post setColumn("port_code")
			tab_1.tabpage_1.dw_1.post setFocus()
			return -1
		end if
	end if
	
end if

if len(ls_portcode) < 2 or len(ls_portcode) > 3 then
	MessageBox("Error","Port Code must be 2 or 3 characters")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("port_code")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

/* Port Name is mandatory */
if isnull(tab_1.tabpage_1.dw_1.object.port_n[1]) then
	MessageBox("Error","You must enter a port name")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("port_n")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

/* If MAROPS Redflag is selected then make sure MAROPS Notes are present */
tab_1.tabpage_1.dw_1.setItem(1,"Ports_Vett_Notes", Trim(tab_1.tabpage_1.dw_1.getItemString(1, "Ports_Vett_Notes")))
If tab_1.tabpage_1.dw_1.getItemNumber(1, "Ports_Vett_Redflag")=1 then
	If Trim(tab_1.tabpage_1.dw_1.getItemString(1, "Ports_Vett_Notes"))="" or IsNull(tab_1.tabpage_1.dw_1.getItemString(1, "Ports_Vett_Notes")) Then
		Messagebox("Validation Error", "If this port is a MAROPS Redflag port, please enter the reason why under 'MAROPS Notes'", Exclamation!)
		Return -1
	End If
End If

/* If Via-point or canal then
	if 2 char portcode: NO AtoBviaC allowed, must have disbursement portcode, must be via point or canal
	if 3 char portcode: NO disbursement portcode, must have AtoBviaC, AtoBviaC must not be used for other ports */
if tab_1.tabpage_1.dw_1.object.via_point[1] > 0 then  				// via-point or canal
	if len(ls_portcode) = 2 then												// 2 character via-point
		MessageBox("Information", "Two character port codes are only valid for old BP"+&
									  "~n~rdistance table and old calculations. If you plan to" +&
									  "~n~ruse the via-point, create one 3 characters long.")
		if isnull(tab_1.tabpage_1.dw_1.object.disb_port_code[1]) then
			MessageBox("Error","You must enter a disbursement port code")
			tab_1.post selectTab(1)
			tab_1.tabpage_1.dw_1.post setColumn("disb_port_code")
			tab_1.tabpage_1.dw_1.post setFocus()
			Return -1
		end if
		tab_1.tabpage_1.dw_1.object.abc_portid[1] = ll_null
	else																			// 3 character via-point
		if isNull(tab_1.tabpage_1.dw_1.object.abc_portid[1]) then
			MessageBox("Error","You must enter a AtoBviaC code")
			tab_1.post selectTab(1)
			tab_1.tabpage_1.dw_1.post setColumn("abc_portid")
			tab_1.tabpage_1.dw_1.post setFocus()
			Return -1
		else
			ll_AtoBviaC_portid = tab_1.tabpage_1.dw_1.object.abc_portid[1]
			setNull(ls_check_portname)
			SELECT PORT_N
				INTO :ls_check_portname
				FROM PORTS
				WHERE PORT_CODE <> :ls_portcode
				AND ABC_PORTID =  :ll_AtoBviaC_portid ;
			if not isNull(ls_check_portname) then
				MessageBox("Validation error", "AtoBviaC Code already used. Please select another code or change existing." +&
														"~n~r~n~rPort using code = '"+ls_check_portname+"'" )
				tab_1.post selectTab(1)
				tab_1.tabpage_1.dw_1.post setColumn("abc_portid")
				tab_1.tabpage_1.dw_1.post setFocus()
				Return -1
			end if				
		end if
		tab_1.tabpage_1.dw_1.object.disb_port_code[1]=ls_null
	end if
else 																				// port
	if len(ls_portcode) <> 3 then											// 2 character - not allowed
		MessageBox("Validation error", "Port codes must be 3 characters long.")
		tab_1.post selectTab(1)
		tab_1.tabpage_1.dw_1.post setColumn("port_code")
		tab_1.tabpage_1.dw_1.post setFocus()
		Return -1
	else																			// 3 character port
		if isNull(tab_1.tabpage_1.dw_1.object.abc_portid[1]) then   
			MessageBox("Error","You must enter a AtoBviaC code to use this port in calculations")
			//return -1  Please don't remove this as it is allowed to create a port without this code
		else																		// with AtoBviaC Code
			ll_AtoBviaC_portid = tab_1.tabpage_1.dw_1.object.abc_portid[1]
			setNull(ls_check_portname)
			SELECT PORT_N
				INTO :ls_check_portname
				FROM PORTS
				WHERE PORT_CODE <> :ls_portcode
				AND VIA_POINT > 0
				AND ABC_PORTID =  :ll_AtoBviaC_portid ;
			if not isNull(ls_check_portname) then
				MessageBox("Validation error", "AtoBviaC already used for one Via-point or Canal. Please select another, or change via-point/canal." +&
														"~n~r~n~rPort using code = '"+ls_check_portname+"'" )
				tab_1.post selectTab(1)
				tab_1.tabpage_1.dw_1.post setColumn("abc_portid")
				tab_1.tabpage_1.dw_1.post setFocus()
				Return -1
			end if				
		end if			
		tab_1.tabpage_1.dw_1.object.disb_port_code[1]=ls_null
	end if
end if

if isnull(tab_1.tabpage_1.dw_1.object.country_id[1]) then
	MessageBox("Error","You must select a country")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("country_id")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

/* If more than one row in area, check that there are not more than 1 primary */
ll_#of_Areas = tab_1.tabpage_2.dw_2.rowcount( )
if ll_#of_Areas = 1 then tab_1.tabpage_2.dw_2.setItem(1, "primary_area", 1)
if ll_#of_Areas > 1 then
	for ll_areaRow = 1 to ll_#of_Areas
		if tab_1.tabpage_2.dw_2.getItemNumber(ll_areaRow, "primary_area" ) = 1 then ll_#of_primaryAreas ++
	next
	if ll_#of_primaryAreas <> 1 then
		MessageBox("Validation Error", "There must be one and only one Primary Area. Please correct!")
		return -1
	end if
end if	

return 1
end function

public function integer uf_updatespending ();long ll_anyModifications = 0

tab_1.tabpage_1.dw_1.acceptText()
tab_1.tabpage_2.dw_2.acceptText()
tab_1.tabpage_4.dw_4.acceptText()
tab_1.tabpage_port_details.dw_ports_details.acceptText()


ll_anymodifications = tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()
ll_anymodifications += tab_1.tabpage_2.dw_2.modifiedCount() + tab_1.tabpage_2.dw_2.deletedCount()
ll_anymodifications += tab_1.tabpage_4.dw_4.modifiedCount() + tab_1.tabpage_4.dw_4.deletedCount()
ll_anymodifications += tab_1.tabpage_port_details.dw_ports_details.modifiedCount() + tab_1.tabpage_port_details.dw_ports_details.deletedCount()


if ll_anymodifications > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		if cb_update.triggerevent( Clicked!)<0 then return -1
	else
		tab_1.tabpage_1.dw_1.reset()
		tab_1.tabpage_2.dw_2.reset()
		tab_1.tabpage_4.dw_4.reset()
		tab_1.tabpage_port_details.dw_ports_details.reset()
		return 0
	end if
end if

return 0
end function

public subroutine uf_updatepicklist ();long	 	ll_countryID
string 	ls_countryname, ls_search_string, ls_portcode
long 		ll_row, ll_rc, ll_country_row, ll_min, ll_max
datawindowchild ldwc

ll_row = dw_list.getSelectedRow(0)
if tab_1.tabpage_1.dw_1.rowCount() > 0 then
	ls_portcode = tab_1.tabpage_1.dw_1.GetItemString(tab_1.tabpage_1.dw_1.getRow(), "port_code")
else
	setNull(ll_countryID)
end if

IF tab_1.SelectedTab = 1 THEN
	ls_countryname = dw_dddw.getItemString(dw_dddw.getRow(), "country_name")
	IF ls_countryname = "<All>" THEN
		ll_min = -9999
		ll_max = 9999
	ELSE	
		dw_dddw.getChild("country_name", ldwc)
		ll_country_row = ldwc.find("country_name='"+ls_countryname+"'",1, 9999)
		ll_min = ldwc.getItemNumber(ll_country_row, "country_id")
		ll_max = ll_min
	END IF
	
	dw_list.retrieve(ll_min, ll_max)		
	IF tab_1.tabpage_1.dw_1.rowCount() > 0 THEN  //new or modified
	   tab_1.tabpage_1.dw_1.accepttext()
	   tab_1.tabpage_2.dw_2.accepttext()
	   ls_search_string = "port_code = '"+ls_portcode+"'"
	   ll_row = dw_list.Find(ls_search_string, 1, dw_list.rowCount() )
	END IF
	IF ll_row < 1 OR ll_row > dw_list.rowCount() THEN // delete
   	ll_row = 1
	END IF
END IF

// Triggers the Clicked-event of dw_list with the selected row
dw_list.EVENT Clicked(0, 0, ll_row, dw_list.object)

//Scroll to the selected row
ll_row = dw_list.getRow()
IF NOT isNull(ls_portcode) THEN
   ls_search_string = "port_code = '"+ls_portcode+"'" 
	ll_row = dw_list.Find(ls_search_string, 1, dw_list.rowCount() ) 
END IF
dw_list.scrollToRow(ll_row)

//enable all tabpages
uf_enableTabPages(TRUE, 2, 5)

end subroutine

public function datawindow uf_getdatawindow (userobject arg_object, integer arg_dw_no);DataWindow ldw_result
long ll_index

FOR ll_index = 1 TO upperBound(arg_object.control)
   IF arg_object.control[ll_index].typeOf() = DataWindow! THEN
		ldw_result = arg_object.control[ll_index]
		If ldw_result.tag = string(arg_dw_no) Then
			Return ldw_result
		End if
   END IF
NEXT

RETURN ldw_result

end function

public function datawindow uf_getdatawindow (userobject arg_object);DataWindow ldw_result
long ll_index

FOR ll_index = 1 TO upperBound(arg_object.control)
   IF arg_object.control[ll_index].typeOf() = DataWindow! THEN
		ldw_result = arg_object.control[ll_index]
		RETURN ldw_result
   END IF
NEXT

RETURN ldw_result

end function

public subroutine uf_enabletabpages (boolean arg_enable, integer arg_first_tab, integer arg_last_tab);long ll_index

FOR ll_index = arg_first_tab TO arg_last_tab
	   tab_1.Control[ll_index].enabled = arg_enable
NEXT


end subroutine

public function long uf_gui_control (integer arg_tabpage, string arg_command);DataWindow ldw_d
long ll_rc

Choose case arg_tabpage
	Case 1 
		Choose case arg_command
			Case "New"
				   uf_enableTabPages(FALSE, 2, 5)
			Case "Delete"
			Case "Update"
			Case "Cancel"
               uf_enableTabPages(TRUE, 2, 5)
			Case "Tab"
		End choose
End choose

Return 1

end function

public function integer uf_deleteport (integer al_row);string ls_portCode

ls_portCode = dw_list.getItemString(al_row, "port_code")

//FIRST DELETE ALL BERTH INFORMATION
DELETE BERTH_ILL_LAST3_GRADE  
	FROM BERTH_ILL_LAST3_GRADE,   
        BERTH  
   WHERE BERTH.BERTH_ID = BERTH_ILL_LAST3_GRADE.BERTH_ID and  
         BERTH.PORT_CODE = :ls_portCode  ;
if sqlca.sqlcode <> 0 then return -1
	
DELETE BERTH_COND_GRADE  
	FROM BERTH_COND_GRADE,   
        BERTH  
   WHERE BERTH.BERTH_ID = BERTH_COND_GRADE.BERTH_ID and  
         BERTH.PORT_CODE = :ls_portCode  ;
if sqlca.sqlcode <> 0 then return -1
  
DELETE BERTH_CNSTR  
	FROM BERTH_CNSTR,   
        BERTH  
   WHERE BERTH.BERTH_ID = BERTH_CNSTR.BERTH_ID and  
         BERTH.PORT_CODE = :ls_portCode  ;
if sqlca.sqlcode <> 0 then return -1

DELETE BERTH_AVAIL_GRADE  
	FROM BERTH_AVAIL_GRADE,   
        BERTH  
   WHERE BERTH.BERTH_ID = BERTH_AVAIL_GRADE.BERTH_ID and  
         BERTH.PORT_CODE = :ls_portCode  ;
if sqlca.sqlcode <> 0 then return -1

DELETE 
	FROM BERTH  
   WHERE BERTH.PORT_CODE = :ls_portCode  ;
if sqlca.sqlcode <> 0 then return -1

//DELETE PORT RELATEREDE DATA
DELETE 
	FROM AREA_PORTS  
	WHERE PORT_CODE = :ls_portCode; 
if sqlca.sqlcode <> 0 then return -1
	
return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_port
	
   <OBJECT></OBJECT>
   <DESC></DESC>
   <USAGE>
	
   </USAGE>
   <ALSO></ALSO>
    	Date   	Ref		Author		Comments
  	00/00/07	?      		Name Here	First Version
  	13/05/11	 CR2232	CONASW	Added created date and user name
	11/10/11  CR2602  CONASW   Added "Vetting Red Flag" field in d_port_detail
	17/02/12	 CR2602	CONASW	Added "MAROPS Notes" field in d_port_detail and added validation
	22/11/12	 CR2990	RJH022	Added a new tab page "Details" with one large free text field next to "Berths" tab page
	27/06/14	 CR3735	AZX004	Port switching, increased according to the requirement of users save code.
	28/08/14	 CR3781	CCY018	The window title match with the text of a menu item
	04/09/14  CR3759  KSH092	Details add attachment
   04/09/14  CR3760  KSH092   Details text add internet or email link
	04/09/14  CR3758  KSH092   Add Details log tabpage
	24/11/17  CR4661  XSZ004   Change delete attachments access for Port Details and Vessel Details tab.		
********************************************************************/
end subroutine

private subroutine _set_permission ();/********************************************************************
   _set_permissions
   <DESC>Access control for tabpages in this window.</DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		24/05/2014		CR2648		XSZ004		First Version	      
   </HISTORY>
********************************************************************/
int 	 li_tab_index

cb_new.enabled 	= False
cb_update.enabled = False
cb_delete.enabled = False
cb_Cancel.Enabled = False
tab_1.tabpage_1.cb_3.Enabled = False
tab_1.tabpage_1.cb_4.Enabled = False
tab_1.tabpage_4.dw_4.enabled = false
tab_1.tabpage_1.dw_1.modify("Datawindow.ReadOnly = 'Yes'")
tab_1.tabpage_2.dw_2.modify("Datawindow.ReadOnly = 'Yes'")
//tab_1.tabpage_port_details.dw_ports_details.modify("Datawindow.ReadOnly = 'Yes'")
//tab_1.tabpage_port_details.dw_ports_details.modify("Datawindow.ReadOnly = 'Yes'")

li_tab_index = tab_1.selectedtab

CHOOSE CASE li_tab_index
	CASE 1	
		if (uo_global.ii_access_level = C#usergroup.#ADMINISTRATOR) or (uo_global.ii_user_profile = 3) then
			cb_new.enabled 	= true
			cb_update.enabled = true
			cb_delete.enabled = true
			cb_cancel.enabled = true
			tab_1.tabpage_1.cb_3.Enabled = true
			tab_1.tabpage_1.cb_4.Enabled = true
			tab_1.tabpage_1.dw_1.modify("Datawindow.ReadOnly = 'No'")
		end if
	CASE 2
		if (uo_global.ii_user_profile < 4) and (uo_global.ii_access_level >= C#usergroup.#USER) then		
			cb_new.enabled 	= true
			cb_update.enabled = true
			cb_delete.enabled = true
			cb_cancel.enabled = true
			tab_1.tabpage_2.dw_2.modify("Datawindow.ReadOnly = 'No'")
		end if
	case 3
		tab_1.tabpage_4.dw_4.enabled = true	
	CASE 4
		if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	
			cb_update.enabled = true
			cb_cancel.enabled = true

		end if
END CHOOSE



end subroutine

public subroutine wf_insert_portdetailhistory (datastore ds_port_detail_history, string as_new, string as_old, string as_port_code, datetime adt_today, string as_type);	/********************************************************************
   wf_insert_portdetailhistory()
   <DESC>	When update attachment,insert change history	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	cb_update.event clicked( )	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/09/14	CR3758        KSH092   First Version
   </HISTORY>
********************************************************************/
int li_row
	
li_row = ds_port_detail_history.insertrow(0)
ds_port_detail_history.setitem(li_row,'port_code',as_port_code)
if isnull(as_new) then as_new = ''
if isnull(as_old) then as_old = ''
if as_type = 'details' then
	ds_port_detail_history.setitem(li_row,'description','Port detail changed. See text below.')
	ds_port_detail_history.setitem(li_row,'detail_new',as_new)
	ds_port_detail_history.setitem(li_row,'detail_old',as_old)
elseif as_type = 'delete' then
	ds_port_detail_history.setitem(li_row,'description','Delete attachment: ' + as_new)
end if

	
ds_port_detail_history.setitem(li_row,'updated_date',adt_today)
ds_port_detail_history.setitem(li_row,'updated_by',uo_global.gos_userid)
end subroutine

on w_port_bak.create
int iCurrent
call super::create
this.cb_withoutarea=create cb_withoutarea
this.cb_1=create cb_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_withoutarea
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_2
end on

on w_port_bak.destroy
call super::destroy
destroy(this.cb_withoutarea)
destroy(this.cb_1)
destroy(this.st_2)
end on

event open;call super::open;n_dw_style_service   lnv_style

datawindowchild ldwc
long ll_row
integer li_profile

in_comment = create n_comment

dw_dddw.setTransObject(SQLCA)
dw_dddw.insertrow(0)
dw_dddw.object.country_name[1] = "<All>"
dw_dddw.object.country_id[1] = 9999
dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_2.dw_2.setTransObject(SQLCA)
tab_1.tabpage_port_details.dw_ports_details.setTransObject(SQLCA)
tab_1.tabpage_4.dw_4.setTransObject(SQLCA)
tab_1.tabpage_details_log.dw_details_log.setTransObject(SQLCA)
tab_1.tabpage_details_log.dw_details_log_desc.setTransObject(SQLCA)

tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_port_details.dw_ports_details)


inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_list, false)

lnv_style.of_registercolumn("port_code", true)
lnv_style.of_registercolumn("disb_port_code", true)
lnv_style.of_registercolumn("port_n", true)
lnv_style.of_registercolumn("country_id", true)
lnv_style.of_dwformformater( tab_1.tabpage_1.dw_1)
tab_1.tabpage_port_details.dw_ports_details.is_hyperlinkshortcut = "ports_details"


lnv_style.of_registercolumn("area_pk", true)
lnv_style.of_dwlistformater(tab_1.tabpage_2.dw_2, false)
lnv_style.of_dwlistformater(tab_1.tabpage_details_log.dw_details_log,false)

// Initialize search box
uo_searchbox.of_setlabel("Search", false)

//ports detail attachment
tab_1.tabpage_port_details.uo_port_att.of_init()

tab_1.tabpage_port_details.uo_port_att.dw_file_listing.modify("description.width = 2365")

tab_1.tabpage_port_details.uo_port_att.post of_init()
tab_1.tabpage_port_details.uo_port_att.of_addupdatetable("ATTACHMENTS","file_id")
tab_1.tabpage_port_details.uo_port_att.of_addupdatetable("PORTS_ACTION","port_code,file_id","port_code,file_id")
tab_1.tabpage_port_details.uo_port_att.visible = true
tab_1.tabpage_port_details.uo_port_att.pb_new.visible = true
tab_1.tabpage_port_details.uo_port_att.pb_delete.visible = true
tab_1.tabpage_port_details.uo_port_att.dw_file_listing.ib_columntitlesort = true
tab_1.tabpage_port_details.uo_port_att.dw_file_listing.ib_multicolumnsort = true
tab_1.tabpage_port_details.uo_port_att.dw_file_listing.ib_setselectrow = true
if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	

	tab_1.tabpage_port_details.uo_port_att.dw_file_listing.modify("Datawindow.ReadOnly = 'No'")
	tab_1.tabpage_port_details.dw_ports_details.object.ports_details.edit.displayonly = 'No'
	tab_1.tabpage_port_details.uo_port_att.pb_new.enabled = true

	tab_1.tabpage_port_details.uo_port_att.dw_file_listing.object.description.edit.displayonly = 'No'

else
	
	tab_1.tabpage_port_details.uo_port_att.dw_file_listing.modify("Datawindow.ReadOnly = 'Yes'")
	tab_1.tabpage_port_details.dw_ports_details.object.ports_details.edit.displayonly = 'Yes'
	tab_1.tabpage_port_details.uo_port_att.pb_new.enabled = false

	tab_1.tabpage_port_details.uo_port_att.dw_file_listing.object.description.edit.displayonly = 'Yes'
end if

if ( uo_global.ii_access_level = C#usergroup.#ADMINISTRATOR or uo_global.ii_access_level = C#usergroup.#SUPERUSER ) &
	and uo_global.ii_user_profile < 3 then
	
	tab_1.tabpage_port_details.uo_port_att.pb_delete.enabled = true
else
	tab_1.tabpage_port_details.uo_port_att.pb_delete.enabled = false
end if


dw_dddw.getChild("country_name", ldwc)
ldwc.settransobject(sqlca)
ldwc.retrieve()
ll_row = ldwc.insertRow(1)
ldwc.setItem(ll_row, "country_name", "<All>")
ldwc.setItem(ll_row, "country_id", 9999)


dw_dddw.setRow(1)
	
// Triggers the Clickedevent of dw_list
IF dw_list.retrieve(-9999, 9999) = 0 THEN
	Messagebox("Message", "No countries to be shown.")
ELSE
	dw_list.event Clicked(0,0,1,dw_list.object)
END IF

_set_permission()
if ib_setdefaultbackgroundcolor then _setbackgroundcolor()

// Init Searchbox
uo_searchbox.of_Initialize(dw_List, "port_code+'#'+port_n")
uo_searchbox.Sle_Search.SetFocus()

dw_list.SetSort("Port_code")
dw_list.Sort()
end event

event closequery;call super::closequery;
if uf_updatesPending() = -1 then
	// prevent
	return 1
else
	//allow
	if isvalid(w_area_ports) then
		close(w_area_ports)
	end if
	RETURN 0
end if
end event

event close;call super::close;destroy in_comment
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_port_bak
integer x = 2670
integer y = 32
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_port_bak
integer x = 18
boolean ib_standard_ui = true
end type

type st_1 from w_coredata_ancestor`st_1 within w_port_bak
integer x = 18
integer y = 16
integer height = 56
integer weight = 400
long textcolor = 16777215
long backcolor = 553648127
string text = "Country"
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_port_bak
integer x = 18
integer y = 88
integer height = 72
string dataobject = "d_country_picklist"
boolean livescroll = false
end type

event dw_dddw::itemchanged;call super::itemchanged;long ll_min, ll_max, ll_row
datawindowchild ldwc_name

if uf_updatesPending() = -1 then 
	cb_update.post setFocus()
	return 2
end if
this.getchild('country_name',ldwc_name)

IF data = "<All>" THEN
	ll_min = -9999
	ll_max = 9999
ELSE	
	ll_row = ldwc_name.find("country_name='"+data+"'",1, 9999)
	ll_min = ldwc_name.getItemNumber(ll_row, "country_id")
	ll_max = ll_min
END IF

uo_SearchBox.cb_Clear.Event Clicked()

IF dw_list.retrieve(ll_min, ll_max) = 0 THEN
	Messagebox("Message", "No ports to be shown.")
   tab_1.tabpage_1.dw_1.post reset()
	tab_1.tabpage_2.dw_2.post reset()
	tab_1.tabpage_port_details.uo_port_att.visible = false
	tab_1.tabpage_details_log.dw_details_log.post reset()
	tab_1.tabpage_details_log.dw_details_log_desc.post reset()
	tab_1.tabpage_1.cb_3.visible = false
	tab_1.tabpage_1.cb_4.visible = false
	
ELSE
	dw_list.event Clicked(0,0,1,dw_list.object)
	tab_1.tabpage_port_details.uo_port_att.visible = true
	tab_1.tabpage_1.cb_3.visible = true
	tab_1.tabpage_1.cb_4.visible = true
	
END IF
end event

event dw_dddw::itemerror;call super::itemerror;return 1
end event

type dw_list from w_coredata_ancestor`dw_list within w_port_bak
integer x = 18
integer y = 404
integer height = 1932
integer taborder = 30
string dataobject = "d_port_picklist"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_list::clicked;
// Call ancestor Clicked event to perform sorting
Super::Event Clicked(xpos, ypos, row, dwo)


if row > 0 and row = getrow() then
	if event rowfocuschanging(row, row) = 0 then
		this.event rowfocuschanged(row)
	end if
elseif row = 0 then
	
	if dwo.type = "text" then this.event rowfocuschanged(this.getrow())

end if
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;string	ls_portcode

if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
   setPointer(hourGlass!)

// Retrieval argument for tabpages
ls_portcode = dw_list.getItemString(currentrow, "port_code")

//Retrieve tabpages
tab_1.tabpage_1.dw_1.POST Retrieve(ls_portcode)
tab_1.tabpage_2.dw_2.POST Retrieve(ls_portcode)
//tab_1.tabpage_3.dw_3.POST Retrieve(ls_portcode)
tab_1.tabpage_4.dw_4.POST Retrieve(ls_portcode)
tab_1.tabpage_port_details.uo_port_att.post of_init()
tab_1.tabpage_details_log.dw_details_log.reset()
tab_1.tabpage_details_log.dw_details_log.Post retrieve(ls_portcode)
tab_1.tabpage_details_log.dw_details_log.setrow(1)
tab_1.tabpage_details_log.dw_details_log.scrolltorow(1)

uf_enableTabPages(TRUE, 2, 5)

SetPointer(Arrow!)
end if
end event

event dw_list::rowfocuschanging;call super::rowfocuschanging;if uf_updatespending() = c#return.failure then return 1
return 0

end event

type cb_close from w_coredata_ancestor`cb_close within w_port_bak
boolean visible = false
integer x = 4187
integer y = 1632
integer width = 343
integer height = 100
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;close(parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_port_bak
integer x = 4224
integer width = 343
integer height = 100
end type

event cb_cancel::clicked;call super::clicked;datawindow ldw_d

uf_gui_control(tab_1.selectedTab, "Cancel")
ldw_d  = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)
ldw_d.reset()
if dw_list.rowcount() > 0 then
   dw_list.EVENT POST Clicked(0, 0, dw_list.GetSelectedRow(0), dw_list.Object)
else
	tab_1.tabpage_1.cb_3.visible = false
	tab_1.tabpage_1.cb_4.visible = false
end if


end event

type cb_delete from w_coredata_ancestor`cb_delete within w_port_bak
integer x = 3877
integer width = 343
integer height = 100
end type

event cb_delete::clicked;long ll_response, ll_rc, ll_update, ll_row, ll_rowCount, ll_selectedrow
dataWindow ldw_d
long ll_currentrow

ll_currentrow = dw_list.getRow()
if ll_currentrow < 1 then return

uf_gui_control(tab_1.selectedTab, "Delete")

ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)

// Deleting selected row depending on the selected tabpage (the general page or any other page)
CHOOSE CASE tab_1.SelectedTab
    CASE 1    //Free form
      ll_response = Messagebox("Deleting!","You are about to delete a port and all information connected to it. ~r~n" + & 
                               "Do you wish to continue?", Question!, YesNo!, 2)
		IF ll_response = 1 THEN
			ll_rc = uf_deletePort(ll_currentrow)
			if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.deleterow(tab_1.tabpage_1.dw_1.getrow())
			if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.update()
			IF ll_rc < 0 THEN
				Messagebox("Error","Update not done. This could be due to data on tabpage # ~r~n" + &
							  string(tab_1.selectedTab) + " being used other places in the system or database error.~r~n~r~n")
				rollback;
				tab_1.tabpage_1.dw_1.retrieve(dw_list.getItemString(ll_currentrow, "port_code"))
				return
			ELSE
				commit;
				uf_updatepicklist()
				dw_list.Sort()
				dw_list.event Clicked(0, 0, ll_currentrow, dw_list.object)
				dw_list.scrollToRow(ll_currentrow)
			END IF
		END IF
	CASE 2   //Tabular form
    
		ll_row = ldw_d.rowcount()
		if ll_row < 1 then
			return
		end if
		ldw_d.accepttext()
		if ldw_d.getitemnumber(ldw_d.getrow(),'primary_area') = 1 then
			messagebox("Validation", "It is not allowed to delete the Primary Area.")
			return
		end if
      ll_response = Messagebox("Deleting!","You are about to delete the selected row on tabpage #"+string(tab_1.SelectedTab)+"~r~n" & 
                               , Question!, YesNo!, 2)
		IF ll_response = 1 THEN
			ldw_d.deleterow(ldw_d.getrow())
			IF ldw_d.update() <> 1 THEN

				rollback;	
				Messagebox("Error","Update not done. This could be due to data on tabpage #" + &
				string(tab_1.SelectedTab) + " being used other places in the system or database error.~r~n~r~n")
				ldw_d.retrieve(dw_list.getItemString(ll_currentrow, "port_code"))
				RETURN
			else
				commit;
			END IF
  		END IF
END CHOOSE
end event

type cb_new from w_coredata_ancestor`cb_new within w_port_bak
integer x = 3182
integer width = 343
integer height = 100
end type

event cb_new::clicked;long ll_row
dataWindow ldw_d

uf_gui_control(tab_1.selectedTab, "New")

CHOOSE CASE tab_1.selectedTab
	CASE 1
		if uf_updatesPending() = -1 then return
		tab_1.tabpage_2.dw_2.reset()
		tab_1.tabpage_4.dw_4.reset()
      ldw_d = uf_getDataWindow(tab_1.Control[1])
		ldw_d.reset()
      ll_row = ldw_d.insertRow(0)
		tab_1.tabpage_1.dw_1.Object.port_active[ll_row] = 1
      ldw_d.scrollToRow(ll_row)
		tab_1.tabpage_1.cb_3.visible = true
	   tab_1.tabpage_1.cb_4.visible = true
		ldw_d.POST setfocus()
		ldw_d.POST setcolumn("port_code")
   CASE ELSE
		if tab_1.tabpage_1.dw_1.getrow() > 0 then
         ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab],1)
         ll_row = ldw_d.insertRow(0)
         ldw_d.scrollToRow(ll_row)
		   ldw_d.setColumn(1)
		   ldw_d.setfocus()
		end if
END CHOOSE

end event

type cb_update from w_coredata_ancestor`cb_update within w_port_bak
integer x = 3529
integer width = 343
integer height = 100
end type

event cb_update::clicked;long ll_rc,ll_rc_history,li_rc_attachment
long ll_tabpage, ll_row, ll_picklist_row
dataWindow ldw_d
string ls_result,ls_port_code,ls_old,ls_new,ls_description
string ls_pick_countryname, ls_port_countryname
long ll_port_countryID, ll_port_row,ll_count
datawindowchild ldwc
long ll_area_pk, ll_area_row
boolean	lb_newport=false		//used to ask for primary Area
datetime ldt_today
int i
n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
datastore ds_port_detail_history

ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))

//add port detail history
ds_port_detail_history = create datastore
ds_port_detail_history.dataobject = 'd_sq_gr_ports_detail_history'
ds_port_detail_history.settransobject(sqlca)
ds_port_detail_history.reset()

uf_gui_control(tab_1.selectedTab, "Update")
if tab_1.tabpage_1.dw_1.rowcount() < 1 then return

//General - Update all tabpages
tab_1.tabpage_1.dw_1.acceptText()
tab_1.tabpage_2.dw_2.acceptText()
tab_1.tabpage_4.dw_4.acceptText()
tab_1.tabpage_port_details.uo_port_att.dw_file_listing.accepttext()
tab_1.tabpage_port_details.dw_ports_details.accepttext()

//Set foreign keys

ll_picklist_row = dw_list.getSelectedRow(0)
if ll_picklist_row > 0 then
   ls_port_code = dw_list.object.port_code[ll_picklist_row]
else
	if tab_1.tabpage_1.dw_1.getrow() > 0 then
	   ls_port_code = tab_1.tabpage_1.dw_1.getitemstring(tab_1.tabpage_1.dw_1.getrow(),'port_code')
	end if
end if
FOR ll_tabpage = 2 TO 3
	ldw_d = uf_getDataWindow(tab_1.Control[ll_tabpage], 1)
  	FOR ll_row = 1 TO  ldw_d.rowCount()
   	IF ldw_d.modifiedCount() > 0 THEN
			ldw_d.object.port_code[ll_row] = dw_list.object.port_code[ll_picklist_row]
		END IF	
	NEXT
NEXT


if uf_validategeneral() = -1 then return

/* If this is a new port that is created ask for the primary Area */
if tab_1.tabpage_1.dw_1.getItemStatus(1, 0, primary!) = newModified! and tab_1.tabpage_1.dw_1.getItemNumber(1, "via_point") = 0 then
	lb_newport = true
	ll_area_pk = long(f_select_from_list("d_area_list", 3, "Name",2,"Shortname",1, "Select Primary Area...",false))
	
	if IsNull(ll_area_pk) or ll_area_pk = 0 then
		MessageBox("Update Error", "Please press update again and select a primary Area for this port")
		return -1
	end if
end if	
ls_new = tab_1.tabpage_port_details.dw_ports_details.getitemstring(1,'ports_details')
ls_old = tab_1.tabpage_port_details.dw_ports_details.getitemstring(1,'ports_details',Primary!,true)
if isnull(ls_new) then ls_new = ''
if isnull(ls_old) then ls_old = ''
if ls_old <> ls_new then
	wf_insert_portdetailhistory(ds_port_detail_history,tab_1.tabpage_port_details.dw_ports_details.getitemstring(1,'ports_details'),tab_1.tabpage_port_details.dw_ports_details.getitemstring(1,'ports_details',Primary!,true),ls_port_code,ldt_today,'details')
end if


ll_rc = tab_1.tabpage_1.dw_1.update(TRUE, FALSE)
if ll_rc < 0 then
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc))
	return -1
else
	ll_rc_history = ds_port_detail_history.update(TRUE,FALSE)
	if ll_rc_history < 0 then
		Rollback;
		Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc_history))
		return -1
	else
		
		if tab_1.tabpage_port_details.uo_port_att.dw_file_listing.modifiedcount( )  > 0 or tab_1.tabpage_port_details.uo_port_att.dw_file_listing.deletedcount( ) > 0 then
			
			lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
			lnv_actionrules.of_registerrulestring("description", true, "description")
			if lnv_actionrules.of_validate(tab_1.tabpage_port_details.uo_port_att.dw_file_listing, true) = c#return.Failure then return c#return.Failure
			li_rc_attachment = tab_1.tabpage_port_details.uo_port_att.of_updateattach() 
			if li_rc_attachment < 0 then
				Rollback;
				Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc_history))
				return -1
			
			end if
		end if
	end if  
end if


if lb_newport then
	ll_area_row = 	tab_1.tabpage_2.dw_2.insertRow(0)
	tab_1.tabpage_2.dw_2.setItem(ll_area_row, "port_code", tab_1.tabpage_1.dw_1.getItemString(1, "port_code") )
	tab_1.tabpage_2.dw_2.setItem(ll_area_row, "area_pk", ll_area_pk)
	tab_1.tabpage_2.dw_2.setItem(ll_area_row, "primary_area", 1)
end if

ll_rc = tab_1.tabpage_2.dw_2.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "Port Area failed~r~nRC=" + String(ll_rc))
	return -1
END IF

//ll_rc = tab_1.tabpage_3.dw_3.update(TRUE, FALSE)
//IF ll_rc < 0 THEN
//	Messagebox("Error message; "+ this.ClassName(), "Port Expenses failed~r~nRC=" + String(ll_rc))
//	Rollback;
//	return -1
//END IF

ll_rc = tab_1.tabpage_4.dw_4.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "Berths Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
END IF

tab_1.tabpage_1.dw_1.resetUpdate()
tab_1.tabpage_2.dw_2.resetUpdate()
//tab_1.tabpage_3.dw_3.resetUpdate()
tab_1.tabpage_4.dw_4.resetUpdate()


COMMIT;


ls_pick_countryname = dw_dddw.getItemString(dw_dddw.getRow(), "country_name")
if ls_pick_countryname <> "<All>" then
	ll_port_countryID = tab_1.tabpage_1.dw_1.getItemNumber(1, "country_id")
	tab_1.tabpage_1.dw_1.getChild("country_id", ldwc)
	ll_port_row = ldwc.find("country_id="+string(ll_port_countryID),1,9999)
	ls_port_countryname = ldwc.getItemString(ll_port_row, "country_name")
	if ls_pick_countryname <> ls_port_countryname then
		dw_dddw.setItem(dw_dddw.getRow(), "country_name", ls_port_countryname)
	end if
end if	

// Update picklist
uf_updatePicklist()
destroy ds_port_detail_history
RETURN 1
end event

type st_list from w_coredata_ancestor`st_list within w_port_bak
boolean visible = false
integer x = 18
integer y = 416
integer weight = 400
string text = "Ports"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_port_bak
integer x = 1006
integer y = 240
integer width = 3566
integer height = 2096
integer taborder = 40
integer weight = 400
boolean multiline = true
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_port_details tabpage_port_details
tabpage_details_log tabpage_details_log
end type

on tab_1.create
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_port_details=create tabpage_port_details
this.tabpage_details_log=create tabpage_details_log
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_port_details,&
this.tabpage_details_log}
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_port_details)
destroy(this.tabpage_details_log)
end on

event tab_1::selectionchanged;_set_permission()

string ls_portcode
if newindex = 5 then
   if dw_list.getrow() > 0 then
		ls_portcode = dw_list.getItemString(dw_list.getrow(), "port_code")
		tab_1.tabpage_details_log.dw_details_log.reset()
	   tab_1.tabpage_details_log.dw_details_log.retrieve(ls_portcode)
      tab_1.tabpage_details_log.dw_details_log.setrow(1)
      tab_1.tabpage_details_log.dw_details_log.scrolltorow(1)
		tab_1.tabpage_details_log.dw_details_log.selectrow(1,true)

	end if
	cb_new.visible 	= False
	cb_update.visible = False
	cb_delete.visible = False
	cb_Cancel.visible = False
	cb_1.visible = False
else
	cb_new.visible 	= True
	cb_update.visible = True
	cb_delete.visible = True
	cb_Cancel.visible = True
	cb_1.visible = True
end if
end event

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 3529
integer height = 1980
cb_3 cb_3
cb_4 cb_4
end type

on tabpage_1.create
this.cb_3=create cb_3
this.cb_4=create cb_4
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_4
end on

on tabpage_1.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.cb_4)
end on

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
event ue_keydown pbm_dwnkey
string tag = "1"
integer x = 18
integer y = 0
integer width = 2048
integer height = 1664
string dataobject = "d_port_detail"
borderstyle borderstyle = stylebox!
end type

event dw_1::ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "abc_portid"
			this.setItem(this.getRow(), "abc_portid", ll_null)
	end choose
end if
	
end event

event dw_1::doubleclicked;call super::doubleclicked;inet linet_base

// Implemented for the hyperlink
if (row > 0) then 
	CHOOSE CASE dw_1.getColumnName()
		CASE "hyperlink"
			string ls_hyperlink
			THIS.GetContextService("Internet", linet_base)
			linet_base.HyperlinkToURL (this.getitemstring(row, "hyperlink"))
	END CHOOSE

end if
end event

type cb_3 from commandbutton within tabpage_1
integer x = 1499
integer y = 520
integer width = 466
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get UNCTAD code"
end type

event clicked;string ls_UNCTAD, ls_portname

Open(w_calc_find_unctad_response)
ls_UNCTAD = Message.StringParm
if ls_UNCTAD <> "" then 
	SELECT CAL_UNCT.CAL_UNCT_PORT_NAME  
		INTO :ls_portname  
		FROM CAL_UNCT  
		WHERE CAL_UNCT.CAL_UNCT_UNCTADCODE = :ls_UNCTAD;
	commit;
	tab_1.tabpage_1.dw_1.SetItem(1,"port_unctad",ls_UNCTAD)
	tab_1.tabpage_1.dw_1.SetItem(1,"unctad_portname",ls_portname)
end if
	
end event

type cb_4 from commandbutton within tabpage_1
integer x = 1499
integer y = 680
integer width = 466
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get AtoBviaC code"
end type

event clicked;decimal ld_portid
string ls_portname

Open(w_atobviac_find_portcode_response)
ld_portid = message.DoubleParm
if ld_portid <> 0 then 
	SELECT ABC_PORTNAME
		INTO :ls_portname
		FROM ATOBVIAC_PORT
		WHERE ABC_PORTID = :ld_portid;
	commit;	
	tab_1.tabpage_1.dw_1.SetItem(1,"abc_portid",ld_portid)
	tab_1.tabpage_1.dw_1.SetItem(1,"abc_portname",ls_portname)
end if

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3529
integer height = 1980
long backcolor = 67108864
string text = "Area"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_2 cb_2
dw_2 dw_2
end type

on tabpage_2.create
this.cb_2=create cb_2
this.dw_2=create dw_2
this.Control[]={this.cb_2,&
this.dw_2}
end on

on tabpage_2.destroy
destroy(this.cb_2)
destroy(this.dw_2)
end on

type cb_2 from commandbutton within tabpage_2
integer x = 1664
integer y = 28
integer width = 686
integer height = 100
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Other Ports in Area"
end type

event clicked;long ll_row

ll_row = dw_2.getrow()

if ll_row > 0 then
	openWithParm(w_area_ports, dw_2.getItemNumber(ll_row, "area_pk"))
else
	MessageBox("Information", "Please select an area")
end if
end event

type dw_2 from u_datagrid within tabpage_2
integer x = 18
integer y = 28
integer width = 1627
integer height = 1936
integer taborder = 30
string dataobject = "d_ports_area"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;long	ll_found

if row <=0 then return
choose case dwo.name
	
	case "primary_area"
		//Insure primary only one row
		if row > 0 then
			if this.getitemnumber(row, "primary_area") = 0 or isnull(this.getitemnumber(row, "primary_area")) then
				ll_found = this.find("primary_area = 1", 1, this.rowcount())
				if ll_found > 0 then
					this.setitem(ll_found, "primary_area", 0)
					this.setitem(row, "primary_area", 1)
					this.setrow(row)
					
				end if
			else
				ll_found = this.find("primary_area = 1", 1, this.rowcount())
				if ll_found = row then
					this.setitem(row, "primary_area", 1)
					return 2
				end if
			end if
		end if
end choose

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3529
integer height = 1980
long backcolor = 67108864
string text = "Berths"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
gb_2 gb_2
st_3 st_3
dw_4 dw_4
end type

on tabpage_4.create
this.gb_2=create gb_2
this.st_3=create st_3
this.dw_4=create dw_4
this.Control[]={this.gb_2,&
this.st_3,&
this.dw_4}
end on

on tabpage_4.destroy
destroy(this.gb_2)
destroy(this.st_3)
destroy(this.dw_4)
end on

type gb_2 from groupbox within tabpage_4
integer x = 18
integer width = 3506
integer height = 1952
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Berths"
end type

type st_3 from statictext within tabpage_4
integer x = 55
integer y = 72
integer width = 1070
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Double-click on the berth you want to edit:"
boolean focusrectangle = false
end type

type dw_4 from datawindow within tabpage_4
event ue_mousemove pbm_dwnmousemove
string tag = "1"
integer x = 55
integer y = 140
integer width = 3429
integer height = 1776
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_berth_comment_picklist"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;If dwo.name = "comments" Then
	if not isValid(w_comment) and not isNull(this.Object.cmmnt[row]) then
	   in_comment.setComment(this.Object.cmmnt[row])		
		in_comment.setX(pixelsToUnits(xpos, xPixelsToUnits!) + tab_1.x + parent.x + this.x)
		in_comment.setY(pixelsToUnits(ypos, yPixelsToUnits!) + tab_1.y + parent.y + this.y)
      openWithParm (w_popupHelp, in_comment, w_port)	
   end if
Else
   If isValid(w_popupHelp) Then
      close (w_popupHelp)
	End if
End if
return 0
end event

event clicked;IF row > 0 THEN
   this.selectRow(0,false)
   this.selectRow(row,true)
END IF
end event

event itemchanged;CHOOSE CASE dwo.name
	CASE "cal_cons_type"
		IF long(data) = 4 or long(data) = 5 THEN
			this.Object.cal_cons_speed[row] = 0
		END IF
END CHOOSE
end event

event doubleclicked;double ld_null

if row > 0 then
	if isValid(w_berth) then close(w_berth)
	OpenSheetWithParm(w_berth, this.getItemNumber(row, "berth_id"), w_tramos_main, 7, Original!) 
else
	if isValid(w_berth) then close(w_berth)
	setNull(ld_null)
	OpenSheetWithParm(w_berth, ld_null, w_tramos_main, 7, Original!) 
end if
end event

type tabpage_port_details from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3529
integer height = 1980
long backcolor = 67108864
string text = "Details"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_ports_details dw_ports_details
gb_1 gb_1
uo_port_att uo_port_att
end type

on tabpage_port_details.create
this.dw_ports_details=create dw_ports_details
this.gb_1=create gb_1
this.uo_port_att=create uo_port_att
this.Control[]={this.dw_ports_details,&
this.gb_1,&
this.uo_port_att}
end on

on tabpage_port_details.destroy
destroy(this.dw_ports_details)
destroy(this.gb_1)
destroy(this.uo_port_att)
end on

type dw_ports_details from mt_u_datawindow within tabpage_port_details
integer x = 18
integer y = 12
integer width = 3493
integer height = 1296
integer taborder = 110
string dataobject = "d_sq_ff_ports_details"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

type gb_1 from groupbox within tabpage_port_details
integer x = 18
integer y = 1324
integer width = 3493
integer height = 632
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Attachments"
borderstyle borderstyle = stylebox!
end type

type uo_port_att from u_fileattach within tabpage_port_details
integer x = 37
integer y = 1388
integer width = 3456
integer height = 552
integer taborder = 70
boolean bringtotop = true
string is_dataobjectname = "d_sq_tb_port_detail_files"
string is_counterlabel = "Files:"
boolean ib_allow_dragdrop = true
boolean ib_enable_cancel_button = false
boolean ib_autosave = true
boolean ib_multitableupdate = true
string is_modulename = "ports_action"
end type

on uo_port_att.destroy
call u_fileattach::destroy
end on

event ue_retrievefilelist;// Overrided
string ls_port_code
long li_row

li_row = dw_list.getrow()
if li_row > 0 then
	ls_port_code = dw_list.GetItemString(li_row, "port_code")
	return adw_file_listing.Retrieve(ls_port_code)
end if

return c#return.Failure
end event

event ue_preupdateattach;call super::ue_preupdateattach;string ls_port_code,ls_description
long li_row,ll_count
datetime ldt_today
int i
datastore ds_port_detail_history

li_row = dw_list.getrow()
if li_row > 0 then
	ls_port_code = dw_list.GetItemString(li_row, "port_code")
	  ll_count = uo_port_att.dw_file_listing.rowcount()
      if ll_count > 0 then
	      for i = 1 to ll_count
			  
			    if uo_port_att.dw_file_listing.GetItemStatus(i,0,PRIMARY!) = NewModified! then
//			     
				    uo_port_att.dw_file_listing.setitem(i,'port_code',ls_port_code)
//					 
				
			   end if
	      next
		end if
end if
//insert delete attachment log
ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))

//add port detail history
ds_port_detail_history = create datastore
ds_port_detail_history.dataobject = 'd_sq_gr_ports_detail_history'
ds_port_detail_history.settransobject(sqlca)
ds_port_detail_history.reset()
if  tab_1.tabpage_port_details.uo_port_att.dw_file_listing.deletedcount( ) > 0 then
	 for i = 1 to tab_1.tabpage_port_details.uo_port_att.dw_file_listing.deletedcount( )
		ls_description = tab_1.tabpage_port_details.uo_port_att.dw_file_listing.getitemstring(i,'description',Delete!,True)
		wf_insert_portdetailhistory(ds_port_detail_history,ls_description,ls_description,ls_port_code,ldt_today,'delete')
	 next
end if
if ds_port_detail_history.update() = 1 then
	
else
	rollback;
	return -1
end if

return 1
end event

event constructor;if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	
   ib_allow_dragdrop = true
else
	ib_allow_dragdrop = false
end if
super::event constructor( )
end event

event ue_postupdateattach;// override

if  ai_returncode = c#return.SUCCESS then
	COMMIT;
else
	rollback;
end if

call super::ue_postupdateattach

end event

type tabpage_details_log from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3529
integer height = 1980
long backcolor = 67108864
string text = "Details Log"
long picturemaskcolor = 536870912
dw_details_log_desc dw_details_log_desc
dw_details_log dw_details_log
end type

on tabpage_details_log.create
this.dw_details_log_desc=create dw_details_log_desc
this.dw_details_log=create dw_details_log
this.Control[]={this.dw_details_log_desc,&
this.dw_details_log}
end on

on tabpage_details_log.destroy
destroy(this.dw_details_log_desc)
destroy(this.dw_details_log)
end on

type dw_details_log_desc from mt_u_datawindow within tabpage_details_log
integer x = 18
integer y = 748
integer width = 3493
integer height = 1216
integer taborder = 60
string dataobject = "d_sq_ff_ports_detail_history_desc"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_details_log from mt_u_datawindow within tabpage_details_log
integer x = 18
integer y = 16
integer width = 3493
integer height = 720
integer taborder = 30
string dataobject = "d_sq_gr_ports_detail_history_query"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event rowfocuschanged;call super::rowfocuschanged;DEC ldc_no
dw_details_log_desc.reset()
if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	ldc_no = this.getitemdecimal(currentrow,'c_no')
	
	dw_details_log_desc.retrieve(ldc_no)
end if
end event

type cb_withoutarea from commandbutton within w_port_bak
boolean visible = false
integer x = 1006
integer y = 2352
integer width = 686
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ports &without Area..."
end type

event clicked;open(w_ports_without_area)
end event

type cb_1 from commandbutton within w_port_bak
integer x = 1006
integer y = 2352
integer width = 686
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Actual &Port Expenses"
end type

event clicked;s_calc_port_expenses lstr_parm

lstr_parm.portcode = tab_1.tabpage_1.dw_1.getItemString(1, "port_code")

/* If no vessel selected Shipype = 1 */
IF UpperBound(lstr_parm.shiptype) = 0 THEN
	lstr_parm.shiptype[1] = 1
END IF

lstr_parm.years = 2
openwithparm(w_calc_port_expenses, lstr_parm)


end event

type st_2 from u_topbar_background within w_port_bak
integer width = 6985
end type

