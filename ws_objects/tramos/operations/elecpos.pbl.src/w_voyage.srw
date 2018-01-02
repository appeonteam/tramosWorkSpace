$PBExportHeader$w_voyage.srw
$PBExportComments$This window lets the user create a voyage.
forward
global type w_voyage from mt_w_response
end type
type cb_refresh from commandbutton within w_voyage
end type
type cb_cancel from commandbutton within w_voyage
end type
type cbx_autocreate_proceedings from checkbox within w_voyage
end type
type dw_preview_voyage from u_datagrid within w_voyage
end type
type cb_update from commandbutton within w_voyage
end type
type dw_voyage from uo_datawindow within w_voyage
end type
type st_voyagelen from mt_u_statictext within w_voyage
end type
end forward

global type w_voyage from mt_w_response
integer x = 672
integer y = 264
integer width = 1659
integer height = 1680
string title = "Voyage"
boolean controlmenu = false
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve ( )
cb_refresh cb_refresh
cb_cancel cb_cancel
cbx_autocreate_proceedings cbx_autocreate_proceedings
dw_preview_voyage dw_preview_voyage
cb_update cb_update
dw_voyage dw_voyage
st_voyagelen st_voyagelen
end type
global w_voyage w_voyage

type variables
datawindowchild idwc_child
s_vessel_voyage istr_parm
integer ii_originalvoytype
string is_suggestedvoyage = ""
boolean ib_newvoyage = false

mt_n_dddw_searchasyoutype inv_dddw_search

constant string is_ALLOCATED = "Allocated"
constant string is_FIXTURE = "Fixture"
constant string is_NEW	= "New"

string is_new_port
string is_new_port_text
long   il_new_pcn
end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_highlight_voyage (string as_voyage)
public subroutine wf_initdddw ()
public subroutine wf_adjust_ui ()
public function long wf_get_matchedvoyage (integer al_vessel_nr, string as_voyage_nr, long al_calc_id, long al_calc_voyagetype)
public subroutine wf_get_ballast_port (long al_calc_id, ref string as_ballast_from)
public function boolean wf_exists_poc (string as_voyagenr, string as_lastport)
public subroutine wf_get_prevoyage_lastport (string as_voyagenr, ref string as_prevoyage, ref string as_lastport)
public function integer wf_insert_itinerary (string as_voyage, long al_calc_id)
public subroutine wf_lockvoyage ()
public subroutine wf_scrolltolastrow ()
public function long wf_validatevoyage (string as_voyage)
public function integer wf_set_input_dt (long al_vessel_nr, string as_voyage_nr)
public function integer wf_enable_newvoyage (long al_calc_id, long al_vessel_nr, string as_voyage)
public subroutine wf_get_suggestedvoyage ()
end prototypes

event ue_retrieve();/********************************************************************
   ue_retrieve
   <DESC> Refresh the voyage list  </DESC>
   <RETURN>	(none):
   </RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13/03/2013 CR3049         LGX001        First Version
   </HISTORY>
********************************************************************/
string ls_voyage
long ll_found, ll_row
boolean lb_existed_new

//check the new voyage data existed or not
if istr_parm.type_name = is_NEW then
	ll_found = dw_preview_voyage.find("voyage_nr = '" + istr_parm.voyage_nr +"'", 1, dw_preview_voyage.rowcount( ))
	lb_existed_new = (ll_found > 0)
end if
//Refresh the preview voyage list
setnull(ls_voyage)
dw_preview_voyage.retrieve(istr_parm.vessel_nr, ls_voyage)

/* 1. Only show curr voyage when the voyage is not in the last ten preview voyage
	2. Current voyage should be unlocked
*/
if istr_parm.type_name = is_ALLOCATED then
	ll_found = dw_preview_voyage.find("voyage_nr = '" + istr_parm.voyage_nr +"'", 1, dw_preview_voyage.rowcount( ))
	if ll_found <= 0 then
		dw_preview_voyage.reset()
		dw_preview_voyage.retrieve(istr_parm.vessel_nr, istr_parm.voyage_nr)
	end if
	do while true
		ll_found = dw_preview_voyage.find("locked = 1 and voyage_nr = '" + istr_parm.voyage_nr +"'", 1, dw_preview_voyage.rowcount( ))
	   if ll_found > 0 then dw_preview_voyage.setitem(ll_found, "locked", 0) else exit
	loop

//Restore the new voyage data 
elseif istr_parm.type_name = is_NEW and lb_existed_new then
	ll_row = dw_preview_voyage.insertrow(0)
	dw_preview_voyage.setitem(ll_row, "voyage_nr", istr_parm.voyage_nr)
	dw_preview_voyage.setitem(ll_row, "port_code", is_new_port)
	dw_preview_voyage.setitem(ll_row, "port_name", is_new_port_text)
	dw_preview_voyage.setitem(ll_row, "pcn", 		  il_new_pcn)
	dw_preview_voyage.setitem(ll_row, "locked", 0)	
end if
	
end event

public subroutine documentation ();/********************************************************************
	ObjectName: w_voyage	
	<OBJECT> 
		Window to control voyage type providing additional options when required
		- Single Voyage 	: allow user to assign a calculation
		- Idle Voyage 		: User has possibility to enter estimated bunker and port expenses
	</OBJECT>
	<DESC>   Event Description</DESC>
	<USAGE>  Object Usage.</USAGE>
	<ALSO>   otherobjs</ALSO>
	<HISTORY> 
		Date     Ref      	Author   Comments
		12/01/11 ?        	AGL		First Version documented
		12/01/11 2288     	AGL		Added Idle Voyage functionality
		24/02/11 2288     	AGL		Fixed some issues including update of voyage type in 
											   proceeding when changing type here.     
		04/04/11 2339     	AGL		fix issue with calculation remaining on voyage type - Idle	
		06/04/11 2339     	AGL		fixed error so validation check is included when switching type from Idle to Single and there is a mismatch.
											   also fixed an issue with modifying a voyage that may not be the last in the list.
		16/03/12 2735     	JMC		fixed error, so check in idle voyages does not include voyages prior to 2000.
		27/03/12 M5-1     	ZSW001	Create voyage transaction when voyage type changes.
		16/05/12 2413     	LGX001   Auto create proceeding/poc when cbx_autocreate_proceedings is checked
		19/06/12 CR#2831  	AGL027	Removed obsolete code concerned with portvalidator
		03/07/12 2413     	LGX001   insert the rest of ports for the matched voyage   
		10/08/12 CR#2413  	AGL027	Set auto-proceeding checkbox to unchecked
		05/09/12 2923     	LGX001   Validate the voyage has existed cargo or not when updatting
		25/10/12 CR2956   	ZSW001   Next to the red coloured text, we should have a button with "..." on it to show the mismatch details.
		12/11/12 CR3002   	LGX001	Allow to allocate the calc to voyage when the dest voyage has existed cargo
											   1. No any claim on voyage
											   2. Update the cal_cerp_id on cargo / CD table 
		29/01/13 CR3002   	LGX001	Remove CR3002 function
		25/03/13 CR3049   	LGX001	1. Add VP recheck when allocating / fixturing
											   2. Add Purpose recheck when allocating / fixturing
											   3. Refresh voyage preview list dynamically 
											   4. other changes
		08/04/13 CR3200   	WWA048	When using the allocate feature in the calculation fixture process, any contents in the Voyage Comments tab
											   page in POC are replaced with the profit center's default voyage comments text.
		12/04/13 CR3138   	WWA048	Remove "non-cargo operation" icon for port in proceeding when do fixture
		16/09/13 CR3344   	AGL027	Log activity when auto-proceeding is used  
		28/02/14 CR2790   	XSZ004	Refresh voyage list when deleting voyage number
		26/11/14 CR3824   	AZX004   Log activity when Chartering creates a new voyage to allocate a calculation to during the Fixture process.
		03/12/14 CR3414   	XSZ004	Check itinerary ballast from port match the last port in previous voyage
		03/03/15 CR3414UAT	XSZ004	<new> is always shown and creates the next valid voyage number.
		22/03/17	CR4439		HHX010	Each type of voyage will use their own Default Voyage Comment when the voyage is created
	<HISTORY>
********************************************************************/

end subroutine

public subroutine wf_highlight_voyage (string as_voyage);/********************************************************************
   wf_highlight_voyage
   <DESC> selected and highlighted  voyage	</DESC>
   <RETURN>	(none): </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_voyage
   </ARGS>
   <USAGE>	selcted and highlighted  voyage	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30/05/2012 CR2413       LGX001        First Version
   </HISTORY>
********************************************************************/
long ll_found = 1,  ll_count

if isnull(as_voyage) then return

dw_preview_voyage.selectrow(0, false)
ll_count = dw_preview_voyage.rowcount( )

do while ll_found > 0
	ll_found = dw_preview_voyage.find("voyage_nr = '" + as_voyage + "'", ll_found, ll_count)
	if ll_found > 0 then 
		dw_preview_voyage.selectrow(ll_found, true)
		dw_preview_voyage.scrolltorow(ll_found)
		if ll_found >= ll_count then exit
		ll_found ++
	end if
loop
end subroutine

public subroutine wf_initdddw ();/********************************************************************
   wf_initdddw
   <DESC> init the dddw of voyage	</DESC>
   <RETURN>	(none):
            
    </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> this would be call from open event</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		16/05/12		CR2413		LGX001		First Version
		10/01/13		CR3049		LGX001		rewrite part code
		03/12/14		CR3414		XSZ004		Check itinerary ballast from port match the last port in previous voyage
   </HISTORY>
********************************************************************/

string ls_voyage
long   ll_count_voyage, ll_locked, ll_found
int    li_return

is_suggestedvoyage = ""

dw_voyage.getchild("voyage_nr", idwc_child)
idwc_child.settransobject(sqlca)
idwc_child.reset()

setnull(ls_voyage)

li_return = wf_enable_newvoyage(istr_parm.cal_calc_id, istr_parm.vessel_nr, ls_voyage)

if li_return = c#return.success then

	idwc_child.insertrow(0) 
	ls_voyage = "<new>"
	idwc_child.setitem(1, "voyage_nr", ls_voyage)
	
	wf_get_suggestedvoyage()
end if

wf_lockvoyage()

ls_voyage = ""
ll_found  = 1
ll_count_voyage = dw_preview_voyage.rowcount( )

do while true
	ll_found = dw_preview_voyage.find("locked = 0 and voyage_nr <> '" + ls_voyage + "'", ll_found, ll_count_voyage + 1)
	if ll_found <= 0 then exit
	
	ls_voyage = dw_preview_voyage.getitemstring(ll_found, "voyage_nr")
	idwc_child.insertrow(0)
	idwc_child.setitem(idwc_child.rowcount( ), "voyage_nr", ls_voyage)
	
	if ll_found >= ll_count_voyage then exit
	ll_found ++
loop
end subroutine

public subroutine wf_adjust_ui ();/********************************************************************
   wf_adjust_ui
   <DESC>	adjust UI	</DESC>
   <RETURN>	(none):
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	call from win open event </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30/05/2012 CR2413       LGX001        First Version
		11/03/2013 CR3049			LGX001		  Default "Auto-create Proceedings"
   </HISTORY>
********************************************************************/
if istr_parm.type_name = is_FIXTURE then
	cb_update.text = "Allocate"
	dw_voyage.modify("cal_calc_id.visible = '0'")
	dw_voyage.settaborder("cal_calc_id", 0)
	
	dw_voyage.modify("t_calc_desc.visible = '1'")
	dw_voyage.object.t_calc_desc.text = istr_parm.calc_desc
		
	// voyage_type: Single(1)/Position(3)/Offservice(4)/LaidUp(6) 
	dw_voyage.modify("voyage_type.Values = 'Single Voyage	1/Position Voyage	3/Offservice//dock	4/Laid Up	6/'")
	
	cb_refresh.visible = true
	cb_refresh.enabled = true
else
	dw_voyage.modify("voyage_nr_1.visible = '1'")
	dw_voyage.modify("voyage_nr.visible = '0'")
	dw_voyage.settaborder("voyage_nr", 0)
	dw_voyage.settaborder("voyage_nr_1", 0)	
end if
		

end subroutine

public function long wf_get_matchedvoyage (integer al_vessel_nr, string as_voyage_nr, long al_calc_id, long al_calc_voyagetype);/********************************************************************
   wf_calc_match_vayage
   <DESC>Checked whether port is matching or not between proceeding and itineraty</DESC>
   <RETURN>	(long):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		al_calc_id
   </ARGS>
   <USAGE> this function is called when allocating a calculation to a voyage </USAGE>
   <HISTORY>
   	Date       CR-Ref     	  Author             Comments
   	27/04/2012 CR2413				LGX001			First Version
		25/10/2012 CR2956				LGX001			dyn set voyage type in n_portvalidator
		29/03/2013 CR3049				LGX001			Call of_set_checkitin_vp(true)
   </HISTORY>
********************************************************************/

string ls_return
boolean lb_locked = false
long ll_vesselnr, ll_voyage_type, ll_atobviac_used = 0
u_tramos_nvo		lnv_tramos
n_portvalidator lnv_validator

if isnull(as_voyage_nr) or as_voyage_nr = "" then return c#return.Success

SELECT USE_ATOBVIAC_DISTANCE  
INTO :ll_atobviac_used  
FROM CAL_CALC  
WHERE CAL_CALC_ID = :al_calc_id;

//check if proceeding matches itenerary in the calculation
if ll_atobviac_used = 1 then
	lnv_validator = create n_portvalidator
	lnv_validator.of_set_calcid(al_calc_id)
	lnv_validator.of_set_voyagetype(al_calc_voyagetype)
	lnv_validator.of_set_checkitin_vp(true)
	
	//portvalidator object called, validate the port between calculation and voyage
	ls_return = string(lnv_validator.of_start("VOYALLOCATOR", al_vessel_nr, as_voyage_nr, 0))
	destroy lnv_validator
else
	//support bp calculations too
	lnv_tramos = create u_tramos_nvo
	lnv_tramos.of_setcalculationid(al_calc_id)
	ls_return = lnv_tramos.uf_check_proceed_itenerary(al_vessel_nr, as_voyage_nr, false)
	destroy lnv_tramos
end if

if ls_return = "1" then
	return c#return.Success
else
	return c#return.Failure
end if


end function

public subroutine wf_get_ballast_port (long al_calc_id, ref string as_ballast_from);/********************************************************************
   wf_get_ballast_port
   <DESC> get ballast port code	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_calc_id
		as_ballast_from
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/03/2013 CR3049            LGX001        First Version
   </HISTORY>
********************************************************************/

SELECT CAL_CALC.CAL_CALC_BALLAST_FROM
INTO :as_ballast_from 
FROM CAL_CALC
WHERE CAL_CALC.CAL_CALC_ID =  :al_calc_id
AND	EXISTS (SELECT 'X' FROM CAL_CARG WHERE CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID);

	
if isnull(as_ballast_from) then as_ballast_from = ""
	 
end subroutine

public function boolean wf_exists_poc (string as_voyagenr, string as_lastport);/********************************************************************
   wf_exists_poc
   <DESC> To check the last port exists ports or not	</DESC>
   <RETURN>	boolean:
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_voyagenr
		as_lastport
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/03/2013 CR3049       LGX001        First Version
   </HISTORY>
********************************************************************/


long ll_actrow, ll_estrow

SELECT count(PORT_CODE) INTO :ll_actrow
FROM POC
WHERE VESSEL_NR = :istr_parm.vessel_nr AND
  		VOYAGE_NR = :as_voyagenr AND
		PORT_CODE = :as_lastport;
		
SELECT COUNT(PORT_CODE) INTO :ll_estrow
FROM POC_EST
WHERE VESSEL_NR = :istr_parm.vessel_nr AND
  		VOYAGE_NR = :as_voyagenr AND
		PORT_CODE = :as_lastport;

return (ll_estrow + ll_actrow > 0 )					
	
end function

public subroutine wf_get_prevoyage_lastport (string as_voyagenr, ref string as_prevoyage, ref string as_lastport);/********************************************************************
   wf_get_prevoyage_lastport
   <DESC>	get previous voyage and last port </DESC>
   <RETURN>	none:
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/03/2013 CR3049       LGX001        First Version
   </HISTORY>
********************************************************************/

SELECT MAX(VOYAGES.VOYAGE_NR)
INTO :as_prevoyage
FROM VOYAGES
WHERE VOYAGES.VESSEL_NR = :istr_parm.vessel_nr AND
	   (ISNULL(:as_voyagenr, "") = "" OR VOYAGES.VOYAGE_NR < :as_voyagenr);

if isnull(as_prevoyage) then
	as_lastport = ""
	as_prevoyage = ""
	return
elseif not isnull(as_voyagenr) then
	// the same year
	if left(as_voyagenr, 2) = left(as_prevoyage, 2) then
		if long(as_voyagenr) - long(left(as_prevoyage, 5)) > 1 then
			as_lastport = ""
			as_prevoyage = ""
			return
		end if
	end if
end if	

SELECT TOP 1 PROCEED.PORT_CODE 
INTO	:as_lastport
FROM PROCEED
WHERE PROCEED.VESSEL_NR = :istr_parm.vessel_nr AND
		PROCEED.VOYAGE_NR = :as_prevoyage
ORDER BY	PROCEED.PROC_DATE DESC;

if isnull(as_lastport) then as_lastport = ""

end subroutine

public function integer wf_insert_itinerary (string as_voyage, long al_calc_id);
/********************************************************************
   wf_insert_itinerary
   <DESC> insert the port data to dw_preview_voyage </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		as_voyage
		al_calc_id
   </ARGS>
   <USAGE>  if type_name = "New" or type_name = "Fixture", then would be 
				inserted port data into preview voyage	
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/05/12		CR2413		LGX001		First Version
		19/03/13		CR3049		LGX001		Insert all row from itinerary port
		03/12/14		CR3414		XSZ004		Check itinerary ballast from port match the last port in previous voyage
   </HISTORY>
********************************************************************/
long   ll_pcn, ll_itinerarycount, ll_portcount, ll_firstrow, ll_findfirstport
long   ll_min, ll_max, ll_found, ll_rowcount, ll_row, ll_insertrow
string ls_port, ls_portname
date   ld_date
int    li_return

mt_n_datastore  lds_itinerary
n_portvalidator lnv_portvalidator

ld_date      = today()
ll_portcount = 0
ll_found     = 1
ll_firstrow  = 0

//Check ballast from port when allocate new voyage from proceeding 
if istr_parm.type_name = is_NEW then
	li_return = wf_enable_newvoyage(al_calc_id, istr_parm.vessel_nr, as_voyage)
	
	if li_return = c#return.failure then
		destroy n_portvalidator
		return li_return
	end if
end if

//get the latest voyage list
if istr_parm.type_name = is_FIXTURE then 
	this.event ue_retrieve( )
	wf_lockvoyage()
end if

ll_rowcount = dw_preview_voyage.rowcount( )
ll_min      = dw_preview_voyage.find("voyage_nr = '" + as_voyage + "'", 1, ll_rowcount)
ll_max      = dw_preview_voyage.find("voyage_nr = '" + as_voyage + "'", ll_rowcount, 1)

// delete proceeding port data
if ll_min > 0 then
	ll_firstrow = ll_min
	if istr_parm.type_name <> is_NEW then
		dw_preview_voyage.rowsmove(ll_min, ll_max, Primary!, dw_preview_voyage, 1, Delete!)
	end if	
else
	ll_found = dw_preview_voyage.find("voyage_nr > '" + as_voyage + "'", 1, ll_rowcount)
	if ll_found > 0 then ll_firstrow = ll_found
end if	

lnv_portvalidator = create n_portvalidator
lnv_portvalidator.of_getitinerary(al_calc_id, lds_itinerary)

if isvalid(lds_itinerary) then
	ll_itinerarycount = lds_itinerary.rowcount( )
end if

if ll_itinerarycount > 0 then
	//delete ballast from port  
	if lds_itinerary.getitemstring(1, "purpose_code") = "B" then
		lds_itinerary.deleterow(1)
		ll_itinerarycount --
	end if
	//delete ballast to port
	if ll_itinerarycount > 0 then
		if lds_itinerary.getitemstring(ll_itinerarycount, "purpose_code") = "B" then
			lds_itinerary.deleterow(ll_itinerarycount)
			ll_itinerarycount --
		end if
	end if
end if

if ll_itinerarycount <= 0 then
	destroy n_portvalidator
	destroy lds_itinerary
 	return c#return.Failure
end if

//first port = port in the proceeding when new a voyage
if istr_parm.type_name = is_NEW and ll_itinerarycount > 0 then
	ll_findfirstport = lds_itinerary.find("ports_via_point = 0", 1, ll_itinerarycount)
	if ll_findfirstport > 0 then ll_found = lds_itinerary.find("port_code = '" + is_new_port + "'", 1, ll_findfirstport)
	
	if ll_found > 0 then
		dw_preview_voyage.rowsmove(ll_min, ll_max, Primary!, dw_preview_voyage, 1, Delete!)
	else
		if ll_max - ll_min > 0 then dw_preview_voyage.rowsmove(ll_min + 1, ll_max, Primary!, dw_preview_voyage, 1, Delete!)
		if ll_min > 0 then
			dw_preview_voyage.setitem(ll_min, "port_code", is_new_port)
			dw_preview_voyage.setitem(ll_min, "port_name", is_new_port_text)
			dw_preview_voyage.setitem(ll_min, "pcn", il_new_pcn)
			dw_preview_voyage.setitem(ll_min, "locked", 0)
		end if
		
		destroy n_portvalidator
		destroy lds_itinerary
		
 		return c#return.Failure
	end if
end if
	
// insert ports for the matched voyage
for ll_row = 1 to ll_itinerarycount
		
	ls_port = lds_itinerary.getitemstring(ll_row, "port_code")
	if ll_firstrow > 0 then
		ll_insertrow = dw_preview_voyage.insertrow(ll_firstrow + ll_row - 1)
	else
		ll_insertrow = dw_preview_voyage.insertrow(0)
	end if
		
 	dw_preview_voyage.setitem(ll_insertrow, "voyage_nr", as_voyage)
	dw_preview_voyage.setitem(ll_insertrow, "port_code", ls_port)	
	dw_preview_voyage.setitem(ll_insertrow, "locked", 0)
	dw_preview_voyage.setitem(ll_insertrow, "new_voyage", 1)
	ld_date = RelativeDate(date(ld_date), 1)		
	dw_preview_voyage.setitem(ll_insertrow, "proc_date", ld_date)
	
	//set port name
	SELECT PORT_N INTO :ls_portname FROM PORTS WHERE PORT_CODE = :ls_port;
	dw_preview_voyage.setitem(ll_insertrow, "port_name", ls_portname)		
		
	// set PCN
	if lds_itinerary.getitemnumber(ll_row, "ports_via_point") > 0 then
		ll_pcn   = 1
		ll_found = 1
		
		do while 1 = 1 
			ll_found = lds_itinerary.find("ports_via_point > 0", ll_found, ll_row)
			if ll_found <= 0 then exit 
			ll_pcn --
			if ll_found >= ll_row then exit
			ll_found ++
		loop
	else
		ll_pcn   = 0
		ll_found = 1
		
		do while 1 = 1
			ll_found = lds_itinerary.find("port_code = '" + ls_port + "'", ll_found, ll_row)
			if ll_found <= 0 then exit
			ll_pcn ++ 
			if ll_found >= ll_row then exit
			ll_found ++ 
		loop
	end if
	dw_preview_voyage.setitem(ll_insertrow, "pcn", ll_pcn)
next

destroy n_portvalidator
destroy lds_itinerary

return c#return.Success

end function

public subroutine wf_lockvoyage ();/********************************************************************
   wf_lockvoyage
   <DESC> Locked the mismatched voyage	</DESC>
   <RETURN>	(none):
           	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date    		CR-Ref	Author		Comments
		10/04/13		CR3049	LGX001		First Version
   </HISTORY>
********************************************************************/

string ls_voyage
long   ll_count_voyage, ll_locked, ll_found, ll_voyagetype, ll_mismatch
long   ll_result = c#return.Success

ls_voyage = ""
ll_found  = 1
ll_count_voyage = dw_preview_voyage.rowcount( )

do while true
	ll_found = dw_preview_voyage.find("locked = 0 and voyage_nr <> '" + ls_voyage + "'", ll_found, ll_count_voyage + 1)
	if ll_found <= 0 then exit

	ls_voyage = dw_preview_voyage.getitemstring(ll_found, "voyage_nr")
	ll_voyagetype = dw_preview_voyage.getitemnumber(ll_found, "voyage_type")
	
	if istr_parm.type_name = is_FIXTURE then
		ll_result = wf_get_matchedvoyage(istr_parm.vessel_nr, ls_voyage, istr_parm.cal_calc_id, ll_voyagetype)	
	end if
	
	if ll_result = c#return.Failure or istr_parm.type_name <> is_FIXTURE and istr_parm.voyage_nr <> ls_voyage  then
		//set the same mismatched voyage to locked
		do while true
			ll_mismatch = dw_preview_voyage.find("locked = 0 and voyage_nr = '" + ls_voyage + "'", 1, ll_count_voyage)
			if ll_mismatch > 0 then dw_preview_voyage.setitem(ll_mismatch, "locked", 1) else exit
		loop
	end if
	
	if ll_found >= ll_count_voyage then exit
	
	ll_found ++
loop

end subroutine

public subroutine wf_scrolltolastrow ();/********************************************************************
   wf_scrolltolastrow
   <DESC> scroll to last row in dw_preview_voyage</DESC>
   <RETURN>	(None):
            	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10/04/2013 CR3049            LGX001        First Version
   </HISTORY>
********************************************************************/

long ll_rowcount

ll_rowcount = dw_preview_voyage.rowcount( )
if ll_rowcount > 0 then
	if istr_parm.type_name <> is_FIXTURE then
		wf_highlight_voyage(istr_parm.voyage_nr)
	else
		dw_preview_voyage.setrow(ll_rowcount)
		dw_preview_voyage.scrolltorow(ll_rowcount)
		if dw_preview_voyage.getitemnumber(ll_rowcount, "locked") = 0 then
			wf_highlight_voyage(dw_preview_voyage.getitemstring(ll_rowcount, "voyage_nr"))
		else
			dw_preview_voyage.selectrow(0, false)
		end if
	end if
end if

end subroutine

public function long wf_validatevoyage (string as_voyage);/********************************************************************
   wf_validatevoyage
   <DESC> validate  manual voyage number </DESC>
   <RETURN>	(Long):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_voyage
   </ARGS>
   <USAGE> validate  manual voyage number  </USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/05/12		CR2413		LGX001		First Version
		11/03/13		CR3049		LGX001		1.When creating an entirely new voyage,it should be allowed to also manually select a new voyage number,
		        		      		      		 as long as this voyage number does not yet exist for that vessel
		        		      		      		2.Ballast From in Itinerary does not match last port in previous voyage in Proceeding, but there is no estimated 
		        		      		      		 or actual Port of Call for the last port in previous voyage in Proceeding
		03/12/14		CR3414		XSZ004		Check itinerary ballast from port match the last port in previous voyage														
   </HISTORY>
********************************************************************/

long   ll_calc_id, ll_count
int    li_return
string ls_last_voyage, ls_last_port, ls_ballast_from

dw_voyage.getchild("voyage_nr", idwc_child)

// search from voyage dddw first 
if idwc_child.find("voyage_nr = '" + as_voyage + "'", 1, idwc_child.rowcount( )) > 0 then
	wf_insert_itinerary(as_voyage, istr_parm.cal_calc_id)
	wf_highlight_voyage(as_voyage)
	ib_newvoyage = false
	li_return =  c#return.Success
else
	// suggested voyage
	if as_voyage = is_suggestedvoyage then
		wf_insert_itinerary(as_voyage, istr_parm.cal_calc_id)
		wf_highlight_voyage(as_voyage)
		ib_newvoyage = true
		li_return = c#return.Success
	else
		SELECT COUNT(VOYAGE_NR) INTO :ll_count FROM VOYAGES
		WHERE VESSEL_NR = :istr_parm.vessel_nr AND VOYAGE_NR = :as_voyage;
		
		li_return = wf_enable_newvoyage(istr_parm.cal_calc_id, istr_parm.vessel_nr, as_voyage)
		
		if ll_count > 0 or li_return = c#return.Failure then
			ib_newvoyage = false		
			
			if ll_count > 0 then
				messagebox("Information", "This voyage already exists! This is NOT allowed.")	
			else
				messagebox("Information", "The Ballast From port in Calculation is not matching with the last port in the previous voyage")	
			end if
			
			setfocus(dw_voyage)
			dw_voyage.setcolumn("voyage_nr")
			li_return = c#return.Failure
		else
			ib_newvoyage = true
				
			wf_insert_itinerary(as_voyage, istr_parm.cal_calc_id)
			wf_highlight_voyage(as_voyage)
	
			li_return = c#return.Success
		end if
	end if
end if

return  li_return

end function

public function integer wf_set_input_dt (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   wf_set_input_dt
   <DESC> Remove "non-cargo operation" icon for port in proceeding when do fixture </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	12/04/2013   CR3138       WWA048        First Version
   </HISTORY>
********************************************************************/

string 	ls_sqlerrtext
long		ll_count

SELECT COUNT(*)
  INTO :ll_count
  FROM PROCEED
 WHERE VESSEL_NR = :al_vessel_nr AND
		 VOYAGE_NR = :as_voyage_nr AND
		 PCN > 0 AND
		 INPUT_DT IS NOT NULL;

if ll_count > 0 then
	UPDATE PROCEED
		SET INPUT_DT = NULL
	 WHERE VESSEL_NR = :al_vessel_nr AND
			 VOYAGE_NR = :as_voyage_nr AND
			 PCN > 0 AND
			 INPUT_DT IS NOT NULL;
end if

if sqlca.sqlcode < 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	_addmessage(this.classdefinition, "Error", "Error updating port to cargo, Please contact your system administrator.", ls_sqlerrtext)
	
	return c#return.Failure
else
	commit;
end if

return c#return.Success
end function

public function integer wf_enable_newvoyage (long al_calc_id, long al_vessel_nr, string as_voyage);/********************************************************************
   wf_enable_newvoyage
   <DESC> decide to whether new voyage can be created or not 	</DESC>
   <RETURN>	boolean:
	         True : 
				False :            	
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	To create a new voygae should only be available if:	
	        		1.Calculation does not have a ballast port.
					2.Calculation has a ballast port and this port is the last port in the proceeding
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		03/05/12		M1-12 		LGX001		First Version
		30/11/12		CR3049		LGX001		It must be possible to create a new voyage number in the Fixture process if 
		        		      		      		it does not match but where there is no estimated or actual Port of Call for the last port in Proceeding.
		03/12/14		CR3414		XSZ004		Check itinerary ballast from port match the last port in previous voyage
   </HISTORY>
********************************************************************/

int li_return
n_portvalidator lnv_portvalidator

lnv_portvalidator = create n_portvalidator

if istr_parm.type_name = is_FIXTURE then
	li_return = lnv_portvalidator.of_check_ballastfrom(al_calc_id, al_vessel_nr, as_voyage, is_FIXTURE)
else
	li_return = lnv_portvalidator.of_check_ballastfrom(al_calc_id, al_vessel_nr, as_voyage, "VOYALLOCATOR")
end if

destroy lnv_portvalidator

return li_return








end function

public subroutine wf_get_suggestedvoyage ();/********************************************************************
   wf_get_suggestedvoyage
   <DESC> set suggested voyage in the open event	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date      	CR-Ref   	Author		Comments
		27/06/2012	2413     	LGX001		First Version
		27/11/2013	3049     	LGX001		The suggested voyage for a new vessel's first voyage is YY001. Ex: 13001.
		03/03/15  	CR3414UAT	XSZ004		<new> is always shown and creates the next valid voyage number.
	</HISTORY>
********************************************************************/
string ls_max_voyage_nr

SELECT max(VOYAGE_NR) INTO :ls_max_voyage_nr
FROM   VOYAGES
WHERE  VESSEL_NR = :istr_parm.vessel_nr AND CONVERT(INT, SUBSTRING(VOYAGE_NR,1,5)) < 90000;

if sqlca.sqlcode <> 0 then
	is_suggestedvoyage = ""
	return
end if

ls_max_voyage_nr = trim(ls_max_voyage_nr)

if len(ls_max_voyage_nr) > 5 then ls_max_voyage_nr = left(ls_max_voyage_nr, 5)
if isnull(ls_max_voyage_nr) or ls_max_voyage_nr = "" then ls_max_voyage_nr = string(today(), "YY") + "000"

is_suggestedvoyage  = string((long(ls_max_voyage_nr) + 1), "00000")

end subroutine

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_voyage
  
 Object     : window
  
 Event	 : open

 Scope     : window

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 30-07-96

 Description : creates or modifies a voyage 

 Arguments : structure s_new_modify_voyage

 Returns   : number 	-1 window was canceled
				0 voyage created but no clac id entered
				>1voyage created with calc id, calc id returned

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96 		3.0			PBT		System 3
16-05-12   		CR2413  LGX001       
************************************************************************************/

// Local variables 
String ls_text, ls_voyage
long ll_null, ll_row, ll_rowcount

n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style

setnull(is_suggestedvoyage)

if istr_parm.type_name = is_FIXTURE then
	this.hide()
end if

// Place window in correct location
move(80,50)

// get parm to window
istr_parm = message.powerobjectparm

// If Tramos/Calc intergration is not set inform user and lock calc dddw
if not gb_tram_calc_is_interfaced then
	messagebox("Notice","Integration to Tramos not yet implemented, you will be unable to choose a Calculation!")
	dw_voyage.settaborder("cal_calc_id",0)
end if

// get the last ten voyage first
this.event ue_retrieve( )

// Set transaction objects for voyage window and calc dddw
dw_voyage.getchild("cal_calc_id", idwc_child)
idwc_child.settransobject(SQLCA)
idwc_child.retrieve(istr_parm.vessel_nr)
// If no calcs for vessel, set dddw to null
if idwc_child.rowcount() < 1 then
	idwc_child.reset()
	idwc_child.insertrow(0)
	idwc_child.setitem(1, "cal_calc_id", "none")
end if

// If this is a new voyage, then ... 
if istr_parm.type_name = is_NEW then
	
	// Insert row into voyage dw
	dw_voyage.insertRow(0)
	
	// Set default data in new voyage
	dw_voyage.SetItem(1, "vessel_nr", istr_parm.vessel_nr)
	dw_voyage.SetItem(1, "voyage_nr", istr_parm.voyage_nr)
	dw_voyage.SetItem(1, "voyage_type", 1)
	
	ls_voyage = left(istr_parm.voyage_nr, 5)
	
	SELECT VOYAGES.VOYAGE_COMMENTS  
   INTO :ls_text  
   FROM VOYAGES  
   WHERE ( VOYAGES.VESSEL_NR = :istr_parm.vessel_nr ) AND  
         ( Substring(VOYAGES.VOYAGE_NR,1,5) = :ls_voyage )   ;
	commit;		
	dw_voyage.SetItem(1, "voyage_comments", ls_text)
	
	// set vessel name 
	setnull(ls_text)
	SELECT VESSEL_NAME INTO:ls_text FROM VESSELS WHERE VESSEL_NR = :istr_parm.vessel_nr;
	dw_voyage.SetItem(1, "vessels_vessel_name", ls_text)
	
	if isvalid(w_proceeding_list) then
		is_new_port = w_proceeding_list.dw_proceeding.getitemstring(1, "port_code")
		is_new_port_text = w_proceeding_list.dw_proceeding.getitemstring(1, "proc_text")
		
		ll_rowcount = dw_preview_voyage.insertrow(0)
		dw_preview_voyage.setitem(ll_rowcount, "voyage_nr", istr_parm.voyage_nr)
		dw_preview_voyage.setitem(ll_rowcount, "port_code", is_new_port)
		dw_preview_voyage.setitem(ll_rowcount, "port_name", is_new_port_text)
		dw_preview_voyage.setitem(ll_rowcount, "locked", 0)
	   dw_preview_voyage.setitem(ll_rowcount, "new_voyage", 0)
	   dw_preview_voyage.setitem(ll_rowcount, "proc_date", today())
		il_new_pcn = 0
		SELECT VIA_POINT INTO :il_new_pcn FROM PORTS WHERE PORT_CODE = :is_new_port;
		if il_new_pcn <= 0 then
			il_new_pcn = 1
		else
			il_new_pcn = 0
		end if
		dw_preview_voyage.setitem(ll_rowcount, "pcn", il_new_pcn)
		
	end if	
// Allocated calculation in the proceeding windows 
elseif istr_parm.type_name = is_ALLOCATED then
	dw_voyage.retrieve(istr_parm.vessel_nr, istr_parm.voyage_nr)
	if dw_voyage.getitemnumber(1, "cal_calc_id") = 1 then
		setnull(ll_null)
		dw_voyage.setitem(1, "cal_calc_id", ll_null)
	end if
	
// Allocate fixture when doing fixture the related calculation 	
elseif istr_parm.type_name = is_FIXTURE then
	dw_voyage.insertrow(0)
	dw_voyage.setitem(1, "vessel_nr", istr_parm.vessel_nr)
	dw_voyage.setitem(1, "cal_calc_id", istr_parm.cal_calc_id)
	dw_voyage.setitem(1, "vessels_vessel_name", istr_parm.vessel_name)
	dw_voyage.setitem(1, "voyage_type", 1)
	
	// insert value into voyage dddw  	
	wf_initdddw( )
	
	dw_voyage.setcolumn("voyage_nr")
end if

// Ensure that voyage nr more than 5 characters is T/C Out 
if len(istr_parm.voyage_nr) > 5 then
	dw_voyage.setitem(1, "voyage_type", 2)
	dw_voyage.settaborder("voyage_type", 0)
	st_voyagelen.show()	 
end if

ii_originalvoytype = dw_voyage.getitemnumber(1, "voyage_type")

if istr_parm.type_name <> is_FIXTURE then
	wf_lockvoyage()
end if

wf_scrolltolastrow()

wf_adjust_ui()

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_preview_voyage, false)

dw_preview_voyage.setrowfocusindicator(Off!)

if istr_parm.type_name = is_FIXTURE then
	if idwc_child.rowcount() > 0 then
		this.show()
	else
		messagebox("Information", "You cannot allocate the Fixture, because the Ballast From port in the Calculation does not match with the last port in the previous voyage.")
		cb_cancel.triggerevent(Clicked!)
	end if
end if

end event

on w_voyage.create
int iCurrent
call super::create
this.cb_refresh=create cb_refresh
this.cb_cancel=create cb_cancel
this.cbx_autocreate_proceedings=create cbx_autocreate_proceedings
this.dw_preview_voyage=create dw_preview_voyage
this.cb_update=create cb_update
this.dw_voyage=create dw_voyage
this.st_voyagelen=create st_voyagelen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refresh
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cbx_autocreate_proceedings
this.Control[iCurrent+4]=this.dw_preview_voyage
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.dw_voyage
this.Control[iCurrent+7]=this.st_voyagelen
end on

on w_voyage.destroy
call super::destroy
destroy(this.cb_refresh)
destroy(this.cb_cancel)
destroy(this.cbx_autocreate_proceedings)
destroy(this.dw_preview_voyage)
destroy(this.cb_update)
destroy(this.dw_voyage)
destroy(this.st_voyagelen)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_voyage
end type

type cb_refresh from commandbutton within w_voyage
boolean visible = false
integer x = 1271
integer y = 32
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Refresh"
end type

event clicked;boolean lb_scrolltolastrow = true
dwobject ldwo_col

dw_preview_voyage.setredraw(false)

// Refresh preview voyage first
parent.event ue_retrieve()

ib_newvoyage = false

// Refresh dddw voyage list and recheck the current voyage when fixture
if istr_parm.type_name = is_FIXTURE then
	wf_initdddw()
		
	ldwo_col = dw_voyage.object.voyage_nr
	if not isnull(ldwo_col.primary[1]) and ldwo_col.primary[1] <> "" then
		dw_voyage.event itemchanged(1, ldwo_col, ldwo_col.primary[1])
		lb_scrolltolastrow = false
	end if
else
	ldwo_col = dw_voyage.object.cal_calc_id
	if not isnull(ldwo_col.primary[1]) and long(ldwo_col.primary[1]) > 1 then
		dw_voyage.event itemchanged(1, ldwo_col, string(ldwo_col.primary[1]))
		lb_scrolltolastrow = false
	end if
end if


if lb_scrolltolastrow then wf_scrolltolastrow()

dw_preview_voyage.setredraw(true)
end event

type cb_cancel from commandbutton within w_voyage
integer x = 1271
integer y = 1468
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;s_voyage_return lstr_return

lstr_return.ab_autocreateproceeding = false
lstr_return.al_return = -1

Closewithreturn(parent, lstr_return)
end event

type cbx_autocreate_proceedings from checkbox within w_voyage
integer x = 37
integer y = 1468
integer width = 713
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
boolean enabled = false
string text = " Auto-create Proceedings"
end type

event clicked;string ls_null; setnull(ls_null)
string ls_voyage
long ll_calc_id, ll_found
boolean lb_scrolltolastrow = true

dw_preview_voyage.setredraw(false)

ls_voyage = dw_voyage.getitemstring(1, "voyage_nr")
if trim(ls_voyage) = "" then setnull(ls_voyage)

parent.event ue_retrieve( )	

wf_lockvoyage()

if not isnull(ls_voyage) then
	ll_found = dw_preview_voyage.find("locked = 0 and voyage_nr = '" + ls_voyage + "'", 1, dw_preview_voyage.rowcount( ))
	if ll_found > 0 then
		if istr_parm.type_name = is_FIXTURE then dw_voyage.setitem(1, "voyage_nr", ls_voyage)
		
		ll_calc_id = dw_voyage.getitemnumber(1,  "cal_calc_id")
		if this.checked and ll_calc_id > 1 then wf_insert_itinerary(ls_voyage, ll_calc_id) 
		wf_highlight_voyage(ls_voyage)
		lb_scrolltolastrow = false
	else
		if istr_parm.type_name = is_FIXTURE then dw_voyage.setitem(1, "voyage_nr", ls_null)
	end if
end if

if lb_scrolltolastrow then wf_scrolltolastrow()

dw_preview_voyage.setredraw(true)

end event

type dw_preview_voyage from u_datagrid within w_voyage
integer x = 37
integer y = 384
integer width = 1573
integer height = 1056
integer taborder = 20
string dataobject = "d_sp_gr_voyage_last_ten"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean ib_multicolumnsort = false
end type

event clicked;call super::clicked;string ls_voyage
dwobject ldwo_voyage
if row <= 0 then return

if istr_parm.type_name = is_FIXTURE then
	if this.getitemnumber(row, "locked") = 0 then
		ls_voyage = this.getitemstring(row, "voyage_nr")
		if ls_voyage <> dw_voyage.getitemstring(1, "voyage_nr") or isnull(dw_voyage.getitemstring(1, "voyage_nr")) then
			dw_voyage.setitem(1, "voyage_nr", ls_voyage)
			ldwo_voyage = dw_voyage.object.voyage_nr
			dw_voyage.event itemchanged(1, ldwo_voyage, ls_voyage)
		end if
	end if
end if
		
end event

event constructor;dw_preview_voyage.settrans(sqlca)
end event

type cb_update from commandbutton within w_voyage
integer x = 923
integer y = 1468
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;/********************************************************************
   clicked
   <DESC>Note this function ideally should be inside n_voyage and not directly on the click event of command button</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date     		CR-Ref		Author		Comments
		27/03/12			M5-1 			ZSW001
							CR2923 		?				Check if there are cargos on the voyage, return if exists
   	26/11/14 		CR3824   	AZX004      Log activity when Chartering creates a new voyage to allocate a calculation to during the Fixture process.
		08/09/16			CR3320 		AGL027		BMVM processing II - validate using VOYMASTER if we are allowed to add new voyage
		08/11/16			CR3320 		AGL027		BMVM processing II - UAT delivery one defect; validate VOYMASTER only from calculation 'new' voyage generation.
		22/03/17			CR4439		HHX010		Each type of voyage will use their own Default Voyage Comment when the voyage is created
   </HISTORY>
********************************************************************/

integer	li_null, li_test_vessel_nr, li_voyage_type, li_old_type, li_tc_check, li_tcincontracts, li_tcowner
integer	li_illegal_voyage, li_this_voyage = 0, li_year
long		ll_ret_code, ll_previous_voyages, ll_count, ll_calc_id_cur, ll_calc_id_org, ll_trans_id, ll_remaining_tcout_voyages
string	ls_return , ls_voyage, ls_voyage_comments, ls_sqlerrtext
string 	ls_vessel_ref_nr
boolean	lb_newvoyage = true
boolean lb_showcommentpopup = false
boolean lb_calc_changed = false
decimal {4} ld_bunker
decimal {2} ld_portexp
integer li_validatorretval
constant integer li_IDLEDAYS = 7

u_tramos_nvo			uo_tram
s_chart_comment_parm	lstr_parm
s_voyage_return		lstr_return
n_portvalidator lnv_validator
n_auto_proceeding lnv_auto_proceeding
n_object_usage_log lnv_uselog
s_voyageinfo	lstr_voyage
n_voyage			lnv_voyage

setnull(li_null)


// Accept inputted text 
dw_voyage.accepttext()
li_voyage_type = dw_voyage.getitemnumber(1,"voyage_type")
li_old_type = dw_voyage.getitemnumber(1, "voyage_type", primary!, true)

// open from calculation 
if istr_parm.type_name = is_FIXTURE then
	ls_voyage = dw_voyage.getitemstring(1, "voyage_nr")
	
	if isnull(ls_voyage) or trim(ls_voyage) = "" then
		messagebox("Information", "Please select an existing voyage number or manually input a new voyage number from 'Voyage No' field.")
		return
	end if	
	
	istr_parm.voyage_nr = ls_voyage
	SELECT COUNT(*) INTO :ll_count FROM VOYAGES WHERE VESSEL_NR = :istr_parm.vessel_nr AND VOYAGE_NR = :istr_parm.voyage_nr;
	
	lb_newvoyage = (ll_count = 0)
	// create new voyage and allocate
	if lb_newvoyage then
		/* validate using VOYMASTER if we are allowed to add new SPOT voyage */
		lnv_voyage = create n_voyage
		
		/* Voyage master processing - validate if we are allowed to modify selected voyage */
		if lnv_voyage.of_validate_ax_voymaster_state( 1, istr_parm.vessel_nr, istr_parm.voyage_nr, "", li_voyage_type, ls_vessel_ref_nr)=c#return.Failure then
			return c#return.Failure	
		end if	

		destroy lnv_voyage
		dw_voyage.setitemstatus(1, 0, Primary!, NewModified!)
	// only allocate to voyage	
	else
		if ib_newvoyage then
			messagebox("Information", "The voyage list is updated. Please refresh before allocate.")
			return
		end if
		dw_voyage.setitemstatus(1, 0, Primary!, DataModified!)
		dw_voyage.setitemstatus(1, "voyage_type", Primary!, DataModified!)
		dw_voyage.setitemstatus(1, "cal_calc_id", Primary!, DataModified!)
	end if
end if

//Check if there are cargos on the voyage, return if exists
ll_calc_id_cur = dw_voyage.getitemnumber(1, "cal_calc_id", primary!, false)
if istr_parm.type_name = is_ALLOCATED then
	ll_calc_id_org = dw_voyage.getitemnumber(1, "cal_calc_id", primary!, true)
	if isnull(ll_calc_id_cur) then ll_calc_id_cur = 0
	if isnull(ll_calc_id_org) then ll_calc_id_org = 0
	if ll_calc_id_cur > 1 and ll_calc_id_cur <> ll_calc_id_org then
		lb_calc_changed = true
	end if
end if

if lb_calc_changed or istr_parm.type_name = is_FIXTURE then
	SELECT COUNT(*)
	  INTO :ll_count
	  FROM CARGO
	 WHERE VESSEL_NR = :istr_parm.vessel_nr AND
	       VOYAGE_NR = :istr_parm.voyage_nr;

	if ll_count > 0 then
		messagebox("Notice", "You cannot allocate this voyage to a calculation, because there is cargo registered.")
		return	
	end if
end if

if ii_originalvoytype = li_IDLEDAYS and li_voyage_type <> li_IDLEDAYS then
	// no check
else
	if li_voyage_type = li_IDLEDAYS then
		
		SELECT count(*)
		INTO :ll_count
		FROM VOYAGES
		WHERE VESSEL_NR=:istr_parm.vessel_nr and :istr_parm.voyage_nr < VOYAGE_NR
		AND CONVERT(INTEGER, LEFT(VOYAGE_NR, 2)) < 90;
		
		if ll_count > 0 then
			_addmessage( this.classdefinition, "clicked()", "Error, It is not possible to have an idle voyage here in the proceeding due to other voyages following this one", "User information")
			return
		end if	
	end if	
	
	SELECT count(*)
	INTO :ll_count
	FROM VOYAGES
	WHERE VESSEL_NR=:istr_parm.vessel_nr and VOYAGE_TYPE = 7 and :istr_parm.voyage_nr > VOYAGE_NR
	AND CONVERT(INTEGER, LEFT(VOYAGE_NR, 2)) < 90;
	
	if ll_count > 0 then
		if ll_count = 1 and (ii_originalvoytype = li_voyage_type) then
			// nothing to do
		else	
			_addmessage( this.classdefinition, "clicked()", "Error, It is not possible to have a new voyage due to a previous voyage being Idle.  You must change the type of the previous voyage before creating a new one.", "User information")
			return
		end if
	end if
end if

if li_voyage_type = 2 then	
	if len(istr_parm.voyage_nr) <> 7 then
		messagebox("Error","Incorrect voyage number!" )
		return
	end if

	SELECT VOYAGE_TYPE
		INTO :li_illegal_voyage
		FROM VOYAGES
		WHERE VOYAGE_NR = :istr_parm.voyage_nr 
		AND VESSEL_NR = :istr_parm.vessel_nr;

	if li_voyage_type = li_illegal_voyage then
		messagebox("Error","This voyage already exists! This is NOT allowed.")
		return
	else
		SELECT COUNT(*)
			INTO :li_illegal_voyage
			FROM VOYAGES
			WHERE VOYAGE_TYPE <> 2 
			AND VOYAGE_NR = SUBSTRING(:istr_parm.voyage_nr, 1, 5) 
			AND VESSEL_NR = :istr_parm.vessel_nr;

		if li_illegal_voyage > 0 then
			MessageBox("Error","This TC Out voyage has same first 4 ciffers identical to another NOT TC Out voyage ! This is NOT allowed.")
			return
		end if
	end if

else
	if len(istr_parm.voyage_nr) <> 5 then
		messagebox("Error","Incorrect voyage number!" )
		return
	end if
end if

// Check if there could be a conflict with a TC contract. Only TC Out is checked
if integer(LEFT(istr_parm.voyage_nr,2)) < 90 then
	li_year = 2000 +  integer(LEFT(istr_parm.voyage_nr,2))
else
	li_year = 1900 +  integer(LEFT(istr_parm.voyage_nr,2))
end if	

SELECT COUNT(*)
	INTO :li_tc_check
	FROM NTC_TC_CONTRACT C, NTC_TC_PERIOD P
	WHERE  C.CONTRACT_ID = P.CONTRACT_ID
	AND C.VESSEL_NR = :istr_parm.vessel_nr
	AND C.TC_HIRE_IN = 0
	AND DATEPART(YY,P.PERIODE_START) = :li_year ;

if li_voyage_type = 2 then
	if li_tc_check = 0 then
		if messagebox("Warning","This vessel is NOT on TC OUT in the voyage year " + String(20) + &
			left(istr_parm.voyage_nr,2) + ", and this is TC Out voyage. Continue ? ",Exclamation!,YesNo!,2) = 2 then
			return
		end if
	end if
else	
	if li_tc_check > 0 then
		if messagebox("Information","This vessel is on TC OUT part of or the whole year " + String(20) + &
			left(istr_parm.voyage_nr,2) + ", BUT this is not a TC Out voyage. Continue ? ",Exclamation!,YesNo!,2) = 2 then
			return
		end if
	end if
end if

// If voyage type is TC out or idle voyage then set calc id to 1 (dummy)
if li_voyage_type = 2 or li_voyage_type = li_IDLEDAYS then 
	dw_voyage.setitem(1,"cal_calc_id",1)
else
	SELECT Count(*)
		INTO :ll_previous_voyages
		FROM VOYAGES
		WHERE VESSEL_NR = :istr_parm.vessel_nr ;

	SELECT IsNull(VESSELS.TCOWNER_NR,0)  
		INTO :li_tcowner  
		FROM VESSELS
		WHERE VESSEL_NR = :istr_parm.vessel_nr ;

	SELECT Count(*)  
		INTO :li_tcincontracts  
		FROM NTC_TC_CONTRACT  
		WHERE VESSEL_NR = :istr_parm.vessel_nr AND TC_HIRE_IN = 1;

	if not(ll_previous_voyages > 0) and not(li_tcowner > 0) and not(li_tcincontracts > 0) then
		if messagebox("Information","Please confirm that this Voyage is on a Maersk Copenhagen or Broström Gothenburg owned Vessel.",Exclamation!,YesNo!,2) = 2 then
			return
		end if	
	elseif li_tcowner > 0 and not(li_tcincontracts > 0) then
		messagebox("Error","This Vessel has a TC Owner but no TC IN Contract. Voyage is not allowed !") 
		return 
	end if	
end if

// If Tramos/Calc interface has as yet not been implemented, set calc id 1 
if not gb_tram_calc_is_interfaced then
	dw_voyage.setitem(1,"cal_calc_id",1)
end if	

// If no calc id has been given, return with code 0, else return with calc id
if isnull(dw_voyage.getitemnumber(1,"cal_calc_id")) then 
	ll_ret_code = 0
else
	ll_ret_code = dw_voyage.getitemnumber(1,"cal_calc_id")
	SELECT count(*)
		INTO :ll_count
		FROM CAL_CARG,   
			CAL_CERP,   
			CHART  
		WHERE  CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID and  
			 CHART.CHART_NR = CAL_CERP.CHART_NR  and  
			 CAL_CARG.CAL_CALC_ID = :ll_ret_code and
			 char_length (CHART.CHART_COMMENT) > 0;
		
	if ll_count > 0 then
		lb_showcommentpopup=true	
	end if
end if

if dw_voyage.getitemnumber(1, "mismatch_flag") = 1 then
	messagebox("Error", "The selected calculation can not be allocated to this voyage. Please select another calculation instead.")
	return
end if



if istr_parm.type_name = is_NEW then
	SELECT COUNT(*)
	INTO :ll_count
	FROM VOYAGES
	WHERE VOYAGES.VESSEL_NR = :istr_parm.vessel_nr  
		AND VOYAGES.VOYAGE_NR = :istr_parm.voyage_nr;
		
	if ll_count > 0 then
		messagebox("Error", "This voyage already exists! This is NOT allowed.")
		return
	end if
	/* validate VOYMASTER data if we are allowed to issue a new voyage number */
	lnv_voyage = create n_voyage
	if lnv_voyage.of_validate_ax_voymaster_state( 2, istr_parm.vessel_nr, istr_parm.voyage_nr, "", li_voyage_type, ls_vessel_ref_nr)=c#return.Failure then
		return c#return.Failure	
	end if	
	destroy lnv_voyage

end if

if dw_voyage.update() = 1 then
	SELECT VOYAGE_COMMENTS
	  INTO :ls_voyage_comments
	  FROM VOYAGES
	 WHERE VESSEL_NR = :istr_parm.vessel_nr AND
	       VOYAGE_NR = :istr_parm.voyage_nr;
			 
	if (isnull(ls_voyage_comments) or ls_voyage_comments = "") and &
	   (isNull(dw_voyage.getItemString(1, "voyage_comments")) or dw_voyage.getItemString(1, "voyage_comments")= "") then
		if li_voyage_type = 2 then
			UPDATE VOYAGES  
			SET VOYAGE_COMMENTS = PROFIT_C.DEFAULT_VOYAGE_COMMENT_TCOUT  
			FROM PROFIT_C,   VESSELS  
			WHERE VESSELS.PC_NR = PROFIT_C.PC_NR  
			AND VESSELS.VESSEL_NR = VOYAGES.VESSEL_NR  
			AND VOYAGES.VESSEL_NR = :istr_parm.vessel_nr  
			AND VOYAGES.VOYAGE_NR = :istr_parm.voyage_nr 
			AND PROFIT_C.USE_DEFAULT_VOYAGE_COMMENT_TCOUT = 1;
		else
			UPDATE VOYAGES  
			SET VOYAGE_COMMENTS = PROFIT_C.DEFAULT_VOYAGE_COMMENT  
			FROM PROFIT_C,   VESSELS  
			WHERE VESSELS.PC_NR = PROFIT_C.PC_NR  
			AND VESSELS.VESSEL_NR = VOYAGES.VESSEL_NR  
			AND VOYAGES.VESSEL_NR = :istr_parm.vessel_nr  
			AND VOYAGES.VOYAGE_NR = :istr_parm.voyage_nr 
			AND PROFIT_C.USE_DEFAULT_VOYAGE_COMMENT = 1;
		end if
	end if	
	
	if (istr_parm.type_name = is_NEW or li_voyage_type <> li_old_type) or (istr_parm.type_name = is_FIXTURE and ib_newvoyage) then
		lnv_voyage = create n_voyage
		lstr_voyage = lnv_voyage.of_get_voyageinfo(istr_parm.vessel_nr, istr_parm.voyage_nr)
		if lstr_voyage.voyagecount = 0 then
			if istr_parm.type_name = is_NEW or istr_parm.type_name = is_ALLOCATED or istr_parm.type_name = is_FIXTURE then 
				lstr_voyage.status = 'C' 
			else 
				lstr_voyage.status = 'M'
			end if
			lnv_voyage.of_log_voyagechanges(lstr_voyage)
		end if
		destroy lnv_voyage
	end if

	COMMIT;

	if li_voyage_type = li_IDLEDAYS or ii_originalvoytype = li_IDLEDAYS  then 
		// 'Idle Days' voyage
		/*
		TODO: do we need to validate if we have 2 idle voyages in a row?
		
		SELECT TOP 1 VOYAGE_TYPE
		INTO :li_voytype
		from VOYAGES,
		(SELECT MAX(VOYAGE_NR) as voynr from VOYAGES where VESSEL_NR=:istr_parm.vessel_nr) V1
		where VESSEL_NR=:istr_parm.vessel_nr and VOYAGE_NR < V1.voynr
		ORDER BY VOYAGE_NR DESC;
		*/
		
		SELECT count(*) 
		INTO :ll_count
		FROM IDLE_VOYAGE_VAS_FIGURES
		WHERE	IDLE_VOYAGE_VAS_FIGURES.VESSEL_NR =  :istr_parm.vessel_nr and
				IDLE_VOYAGE_VAS_FIGURES.VOYAGE_NR =  :istr_parm.voyage_nr;
		
		if ii_originalvoytype = li_IDLEDAYS and li_voyage_type <> li_IDLEDAYS and ll_count>0 then
			// remove 'Idle Days' entry 
			DELETE FROM IDLE_VOYAGE_VAS_FIGURES 
			WHERE	VESSEL_NR = :istr_parm.vessel_nr AND VOYAGE_NR = :istr_parm.voyage_nr; 
		else	
			ld_bunker = dw_voyage.getitemnumber(1,"idle_est_bunker_consumption")
			ld_portexp = dw_voyage.getitemnumber(1,"idle_est_port_exp_usd")
			if isnull(ld_bunker) then ld_bunker = 0
			if isnull(ld_portexp) then ld_portexp = 0			
			
			if ll_count > 0 then
				UPDATE IDLE_VOYAGE_VAS_FIGURES 
				SET IDLE_EST_BUNKER_CONSUMPTION = :ld_bunker,
					 IDLE_EST_PORT_EXP_USD = :ld_portexp
				WHERE	VESSEL_NR = :istr_parm.vessel_nr AND	
						VOYAGE_NR = :istr_parm.voyage_nr; 
			else
				INSERT INTO IDLE_VOYAGE_VAS_FIGURES (VOYAGE_NR, VESSEL_NR, IDLE_EST_BUNKER_CONSUMPTION, IDLE_EST_PORT_EXP_USD) 			
				VALUES (:istr_parm.voyage_nr, :istr_parm.vessel_nr, :ld_bunker, :ld_portexp);
			end if
		end if
		
		if SQLCA.sqlcode = 0 then
			COMMIT;
		else
			ls_sqlerrtext = sqlca.sqlerrtext
			ROLLBACK;
			_addmessage(this.classdefinition, "clicked", "Error can not update idle days data for voyage", ls_sqlerrtext)
		end if
	end if

	if li_voyage_type <> li_IDLEDAYS  then
		// Check if Calc_id > 1. If yes, check if new voyage. If yes, no test performed
		IF dw_voyage.getitemnumber(1,"cal_calc_id") > 1 THEN
			SELECT DISTINCT VESSEL_NR 
			INTO :li_test_vessel_nr 
			FROM PROCEED
			WHERE VESSEL_NR = :istr_parm.vessel_nr 
			AND VOYAGE_NR = :istr_parm.voyage_nr; 

			if SQLCA.SQLCode = 0 then
				// check if proceeding matches itenerary in the calculation
				if f_AtoBviaC_used (istr_parm.vessel_nr,istr_parm.voyage_nr) then
					lnv_validator = create n_portvalidator
					lnv_validator.of_set_checkitin_vp(true)
					//portvalidator object called, only interested in the return value
					li_validatorretval = lnv_validator.of_start("VOYALLOCATOR", istr_parm.vessel_nr, istr_parm.voyage_nr, 3)
					destroy lnv_validator
				else				
					//support bp calculations too
					uo_tram = CREATE u_tramos_nvo 
					ls_return = uo_tram.uf_check_proceed_itenerary(istr_parm.vessel_nr,istr_parm.voyage_nr, TRUE)
					DESTROY uo_tram;
					if ls_return = "-1" or ls_return = "0" then
						li_validatorretval = c#return.Failure
					end if	
				end if
				
				if li_validatorretval = c#return.Failure then
					UPDATE VOYAGES
						SET CAL_CALC_ID = 1
						WHERE VESSEL_NR = :istr_parm.vessel_nr AND VOYAGE_NR = :istr_parm.voyage_nr;
					COMMIT;
					ll_ret_code = -1
					
					parent.event ue_retrieve()
					wf_lockvoyage()
					wf_scrolltolastrow()					
					
					return
				else
					if lb_showcommentpopup then
						lstr_parm.chart_nr = false
						lstr_parm.reciD = ll_ret_code
						OpenWithParm (w_chart_comment_popup, lstr_parm )
					end if
				end if				
			end if
			
		end if
	end if
	
	if ii_originalvoytype<>li_voyage_type then
		if isvalid(w_proceeding_list) then
			w_proceeding_list.wf_set_calc_and_voyage_type(w_proceeding_list.dw_proceeding_list.getrow())
		end if	
	end if
	
	lstr_return.ab_autocreateproceeding = cbx_autocreate_proceedings.checked
	lstr_return.al_return = ll_ret_code
	
	if istr_parm.type_name = is_FIXTURE then
		if wf_set_input_dt(istr_parm.vessel_nr, istr_parm.voyage_nr) = c#return.Success then
			if cbx_autocreate_proceedings.checked then
				lnv_auto_proceeding = create n_auto_proceeding
				lnv_auto_proceeding.of_auto_proceeding(istr_parm.vessel_nr, istr_parm.voyage_nr)
				destroy lnv_auto_proceeding
				// log user activity
				lnv_uselog.uf_log_object("Auto-create Proceedings (from Fix)")
			end if
		end if
	end if
	
	closewithreturn(parent, lstr_return)
else
	rollback;
end if
end event

type dw_voyage from uo_datawindow within w_voyage
integer x = 37
integer y = 16
integer width = 1573
integer height = 368
integer taborder = 10
string dataobject = "dw_voyage"
boolean border = false
end type

event itemchanged;long   ll_found, ll_count, ll_calc_id, ll_voyagetype
string ls_voyage

choose case dwo.name 
	case "voyage_nr"
		ls_voyage = trim(data)
		
		if ls_voyage = "<new>" and is_suggestedvoyage <> "" then
			ls_voyage = is_suggestedvoyage
			this. post setitem(1, "voyage_nr", ls_voyage)
		elseif not isnumber(ls_voyage) or len(ls_voyage) <> 5 or isnull(ls_voyage) then
			messageBox("Error","Incorrect voyage number: " + ls_voyage)
			setnull(ls_voyage)
			this.post setitem(row, "voyage_nr", ls_voyage)
			dw_preview_voyage.setredraw(false)
			parent.event ue_retrieve( )
			wf_lockvoyage()
			wf_scrolltolastrow()
			dw_preview_voyage.setredraw(true)
			ib_newvoyage = false
			return 1
		end if
		
		dw_preview_voyage.setredraw(false)
		
		if wf_validatevoyage(ls_voyage) = c#return.Failure then
			setnull(ls_voyage)
			this.post setitem(1, "voyage_nr", ls_voyage)
			parent.event ue_retrieve( )
			wf_lockvoyage()
			wf_scrolltolastrow()
			cbx_autocreate_proceedings.enabled = false
			cbx_autocreate_proceedings.checked = false
		else
			cbx_autocreate_proceedings.enabled = true
			cbx_autocreate_proceedings.checked = true
		end if
		
		dw_preview_voyage.setredraw(true)
		
		
	case "voyage_type"		
		ls_voyage = this.getitemstring(row, "voyage_nr")
		ll_calc_id	= this.getitemnumber(row, "cal_calc_id")
		ll_voyagetype = long(data) 
		// idle voyage(7) / Tc out(2)
		if ll_voyagetype = 7 or ll_voyagetype = 2 then
			
			cbx_autocreate_proceedings.checked = false
			cbx_autocreate_proceedings.enabled = false			
			setnull(ll_calc_id)
			cb_update.enabled = true
			
			this.post setitem(row, "mismatch_flag", 0)
			this.post setitem(row, "cal_calc_id", ll_calc_id)
			
			if ll_voyagetype = 2 then
				st_voyagelen.visible = true
			else
				st_voyagelen.visible = false
			end if
			
			parent.event ue_retrieve( )
			
			wf_lockvoyage()
			wf_scrolltolastrow()
			wf_highlight_voyage(ls_voyage)
		else
			st_voyagelen.visible = false
			if isnull(ll_calc_id) then ll_calc_id = 0
			if ll_calc_id <= 1 then
				cbx_autocreate_proceedings.checked = false
				cbx_autocreate_proceedings.enabled = false
			elseif istr_parm.type_name <> is_NEW then
				
				if isnull(ls_voyage) or trim(ls_voyage) = "" then return 
				
				dw_preview_voyage.setredraw(false)
				if wf_get_matchedvoyage(istr_parm.vessel_nr, ls_voyage, ll_calc_id, ll_voyagetype) = c#return.Success then
					cb_update.enabled = true
					wf_insert_itinerary(ls_voyage, ll_calc_id)
					wf_highlight_voyage(ls_voyage)
					this.post setitem(row, "mismatch_flag", 0)
					cbx_autocreate_proceedings.checked = true
					cbx_autocreate_proceedings.enabled = true					
				else
					parent.event ue_retrieve( )
					wf_lockvoyage()
					wf_scrolltolastrow()
					cb_update.enabled = false
					this.post setitem(row, "mismatch_flag", 1)
					cbx_autocreate_proceedings.enabled = false
					cbx_autocreate_proceedings.checked = false
				end if
				dw_preview_voyage.setredraw(true)
			end if
		end if		
	case "cal_calc_id"	
		ls_voyage = this.getitemstring(row, "voyage_nr")
		ll_voyagetype = this.getitemnumber(row, "voyage_type")
		ll_calc_id = long(data)
		dw_preview_voyage.setredraw(false)
			
		if istr_parm.type_name = is_NEW then
			if wf_insert_itinerary(ls_voyage, ll_calc_id) = c#return.Success then
				wf_highlight_voyage(ls_voyage)
				this.post setitem(row, "mismatch_flag", 0)
				cbx_autocreate_proceedings.enabled = true
				cbx_autocreate_proceedings.checked = true
			else
				parent.event ue_retrieve( )
				wf_lockvoyage()
				wf_scrolltolastrow()
				this.post setitem(row, "mismatch_flag", 1)
				cbx_autocreate_proceedings.enabled = false
				cbx_autocreate_proceedings.checked = false
			end if
		elseif istr_parm.type_name = is_ALLOCATED then
			if wf_get_matchedvoyage(istr_parm.vessel_nr, ls_voyage, ll_calc_id, ll_voyagetype) = c#return.Success then
				cb_update.enabled = true
				this.post setitem(row, "mismatch_flag", 0)
				wf_insert_itinerary(ls_voyage, ll_calc_id)
				wf_highlight_voyage(ls_voyage)
				cbx_autocreate_proceedings.enabled = true
				cbx_autocreate_proceedings.checked = true
			else
				cb_update.enabled = false
				parent.event ue_retrieve( )
				wf_lockvoyage()
				wf_scrolltolastrow()
				this.post setitem(row, "mismatch_flag", 1)
				cbx_autocreate_proceedings.enabled = false
				cbx_autocreate_proceedings.checked = false
			end if
		end if
		
		dw_preview_voyage.setredraw(true)
end choose
end event

event itemerror;call super::itemerror;return 1
end event

event losefocus;call super::losefocus;this.accepttext( )

end event

event editchanged;call super::editchanged;if dwo.name = "voyage_nr" then
	inv_dddw_search.event mt_editchanged(row, dwo, data, dw_voyage)
end if
end event

event buttonclicked;call super::buttonclicked;
integer				li_return, li_atobviac_used, ll_row
long					ll_calc_id, ll_voyagetype
string				ls_return, ls_port_code

n_portvalidator	lnv_validator
u_tramos_nvo		lnv_tramos_nvo

//CR2956: Next to the red coloured text, we should have a button with "..." on it to show the mismatch details.
if dwo.name = "b_detail" then
	ll_calc_id = dw_voyage.getitemnumber(row, "cal_calc_id")
	ll_voyagetype = dw_voyage.getitemnumber(row, "voyage_type")
	SELECT USE_ATOBVIAC_DISTANCE INTO :li_atobviac_used FROM CAL_CALC WHERE CAL_CALC_ID = :ll_calc_id;
	if li_atobviac_used = 1 then
		lnv_validator = create n_portvalidator
		lnv_validator.of_set_calcid(ll_calc_id)
		lnv_validator.of_set_voyagetype(ll_voyagetype)
		lnv_validator.of_set_checkitin_vp(true)
		
		if istr_parm.type_name = is_NEW then
			lnv_validator.ib_new_proc = true
			ll_row = dw_preview_voyage.getselectedrow(0)
			if ll_row > 0 then
				ls_port_code = dw_preview_voyage.getitemstring(ll_row, "port_code")
				lnv_validator.of_newproc(ls_port_code)
			end if
		end if
		
		//portvalidator object called
		li_return = lnv_validator.of_start("VOYALLOCATOR", istr_parm.vessel_nr, istr_parm.voyage_nr, lnv_validator.ii_WINDOW)
		w_portvalidator.enabled = true
		
		destroy lnv_validator
	else				
		// support bp calculations too
		lnv_tramos_nvo = create u_tramos_nvo
		ls_return = lnv_tramos_nvo.uf_check_proceed_itenerary(istr_parm.vessel_nr, istr_parm.voyage_nr, true)
		destroy lnv_tramos_nvo
	end if
end if

end event

event constructor;call super::constructor;dw_voyage.SetTransObject(SQLCA)

end event

type st_voyagelen from mt_u_statictext within w_voyage
boolean visible = false
integer x = 55
integer y = 256
integer width = 1024
integer height = 56
string text = "Voyage more than 5 characters must be T/C."
end type

