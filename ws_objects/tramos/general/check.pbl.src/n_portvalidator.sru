$PBExportHeader$n_portvalidator.sru
forward
global type n_portvalidator from mt_n_nonvisualobject
end type
end forward

global type n_portvalidator from mt_n_nonvisualobject
end type
global n_portvalidator n_portvalidator

type variables
integer ii_action, ii_ballastrow, il_caiopos
mt_n_datastore ids_itin, ids_proc, ids_summary 
mt_n_datastore ids_caio /* used only from CALCCARGO  */
mt_n_datastore ids_validator
u_datawindow_sqlca idw_active[] /* array of datawindows that are shared */
n_checkdata inv_data  

//voyage type
constant integer ii_SINGLEVOYAGE = 1
constant integer ii_TCVOYAGE = 2
constant integer ii_IDLEVOYAGE = 7

/* calculation types  */
constant integer ii_FIXTURED = 4
constant integer ii_CALCULATED = 5
constant integer ii_ESTIMATED = 6
/* Datawindow Port Type */
constant integer ii_LOAD = 1
constant integer ii_DISCHARGE = 2
/* output options */
constant integer ii_NONE = 0
constant integer ii_ERRLOG = 1
constant integer ii_ERRSERV = 2
constant integer ii_WINDOW = 3
constant integer ii_FROMVALIDATOR = 5
/* error service output options */
constant integer ii_ERRWINDOW = 1
constant integer ii_ERRLOGFILE = 2
constant integer ii_ERRWINDB = 3

long il_calc_id = -1  		/* only used on CR2413 when need to dynamically set calculation ID  */
long il_calc_voyagetype    /* only used on CR2413 when need to dynamically set voyage type  */

boolean	ib_new_proc			/* only used on CR2956 when need to dynamically set proceeding */

boolean  ib_checkvp = false

long il_contypeid
end variables

forward prototypes
public subroutine documentation ()
public function integer _addmatchflags (string as_type)
public function integer _composemsg (ref string as_message)
public function string _getpurposecode (string as_purpose)
private function integer _writerow (string as_columnprefix, long al_row, mt_n_datastore ads_reference, long al_referencerow, string as_typetext, integer ai_status)
public function integer of_registeractivedw (ref u_datawindow_sqlca adw)
public function integer of_start (string as_reference, integer ai_vesselnr, string as_voyagenr, integer ai_output)
public function string _getportcode (string as_port)
public function integer of_start (string as_reference, u_datawindow_sqlca adw_summary, n_checkdata anv_opdata, integer ai_output, boolean ab_unlocked, ref integer ai_action)
public function integer _doprocremainder (string as_typetext, long al_procpos, long al_row, integer ai_itinmismatch)
public function integer _doitinremainder (string as_typetext, long al_itinpos, long al_row, integer ai_procmismatch, string as_portcode)
public function integer _build (string as_typecol)
public function integer _mismatched (string as_type, string as_typecol, long al_row, ref long al_itinpos, ref long al_procpos, integer ai_success, boolean ab_ignore)
public function integer _loadmessagedetail (string as_newtext, string as_portcode)
public function integer _setrow (string as_type, ref long ll_currentrow)
public function integer of_updatewindow (string as_reference)
private function integer _main (string as_reference, integer ai_output)
private function integer _initfromcalculation (string as_reference, boolean ab_unlocked)
private function integer _initfromoperations (integer ai_vesselnr, string as_voyagenr)
public subroutine of_getitinerary (long al_calc_id, ref mt_n_datastore ads_itinerary)
private function long _inititinerary (long al_calc_id)
public subroutine of_set_calcid (long al_calc_id)
public subroutine of_set_voyagetype (integer al_calc_voyagetype)
public subroutine of_newproc (string as_port_code)
public subroutine of_set_checkitin_vp (boolean ab_checkvp)
public function integer of_start (string as_reference, integer ai_vesselnr, string as_voyagenr, integer ai_output, ref string as_return)
public function integer of_check_ballastfrom (long al_calc_id, long al_vesselnr, string as_voyagenr, string as_reference)
end prototypes

public subroutine documentation ();/********************************************************************
   n_portvalidator: 
		General purpose validator for mismatched ports between the calculation module and the operational side.
		
	<OBJECT>
		A complex routine.  A lot of functionality involved and difficult business	logic to manage.
	</OBJECT>
  	<DESC>
		Replaces 3 implementations of similar validation logic.  Each scenario can have its own behaviour.
	</DESC>
   <USAGE>
		as_reference - this can be a number of values	
		
		CALCITIN				: implemented  \_ of_start() -> _initfromcalculation()\
		CALCCARGO*			: implemented	/													|
																									 	\_ _	_main() - 	_addmatchflags('ports')	
		POCFINISHVOYAGE*	: implemented	\												 	/						_build('purpose')
		VOYALLOCATOR		: implemented	|													|						_addmatchflags('ports')
		REPORTVAS*			: implemented	|													|						_build('purpose')
		PROCINSERT			: implemented	\_	of_start() -> _initfromoperation()	/						...
		PROCITEMCHANGED	: implemented	/
		CHECKER*				: implemented	|
		CALCACTIVATE*		: implemented	/
		
		references marked with <*> denote they test both port and purpose, whereas the rest validate only the port.
	</USAGE>
   <ALSO>
		- associated object list: 
			n_checkdata
			d_ex_gr_portvalidator
			w_portvalidator
		
		- this object may be called from the following libraries: 
			calcatobviac.pbl
			elecpos.pbl
			supervas.pbl
			check.pbl
		
		- it is used in the following applications:
			TRAMOS
			ACCRUALGENERATOR <Obsolete after 1/June 2012>
	</ALSO>
   
	Date    		Ref   		Author   		Comments
  	02/08/11		D-CALC		AGL027			First Version
	13/01/11		D-CALC		AGL027			set an option to disable port validator _ib_enabled.  This is
   													only temporary measure and will generate a CR to remove this functionality
													   when port validator has been proven.
	30/01/11		D-CALC		AGL027			Refactored _main() function and made general cleanup
	16/02/11		D-CALC		AGL027			Iteration 5 - fixes to requests.. dated 15/2
	20/04/12		CR#2761		AGL027			Just in case bug with atobviac port occurs (CR#2760) surpress the pb error.  Also only process
													   port validator
	16/05/12		CR2413   	LGX001			dynamicaly set calculation ID / voyage type when needed 									
	20/06/12		CR#2831		AGL027			Remove obsolete code and fix issues defined in CR
	25/10/12		CR2956		LGX001			1.dynamicaly set voyage type when needed
													   2.change function name of_setcalculationid() to of_set_calcid()
	11/01/13		CR2956		ZSW001			Dynamically set proceeding
	20/03/13		CR3049		LGX001			1.It must not be possible to allocate a calculation to a voyage when purposes don’t match
													   2.validation – routing/via points 
	28/03/13		CR2658		WWG004			Get the consumption type from the route.
	09/07/13		CR3266		LGX001			The functionality of the 'New' button in Proceeding should work in the same way as with the Proceeding
													   Validator window close. I.e. it should be possible to add a new port
	03/12/14		CR3414		XSZ004			Check itinerary ballast from port match the last port in previous voyage												
	03/12/14		CR3564		XSZ004			1 Only ports should match for position voyage.
	        		      		      		   2 Fix bug for ports and purpose matching when allocating voayge.
	05/12/14		CR3415		XSZ004			Fix bug about port validator window shows a mixed up itinerary	
	        		      	      			   with wrong ports and wrong port sequences.
	21/01/15		CR3921		LHG008			Fix the bug when status is fixture datawindow dw_loadports and dw_dischports not locked.
	03/03/15		CR3564UAT	XSZ004			Fix bug.
	14/03/15		CR4024		XSZ004			Ignore cancel port when port validator.
********************************************************************/


end subroutine

public function integer _addmatchflags (string as_type);/********************************************************************
   _addmatchflags( /*string as_type */)
<DESC>   
	Important function to setup linkage between the 2 datastores.
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	as_type: port or purpose column reference
</ARGS>
<USAGE>
	Executed twice from _main(), once for ports the other for purposes.
</USAGE>
********************************************************************/
boolean lb_found, lb_success, lb_purposeviapoint
integer li_itinindex, li_procindex
string ls_searchvalue, ls_typetext

if as_type = "port_code" then 
	ls_typetext = "port"
else
	ls_typetext = "purpose"
end if

for li_itinindex = 1 to ids_itin.rowcount()
	lb_found=false
	lb_purposeviapoint=false
	ls_searchvalue = ids_itin.getitemstring(li_itinindex, as_type)

	for li_procindex = 1 to ids_proc.rowcount()
		
		if ls_searchvalue = ids_proc.getitemstring(li_procindex, as_type) then
			if ids_proc.getitemnumber(li_procindex,ls_typetext + "matched") = 0 then
				lb_found=true
				ids_itin.setitem(li_itinindex, ls_typetext + "matched", li_procindex )
				ids_proc.setitem(li_procindex, ls_typetext + "matched", li_itinindex )
				exit
			end if	
		end if
	next
	if lb_found = false then
		if ids_itin.getitemstring(li_itinindex, as_type)="" and isnull(ids_proc.getitemstring(li_itinindex, as_type)) then
			ids_itin.setitem(li_itinindex, ls_typetext + "matched", li_itinindex )
			ids_proc.setitem(li_procindex, ls_typetext + "matched", li_itinindex )
		end if
		ids_itin.setitem(li_itinindex, ls_typetext + "matched", -1 )
	end if
next
for li_procindex = 1 to ids_proc.rowcount()
	if ids_proc.getitemnumber(li_procindex, ls_typetext + "matched") = 0 then
		ids_proc.setitem(li_procindex,ls_typetext + "matched", -1 )
	end if
next
return c#return.Success

end function

public function integer _composemsg (ref string as_message);/* write the output to a string */

long ll_row
string ls_itindetail, ls_procdetail, ls_message

for ll_row = 1 to ids_validator.rowcount()
	ls_itindetail+=_getportcode(ids_validator.getitemstring(ll_row,"itin_portcode")) + "(" + _getpurposecode(ids_validator.getitemstring(ll_row,"itin_purposecode")) + "), "
	ls_procdetail+=_getportcode(ids_validator.getitemstring(ll_row,"proc_portcode")) + "(" + _getpurposecode(ids_validator.getitemstring(ll_row,"proc_purposecode")) + "), "	
next	
ls_itindetail= mid(ls_itindetail,1,len(ls_itindetail)-2)
ls_procdetail= mid(ls_procdetail,1,len(ls_procdetail)-2)

as_message += " [ITINERARY:" + ls_itindetail + "] [PROCEEDING:" + ls_procdetail + "]"

return c#return.Success
end function

public function string _getpurposecode (string as_purpose);if as_purpose="" or isnull(as_purpose) then
	return "vp"
else
	return as_purpose
end if
end function

private function integer _writerow (string as_columnprefix, long al_row, mt_n_datastore ads_reference, long al_referencerow, string as_typetext, integer ai_status);/********************************************************************
   _writerow( /*string as_columnprefix*/, /*long al_row*/, /*mt_n_datastore ads_reference*/, /*long al_referencerow*/, /*string as_typetext*/, /*integer ai_status */)

<DESC>   
	Writes data to the datastore that holds the restructured outcome of the port data
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	as_columnprefix		: prefix of the column inside the validator datawindow (either "itin" or "proc")
	al_row					: the current row in the validator datawindow
	ads_reference			: either the itin datastore or the proc datastore
	al_referencerow		: the current row in the source datastore
	as_typetext				: teh prefix for the definition and matched flag (either "port" or "purpose")
	ai_status					: status code dependent on the situation
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/
string ls_def=""

ids_validator.setitem(al_row, as_columnprefix + "_portcode", ads_reference.getitemstring(al_referencerow,"port_code"))			
ids_validator.setitem(al_row, as_columnprefix + "_portname", ads_reference.getitemstring(al_referencerow,"port_name"))			
ids_validator.setitem(al_row, as_columnprefix + "_purposecode", ads_reference.getitemstring(al_referencerow,"purpose_code"))
ids_validator.setitem(al_row, as_columnprefix + "_viapoint", ads_reference.getitemnumber(al_referencerow,"ports_via_point"))
ids_validator.setitem(al_row, as_columnprefix + "_contypeid", ads_reference.getitemnumber(al_referencerow,"cal_cons_id"))
/* pcn only required for shortcut from proceeding side */
if as_columnprefix = "proc" then ids_validator.setitem(al_row, as_columnprefix + "_pcn", ads_reference.getitemnumber(al_referencerow,"pcn"))

choose case ai_status 
	case 0
		/* success */
		return c#return.Success
	case 1
		ls_def = "(itinerary " + as_typetext + " remainder)"		
	case 2		
		ls_def = "(proceeding " + as_typetext + " remainder)"	
	case 3
		ls_def = "(we have a " + as_typetext + " mismatch which does not exist in the itinerary.)"
	case 4
		ls_def = "(mismatch in " + as_typetext + "s)"
	case 5
		ls_def = "(the itinerary " + as_typetext + " can not be found in the proceeding)"
	case 6		
		ls_def = "(the proceeding " + as_typetext + " can not be found in the itinerary)"
	case 7
		ls_def = "(ordering issue in the " + as_typetext + ")"
	case 9	
		ls_def = "(you can not finish a voyage missing actual port calls)"
	case else
		ls_def = "(whoops in the " + as_typetext + " process)"
end choose

ids_validator.setitem(al_row, as_typetext + "_matched", ai_status)

ids_validator.setitem(al_row, as_typetext + "_definition", ls_def)

return c#return.Success

end function

public function integer of_registeractivedw (ref u_datawindow_sqlca adw);idw_active[upperbound(idw_active)+1] = adw
return c#return.Success
end function

public function integer of_start (string as_reference, integer ai_vesselnr, string as_voyagenr, integer ai_output);/********************************************************************
   of_start()
	
<DESC>   
	Function called from the operations module.  ie POC, VAS & Voyage Allocator in Proceeding
</DESC>
<RETURN>
	Integer:
		<LI>  1, Success
		<LI>  0, NoAction
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_reference: 	as_reference values include 'POCFINISHVOYAGE', 
						'REPORTVAS', 'VOYALLOCATOR', 'PORTVALIDATOR'
	ai_vesselnr	: 	the vessel number reference
	as_voyagenr	: 	the voyage number reference
	ai_output	: 	is the error message shown in a popup window, logged or ignored? 
</ARGS>
<USAGE>
	Only used against the operations module.  some unique details are required.  
</USAGE>
********************************************************************/

string ls_port=""
integer li_success
li_success = of_start( as_reference, ai_vesselnr, as_voyagenr, ai_output, ls_port)
return li_success
end function

public function string _getportcode (string as_port);if isnull(as_port) then
	return ""
else
	return as_port
end if
end function

public function integer of_start (string as_reference, u_datawindow_sqlca adw_summary, n_checkdata anv_opdata, integer ai_output, boolean ab_unlocked, ref integer ai_action);/********************************************************************
   of_start()
	
<DESC>   
	Function called from the calculation module.  ie Itinerary/Cargo
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_reference: as_reference values include 'CALCITIN', 'CALCCARGO'
	adw_summary	: 
	anv_opdata	:
	ai_output	:
	ab_unlocked	:
</ARGS>
<USAGE>
	Only used against the calculation.  some unique details are required.  These are
	controlled by the reference value throughout this object.
</USAGE>
********************************************************************/

/*  */

integer li_retval, li_success
long ll_index, ll_dwindex

ids_summary = create mt_n_datastore
ids_summary.dataobject = adw_summary.dataobject
ids_summary.settransobject(SQLCA)
adw_summary.sharedata(ids_summary)

inv_data = anv_opdata

li_retval = _initfromcalculation(as_reference, ab_unlocked)

if li_retval = c#return.Success then

	/* if estimated calculation, lock purpose and port fields */
	ids_itin.setFilter("isnull( cal_route_abc_portid ) and purpose_code <> 'B'")
	ids_itin.filter()
	
	li_success = _main(as_reference, ai_output)

	for ll_dwindex = 1 to upperbound(idw_active)
		if as_reference = "CALCITIN" then
			/* what should we do here? */
		else
			/* control the lockings of port columns */
			if li_success = c#return.Failure and inv_data.ii_calcstatus = ii_CALCULATED then
				for ll_index = 1 to idw_active[ll_dwindex].rowcount()
					idw_active[ll_dwindex].setItem(ll_index, "proceed_locked", 0)
					idw_active[ll_dwindex].setitem(ll_index, "edit_locked", 0)
				next	
			else
				for ll_index = 1 to idw_active[ll_dwindex].rowcount()
					idw_active[ll_dwindex].setItem(ll_index, "proceed_locked", 1)
					if (inv_data.ii_calcstatus = ii_ESTIMATED ) then
						idw_active[ll_dwindex].setitem(ll_index, "edit_locked", 1)
					else
						idw_active[ll_dwindex].setitem(ll_index, "edit_locked", 2)
					end if					
				next
			end if
			
		end if		 
	next

	ids_itin.setFilter("")
	ids_itin.filter()

	ai_action = ii_action
	destroy inv_data
	return li_success
else
	if li_retval <> c#return.Failure then
		// ai_action = ii_action
		destroy inv_data		
		return li_retval
	end if
end if
end function

public function integer _doprocremainder (string as_typetext, long al_procpos, long al_row, integer ai_itinmismatch);/********************************************************************
   _doprocremainder
   <DESC> There are more proc records than itin	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date    		CR-Ref      Author		Comments
		05/12/14		CR3415		XSZ004		Fix bug about port validator window shows a mixed up itinerary	
	        		      	      				with wrong ports and wrong port sequences.
   </HISTORY>
********************************************************************/

if ai_itinmismatch > 0  and as_typetext="port" then
	/* as there is a match in there, we use the stored data */
	_writerow( "proc", al_row, ids_proc, al_procpos, as_typetext, 6)
else	
	/* we write out just the proc detail as we have no itin */
	_writerow( "proc", al_row, ids_proc, al_procpos, as_typetext, 2)
end if


return c#return.Success
end function

public function integer _doitinremainder (string as_typetext, long al_itinpos, long al_row, integer ai_procmismatch, string as_portcode);/********************************************************************
   _doiniremainder
   <DESC> There are more itin records than proc	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date    		CR-Ref      Author		Comments
		05/12/14		CR3415		XSZ004		Fix bug about port validator window shows a mixed up itinerary	
	        		      	      				with wrong ports and wrong port sequences.
		03/03/15		CR3564UAT	XSZ004		Fix bug.
   </HISTORY>
********************************************************************/

if ai_procmismatch>0  and as_typetext="port" then
	if w_portvalidator.is_reference = "POCFINISHVOYAGE" or w_portvalidator.is_reference = "CHECKER" then
		_writerow( "itin", al_row, ids_itin, al_itinpos, as_typetext, 5)
	else
		/* as there is a match in there, we use the stored data */		
		_writerow( "itin", al_row, ids_itin, al_itinpos, as_typetext, 0)
	end if
else	
	/* exceptions */
	CHOOSE CASE w_portvalidator.is_reference
		CASE "PROCINSERT"	
			if w_portvalidator.is_portcode = "" and as_typetext="port" then 
				w_portvalidator.is_portcode	= as_portcode
				il_contypeid	= ids_itin.getitemnumber(al_row, "cal_cons_id")
			end if
		CASE ELSE
			/* do nothing */
	END CHOOSE
	
	if w_portvalidator.is_reference = "POCFINISHVOYAGE" or w_portvalidator.is_reference = "CHECKER" then 
		/* we write out just the itin detail as we have no proc */			
		_writerow( "itin", al_row, ids_itin, al_itinpos, as_typetext, 1)
	else
		_writerow( "itin", al_row, ids_itin, al_itinpos, as_typetext, 0)
	end if
	
end if

return c#return.Success
end function

public function integer _build (string as_typecol);/********************************************************************
   _build( /*string as_type*/)
	
<DESC>   
	This function transforms the 2 seperate datastores into 1 which will be used
	to validate the ports.  it is called directly from _main()
</DESC>
<RETURN>
	Integer:
		<LI>  1 Success
		<LI>  0 NoAction
		<LI> -1 Failure
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	as_typecol	: port or purpose
</ARGS>
<USAGE>
	Depending on reference (stored in inv_windata) it can be called once (port) or twice (port & purpose)
	as_typecol 
	If as_typecol is port new records are appended to the validator datastore.  if as_typecol is purpose
	existing records are modified.

	User functions that are called from here include
		* _setrow()  
		* _lockport()
		* _doitinremainder()
		* _doprocremainder()
		* _writerow()
		* _mismatched()
</USAGE>
<HISTORY>
	Date    		CR-Ref		Author		Comments
	03/12/14		CR3564		XSZ004		1 Only ports should match for position voyage.
	        		      		      		2 Fix bug for ports and purpose matching when allocating voayge.
	04/03/15		CR3564UAT	XSZ004		Fix bug.
</HISTORY>
********************************************************************/

long    ll_row, ll_calcaioid, ll_faultrow=0, ll_itinpos=1, ll_procpos=1, ll_caiopos
integer li_success = c#return.Success, li_itinmismatch, li_procmismatch, li_voyagetype
string  ls_type, ls_itintype, ls_proctype, ls_portdetail
boolean lb_finished = false, lb_insert = false, lb_ignore
boolean lb_checkpurpose = false, lb_checkvoyage = false

li_voyagetype = inv_data.ii_voyagetype

if li_voyagetype <> ii_TCVOYAGE and li_voyagetype <> ii_IDLEVOYAGE then
	lb_checkvoyage = true
	
	if li_voyagetype = ii_SINGLEVOYAGE then
		lb_checkpurpose = true
	else
		lb_checkpurpose = false
	end if
end if

if as_typecol = "port_code" then 
	ls_type = "port"
else
	ls_type = "purpose"
	
	if not lb_checkpurpose then
		return c#return.success
	end if
end if	

do
	_setrow(ls_type,ll_row)
	lb_ignore = false
	if ll_procpos > ids_proc.rowcount() then
		/* there are more itin records than proc */
		_doitinremainder(ls_type, ll_itinpos,ll_row,ids_itin.getitemnumber(ll_itinpos, ls_type + "matched"), ids_itin.getitemstring(ll_row, as_typecol))
		if w_portvalidator.is_reference = "POCFINISHVOYAGE" or w_portvalidator.is_reference = "CHECKER" then
			li_success = c#return.Failure	
		end if	
	elseif ll_itinpos > ids_itin.rowcount() then
		/* there are more proc records than itin */
		_doprocremainder(ls_type, ll_procpos,ll_row,ids_proc.getitemnumber(ll_procpos, ls_type + "matched"))
		if ls_type="port" then
			li_success=c#return.Failure
		end if
	else
		/* we have both an itin and proc record */
		ls_itintype = ids_itin.getitemstring(ll_itinpos, as_typecol)
		if isnull(ls_itintype) then ls_itintype = ""
		ls_proctype = ids_proc.getitemstring(ll_procpos, as_typecol)
		if isnull(ls_proctype) then ls_proctype = ""
		
		if ls_itintype = ls_proctype then
			/* we have a match! */
			_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 0)
			_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 0)
			if isvalid(ids_summary) then
				/* used to test if we really came from the calculation module directly */
				CHOOSE CASE w_portvalidator.is_reference
					CASE "CALCCARGO"
						if inv_data.ii_calcstatus = ii_ESTIMATED then
							if ll_row=1 then ii_action = 2	
						elseif inv_data.ii_calcstatus = ii_CALCULATED then
							if ll_row=1 then ii_action = 1	
						end if
					CASE "CALCITIN"
						if inv_data.ii_calcstatus = ii_ESTIMATED then
							if ll_row=1 then ii_action = 2	
						elseif inv_data.ii_calcstatus = ii_CALCULATED then
							if ll_row=1 then ii_action = 1	
						end if
					CASE ELSE
						/* do nothing */
				END CHOOSE
			end if		
		else
			if lb_checkvoyage then
				CHOOSE CASE w_portvalidator.is_reference
					CASE "PROCINSERT", "PROCITEMCHANGED" 
						if ls_proctype <> "" and ls_type = "port" then
							li_success = c#return.Failure	
						end if
					CASE ELSE
						/* do nothing */
				END CHOOSE
				if ls_type = "port" then
					if ls_proctype <> "" then
						li_success = c#return.Failure				
					end if
				else /* purpose */
					
					CHOOSE CASE w_portvalidator.is_reference
						CASE "CALCCARGO" 
							if ids_proc.getitemstring(ll_procpos, "purpose_code") = "L/D" then
								if il_caiopos>0 then
									if ids_caio.getitemstring(il_caiopos, "purpose_code") = "D" or ids_caio.getitemstring(il_caiopos, "purpose_code") = "L" then
										/* multi-purpose port */
										li_success = c#return.Failure							
									else
										_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 0)
										_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 0)
									end if
								else
									li_success = c#return.Failure
								end if
							end if
						CASE ELSE
							/* do nothing */
					END CHOOSE	
					
					/* check via points with lose validation on matches */
					if ids_proc.getitemnumber(ll_procpos, "ports_via_point") > 0 and ids_itin.getitemnumber(ll_itinpos, "ports_via_point") > 0 then
						if ls_itintype<>ls_proctype then
							if (ls_itintype="" or ls_proctype="") then
								/* do nothing */	
								_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 0)
								_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 0)
								lb_ignore = true
							elseif (ls_itintype<>"" and ls_proctype<>"") then
								_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 4)
								_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 4)
								li_success = c#return.Failure			
							end if
						end if
					else
						
						CHOOSE CASE w_portvalidator.is_reference
							CASE "POCFINISHVOYAGE", "CHECKER"	
								/* this logic relies on validation outside this object to check the type est/act. */
								if ls_itintype<>ls_proctype then
									_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 9)
									_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 9)
									li_success = c#return.Failure	
									lb_ignore = true
								end if
							CASE ELSE	
								if ls_itintype<>ls_proctype and (ls_proctype<>"") then
									_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 4)
									_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 4)
									li_success = c#return.Failure
								elseif ls_itintype<>ls_proctype and (ls_proctype = "") then
									_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 0)
									_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 0)
									lb_ignore = true
								end if
						END CHOOSE		

					end if	
				end if	
				_mismatched( ls_type, as_typecol, ll_row, ll_itinpos, ll_procpos, li_success, lb_ignore )
			else
				/* non single voyage types */		
				_writerow( "itin", ll_row, ids_itin, ll_itinpos, ls_type, 8)
				_writerow( "proc", ll_row, ids_proc, ll_procpos, ls_type, 8)
			end if				
		end if
	end if
	ll_itinpos++
	ll_procpos++
loop until ll_itinpos > ids_itin.rowcount() and ll_procpos > ids_proc.rowcount()


return li_success
end function

public function integer _mismatched (string as_type, string as_typecol, long al_row, ref long al_itinpos, ref long al_procpos, integer ai_success, boolean ab_ignore);/********************************************************************
   _mismatched
<DESC>   
	handles the output of mismatches moved away from its calling process '_build()'
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	as_type: port/purpose???
	as_typecol: column of port_code/purpose_code
	al_row : current row in the portvalidator external datasource
</ARGS>
<USAGE>
	How to use this function.
	User functions that are called from here include
		* _updateportaccess()  
		* _loadmessagedetails()
		* _writerow()
	last modified: AGL 31/01/12 - final small modification to output... 
</USAGE>
********************************************************************/


integer li_itinmismatch, li_procmismatch

if ai_success = c#return.Failure then
	if not (ab_ignore) then
		CHOOSE CASE w_portvalidator.is_reference
			CASE "PROCINSERT"	
				/* modify default data structure sent to window object  */
				if as_type = "port" then
					_loadmessagedetail("Please insert port " + ids_itin.getItemString(al_row, as_typecol) + " before port " +  ids_proc.getItemString(al_row, as_typecol), ids_itin.getItemString(al_row, as_typecol))
				end if
				
				if al_row <= ids_itin.rowcount() then il_contypeid = ids_itin.getItemnumber(al_row, "cal_cons_id")
			CASE ELSE					
				/* do nothing */
		END CHOOSE		
		li_itinmismatch = ids_itin.getitemnumber(al_itinpos,as_type + "matched")
		li_procmismatch = ids_proc.getitemnumber(al_procpos,as_type + "matched")
		if li_itinmismatch = li_procmismatch then
			/* this is normally a case of 2 ports being switched over */
			if li_itinmismatch = -1 then
				/* itin port not in proc, proc port not in itin*/
				_writerow( "itin", al_row, ids_itin, al_itinpos, as_type, 3)
				_writerow( "proc", al_row, ids_proc, al_procpos, as_type, 3)
			else
				/* complete mismatch */
				_writerow( "itin", al_row, ids_itin, al_itinpos, as_type, 4)
				_writerow( "proc", al_row, ids_proc, al_procpos, as_type, 4)
			end if
		else
			if li_itinmismatch = -1 or li_itinmismatch < li_procmismatch then 
				if as_type = "port" then al_procpos --
				_writerow( "itin", al_row, ids_itin, al_itinpos, as_type, 5)
			elseif li_procmismatch = -1 or li_procmismatch < li_itinmismatch then
				if as_type = "port" then al_itinpos --
				_writerow( "proc", al_row, ids_proc, al_procpos, as_type, 6)
			else
				_writerow( "itin", al_row, ids_itin, al_itinpos, as_type, 7)
				_writerow( "proc", al_row, ids_proc, al_procpos, as_type, 7)	
			end if	
		end if
	end if
end if

return c#return.Success
end function

public function integer _loadmessagedetail (string as_newtext, string as_portcode);/* simple assignment of values only if messagedetail is empty */

if w_portvalidator.is_messagedetail = "" then
	w_portvalidator.is_messagedetail = as_newtext
	w_portvalidator.is_portcode = as_portcode
end if
return c#return.Success
end function

public function integer _setrow (string as_type, ref long ll_currentrow);/* depending on type insert new row or proceed to next row reference */

if as_type="port" then 
	ll_currentrow = ids_validator.insertrow(0)
else
	ll_currentrow++
end if	
return c#return.Success
end function

public function integer of_updatewindow (string as_reference);integer li_retval = c#return.Success

w_portvalidator.ii_vesselnr 	= 	inv_data.ii_vesselnr
w_portvalidator.is_voyagenr = 	inv_data.is_voyagenr
w_portvalidator.il_calcid 		=	inv_data.il_calcid
w_portvalidator.il_fixtureid 	= 	inv_data.il_fixtureid
w_portvalidator.il_calcalcid 	= 	inv_data.il_calcalcid
w_portvalidator.il_estcalcid 	= 	inv_data.il_estcalcid

w_portvalidator.dw_validator.reset()
ids_validator.rowscopy( 1, ids_validator.rowcount(), Primary! ,w_portvalidator.dw_validator, 1, Primary!)

CHOOSE CASE as_reference 
	CASE "PROCINSERT"
		w_portvalidator.is_windowtitle = "Insert Proceeding Validator"	
		w_portvalidator.of_generate()
		w_portvalidator.visible = true

	CASE "PROCUPDATE"
		w_portvalidator.is_windowtitle = "Update Proceeding Validator"		
		w_portvalidator.of_generate()
		w_portvalidator.visible = true

	CASE "CALCCARGO"
		w_portvalidator.is_windowtitle = "Cargo Validator"		
		w_portvalidator.of_generate()
		w_portvalidator.visible = true

	CASE "CALCITIN"
		w_portvalidator.is_windowtitle = "Validator"		
		w_portvalidator.of_generate()
		w_portvalidator.visible = true

	CASE "POCFINISHVOYAGE"
		w_portvalidator.is_windowtitle = "Finish Voyage Validator"		
		w_portvalidator.of_generate()
		w_portvalidator.visible = true

	CASE "REPORTVAS"
		w_portvalidator.is_windowtitle = "VAS Validator"						
		w_portvalidator.of_generate()
		w_portvalidator.visible = true

	CASE "CALCACTIVATE"
		w_portvalidator.is_windowtitle = "Calculation Validator"
		w_portvalidator.of_generate()
	CASE ELSE
		w_portvalidator.is_windowtitle = "Validator"		
		w_portvalidator.of_generate()
		w_portvalidator.visible = true

END CHOOSE

return li_retval
end function

private function integer _main (string as_reference, integer ai_output);/********************************************************************
   _main
<DESC>   
	Main function of this compare process
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_reference		: 	Reference of where this object has been called.  ("vas", "poc" etc)
	ai_output			: 	what to do with the error?  
								0=no output, just return the value
								1=check against the error service.  only output if option is set to log file
								3=use validator window
								5=called from existing portvalidator
</ARGS>
<USAGE>
	User functions that are called from here include
		* _addmatchflags()  
		* _build()
		* _composemsg()
		* _loadmessagedetails()
</USAGE>
<HISTORY>
	Date    		CR-Ref		Author		Comments
	03/12/14		CR3414		XSZ004		Check itinerary ballast from port match the last port in previous voyage
	04/03/15		CR3564UAT	XSZ004		Fix bug.
</HISTORY>
********************************************************************/

long    ll_itincount, ll_row, ll_count, ll_matched[]
string  ls_ballast_from, ls_ballast_to, ls_firstport, ls_portcode
integer li_errservoutput, li_portmatch, li_purposematch, li_ballastmatch, li_reference
boolean lb_purpose

n_service_manager	lnv_servicemgr
n_error_service   lnv_error

constant string ls_METHODNAME = "_main()"

if not isvalid(w_portvalidator) then open(w_portvalidator)
w_portvalidator.is_reference = as_reference
w_portvalidator.is_portcode=""
w_portvalidator.is_messagedetail=""

if as_reference = "VOYALLOCATOR" then
	w_portvalidator.dw_validator.modify("compute_reference.expression = '1'")
else
	w_portvalidator.dw_validator.modify("compute_reference.expression = '0'")
end if

w_portvalidator.dw_validator.modify("compute_voyage_type.expression = '" + string(inv_data.ii_voyagetype) + "'")

if _addmatchflags("port_code") = c#return.Success then
	li_portmatch = _build("port_code")
	ls_portcode = w_portvalidator.is_portcode
	
	if li_portmatch = c#return.Success then
		CHOOSE CASE as_reference
			CASE "CALCCARGO", "CALCITIN", "POCFINISHVOYAGE", "REPORTVAS", "CHECKER", "CALCACTIVATE", "PROCINSERT", "PROCITEMCHANGED"
				if _addmatchflags("purpose_code") = c#return.Success then
					li_purposematch = _build("purpose_code")						
					if li_purposematch = c#return.Success then
						/* prepare window */	
						CHOOSE CASE as_reference
							CASE "CALCACTIVATE"
								_loadmessagedetail("No mismatches!","")
								of_updatewindow(as_reference)	
							CASE "CALCCARGO", "POCFINISHVOYAGE"
								if w_portvalidator.visible then
									_loadmessagedetail("No mismatches!","")
									of_updatewindow(as_reference)	
								end if	
							CASE "CHECKER"
								if ai_output=5 then /* user clicked refresh icon on validator window */
									_loadmessagedetail("No mismatches!","")
									of_updatewindow(as_reference)	
								end if	
						END CHOOSE		
					else
						_loadmessagedetail("Purpose mismatch found!","")
					end if	
				end if
			CASE "PROCINSERT"
				//CR3266: Refresh the data when calling from existing portvalidator
				if ai_output = 5 then
					if w_portvalidator.visible then
						_loadmessagedetail("No mismatches!","")
						of_updatewindow(as_reference)	
					end if
				end if
			
				return c#return.Success
			CASE "REPORTVAS", "CALCITIN", "ESTIMATOR" /* , PROCITEMCHANGED */
				return c#return.Success
			CASE ELSE
				/* do nothing */
		END CHOOSE
	else
		_loadmessagedetail("Port mismatch found!","")
		CHOOSE CASE as_reference
			CASE "REPORTVAS", "ESTIMATOR"		
				return c#return.Failure
			CASE "PROCINSERT" /* , PROCITEMCHANGED */
				if isvalid(w_proceeding_list) then
					w_proceeding_list.istr_viap.port[1] = "ERROR"
					w_proceeding_list.istr_viap.viap[1] = 9	
				end if
			CASE ELSE
		END CHOOSE		
	end if
end if

//VP recheck & purpose recheck when allocating to voyage
if ib_checkvp then
	
	//VP recheck
	if li_portmatch = c#return.Failure then
		if ids_validator.rowcount() > 0 then
			if ids_validator.getitemnumber(1, "compute_port_mismatched") <= 0 then li_portmatch = c#return.Success
		end if 
	end if
	
	//Purpose recheck
	if li_portmatch = c#return.Success and inv_data.ii_voyagetype = ii_SINGLEVOYAGE then
		if ids_validator.rowcount() > 0 then
			if ids_validator.getitemnumber(1, "compute_purpose_mismatched") <= 0 then
				li_purposematch = c#return.Success
			else
				li_purposematch = c#return.Failure
			end if
		end if
	end if
end if

li_ballastmatch = of_check_ballastfrom(inv_data.il_calcalcid, inv_data.ii_vesselnr, inv_data.is_voyagenr, as_reference)
	
if li_portmatch = c#return.Failure or li_purposematch = c#return.Failure or li_ballastmatch = c#return.failure then
	
	if li_portmatch = c#return.failure or li_ballastmatch = c#return.failure then
		_loadmessagedetail("Port mismatch found!", "")
	else
		_loadmessagedetail("Purpose mismatch found!", "")
	end if
	
	if as_reference = "PROCINSERT" and ls_portcode <> "" then
		w_portvalidator.is_portcode = ls_portcode
	end if
	
	if ai_output <> ii_WINDOW and ai_output <> ii_FROMVALIDATOR then
		lnv_servicemgr.of_loadservice( lnv_error, "n_error_service")
		li_errservoutput = lnv_error.of_getoutputtype( )
		if li_errservoutput = ii_ERRLOGFILE then
			_composemsg(w_portvalidator.is_messagedetail)
			_addmessage( this.classdefinition, ls_METHODNAME, w_portvalidator.is_messagedetail, "portValidator:User information" )
		end if
		destroy lnv_error
		return c#return.Failure
	else
		
		of_updatewindow(as_reference)
		
		if li_portmatch = c#return.success and as_reference = "PROCINSERT" then
			return c#return.Success
		else
			return c#return.Failure
		end if
	end if
elseif li_portmatch = c#return.Success and li_purposematch <> c#return.Failure then
	if ai_output = ii_FROMVALIDATOR or as_reference="CALCACTIVATE" then
		w_portvalidator.is_messagedetail = "Ports on voyage now match!"
	end if
	return c#return.Success		
end if	
	


end function

private function integer _initfromcalculation (string as_reference, boolean ab_unlocked);/* function loads values into container object n_codata and retreives calc_id */
long ll_row, ll_dw, ll_fixedcalcid, ll_estimatedcalcid, ll_validitin

if inv_data.ii_calcstatus < 4 or inv_data.ii_calcstatus >= 7 or ab_unlocked then return c#return.NoAction
/* when fixing the calculation the validator is called.  at this point the estimated calc id may not exist.  */
if inv_data.il_estcalcid=0 then return c#return.NoAction

/* lock all expenses and route control */
if inv_data.ii_calcstatus = ii_FIXTURED then
	ii_action = 1	
	if as_reference = "CALCCARGO" then 
		ids_summary.setitem(1, "locked", 2)
	end if
	for ll_dw = 1 to upperbound(idw_active)
		for ll_row = 1 to idw_active[ll_dw].rowcount()
			choose case as_reference
				case "CALCCARGO"
					idw_active[ll_dw].setitem(ll_row, "proceed_locked", 1)
					idw_active[ll_dw].setitem(ll_row, "edit_locked", 2)	
				case "CALCITIN"
					idw_active[ll_dw].object.locked[ll_row] = 1
				case else
					/* do nothing*/
			end choose		
		next
	next
	return c#return.NoAction
end if

choose case as_reference
	case "CALCCARGO"
		ids_itin.dataobject = "d_sq_tb_validatoritin"
		ids_itin.settransobject(sqlca)
		ids_itin.retrieve(inv_data.il_calcid)
		ids_caio.dataobject = "d_sq_tb_validatorcaio"
		ids_caio.settransobject(sqlca)
		ids_caio.retrieve(inv_data.il_calcid)		
	case "CALCITIN"
		ids_itin.dataobject = idw_active[1].dataobject
		ids_itin.settransobject(sqlca)
		idw_active[1].sharedata(ids_itin)
	case else
		return c#return.NoAction
end choose	

ll_validitin = ids_itin.rowcount()

/* CR#2761 - just in case bug with atobviac port occurs (CR#2760) surpress the pb error  */
if ll_validitin <= 0 then
	return c#return.NoAction
end if	

if inv_data.ii_vesselnr = 0 and inv_data.is_voyagenr = "" then return c#return.NoAction

if not ib_new_proc then
	ids_proc.dataobject = "d_sq_tb_validatorproc"
	ids_proc.settransobject(sqlca)
	ids_proc.retrieve(inv_data.ii_vesselnr, inv_data.is_voyagenr)
end if

return c#return.Success
end function

private function integer _initfromoperations (integer ai_vesselnr, string as_voyagenr);/* function loads values into container object n_codata and retreives calc_id */

string ls_ballast_from, ls_ballast_to, ls_firstport
long ll_row
boolean lb_purpose

inv_data.ii_vesselnr = ai_vesselnr
inv_data.is_voyagenr = as_voyagenr

SELECT 
	CAL_CALC_ID, 
	VOYAGE_TYPE
INTO 
	:inv_data.il_calcid, 
	:inv_data.ii_voyagetype 
FROM 
	VOYAGES
WHERE 
	VESSEL_NR = :inv_data.ii_vesselnr AND 
	VOYAGE_NR = :inv_data.is_voyagenr
USING sqlca;

/* only used on CR2413 when need to dynamicaly set calculation ID / voyage type from  w_voyages */
if il_calc_id > 0 then 
	inv_data.il_calcid = il_calc_id
	inv_data.ii_voyagetype = il_calc_voyagetype
end if

inv_data.il_estcalcid = inv_data.il_calcid

SELECT 
	CAL_CALC_ID, 
	CAL_CALC_FIX_ID
INTO 
	:inv_data.il_calcalcid, 
	:inv_data.il_fixtureid
FROM 
	CAL_CALC
WHERE 
	CAL_CALC_FIX_ID = 
		(
		SELECT 
			CAL_CALC_FIX_ID 
		FROM 
			CAL_CALC 
		WHERE 
			CAL_CALC_ID=:inv_data.il_estcalcid) 
	AND CAL_CALC_STATUS = 5
USING sqlca;	

_inititinerary(inv_data.il_estcalcid)

/* CR#2761 - just in case bug with atobviac port occurs (CR#2760) surpress the pb error  */
if ids_itin.rowcount()<=0 then
	return c#return.NoAction
end if

if not ib_new_proc then
	ids_proc.dataobject = "d_sq_tb_validatorproc"
	ids_proc.settransobject(sqlca)
	ids_proc.retrieve(inv_data.ii_vesselnr, inv_data.is_voyagenr)
end if

return c#return.Success
end function

public subroutine of_getitinerary (long al_calc_id, ref mt_n_datastore ads_itinerary);
_inititinerary(al_calc_id)

ads_itinerary = ids_itin

end subroutine

private function long _inititinerary (long al_calc_id);
/********************************************************************
   _inititinerary
   <DESC>		</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_calc_id
   </ARGS>
   <USAGE> this would be called form : 
	             1. _initfromoperations()
	             2. of_getitinerary()
	</USAGE>
   <HISTORY>
   	Date       CR-Ref          Author             Comments
   	27/04/2012 M1-12(CR2413)   LGX001        First Version
   </HISTORY>
********************************************************************/

string ls_ballast_from, ls_ballast_to, ls_firstport
long ll_row
boolean lb_purpose

ids_itin.dataobject = "d_sq_tb_validatoritin"
ids_itin.settransobject(sqlca)
ids_itin.retrieve(al_calc_id)


/* obtain ballast fields and first port */
SELECT 
	CAL_CALC.CAL_CALC_BALLAST_FROM, 
	CAL_CALC.CAL_CALC_BALLAST_TO, 
	CAL_CAIO.PORT_CODE
INTO 
	:ls_ballast_from, 
	:ls_ballast_to, 
	:ls_firstport
FROM 
	CAL_CALC, 
	CAL_CARG, 
	CAL_CAIO
WHERE 
	CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID AND 
	CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID
AND 
	CAL_CALC.CAL_CALC_ID = :al_calc_id AND 
	CAL_CAIO.CAL_CAIO_ITINERARY_NUMBER = 1;

for ll_row = 1 to ids_itin.rowcount( )
	if not isnull(ids_itin.getitemstring(ll_row, "purpose_code")) then
		lb_purpose = true
		exit
	end if
next

/* handle ballast entries.  ignore them in calculation itinerary */
if not isnull(ls_ballast_from) and ls_ballast_from <> "" then
	if lb_purpose then
		ids_itin.deleterow(1)
	else
		if ls_firstport <> ls_ballast_from then
			ids_itin.deleterow(1)
		end if
	end if
end if

if not isnull(ls_ballast_to) and ls_ballast_to <> "" then
	if ids_itin.getitemstring(ids_itin.rowcount(),"port_code") = ls_ballast_to then
		ids_itin.deleterow(ids_itin.rowcount())
	end if
end if

return c#return.Success
end function

public subroutine of_set_calcid (long al_calc_id);/* only used on CR2413 when need to dynamicaly set calculation ID  */

il_calc_id = al_calc_id

 

end subroutine

public subroutine of_set_voyagetype (integer al_calc_voyagetype);/* only used on CR2413 when need to dynamicaly set voyage type  */

il_calc_voyagetype = al_calc_voyagetype

end subroutine

public subroutine of_newproc (string as_port_code);/********************************************************************
   of_newproc
   <DESC>	Dynamically set proceeding	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_port_code
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	11/01/2013   CR2956       ZSW001       First Version
		28/03/13		 CR2658		  WWG004			Add column cal_cons_id to datawindow.
   </HISTORY>
********************************************************************/

long		ll_row, ll_via_point, ll_pcn
string	ls_port_name

if ib_new_proc then
	SELECT PORT_N, VIA_POINT INTO :ls_port_name, :ll_via_point FROM PORTS WHERE PORT_CODE = :as_port_code;
	if ll_via_point > 0 then ll_pcn = 0 else ll_pcn = 1
	
	ids_proc.dataobject = "d_sq_tb_validatorproc"
	ids_proc.settransobject(sqlca)
	ll_row = ids_proc.insertrow(0)
	
	ids_proc.setitem(ll_row, "port_code", as_port_code)
	ids_proc.setitem(ll_row, "port_name", ls_port_name)
	ids_proc.setitem(ll_row, "pcn", ll_pcn)
	ids_proc.setitem(ll_row, "portmatched", 0)
	ids_proc.setitem(ll_row, "purposematched", 0)
	ids_proc.setitem(ll_row, "cal_cons_id", 0)
end if

end subroutine

public subroutine of_set_checkitin_vp (boolean ab_checkvp);/********************************************************************
   of_set_checkitin_vp
   <DESC> to set the itinerary vp port matched flag </DESC>
   <RETURN>	(None):
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19/03/2013 CR3049            LGX001        First Version
   </HISTORY>
********************************************************************/
ib_checkvp = ab_checkvp
end subroutine

public function integer of_start (string as_reference, integer ai_vesselnr, string as_voyagenr, integer ai_output, ref string as_return);/********************************************************************
   of_start()
	
<DESC>   
	Function called from operations module, overridden function.
</DESC>
<RETURN>
	Integer:
		<LI>  1, Success
		<LI>  0, NoAction
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_reference	: 	values from operational side
	ai_vesselnr		: 	the vessel number reference
	as_voyagenr		: 	the voyage number reference
	ai_output		: 	is the error message shown in a popup window, logged or ignored?
	as_returntext 	: 	used to return text value 
							portcode detail when as_reference is either set to 'PROCINSERT' or 'PROCITEMCHANGED'.  
							error text when calling process needs to deal with message.  ie 'CHECKER'
</ARGS>
<USAGE>
	Only used against the operations module.  some unique details are required.  
</USAGE>
********************************************************************/

integer li_init, li_success

li_init = _initfromoperations( ai_vesselnr, as_voyagenr) 
if li_init = c#return.Success then
	li_success = _main(as_reference, ai_output)
	/* overrides based on source */
	choose case as_reference
		case "PROCINSERT", "PROCITEMCHANGED", "ESTIMATOR"	
			as_return		= w_portvalidator.is_portcode
		case else
			/* do nothing */
	end choose
end if
return li_success
end function

public function integer of_check_ballastfrom (long al_calc_id, long al_vesselnr, string as_voyagenr, string as_reference);/********************************************************************
   of_check_ballastfrom
   <DESC> Check itinerary ballast from port match the last port in previous voyage </DESC>
   <RETURN>	
		<LI> c#return.Success, X ok
		<LI> c#return.Failure, X failed	
	</RETURN>          	
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_calc_id
		al_vesselnr
		as_voyagenr
		as_reference
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		03/12/14		CR3414		XSZ004		First Version
		03/03/15		CR3414UAT	XSZ004		Fix bug.
		14/03/15		CR4024		XSZ004		Ignore cancel port when port validator.		
   </HISTORY>
********************************************************************/

string  ls_ballast_from, ls_lastport, ls_lastport_name, ls_ballast_name, ls_full_voyagenr
integer li_insertrow, li_pcn, li_return = c#return.failure, li_via_point

SELECT CAL_CALC.CAL_CALC_BALLAST_FROM INTO :ls_ballast_from 
  FROM CAL_CALC
 WHERE CAL_CALC.CAL_CALC_ID = :al_calc_id;

if isnull(ls_ballast_from) then ls_ballast_from = ""

if ls_ballast_from = "" then
	li_return = c#return.success	
else
	
	SELECT FULL_VOYAGE_NR into :ls_full_voyagenr 
	FROM VOYAGES  WHERE VOYAGE_NR = :as_voyagenr AND VESSEL_NR = :al_vesselnr;
	
	if ls_full_voyagenr = "" then
		ls_full_voyagenr = left(string(year(today())), 2) + as_voyagenr
	end if
	
	SELECT TOP 1 PROCEED.PORT_CODE, PROCEED.PROC_TEXT, PROCEED.PCN INTO :ls_lastport, :ls_lastport_name, :li_pcn 
	  FROM PROCEED, VOYAGES
	 WHERE PROCEED.VESSEL_NR = VOYAGES.VESSEL_NR AND PROCEED.VOYAGE_NR = VOYAGES.VOYAGE_NR AND
	       PROCEED.VESSEL_NR = :al_vesselnr AND  PROCEED.CANCEL <> 1 AND (ISNULL(:as_voyagenr, "") = "" OR 
	       VOYAGES.FULL_VOYAGE_NR < :ls_full_voyagenr)
  ORDER BY VOYAGES.FULL_VOYAGE_NR DESC, PROCEED.PORT_ORDER DESC;
	
	if ls_lastport = "" then
		li_return = c#return.success
	else
		  
		if ls_lastport = ls_ballast_from then
			li_return = c#return.success
		else
			li_return = c#return.failure
		end if
	end if
end if

//Display both Ballast From port and the previous voyage's last port if they are not matching.
if li_return = c#return.failure then
	
		SELECT PORT_N, VIA_POINT INTO :ls_ballast_name, :li_via_point FROM PORTS WHERE PORT_CODE = :ls_ballast_from;
		
		li_insertrow = ids_validator.insertrow(1)
		
		ids_validator.setitem(li_insertrow, "itin_viapoint", li_via_point)
		ids_validator.setitem(li_insertrow, "itin_portcode", ls_ballast_from)
		ids_validator.setitem(li_insertrow, "itin_portname", ls_ballast_name)
		ids_validator.setitem(li_insertrow, "itin_purposecode", "B")
		
		ids_validator.setitem(li_insertrow, "proc_portcode", ls_lastport)
		ids_validator.setitem(li_insertrow, "proc_portname", ls_lastport_name)
		ids_validator.setitem(li_insertrow, "proc_pcn", li_pcn)
		
		ids_validator.setitem(li_insertrow, "port_matched", 3)
end if

return li_return
end function

on n_portvalidator.create
call super::create
end on

on n_portvalidator.destroy
call super::destroy
end on

event constructor;call super::constructor;inv_data = create n_checkdata
ids_itin = create mt_n_datastore
ids_proc = create mt_n_datastore
ids_caio = create mt_n_datastore
ids_validator = create mt_n_datastore
ids_validator.dataobject = 'd_ex_gr_portvalidator'

end event

event destructor;call super::destructor;destroy ids_itin
destroy ids_proc
destroy ids_caio
destroy ids_validator


end event

