$PBExportHeader$w_actionlist.srw
$PBExportComments$This window lets the user edit actions.
forward
global type w_actionlist from w_list
end type
type cbx_1 from uo_cbx_base within w_actionlist
end type
type dw_target from u_datawindow_sqlca within w_actionlist
end type
type gb_3 from uo_gb_base within w_actionlist
end type
type gb_2 from uo_gb_base within w_actionlist
end type
end forward

global type w_actionlist from w_list
int Height=1529
cbx_1 cbx_1
dw_target dw_target
gb_3 gb_3
gb_2 gb_2
end type
global w_actionlist w_actionlist

forward prototypes
public subroutine wf_buttons ()
public subroutine wf_select_column (integer columnno)
end prototypes

public subroutine wf_buttons ();
	cb_delete.enabled = dw_1.GetSelectedRow(0) > 0
	cb_modify.enabled = cb_delete.enabled

end subroutine

public subroutine wf_select_column (integer columnno);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_actionlist
  
 Object     : wf_select_column
  
 Event	 : 

 Scope     : public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description : Selects column for sort / search

 Arguments : Column no which is to be sorted

 Returns   :none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0	 		JH		Initial version
03-09-96					JH		Sort date descenting order
  
************************************************************************************/

ii_current_column = columnno
dw_1.SelectRow(0,False)

IF ii_current_column = 1 THEN
	dw_1.SetSort(string(istr_parametre.column[ii_current_column])+" D")
ELSE
	dw_1.SetSort(string(istr_parametre.column[ii_current_column])+" A")
END IF



dw_1.Sort()

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()

wf_updatebuttons()
end subroutine

on w_actionlist.create
int iCurrent
call w_list::create
this.cbx_1=create cbx_1
this.dw_target=create dw_target
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cbx_1
this.Control[iCurrent+2]=dw_target
this.Control[iCurrent+3]=gb_3
this.Control[iCurrent+4]=gb_2
end on

on w_actionlist.destroy
call w_list::destroy
destroy(this.cbx_1)
destroy(this.dw_target)
destroy(this.gb_3)
destroy(this.gb_2)
end on

type cb_modify from w_list`cb_modify within w_actionlist
int TabOrder=90
boolean Enabled=true
end type

on cb_modify::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : cb_modify
  
 Event	 : Clisked!, override ancestor script 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-07-96

 Description :  Open detail window for selected action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Override ancestor script to send action structure in PowerObjectParm

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0	 		JH		Initial version
  
************************************************************************************/
Window mywindow
call uo_securitybutton::clicked;Long ll_row

s_action lstr_parm


ll_row = dw_1.GetSelectedRow(0)
If ll_Row > 0 Then
	lstr_parm.action_key  = dw_1.GetItemNumber(ll_row, Istr_parametre.column[0] )
	lstr_parm.target_key = dw_1.GetItemNumber(ll_row,"ccs_targ__pk")
	OpenSheetWithParm(mywindow,  lstr_parm, istr_parametre.edit_window, w_tramos_main, 7, original!)
End if
end on

type cb_delete from w_list`cb_delete within w_actionlist
int TabOrder=70
boolean Enabled=true
end type

on cb_delete::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_actionlist
  
 Object     : cb_delete
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Kim Husson Kasperek
   
 Date       : 29-08-96

 Description : Delete an action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Overide ancestor script to cascade delete 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-08-96		1.0	 		JH		Initial version
28-08-96		1.0			KHK		Now used in connection with Targets (names on ClickButtons modified)
29-08-96		1.0			JH		Handle cascade delete  
************************************************************************************/

long ll_tmp_pk


IF MessageBox("Delete","You are about to DELETE !~r~n" + &
					  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN 
	return
ELSE
	ll_tmp_pk = dw_1.GetItemNumber(dw_1.GetRow(),"ccs_acts_pk")
	/* Delete in actionkeycode list first */
	DELETE FROM ACTION_KEYCODES  
	WHERE ACTION_KEYCODES.CCS_ACTS_PK = :ll_tmp_pk;

	IF SQLCA.SQLCode = 0 THEN
//	delete in action keycodes ok
		dw_1.DeleteRow(dw_1.GetRow())
		IF dw_1.Update(TRUE,FALSE) = 1 THEN
//		delete in actions ok
			COMMIT;
			dw_1.PostEvent("ue_retrieve")
		ELSE
			MessageBox("DB Error","Couldn't delete action table. Please try later!",StopSign!)
			ROLLBACK;
		END IF
	ELSE
		MessageBox("DB Error","Not able to delete action; because can not delete actions keycodes table. "&
					+"Please try later!",StopSign!)
		ROLLBACK;
	END IF
END IF


wf_buttons()



end on

type cb_new from w_list`cb_new within w_actionlist
int TabOrder=60
end type

on cb_new::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : cb_modify
  
 Event	 : Clisked!, override ancestor script 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-07-96

 Description :  Open detail window to make new action

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Override ancestor script to send action structure in PowerObjectParm

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0	 		JH		Initial version
  
************************************************************************************/
call uo_securitybutton::clicked;istr_parametre.edit_key_text = ""
Window mywindow

s_action lstr_parm


lstr_parm.action_key  = 0
lstr_parm.target_key = 0
OpenSheetWithParm(mywindow,  lstr_parm, istr_parametre.edit_window, w_tramos_main, 7, original!)

end on

type cb_close from w_list`cb_close within w_actionlist
int TabOrder=100
end type

type cb_refresh from w_list`cb_refresh within w_actionlist
int TabOrder=80
end type

on cb_refresh::clicked;call w_list`cb_refresh::clicked;wf_buttons()
end on

type cb_ok from w_list`cb_ok within w_actionlist
int TabOrder=110
end type

type cb_cancel from w_list`cb_cancel within w_actionlist
int TabOrder=120
end type

type dw_1 from w_list`dw_1 within w_actionlist
int TabOrder=50
end type

on dw_1::rowfocuschanged;call w_list`dw_1::rowfocuschanged;LONG 	ll_cur_row

// Take use of ancestors script
ib_auto = TRUE

dw_1.SelectRow(0,FALSE)

ll_cur_row = dw_1.GetRow()


/*If there are any actual Action, then update related target-datawindow*/
IF ll_cur_row > 0 THEN
	dw_1.SelectRow(ll_cur_row,TRUE)
	cb_modify.Enabled = TRUE
	cb_delete.Enabled = TRUE
	dw_target.Retrieve(dw_1.GetItemNumber(ll_cur_row,"ccs_targ__pk"))
	COMMIT USING SQLCA;
END IF
end on

event dw_1::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_actionlist
  
 Object     : dw_1(list of actions)
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 21-08-96

 Description : Clicked Script for dw_1;  override ancestor script to handle datetime fields

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- ------- 	----- -------------------------------------
21-08-96	1.0	 	JH		Initial version
10/9-97	1.0		BO    Remove the obsolete function names.	  
************************************************************************************/



dw_1.SelectRow(il_selectedrow, FALSE)	/* Un-highlight old row*/

/* il_selectedrow = dw_1.GetClickedRow( ) */
il_selectedrow = row

/*seletion of row set text to this row and set filter to this*/
//IF il_selectedrow <> 0 THEN
IF il_selectedrow > 0 THEN
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(il_selectedrow, TRUE)		/* Highlight new row*/
	IF dw_1.Describe("#"+String(ii_current_column)+".ColType") = "datetime" THEN
		sle_find.text = string(dw_1.GetItemDateTime(il_selectedrow, istr_parametre.column[ii_current_column]))		
	ELSE
		sle_find.text = dw_1.GetItemString(il_selectedrow, istr_parametre.column[ii_current_column])
	END IF

	is_filter = sle_find.text

	wf_updatebuttons()
ELSE 
	RETURN
END IF


end event

type sle_find from w_list`sle_find within w_actionlist
int TabOrder=40
end type

on sle_find::key_pressed;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : sle_find
  
 Event	 : ue_keydown, override ancestor script 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 21-07-96

 Description :  Find matching string and posistion in datawindow.  

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Script overrided from ancestors script to allow sort/search on datetime field

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
21-08-96		1.0	 		JH		Initial version
  
************************************************************************************/
/* Key_Pressed Script for sle_find*/

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
	dw_1.SetRedraw(False)
	ll_row = dw_1.GetSelectedRow(0)
	ll_row = ll_row + li_movement
	If ll_row < 1 or ll_row > dw_1.RowCount( ) Then 
		Beep(1)
		Return
	End If
	dw_1.selectrow(0,False)
	dw_1.SelectRow(ll_row , True)
	dw_1.ScrollToRow (ll_row)

	

	IF  dw_1.Describe("#"+String(ii_current_column)+".ColType") = "datetime"  THEN
		sle_find.text = String(dw_1.GetItemDateTime(ll_row, ii_current_column))	
	ELSE
		sle_find.text = dw_1.GetItemString(ll_row, ii_current_column)		
	END IF

	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_1.SetRedraw(True)
	sle_find.SelectText(len(sle_find.text) + 1,0)
	message.processed = true

	cb_modify.enabled = true
	cb_delete.enabled = true

	Return
End If


string	ls_character
long	ll_found_row
int		li_num_chars

ls_character = Char(message.wordparm)


/* Backspace*/ 
If message.wordparm = 8   then
	li_num_chars = Len(is_filter)
	If li_num_chars > 0 then is_filter = Left(is_filter, li_num_chars -1)		
else
	is_filter = is_filter + ls_character
end if


/* Do case-insensitive search*/
String ls_tmp
IF Len(is_filter) > 0 THEN
	IF dw_1.Describe("#"+String(ii_current_column)+".ColType") = "datetime"  THEN
		ls_tmp = "Left(String("+istr_parametre.column[ii_current_column]+"), " + String(len(is_filter))+ " )='"+is_filter+"'"
//		MessageBox("info", ls_tmp)
		ll_found_row = dw_1.Find(ls_tmp,1,99999)
	ELSE
		ll_found_row = dw_1.Find(Lower(istr_parametre.column[ii_current_column]) + ">='" + Lower(is_filter) + "'",1, 99999)
	END IF


	IF ll_found_row > 0 THEN 
		dw_1.SetRedraw(FALSE)
		dw_1.SelectRow(0, FALSE)
		dw_1.ScrollToRow(ll_found_row)
		dw_1.SelectRow(ll_found_row, TRUE)
		dw_1.SetRedraw(TRUE)
/* is_filterer function did not find any matching row*/
	Else
//            Beep(1)
		li_num_chars = Len(is_filter)
		If li_num_chars > 0 Then is_filter = Left(is_filter, li_num_chars -1)		
/* Throw away last character*/
		message.processed = true
	End If
/* is_filterer length is 0, so unhighlight former selected row*/
Else	
	dw_1.SelectRow(0, FALSE)
	ll_found_row = 0
End If

/* Remember number of highlighted row*/
il_selectedrow = ll_found_row			

wf_buttons()

end on

type cbx_1 from uo_cbx_base within w_actionlist
int X=1500
int Y=801
int Width=375
string Text="Filter ON/OFF "
end type

on clicked;call uo_cbx_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_targetlist
  
 Object     : cbx_filter_on_off
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 21-08-96

 Description : Set filter on list accordingly to Sort/Search and text in Find.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
21-08-96		1.0 			JH		Initial version
  
************************************************************************************/


IF This.Checked THEN
/* Filter ON */
	IF sle_find.Text = "" THEN
		/*Specify filter creteria*/
		Messagebox("Information","Please Enter Filter Criteria",StopSign!)
		This.Checked = FALSE
		sle_find.SetFocus()
	ELSE
		IF rb_header1.Checked THEN
			/* Filter on Date Planned */
			dw_1.SetFilter("ccs_acts_plan_d = Date('"+sle_find.text+"')")
		ELSEIF rb_header2.Checked THEN
			/* Filter on Description */
			dw_1.SetFilter("ccs_acts_desc = '"+sle_find.text+"'")
		END IF
		dw_1.Filter()
	END IF
ELSE
/* Filter OFF */
	dw_1.SetFilter("")
	dw_1.Filter()
	sle_find.SetFocus()
END IF

end on

type dw_target from u_datawindow_sqlca within w_actionlist
int X=55
int Y=1137
int Width=1847
int Height=225
int TabOrder=20
string DataObject="d_target_on_action"
end type

type gb_3 from uo_gb_base within w_actionlist
int X=19
int Y=1057
int Width=1921
int Height=353
int TabOrder=10
string Text="Target:"
end type

type gb_2 from uo_gb_base within w_actionlist
int X=1463
int Y=753
int Width=476
int Height=145
int TabOrder=30
string Text=""
end type

