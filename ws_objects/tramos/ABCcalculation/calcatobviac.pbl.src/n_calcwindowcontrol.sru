$PBExportHeader$n_calcwindowcontrol.sru
$PBExportComments$used to assist managing multiple instances of calculation window
forward
global type n_calcwindowcontrol from mt_n_nonvisualobject
end type
end forward

global type n_calcwindowcontrol from mt_n_nonvisualobject
end type
global n_calcwindowcontrol n_calcwindowcontrol

forward prototypes
public function w_atobviac_calc_calculation of_getopencalc (long al_calcid)
public function w_atobviac_calc_calculation of_getavailablecalc (long al_calcid, long al_fixtureid, integer ai_status, ref integer ai_returncode)
public subroutine documentation ()
end prototypes

public function w_atobviac_calc_calculation of_getopencalc (long al_calcid);/********************************************************************
   of_getopencalc()
<DESC>   
	Basic function used to validate if calculation required exists in an open window already.
</DESC>
<RETURN>
	w_atobviac_calc_calculation:
		<LI> Success : open window object reference
		<LI> Failure : empty window object reference
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	al_calcid: The Calculation we are following
</ARGS>
<USAGE>
	Used directly in the doubleclick event on the datawindow.
</USAGE>
********************************************************************/

w_atobviac_calc_calculation 	lw_calcactive, lw_dummy
window								lw_parent, lw_sheet, lw_currentsheet
boolean 								lb_valid , lb_firstsheet = true , lb_found=false
integer 								li_index=0

lw_parent = w_tramos_main
lw_sheet = lw_parent.getfirstsheet()
lb_valid = isvalid(lw_sheet)

do while lb_Valid
	li_index++
	if lw_sheet.classname( ) = "w_atobviac_calc_calculation" then
		if lb_firstsheet then
			lw_calcactive = lw_parent.getfirstsheet()
		else	
			lw_calcactive = lw_parent.getnextsheet(lw_currentsheet)	
		end if
		if lw_calcactive.il_calc_id	= al_calcid then
			return lw_calcactive
		end if	
	end if
	lw_currentsheet = lw_sheet
	lw_sheet = lw_parent.getnextsheet(lw_currentsheet)	
	lb_valid = isvalid (lw_sheet)
	lb_firstsheet = false
loop

return lw_dummy
end function

public function w_atobviac_calc_calculation of_getavailablecalc (long al_calcid, long al_fixtureid, integer ai_status, ref integer ai_returncode);/********************************************************************
   of_getavailablecalc()
<DESC>   
	Used to validate if calculation required exists in an open window already.
</DESC>
<RETURN>
	w_atobviac_calc_calculation:
		<LI> Success : open window object reference
		<LI> Failure : empty window object reference
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	al_calcid: 		the Calculation we are following
	al_fixtureid:		the fixtured id that strings related calculations together
	ai_status:		the status id of the calculation we want to open
	ai_returncode:	used to allow the calling process to have detail what happened
</ARGS>
<USAGE>
	Used directly in the doubleclick event on the datawindow.
</USAGE>
********************************************************************/

w_atobviac_calc_calculation 	lw_calcactive, lw_dummy
window								lw_parent, lw_sheet, lw_currentsheet
boolean 								lb_valid , lb_firstsheet = true , lb_found=false
integer 								li_index=0

lw_parent = w_tramos_main
lw_sheet = lw_parent.getfirstsheet()
lb_valid = isvalid(lw_sheet)

constant integer li_NOACTION = 0
constant integer li_SAMECALC = 1
constant integer li_MODIFIEDOPEN = 2
constant integer li_CLOSEDUNMODIFIED = 3


constant integer li_CALCULATED = 5
constant integer li_ESTIMATED = 6

do while lb_Valid
	li_index++
	if lw_sheet.classname( ) = "w_atobviac_calc_calculation" then
		if lb_firstsheet then
			lw_calcactive = lw_parent.getfirstsheet()
		else	
			lw_calcactive = lw_parent.getnextsheet(lw_currentsheet)	
		end if
		if lw_calcactive.il_calc_id	= al_calcid then
			ai_returncode=li_SAMECALC
			return lw_calcactive
		elseif lw_calcactive.uo_calculation.uf_get_fix_id( ) = al_fixtureid and (ai_status = li_CALCULATED or ai_status = li_ESTIMATED) then
			/* we have an issue opening calculations related to same fixture when they have a status of calculated/estimated */
			if lw_calcactive.uo_calculation.ib_modified then
				/* the existing calculation can not be closed, send a message to the user! */
				_addmessage( this.classdefinition, "of_getavailablecalc()", "It is not possible to switch to the requested calculation due to a related calculation on the same fixture having outstanding modifications.  Please save/close that calculation before opening this.", "user notification")
				ai_returncode=li_MODIFIEDOPEN
				return lw_calcactive
			else
				ai_returncode=li_CLOSEDUNMODIFIED
				close(lw_calcactive)
				return lw_dummy				
			end if
		end if	
	end if
	lw_currentsheet = lw_sheet
	lw_sheet = lw_parent.getnextsheet(lw_currentsheet)	
	lb_valid = isvalid (lw_sheet)
	lb_firstsheet = false
loop

ai_returncode=li_NOACTION
return lw_dummy
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_calcwindowcontrol
	
	<OBJECT>
		General object to help manage multiple calculation window
	</OBJECT>
   	<DESC>
		Only 2 functions, 1 currently in use.
	</DESC>
   	<USAGE>
		Used to evalulate calculations when using the shortcut.  Could be used elsewhere in the CP
		process/compact view etc at a later date.
	</USAGE>
   	<ALSO>
		w_atobviac_calculation
	</ALSO>
    	Date   		Ref   Author   Comments
  	22/11/11 	D-CALC	AGL027	First Version
********************************************************************/
end subroutine

on n_calcwindowcontrol.create
call super::create
end on

on n_calcwindowcontrol.destroy
call super::destroy
end on

