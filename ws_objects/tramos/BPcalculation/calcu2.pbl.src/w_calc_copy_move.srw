$PBExportHeader$w_calc_copy_move.srw
$PBExportComments$Window for copying/moving
forward
global type w_calc_copy_move from mt_w_response_calc
end type
type dw_calc_copymove from u_datawindow_sqlca within w_calc_copy_move
end type
type cb_ok from uo_cb_base within w_calc_copy_move
end type
type cb_cancel from uo_cb_base within w_calc_copy_move
end type
type st_text from statictext within w_calc_copy_move
end type
type gb_1 from uo_gb_base within w_calc_copy_move
end type
end forward

global type w_calc_copy_move from mt_w_response_calc
integer width = 3195
integer height = 1408
string title = "Copy"
dw_calc_copymove dw_calc_copymove
cb_ok cb_ok
cb_cancel cb_cancel
st_text st_text
gb_1 gb_1
end type
global w_calc_copy_move w_calc_copy_move

type variables
s_calc_copymove_parm istr_parm
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_calc_copy_move
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	08/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Retrieve data into the DW_CALC_COPYMOVE datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_calc_copymove.Retrieve(istr_parm.l_from_calc, uo_global.is_userid, istr_parm.s_filter_create_user)

COMMIT;
end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Opens the copy/move window, that enables the user to move or copy
 					one cargo from one calculation to another. Arguments is passed
					in a S_CALC_COPYMOVE_PARM structure in the message object.
					
 Arguments : S_CALC_COPYMOVE_PARM, containing the following information:
 
 				 I_FUNCTION_CODE as integer, can be 1 (copy) or 2 (move) 
				 L_CARGO as Long, ID of cargo to move or copy
				 L_FROM_CALC as Long, ID of calculation the cargo is from

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Get the arguments passed in the messageobject into the ISTR_PARM
istr_parm = Message.PowerObjectParm

// Update the text, title and  buttons depending on the function code
CHOOSE CASE istr_parm.i_function_code
	CASE 1 // Copy
		st_text.text = "Select calculation to which you want to copy cargo, and select copy"
		cb_ok.text = "Cop&y"
		This.Title = "Copy cargo"
	CASE 2 // Move
		st_text.text = "Select calculation to which you want to move cargo, and select move"
		cb_ok.text = "&Move"
		This.Title = "Move cargo"
END CHOOSE

// Post a retrieve event
PostEvent("ue_retrieve")
// and set the auto (click handling) to true
dw_calc_copymove.ib_auto = true
end event

on w_calc_copy_move.create
int iCurrent
call super::create
this.dw_calc_copymove=create dw_calc_copymove
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_text=create st_text
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_calc_copymove
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.st_text
this.Control[iCurrent+5]=this.gb_1
end on

on w_calc_copy_move.destroy
call super::destroy
destroy(this.dw_calc_copymove)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_text)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_copy_move
end type

type dw_calc_copymove from u_datawindow_sqlca within w_calc_copy_move
integer x = 55
integer y = 112
integer width = 3072
integer height = 1024
integer taborder = 30
string dataobject = "d_calc_copymove"
boolean vscrollbar = true
end type

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;cb_ok.enabled = true
end on

type cb_ok from uo_cb_base within w_calc_copy_move
integer x = 2610
integer y = 1152
integer taborder = 40
boolean enabled = false
string text = "&OK "
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Copies or moves the cargo to the current cargo, chosen in the 
 					DW_CALC_COPYMOVE datawindow

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
Long ll_row, ll_to_calc, ll_count, ll_max
String ls_from, ls_to, ls_tmp

// Get the current row, and validate it
ll_row = dw_calc_copymove.GetRow()

If ll_row > 0 Then
	// Get the CALC_ID of the calculation that we are about to copy or move to
	ll_to_calc = dw_calc_copymove.GetItemNumber(ll_row, "cal_calc_cal_calc_id")

	// Get the description for both calculations
	SELECT CAL_CALC_DESCRIPTION
	INTO :ls_from
	FROM CAL_CALC
	WHERE CAL_CALC_ID = :istr_parm.l_from_calc;
	COMMIT;

	SELECT CAL_CALC_DESCRIPTION
	INTO :ls_to
	FROM CAL_CALC
	WHERE CAL_CALC_ID = :ll_to_calc;
	COMMIT;

	CHOOSE CASE istr_parm.i_function_code
		CASE 1
			ls_tmp = "Copy"
		CASE 2
			ls_tmp = "Move"
	END CHOOSE

	// Display notice box to user, requestion the acknowledge for copy or move
	If MessageBox("Notice", ls_tmp + " from ~"" + ls_from + "~" to ~"" + ls_to + "~"~r~n~r~nContinue ?", Question!, YesNo!, 1) = 1 Then
		// The user selected OK.
		
		CHOOSE CASE istr_parm.i_function_code
			CASE 1
				// This is a copy, INSERT a new field in the CAL_CARG table, containing
				// all the values from the cargo that we're to copy from, except
				// CAL_CARG_STATUS that is set to 2 (working).

				commit;

				INSERT CAL_CARG
				  SELECT  :ll_to_calc as 
					  CAL_CALC_ID,
				  CAL_CERP_ID, CAL_CARG_FREIGHT_TYPE,   
				CAL_CARG_FREIGHT_RATE, CAL_CARG_LUMPSUM, CAL_CARG_WS_RATE,   
				CAL_CARG_FLATRATE, CAL_CARG_LAYCAN_START, CAL_CARG_LAYCAN_END,   
				CAL_CARG_TOTAL_UNITS, CAL_CARG_FREIGHT_PER_UNIT,   
				CAL_CARG_MIN_1, CAL_CARG_MIN_2, CAL_CARG_OVERAGE_1,   
				CAL_CARG_OVERAGE_2, CAL_CARG_ADR_COMMISION, CAL_CARG_TEMP_COMISSION,   
				CAL_CARG_ADD_DAYS_LADEN, CAL_CARG_ADD_DAYS_BALLAST,   
				CAL_CARG_ADD_DAYS_OTHER, CAL_CARG_ADD_FO,   
				CAL_CARG_ADD_DO,  CAL_CARG_ADD_MGO, CAL_CARG_ADD_LUMPSUM, 
				CAL_CARG_ADD_EXPENSES, CAL_CARG_PREDE_DAYS_LAYCAN,    
				CAL_CARG_DESCRIPTION, 2 as CAL_CARG_STATUS, CAL_CARG_ORDER,   
				CAL_CARG_REVERSIBLE, CAL_CARG_REV_CERP,   CAL_CARG_ADR_COM_LUMP,
				CAL_CARG_REV_FREIGHT, CAL_CARG_ADD_DAYS_TYPE, CAL_CARG_LOAD_DISCH_TYPE,    
				CAL_CARG_IDLE_DAYS,  CAL_CARG_BUNKERING_DAYS, CAL_CARG_ADD_DAYS_LADEN_PCNT,   
				CAL_CARG_ADD_DAYS_BALLAST_PCNT,  CAL_CARG_ADD_DAYS_VARIO_PCNT,  
				CAL_CARG_TOTAL_GROSS_FREIGHT, CAL_CARG_TOTAL_DEMURRAGE, CAL_CARG_TOTAL_DESPATCH,    
				CAL_CARG_TOTAL_COMMISSION, CAL_CARG_LOCAL_FLATRATE, CAL_CARG_MISC_INCOME,    
				CAL_CARG_ADD_DAYS_LADEN_SPD, CAL_CARG_ADD_DAYS_BALLAST_SPD, BUNKER_ESCALATION      
	 				FROM CAL_CARG
				WHERE CAL_CARG_ID = :istr_parm.l_cargo; 
				
				If SQLCA.SQLCode = 0 Then
					// It worked, now get the cargo ID of the cargo that we just created
					SELECT MAX(CAL_CARG_ID)
					INTO :ll_max
					FROM CAL_CARG;
				else
					MessageBox("Error", "Error" + SQLCA.sqlerrtext)
					rollback;
					return
				End if
					// Copy all additonal lumpsums from the old cargo to the new one, only changing the
					// link ID (CAL_CARG_ID)
					INSERT CAL_LUMP				
					SELECT:ll_max as CAL_CARG_ID,  
								CAL_LUMP_ADD_LUMPSUM, 
								CAL_LUMP_ADR_COMM,   
								CAL_LUMP_BRO_COMM,
								CAL_LUMP_COMMENT,
								CAL_LUMP_ORDER
					FROM CAL_LUMP 
					WHERE CAL_CARG_ID = :istr_parm.l_cargo;
					
					If SQLCA.SQLCode <> 0 Then
						MessageBox("Error", "Error" + SQLCA.sqlerrtext)
						rollback;
						return
					End if
				
					// Copy all ports from the old cargo to the new one, only changing the
					// link ID (CAL_CARG_ID)
					
					INSERT CAL_CAIO					
  				 	SELECT:ll_max as  
					CAL_CARG_ID, CAL_RATY_ID,   CAL_CAIO_RATE_ESTIMATED, 
					CAL_CAIO_RATE_CALCULATED,   CAL_CAIO_NOTICETIME,CAL_CAIO_DESPATCH,    
					CAL_CAIO_DEMURRAGE,   CAL_CAIO_DAYS_CALCULATED, CAL_CAIO_TOTAL_PORT_EXPENSES,       
					CAL_CAIO_EXPENSES, CAL_CAIO_MISC_EXPENSES, CAL_CAIO_LOAD_UNIT_EXPENSES,     
					CAL_CAIO_NUMBER_OF_UNITS,CAL_CAIO_ITINERARY_NUMBER,  CAL_CAIO_DISTANCE_TO_PREVIOUS,     
					CAL_CAIO_DAYS_AT_SEA,  CAL_CAIO_DAYS_AT_CANAL, CAL_CAIO_MISC_EXPENSES_2,      
					CAL_CAIO_VIA_POINT_1, CAL_CAIO_VIA_EXPENSES_1,  CAL_CAIO_VIA_POINT_2,      
					CAL_CAIO_VIA_EXPENSES_2,   CAL_CAIO_VIA_POINT_3,  CAL_CAIO_VIA_EXPENSES_3,     
					PORT_CODE, CAL_CAIO_ARRIVAL, CAL_CAIO_GEAR,       
					CAL_CAIO_LEG_SPEED, CAL_CAIO_LOAD_TERMS,  PURPOSE_CODE,   
					CAL_CAIO_PURPOSE_CODE  
				 FROM CAL_CAIO 
					WHERE CAL_CARG_ID = :istr_parm.l_cargo;
					
				If SQLCA.SQLCode <> 0 Then
					MessageBox("Error", "Error" + SQLCA.sqlerrtext)
					rollback;
					return
				End if
				
				//commit;
					
				// If it went ok then close and return 1 (data changed)
				If f_sql_check("copying") Then CloseWithReturn(Parent,1)
				
			CASE 2
				// Move Cargo from calculation given in L_FROM_CALC to LL_TO_CALC. 
				// If this is the only cargo on that calculation, then notice the user
				// that the calculation will be deleted after moving

				// Get the number of cargoes on that calculation
				SELECT COUNT(*)
				INTO :ll_count
				FROM CAL_CARG
				WHERE CAL_CALC_ID = :istr_parm.l_from_calc;
				COMMIT;
			
				// Show warning notice if only 1, and exit if the user selectes no.
				If ll_count = 1 Then
					If MessageBox("Warning", "This is the only cargo on calculation ~""+ls_from+"~", moving this cargo will delete the calculation.~r~n~r~nContinue ?", &
							Exclamation!, YesNo!, 1) = 2 Then Return
				End if					
			
				
				// Change the link-ID (CAL_CALC_ID) on the cargo that we're to move
				UPDATE CAL_CARG
				SET CAL_CALC_ID = :ll_to_calc
				WHERE (CAL_CALC_ID = :istr_parm.l_from_calc) AND
					(CAL_CARG_ID = :istr_parm.l_cargo);
			
					// Try deleting the calculation (if there's more cargoes will
					// get an error but nothing will happen).
				
					DELETE CAL_CALC
					WHERE CAL_CALC_ID = :istr_parm.l_from_calc;
				
					If f_sql_check("moving") Then CloseWithReturn(Parent,1)
					
					Return
			
		END CHOOSE
	End if	
End if
end event

type cb_cancel from uo_cb_base within w_calc_copy_move
integer x = 2885
integer y = 1152
integer taborder = 20
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the copy/move window

 Arguments : None

 Returns   : None 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type st_text from statictext within w_calc_copy_move
integer x = 55
integer y = 48
integer width = 2560
integer height = 48
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "none"
boolean focusrectangle = false
end type

type gb_1 from uo_gb_base within w_calc_copy_move
integer x = 18
integer width = 3145
integer height = 1292
integer taborder = 10
long backcolor = 81324524
string text = ""
end type

