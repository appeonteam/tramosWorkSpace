$PBExportHeader$n_accrualslock.sru
forward
global type n_accrualslock from mt_n_nonvisualobject
end type
end forward

global type n_accrualslock from mt_n_nonvisualobject
end type
global n_accrualslock n_accrualslock

type variables
mt_n_datastore _ids_accruallocking
end variables

forward prototypes
public function integer of_getaccrualslock ()
public function integer of_setaccrualslock (integer ai_enablelock)
public subroutine documentation ()
public function boolean of_islockedpc (integer ai_pc)
end prototypes

public function integer of_getaccrualslock ();/* gets the current flag value from the dataobject */
return _ids_accruallocking.getitemnumber( 1, "accruals_running" )
end function

public function integer of_setaccrualslock (integer ai_enablelock);/********************************************************************
   of_setaccrualslock( /*integer ai_enablelock */)
	
	<DESC>
		Updates the system options table column accruals_running with value passed in as parameter
	</DESC>
   	<RETURN> Integer:
            <LI> 1, enabled
            <LI> 0, disabled</RETURN>
   	<ACCESS> 
		Public
	</ACCESS>
   	<ARGS>   
			ai_enablelock: value to either lock or unlock accruals dependent events
	</ARGS>
   	<USAGE>  
		Called only from the server process accrual generator itself.  
		Calls function with ai_enabled=1 on startup to lock, 0 at the end to release
	</USAGE>
********************************************************************/

if ai_enablelock < 0  or ai_enablelock > 1 then
	return c#return.Failure
end if
_ids_accruallocking.setitem(1, "accruals_running", ai_enablelock)

if _ids_accruallocking.update() = 1 then
	commit using sqlca;
	return c#return.Success
else
	rollback using sqlca;
	return c#return.Failure
end if





end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_accrualslock
	
	<OBJECT> 
		Business logic to assist controlling the locking of certain Tramos functionality when the ACCRUALS generation is happening.  At time of development
		this will be at 00:00 on the 1st of each month.
	</OBJECT>
   	<DESC>
		Helper functions
	</DESC>
   	<USAGE>  	
					of_setaccrualslock( /*integer ai_enablelock */) 		:Control flag located inside system_options table
					of_islockedbypc( /*integer ai_pc */)					:Place wherever logic is required.  (example 'finish voyage' button on the portofcall)
	</USAGE>
   	<ALSO>
		Makes use of existing datawindow objects: d_sq_ff_system_options, dw_profit_center.
	</ALSO>
	
    Date   		Ref    			Author	Comments
  15/04/11 	cr#2381      	AGL     	First Version
********************************************************************/

end subroutine

public function boolean of_islockedpc (integer ai_pc);/********************************************************************
	of_islockedpc( /*integer ai_pc */)
	
   	<DESC>
		This is the main call to determine if accruals process is currently running and profit center passed is 
		an accruals enabled.
	</DESC>
   	<RETURN> Boolean:
            <LI> true, profit center is locked
            <LI> false, not locked </RETURN>
   	<ACCESS>
		Public
	</ACCESS>
   	<ARGS>   
		ai_pc: profit center number
	</ARGS>
   	<USAGE>
		From within event you want to trap
	</USAGE>
********************************************************************/

mt_n_datastore lds_pc
lds_pc = create mt_n_datastore
lds_pc.dataobject = "dw_profit_center"
lds_pc.settransobject( sqlca )
lds_pc.retrieve(ai_pc)
if lds_pc.getitemnumber(1,"generate_accruals") = 1 then
	destroy lds_pc
	if of_getaccrualslock( ) = 1 then
		return true
	else
		return false		
	end if	
else
	destroy lds_pc
	return false
end if

end function

on n_accrualslock.create
call super::create
end on

on n_accrualslock.destroy
call super::destroy
end on

event constructor;call super::constructor;/* opens the dataobject into a private datastore object and retrieves the single row */

_ids_accruallocking = create mt_n_datastore
_ids_accruallocking.dataobject="d_sq_ff_system_options"
_ids_accruallocking.settransobject( sqlca )
_ids_accruallocking.retrieve( )
end event

event destructor;call super::destructor;destroy _ids_accruallocking
end event

