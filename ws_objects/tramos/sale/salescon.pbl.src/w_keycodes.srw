$PBExportHeader$w_keycodes.srw
$PBExportComments$Maintain Keycodes.
forward
global type w_keycodes from w_sale_base
end type
type rb_keycode from radiobutton within w_keycodes
end type
type rb_description from radiobutton within w_keycodes
end type
type cb_new_keycode from commandbutton within w_keycodes
end type
type cb_delete_keycode from commandbutton within w_keycodes
end type
type cb_modify_charterers_list from commandbutton within w_keycodes
end type
type cb_modify_targets_list from commandbutton within w_keycodes
end type
type cb_modify_actions_list from commandbutton within w_keycodes
end type
type cb_refresh from commandbutton within w_keycodes
end type
type cb_update from commandbutton within w_keycodes
end type
type cb_close from commandbutton within w_keycodes
end type
type sle_find from singlelineedit within w_keycodes
end type
type st_1 from statictext within w_keycodes
end type
type st_2 from statictext within w_keycodes
end type
type dw_charterers from u_datawindow_sqlca within w_keycodes
end type
type st_3 from statictext within w_keycodes
end type
type dw_targets from u_datawindow_sqlca within w_keycodes
end type
type st_4 from statictext within w_keycodes
end type
type dw_actions from u_datawindow_sqlca within w_keycodes
end type
type gb_2 from groupbox within w_keycodes
end type
type gb_1 from groupbox within w_keycodes
end type
type dw_keycodes from u_datawindow_sqlca within w_keycodes
end type
end forward

global type w_keycodes from w_sale_base
int X=394
int Y=161
int Width=2135
int Height=1625
boolean TitleBar=true
string Title="Key Codes"
boolean MaxBox=false
boolean Resizable=false
rb_keycode rb_keycode
rb_description rb_description
cb_new_keycode cb_new_keycode
cb_delete_keycode cb_delete_keycode
cb_modify_charterers_list cb_modify_charterers_list
cb_modify_targets_list cb_modify_targets_list
cb_modify_actions_list cb_modify_actions_list
cb_refresh cb_refresh
cb_update cb_update
cb_close cb_close
sle_find sle_find
st_1 st_1
st_2 st_2
dw_charterers dw_charterers
st_3 st_3
dw_targets dw_targets
st_4 st_4
dw_actions dw_actions
gb_2 gb_2
gb_1 gb_1
dw_keycodes dw_keycodes
end type
global w_keycodes w_keycodes

type variables
String is_filter = "",is_current_column = "ccs_keyc_code"
Long il_selectedrow
end variables

forward prototypes
public function integer wf_save ()
public subroutine wf_enable_disable_buttons ()
public subroutine wf_select_column (string as_column_name)
end prototypes

public function integer wf_save ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : wf_save
  
 Event	 :

 Scope     :Public

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 16-08-96

 Description : Checks all required fields before updating a contact person. 		 

 Arguments : {description/none}

 Returns   : Integer 0 if update did not occure and 1 if OK

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0 			KHK		Initial version
  
************************************************************************************/
Long ll_allrows, ll_row
Integer li_rtn

li_rtn = 1

/* Check all fields are entered in keycode */

dw_keycodes.AcceptText()
ll_allrows = dw_keycodes.Rowcount()
IF ll_allrows > 0 THEN
	FOR ll_row = 1 TO ll_allrows
		IF IsNull(dw_keycodes.GetItemString(ll_row,"ccs_keyc_code")) THEN
			MessageBox("Update Error","Please enter Keycode in row "+String(ll_row),Stopsign!)
			dw_keycodes.ScrollToRow(ll_row)
			dw_keycodes.SetColumn("ccs_keyc_code")
			dw_keycodes.SetFocus()
			Return 0
		END IF
		IF IsNull(dw_keycodes.GetItemString(ll_row,"ccs_keyc_desc")) THEN
			MessageBox("Update Error","Please enter Keycode Description in row "+String(ll_row),Stopsign!)
			dw_keycodes.ScrollToRow(ll_row)
			dw_keycodes.SetColumn("ccs_keyc_desc")
			dw_keycodes.SetFocus()
		Return 0
		END IF
	NEXT	
END IF

IF li_rtn = 1 THEN
	f_update(dw_keycodes,w_tramos_main)
	Return 1
ELSE
	MessageBox("Update Error","Couldn't update Keycode. Please check and try again.",StopSign!)
	Return 0
END IF

return 0

end function

public subroutine wf_enable_disable_buttons ();IF dw_keycodes.GetRow() < 1  THEN
	cb_delete_keycode.enabled = FALSE
	cb_modify_charterers_list.enabled = FALSE
	cb_modify_targets_list.enabled = FALSE
	cb_modify_actions_list.enabled = FALSE
ELSEIF  IsNull(dw_keycodes.GetItemNumber(dw_keycodes.GetRow(),"ccs_keyc_pk")) THEN 
	cb_delete_keycode.enabled = FALSE
	cb_modify_charterers_list.enabled = FALSE
	cb_modify_targets_list.enabled = FALSE
	cb_modify_actions_list.enabled = FALSE
ELSE
	cb_delete_keycode.enabled = TRUE
	cb_modify_charterers_list.enabled = TRUE
	cb_modify_targets_list.enabled = TRUE
	cb_modify_actions_list.enabled = TRUE
END IF

end subroutine

public subroutine wf_select_column (string as_column_name);is_current_column = as_column_name
dw_keycodes.SelectRow(0,False)
dw_keycodes.SetSort(is_current_column+" A")
dw_keycodes.Sort()
dw_keycodes.SelectRow(1,TRUE)

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

end subroutine

on open;call w_sale_base::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : 
  
 Event	 :Open! 

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 16-08-96

 Description : Create, modify or delete keycodes

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables :{description/none}  

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0 			KHK		Initial version
  
************************************************************************************/

LONG 	ll_cur_row

//////////////////////// Retrieve existing Keycodes
dw_keycodes.Retrieve()
COMMIT USING SQLCA;
ll_cur_row = dw_keycodes.GetRow()

//////////////////////// If any existing Keycodes, the update related datawindow
IF ll_cur_row > 0 THEN
	dw_charterers.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
	COMMIT USING SQLCA;
	dw_targets.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
	COMMIT USING SQLCA;
	dw_actions.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
	COMMIT USING SQLCA;
END IF

//////////////////////// Enable/disable buttons according to data in the window
wf_enable_disable_buttons()

sle_find.SetFocus()

end on

on w_keycodes.create
int iCurrent
call w_sale_base::create
this.rb_keycode=create rb_keycode
this.rb_description=create rb_description
this.cb_new_keycode=create cb_new_keycode
this.cb_delete_keycode=create cb_delete_keycode
this.cb_modify_charterers_list=create cb_modify_charterers_list
this.cb_modify_targets_list=create cb_modify_targets_list
this.cb_modify_actions_list=create cb_modify_actions_list
this.cb_refresh=create cb_refresh
this.cb_update=create cb_update
this.cb_close=create cb_close
this.sle_find=create sle_find
this.st_1=create st_1
this.st_2=create st_2
this.dw_charterers=create dw_charterers
this.st_3=create st_3
this.dw_targets=create dw_targets
this.st_4=create st_4
this.dw_actions=create dw_actions
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_keycodes=create dw_keycodes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=rb_keycode
this.Control[iCurrent+2]=rb_description
this.Control[iCurrent+3]=cb_new_keycode
this.Control[iCurrent+4]=cb_delete_keycode
this.Control[iCurrent+5]=cb_modify_charterers_list
this.Control[iCurrent+6]=cb_modify_targets_list
this.Control[iCurrent+7]=cb_modify_actions_list
this.Control[iCurrent+8]=cb_refresh
this.Control[iCurrent+9]=cb_update
this.Control[iCurrent+10]=cb_close
this.Control[iCurrent+11]=sle_find
this.Control[iCurrent+12]=st_1
this.Control[iCurrent+13]=st_2
this.Control[iCurrent+14]=dw_charterers
this.Control[iCurrent+15]=st_3
this.Control[iCurrent+16]=dw_targets
this.Control[iCurrent+17]=st_4
this.Control[iCurrent+18]=dw_actions
this.Control[iCurrent+19]=gb_2
this.Control[iCurrent+20]=gb_1
this.Control[iCurrent+21]=dw_keycodes
end on

on w_keycodes.destroy
call w_sale_base::destroy
destroy(this.rb_keycode)
destroy(this.rb_description)
destroy(this.cb_new_keycode)
destroy(this.cb_delete_keycode)
destroy(this.cb_modify_charterers_list)
destroy(this.cb_modify_targets_list)
destroy(this.cb_modify_actions_list)
destroy(this.cb_refresh)
destroy(this.cb_update)
destroy(this.cb_close)
destroy(this.sle_find)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_charterers)
destroy(this.st_3)
destroy(this.dw_targets)
destroy(this.st_4)
destroy(this.dw_actions)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_keycodes)
end on

type rb_keycode from radiobutton within w_keycodes
int X=1701
int Y=81
int Width=311
int Height=65
int TabOrder=40
string Text="Key Code"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;wf_select_column("ccs_keyc_code")

end on

type rb_description from radiobutton within w_keycodes
int X=1701
int Y=145
int Width=348
int Height=65
int TabOrder=50
string Text="Description"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;wf_select_column("ccs_keyc_desc")
end on

type cb_new_keycode from commandbutton within w_keycodes
int X=1738
int Y=273
int Width=293
int Height=81
int TabOrder=80
string Text="New"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : cb_new_keycode
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 16-08-96

 Description : Insert new row in keycodes list to create new keycode

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0 			KHK		Initial version
  
************************************************************************************/

Long ll_newrow

//////////////////////// Insert new row in buttom of list, and scroll to this
ll_newrow = dw_keycodes.InsertRow(0)
dw_keycodes.ScrollToRow(ll_newrow)
dw_keycodes.SetColumn("ccs_keyc_code")
dw_keycodes.SetFocus()

//////////////////////// Enable/disable buttons according to data in the window
wf_enable_disable_buttons()


end on

type cb_delete_keycode from commandbutton within w_keycodes
int X=1738
int Y=369
int Width=293
int Height=81
int TabOrder=90
string Text="Delete"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : cb_delete_keycode
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 16-08-96

 Description : Delete a row in keycodes list

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0 			KHK		Initial version
  
************************************************************************************/

Long ll_row

ll_row = dw_keycodes.GetRow()

//////////////////////// Retrieve related data before checking if it is allowed to delete the current row
dw_charterers.Retrieve(dw_keycodes.GetItemNumber(ll_row,"ccs_keyc_pk"))
dw_targets.Retrieve(dw_keycodes.GetItemNumber(ll_row,"ccs_keyc_pk"))
dw_actions.Retrieve(dw_keycodes.GetItemNumber(ll_row,"ccs_keyc_pk"))

//////////////////////// Check for related data - if there is, deletion is not allowed
IF (dw_charterers.RowCount() + dw_targets.RowCount() + dw_actions.RowCount()) > 0 THEN
	MessageBox("Stop","You can't delete a Keycode with relations to Charterers, Targets or Actions",StopSign!)
ELSEIF MessageBox("Warning","You are about to delete a keycode. Continue?",Question!,YesNo!,2) = 1 THEN
	// Proceed Yes
	dw_keycodes.DeleteRow(ll_row)
	IF dw_keycodes.Rowcount() < 1 THEN 	This.Enabled = FALSE
ELSE
	dw_keycodes.SetFocus()
END IF

//////////////////////// Enable/disable buttons according to data in the window
wf_enable_disable_buttons()

end on

type cb_modify_charterers_list from commandbutton within w_keycodes
int X=1738
int Y=673
int Width=293
int Height=81
int TabOrder=110
string Text="Modify List"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : cb_modify_charterers_list
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek

 Date       : 16-08-96

 Description : Activate the userobject holding charterers related to the actual keycode

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0	 		KHK		Initial version
05-09-96					JH		Changed dimm buttons while  responce window is open    
************************************************************************************/

LONG	ll_cur_row

//////////////////////////////// Call the UserObject "w_chart_keyc_select" with the actual Keycode as parameter
ll_cur_row = dw_keycodes.GetRow()

/* Disable buttons in buttom of window*/
cb_close.Enabled = FALSE
cb_refresh.Enabled = FALSE
cb_update.Enabled = FALSE

IF OpenWithParm(w_chart_keyc_select,dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk")) = 1THEN	
	cb_close.Enabled = TRUE
	cb_refresh.Enabled = TRUE
	cb_update.Enabled = TRUE
	dw_charterers.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
END IF



end on

type cb_modify_targets_list from commandbutton within w_keycodes
int X=1738
int Y=929
int Width=293
int Height=81
int TabOrder=120
string Text="Modify List"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : cb_modify_charterers_list
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek

 Date       : 16-08-96

 Description : Activate the userobject holding targets related to the actual keycode

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0	 		KHK		Initial version
05-09-96					JH		Changed dimm buttons while  responce window is open
  
************************************************************************************/

LONG	ll_cur_row

//////////////////////////////// Call the UserObject "w_chart_target_select" with the actual Keycode as parameter
ll_cur_row = dw_keycodes.GetRow()

/* Disable buttons in buttom of window*/
cb_close.Enabled = FALSE
cb_refresh.Enabled = FALSE
cb_update.Enabled = FALSE

IF OpenWithParm(w_target_keyc_select,dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk")) = 1THEN
	
	cb_close.Enabled = TRUE
	cb_refresh.Enabled = TRUE
	cb_update.Enabled = TRUE
	dw_targets.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
END IF


end on

type cb_modify_actions_list from commandbutton within w_keycodes
int X=1738
int Y=1185
int Width=293
int Height=81
int TabOrder=130
string Text="Modify List"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : cb_modify_actions_list
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek

 Date       : 16-08-96

 Description : Activate the userobject holding actions related to the actual keycode

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0	 		KHK		Initial version
05-09-96					JH		Changed dimm buttons while  responce window is open
  
************************************************************************************/

LONG	ll_cur_row

//////////////////////////////// Call the UserObject "w_action_keyc_select" with the actual Keycode as parameter
ll_cur_row = dw_keycodes.GetRow()

/* Disable buttons in buttom of window*/
cb_close.Enabled = FALSE
cb_refresh.Enabled = FALSE
cb_update.Enabled = FALSE

IF OpenWithParm(w_action_keyc_select,dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk")) = 1THEN
	
	cb_close.Enabled = TRUE
	cb_refresh.Enabled = TRUE
	cb_update.Enabled = TRUE
	dw_actions.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
END IF
end on

type cb_refresh from commandbutton within w_keycodes
int X=385
int Y=1425
int Width=385
int Height=81
int TabOrder=140
string Text="Refresh"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;////////////////////////// Refresh all datawindows as if the window was just opened
Parent.TriggerEvent(open!)

end on

type cb_update from commandbutton within w_keycodes
int X=860
int Y=1425
int Width=385
int Height=81
int TabOrder=150
string Text="&Update"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;////////////////////////////// Call the local save-function
wf_save()

//////////////////////// Enable/disable buttons according to data in the window
wf_enable_disable_buttons()


end on

type cb_close from commandbutton within w_keycodes
int X=1335
int Y=1425
int Width=385
int Height=81
int TabOrder=160
string Text="Close"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : cb_closed
  
 Event	 :Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 16-08-96

 Description : Close the window

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0 			KHK		Initial version
  
************************************************************************************/
Integer li_ans

/* test if any changes were made */
dw_keycodes.AcceptText()
IF (dw_keycodes.ModifiedCount() > 0) OR (dw_keycodes.DeletedCount() > 0) THEN
	li_ans = MessageBox("Warning","You have modified keycodes! Do you wish to update "&
						+"before closing?",Question!,YesNOCancel!)
ELSE
	li_ans = 0
END IF

IF li_ans = 1 THEN
	/* save changes before closing*/
	cb_update.TriggerEvent(Clicked!)
ELSEIF li_ans = 3 THEN
	/* Cancel close */
	Return
END IF

Close(Parent)

end on

type sle_find from singlelineedit within w_keycodes
event ue_keydown pbm_keydown
int X=257
int Y=17
int Width=823
int Height=81
int TabOrder=70
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on ue_keydown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_keycodes
  
 Object     : sle_find
  
 Event	 : ue_keydown

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 20-07-96

 Description :  Find matching string and posistion in datawindow.  

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Script copied from Martins code in w_keycodes key_pressed script for sle_find

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-96		1.0	 		JH		Initial version
  
************************************************************************************/

/* key pressed in datawindow
 capture up and down arrows to move the selection up and down*/

int li_movement 
long ll_row

If KeyDown (keyUparrow!) then
	li_movement = -1
End If


If KeyDown (keyDownarrow!) then
	li_movement = 1
End If

If li_movement <> 0 Then
	dw_keycodes.SetRedraw(False)
	ll_row = dw_keycodes.GetSelectedRow(0)
	ll_row = ll_row + li_movement
	If ll_row < 1 or ll_row > dw_keycodes.RowCount( ) Then 
		Beep(1)
		Return
	End If
	dw_keycodes.selectrow(0,False)
	dw_keycodes.SelectRow(ll_row , True)
	dw_keycodes.ScrollToRow (ll_row)

	IF dw_keycodes.Describe(is_current_column+".ColType") = "datetime"  THEN
		sle_find.text = String(dw_keycodes.GetItemDateTime(ll_row, is_current_column))	
	ELSE
		sle_find.text = dw_keycodes.GetItemString(ll_row, is_current_column)		
	END IF
	

	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_keycodes.SetRedraw(True)
	sle_find.SelectText(len(sle_find.text) + 1,0)
	message.processed = true
	Return
End If


/*Backspace*/ 

string	ls_character
long	ll_found_row
int		li_num_chars

ls_character = Char(message.wordparm)

If message.wordparm = 8   then
	li_num_chars = Len(is_filter)
	If li_num_chars > 0 then is_filter = Left(is_filter, li_num_chars -1)		
else
	is_filter = is_filter + ls_character
end if


/* Do case-insensitive search*/
String ls_tmp	
IF Len(is_filter) > 0 THEN
	IF dw_keycodes.Describe(is_current_column+".ColType") = "datetime"  THEN
		ls_tmp = "Left(String("+is_current_column+"), " + String(len(is_filter))+ " )='"+is_filter+"'"
//		MessageBox("info", ls_tmp)
		ll_found_row = dw_keycodes.Find(ls_tmp,1,99999)
	ELSE
		ll_found_row = dw_keycodes.Find(Lower(is_current_column) + ">='" + Lower(is_filter) + "'",1, 99999)
	END IF

	IF ll_found_row > 0 THEN 
		dw_keycodes.SetRedraw(FALSE)
		dw_keycodes.SelectRow(0, FALSE)
		dw_keycodes.ScrollToRow(ll_found_row)
		dw_keycodes.SelectRow(ll_found_row, TRUE)
		dw_keycodes.SetRedraw(TRUE)
	/* is_filterer function did not find any matching row*/
	ELSE
            Beep(1)
		li_num_chars = Len(is_filter)
		If li_num_chars > 0 Then is_filter = Left(is_filter, li_num_chars -1)		
	/* Throw away last character*/
		message.processed = true
	END IF
	/* is_filter er length is 0, so unhighlight former selected row*/
ELSE
	dw_keycodes.SelectRow(0, FALSE)
	ll_found_row = 0
END IF

/* Remember number of highlighted row*/
il_selectedrow = ll_found_row	

wf_enable_disable_buttons()		


end on

type st_1 from statictext within w_keycodes
int X=74
int Y=33
int Width=183
int Height=65
boolean Enabled=false
string Text="Find:"
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_keycodes
int X=92
int Y=609
int Width=257
int Height=65
boolean Enabled=false
string Text="Charterers:"
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_charterers from u_datawindow_sqlca within w_keycodes
int X=74
int Y=657
int Width=1555
int Height=193
int TabOrder=10
string DataObject="d_chart_list"
boolean VScrollBar=true
end type

type st_3 from statictext within w_keycodes
int X=92
int Y=865
int Width=238
int Height=65
boolean Enabled=false
string Text="Targets:"
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_targets from u_datawindow_sqlca within w_keycodes
int X=74
int Y=913
int Width=1555
int Height=193
int TabOrder=20
string DataObject="d_target_list"
boolean VScrollBar=true
end type

type st_4 from statictext within w_keycodes
int X=92
int Y=1121
int Width=238
int Height=65
boolean Enabled=false
string Text="Actions:"
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_actions from u_datawindow_sqlca within w_keycodes
int X=74
int Y=1169
int Width=1555
int Height=193
int TabOrder=30
string DataObject="d_actions_list"
boolean VScrollBar=true
end type

type gb_2 from groupbox within w_keycodes
int X=37
int Y=529
int Width=2049
int Height=865
int TabOrder=100
string Text="Key Code used by:"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_keycodes
int X=1665
int Y=33
int Width=421
int Height=193
string Text="Sort/Search"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_keycodes from u_datawindow_sqlca within w_keycodes
int X=37
int Y=129
int Width=1591
int Height=385
int TabOrder=60
string DataObject="d_keycode_list3"
boolean VScrollBar=true
end type

on itemchanged;call u_datawindow_sqlca::itemchanged;//////////////////////// Enable/disable buttons according to data in the window
wf_enable_disable_buttons()

end on

on rowfocuschanged;call u_datawindow_sqlca::rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : dw_keycodes
  
 Object     : 
  
 Event	 : rowfocuschanged

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 16-08-96

 Description : Updates related datawindows according to the actual Keycode

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-08-96		1.0 			KHK		Initial version
  
************************************************************************************/

LONG 	ll_cur_row

ll_cur_row = dw_keycodes.GetRow()

//////////////////////// If there are any actual Keycode, then update related datawindows
IF ll_cur_row > 0 THEN
	dw_charterers.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
	COMMIT USING SQLCA;
	dw_targets.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
	COMMIT USING SQLCA;
	dw_actions.Retrieve(dw_keycodes.GetItemNumber(ll_cur_row,"ccs_keyc_pk"))
	COMMIT USING SQLCA;
END IF

//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

//////////////////////// Enable/disable buttons according to data in the window
wf_enable_disable_buttons()

end on

on clicked;call u_datawindow_sqlca::clicked;//////////////////////// Highlight current row
This.SelectRow(0,FALSE)
il_selectedrow = This.GetRow()
This.SelectRow(il_selectedrow,TRUE)

end on

