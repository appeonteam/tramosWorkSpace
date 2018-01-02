$PBExportHeader$u_cross_select.sru
$PBExportComments$Visual object to manage m:n relations; lets the user select rows from one datawindow and enters the selected values in another datawindow.
forward
global type u_cross_select from mt_u_visualobject
end type
type sle_find from uo_sle_base within u_cross_select
end type
type st_find from uo_st_base within u_cross_select
end type
type cb_add_all from uo_cb_base within u_cross_select
end type
type st_all from uo_st_base within u_cross_select
end type
type st_selected from uo_st_base within u_cross_select
end type
type dw_2 from u_datawindow_sqlca within u_cross_select
end type
type cb_remove_all from uo_cb_base within u_cross_select
end type
type cb_add from uo_cb_base within u_cross_select
end type
type cb_remove from uo_cb_base within u_cross_select
end type
type rb_header1 from uo_rb_base within u_cross_select
end type
type rb_header2 from uo_rb_base within u_cross_select
end type
type gb_1 from uo_gb_base within u_cross_select
end type
type cb_update from uo_cb_base within u_cross_select
end type
type cb_cancel from uo_cb_base within u_cross_select
end type
type dw_1 from u_datawindow_sqlca within u_cross_select
end type
end forward

global type u_cross_select from mt_u_visualobject
int Width=2757
int Height=1185
sle_find sle_find
st_find st_find
cb_add_all cb_add_all
st_all st_all
st_selected st_selected
dw_2 dw_2
cb_remove_all cb_remove_all
cb_add cb_add
cb_remove cb_remove
rb_header1 rb_header1
rb_header2 rb_header2
gb_1 gb_1
cb_update cb_update
cb_cancel cb_cancel
dw_1 dw_1
end type
global u_cross_select u_cross_select

type variables
private boolean ib_column_string[2] // True, False 

private s_cross_select_list istr_param

private string is_filter = ""

private Long il_key

private String is_key

private Integer ii_current_column = 1

private Long il_selectedrow 
private Long il_rowdw2

private Boolean ib_row_is_selected[]

end variables

forward prototypes
public function integer uf_construct (s_cross_select_list astr_list)
public subroutine uf_select_column (integer ai_column_nr)
private subroutine uf_insert (integer al_selected_row)
private subroutine uf_set_indicator ()
private subroutine uf_remove_indicator (long al_row_nr)
public subroutine uf_update ()
private subroutine uf_add_all ()
private function integer uf_add_selected (long al_row_nr)
private function integer uf_remove_selected (long al_rownr)
private subroutine uf_remove_all ()
public subroutine uf_addbuttons ()
public subroutine uf_removebuttons ()
end prototypes

public function integer uf_construct (s_cross_select_list astr_list);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_construct(s_cross_select_list astr_list)
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 19-07-96

 Description : Constructs the user object. Any users must call this function for the user object to be initialized. 

 Arguments : s_cross_select_list astr_list

 Returns   : Integer (If succees: 1)  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Builds the userobject at runtime by setting datawindow objects and names on radiobuttons. 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-07-96		1.0 			JH		Initial version
  
************************************************************************************/

Long ll_count

/* Set the instance structure as argument*/ 
istr_param = astr_list

dw_1.DataObject  = astr_list.dwin_list 		/* The list to select from */
dw_2.DataObject  = astr_list.dwin_selects	/* The list of selected values */

dw_1.SetTransObject(SQLCA)
IF dw_1.Retrieve() < 1 THEN
/*	No Rows retrieved in the list to select from.*/
	uf_addbuttons()
ELSE
	
	dw_2.SetTransObject(SQLCA)
	dw_2.Retrieve(astr_list.select_key)

	dw_1.VScrollBar = TRUE
	dw_2.VScrollBar = TRUE



	/* Get search column data type*/

	For ll_count = 1To 2
		CHOOSE CASE left(dw_1.describe(string(astr_list.column_names[ll_count])+".ColType"),4)
			CASE "numb", "deci","date"
				ib_column_string[ll_count]  = FALSE		
			CASE ELSE
				ib_column_string[ll_count]  = TRUE		 
		END CHOOSE
	Next



	/* Set RadioButton text for Sort/Search*/

	rb_header1.text = astr_list.column_headers[1]
	rb_header2.text = astr_list.column_headers[2]

	/* Set Instance variablen of type Boolean Array to indicate which rows is already selected*/ 

	uf_set_indicator()

END IF
// Rollback because of retrieve() as recomented by Sybase (and Martin!)
ROLLBACK;









Return 1
end function

public subroutine uf_select_column (integer ai_column_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_construct(s_cross_select_list astr_list)
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 19-07-96

 Description : Set column and sorts the column in ascending order 

 Arguments : A Integer ai_column_nr

 Returns   : none 

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other :. 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-07-96		1.0 			JH		Initial version
  
************************************************************************************/


ii_current_column = ai_column_nr
dw_1.SelectRow(0,False)
dw_1.SetSort(string(istr_param.column_names[ii_current_column])+" A")
dw_1.Sort()
dw_1.SelectRow(1,TRUE)

sle_find.text = ""
is_filter = ""
il_selectedrow = 0
sle_find.SetFocus()


end subroutine

private subroutine uf_insert (integer al_selected_row);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_insert
  
 Event	 : 

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-07-96

 Description : Inserts the selected value from the list (dw_1) in the list of selected values (dw_2)

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-07-96		1.0	 		JH		Initial version
20-08-96					JH		Modified to handle datetime fields in datawindows
  
************************************************************************************/


Long ll_newrow, ll_colmval[2], ll_count, ll_key
String ls_colmval[2],ls_key
Datetime ldt_colmval[2]


ll_newrow = dw_2.InsertRow(0)

// set key column value with selected value  
CHOOSE CASE left(dw_1.describe(string(istr_param.list_key_column_name)+".ColType"),4)
		CASE "numb", "deci"
			ll_key = dw_1.GetItemNumber(al_selected_row,istr_param.list_key_column_name)			
			dw_2.SetItem(ll_newrow,istr_param.selects_key_column_name,ll_key)			
		CASE ELSE
			ls_key = dw_1.GetItemString(al_selected_row,istr_param.list_key_column_name)
			dw_2.SetItem(ll_newrow,istr_param.selects_key_column_name,ls_key)
		END CHOOSE

// set key column value specifying who the selected values are for 
dw_2.SetItem(ll_newrow,istr_param.selects_key2_column_name,istr_param.select_key)			


// Set the display column values
FOR ll_count = 1 TO 2
	IF ib_column_string[ll_count] THEN
		ls_colmval[ll_count] = dw_1.GetItemString(al_selected_row,ll_count)
		dw_2.SetItem(ll_newrow,ll_count,ls_colmval[ll_count])
	ELSE
		IF  left(dw_1.describe("#"+string(ll_count)+".ColType"),4) = "date" THEN
			ldt_colmval[ll_count] = dw_1.GetItemDateTime(al_selected_row,ll_count)
			dw_2.SetItem(ll_newrow,ll_count,ldt_colmval[ll_count])
		ELSE
			ll_colmval[ll_count] = dw_1.GetItemNumber(al_selected_row,ll_count)
			dw_2.SetItem(ll_newrow,ll_count,ll_colmval[ll_count])
		END IF

	END IF
	
NEXT


 
dw_2.ScrollToRow(ll_newrow)

end subroutine

private subroutine uf_set_indicator ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_set_indicator()
  
 Event	 : 

 Scope     :Private 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 23-07-96

 Description : Sets instance array ib_row_is_selected[] to indicate the selected elements in the list. 

 Arguments : none

 Returns   : none

 Variables : ib_row_is_selected[], istr_param

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
23-07-96	 	1.0	 		JH		Initial version
  
************************************************************************************/

Long ll_count 
Long ll_key
String ls_key

// For each row in the list (dw_1) check if the key is in the selected list (dw_2).
// If it is, set instance array ib_row_is_selected at index  'positon row number' to TRUE

FOR ll_count = 1 TO dw_1.RowCount()
	CHOOSE CASE left(dw_1.describe(string(istr_param.list_key_column_name)+".ColType"),4)
		CASE "numb", "deci"
			ll_key = dw_1.GetItemNumber(ll_count,istr_param.list_key_column_name)			
			IF dw_2.Find(string(istr_param.selects_key_column_name)+" = "+string(ll_key),1,dw_2.RowCount())  > 0 THEN
				ib_row_is_selected[ll_count] = TRUE
			ELSE
				ib_row_is_selected[ll_count] = FALSE				
			END IF
		CASE ELSE
			ls_key = dw_1.GetItemString(ll_count,istr_param.list_key_column_name)
			IF dw_2.Find(string( istr_param.selects_key_column_name)+" = "+string(ls_key),1,dw_2.RowCount()) > 0 THEN
				ib_row_is_selected[ll_count] = TRUE
			ELSE
				ib_row_is_selected[ll_count] = FALSE
			END IF
		END CHOOSE
NEXT




end subroutine

private subroutine uf_remove_indicator (long al_row_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_remove_indicator(al_row_nr )
  
 Event	 : 

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 23-07-96

 Description : Removes indication in Instance array ib_row_is_selected[] at index 'al_row_nr'

 Arguments :A Long  al_row_nr. The selected and current row af the selected list(dw_2)  

 Returns   : none

 Variables : ib_row_is_selected[]

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
23-07-96		1.0 			JH		Initial version
  
************************************************************************************/

Long ll_key
Long ll_row
String ls_key

// Search list(dw_1) to find which row and set instace array ib_row_is_selected[row] to false

CHOOSE CASE left(dw_2.describe(string(istr_param.selects_key_column_name)+".ColType"),4)
	CASE "numb", "deci"
		ll_key = dw_2.GetItemNumber(al_row_nr,istr_param.selects_key_column_name)	
		ll_row =  dw_1.Find(string(istr_param.list_key_column_name)+" = "+string(ll_key),1,dw_1.RowCount())		
		IF ll_row > 0 THEN
			ib_row_is_selected[ll_row] = FALSE			
		END IF
	CASE ELSE
		ls_key = dw_2.GetItemString(al_row_nr,istr_param.selects_key_column_name)
		ll_row =  dw_1.Find(string( istr_param.list_key_column_name)+" = "+string(ls_key),1,dw_1.RowCount())	
		IF ll_row > 0 THEN
			ib_row_is_selected[ll_row] = FALSE
		END IF
	END CHOOSE





end subroutine

public subroutine uf_update ();IF dw_2.Update() = 1 THEN
	COMMIT USING SQLCA;
	IF Sqlca.Sqlcode < 0  THEN
	MessageBox("DB Error","Changes haven't been made. Please Try again.",StopSign!)
	END IF
ELSE
	ROLLBACK USING SQLCA;
	IF Sqlca.Sqlcode < 0 THEN
	MessageBox("DB RollBack Error","Rollback could not be performed. Please check all changes this session.",StopSign!)
	END IF
END IF

end subroutine

private subroutine uf_add_all ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_add_all( )
  
 Event	 : 

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 31-07-96

 Description : Takes all rows in the list(dw_1) and adds them to the list of selected values(dw_2) 

 Arguments : none

 Returns   :none

 Variables :  

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
31-07-96	 	1.0	 		JH		Initial version
  
************************************************************************************/
Long ll_rowcount,ll_row

dw_2.SetRedraw(FALSE)
ll_rowcount = dw_1.RowCount()

IF dw_1.RowCount() > 0 THEN
	FOR ll_row = 1 TO ll_rowcount
		uf_add_selected(ll_row)  
	NEXT

END IF
dw_2.SetRedraw(TRUE)


end subroutine

private function integer uf_add_selected (long al_row_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_add_selected(al_row_nr)
  
 Event	 : 

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-07-96

 Description : Takes the selected value in the list(dw_1) and adds it to the list of selected values(dw_2) 

 Arguments : al_row_nr.  A Long whose value is the selected and current row in dw_1.  

 Returns   : Integer 	0 = Could not insert, item already in selected list
				1 = Has inserted selected row

 Variables : Instance array ib_row_is_selected[] must show which rows in the list that is already selected.  

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-07-96	 	1.0	 		JH		Initial version
  
************************************************************************************/

IF ib_row_is_selected[al_row_nr] THEN
	// Item is already in selectd list 
	Return 0
ELSE	
	ib_row_is_selected[al_row_nr] = TRUE
	uf_insert(al_row_nr)
	Return 1
END IF






end function

private function integer uf_remove_selected (long al_rownr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_remove_selected(al_rownr )
  
 Event	 : 

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       :23-07-96

 Description : Removes the selected row from the selected list(dw_2)

 Arguments :A Long al_rownr; The selected and current row of the selected list(dw_2)

 Returns   : none

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
23-07-96		1.0 			JH		Initial version
  
************************************************************************************/

IF al_rownr > 0 THEN
	// Update instance array ib_row_is_selected[] and delete the row
	uf_remove_indicator(al_rownr)
	dw_2.DeleteRow(al_rownr)
	Return 1	
ELSE
	 Return 0
END IF

end function

private subroutine uf_remove_all ();Long ll_row
Long ll_rowcount

dw_2.SetRedraw(FALSE)
ll_rowcount = dw_2.RowCount()

IF dw_2.RowCount() > 0 THEN
	FOR ll_row =  ll_rowcount TO 1 STEP -1
		uf_remove_selected(ll_row)  
	NEXT

END IF
dw_2.SetRedraw(TRUE)
end subroutine

public subroutine uf_addbuttons ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_addbuttons( )
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 01-08-96

 Description : Updates the 'add' and 'add all' buttons enabled attribute

 Arguments : none

 Returns   :none

 Variables : The instance variabled il_selectedrow must indicate current row in list (dw_1) 

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-08-96	 	1.0	 		JH		Initial version
  
************************************************************************************/

cb_add.enabled = il_selectedrow > 0
cb_add_all.enabled = cb_add.enabled
end subroutine

public subroutine uf_removebuttons ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select.uf_removebuttons( )
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 01-08-96

 Description : Updates the 'remove' and 'remove all' buttons enabled attribute

 Arguments : none

 Returns   :none

 Variables : The instance variabled il_rowdw2 must indicate current row in list of selected values (dw_2) 

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-08-96	 	1.0	 		JH		Initial version
  
************************************************************************************/


cb_remove.enabled = il_rowdw2 > 0
cb_remove_all.enabled = cb_remove.enabled
end subroutine

on constructor;call mt_u_visualobject::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_cross_select
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 18-07-96

 Description : Generic user object used to manage m:n relations, where the user can select from one list(dw_1)
			 and see selected values in selected list(dw_2) for a chosen entity.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : 	Instances of this  user object must be initialized by calling its function uf_construct(Struct) . Struct is a structure of type
		s_cross_select_list. The variables of Struct must be asigned following:
			String dwin_list: The name of the datawindow object holding the list with all values that can be selected.
			String dwin_selects : The name of the datawindow object holding the list of values selected by a chosen
							entity.
			Long select_key: The key value of the choosen entity ( notice this must be a unique key, not a composite key!)
			String column_names[2]: The names of the 2 datawindow columns to be shown in dwin_list.
			String column_headers[2]: The header text of the 2 datawindow columns to be shown dwin_list.
			String list_key_column_name: The name of the datawindow column holding the key value dwin_list. 
			String selects_key_column_name: The name of the datawindow column holding the key value in
							dwin_selects identifying the key from dwin_list.										
			String select_key_column2_name: The name of the datawindow column holding the key value in
							dwin_selects identifying select_key.
		This initialization can f.ex be done in the constructor event.  
		
		Example: A customer can have many codes and a code can relate to many customer. This results in 3 tables:
				Customers,Codes and the relation table Customers_codes.   
				dwin_list will be a datawindow object selecting all from Codes.
				dwin_selects will be a datawindow object selecting all codes in Customers_codes
					where customer = select_key and then displaying the column from Codes.

		This user object updates the m:n relation table, as specified by dwin_selects with the valuepair optained from
		column: 'selects_key_column_name' and 'select_key_column2_name'

		Custom actions following Clicked even on Update and Cancel must be specified on the destructor event. 
		Examble: 	Following code enables a buttton in the window using the user object, before making the user object
				invisible:
					cb_codes.enabled = TRUE
					This.visible = FALSE
		  
		

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18-07-96		1.0	 		JH		Initial version
19-07-96					JH		Added uf_construct(), uf_select_column()
22-07-96					JH		Added uf_add_selected(), uf_insert()  
23-07-96					JH		Addes uf_set_indicator(), uf_remove_indicator(), uf_remove_selected()	
31-07-96					JH		Added uf_add_all and uf_remove_all
01-08-96					JH 		Added uf_addbuttons, uf_removebuttons
************************************************************************************/



end on

on destructor;call mt_u_visualobject::destructor;
//instances of this user object may need to insert destructor script
end on

on u_cross_select.create
int iCurrent
call mt_u_visualobject::create
this.sle_find=create sle_find
this.st_find=create st_find
this.cb_add_all=create cb_add_all
this.st_all=create st_all
this.st_selected=create st_selected
this.dw_2=create dw_2
this.cb_remove_all=create cb_remove_all
this.cb_add=create cb_add
this.cb_remove=create cb_remove
this.rb_header1=create rb_header1
this.rb_header2=create rb_header2
this.gb_1=create gb_1
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=sle_find
this.Control[iCurrent+2]=st_find
this.Control[iCurrent+3]=cb_add_all
this.Control[iCurrent+4]=st_all
this.Control[iCurrent+5]=st_selected
this.Control[iCurrent+6]=dw_2
this.Control[iCurrent+7]=cb_remove_all
this.Control[iCurrent+8]=cb_add
this.Control[iCurrent+9]=cb_remove
this.Control[iCurrent+10]=rb_header1
this.Control[iCurrent+11]=rb_header2
this.Control[iCurrent+12]=gb_1
this.Control[iCurrent+13]=cb_update
this.Control[iCurrent+14]=cb_cancel
this.Control[iCurrent+15]=dw_1
end on

on u_cross_select.destroy
call mt_u_visualobject::destroy
destroy(this.sle_find)
destroy(this.st_find)
destroy(this.cb_add_all)
destroy(this.st_all)
destroy(this.st_selected)
destroy(this.dw_2)
destroy(this.cb_remove_all)
destroy(this.cb_add)
destroy(this.cb_remove)
destroy(this.rb_header1)
destroy(this.rb_header2)
destroy(this.gb_1)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.dw_1)
end on

type sle_find from uo_sle_base within u_cross_select
event ue_keydown pbm_keydown
int X=183
int Y=33
int Width=933
int Height=81
int TabOrder=10
end type

on ue_keydown;call uo_sle_base::ue_keydown;//ue_keydown Script for sle_find. Copied from Martins code in w_list key_pressed script for sle_find
// Find matching string and posistion in datawindow.  

// key pressed in datawindow
// capture up and down arrows to move the selection up and down


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

	IF ib_column_string[ii_current_column] THEN
		sle_find.text = dw_1.GetItemString(ll_row, istr_param.column_names[ii_current_column])
	Else
		sle_find.text = String(dw_1.GetItemNumber(ll_Row, ii_current_column) )
	END IF

	is_filter = sle_find.text
	il_selectedrow = ll_row
	dw_1.SetRedraw(True)
	sle_find.SelectText(len(sle_find.text) + 1,0)
	message.processed = true
	cb_add.enabled = TRUE
	cb_add_all.enabled = TRUE
	Return
End If


string	ls_character
long	ll_found_row
int		li_num_chars

ls_character = Char(message.wordparm)

////filter out non alpha characters
//If (Lower(ls_character) < "a" or Lower(ls_character) > "z") and  ls_character <> Char(8) Then 
//	message.processed = true
//	Return
//End If

// Backspace 
If message.wordparm = 8   then
	li_num_chars = Len(is_filter)
	If li_num_chars > 0 then is_filter = Left(is_filter, li_num_chars -1)		
else
	is_filter = is_filter + ls_character
	
end if

// Do case-insensitive search
IF Len(is_filter) > 0 THEN
	IF ib_column_string[ii_current_column] THEN
		ll_found_row = dw_1.Find(Lower(istr_param.column_names[ii_current_column]) + ">='" + Lower(is_filter) + "'",1, 99999)
	ELSE
		ll_found_row = dw_1.Find(string(istr_param.column_names[ii_current_column])+">="+is_filter,1, 99999)
	END IF
	IF ll_found_row > 0 THEN 
		dw_1.SetRedraw(FALSE)
		dw_1.SelectRow(0, FALSE)
		dw_1.ScrollToRow(ll_found_row)
		dw_1.SelectRow(ll_found_row, TRUE)
		dw_1.SetRedraw(TRUE)
// is_filterer function did not find any matching row
	Else
            Beep(1)
		li_num_chars = Len(is_filter)
		If li_num_chars > 0 Then is_filter = Left(is_filter, li_num_chars -1)		
// Throw away last character
		message.processed = true
	End If
// is_filter er length is 0, so unhighlight former selected row
Else	
	dw_1.SelectRow(0, FALSE)
	ll_found_row = 0
End If

// Remember number of highlighted row
il_selectedrow = ll_found_row	

uf_addbuttons()		


end on

type st_find from uo_st_base within u_cross_select
int X=37
int Y=33
int Width=147
int Height=65
string Text="Find:"
Alignment Alignment=Left!
end type

type cb_add_all from uo_cb_base within u_cross_select
int X=1171
int Y=673
int Width=403
int Height=81
int TabOrder=50
string Text="Add All>>"
end type

on clicked;call uo_cb_base::clicked;uf_add_all()
end on

type st_all from uo_st_base within u_cross_select
int X=37
int Y=145
int Width=293
int Height=65
string Text="All:"
Alignment Alignment=Left!
end type

type st_selected from uo_st_base within u_cross_select
int X=1646
int Y=145
int Width=311
int Height=65
string Text="Selected:"
Alignment Alignment=Left!
end type

type dw_2 from u_datawindow_sqlca within u_cross_select
int X=1646
int Y=225
int Width=1079
int Height=865
int TabOrder=90
BorderStyle BorderStyle=StyleLowered!
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_cross_select.dw_2
  
 Event	 :  clicked!

 Scope     : Global

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 17-07-96

 Description : Override ancestor's clicked event

 Arguments : None

 Returns   : None

 Variables :  None

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- ------- 	-----	-------------------------------------
1/1-96	1.0				Initial version
10/9-97	1.0		BO		Remove the use of obsolete functions in 
								PB 5.0
************************************************************************************/



/* Long ll_row */

	/* ll_Row = GetClickedRow () */

	If  row = 0 Then row = GetSelectedRow(0)

	If row > 0 Then SetRow(row)

	ScrollToRow(row)
	SelectRow(row,True)
	il_rowdw2 = GetRow()
	uf_removebuttons()

	



end event

on rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_cross_select.dw_2
  
 Event	 : rowfocuschanged!

 Scope     : Global

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 17-07-96

 Description : Override ancestor's clicked event

 Arguments : None

 Returns   : None

 Variables :  None

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
17-07-96		1.0					Initial version

************************************************************************************/


	il_rowdw2 = GetRow()
	
	If il_rowdw2 <> GetSelectedRow(0) Then
		SelectRow(0,False)
		SelectRow(il_rowdw2,True)
		SetRow(il_rowdw2)
		ScrollToRow(il_rowdw2)
	End if
	
	uf_removebuttons()
end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;uf_remove_selected( dw_2.GetRow())
end on

type cb_remove_all from uo_cb_base within u_cross_select
int X=1171
int Y=769
int Width=403
int Height=81
int TabOrder=60
string Text="<<Remove All<<"
end type

on clicked;call uo_cb_base::clicked;

	IF MessageBox("Warning", "Remove ALL from list of selected",	Question!, OKCancel! ) = 1 THEN
		uf_remove_all() 
	END IF


end on

type cb_add from uo_cb_base within u_cross_select
int X=1171
int Y=481
int Width=403
int Height=81
int TabOrder=30
string Text="Add>>"
end type

on clicked;call uo_cb_base::clicked;

IF uf_add_selected(dw_1.GetRow()) = 0 THEN
	MessageBox("Information","Item is already selected.")
END IF

end on

type cb_remove from uo_cb_base within u_cross_select
int X=1171
int Y=577
int Width=403
int Height=81
int TabOrder=40
string Text="<<Remove"
end type

on clicked;call uo_cb_base::clicked;Integer li_ans

li_ans = MessageBox("Warning", "Remove from list of selected",	Question!, OKCancel! )
	IF li_ans = 1 THEN
		IF uf_remove_selected( dw_2.GetRow()) = 0 THEN
			MessageBox("Information","Nothing To Delete")
	END IF
END IF

		
end on

type rb_header1 from uo_rb_base within u_cross_select
int X=1153
int Y=65
int Width=439
int Height=65
string Text="Header1"
boolean Checked=true
end type

on clicked;call uo_rb_base::clicked;uf_select_column (1)
end on

type rb_header2 from uo_rb_base within u_cross_select
int X=1153
int Y=145
int Width=439
int Height=65
string Text="Header2"
end type

on clicked;call uo_rb_base::clicked;uf_select_column(2)
end on

type gb_1 from uo_gb_base within u_cross_select
int X=1134
int Y=1
int Width=476
int Height=225
int TabOrder=0
string Text="Sort/Search"
end type

type cb_update from uo_cb_base within u_cross_select
int X=1171
int Y=913
int Width=403
int Height=81
int TabOrder=70
string Text="Update"
end type

on clicked;call uo_cb_base::clicked;
f_update(dw_2,w_tramos_main)
sle_find.text = ""
parent.TriggerEvent(Destructor!)



end on

type cb_cancel from uo_cb_base within u_cross_select
int X=1171
int Y=1009
int Width=403
int Height=81
int TabOrder=80
string Text="Cancel"
end type

on clicked;call uo_cb_base::clicked;Integer li_ans

/* test if any changes were made */
dw_2.AcceptText()

IF dw_2.ModifiedCount() > 0 OR dw_2.DeletedCount() > 0 THEN
	li_ans = MessageBox("Warning","You have modified the list! Do you wish to save?",Question!,YesNO!)

END IF
IF li_ans = 1 THEN
	/* save changes before closing*/
	cb_update.TriggerEvent(Clicked!)

ELSE
	parent.TriggerEvent(Destructor!)
END IF





end on

type dw_1 from u_datawindow_sqlca within u_cross_select
int X=37
int Y=225
int Width=1079
int Height=865
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_cross_select.dw_1
  
 Event	 :  clicked!

 Scope     : Global

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 17-07-96

 Description : Override ancestor's clicked event

 Arguments : None

 Returns   : None

 Variables :  None

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- ------- 	-----	-------------------------------------
1/1-96	1.0				Initial version
10/9-97	1.0		BO		Remove the use of obsolete functions in PB 5.0	
************************************************************************************/



/* Long ll_row */

	/* ll_Row = GetClickedRow ()*/

	if row = 0 Then row = GetSelectedRow(0)

	If row > 0 Then SetRow(row)

	ScrollToRow(row)
	SelectRow(row,True)
	
	il_selectedrow = GetRow()
	uf_addbuttons()




end event

on rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_cross_select.dw_1
  
 Event	 : rowfocuschanged!

 Scope     : Global

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 17-07-96

 Description : Override ancestor's clicked event

 Arguments : None

 Returns   : None

 Variables :  None

 Other :

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
17-07-96		1.0					Initial version

************************************************************************************/
Long ll_row

ll_row = GetRow()

IF ll_row > 0 THEN
/* There are rows in dw_1 */

	If ll_row <> GetSelectedRow(0) Then
		SelectRow(0,False)
		SelectRow(ll_row,True)
		SetRow(ll_Row)
		ScrollToRow(ll_row)
	End if

	il_selectedrow = GetRow()
	uf_addbuttons()

	/* Get keyvalue for selected row in list*/

	CHOOSE CASE left(dw_1.describe(string(istr_param.list_key_column_name)+".ColType"),4)
		CASE "numb", "deci"
			il_key = dw_1.GetItemNumber(ll_row,istr_param.list_key_column_name)
		CASE ELSE
			is_key = dw_1.GetItemString(ll_row,istr_param.list_key_column_name)
	END CHOOSE

END IF



end on

on doubleclicked;call u_datawindow_sqlca::doubleclicked;uf_add_selected(dw_1.GetRow())
end on

