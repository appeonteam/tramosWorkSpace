$PBExportHeader$w_profitcenterlist.srw
forward
global type w_profitcenterlist from w_coredata_ancestor
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tab_2 from tab within tabpage_2
end type
type tabpage_5 from userobject within tab_2
end type
type dw_voyage from mt_u_datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_2
dw_voyage dw_voyage
end type
type tabpage_6 from userobject within tab_2
end type
type dw_tcout from mt_u_datawindow within tabpage_6
end type
type tabpage_6 from userobject within tab_2
dw_tcout dw_tcout
end type
type tabpage_7 from userobject within tab_2
end type
type dw_agent from mt_u_datawindow within tabpage_7
end type
type tabpage_7 from userobject within tab_2
dw_agent dw_agent
end type
type tab_2 from tab within tabpage_2
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
tab_2 tab_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_attachtypes from mt_u_datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_attachtypes dw_attachtypes
end type
type tabpage_4 from userobject within tab_1
end type
type uo_taskconfig from u_poc_taskconfig within tabpage_4
end type
type tabpage_4 from userobject within tab_1
uo_taskconfig uo_taskconfig
end type
type tabpage_route from userobject within tab_1
end type
type gb_1 from mt_u_groupbox within tabpage_route
end type
type gb_2 from mt_u_groupbox within tabpage_route
end type
type dw_primary from mt_u_datawindow within tabpage_route
end type
type dw_route from mt_u_datawindow within tabpage_route
end type
type tabpage_route from userobject within tab_1
gb_1 gb_1
gb_2 gb_2
dw_primary dw_primary
dw_route dw_route
end type
type tabpage_bunker from userobject within tab_1
end type
type dw_bunker from mt_u_datawindow within tabpage_bunker
end type
type tabpage_bunker from userobject within tab_1
dw_bunker dw_bunker
end type
type st_background from u_topbar_background within w_profitcenterlist
end type
end forward

global type w_profitcenterlist from w_coredata_ancestor
integer width = 4608
integer height = 2568
string title = "Profit Centers"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
st_background st_background
end type
global w_profitcenterlist w_profitcenterlist

type variables
Long il_pc_nr
boolean ib_button_new_delete

n_voyageatt_types   inv_types
// tab page constants
constant integer ii_PCDETAIL = 1
constant integer ii_DEFAULTCOMMENT = 2
constant integer ii_VOYDOCTYPES = 3
constant integer ii_TASKCONFIG = 4
constant integer ii_ROUTINGDEFAULTS = 5
constant integer ii_BUNKERADDITIONAL = 6
end variables

forward prototypes
private function integer uf_updatespending ()
public function boolean wf_isempty (string as_column)
public function integer wf_copyconfigdatapcgroup (long al_oldpcgroup, long al_newpcgroup)
public subroutine uf_pcgroupid_changed (integer ai_row)
public subroutine documentation ()
private function boolean _pcinuse (long al_pcnr, ref string as_message)
private function integer wf_mt_handled_changed (long al_profitcenter, ref string as_vessellist)
private subroutine _set_permission ()
end prototypes

private function integer uf_updatespending ();integer li_ret
string  ls_tab_name, ls_msg
boolean lb_modified

If Not cb_update.enabled then return 0


choose case tab_1.selectedtab
		
	case ii_PCDETAIL
		
		tab_1.tabpage_1.dw_1.accepttext()
		
		If tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount() > 0 then 
			ls_tab_name = "Finance"
			lb_modified = true
		end if
		
	case ii_DEFAULTCOMMENT
		
		tab_1.tabpage_2.dw_2.acceptText()
		tab_1.tabpage_2.tab_2.tabpage_5.dw_voyage.accepttext()
		tab_1.tabpage_2.tab_2.tabpage_6.dw_tcout.accepttext()
		tab_1.tabpage_2.tab_2.tabpage_7.dw_agent.accepttext()
		
		If tab_1.tabpage_2.dw_2.modifiedCount() + tab_1.tabpage_2.dw_2.deletedCount()  > 0  or &
		tab_1.tabpage_2.tab_2.tabpage_5.dw_voyage.modifiedCount() + tab_1.tabpage_2.tab_2.tabpage_5.dw_voyage.deletedCount()  > 0  or &
		tab_1.tabpage_2.tab_2.tabpage_6.dw_tcout.modifiedCount() + tab_1.tabpage_2.tab_2.tabpage_6.dw_tcout.deletedCount()  > 0  or &
		tab_1.tabpage_2.tab_2.tabpage_7.dw_agent.modifiedCount() + tab_1.tabpage_2.tab_2.tabpage_7.dw_agent.deletedCount()  > 0  then 
			ls_tab_name = "Operations"
			lb_modified = true
		end if
			
	case ii_VOYDOCTYPES
		
		tab_1.tabpage_3.dw_attachtypes.accepttext()
		
		if tab_1.tabpage_3.dw_attachtypes.modifiedcount() + tab_1.tabpage_3.dw_attachtypes.deletedcount() > 0 then
			ls_tab_name = "Attachment Types"
			lb_modified = true
		end if
		
	case ii_TASKCONFIG
		
		tab_1.tabpage_4.uo_taskconfig.dw_tasklist.accepttext()
		tab_1.tabpage_4.uo_taskconfig.dw_included.accepttext()
		
		if tab_1.tabpage_4.uo_taskconfig.dw_tasklist.modifiedCount() + tab_1.tabpage_4.uo_taskconfig.dw_tasklist.deletedCount() > 0 or &
	   	tab_1.tabpage_4.uo_taskconfig.dw_included.modifiedCount() + tab_1.tabpage_4.uo_taskconfig.dw_included.deletedCount() > 0 then
			
			ls_tab_name = "Voyage Tasks"
			lb_modified = true
		end if
			
	case ii_ROUTINGDEFAULTS
		
		tab_1.tabpage_route.dw_route.accepttext()
		tab_1.tabpage_route.dw_primary.accepttext()
	
		if tab_1.tabpage_route.dw_route.modifiedcount() > 0 or tab_1.tabpage_route.dw_primary.modifiedcount() > 0 then
			ls_tab_name = "Routing Defaults"
			lb_modified = true
		end if	
	
	case ii_BUNKERADDITIONAL
		
		tab_1.tabpage_bunker.dw_bunker.accepttext()
		
		if tab_1.tabpage_bunker.dw_bunker.modifiedcount() > 0 then
			ls_tab_name = "Bunker Additionals"
			lb_modified = true
		end if
	
	case else
		lb_modified = false
end choose

if lb_modified then
	
	ls_msg = "You have modified Profit Centers - " + ls_tab_name + ".~r~n~nWould you like to save before continuing?"
	li_ret = messagebox("Data not saved", ls_msg, Exclamation!, YesNoCancel!, 1)
	
	if li_ret = 1 then
		li_ret = cb_update.event clicked()
		
		if li_ret = c#return.failure then
			li_ret = c#return.PreventAction
		else
			li_ret = c#return.ContinueAction
		end if
		
	elseif li_ret = 2 then
		cb_cancel.event clicked()	
		li_ret = c#return.ContinueAction
	elseif li_ret = 3 then
		li_ret = c#return.PreventAction
	end if
else
	li_ret = c#return.ContinueAction
end if

return li_ret
end function

public function boolean wf_isempty (string as_column);
Return IsNull(tab_1.tabpage_1.dw_1.GetItemString(1, as_Column)) or (Trim(tab_1.tabpage_1.dw_1.GetItemString(1, as_Column),True)="")
end function

public function integer wf_copyconfigdatapcgroup (long al_oldpcgroup, long al_newpcgroup);boolean  bl_clearpcgroup
long	ll_maxcompanyid
integer li_updatepcgroup


//1. PF_FIXTURE_BUNKERPLACE
COMMIT;
INSERT INTO PF_FIXTURE_BUNKERPLACE (NAME, PRICE, PCGROUP_ID)
(SELECT NAME, PRICE, :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_BUNKERPLACE WHERE PCGROUP_ID=:al_oldpcgroup);
COMMIT USING SQLCA;
IF SQLCA.SQLcode <> 0 THEN
 MessageBox("Warning", "Error Copying trade information " + SQLCA.sqlerrtext )
 return -1
END IF

//2. PF_FIXTURE_TRADE
COMMIT;
INSERT INTO PF_FIXTURE_TRADE (NAME, LOADAREAID, DISCHARGEAREAID, DISTANCE, DAYS, FLATRATE, BUNKERID, COMMISSION, EXPENSES, COMMENT, DAYSINPORT, DPORTCODE, LPORTCODE, PCGROUP_ID)
(SELECT NAME, LOADAREAID, DISCHARGEAREAID, DISTANCE, DAYS, FLATRATE, BUNKERID, COMMISSION, EXPENSES, COMMENT, DAYSINPORT, DPORTCODE, LPORTCODE, :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:al_oldpcgroup);
COMMIT USING SQLCA;
IF SQLCA.SQLcode <> 0 THEN
 MessageBox("Warning", "Error Copying trade information " +SQLCA.sqlerrtext )
 bl_clearpcgroup=TRUE
END IF

IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	UPDATE PF_FIXTURE_TRADE  SET PF_FIXTURE_TRADE.BUNKERID=FP2.BUNKERID
	FROM  PF_FIXTURE_BUNKERPLACE FP , PF_FIXTURE_BUNKERPLACE FP2
	WHERE PF_FIXTURE_TRADE.BUNKERID=FP.BUNKERID AND PF_FIXTURE_TRADE.PCGROUP_ID=:al_newpcgroup AND
	FP2.NAME=FP.NAME AND FP2.PCGROUP_ID=:al_newpcgroup;
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying trade information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//PF_FIXTURE_FLATRATE
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_FLATRATE (TRADEID, PCGROUP_ID, FLATRATE, FLATRATEYEAR)
   (SELECT TRADEID, PCGROUP_ID, 0 AS FLATRATE, year(getdate()) AS FLATRATEYEAR FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:al_newpcgroup);
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying trade information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF


//3. PF_FIXTURE_CLEANINGTYPE
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_CLEANINGTYPE (DESCRIPTION, PCGROUP_ID)
	(SELECT DESCRIPTION, :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_CLEANINGTYPE WHERE PCGROUP_ID=:al_oldpcgroup);
	COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying cargo cleaning type information " + SQLCA.sqlerrtext )
	 return -1
	END IF
END IF

//4. PF_FIXTURE_CARGO
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_CARGO (NAME,DESCRIPTION,CPP,CLEANINGTYPEID, PCGROUP_ID)
	(SELECT NAME,DESCRIPTION,CPP,CLEANINGTYPEID, :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_CARGO WHERE PCGROUP_ID=:al_oldpcgroup);
	COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying cargo information " + SQLCA.sqlerrtext )
	 return -1
	END IF
END IF

IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	UPDATE PF_FIXTURE_CARGO  SET PF_FIXTURE_CARGO.CLEANINGTYPEID=FP2.CLEANINGTYPEID
	FROM  PF_FIXTURE_CARGO , PF_FIXTURE_CLEANINGTYPE FP , PF_FIXTURE_CLEANINGTYPE FP2
	WHERE PF_FIXTURE_CARGO.CLEANINGTYPEID=FP.CLEANINGTYPEID AND PF_FIXTURE_CARGO.PCGROUP_ID=:al_newpcgroup AND
	FP2.DESCRIPTION=FP.DESCRIPTION AND FP2.PCGROUP_ID=:al_newpcgroup;  
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying cargo information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//5. PF_FIXTURE_STATUS_CONFIG
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_STATUS_CONFIG (STATUSID,FIXTURELIST, CARGOLIST,DAYSONLIST, PCGROUP_ID )
   (SELECT STATUSID,FIXTURELIST, CARGOLIST,DAYSONLIST, :al_newpcgroup as PCGROUP_ID 
	FROM PF_FIXTURE_STATUS_CONFIG WHERE PCGROUP_ID=:al_oldpcgroup);
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying fixture status information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//6. PF_COMPANY

IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	SELECT MAX(COMPANYID) 
	INTO :ll_maxcompanyid
	FROM PF_COMPANY;
	COMMIT USING SQLCA;
	
	COMMIT;
	INSERT INTO PF_COMPANY (COMPANY,COMPANY2,SHORTNAME,ADDRESS1,ADDRESS2,ADDRESS3,CITY,POSTCODE,COUNTRYID,EMAIL,EMAIL2,TELEPHONE,TELEPHONE2,
FAX, FAX2,TELEX,TYPEID,CHASHORTPHONE,OPSSHORTPHONE,CHATM,OPSTM,SWITCHBOARD,CATEGORYID,MAILLIST,DEACTIVATED,CRLOIRATINGID,CRBANK,
CRFREIGHT,CRCOMMENT,CRLASTAUTHDATE,CRLASTMODDATE,CREXPIREDATE,DISABLEOFFICE,LASTUPDATED, PCGROUP_ID )
   (SELECT COMPANY,COMPANY2,SHORTNAME,ADDRESS1,ADDRESS2,ADDRESS3,CITY,POSTCODE,COUNTRYID,EMAIL,EMAIL2,TELEPHONE,TELEPHONE2,
FAX, FAX2,TELEX,TYPEID,CHASHORTPHONE,OPSSHORTPHONE,CHATM,OPSTM,SWITCHBOARD,CATEGORYID,MAILLIST,DEACTIVATED,CRLOIRATINGID,CRBANK,
CRFREIGHT,CRCOMMENT,CRLASTAUTHDATE,CRLASTMODDATE,CREXPIREDATE,DISABLEOFFICE,LASTUPDATED, :al_newpcgroup as PCGROUP_ID 
	FROM PF_COMPANY WHERE PCGROUP_ID=:al_oldpcgroup);
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying companies information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//li_updatepcgroup=MessageBox("Profit center group","Copy company contacts?",Question!, YesNo! )

//if li_updatepcgroup=1 then
	
	//7. PF_COMPANYCONTACTS
//	IF bl_clearpcgroup = FALSE THEN
//		COMMIT;
//		INSERT INTO PF_COMPANYCONTACTS (CONTACTSPROFILEID,FULLNAME,COMPANYID,WORKTELEPHONE,HOMETELEPHONE,MOBILE,EMAIL,STAFFTITLE,STAFFRESPONSIBILITY,MAILLIST,
//	DEACTIVATED,LASTUPDATED,COMMENT )
//		(SELECT CONTACTSPROFILEID,FULLNAME,PF_COMPANYCONTACTS.COMPANYID,WORKTELEPHONE,HOMETELEPHONE,MOBILE,PF_COMPANYCONTACTS.EMAIL,STAFFTITLE,STAFFRESPONSIBILITY,PF_COMPANYCONTACTS.MAILLIST,
//	PF_COMPANYCONTACTS.DEACTIVATED,PF_COMPANYCONTACTS.LASTUPDATED,COMMENT
//		FROM PF_COMPANYCONTACTS, PF_COMPANY WHERE PF_COMPANYCONTACTS.COMPANYID = PF_COMPANY.COMPANYID AND PF_COMPANY.PCGROUP_ID=:al_oldpcgroup);
//		 COMMIT USING SQLCA;
//		IF SQLCA.SQLcode <> 0 THEN
//		 MessageBox("Warning", "Error Copying companies information " +SQLCA.sqlerrtext )
//		 bl_clearpcgroup=TRUE
//		END IF
//	END IF
//	
//	IF bl_clearpcgroup = FALSE THEN
//		COMMIT;
//		
//		UPDATE PF_COMPANYCONTACTS  SET PF_COMPANYCONTACTS.COMPANYID=FP2.COMPANYID
//		FROM  PF_COMPANYCONTACTS , PF_COMPANY FP , PF_COMPANY FP2
//		WHERE PF_COMPANYCONTACTS.COMPANYID=FP.COMPANYID AND FP.PCGROUP_ID=:al_oldpcgroup and 
//		FP2.COMPANY=FP.COMPANY AND  FP2.COMPANYID>:ll_maxcompanyid ;  
//	
//		 COMMIT USING SQLCA;
//		IF SQLCA.SQLcode <> 0 THEN
//		 MessageBox("Warning", "Error Copying company contacts information " +SQLCA.sqlerrtext )
//		 bl_clearpcgroup=TRUE
//		END IF
//	END IF
//end if

if bl_clearpcgroup=true then

	COMMIT;
	DELETE FROM PF_FIXTURE_FLATRATE WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_BUNKERPLACE WHERE PCGROUP_ID=:al_newpcgroup;

	DELETE FROM PF_FIXTURE_CARGO WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_CLEANINGTYPE WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_STATUS_CONFIG WHERE PCGROUP_ID=:al_newpcgroup;
	
	//DELETE FROM PF_COMPANYCONTACTS WHERE COMPANYID IN  (SELECT COMPANYID FROM PF_COMPANY WHERE PCGROUP_ID=:al_newpcgroup);

	DELETE FROM PF_COMPANY WHERE PCGROUP_ID=:al_newpcgroup;

	COMMIT USING SQLCA;
   return -1
end if

return 0
end function

public subroutine uf_pcgroupid_changed (integer ai_row);/********************************************************************
   uf_pcgroupid_changed
   <DESC> Enables and disables options related with PCGroup. </DESC>
   <RETURN> (none)
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>	ai_row: data window row number
   </ARGS>
   <USAGE>	Use this function to refreh office list box and enable or disable
		some of the options related with the profit center group. </USAGE>
********************************************************************/

long ll_null; setNull(ll_null)	
datawindowchild	ldwc

tab_1.tabpage_1.dw_1.accepttext( )
tab_1.tabpage_1.dw_1.getchild("cert_notify_office", ldwc)

if isnull(tab_1.tabpage_1.dw_1.getitemnumber( ai_row,"pcgroup_id" )) then
	tab_1.tabpage_1.dw_1.post setItem(ai_row, "transfer_fleet",0 )
	tab_1.tabpage_1.dw_1.post setItem(ai_row, "transfer_certificates",0 )
	tab_1.tabpage_1.dw_1.post setItem(ai_row, "transfer_positions",0 )
	tab_1.tabpage_1.dw_1.settaborder( "transfer_fleet", 0)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_certificates", 0)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_positions", 0)
	
	ldwc.reset( )
else
	tab_1.tabpage_1.dw_1.settaborder( "transfer_fleet", 301)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_certificates", 302)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_positions", 303)
	
	//fulfill offices list box
	ldwc.SetTransObject(SQLCA)
	ldwc.retrieve(tab_1.tabpage_1.dw_1.getitemnumber( ai_row,"pcgroup_id" ))
	
end if
tab_1.tabpage_1.dw_1.setitem( ai_row, "cert_notify_office", ll_null)
		

end subroutine

public subroutine documentation ();/********************************************************************
 ObjectName: w_profitcenterlist - Profit Center List
	
<OBJECT>
	System table - Profit center configuration	
</OBJECT>
 <USAGE> 
	See wiki manual to get an explanation of each configuration.
	See "System Access.doc". This document explains the restrictions by user profile.
	Web configurations is enabled when the profit center is linked to a Profit Center Group.
	The Office drop down on "Notify Expired certificates", has a list of the offices defined by profit center group.
</USAGE>
<ALSO>
	tab_page1 & tab_page2 - now fits full process, so that when a user switches tab they are forced to save/cancel changes.
	tab_page3 (Document Type Configuration) - uses interface object n_voyageatt_types for database specific actions directly from within this window.
	tab_page4 (POC Task Configuration) - all functionality is contained within the visual user object u_poc_taskconfig.  
		The command buttons/tab page change/profit center change all call public functions within u_poc_taskconfig.
</ALSO>
<HISTORY> 
	Date    		CR-Ref		Author				Comments
	00/00/07		?     		Name Here     		First Version
	08/02/10		1816,1722	Joana Carvalho	
	25/11/10		2193  		AGL			  		Added Task Config tab and functionality. 	
	30/11/10		2193  		AGL					Added also the Document Type Configuration and changed styles
	10/12/10		2193  		AGL					Changed the user access rights for tabs 3 and 4
	15/12/10		2218  		RMO					Added check if proftcenter in use before delete ( _pcInUse() )
	16/12/10		2225  		AGL					in tab_1 selectionchanging check purposelist. if no rows found user
														added new profit center so we make a new retrieval.
	24/01/11		2264  		JMC					Add fields: CODA company code and Non-apm commercially handled flag
														New fields can be edited by admin or finance super users
	27/04/11		2323  		RMO					Added function wf_mt_handled_changed, to check if any vessel is in the 
														wrong posting list, when "Non-MT commercially handle" is turned on/off
	27/04/11		2375  		JMC					Added Vat_nr
	23/05/11		2407  		RJH022				Add MTBE, BIO, and Dye/Marked in cargo
	07/06/11		2407  		RJH022				Change the access rights for tabs in Profit Center: administrator can change all tabs; only finance superuser can change finance tab; other superusers can change tabs except finance tab
	04/07/11		2453  		RMO					Added validation related to "Non-MT commercially handled" profitcenter
														and "Vessels Crew and T.O. managed by Copenhagen"
	01/08/11		2497  		CONASW				Added validation to check for PC Number 999.												
	24/09/11		2528  		TTY004				Added MVV task  for POC MVV task config.
	30/04/13		2688  		AGL027				Fix deletion of notify office on expired certificates.
	02/08/13		2791  		WWA048				Add validation on Table BLUEBOARD, DOCUMENT_ACCESSIBLE_BY, NTC_TC_CONTRACT when deleting Profit Center
	18/02/16		CR3767		XSZ004				Add Routing Defaults tab and functionality.
	12/07/16		CR4216		XSZ004				Add bunker additionals tab and functionality.
	22/03/17		CR4439		HHX010				In Voyage Tasks tab, add two checkbox columns TC-Out and Finish in “Included Tasks”
															In Operations tab, divide Default Voyage Comment into two fields
</HISTORY>    
********************************************************************/
end subroutine

private function boolean _pcinuse (long al_pcnr, ref string as_message);/********************************************************************
   _pcinuse
   <DESC> This function makes the most obvious checks, to find out if a Profitcenter 
	is used in the system</DESC>
   <RETURN> Boolean
            <LI> True, Profitcenter in use
            <LI> False, NOT in use</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   al_pcnr: Profitcenter Number (primary key)
            as_message: Reference to message that has be be shown to user</ARGS>
   <USAGE>  </USAGE>
	<HISTORY> 
	Date			CR-Ref		Author				Comments
	02/08/13		CR2791		WWA048				Add validation on Table BLUEBOARD, DOCUMENT_ACCESSIBLE_BY, NTC_TC_CONTRACT
															when deleting Profit Center
</HISTORY>    
********************************************************************/

long 	ll_counter
  
/* Voyage Document Types */
SELECT count(*)  
	INTO :ll_counter  
	FROM VOYAGE_DOC_TYPES  
	WHERE PC_NR = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are Voyage Document Types attached to it. Please delete the Document Types, and try again"
	return true
end if

/* POC/Purpose task configuration */
SELECT count(*)  
	INTO :ll_counter  
	FROM POC_TASKS_CONFIG_PC  
	WHERE PC_NR = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are POC tasks configured. Please delete the tasks, and try again"
	return true
end if

/* Vessels */
SELECT count(*)  
	INTO :ll_counter  
	FROM VESSELS  
	WHERE PC_NR = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are Vessels connected to it. Please delete/move the Vessels, and try again"
	return true
end if

/* CAL_CLAR (Competitor vessels) */
SELECT count(*)  
	INTO :ll_counter  
	FROM CAL_CLAR  
	WHERE PC_NR = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are Competitor Vessels connected to it. Please delete/move the Vessels, and try again"
	return true
end if

/* CAL_CERP */
SELECT count(*)  
	INTO :ll_counter  
	FROM CAL_CERP  
	WHERE CAL_CERP_PROFIT_CENTER_NO = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are C/Ps connected to it. Please delete the C/Ps, and try again"
	return true
end if

/* BLUEBOARD */
SELECT count(*)  
	INTO :ll_counter  
	FROM BLUEBOARD  
	WHERE PC_NR = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are Blueboards connected to it. Please delete the Blueboards, and try again"
	return true
end if

/* DOCUMENT_ACCESSIBLE_BY */
SELECT count(*)  
	INTO :ll_counter  
	FROM DOCUMENT_ACCESSIBLE_BY  
	WHERE PC_NR = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are Documents connected to it. Please delete the Documents, and try again"
	return true
end if

/* TC Contract */
SELECT count(*)  
	INTO :ll_counter  
	FROM NTC_TC_CONTRACT  
	WHERE PC_NR = :al_pcnr   ;
commit;

if ll_counter > 0 then
	as_message = "You can't delete this Profitcenter, as there are TC Contracts connected to it. Please delete the TC Contracts, and try again"
	return true
end if

/* OK to delete */
return false
end function

private function integer wf_mt_handled_changed (long al_profitcenter, ref string as_vessellist);/********************************************************************
   wf_mt_handled_changed 
   <DESC> If the "Non-MT Commercially handled" checkmark is turned on or off, we need to 
	check that there are no vessels in the IOM/SIM or Broström/MT setup, that should not
	be there.
	If turned 
		ON 	No vessels from this profit center must be in the IOM/SIN setup
		OFF   No vessels from this profit center must be in the Broström/MT setup</DESC>
   <RETURN> 
		0 	OK
		-1	failure
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>	al_profitcenter:	profitcenter number
				as_vessellist:	message returned if vessels in wrong configuration
   </ARGS>
   <USAGE>	 </USAGE>
********************************************************************/
long	ll_rows, ll_row
mt_n_datastore	lds_data

lds_data = create mt_n_datastore

if tab_1.tabpage_1.dw_1.GetItemNumber(1, "non_apm_comm_handled") = 1 then
	lds_data.dataObject = "d_sq_tb_check_IOMSIN_vessels"
else
	lds_data.dataObject = "d_sq_tb_check_BrostromMT_vessels"
end if
lds_data.setTransObject(sqlca)
ll_rows = lds_data.retrieve(al_profitcenter)
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		//build list of vessels and return failure
		as_vessellist += lds_data.getItemString(ll_row, "vessel")+", "
	next
	return c#return.failure
else
	return c#return.success
end if

end function

private subroutine _set_permission ();/********************************************************************
   _set_permission
   <DESC>Access control for tabpages in this window.</DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		22/02/16		CR3767		XSZ004		First Version
		12/07/16		CR4216		XSZ004		Access bunker additionals tab.
   </HISTORY>
********************************************************************/

int li_index

li_index = tab_1.selectedtab

cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled    = true
cb_delete.enabled = true

choose case li_index
	
	case ii_PCDETAIL
		
		if (uo_global.ii_access_level <= c#usergroup.#user) or (uo_global.ii_user_profile <> 3 and uo_global.ii_access_level = c#usergroup.#SUPERUSER) then
			
			cb_update.enabled = false
			cb_cancel.enabled = false
			cb_new.enabled    = false
			cb_delete.enabled = false
			
			tab_1.tabpage_1.dw_1.modify("datawindow.readonly = 'yes'")
		else
			tab_1.tabpage_1.dw_1.modify("datawindow.readonly = 'no'")
		end if
		
	case ii_DEFAULTCOMMENT
		
		if (uo_global.ii_access_level <= c#usergroup.#USER) or ( uo_global.ii_access_level = c#usergroup.#SUPERUSER and uo_global.ii_user_profile = 3) then
			cb_update.enabled    = false
			cb_cancel.enabled    = false
			cb_new.enabled       = false
			cb_delete.enabled    = false
			
			tab_1.tabpage_2.dw_2.modify("datawindow.readonly = 'yes'")
			
		elseif uo_global.ii_access_level = c#usergroup.#SUPERUSER and (uo_global.ii_user_profile <> 3) then
			
			cb_new.enabled    = false
			cb_delete.enabled = false
	
			tab_1.tabpage_2.dw_2.modify("datawindow.readonly = 'no'")			
		else
			tab_1.tabpage_2.dw_2.modify("datawindow.readonly = 'no'")
		end if
		
	case ii_VOYDOCTYPES, ii_TASKCONFIG
		
		if (uo_global.ii_access_level <= c#usergroup.#USER) or ( uo_global.ii_access_level = c#usergroup.#SUPERUSER and uo_global.ii_user_profile = 3) then
			
			cb_update.enabled = false
			cb_cancel.enabled = false
			cb_new.enabled    = false
			cb_delete.enabled = false
			
			tab_1.tabpage_3.dw_attachtypes.modify("datawindow.readonly = 'yes'")
			tab_1.tabpage_4.uo_taskconfig.dw_included.modify("datawindow.readonly = 'yes'")
			tab_1.tabpage_4.uo_taskconfig.dw_tasklist.modify("datawindow.readonly = 'yes'")
			
			tab_1.tabpage_4.uo_taskconfig.pb_exclude.enabled = false
			tab_1.tabpage_4.uo_taskconfig.pb_include.enabled = false
			
			tab_1.tabpage_4.uo_taskconfig.of_setreadonly(true)
		else	
			tab_1.tabpage_3.dw_attachtypes.modify("datawindow.readonly = 'no'")
			tab_1.tabpage_4.uo_taskconfig.dw_included.modify("datawindow.readonly = 'no'")
			tab_1.tabpage_4.uo_taskconfig.dw_tasklist.modify("datawindow.readonly = 'no'")
			
			tab_1.tabpage_4.uo_taskconfig.pb_exclude.enabled = true
			tab_1.tabpage_4.uo_taskconfig.pb_include.enabled = true
			
			tab_1.tabpage_4.uo_taskconfig.of_setreadonly(false)
		end if
		
	case ii_ROUTINGDEFAULTS
		
		if uo_global.ii_access_level = c#usergroup.#SUPERUSER and (uo_global.ii_user_profile = 1 or uo_global.ii_user_profile = 2) then
			tab_1.tabpage_route.dw_route.modify("datawindow.readonly = 'no'")
			tab_1.tabpage_route.dw_primary.modify("datawindow.readonly = 'no'")
		else
			tab_1.tabpage_route.dw_route.modify("datawindow.readonly = 'yes'")
			tab_1.tabpage_route.dw_primary.modify("datawindow.readonly = 'yes'")
			cb_update.enabled = false
			cb_cancel.enabled = false
		end if
		
		cb_new.enabled    = false
		cb_delete.enabled = false
	
	case ii_BUNKERADDITIONAL
		
		if (uo_global.ii_access_level = c#usergroup.#SUPERUSER or uo_global.ii_access_level = c#usergroup.#ADMINiSTRATOR) and uo_global.ii_user_profile = 2 then
			tab_1.tabpage_bunker.dw_bunker.modify("datawindow.readonly = 'no'")
		else
			tab_1.tabpage_bunker.dw_bunker.modify("datawindow.readonly = 'yes'")
			cb_update.enabled = false
			cb_cancel.enabled = false
		end if
		
		cb_new.enabled    = false
		cb_delete.enabled = false
		
end choose
end subroutine

on w_profitcenterlist.create
int iCurrent
call super::create
this.st_background=create st_background
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_background
end on

on w_profitcenterlist.destroy
call super::destroy
destroy(this.st_background)
end on

event open;call super::open;// Init datawindows
n_service_manager 	lnv_servicemanager
n_dw_style_service	lnv_styleservice
boolean lb_readonlytasks = false

dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_2.dw_2.setTransObject(SQLCA)
tab_1.tabpage_3.dw_attachtypes.setTransObject(SQLCA)
tab_1.tabpage_route.dw_route.settransobject(sqlca)
tab_1.tabpage_route.dw_primary.settransobject(sqlca)
tab_1.tabpage_bunker.dw_bunker.settransobject(sqlca)

tab_1.tabpage_2.tab_2.tabpage_5.dw_voyage.setTransObject(SQLCA)
tab_1.tabpage_2.tab_2.tabpage_6.dw_tcout.setTransObject(SQLCA)
tab_1.tabpage_2.tab_2.tabpage_7.dw_agent.setTransObject(SQLCA)


tab_1.tabpage_bunker.dw_bunker.setrowfocusindicator(focusrect!)
tab_1.tabpage_route.dw_route.setrowfocusindicator(focusrect!)
tab_1.tabpage_route.dw_primary.setrowfocusindicator(focusrect!)

dw_list.Retrieve(uo_global.is_userid)

 inv_types = create n_voyageatt_types
 if inv_types.of_share( "typeslist", tab_1.tabpage_3.dw_attachtypes) = c#return.failure then
	_addMessage( this.classdefinition, "open()", "Error getting the data for Types List", "")	
	return
end if

lnv_servicemanager.of_loadservice( lnv_styleservice , "n_dw_style_service")
lnv_styleservice.of_dwlistformater(dw_list)
lnv_styleservice.of_dwlistformater(tab_1.tabpage_3.dw_attachtypes)
lnv_styleservice.of_registercolumn("pc_nr", true)
lnv_styleservice.of_registercolumn("pc_name", true)
lnv_styleservice.of_registercolumn("pc_dept_code", true)
lnv_styleservice.of_registercolumn("pc_bank_acc", true)
lnv_styleservice.of_registercolumn("vat_nr", true)
lnv_styleservice.of_registercolumn("coda_company_code", true)
lnv_styleservice.of_registercolumn("coda_el3_pool", true)
lnv_styleservice.of_registercolumn("coda_el4_pool", true)
lnv_styleservice.of_registercolumn("notify_on_temp_diff", true)
lnv_styleservice.of_dwformformater(tab_1.tabpage_1.dw_1)
lnv_styleservice.of_dwformformater(tab_1.tabpage_2.dw_2)

// Sort and select
dw_list.SetSort("pc_nr")
dw_list.Sort( )
dw_list.event Clicked(0, 0, 1, dw_list.object)

// Initialize search box
uo_SearchBox.of_initialize(dw_List, "string(pc_nr)+'#'+pc_name")
uo_SearchBox.sle_search.POST setfocus()

/* Share general and finance tabpages */
if tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_2.dw_2) = -1 then
	Messagebox("Error", "Datawindow share between tabpage 1 & 2 failed. Contact Administrator")
	return
end if

tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_2.tab_2.tabpage_5.dw_voyage)
tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_2.tab_2.tabpage_6.dw_tcout)
tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_2.tab_2.tabpage_7.dw_agent)
end event

event closequery;call super::closequery;integer li_ret 

li_ret = uf_updatespending()

return li_ret
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_profitcenterlist
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_profitcenterlist
integer y = 32
integer width = 1170
long backcolor = 22628899
boolean ib_standard_ui_topbar = true
boolean ib_scrolltocurrentrow = true
end type

type st_1 from w_coredata_ancestor`st_1 within w_profitcenterlist
boolean visible = false
integer x = 987
integer y = 208
long backcolor = 32304364
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_profitcenterlist
boolean visible = false
integer x = 731
integer y = 208
integer width = 219
end type

type dw_list from w_coredata_ancestor`dw_list within w_profitcenterlist
integer y = 240
integer width = 1170
integer height = 2120
integer taborder = 30
string dataobject = "d_sq_tb_profit_center_list"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_list::clicked;call super::clicked;long    ll_pcgroupid, ll_null, ll_pcnr
boolean lb_button_new_delete
integer li_ret

datawindowchild ldwc

setNull(ll_null)	

If row < 1 then return

ll_pcnr  = il_PC_NR
il_PC_NR = This.GetItemNumber(row, "pc_nr") 

li_ret =  uf_updatespending()

if li_ret = c#return.PreventAction then
	il_PC_NR = ll_pcnr
	return
end if


setPointer(hourGlass!)

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

tab_1.tabpage_1.dw_1.Retrieve(il_PC_NR)
tab_1.tabpage_2.dw_2.getchild("cert_notify_office", ldwc)

inv_types.of_retrieve(il_pc_nr)
tab_1.tabpage_4.uo_taskconfig.of_refresh(il_pc_nr)
tab_1.tabpage_route.dw_route.retrieve(il_pc_nr)
tab_1.tabpage_route.dw_primary.retrieve(il_pc_nr)
tab_1.tabpage_bunker.dw_bunker.retrieve(il_pc_nr)

ldwc.SetTransObject(SQLCA)

if isnull(tab_1.tabpage_1.dw_1.getitemnumber( 1,"pcgroup_id" )) then
	tab_1.tabpage_1.dw_1.settaborder( "transfer_fleet", 0)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_certificates", 0)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_positions", 0)
	ldwc.reset( )
else
	ldwc.retrieve( tab_1.tabpage_1.dw_1.getitemnumber( 1,"pcgroup_id" ))
 	tab_1.tabpage_1.dw_1.settaborder( "transfer_fleet", 301)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_certificates", 302)
	tab_1.tabpage_1.dw_1.settaborder( "transfer_positions", 303)
end if

this.setrow(row)

SetPointer(Arrow!)
end event

event dw_list::dberror;call super::dberror;/* TODO - add a check before deleterow in all dependent tables of PROFIT_C.  */
return 1
end event

type cb_close from w_coredata_ancestor`cb_close within w_profitcenterlist
boolean visible = false
integer x = 2194
integer taborder = 90
end type

event cb_close::clicked;call super::clicked;
Close(Parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_profitcenterlist
integer x = 4219
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 80
end type

event cb_cancel::clicked;call super::clicked;/* main profit center window */
if tab_1.selectedtab = ii_PCDETAIL or tab_1.selectedtab = ii_DEFAULTCOMMENT then
	// Triggers the Clickedevent of dw_list
	tab_1.tabpage_1.dw_1.reset()
	
	if dw_list.enabled = false then
		tab_1.tabpage_2.enabled = true
		tab_1.tabpage_3.enabled = true
		tab_1.tabpage_4.enabled = true
		tab_1.tabpage_route.enabled = true
		dw_list.enabled = true
		uo_searchbox.enabled = true
	end if
	
	dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)
	
	_set_permission()
	
	if dw_list.rowcount( ) = 0 then
		cb_delete.enabled = false
		cb_update.enabled = false
		cb_cancel.enabled = false
	end if

/* voyage document/attachment type configuration */
elseif tab_1.selectedtab = ii_VOYDOCTYPES then
	
	 inv_types.of_retrieve(il_pc_nr)
	
/* task list configuration*/
elseif tab_1.selectedtab = ii_TASKCONFIG then
	
	tab_1.tabpage_4.uo_taskconfig.of_updatetask("cancel")
	
elseif tab_1.selectedtab = ii_ROUTINGDEFAULTS then
	
	tab_1.tabpage_route.dw_route.retrieve(il_pc_nr)
	tab_1.tabpage_route.dw_primary.retrieve(il_pc_nr)
	
elseif tab_1.selectedtab = ii_BUNKERADDITIONAL then
	tab_1.tabpage_bunker.dw_bunker.retrieve(il_pc_nr)
end if	

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_profitcenterlist
integer x = 3872
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 70
end type

event cb_delete::clicked;call super::clicked;long 		ll_row
integer 	li_pcnr
string		ls_message
constant string METHOD_NAME = "cb_delete.clicked"

/* main profit center window */
if tab_1.selectedtab = ii_PCDETAIL then
	
	ll_row = dw_list.GetSelectedRow(0)
	
	If ll_Row <> 0 Then
		li_pcnr = dw_list.getitemnumber( ll_row, "pc_nr")
		
		if _pcInUse(li_pcnr, ls_message ) then
			_addmessage( this.classdefinition, METHOD_NAME, ls_message, "N/A")
			return c#return.failure
		end if
		
		If MessageBox("Delete","You are about to DELETE a profit center!~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 Then Return
	
		DELETE FROM USERS_PROFITCENTER WHERE PC_NR=:li_pcnr;
		if sqlca.sqlcode <> 0 then
			Rollback;
			MessageBox("Information","Error deleting users permissions!")
			return
		end if
		
		dw_list.DeleteRow(ll_row)
		
		If dw_list.Update() = 1 Then
			
			DELETE FROM PC_ROUTING_DEFAULTS WHERE PC_NR = :li_pcnr;
			
			if sqlca.sqlcode <> 0 then
				rollback;
				messagebox("Error", "Error deleting Routing Defaults.")
			else
				Commit;
			end if
		Else
			Rollback;
		End If
		
		If dw_list.Retrieve(uo_global.is_userid) > 0 then 
			
			If ll_Row > dw_List.RowCount() then ll_Row = dw_List.RowCount()
			
			dw_List.SelectRow(ll_Row, True)
			dw_List.event clicked(0,0, ll_row, dw_list.object)
			dw_List.ScrollToRow(ll_row)
			
		Else
			tab_1.tabpage_1.dw_1.Reset( )
			cb_Update.Enabled = False
		End If			
	end if

/* voyage document/attachment type configuration */
elseif tab_1.selectedtab = ii_VOYDOCTYPES then

	ll_row = tab_1.tabpage_3.dw_attachtypes.getselectedrow(0)
	
	if ll_row < 1 then 
		
		_addmessage( this.classdefinition, "clicked()", "Please select a type!", "N/A")
		
		return c#return.failure
	end if
	
	return inv_types.of_deleterow( "taskslist", ll_row)

/* task list configuration*/
elseif tab_1.selectedtab = ii_TASKCONFIG then
	tab_1.tabpage_4.uo_taskconfig.of_updatetask("delete")
end if	

	


end event

type cb_new from w_coredata_ancestor`cb_new within w_profitcenterlist
integer x = 3177
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 50
end type

event cb_new::clicked;call super::clicked;datawindowchild	ldwc
long ll_rows, ll_row
int  li_ret

/* main profit center window */
if tab_1.selectedtab = ii_PCDETAIL then
	
	li_ret = uf_updatesPending()
	
	If li_ret = c#return.PreventAction then 
		return
	end if
	
	tab_1.tabpage_1.dw_1.getchild("cert_notify_office", ldwc)
	ldwc.reset( )
	
	tab_1.tabpage_1.dw_1.Reset()
	tab_1.tabpage_1.dw_1.InsertRow(0)
	tab_1.tabpage_1.dw_1.setFocus()
	
	cb_new.enabled          = false
	cb_delete.enabled       = false
	cb_update.enabled       = true
	cb_cancel.enabled       = true
	dw_list.enabled         = false
	uo_searchbox.enabled    = false
	tab_1.tabpage_2.enabled = false
	tab_1.tabpage_3.enabled = false
	tab_1.tabpage_4.enabled = false	
	
	tab_1.tabpage_route.enabled = false
	
	tab_1.tabpage_1.dw_1.setitem( 1, "post_transaction", 0)
	tab_1.tabpage_1.dw_1.setitemstatus(1, "post_transaction", Primary!, NotModified!)
	
	tab_1.tabpage_route.dw_route.reset()
	tab_1.tabpage_route.dw_primary.reset()
	
	il_PC_NR = 0

elseif tab_1.selectedtab = ii_VOYDOCTYPES and ((uo_global.ii_user_profile <> 3 and uo_global.ii_access_level = 2) or uo_global.ii_access_level = 3) then

	tab_1.tabpage_3.dw_attachtypes.accepttext()
	
	ll_row = inv_types.of_insertrow("typeslist")
	
	if ll_row = c#return.failure then return
	
	tab_1.tabpage_3.dw_attachtypes.scrolltorow( ll_row)		
	tab_1.tabpage_3.dw_attachtypes.setColumn("doc_type_desc")
	tab_1.tabpage_3.dw_attachtypes.setfocus()

elseif tab_1.selectedtab = ii_TASKCONFIG and((uo_global.ii_user_profile <> 3 and uo_global.ii_access_level = 2) or uo_global.ii_access_level = 3) then
	tab_1.tabpage_4.uo_taskconfig.dw_tasklist.accepttext()
	tab_1.tabpage_4.uo_taskconfig.of_newtask()
end if

end event

type cb_update from w_coredata_ancestor`cb_update within w_profitcenterlist
integer x = 3525
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 60
end type

event cb_update::clicked;Long    ll_Found, ll_pc_nr, ll_old_pcnr, ll_OldPCGroup, ll_PCGroup, ll_CountItems, ll_CPHmanaged, ll_row
Integer li_updatepcgroup, li_numberPC, li_cnt, li_insertrow
decimal {2} ld_null; setNull(ld_null)
string  ls_vesselList, ls_error
boolean lb_bunkeradd_update

n_service_manager       lnv_svcmgr
n_dw_validation_service lnv_actionrules

mt_n_datastore lds_advancedroute, lds_primaryroute
mt_u_datawindow ldw_route, ldw_primaryroute

ldw_route = tab_1.tabpage_route.dw_route
ldw_primaryroute = tab_1.tabpage_route.dw_primary

/* main profit center window */
if tab_1.selectedtab = ii_PCDETAIL or tab_1.selectedtab = ii_DEFAULTCOMMENT then
	
	tab_1.tabpage_1.dw_1.AcceptText()
	tab_1.tabpage_2.dw_2.AcceptText()
	
	ll_pc_nr    = tab_1.tabpage_1.dw_1.GetItemNumber(1, "pc_nr")
	ll_old_pcnr = tab_1.tabpage_1.dw_1.getitemnumber(1, "pc_nr", primary!, true)
	
	if (uo_global.ii_user_profile = 3 and uo_global.ii_access_level = 2) or uo_global.ii_access_level = 3 then 
	
		if tab_1.tabpage_1.dw_1.GetItemStatus(1,"post_transaction",Primary!)<>NotModified! then
			if tab_1.tabpage_1.dw_1.getitemnumber( 1, "post_transaction") = 0 then
				
				if MessageBox("Warning","Posting to CODA and CMS is disabled. Do you want to change it? ", question!, YesNo!, 2) =1 then 
					tab_1.tabpage_1.dw_1.setitem( 1, "post_transaction",1)
				end if
			end if
		end if
		
		if ll_pc_nr = 0 or wf_IsEmpty("pc_name") or wf_IsEmpty("pc_bank_acc") or wf_IsEmpty("pc_dept_code") or wf_IsEmpty("vat_nr") then	
			MessageBox("Notice","Please fill in the mandatory blue fields!")
			return -1
		end if
		
		if ll_pc_nr = 999 then
			Messagebox("Notice","Profit Center Number cannot be 999. It is reserved.")
			return -1
		End If

		if tab_1.tabpage_1.dw_1.GetItemNumber(1,"post_transaction") = 1 then
			
			if wf_IsEmpty("coda_company_code")  or wf_IsEmpty("coda_el4_pool") or wf_IsEmpty("coda_el3_pool") then
				
				MessageBox("Notice","Please fill in the mandatory blue fields: company code, CODA El3 and El4!")
				Return -1
			end if
			
			if tab_1.tabpage_1.dw_1.GetItemStatus(1, "non_apm_comm_handled", Primary!) = dataModified! then
				
				//check if any vessel in IOM/SIN or Brostrom/MT setup, that should not be there
				if wf_mt_handled_changed( ll_pc_nr, ls_vesselList ) = c#return.failure then
					
					if tab_1.tabpage_1.dw_1.GetItemNumber(1, "non_apm_comm_handled") = 1 then
						ls_vesselList = "Following vessels are configured in the IOM/SIN list,~r~nand needs to be deleted before changing 'Non-MT Commercially handled'~r~n~r~n"+ls_vesselList 
					else
						ls_vesselList = "Following vessels are configured in the Broström/MT list,~r~nand needs to be deleted before changing 'Non-MT Commercially handled'~r~n~r~n"+ls_vesselList 
					end if
					
					messageBox("Notice", ls_vesselList)
					
					return c#return.failure
				end if
				
			end if
			
			if tab_1.tabpage_1.dw_1.GetItemNumber(1, "non_apm_comm_handled") = 1 then
				// If profitcenter is marked as "Non-MT Commercially handled"
				// check if any vessels in the profitcenter have the option 
				// "Crew and/or T.O. managed by CPH" set
				// in this case it is not allowed to turn it on
				
				SELECT SUM(cast(VESSEL_CPH_CREW_MANAGED as integer) + cast(VESSEL_CPH_TO_MANAGED as integer))
				INTO :ll_CPHmanaged
				FROM VESSELS
				WHERE PC_NR = :ll_pc_nr;
			
				if ll_CPHmanaged > 0 then
					MessageBox("Error","You are not allowed to turn on 'Non-MT Commercially handled'~r~nwhen there are Vessels belonging to this Profitcenter~r~nmarked as 'Crew and/or T.O. managed by Copenhagen' ")
					Return -1
				end if
	
			end if
		end if
		
	end if 
 
	if( uo_global.ii_user_profile = 2 and uo_global.ii_access_level = 2 ) or uo_global.ii_access_level = 3 then	
		
		if tab_1.tabpage_2.dw_2.getItemNumber(1, "validate_cargo_temp") = 1 then
			
			if isnull(tab_1.tabpage_2.dw_2.getItemNumber(1, "notify_on_temp_diff")) then	
				MessageBox("Notice","Please fill in the mandatory blue fields!")
				Return -1
			elseif tab_1.tabpage_2.dw_2.getItemNumber(1, "notify_on_temp_diff") <= 0 then
				MessageBox("Notice","Temperature difference can't be zero or less than zero!")
				Return -1
			end if
		else
			tab_1.tabpage_2.dw_2.setItem(1, "notify_on_temp_diff", ld_null )
		end if
	end if
	 
	//Profit Center Group 
	SELECT PCGROUP_ID INTO :ll_oldpcgroup FROM PROFIT_C WHERE PC_NR = :ll_pc_nr;
		 
	ll_pcgroup = tab_1.tabpage_1.dw_1.GetItemNumber(1, "pcgroup_id")
	
	if isnull(ll_oldpcgroup) then
		ll_oldpcgroup=-1
	end if
	
	If isnull(ll_pcgroup) = False and ll_oldpcgroup<> ll_pcgroup and ll_oldpcgroup>0 then  //pcgroup changed
		//check if the selected pcgroup is empty	
		SELECT count(*) INTO :ll_countitems FROM PF_COMPANY WHERE PCGROUP_ID=:ll_pcgroup;		
		If ll_countitems=0 then				
			SELECT count(*) INTO :ll_countitems FROM PF_FIXTURE_CARGO WHERE PCGROUP_ID=:ll_pcgroup;
			If ll_countitems=0 then			
				SELECT count(*) INTO :ll_countitems FROM PF_FIXTURE_STATUS_CONFIG WHERE PCGROUP_ID=:ll_pcgroup;
				If ll_countitems=0 then
					
					SELECT count(*) INTO :ll_countitems	FROM PF_FIXTURE_CLEANINGTYPE WHERE PCGROUP_ID=:ll_pcgroup;
					If ll_countitems=0 then
						SELECT count(*) INTO :ll_countitems	FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:ll_pcgroup;
						If ll_countitems=0 then
							li_updatepcgroup=MessageBox("Profit center group","The selected Profit Center Group is empty, do you want to copy the configuration data?",Question!, YesNoCancel! )
							If li_updatepcgroup = 1 then
								If wf_copyConfigDataPCGroup(ll_oldpcgroup, ll_pcgroup) = -1 then Return -1
							Elseif li_updatepcgroup = 3 then
								Return -1
							End if
						End if
					End if
				End if			
			End if
		End If
	End if
		
	If tab_1.tabpage_1.dw_1.Update() = 1  then
		
		if il_pc_nr = 0 then
			
			lds_advancedroute = create mt_n_datastore
			lds_advancedroute.dataobject = "d_sq_hide_advanced_routing_point"
			lds_advancedroute.settransobject(sqlca)
			lds_advancedroute.retrieve()
		
			for li_cnt = 1 to lds_advancedroute.rowcount()
				li_insertrow = ldw_route.insertrow(0)
				
				ldw_route.setitem(li_insertrow, "pc_routing_defaults_pc_nr", ll_pc_nr)
				ldw_route.setitem(li_insertrow, "pc_routing_defaults_abc_portcode", lds_advancedroute.getitemstring(li_cnt, "routingpointcode"))
				ldw_route.setitem(li_insertrow, "pc_routing_defaults_rp_defaultvalue", lds_advancedroute.getitemnumber(li_cnt, "atobviac_port_abc_advanced_rp_default_on"))
				ldw_route.setitem(li_insertrow, "rp_primary", 0)
			next
			
			lds_primaryroute = create mt_n_datastore
			lds_primaryroute.dataobject = "d_ex_tb_primary_routing_point"
			
			for li_cnt = 1 to lds_primaryroute.rowcount()
				li_insertrow = ldw_primaryroute.insertrow(0)
				
				ldw_primaryroute.setitem(li_insertrow, "pc_nr", ll_pc_nr)
				ldw_primaryroute.setitem(li_insertrow, "abc_portcode", lds_primaryroute.getitemstring(li_cnt, "primaryrpname"))
				ldw_primaryroute.setitem(li_insertrow, "rp_defaultvalue", 1)
				ldw_primaryroute.setitem(li_insertrow, "rp_primary", 1)
				ldw_primaryroute.setitem(li_insertrow, "rp_shortname", lds_primaryroute.getitemstring(li_cnt, "primaryrpshortname"))
				ldw_primaryroute.setitem(li_insertrow, "rp_order", li_cnt)			
			next
			
			insert into PC_BUNKERADDITIONALS(CAL_DESCRIPTION, PC_NR)
  			select CAL_DESCRIPTION, :ll_pc_nr from CAL_BUNKERADDITIONALS;
			
			destroy lds_primaryroute
			destroy lds_advancedroute
			
		elseif ll_pc_nr <> ll_old_pcnr then
				
			for li_cnt = 1 to ldw_route.rowcount()
				ldw_route.setitem(li_cnt, "pc_routing_defaults_pc_nr", ll_pc_nr)
			next
			
			for li_cnt = 1 to ldw_primaryroute.rowcount()
				ldw_primaryroute.setitem(li_cnt, "pc_nr", ll_pc_nr)	
			next	
			
			update PC_BUNKERADDITIONALS set PC_NR = :ll_pc_nr where PC_NR = :ll_old_pcnr;
			
		end if
		
		if sqlca.sqlcode = 0 then
			lb_bunkeradd_update = true
		else
			ls_error = sqlca.sqlerrtext
			lb_bunkeradd_update = false
		end if
		
		if ldw_primaryroute.update() = c#return.success and ldw_route.update() = c#return.success then
						
			if lb_bunkeradd_update then
				Commit;
			else
				rollback;
				messagebox("Error", "Update Bunker Additionals failed. " + ls_error, StopSign!)
				return -1
			end if		
		else
			ls_error = sqlca.sqlerrtext
			rollback;
			messagebox("Error", "Update Routing Defaults failed. " + ls_error, StopSign!)	
			return -1	
		end if
		
	Else
		Rollback;
		Return -1
	End If
	
	if il_PC_NR = 0 then
		
		COMMIT;
		
		INSERT INTO USERS_PROFITCENTER (USERID, PC_NR) (
		SELECT USERID, :ll_pc_nr AS PC_NR FROM (SELECT  USERID, COUNT(*) AS CC FROM USERS_PROFITCENTER GROUP BY USERID) TAB1 
		 WHERE TAB1.CC = (SELECT COUNT(*)-1 FROM  PROFIT_C))
		COMMIT USING SQLCA;
		IF SQLCA.SQLcode <> 0 THEN
			MessageBox("Error", "Error adding access rights to the users with full access!" +SQLCA.sqlerrtext )
		END IF		
	end if
	
	if isnull(ll_pcgroup) = False and (isnull(ll_oldpcgroup) or ll_oldpcgroup<> ll_pcgroup ) then
	  if MessageBox("Warning!","Give access rights to the users that already belong to the group?",Question!, YesNoCancel!)=1 then
			//Give users access to the PC
			
			COMMIT;
			SELECT DISTINCT count(PC_NR) as CC
			into :li_numberPC
			FROM PROFIT_C WHERE PCGROUP_ID=:ll_pcgroup
			COMMIT USING SQLCA;
			li_numberPC = li_numberPC - 1
			
			COMMIT;
			INSERT INTO USERS_PROFITCENTER (USERID, PC_NR) (
			SELECT USERID, :ll_pc_nr AS PC_NR FROM (
			SELECT  USERID, COUNT(*) AS CC FROM USERS_PROFITCENTER 
			WHERE PC_NR IN (SELECT DISTINCT PC_NR FROM PROFIT_C WHERE PCGROUP_ID=:ll_pcgroup)
			and USERID not in (SELECT USERID from USERS_PROFITCENTER where PC_NR=:ll_pc_nr)
			GROUP BY USERID) TAB1 
			WHERE TAB1.CC = :li_numberPC )
			COMMIT USING SQLCA;
			IF SQLCA.SQLcode <> 0 THEN
				 MessageBox("Error", "Error adding access rights " +SQLCA.sqlerrtext )
			END IF		
		end if
	end if
	
	
	if dw_list.enabled = false then
		tab_1.tabpage_2.enabled = true
		tab_1.tabpage_3.enabled = true
		tab_1.tabpage_4.enabled = true
		dw_list.enabled         = true
		uo_searchbox.enabled    = true
		
		tab_1.tabpage_route.enabled = true	
	end if

	If uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3 then
		w_share.TriggerEvent("ue_retrieve")
	End if
	
	_set_permission()
	
	// Retrieve and select from main list
	dw_list.Retrieve(uo_global.is_userid)
	dw_list.Sort()

	// todo Tuesday test if this works ok???
	ll_found = dw_list.Find("pc_nr = " + String(	il_PC_NR) , 1, dw_list.rowCount() ) 
	
	If ll_found = 0 then  // In case unable to find due to filter, remove filter and find again
		uo_searchbox.cb_clear.event clicked( )
		ll_found = dw_list.Find("pc_nr = " + String(tab_1.tabpage_1.dw_1.GetItemNumber(1, "pc_nr" ) ), 1, dw_list.rowCount() ) 
	End If
		
	dw_list.event Clicked( 0, 0, ll_found, dw_list.object )
	dw_list.scrollToRow(ll_found)
		
	Return 1

elseif tab_1.selectedtab = ii_VOYDOCTYPES then
	
	tab_1.tabpage_3.dw_attachtypes.accepttext()
	inv_types.of_update( )

elseif tab_1.selectedtab = ii_TASKCONFIG then
	
	for ll_row = tab_1.tabpage_4.uo_taskconfig.dw_tasklist.rowcount() to 1 step -1 // if the rowstatus is new! then ignore the row
		
		if tab_1.tabpage_4.uo_taskconfig.dw_tasklist.getitemstatus(ll_row, 0, primary!) = new! then &
		tab_1.tabpage_4.uo_taskconfig.dw_tasklist.deleterow(ll_row)
		
		if trim(tab_1.tabpage_4.uo_taskconfig.dw_tasklist.getitemstring(ll_row,"description") + &
		   tab_1.tabpage_4.uo_taskconfig.dw_tasklist.getitemstring(ll_row,"task_mvv_name")) ='' then &
			tab_1.tabpage_4.uo_taskconfig.dw_tasklist.deleterow(ll_row)
	next
	
	lnv_svcmgr.of_loadservice(lnv_actionrules, "n_dw_validation_service")
	lnv_actionrules.of_registerrulestring("description", true, "Task List", true)
   lnv_actionrules.of_registerrulestring("task_mvv_name", false, "MVV", true)
	
	if lnv_actionrules.of_validate(tab_1.tabpage_4.uo_taskconfig.dw_tasklist, true) = c#return.Failure then return c#return.Failure
	
	tab_1.tabpage_4.uo_taskconfig.of_updatetask("save")
	
elseif tab_1.selectedtab = ii_ROUTINGDEFAULTS then
	
	ldw_route.accepttext()
	ldw_primaryroute.accepttext()
	
	if ldw_route.update() = 1 and ldw_primaryroute.update() = 1 then
		commit;
	else
		rollback;
	end if
elseif tab_1.selectedtab = ii_BUNKERADDITIONAL then
	
	tab_1.tabpage_bunker.dw_bunker.accepttext()
	
	if tab_1.tabpage_bunker.dw_bunker.update() = 1 then
		commit;
	else
		rollback;
	end if
	
end if	

end event

type st_list from w_coredata_ancestor`st_list within w_profitcenterlist
boolean visible = false
integer y = 224
long backcolor = 32304364
string text = "Profit Centers:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_profitcenterlist
integer x = 1243
integer y = 240
integer width = 3319
integer height = 2120
integer taborder = 40
integer weight = 400
long backcolor = 32304364
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_route tabpage_route
tabpage_bunker tabpage_bunker
end type

on tab_1.create
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_route=create tabpage_route
this.tabpage_bunker=create tabpage_bunker
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_2
this.Control[iCurrent+2]=this.tabpage_3
this.Control[iCurrent+3]=this.tabpage_4
this.Control[iCurrent+4]=this.tabpage_route
this.Control[iCurrent+5]=this.tabpage_bunker
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_route)
destroy(this.tabpage_bunker)
end on

event tab_1::selectionchanged;call super::selectionchanged;if newindex = ii_TASKCONFIG then
	tab_1.tabpage_4.uo_taskconfig.dw_purposelist.setfilter("pc=" + string(il_pc_nr))
	tab_1.tabpage_4.uo_taskconfig.dw_purposelist.filter()
	tab_1.tabpage_4.uo_taskconfig.dw_purposelist.sort()
end if

_set_permission()

end event

event tab_1::selectionchanging;call super::selectionchanging;int li_ret

if dw_list.rowcount() = 0 then // just in case user has filtered all records out...
	uo_searchbox.cb_clear.event clicked() 
end if	

if newindex = 4 then
	/* check the purpose list.  If we have a new profit center the current list wil need to be retreived again */
	if tab_1.tabpage_4.uo_taskconfig.dw_purposelist.rowcount() = 0 then
		tab_1.tabpage_4.uo_taskconfig.of_retreivepurposes( )
	end if
end if

li_ret = uf_updatespending()

if li_ret = c#return.PreventAction then
	return c#return.PreventAction
end if
	


end event

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 3282
integer height = 2004
long backcolor = 32304364
string text = "Finance"
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
event ue_keydown pbm_dwnkey
integer x = 0
integer y = 0
integer width = 3200
integer height = 1908
string dataobject = "dw_profit_center"
end type

event dw_1::ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "pcgroup_id" 
			this.setItem(this.getRow(), "pcgroup_id", ll_null)
		    uf_pcgroupid_changed(this.getRow())
		// no other cases	 
		end choose
end if
end event

event dw_1::itemchanged;call super::itemchanged;choose case dwo.name
	case "pcgroup_id"
		uf_pcgroupid_changed(row)
end choose


end event

event dw_1::dberror;call super::dberror;long ll_errCode

if sqldbcode=2601 then  // dependent foreign key error
	messagebox("Error","It is not possible to insert this record as the profit center number already exists.")
	tab_1.tabpage_1.dw_1.setcolumn( "pc_nr")
	tab_1.tabpage_1.dw_1.setFocus()
	return 1
end if


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3282
integer height = 2004
long backcolor = 32304364
string text = "Operations"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_2 dw_2
tab_2 tab_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.tab_2=create tab_2
this.Control[]={this.dw_2,&
this.tab_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
destroy(this.tab_2)
end on

type dw_2 from datawindow within tabpage_2
event ue_keydown pbm_dwnkey
integer width = 3040
integer height = 1000
integer taborder = 15
string title = "none"
string dataobject = "dw_profit_center_default_comment"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "cert_notify_office" 
			this.setItem(this.getRow(), "cert_notify_office", ll_null)
	// no other cases
	end choose
end if
end event

event editchanged;if row < 1 then return

if dwo.name = 'tce_pr_day_in_poc' then
	if dec(data) < 0 then 
		this.setitem( row, 'tce_pr_day_in_poc', abs(dec(data)))
	elseif dec(data) > 9999.99 then
		this.setitem( row, 'tce_pr_day_in_poc', 9999.99)
	end if
end if
end event

event itemfocuschanged;if row > 0 then
	if dwo.name = 'tce_pr_day_in_poc' then
		selecttext( 1,len(gettext()) + 1 )	
	end if
end if
end event

type tab_2 from tab within tabpage_2
integer x = 37
integer y = 1020
integer width = 2967
integer height = 968
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type

on tab_2.create
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7}
end on

on tab_2.destroy
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
end on

type tabpage_5 from userobject within tab_2
integer x = 18
integer y = 100
integer width = 2930
integer height = 852
long backcolor = 32304364
string text = "Default Voyage Comment"
long tabtextcolor = 33554432
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
dw_voyage dw_voyage
end type

on tabpage_5.create
this.dw_voyage=create dw_voyage
this.Control[]={this.dw_voyage}
end on

on tabpage_5.destroy
destroy(this.dw_voyage)
end on

type dw_voyage from mt_u_datawindow within tabpage_5
integer x = 18
integer y = 24
integer width = 2912
integer height = 824
integer taborder = 20
string dataobject = "d_sq_ff_pc_default_comment"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
end type

type tabpage_6 from userobject within tab_2
integer x = 18
integer y = 100
integer width = 2930
integer height = 852
long backcolor = 32304364
string text = "Default TC-Out Voyage Comment"
long tabtextcolor = 33554432
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
dw_tcout dw_tcout
end type

on tabpage_6.create
this.dw_tcout=create dw_tcout
this.Control[]={this.dw_tcout}
end on

on tabpage_6.destroy
destroy(this.dw_tcout)
end on

type dw_tcout from mt_u_datawindow within tabpage_6
integer x = 18
integer y = 24
integer width = 2912
integer height = 824
integer taborder = 30
string dataobject = "d_sq_ff_pc_default_comment_tcout"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
end type

type tabpage_7 from userobject within tab_2
integer x = 18
integer y = 100
integer width = 2930
integer height = 852
long backcolor = 32304364
string text = "Default Agent Details"
long tabtextcolor = 33554432
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
dw_agent dw_agent
end type

on tabpage_7.create
this.dw_agent=create dw_agent
this.Control[]={this.dw_agent}
end on

on tabpage_7.destroy
destroy(this.dw_agent)
end on

type dw_agent from mt_u_datawindow within tabpage_7
integer x = 18
integer y = 24
integer width = 2912
integer height = 824
integer taborder = 30
string dataobject = "d_sq_ff_pc_default_comment_agent"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
boolean ib_sortbygroup = false
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3282
integer height = 2004
long backcolor = 32304364
string text = "Attachment Types"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_attachtypes dw_attachtypes
end type

on tabpage_3.create
this.dw_attachtypes=create dw_attachtypes
this.Control[]={this.dw_attachtypes}
end on

on tabpage_3.destroy
destroy(this.dw_attachtypes)
end on

type dw_attachtypes from mt_u_datawindow within tabpage_3
integer x = 41
integer y = 28
integer width = 3200
integer height = 1936
integer taborder = 30
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

event clicked;call super::clicked;/********************************************************************
dw_attachtypes.event clicked( )
   <DESC>Sort and select row   	</DESC>
   <RETURN>  </RETURN>
   <ACCESS> </ACCESS>
   <ARGS> </ARGS>
   <USAGE>	</USAGE>
********************************************************************/

string	ls_sort

If row = 0 then
	If (String(dwo.type) = "text") then
		If (String(dwo.tag)>"") then
			ls_sort = dwo.Tag
			This.SetSort(ls_sort)
			This.Sort()
			If right(ls_sort,1) = "A" then 
				ls_sort = Replace(ls_sort, len(ls_sort),1, "D")
			Else
				ls_sort = Replace(ls_sort, len(ls_sort),1, "A")
			End if
			dwo.Tag = ls_sort		
		End If
	End if
	this.selectrow(0,false)
else

	this.selectrow(0,false)
	this.selectrow(row,true)

end if
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3282
integer height = 2004
long backcolor = 32304364
string text = "Voyage Tasks"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
uo_taskconfig uo_taskconfig
end type

on tabpage_4.create
this.uo_taskconfig=create uo_taskconfig
this.Control[]={this.uo_taskconfig}
end on

on tabpage_4.destroy
destroy(this.uo_taskconfig)
end on

type uo_taskconfig from u_poc_taskconfig within tabpage_4
integer y = 4
integer width = 3369
integer height = 1968
integer taborder = 30
end type

on uo_taskconfig.destroy
call u_poc_taskconfig::destroy
end on

type tabpage_route from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3282
integer height = 2004
long backcolor = 32304364
string text = "Routing Defaults"
long tabtextcolor = 33554432
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
gb_1 gb_1
gb_2 gb_2
dw_primary dw_primary
dw_route dw_route
end type

on tabpage_route.create
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_primary=create dw_primary
this.dw_route=create dw_route
this.Control[]={this.gb_1,&
this.gb_2,&
this.dw_primary,&
this.dw_route}
end on

on tabpage_route.destroy
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_primary)
destroy(this.dw_route)
end on

type gb_1 from mt_u_groupbox within tabpage_route
integer x = 1065
integer y = 16
integer width = 2181
integer height = 1980
integer taborder = 20
integer weight = 400
string facename = "Tahoma"
string text = "Advanced Routing Points"
end type

type gb_2 from mt_u_groupbox within tabpage_route
integer x = 41
integer y = 16
integer width = 997
integer height = 1980
integer taborder = 20
integer weight = 400
string facename = "Tahoma"
string text = "Primary Routing Points"
end type

type dw_primary from mt_u_datawindow within tabpage_route
integer x = 91
integer y = 92
integer width = 896
integer height = 1868
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sq_gr_primaryroute"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_route from mt_u_datawindow within tabpage_route
integer x = 1106
integer y = 92
integer width = 2098
integer height = 1868
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sq_gr_pcroute"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type tabpage_bunker from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3282
integer height = 2004
long backcolor = 32304364
string text = "Bunker Additionals"
long tabtextcolor = 33554432
long tabbackcolor = 32304364
long picturemaskcolor = 536870912
dw_bunker dw_bunker
end type

on tabpage_bunker.create
this.dw_bunker=create dw_bunker
this.Control[]={this.dw_bunker}
end on

on tabpage_bunker.destroy
destroy(this.dw_bunker)
end on

type dw_bunker from mt_u_datawindow within tabpage_bunker
integer x = 41
integer y = 28
integer width = 3200
integer height = 1936
integer taborder = 40
string dataobject = "d_sq_gr_pcbunkeradditionals"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;this.selecttext(1, 15)
end event

event ue_dwkeypress;call super::ue_dwkeypress;int    li_row, li_null
string ls_colname

li_row = this.getrow()

setnull(li_null)

if li_row > 0 and cb_update.enabled then
	if keydown(KeyControl!) and (keydown(Key0!) or keydown(KeyNumpad0!)) then
		
		ls_colname =  this.getcolumnname()
			
		if ls_colname = "hsfo_value" or ls_colname = "hsgo_value" or &
			ls_colname = "lsgo_value" or ls_colname = "lsfo_value" then
			
			this.setitem(li_row, ls_colname, li_null)
		end if	
	end if
end if
end event

type st_background from u_topbar_background within w_profitcenterlist
end type

