$PBExportHeader$n_rowselection.sru
$PBExportComments$PFC DataWindow Row Selection service
forward
global type n_rowselection from nonvisualobject
end type
end forward

global type n_rowselection from nonvisualobject
event type integer ue_clicked ( integer ai_xpos,  integer ai_ypos,  long al_row,  ref dwobject adwo_obj )
event ue_lbuttondown ( unsignedlong aul_flags,  integer ai_xpos,  integer ai_ypos )
event ue_lbuttonup ( unsignedlong aul_flags,  integer ai_xpos,  integer ai_ypos )
event ue_rbuttonup ( integer ai_xpos,  integer ai_ypos,  long al_row,  dwobject adwo_obj )
event ue_rbuttondown ( integer ai_xpos,  integer ai_ypos,  long al_row,  dwobject dwo_obj )
event type integer ue_rowfocuschanged ( long al_row )
end type
global n_rowselection n_rowselection

type variables
Public:
//Style constants:
constant integer SINGLE =0
constant integer MULTIPLE =1
constant integer EXTENDED =2

Protected:
// Service Behavior.
integer	ii_style=0

// Service Requestor
DataWindow idw_requestor

// Previous row and keys attributes.
long	il_prevclickedrow =0  	// Previous clickedrow.
long	il_currclickedrow =0	// Currently clickedrow.
long	il_prevrow=0	// Used to determine row deletions.
long	il_prevrowcount=0	// Used to determine row deletions.
boolean	ib_prevcntrl =False	// State of the CNTRL key at the time il_prevclickedrow was captured. 
boolean	ib_prevshift =False	// State of the SHIFT key at the time il_prevclickedrow was captured. 

// Keyboard (rowfocuschanged) support
boolean	ib_keyboard=True	// Should keyboard support be active.

// Current Anchor row.
long	il_anchorrow=0		

// Is the Left Button currently pressed?
boolean	ib_lbuttonpressed=False	

// Is the Right Button currently pressed?
boolean	ib_rbuttonpressed=False	

end variables

forward prototypes
public function long of_selectedcount (ref long al_selectedrows[])
public function integer of_invertselection ()
protected function integer of_rowselectsingle (long al_row)
protected function integer of_rowselectmulti (long al_row)
protected function integer of_rowselectext (long al_row, boolean ab_cntrlpressed, boolean ab_shiftpressed)
protected function integer of_buttonup ()
public function integer of_setstyle (integer ai_style)
public function integer of_getstyle ()
public function integer of_rowselect (long al_row)
protected function integer of_keybrowselectext (long al_row, boolean ab_cntrlpressed, boolean ab_shiftpressed)
protected function integer of_keybrowselect (long al_row)
public function integer of_setkeyboard (boolean ab_switch)
public function boolean of_iskeyboard ()
public function integer of_setrequestor (datawindow adw_requestor)
end prototypes

event type integer ue_clicked(integer ai_xpos, integer ai_ypos, long al_row, ref dwobject adwo_obj);// Make sure request is valid.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then Return -1
If IsNull(adwo_obj) Then Return -1
If IsNull(al_row) or al_row <=0 Then Return -1

// Keep track of the currently clicked row.
il_currclickedrow = al_row

// Process clicked behavior depending on selection option
Return of_RowSelect(al_row)

end event

event ue_lbuttondown(unsignedlong aul_flags, integer ai_xpos, integer ai_ypos);//Store in service that the Left Button is Pressed.
ib_lbuttonpressed = TRUE

// Clear other button.
ib_rbuttonpressed = FALSE
end event

event ue_lbuttonup(unsignedlong aul_flags, integer ai_xpos, integer ai_ypos);// Store in service that the Left Button is no longer Pressed.
ib_lbuttonpressed = FALSE

// Clear other button.
ib_rbuttonpressed = FALSE

// Perform the Button Up processing.
of_ButtonUp()
end event

event ue_rbuttonup(integer ai_xpos, integer ai_ypos, long al_row, dwobject adwo_obj);// Store in service that the Button is no longer Pressed.
ib_rbuttonpressed = FALSE

// Clear other button.
ib_lbuttonpressed = FALSE

// Perform the Button Up processing.
of_ButtonUp()

end event

event ue_rbuttondown(integer ai_xpos, integer ai_ypos, long al_row, dwobject dwo_obj);//Store in service that the Button is Pressed.
ib_rbuttonpressed = TRUE

// Clear other button.
ib_lbuttonpressed = FALSE

// Make sure request is valid.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then Return
If IsNull(al_row) or al_row <=0 Then Return

// Keep track of the currently clicked row.
il_currclickedrow = al_row

// Process behavior depending on selection option
of_RowSelect(al_row)

end event

event type integer ue_rowfocuschanged(long al_row);Integer	li_rc=1
boolean	lb_rowdeletion=False
boolean	lb_rowclicked=False

// Validate required reference.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then
	Return -1
End If

// Only perform when the keyboard support is active.
If ib_keyboard Then
	// Determine if this rowchange was caused by a RowDeletion operation.
	// (Note: al_row=1 is needed for dwSharing.)
	lb_rowdeletion = ((al_row = il_prevrow -1 Or al_row=1) And &
							idw_requestor.RowCount() = il_prevrowcount -1)

	// Determine if this rowchange was caused by a Clicked operation.
	lb_rowclicked = (il_currclickedrow = al_row)

	// Process row when not a rowdeletion or rowclicked operation.
	If (Not lb_rowdeletion) And (Not lb_rowclicked) Then
		// Process keyboard behavior depending on selection option
		li_rc = of_KeybRowSelect(al_row)
	End If
End If

// Reset the currently Clicked row.
il_currclickedrow = 0

// Keep track of the previous row and previous rowcount to catch for 
// RowDeletion operations.
il_prevrow = al_row
il_prevrowcount = idw_requestor.RowCount()

Return li_rc

end event

public function long of_selectedcount (ref long al_selectedrows[]);long	ll_selected=0
long	ll_counter=0

//Check for any requirements.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then Return -1

//Loop and count the number of selected rows.
DO
	ll_selected = idw_requestor.GetSelectedRow ( ll_selected )
	IF ll_selected > 0 THEN
		ll_counter++
		al_selectedrows[ll_counter] = ll_selected
	END IF
LOOP WHILE ll_selected > 0

Return ll_counter

end function

public function integer of_invertselection ();long	ll_max
long	ll_i

// Validate the datawindow reference.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then Return -1

// Get the row count.
ll_max = idw_requestor.RowCount ( ) 

// Prevent flickering and improve performance.
idw_requestor.SetReDraw ( FALSE ) 

// Invert row by row.
FOR ll_i = 1 to ll_max
	idw_requestor.SelectRow ( ll_i, NOT (idw_requestor.IsSelected(ll_i)) ) 
NEXT 

// Prevent flickering and improve performance.
idw_requestor.SetReDraw ( TRUE ) 

Return 1


end function

protected function integer of_rowselectsingle (long al_row);// Check arguments.
If IsNull(al_row) or al_row <0 Then
	Return -1
End If

// Deselect all rows.
idw_Requestor.SelectRow ( 0, FALSE ) 

// Select the one row.
idw_Requestor.SelectRow ( al_row, TRUE ) 

// Set the one row as the current row.
If idw_Requestor.GetRow() <> al_row Then
	idw_Requestor.SetRow ( al_row ) 
End If

Return 1



end function

protected function integer of_rowselectmulti (long al_row);// Check arguments.
If IsNull(al_row) or al_row <0 Then
	Return -1
End If

// Select or Deselect the row.
idw_Requestor.SelectRow ( al_row,  NOT (idw_Requestor.IsSelected(al_row)) ) 

// Make the row the current row.
If idw_Requestor.GetRow() <> al_row Then
	idw_Requestor.SetRow ( al_row ) 
End If

Return 1


end function

protected function integer of_rowselectext (long al_row, boolean ab_cntrlpressed, boolean ab_shiftpressed);integer	li_i
boolean	lb_waitforbuttonup=False
boolean	lb_takenoaction=False

// Check arguments.
If IsNull(al_row) or al_row <0 Then
	Return -1
End If

// @@
// n_cst_conversion lc
// gnv_app.inv_debug.of_Message(	'Row='+string(al_row)+ &
//										'* Ctrl='+lc.of_String(ab_cntrlpressed) + &
//										'* Shift='+lc.of_String(ab_shiftpressed) + &
//										'* lbutton = '+lc.of_String(ib_lbuttonpressed)+ &
//										'* rbutton = '+lc.of_String(ib_rbuttonpressed))

//////////////////////////////////////////////////////////////////////////////
// On the first part of the 'IF' statement:
// 	If the LEFTBUTTON is pressed, the CNTRL key down, and the SHIFT is up - Then
//		according to Win95 the processing will be performed (by this same function)
//		when the Button is released.	
//	On the second part of the 'IF' statement:
// 	If the BUTTON is pressed, the CNTRL key down, and the SHIFT is up - Then
//		according to Win95 the processing will be performed (by this same function)
//		when the Button is released.	
//////////////////////////////////////////////////////////////////////////////
If ((ib_lbuttonpressed or ib_rbuttonpressed) And ab_cntrlpressed And ab_shiftpressed=False) Or &
	(idw_requestor.IsSelected(al_row) And ib_lbuttonpressed And &
	ab_cntrlpressed=False And ab_shiftpressed=False)  Then
	// Wait for the button up to process click.
	lb_waitforbuttonup = True
ElseIf idw_requestor.IsSelected(al_row) And ib_rbuttonpressed And &
	ab_cntrlpressed=False And ab_shiftpressed=False  Then
	// Right Clicking on an already Highlighted row requires a No Action process.
	lb_takenoaction = True
End If

If lb_waitforbuttonup Then
	// Handle processing when the Button is released.
	il_prevclickedrow  = al_row
	ib_prevcntrl = ab_cntrlpressed
	ib_prevshift = ab_shiftpressed
	// gnv_app.inv_debug.of_Message(	'Wait for button up process.')	
	Return 1
End If

// There is no Previous row information.
il_prevclickedrow  = 0
ib_prevcntrl = False
ib_prevshift = False

If lb_takenoaction Then
	// Take the No Action Process.
	// @@
	// gnv_app.inv_debug.of_Message(	'No Action process.')
	Return 1
End If

//////////////////////////////////////////////////////////////////////////////
// Perform now.  This is either:
//		1) Processing that does not wait for the Left Button to be released.
//		or
//		2) Processing which waited for the Left Button to be released.
//			The lbuttonup event then called this function with the following
//			variables: (il_prevclickedrow, il_prevcntrl, il_prevshift)
//////////////////////////////////////////////////////////////////////////////

If ab_cntrlpressed And ab_shiftpressed=False Then
	// Select or De-Select (as appropriate) the current row.
	idw_requestor.SelectRow ( al_row, Not idw_requestor.IsSelected(al_row) ) 

	// Store new Anchor Row.
	il_anchorrow = al_row

ElseIf ab_cntrlpressed Or ab_shiftpressed Then

	/* Note: The valid combinations here are:											*/
	/*					ab_cntrlpressed=True  and ab_shiftpressed=True				*/
	/*					ab_cntrlpressed=False and ab_shiftpressed=True				*/
	/*					ab_cntrlpressed=True  and ab_shiftpressed=False	+++++++	*/	
	/*		+++++++ Because of the "If" prior to this "ElseIf", it is 			*/
	/* 	impossible for ab_cntrlpressed=True and ab_shiftpressed=False.		*/
	
	If ab_cntrlpressed=False Then
		//Clear all previously selected rows.	
		idw_requestor.SelectRow (0, false)	
	End If
	
	// If there is no anchor row, then only select the row that was clicked.
	If il_anchorrow	= 0 Then
		idw_requestor.SelectRow ( al_row, TRUE )
	Else
		// Prevent flickering.  Improve performance.
		idw_requestor.SetReDraw ( FALSE ) 

		// Select all rows in between anchor row and current row */
		If il_anchorrow > al_row Then
			FOR li_i = il_anchorrow to al_row STEP -1
				idw_requestor.SelectRow ( li_i, TRUE )	
			NEXT
		Else
			FOR li_i = il_anchorrow to al_row
				idw_requestor.SelectRow ( li_i, TRUE )	
			NEXT 
		END If 

		// Prevent flickering.  Improve performance.
		idw_requestor.SetReDraw ( TRUE ) 
	END If
	
Else
	// Unselect all previous rows (if any) and select the current row.
	of_RowSelectSingle (al_row)

	// Store new Anchor Row.
	il_anchorrow = al_row
	
End If
	
// Make the row the current row.
If idw_Requestor.GetRow() <> al_row Then
	idw_Requestor.SetRow ( al_row ) 
End If	
		
Return 1
end function

protected function integer of_buttonup ();integer li_rc = 1

// Make sure request is valid.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then Return -1

// Process clicked behavior depending on selection option
CHOOSE CASE ii_style
	CASE SINGLE 
		// No Action.

	CASE MULTIPLE 
		// No Action

	CASE EXTENDED 
		// Win 95 style of processing Control-clicks on Extended Selections.
		If il_prevclickedrow > 0 Then
			li_rc = of_RowSelectExt ( il_prevclickedrow ,ib_prevcntrl, ib_prevshift)
		End If		
END CHOOSE

// There is no Previous row information.
il_prevclickedrow  = 0
ib_prevcntrl = False
ib_prevshift = False

Return li_rc
end function

public function integer of_setstyle (integer ai_style);//Check arguments
IF IsNull(ai_style) THEN
	Return -1
END IF

CHOOSE CASE ai_style
	CASE SINGLE, MULTIPLE, EXTENDED
		ii_style = ai_style
		Return 1
END CHOOSE

Return -1 

end function

public function integer of_getstyle ();Return ii_style
end function

public function integer of_rowselect (long al_row);integer	li_rc=-1

CHOOSE CASE ii_style
	CASE SINGLE 
		li_rc = of_RowSelectSingle ( al_row )

	CASE MULTIPLE 
		li_rc = of_RowSelectMulti ( al_row ) 

	CASE EXTENDED 
		li_rc = of_RowSelectExt (al_row, KeyDown(KeyControl!), Keydown(KeyShift!)) 
END CHOOSE
	
Return li_rc
end function

protected function integer of_keybrowselectext (long al_row, boolean ab_cntrlpressed, boolean ab_shiftpressed);integer	li_i

// Check arguments.
If IsNull(al_row) or al_row <=0 Then
	Return -1
End If

// There is no Previous row information.
il_prevclickedrow  = 0
ib_prevcntrl = False
ib_prevshift = False

If ab_shiftpressed Then

	//Clear all previously selected rows.	
	idw_requestor.SelectRow (0, false)	
	
	// If there is no anchor row, then only select the row that was clicked.
	If il_anchorrow	= 0 Then
		idw_requestor.SelectRow ( al_row, TRUE )
	Else
		// Prevent flickering.  Improve performance.
		idw_requestor.SetReDraw ( FALSE ) 

		// Select all rows in between anchor row and current row */
		If il_anchorrow > al_row Then
			FOR li_i = il_anchorrow to al_row STEP -1
				idw_requestor.SelectRow ( li_i, TRUE )	
			NEXT
		Else
			FOR li_i = il_anchorrow to al_row
				idw_requestor.SelectRow ( li_i, TRUE )	
			NEXT 
		END If 

		// Prevent flickering.  Improve performance. ?
		idw_requestor.SetReDraw ( TRUE ) 
	END If

ElseIf ab_cntrlpressed Then
	// No action desired. Just let RowFocusIndicator show current row.
	
Else
	// Unselect all previous rows (if any) and select the current row.
	of_RowSelectSingle (al_row)

	// Store new Anchor Row.
	il_anchorrow = al_row
	
End If
	
// Make the row the current row.
If idw_Requestor.GetRow() <> al_row Then
	idw_Requestor.SetRow ( al_row ) 
End If	
		
Return 1
end function

protected function integer of_keybrowselect (long al_row);integer	li_rc=-1

CHOOSE CASE ii_style
	CASE SINGLE 
		li_rc = of_RowSelectSingle ( al_row )

	CASE MULTIPLE 
		// No Action.

	CASE EXTENDED 
		li_rc = of_KeyBRowSelectExt (al_row, Keydown(KeyControl!), Keydown(KeyShift!)) 
END CHOOSE
	
Return li_rc
end function

public function integer of_setkeyboard (boolean ab_switch);//Check arguments
IF IsNull(ab_switch) THEN
	Return -1
END IF

ib_keyboard = ab_switch
Return 1 

end function

public function boolean of_iskeyboard ();Return ib_keyboard

end function

public function integer of_setrequestor (datawindow adw_requestor);// Check arguments
if IsNull(adw_requestor) or not IsValid(adw_requestor) then
	return -1
end if

idw_requestor = adw_requestor
return 1

end function

on n_rowselection.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_rowselection.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

