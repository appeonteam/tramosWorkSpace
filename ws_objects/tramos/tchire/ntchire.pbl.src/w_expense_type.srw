$PBExportHeader$w_expense_type.srw
$PBExportComments$Window for maintaining expense types
forward
global type w_expense_type from mt_w_sheet
end type
type cb_cancel from commandbutton within w_expense_type
end type
type cb_close from commandbutton within w_expense_type
end type
type cb_delete from commandbutton within w_expense_type
end type
type cb_update from commandbutton within w_expense_type
end type
type cb_new from commandbutton within w_expense_type
end type
type rb_filter_contract from radiobutton within w_expense_type
end type
type rb_filter_non-port from radiobutton within w_expense_type
end type
type rb_filter_all from radiobutton within w_expense_type
end type
type dw_expense_type_list from datawindow within w_expense_type
end type
type dw_expense_type_details from datawindow within w_expense_type
end type
type gb_filter from groupbox within w_expense_type
end type
end forward

global type w_expense_type from mt_w_sheet
integer width = 4023
integer height = 1348
string title = "T/C Income/Expense Types"
boolean maxbox = false
boolean resizable = false
boolean center = false
cb_cancel cb_cancel
cb_close cb_close
cb_delete cb_delete
cb_update cb_update
cb_new cb_new
rb_filter_contract rb_filter_contract
rb_filter_non-port rb_filter_non-port
rb_filter_all rb_filter_all
dw_expense_type_list dw_expense_type_list
dw_expense_type_details dw_expense_type_details
gb_filter gb_filter
end type
global w_expense_type w_expense_type

type variables
n_tc_exp_type iuo_expense

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14		CR3781	CCY018			Modified ancestor and the window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_expense_type.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_close=create cb_close
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_new=create cb_new
this.rb_filter_contract=create rb_filter_contract
this.rb_filter_non-port=create rb_filter_non-port
this.rb_filter_all=create rb_filter_all
this.dw_expense_type_list=create dw_expense_type_list
this.dw_expense_type_details=create dw_expense_type_details
this.gb_filter=create gb_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.rb_filter_contract
this.Control[iCurrent+7]=this.rb_filter_non-port
this.Control[iCurrent+8]=this.rb_filter_all
this.Control[iCurrent+9]=this.dw_expense_type_list
this.Control[iCurrent+10]=this.dw_expense_type_details
this.Control[iCurrent+11]=this.gb_filter
end on

on w_expense_type.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_close)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_new)
destroy(this.rb_filter_contract)
destroy(this.rb_filter_non-port)
destroy(this.rb_filter_all)
destroy(this.dw_expense_type_list)
destroy(this.dw_expense_type_details)
destroy(this.gb_filter)
end on

event open;// -------------------------------------------
this.move(0,0)
iuo_expense = CREATE n_tc_exp_type
iuo_expense.of_share_on(dw_expense_type_list, dw_expense_type_details)

iuo_expense.POST of_retrieve_list()
dw_expense_type_list. post event clicked(0,0,1,dw_expense_type_list.object)

/* Admin and finance profile have access */
if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3 then 
	dw_expense_type_details.object.datawindow.readonly = 'No'
	cb_new.enabled = true 
	cb_update.enabled = true 
	cb_delete.enabled = true
	cb_cancel.enabled = true
else
	dw_expense_type_details.object.datawindow.readonly = 'Yes'
	cb_new.enabled = false 
	cb_update.enabled = false 
	cb_delete.enabled = false
	cb_cancel.enabled = false
end if
end event

event closequery;string ls_error_text

dw_expense_type_details.accepttext()
//Check if data has been modified and notify user accordingly before closing
if dw_expense_type_details.modifiedcount() > 0 then
	if messagebox("Data not saved!","Data in the current record has been modified, " +&
						"but not saved.~r~nWould you like to update data before closing the window?"&
						,Question!,YesNo!,1) = 1 then //validate and save changes before closing the window
			if iuo_expense.of_validate(ls_error_text) = -1 then //validate error
				MessageBox ("Validation Error", ls_error_text, StopSign!)
				Return 1 //i.e. do not close window
			end if //validate error
			if iuo_expense.of_update(ls_error_text) = -1 then //update error
				MessageBox ("Update Error", ls_error_text, StopSign!)
				Return 1 //i.e. do not close window
			end if //update error
	end if //Messagebox
end if //data modified
//Data has not been modified (or data has now been saved) - just close...
return 0 //allow the window to be closed
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_expense_type
end type

type cb_cancel from commandbutton within w_expense_type
integer x = 2537
integer y = 1140
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&ancel"
boolean cancel = true
end type

event clicked;dw_expense_type_details.reset()
//iuo_expense.POST of_retrieve_detail(dw_expense_type_list.getitemnumber(getrow(),"exp_type_id"))
dw_expense_type_list. post event clicked(0,0,dw_expense_type_list.getrow(),dw_expense_type_list.object)
end event

type cb_close from commandbutton within w_expense_type
integer x = 3634
integer y = 1140
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_delete from commandbutton within w_expense_type
integer x = 3269
integer y = 1140
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;string ls_error_text

if messagebox("Confirm deleting record","Are you sure you want to delete this record?",Exclamation!,yesno!) = 1 then
		if iuo_expense.of_delete(ls_error_text) = -1 then 
			MessageBox ("Delete Error", ls_error_text )
		Return
		end if
else
	return
end if

iuo_expense.of_retrieve_list()
dw_expense_type_list.POST EVENT clicked(0,0,1,dw_expense_type_list.object)
end event

type cb_update from commandbutton within w_expense_type
integer x = 2171
integer y = 1140
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
end type

event clicked;string ls_error_text
int li_type_id, li_row_no

dw_expense_type_details.AcceptText()

if iuo_expense.of_validate(ls_error_text) = -1 then 
	MessageBox ("Validation Error", ls_error_text, StopSign! )
	Return
end if

if iuo_expense.of_update(ls_error_text) = -1 then 
	MessageBox ("Update Error", ls_error_text, StopSign! )
	Return
end if

iuo_expense.of_retrieve_list()
li_type_id = dw_expense_type_details.getitemnumber(1,"exp_type_id")
li_row_no = dw_expense_type_list.find("exp_type_id = " + string(li_type_id),0,dw_expense_type_list.rowcount())
dw_expense_type_list.scrolltorow(li_row_no)
dw_expense_type_list.selectrow(li_row_no,true)
end event

type cb_new from commandbutton within w_expense_type
integer x = 2903
integer y = 1140
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&New"
end type

event clicked;string ls_error_text

dw_expense_type_details.accepttext()
//Check if data has been modified and notify user accordingly before inserting new entry
if dw_expense_type_details.modifiedcount() > 0 then
	if messagebox("Data not saved!","Data in the current record has been modified, " +&
						"but not saved.~r~nWould you like to update data before inserting a new entry?"&
						,Question!,YesNo!,1) = 1 then //save changes before inserting a row
			if iuo_expense.of_validate(ls_error_text) = -1 then //validate error
				MessageBox ("Validation Error", ls_error_text, StopSign! )
				Return
			end if //validate error
			if iuo_expense.of_update(ls_error_text) = -1 then //update error
				MessageBox ("Update Error", ls_error_text, StopSign! )
				Return
			end if //update error
			iuo_expense.of_retrieve_list()
	end if //Messagebox
end if //data modified
//Data has not been modified (or data has now been saved) - just insert a new row
dw_expense_type_list.Selectrow(0, False)
iuo_expense.of_insert_row()
dw_expense_type_details.setitem(1, "non_port_exp", 1)
setfocus(dw_expense_type_details)

end event

type rb_filter_contract from radiobutton within w_expense_type
integer x = 1769
integer y = 812
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contract"
end type

event clicked;dw_expense_type_list.setfilter("non_port_exp = 0")
dw_expense_type_list.filter()
dw_expense_type_list. post event clicked(0,0,1,dw_expense_type_list.object)
end event

type rb_filter_non-port from radiobutton within w_expense_type
integer x = 1408
integer y = 812
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Non-port"
end type

event clicked;dw_expense_type_list.setfilter("non_port_exp = 1")
dw_expense_type_list.filter()
dw_expense_type_list. post event clicked(0,0,1,dw_expense_type_list.object)
end event

type rb_filter_all from radiobutton within w_expense_type
integer x = 1198
integer y = 812
integer width = 210
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
boolean checked = true
end type

event clicked;int li_row_no, li_type_id
dw_expense_type_list.setfilter("")
dw_expense_type_list.filter()

li_type_id = dw_expense_type_details.getitemnumber(1,"exp_type_id")
li_row_no = dw_expense_type_list.find("exp_type_id = " + string(li_type_id),0,dw_expense_type_list.rowcount())
dw_expense_type_list.scrolltorow(li_row_no)
dw_expense_type_list.selectrow(0,false)
dw_expense_type_list.selectrow(li_row_no,true)
end event

type dw_expense_type_list from datawindow within w_expense_type
integer x = 5
integer width = 1129
integer height = 1228
string title = "none"
string dataobject = "d_expense_type_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	if row = 1 and this.rowcount() = 0 then 
		iuo_expense.of_insert_row()
		dw_expense_type_details.setitem(1, "non_port_exp", 1)
		return
	end if
	this.selectrow(0,false)
	this.selectrow(row,true)
	iuo_expense.POST of_retrieve_detail(this.getitemnumber(row,"exp_type_id"))
end if
	
	
end event

type dw_expense_type_details from datawindow within w_expense_type
integer x = 1152
integer width = 2848
integer height = 684
integer taborder = 10
string title = "none"
string dataobject = "d_expense_type_detail"
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;if row < 1 then return

if dwo.name = "non_port_exp" then
	if data = "0" then
		this.setItem(row, "final_hire", 0)
		this.setItem(row, "opsa_setup", 0)
	end if
end if
end event

type gb_filter from groupbox within w_expense_type
integer x = 1179
integer y = 732
integer width = 1056
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter - Expense type"
end type

