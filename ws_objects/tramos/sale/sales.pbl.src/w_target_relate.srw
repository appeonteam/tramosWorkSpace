$PBExportHeader$w_target_relate.srw
$PBExportComments$Response window lets the user choose a target from a list.
forward
global type w_target_relate from w_sale_response
end type
type dw_target_list from u_datawindow_sqlca within w_target_relate
end type
type sle_find from uo_sle_base within w_target_relate
end type
type st_1 from uo_st_base within w_target_relate
end type
type cb_cancel from uo_cb_base within w_target_relate
end type
type cb_ok from uo_cb_base within w_target_relate
end type
type rb_salesperson from uo_rb_base within w_target_relate
end type
type rb_description from uo_rb_base within w_target_relate
end type
type gb_1 from uo_gb_base within w_target_relate
end type
type cbx_filter_on from uo_cbx_base within w_target_relate
end type
type gb_2 from uo_gb_base within w_target_relate
end type
end forward

global type w_target_relate from w_sale_response
integer width = 1984
integer height = 1204
dw_target_list dw_target_list
sle_find sle_find
st_1 st_1
cb_cancel cb_cancel
cb_ok cb_ok
rb_salesperson rb_salesperson
rb_description rb_description
gb_1 gb_1
cbx_filter_on cbx_filter_on
gb_2 gb_2
end type
global w_target_relate w_target_relate

type variables
Integer ii_current_column = 1
String is_filter,is_column_names[2]
Long il_selectedRow
s_action istr_parm

end variables

forward prototypes
public subroutine wf_select_column (integer ai_column_nr)
public subroutine wf_buttons ()
public subroutine documentation ()
end prototypes

public subroutine wf_select_column (integer ai_column_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : wf_select_column
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description : Set column and sorts the column in ascending order 

 Arguments : A Integer ai_column_nr

 Returns   : none 

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other :. 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0 			JH		Initial version
  
************************************************************************************/


ii_current_column = ai_column_nr
dw_target_list.SelectRow(0,False)



dw_target_list.SetSort(string(is_column_names[ii_current_column])+" A")
dw_target_list.Sort()
dw_target_list.SelectRow(1,TRUE)

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()


end subroutine

public subroutine wf_buttons ();//cb_ok.enabled = il_selectedrow > 0
cb_ok.enabled = dw_target_list.GetSelectedRow(0) > 0

end subroutine

public subroutine documentation ();/********************************************************************
	w_target_relate
	
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
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on open;call w_sale_response::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_relate
  
 Object     : 
  
 Event	 :Open! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description :Response Window lets user choose a target and returns the key

 Arguments : 

 Returns   : Returns "0" if no target was choosen, else the target key  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0	 		JH		Initial version
  
************************************************************************************/
Long ll_found_row

//This.Move(1,290)

istr_parm = Message.PowerObjectParm

/* set title of window */
This.Title = "Associate Target to Action: " + istr_parm.action_description

s_action aa
aa = istr_parm

/* Retrieve data for list of templates */
dw_target_list.Retrieve()
COMMIT USING SQLCA;


/*Find the target already choosen, if there is one*/
IF istr_parm.target_key > 0 THEN
	ll_found_row = dw_target_list.Find("ccs_targ__pk =  "+String(istr_parm.target_key),1,dw_target_list.RowCount())
	IF ll_found_row > 0 THEN
		dw_target_list.ScrollToRow(ll_found_row)		
	END IF
END IF


/*Set instance variable to show column names*/
is_column_names[1] = "userid"
is_column_names[2] = "ccs_targ_desc"

sle_find.SetFocus()

wf_buttons()


end on

on w_target_relate.create
int iCurrent
call super::create
this.dw_target_list=create dw_target_list
this.sle_find=create sle_find
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.rb_salesperson=create rb_salesperson
this.rb_description=create rb_description
this.gb_1=create gb_1
this.cbx_filter_on=create cbx_filter_on
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_target_list
this.Control[iCurrent+2]=this.sle_find
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.rb_salesperson
this.Control[iCurrent+7]=this.rb_description
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.cbx_filter_on
this.Control[iCurrent+10]=this.gb_2
end on

on w_target_relate.destroy
call super::destroy
destroy(this.dw_target_list)
destroy(this.sle_find)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.rb_salesperson)
destroy(this.rb_description)
destroy(this.gb_1)
destroy(this.cbx_filter_on)
destroy(this.gb_2)
end on

type st_hidemenubar from w_sale_response`st_hidemenubar within w_target_relate
end type

type dw_target_list from u_datawindow_sqlca within w_target_relate
integer x = 18
integer y = 128
integer width = 1390
integer height = 944
integer taborder = 50
string dataobject = "d_ccs_target_list"
boolean vscrollbar = true
end type

on doubleclicked;call u_datawindow_sqlca::doubleclicked;cb_ok.TriggerEvent(Clicked!)
end on

on rowfocuschanged;Long ll_row

	ll_row = This.GetRow()
	
	If ll_row <> This.GetSelectedRow(0) Then
		This.SelectRow(0,False)
		This.SelectRow(ll_row,True)
		This.ScrollToRow(ll_Row)
		il_selectedrow = ll_Row
	End if

	
	
end on

event clicked;
	if row = 0 Then row = GetSelectedRow(0)

	If (Row > 0) And (row <> GetSelectedRow(row - 1)) Then 
		SelectRow(0,false)
		ScrollToRow(row)
		SelectRow(row,True)
		il_selectedrow = row
		
	End if
	wf_buttons()
	
end event

type sle_find from uo_sle_base within w_target_relate
event ue_keydown pbm_keydown
integer x = 274
integer y = 32
integer width = 1134
integer height = 80
integer taborder = 60
end type

on ue_keydown;call uo_sle_base::ue_keydown;// Key_Pressed Script for sle_find

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
	dw_target_list.SetRedraw(False)
	ll_row = dw_target_list.GetSelectedRow(0)
	ll_row = ll_row + li_movement
	If ll_row < 1 or ll_row > dw_target_list.RowCount( ) Then 
		Beep(1)
		Return
	End If
	dw_target_list.selectrow(0,False)
	dw_target_list.SelectRow(ll_row , True)
	dw_target_list.ScrollToRow (ll_row)

	
	sle_find.text = dw_target_list.GetItemString(ll_row,is_column_names[ii_current_column])
	

	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_target_list.SetRedraw(True)
	sle_find.SelectText(len(sle_find.text) + 1,0)
	message.processed = true

	cb_ok.enabled = true
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
IF Len(is_filter) > 0 THEN
	
	ll_found_row = dw_target_list.Find(Lower(is_column_names[ii_current_column]) + ">='" + Lower(is_filter) + "'",1, 99999)
	
	IF ll_found_row > 0 THEN 
		dw_target_list.SetRedraw(FALSE)
		dw_target_list.SelectRow(0, FALSE)
		dw_target_list.ScrollToRow(ll_found_row)
		dw_target_list.SelectRow(ll_found_row, TRUE)
		dw_target_list.SetRedraw(TRUE)
/* is_filterer function did not find any matching row*/
	Else
            Beep(1)
		li_num_chars = Len(is_filter)
		If li_num_chars > 0 Then is_filter = Left(is_filter, li_num_chars -1)		
/* Throw away last character*/
		message.processed = true
	End If
/* is_filterer length is 0, so unhighlight former selected row*/
Else	
	dw_target_list.SelectRow(0, FALSE)
	ll_found_row = 0
End If

/* Remember number of highlighted row*/
il_selectedrow = ll_found_row			

wf_buttons()

end on

type st_1 from uo_st_base within w_target_relate
integer x = 18
integer y = 32
string text = "Find:"
alignment alignment = left!
end type

type cb_cancel from uo_cb_base within w_target_relate
integer x = 1499
integer y = 992
integer width = 366
integer height = 80
integer taborder = 40
string text = "Cancel"
boolean cancel = true
end type

on clicked;call uo_cb_base::clicked;CloseWithReturn(parent,0)
end on

type cb_ok from uo_cb_base within w_target_relate
integer x = 1499
integer y = 880
integer width = 366
integer height = 80
integer taborder = 30
string text = "OK"
boolean default = true
end type

on clicked;call uo_cb_base::clicked;Long ll_row

ll_row = dw_target_list.GetRow()
CloseWithReturn(parent,dw_target_list.GetItemNumber(ll_row,"ccs_targ__pk"))
end on

type rb_salesperson from uo_rb_base within w_target_relate
integer x = 1499
integer y = 448
integer width = 375
string text = "Sales Person "
boolean checked = true
end type

on clicked;call uo_rb_base::clicked;wf_select_column(1)
end on

type rb_description from uo_rb_base within w_target_relate
integer x = 1499
integer y = 528
integer width = 366
integer height = 64
string text = "Description "
end type

on clicked;call uo_rb_base::clicked;wf_select_column(2)
end on

type gb_1 from uo_gb_base within w_target_relate
integer x = 1445
integer y = 384
integer height = 240
integer taborder = 20
string text = "Sort/Search"
end type

type cbx_filter_on from uo_cbx_base within w_target_relate
integer x = 1481
integer y = 672
integer width = 375
string text = "Filter ON/OFF "
end type

on clicked;call uo_cbx_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_relate
  
 Object     : cbx_filter_on_off
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-08-96

 Description : Will set filter on list accordingly to Sort/Search and text in Find.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-08-96		1.0 			JH		Initial version
  
************************************************************************************/


IF This.Checked THEN
/* Filter ON */
	IF sle_find.Text = "" THEN
		/*Specify filter creteria*/
		Messagebox("Infomation","Please Enter Filter Criteria",StopSign!)
		This.Checked = FALSE
		sle_find.SetFocus()
	ELSE
		IF rb_salesperson.Checked THEN
			/* Filter on Sales person */
			dw_target_list.SetFilter("userid = '"+Upper(sle_find.text)+"'")
		ELSEIF rb_description.Checked THEN
			/* Filter on Description */
			dw_target_list.SetFilter("ccs_targ_desc = '"+sle_find.text+"'")
		END IF
		dw_target_list.Filter()
	END IF
ELSE
/* Filter OFF */
	dw_target_list.SetFilter("")
	dw_target_list.Filter()
	sle_find.SetFocus()
END IF

end on

type gb_2 from uo_gb_base within w_target_relate
integer x = 1445
integer y = 624
integer height = 144
integer taborder = 10
string text = ""
end type

