$PBExportHeader$u_drag_drop_boxes.sru
$PBExportComments$This object has 2 dw's from which you can drag and drop between, also use buttons between.
forward
global type u_drag_drop_boxes from mt_u_visualobject_calc
end type
type cb_msl from commandbutton within u_drag_drop_boxes
end type
type cb_mal from commandbutton within u_drag_drop_boxes
end type
type cb_msr from commandbutton within u_drag_drop_boxes
end type
type cb_mar from commandbutton within u_drag_drop_boxes
end type
type dw_left from u_dw_multiselect_dragdrop within u_drag_drop_boxes
end type
type dw_right from u_dw_multiselect_dragdrop within u_drag_drop_boxes
end type
type gb_1 from groupbox within u_drag_drop_boxes
end type
end forward

global type u_drag_drop_boxes from mt_u_visualobject_calc
integer width = 1147
integer height = 728
boolean border = false
long backcolor = 81324524
event ue_msr_clicked pbm_custom01
event ue_mar_clicked pbm_custom02
event ue_msl_clicked pbm_custom03
event ue_mal_clicked pbm_custom04
event ue_dw_changed pbm_custom06
cb_msl cb_msl
cb_mal cb_mal
cb_msr cb_msr
cb_mar cb_mar
dw_left dw_left
dw_right dw_right
gb_1 gb_1
end type
global u_drag_drop_boxes u_drag_drop_boxes

type variables
string is_sort_order[] = {"A"}
int ii_sort_column[] = {1}
end variables

forward prototypes
public function integer uf_set_frame_label (string as_frame_label)
public function integer uf_setleft_datawindow (string as_dw_name)
public function integer uf_setright_datawindow (string as_dw_name)
public function integer uf_set_right_dw_width (integer al_width_percent)
public function integer uf_set_left_dw_width (integer al_width_percent)
protected function integer uf_move_all (ref datawindow adw_from, ref datawindow adw_to)
public function integer uf_set_sort (string as_sort_order, integer ai_sort_column, integer ai_column_priority)
public function integer uf_set_height (integer al_height_percent)
protected function integer uf_move_selected (ref datawindow adw_from, ref datawindow adw_to)
public function integer uf_do_dws_match ()
public function integer uf_sort ()
public subroutine documentation ()
end prototypes

on ue_msr_clicked;call mt_u_visualobject_calc::ue_msr_clicked;/* Call function to move selected rows */
uf_move_selected(dw_left,dw_right)
end on

on ue_mar_clicked;call mt_u_visualobject_calc::ue_mar_clicked;/* Call function to move all rows */
uf_move_all(dw_left,dw_right)
end on

on ue_msl_clicked;call mt_u_visualobject_calc::ue_msl_clicked;/* Call function to move selected rows */
uf_move_selected(dw_right,dw_left)
end on

on ue_mal_clicked;call mt_u_visualobject_calc::ue_mal_clicked;/* Call function to move all rows */
uf_move_all(dw_right,dw_left)
end on

public function integer uf_set_frame_label (string as_frame_label);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : u_drag_drop_boxes
  
 Event	 : n/a

 Scope     : public

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 08-10-96

 Description : Sets the frame label

 Arguments : as_frame_label - string to place into label

 Returns   : 	1 if all well
			-1 if fails

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
08-10-96 		3.0			PBT		System 3
************************************************************************************/
/* Set label to given string */
gb_1.text = as_frame_label
/* Returns 0 as nothing to test */
return 1



end function

public function integer uf_setleft_datawindow (string as_dw_name);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : u_drag_drop_boxes
  
 Event	 : n/a

 Scope     : public

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 08-10-96

 Description : This function sets the left datawindow control to the
			given dw object and sets transaction object.

 Arguments : as_dw_name - name of dw object to connect control to.

 Returns   : 	-1 error
			1 no error

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
08-10-96 		3.0			PBT		System 3
************************************************************************************/
/* set the left dw control to the given dw object */
dw_left.dataobject = as_dw_name
/* test to see if connection worked and set transaction object and return relevant code */
if isnull(dw_left.describe("dataobject")) or dw_left.describe("dataobject") = "" then
	return -1
else
	if dw_left.settransobject(sqlca) = -1 then
		return -1
	else
		return 1
	end if
end if
end function

public function integer uf_setright_datawindow (string as_dw_name);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : u_drag_drop_boxes
  
 Event	 : n/a

 Scope     : public

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 08-10-96

 Description : This function sets the right datawindow control to the
			given dw object.

 Arguments : as_dw_name - name of dw object to connect control to.

 Returns   : 	-1 error
			1 no error

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
08-10-96 		3.0			PBT		System 3
************************************************************************************/
/* set the right dw control to the given dw object */
dw_right.dataobject = as_dw_name
/* test to see if connection worked and set transaction object and return relevant code */
if isnull(dw_right.describe("dataobject")) or dw_right.describe("dataobject") = "" then
	return -1
else
	if dw_right.settransobject(sqlca) = -1 then
		return -1
	else
		return 1
	end if
end if
end function

public function integer uf_set_right_dw_width (integer al_width_percent);/* Local Variables */
long ll_new_width, ll_extra_width

/* Set right dw to new size and resize frame */
ll_new_width = dw_right.width * (al_width_percent/100)
ll_extra_width = (dw_right.width * (al_width_percent/100)) - dw_right.width
dw_right.width = ll_new_width
this.width += ll_extra_width
gb_1.width += ll_extra_width
return 1
end function

public function integer uf_set_left_dw_width (integer al_width_percent);/* Local Variables */
long ll_new_width, ll_extra_width

/* Set left dw new size, resize frame, and move buttons and right dw */
ll_new_width = dw_left.width * (al_width_percent/100)
ll_extra_width = (dw_left.width * (al_width_percent/100)) - dw_left.width
dw_left.width = ll_new_width
this.width += ll_extra_width
gb_1.width += ll_extra_width
cb_msl.x += ll_extra_width
cb_mal.x += ll_extra_width
cb_msr.x += ll_extra_width
cb_mar.x += ll_extra_width
dw_right.x += ll_extra_width
return 1
end function

protected function integer uf_move_all (ref datawindow adw_from, ref datawindow adw_to);/* Move all rows from one dw to the other */
adw_from.RowsMove ( 1, adw_from.rowcount(), Primary!, adw_to, 40000, Primary! )

/* sort dw's */
this.uf_sort()

/* Post controls changed event */
Postevent("ue_dw_changed")

return 1

end function

public function integer uf_set_sort (string as_sort_order, integer ai_sort_column, integer ai_column_priority);/* set instance sort variables for control */
is_sort_order[ai_column_priority] = as_sort_order
ii_sort_column[ai_column_priority] = ai_sort_column
return 1
end function

public function integer uf_set_height (integer al_height_percent);/* Local Variables */
long ll_extra_height

if al_height_percent < 60 then al_height_percent = 60

/* Set  */
ll_extra_height =  (dw_left.height * (al_height_percent/100)) - dw_left.height 
dw_left.height += ll_extra_height
dw_right.height += ll_extra_height
this.height += ll_extra_height
gb_1.height += ll_extra_height



long ll_temp
ll_temp = (((dw_left.height - (4 * cb_mar.height)) / 3) + cb_mar.height)

cb_mar.y = cb_msr.y + ll_temp

cb_msl.y =  cb_mar.y + ll_temp

cb_mal.y =  cb_msl.y + ll_temp



return 1
end function

protected function integer uf_move_selected (ref datawindow adw_from, ref datawindow adw_to);/* Local Variables */
Long ll_row_counter, ll_rows_in_from_dw

/* Get how many rows are in the "from" dw */
ll_rows_in_from_dw = adw_from.rowcount()

/* Test to see if dw's match for transfer */
if uf_do_dws_match() = -1 then return -1

/* Set redraw off */
this.setredraw(FALSE)

/* Move selected rows from left to right dw */
for ll_row_counter = 1 to ll_rows_in_from_dw
	if adw_from.isselected(ll_row_counter) then
		adw_from.RowsMove ( ll_row_counter, ll_row_counter, Primary!, adw_to, 40000, Primary! )
		ll_rows_in_from_dw --
		ll_row_counter --
	end if
next

/* sort dw's */
this.uf_sort()

/* Set redraw on */
this.setredraw(true)

/* Post controls changed event */
Postevent("ue_dw_changed")

return 1

end function

public function integer uf_do_dws_match ();/* Set local Variables */
Long ll_columns_in_left_dw, ll_columns_in_right_dw

/* Count columns in both dw's */
ll_columns_in_left_dw = long(dw_left.Describe("DataWindow.Column.Count"))
ll_columns_in_right_dw = long(dw_right.Describe("DataWindow.Column.Count"))

/* If column count of dw's does not match, inform user and fail */
if ll_columns_in_left_dw <>  ll_columns_in_right_dw then
	messagebox("uf_do_dws_match","The left Datawindow has " + string(ll_columns_in_left_dw) + " columns, while " +&
			"the right Datawindow has " + string(ll_columns_in_right_dw) + " Columns.~r~n" + &
			"The function has failed!")
	return -1
end if

/* This next section should test if column types match in dw's */
//messagebox("uf_do_dws_match","Col type is " + dw_left.Describe("1.Coltype"))
//CHOOSE CASE ll_columns_in_left_dw
//	CASE 1
//		<statementblock>
//	CASE 2
//		<statementblock>
//	CASE 3
//		<statementblock>
//	CASE 4
//		<statementblock>
//	CASE ELSE
//		<statementblock>
//END CHOOSE


return 1
end function

public function integer uf_sort ();
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : PBT
   
 Date       : 1996

 Description : 

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
4-3-98				MI		Fixed a bug that made the right datawindow sort only on the
								first column.
************************************************************************************/


/* define local variables */
string ls_left_sort_string = "", ls_right_sort_string = ""
long ll_counter

/* if vessel, tank grades don't set sort order */
if dw_left.dataObject <> "d_tank_grades_left" then
	/* create the dw's sort order strings */
	for ll_counter = 1 to upperbound(ii_sort_column)
		if ls_left_sort_string <> "" then ls_left_sort_string += ", "
		ls_left_sort_string += "#" + string(ii_sort_column[ll_counter]) + " " +  is_sort_order[ll_counter]
		if ls_right_sort_string <> "" then ls_right_sort_string += ", "
		ls_right_sort_string += "#" + string(ii_sort_column[ll_counter]) + " " +  is_sort_order[ll_counter]
	next
	
	/* set the dw's sort order strings */
	dw_left.setsort(ls_left_sort_string)
	dw_right.setsort(ls_right_sort_string) 
end if

/* sort the dw's */
dw_left.sort()
dw_right.sort()


return 1
end function

public subroutine documentation ();/********************************************************************
   u_drag_drop_boxes
	<OBJECT>
	</OBJECT>
  	<DESC>	</DESC>
  	<USAGE>	</USAGE>
  	<ALSO>	</ALSO>
	<HISTORY>
		Date    		Ref   	Author		Comments
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
	</HISTORY>
********************************************************************/
end subroutine

on ue_retrieve;call mt_u_visualobject_calc::ue_retrieve;uf_redraw_off()

/* Clear this objects dw's */
this.dw_left.reset()
this.dw_right.reset()

/* Post this objects changed event */
this.postevent("ue_dw_changed")

uf_redraw_on()
end on

on constructor;call mt_u_visualobject_calc::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : n/a
  
 Object     : u_drag_drop_boxes
  
 Event	 : constructor

 Scope     : n/a

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 09-10-96

 Description : This Custom Control lets you create an object that has
two datawindows, one on the left and one of the right of standard
move buttons. You set the datawindows to specific objects, and the
control has all the functionality required. There are some functions you
must call from the constructor event when you use this control :
Mandatory Function calls :
	this.uf_setleft_datawindow("<dw name>")
	Sets left dw in control (Place in constructor event)

	this.uf_setright_datawindow("<dw name>")
	Sets right dw in control (Place in constructor event)

Optional Functions
	dw_left.retrieve( {,arg,arg...} )
	Retrieves left dw (Placed in ue_retrieve - Auto triggered)

	dw_right.retrieve( {,arg,arg...} )
	Retrieves right dw (Placed in ue_retrieve - Auto triggered)

	this.uf_set_frame_label("<text>")
	Sets frame label

	uo_1.uf_set_left_dw_width(<value>)
	Sets left dw width (% of original) eg. uf_set_left_dw_width(120)
	would set the datawindow 20% wider.

	uo_1.uf_set_right_dw_width(<value>)	
	Sets right dw width (% of original)

	uf_set_sort([ "A" | "D" ],[ 1 | 2 | 3 | ... ] ,[<priority>])
	sets sort order(A = ASC, D = DSC) and column to sort by.
	priority, is if this is the first sort etc in cascade sorts.

	uf_sort()
	sorts the dw's, onæy do this after retrieve. The object
	does it automatically while moving from side to side.


 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Using this controæ with twp dw's that are not the same could give problems

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
09-10-96 		3.0			PBT		System 3
************************************************************************************/
/* Post the retrieve event for controæ */
this.postevent("ue_retrieve")
end on

on u_drag_drop_boxes.create
int iCurrent
call super::create
this.cb_msl=create cb_msl
this.cb_mal=create cb_mal
this.cb_msr=create cb_msr
this.cb_mar=create cb_mar
this.dw_left=create dw_left
this.dw_right=create dw_right
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_msl
this.Control[iCurrent+2]=this.cb_mal
this.Control[iCurrent+3]=this.cb_msr
this.Control[iCurrent+4]=this.cb_mar
this.Control[iCurrent+5]=this.dw_left
this.Control[iCurrent+6]=this.dw_right
this.Control[iCurrent+7]=this.gb_1
end on

on u_drag_drop_boxes.destroy
call super::destroy
destroy(this.cb_msl)
destroy(this.cb_mal)
destroy(this.cb_msr)
destroy(this.cb_mar)
destroy(this.dw_left)
destroy(this.dw_right)
destroy(this.gb_1)
end on

type cb_msl from commandbutton within u_drag_drop_boxes
integer x = 498
integer y = 420
integer width = 142
integer height = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "<"
end type

on dragenter;/* set drag icon to dragging hand if this control is in drag mode */
if dw_left.ib_dragging or dw_right.ib_dragging then dragicon = "images\drag.ico"
end on

on clicked;/* Trigger event for Move Selected Left */
parent.Triggerevent("ue_msl_clicked")
end on

type cb_mal from commandbutton within u_drag_drop_boxes
integer x = 498
integer y = 604
integer width = 142
integer height = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "<<"
end type

on dragenter;/* set drag icon to dragging hand if this control is in drag mode */
if dw_left.ib_dragging or dw_right.ib_dragging then dragicon = "images\drag.ico"
end on

on clicked;/* Trigger event for Move All Right */
parent.Triggerevent("ue_mal_clicked")
end on

type cb_msr from commandbutton within u_drag_drop_boxes
integer x = 498
integer y = 52
integer width = 142
integer height = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">"
end type

on clicked;/* Trigger event for Move Selected Right */
parent.Triggerevent("ue_msr_clicked")
end on

on dragenter;/* set drag icon to dragging hand if this control is in drag mode */
if dw_left.ib_dragging or dw_right.ib_dragging then dragicon = "images\drag.ico"
end on

type cb_mar from commandbutton within u_drag_drop_boxes
integer x = 498
integer y = 236
integer width = 142
integer height = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">>"
end type

on dragenter;/* set drag icon to dragging hand if this control is in drag mode */
if dw_left.ib_dragging or dw_right.ib_dragging then dragicon = "images\drag.ico"
end on

on clicked;/* Trigger event for Move All Right */
parent.Triggerevent("ue_mar_clicked")
end on

type dw_left from u_dw_multiselect_dragdrop within u_drag_drop_boxes
integer x = 23
integer y = 52
integer width = 439
integer height = 652
integer taborder = 0
string dataobject = "d_profit_center_name"
boolean vscrollbar = true
end type

on dragdrop;call u_dw_multiselect_dragdrop::dragdrop;/* Check to see if drag is from this control */
if dw_right.ib_dragging then
	/* Move selected rows */
	parent.uf_move_selected(dw_right,dw_left)
end if
end on

on dragenter;call u_dw_multiselect_dragdrop::dragenter;/* set drag icon to dragging hand if this control is in drag mode */
if dw_left.ib_dragging or dw_right.ib_dragging then dragicon = "images\drag.ico"
end on

type dw_right from u_dw_multiselect_dragdrop within u_drag_drop_boxes
integer x = 677
integer y = 52
integer width = 439
integer height = 652
integer taborder = 0
string dataobject = "d_profit_center_name"
boolean vscrollbar = true
end type

on dragenter;call u_dw_multiselect_dragdrop::dragenter;/* set drag icon to dragging hand if this control is in drag mode */
if dw_left.ib_dragging or dw_right.ib_dragging then dragicon = "images\drag.ico"
end on

on dragdrop;call u_dw_multiselect_dragdrop::dragdrop;/* Check to see if drag is from this control */
if dw_left.ib_dragging then
	/* Move selected rows */
	parent.uf_move_selected(dw_left,dw_right)
end if
end on

type gb_1 from groupbox within u_drag_drop_boxes
integer width = 1138
integer height = 724
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "none"
end type

