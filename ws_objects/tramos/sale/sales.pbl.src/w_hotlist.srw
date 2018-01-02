$PBExportHeader$w_hotlist.srw
$PBExportComments$Displays the Hot list.
forward
global type w_hotlist from w_actionlist
end type
type cb_open from uo_cb_base within w_hotlist
end type
type rb_header3 from uo_rb_base within w_hotlist
end type
end forward

global type w_hotlist from w_actionlist
integer width = 2830
integer height = 1300
cb_open cb_open
rb_header3 rb_header3
end type
global w_hotlist w_hotlist

forward prototypes
public subroutine wf_select_column (integer column_nr)
end prototypes

public subroutine wf_select_column (integer column_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_hotlist
  
 Object     : wf_select_column
  
 Event	 : 

 Scope     : public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description : Selects column for sort / search

 Arguments : Column no which is to be sorted

 Returns   :none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0	 		JH		Initial version
03-09-96					JH		Sort date descenting order
  
************************************************************************************/

ii_current_column = column_nr
dw_1.SelectRow(0,False)

IF ii_current_column = 1 THEN
	// date column
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

on ue_retrieve;/* Override ancestor*/


/* List all action status notations made in the last 14 days */
dw_1.Retrieve(DateTime(RelativeDate(Today(),-14)))
COMMIT USING SQLCA;
sle_find.SetFocus()
end on

on open;/* Override ancestor */

Long ll_count
string ls_tmp
istr_parametre = Message.PowerObjectParm
dw_1.DataObject  = istr_parametre.list_window
dw_1.SetTransObject(SQLCA)
This.Move(5,5)

// Get search column data type

For ll_count = 0 to 2 
	ls_tmp= dw_1.describe(string(istr_parametre.column[ll_count])+".ColType") 
	ib_column_string[ll_count] = ls_tmp	<> "number" 
Next

//Set Window Title sort Text and Hide

this.Title = istr_parametre.window_title

rb_header1.text = istr_parametre.column_name[1]
rb_header2.text = istr_parametre.column_name[2]
rb_header3.Text = istr_parametre.column_name[3]

IF  IsNull(istr_parametre.edit_datawindow) And  IsNull (istr_parametre.edit_window) THEN
	cb_new.Hide()
	cb_modify.Hide()
	cb_delete.Hide()
	cb_refresh.Hide()
	cb_close.Hide()
ELSE
	cb_ok.Hide()
	cb_cancel.Hide()
END IF

Setnull(istr_parametre.return_value)
wf_select_column(1)
PostEvent("ue_retrieve")

end on

on w_hotlist.create
int iCurrent
call super::create
this.cb_open=create cb_open
this.rb_header3=create rb_header3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_open
this.Control[iCurrent+2]=this.rb_header3
end on

on w_hotlist.destroy
call super::destroy
destroy(this.cb_open)
destroy(this.rb_header3)
end on

type cb_modify from w_actionlist`cb_modify within w_hotlist
boolean visible = false
integer x = 2304
integer y = 224
integer taborder = 110
end type

type cb_delete from w_actionlist`cb_delete within w_hotlist
boolean visible = false
integer x = 2304
integer y = 320
integer taborder = 90
end type

type cb_new from w_actionlist`cb_new within w_hotlist
boolean visible = false
integer x = 2304
integer y = 128
integer taborder = 80
end type

type cb_close from w_actionlist`cb_close within w_hotlist
integer x = 2304
integer y = 1120
integer taborder = 60
end type

type cb_refresh from w_actionlist`cb_refresh within w_hotlist
boolean visible = false
integer x = 2304
integer y = 512
integer taborder = 100
end type

type rb_header1 from w_actionlist`rb_header1 within w_hotlist
integer x = 2286
integer y = 704
integer width = 384
integer height = 64
end type

on rb_header1::clicked;/* Overide ancestor */
wf_select_column(1)

end on

type rb_header2 from w_actionlist`rb_header2 within w_hotlist
integer x = 2286
integer y = 784
integer width = 421
integer height = 64
end type

on rb_header2::clicked;/* Overide ancestor */
wf_select_column(2)
end on

type st_return from w_actionlist`st_return within w_hotlist
end type

type st_1 from w_actionlist`st_1 within w_hotlist
integer x = 37
integer y = 16
end type

type cb_ok from w_actionlist`cb_ok within w_hotlist
boolean visible = false
integer x = 2304
integer y = 128
integer taborder = 120
end type

type cb_cancel from w_actionlist`cb_cancel within w_hotlist
integer x = 2304
integer taborder = 130
end type

type dw_1 from w_actionlist`dw_1 within w_hotlist
integer x = 37
integer y = 176
integer width = 2176
integer height = 1008
integer taborder = 20
end type

on dw_1::doubleclicked;/* Overide ancestor script */

cb_open.TriggerEvent(Clicked!)
end on

on dw_1::rowfocuschanged;/* Overide ancestor script */
Long ll_row

	ll_row = GetRow()
	
	If ll_row <> GetSelectedRow(0) Then
		SelectRow(0,False)
		SelectRow(ll_row,True)
		ScrollToRow(ll_Row)
	End if

//ib_auto = TRUE
end on

type gb_1 from w_actionlist`gb_1 within w_hotlist
integer x = 2249
integer y = 640
integer width = 530
integer height = 320
integer taborder = 40
end type

type sle_find from w_actionlist`sle_find within w_hotlist
integer x = 37
integer y = 80
integer taborder = 10
end type

on sle_find::key_pressed;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_articles
  
 Object     : sle_find
  
 Event	 : ue_keydown, override ancestor script 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-07-96

 Description :  Find matching string and posistion in datawindow.  

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Script overrided from ancestors script to allow sort/search on salesperson

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0	 		JH		Initial version
  
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



end on

type cbx_1 from w_actionlist`cbx_1 within w_hotlist
integer x = 2304
integer y = 1008
end type

on cbx_1::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_hotlist
  
 Object     : cbx_1
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description : Set filter on list accordingly to Sort/Search and text in Find.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Overide ancestors script to handle filter on actual datawindows rows

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
		Messagebox("Infomation","Please Enter Filter Criteria",StopSign!)
		This.Checked = FALSE
		sle_find.SetFocus()
	ELSE
		IF rb_header1.Checked THEN
			/* Filter on Date */
			dw_1.SetFilter("ccs_acts_ccs_acts_sts_d = Date('"+sle_find.text+"')")
		ELSEIF rb_header2.Checked THEN
			/* Filter on Description */
			dw_1.SetFilter("ccs_acts_ccs_acts_sts_desc = '"+sle_find.text+"'")
		ELSEIF rb_header3.Checked THEN
			/* Filter on Sales Person */
			dw_1.SetFilter("ccs_targ_userid = '"+Upper(sle_find.text)+"'")
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

type dw_target from w_actionlist`dw_target within w_hotlist
boolean visible = false
integer y = 1232
integer taborder = 0
end type

type gb_3 from w_actionlist`gb_3 within w_hotlist
boolean visible = false
integer x = 37
integer y = 1152
integer taborder = 70
end type

type gb_2 from w_actionlist`gb_2 within w_hotlist
integer x = 2267
integer y = 960
integer taborder = 50
end type

type cb_open from uo_cb_base within w_hotlist
integer x = 2304
integer y = 32
integer width = 402
integer height = 80
integer taborder = 30
string text = "&Open"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_hotlist
  
 Object     : cb_open
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description :Expands text field in a responce window; so the user can edit and read status description. 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : A structure of type s_expand_text to send text field to be expanded

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
  
************************************************************************************/


s_expand_text lstr_parm
String ls_rtn
Long ll_row

ll_row = dw_1.GetSelectedRow(0)

IF ll_row > 0 THEN
	// Only if a row is selected
	dw_1.AcceptText()
	lstr_parm.text = dw_1.GetItemString(ll_row,"ccs_acts_ccs_acts_sts_desc")  
	lstr_parm.name = String(dw_1.GetItemDateTime(ll_row,"ccs_acts_ccs_acts_sts_d"))


	/* Open the responce window and wait for return */	
	OpenWithParm(w_expand_hotlist,lstr_parm)

	ls_rtn = Message.StringParm
	/* Test if changes were made */
	IF ls_rtn <> "!" THEN
		/* Changes will not be updated */
		MessageBox("Infomation","Changes will not be updated! Please make changes to Action Status Reports"&
					+" in module Action/Status!")
	END IF
	
ELSE
	MessageBox("Infomation","Please select an Action Status first!",StopSign!)
END IF
end on

type rb_header3 from uo_rb_base within w_hotlist
integer x = 2286
integer y = 864
integer width = 421
integer height = 64
boolean bringtotop = true
string text = "Header 3"
end type

on clicked;/* Overide ancestor */
wf_select_column(3)
end on

