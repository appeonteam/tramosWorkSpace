$PBExportHeader$u_vas_idledays.sru
$PBExportComments$Idle Days
forward
global type u_vas_idledays from u_vas_key_data
end type
end forward

global type u_vas_idledays from u_vas_key_data
end type
global u_vas_idledays u_vas_idledays

forward prototypes
public function integer of_start_idledays ()
public subroutine documentation ()
end prototypes

public function integer of_start_idledays ();/********************************************************************
  of_start_idledays( )
   <DESC>   Used to load values in shared data structure</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>n/a</ARGS>
   <USAGE>  Within u_vas_control, called from function of_master_control.</USAGE>
********************************************************************/


string ls_voyage_nr 
integer li_index, li_vessel_nr
decimal {2} ld_idle_days
decimal {3} ld_bunker
decimal {2} ld_portexp

ls_voyage_nr = of_getcurrent_voyage_nr( )
li_vessel_nr = of_getcurrent_vessel_nr( )

/* Set shared values */
ld_idle_days = of_get_days_between(of_getcommenced_date( ), of_getcurrent_enddate( ) )
of_setidle_days (4, ld_idle_days)	

commit;
SELECT IDLE_EST_BUNKER_CONSUMPTION, IDLE_EST_PORT_EXP_USD 
INTO :ld_bunker, :ld_portexp
FROM IDLE_VOYAGE_VAS_FIGURES
WHERE
VOYAGE_NR = :ls_voyage_nr  and 
VESSEL_NR = :li_vessel_nr;
commit;

if not isnull(ld_bunker) then
	of_setbunker_expenses (4,ld_bunker)
end if	
if not isnull(ld_portexp) then
	of_setport_expenses (4,ld_portexp )
end if

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_vas_idledays
	
   <OBJECT> when voyage type is equal to Idle Day here are the exceptions</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  When Voyage Type = 5 (Idle Days) use this object to control processing</USAGE>
   <ALSO>   Ancestor: u_vas_key_data.  Similar to other children of this object</ALSO>
    Date   Ref    Author        Comments
  17/01/11 2183     AGL     Created object
  
  
  TODO: check if we need to create general rule of not 2 idle voyages in a row.
********************************************************************/

end subroutine

on u_vas_idledays.create
call super::create
end on

on u_vas_idledays.destroy
call super::destroy
end on

