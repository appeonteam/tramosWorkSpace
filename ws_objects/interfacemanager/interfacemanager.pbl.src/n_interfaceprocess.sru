$PBExportHeader$n_interfaceprocess.sru
$PBExportComments$used to store timings and general configurations for each interface
forward
global type n_interfaceprocess from n_interface
end type
end forward

global type n_interfaceprocess from n_interface
end type
global n_interfaceprocess n_interfaceprocess

type variables
private long _il_interval
private string _is_sourcetable
private string _is_interfacegroup
private datetime _idtm_lastelapsed
/* make private */
/* structure from db */
s_interface		istr_interfaces[]

/* supporting properties */
n_interfacelogic								inv_logic
n_interfacelogicack							inv_logicack
n_interfacelogicax							inv_logicax
n_interfacelogicvm							inv_logicvm
n_interfacelogicvendors 					inv_logicvendor
n_interfacelogicexchangerates 			inv_logicexrate

end variables

forward prototypes
public subroutine documentation ()
public function integer of_writetolog (string as_text, integer ai_loglevel)
public function boolean of_hastimeelapsed ()
public function string of_getnoteinterval ()
public function string of_getsourcetable ()
public function long of_getinterval ()
public function string of_getinterfacegroup ()
public function integer of_createprocess (string as_interfacegroup, string as_sourcetable, long al_interval)
public function integer of_initialisefolder (ref string as_folder, boolean ab_mandatory)
public function integer of_addinterfacemodel (s_interface astr_interface)
public function integer of_start (ref double ad_transcounter)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_interfaceprocess
	
	<OBJECT>
		The batch controller where we group related interfaces together
	</OBJECT>
   <DESC>
		Event Description
	</DESC>
  	<USAGE>
		Object Usage.
	</USAGE>
  	<ALSO>
		
		n_interface
		|	+  n_interfacelogic
		|	|	+	n_interfacelogicvm
		|	|	+ 	n_interfacelogicax
		|	+  *n_interfaceprocess*
		
		
	w_interfaceprocessmanagertimer 	1:M n_interfaceprocess 
	n_interfaceprocess 					1:M s_interface
	n_interfaceprocess 					1:1 n_interfacelogicax
	n_interfaceprocess 					1:1 n_interfacelogicvm	
		
	
	
	modify table INTERFACES
	
	id						:
	name					: 	<new column> char(255)
	group					: 	<new column> char(10)	
	interval				:
	folder_location		:	listening folder
	folder_working		:	char(255)
	folder_archive		:	
	folder_out			:	char(255)
	mq_queuemanager	:
	mq_queuename		:
	enabled				:	
	file_extension		:	obsolete
	filename_counter	:
	sourceref_counter	:
	last_processed		:
	source_table		:
	description			:
	
	
	
	
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		04/01/12 	M5-1     AGL				First Version
		19/01/12		M5-1		AGL				Modified base structure to handle multiple interfaces for ACE 
		27/03/12		M5-5		AGL				Integrated Appeon's AxInterfaces application to receive confirmation messages from ACE
		28/07/15		CR3872	AGL				BMVM modification.  Added more source dataobjects to Acknowledgment model
		09/09/16		CR3320	AGL				revised BMVM process
		
********************************************************************/
end subroutine

public function integer of_writetolog (string as_text, integer ai_loglevel);return super::of_writetolog("'" + of_getinterfacegroup() + "' " + as_text,ai_loglevel)

end function

public function boolean of_hastimeelapsed ();/********************************************************************
  of_hastimeelapsed()
  
<DESC>   
	checks the time the process was last run against the interval
</DESC>
<RETURN>
	Boolean:
		<LI> true, time has elapsed
		<LI> false, time has not yet passed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	n/a
</ARGS>
<USAGE>
	it also sets the new time process was last run
</USAGE>
********************************************************************/

mt_n_datefunctions	lnv_datefunc

if lnv_datefunc.of_secondsafter( _idtm_lastelapsed, datetime(today(),now())  ) > of_getinterval() then
	 _idtm_lastelapsed = datetime(today(),now())
	return true
end if	

return false
end function

public function string of_getnoteinterval ();return "(every " + string(_il_interval) + " secs)"
end function

public function string of_getsourcetable ();return _is_sourcetable
end function

public function long of_getinterval ();return _il_interval
end function

public function string of_getinterfacegroup ();return _is_interfacegroup
end function

public function integer of_createprocess (string as_interfacegroup, string as_sourcetable, long al_interval);
_is_interfacegroup = as_interfacegroup
_is_sourcetable = as_sourcetable
_il_interval = al_interval

return c#return.Success
end function

public function integer of_initialisefolder (ref string as_folder, boolean ab_mandatory);
if as_folder = "" or isnull(as_folder) then 
	if ab_mandatory then
		of_writetolog("error, the required path " + as_folder + " does not exist" ,ii_LOG_IMPORTANT)
		as_folder = "error"
		return c#return.Failure
	else
		return c#return.NoAction
	end if	
else
	/* Make sure the path ends with a '\' */
	as_folder = righttrim(as_folder)
	if right(as_folder,1) <> "\" then
		as_folder += "\"
	end if
	
	if directoryexists(as_folder)	then
		return c#return.Success		
	else
		if ab_mandatory then
			of_writetolog("error, the required path " + as_folder + " does not exist in the filesystem, please create",ii_LOG_IMPORTANT)
			as_folder = "error"
			return c#return.Failure
		else
			of_writetolog("info, the path " + as_folder + " does not exist.  for this process to work completely create a new folder on your server",ii_LOG_IMPORTANT)
			return c#return.NoAction
		end if	
	end if
	
end if
return c#return.Success
end function

public function integer of_addinterfacemodel (s_interface astr_interface);/********************************************************************
   of_addinterfacemodel()
	
<DESC>   
	for each process there can be >= 1 interface model(s)
	
	a process is a batch of actual interfaces that have the following common specs:	
		* source table
		* interface group
		* interval
	
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public/Protected/Private
</ACCESS>
<ARGS>   
	as_description
	al_interval
	as_folderlocation
	as_folderarchive
	as_mqqueuemanager
	as_mq_mq_queuename
</ARGS>
<USAGE>
	on initialisation of interfaces.  called only once.
</USAGE>
********************************************************************/

long ll_index
ll_index = upperbound(istr_interfaces) + 1
integer li_success = c#return.Success

istr_interfaces[ll_index] = astr_interface

/* working folder is compulsary when it has a value. */
if istr_interfaces[ll_index].s_folderworking<>"" then
	if of_initialisefolder(istr_interfaces[ll_index].s_folderworking,true) = c#return.Failure then
		li_success = c#return.Failure
	end if
else
	of_initialisefolder(istr_interfaces[ll_index].s_folderworking,false)
end if	

if right(of_getinterfacegroup(),2)  <> "IN" then
	/* out folder is compulsary whatever */
	if of_initialisefolder(istr_interfaces[ll_index].s_folderout,true) = c#return.Failure then
		li_success = c#return.Failure
	end if
end if

/* archive folder is optional */
if of_initialisefolder(istr_interfaces[ll_index].s_folderarchive,false) = c#return.Success then
	istr_interfaces[ll_index].b_archive = true
end if

/* as is the location folder.  (currently not used) */
of_initialisefolder(istr_interfaces[ll_index].s_folderlocation,false)

return li_success
end function

public function integer of_start (ref double ad_transcounter);/********************************************************************
   of_go()
	
<DESC>   
	Using the interface type reference in the database table INTERFACES
	this function splits processing amongst the business logic objects.
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
	n/ad_transcounter
</ARGS>
<USAGE>
	called directly from the window object w_interfacemanagertimer 
	only when time has elapsed (another function within n_interfaceprocess) 
	since last execution, this function directs business workflow.
	
	known interface models
		Voyage Master Data		VOY_OUT 	- single interface
				
		Transaction Data			AX_OUT 		- many interface members contained for each valid transaction type
										AX_IN			- single interface, but may work for multiple transaction types
	
</USAGE>
********************************************************************/

string ls_filter
integer li_returnflag = c#return.NoAction


CHOOSE CASE of_getsourcetable()
	
	CASE "VOYAGE_MASTER"
		of_writetolog("calling single interface item for VOY_OUT (voyage master) group...", ii_LOG_DEBUG)
		inv_logicvm = create n_interfacelogicvm 
		inv_logicvm.of_setmonitorid(is_monitor_id)
		inv_logicvm.of_registersource("d_sq_tb_voyagemaster")
		inv_logicvm.of_setfilter("isnull(file_name) or file_name=''")
		li_returnflag = inv_logicvm.of_go(istr_interfaces)
		destroy inv_logicvm
	
	CASE "TRANS_LOG_MAIN_A"	
		
		if of_getinterfacegroup() = "AX_IN" then
			/* confirmation message */
			of_writetolog("calling interface inside AX_IN (AX confirmation)  group...", ii_LOG_DEBUG)
			inv_logicack = create n_interfacelogicack
			inv_logicack.of_setmonitorid(is_monitor_id)
			inv_logicack.of_registersource("d_sq_gr_log_main_a", true)
			inv_logicack.of_registersource("d_ex_gr_confirm_msg", false)
			inv_logicack.of_registersource("d_sq_gr_bmvm_lookup_voymaster", false)
			inv_logicack.of_registersource("d_sq_gr_bmvm_lookup_voymastermod", false)
			inv_logicack.of_registersource("d_sq_gr_bmvm_lookup_transloga", false)			
			inv_logicack.of_registersource("d_sq_tb_trans_b", false)
			inv_logicack.of_registersource("d_sq_gr_bmvm_list_claimtranskeys", false)
			inv_logicack.of_registersource("d_ex_gr_voymaster_confirm_msg", true)
			li_returnflag = inv_logicack.of_go(istr_interfaces)
			// if li_returnflag=c#return.NoAction then li_returnflag=c#return.Success
			destroy inv_logicack
		
		else
			/* standard transaction message */
			of_writetolog("calling interface member inside AX_OUT (AX transaction) group ...", ii_LOG_DEBUG)
			inv_logicax = create n_interfacelogicax
			inv_logicax.of_setmonitorid(is_monitor_id)
			inv_logicax.of_registersource("d_sq_tb_trans_a", true)
			inv_logicax.of_registersource("d_sq_tb_trans_b", false)
			inv_logicax.of_registertranstypes(istr_interfaces)
			inv_logicax.of_settranscounter(ad_transcounter)
			li_returnflag = inv_logicax.of_go(istr_interfaces)
			ad_transcounter = inv_logicax.of_gettranscounter()
			destroy inv_logicax
		end if
			
	CASE "VENDOR_LOG"
		/* vendor message */
		of_writetolog("calling interface inside VENDOR_IN (AX confirmation) group...", ii_LOG_DEBUG)
		inv_logicvendor = create n_interfacelogicvendors
		inv_logicvendor.of_setmonitorid(is_monitor_id)
		li_returnflag = inv_logicvendor.of_go(istr_interfaces)
		destroy inv_logicvendor			
			
	CASE "NTC_EXCHANGE_RATES"	
		/* suggested group DAILY-IN */
		/* exchange rate process previously known as ValuaImport */
		of_writetolog("calling interface inside EXCHANGERATE (tramos incoming) group...", ii_LOG_DEBUG)
		inv_logicexrate = create n_interfacelogicexchangerates
		inv_logicexrate.of_setmonitorid(is_monitor_id)
		/* this override also registers the target datastore */
		inv_logicexrate.of_registersource("d_sq_tb_currcodes")
		li_returnflag = inv_logicexrate.of_go(istr_interfaces)
		destroy inv_logicexrate			
					
	CASE ELSE	
		of_writetolog("warning, work in progress - missing business logic, end point", ii_LOG_IMPORTANT)
END CHOOSE

garbagecollect()

return li_returnflag
end function

on n_interfaceprocess.create
call super::create
end on

on n_interfaceprocess.destroy
call super::destroy
end on

event constructor;call super::constructor;/* standard initialisation settings */
 _idtm_lastelapsed = datetime( '1 Dec 2000 00:00')

end event

event destructor;call super::destructor;if isvalid(inv_logic) then destroy inv_logic
if isvalid(inv_logicvm) then destroy inv_logicvm
if isvalid(inv_logicax) then destroy inv_logicax

end event

