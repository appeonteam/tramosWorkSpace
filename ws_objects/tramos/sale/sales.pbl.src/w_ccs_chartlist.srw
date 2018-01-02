$PBExportHeader$w_ccs_chartlist.srw
$PBExportComments$This window lists the charterers for the salessystem.
forward
global type w_ccs_chartlist from w_list
end type
end forward

global type w_ccs_chartlist from w_list
end type
global w_ccs_chartlist w_ccs_chartlist

forward prototypes
public subroutine wf_ccs_open_detail ()
end prototypes

public subroutine wf_ccs_open_detail ();//w_ccs_chart mydata
//Window mywindow
//
//If (IsNull(istr_parametre.edit_window_title)) Or (istr_parametre.edit_window_title = "")  Then &
//	istr_parametre.edit_window_title = Istr_parametre.window_title
//
//If Not IsNull(istr_parametre.edit_datawindow) Then
//	OpenSheetWithParm( mydata, istr_parametre, w_main, 7, Original!)
//Elseif Not IsNull(istr_parametre.edit_window) Then
//	If ib_column_string[0] Then
//		OpenSheetWithParm(mywindow, istr_parametre.edit_key_text, istr_parametre.edit_window,  w_main, 7, original!)
//	else
//		OpenSheetWithParm(mywindow,  istr_parametre.edit_key_number, istr_parametre.edit_window, w_main, 7, original!)
//	end if
//end if
//
//
end subroutine

on open;call w_list::open;/* Indicate charterer */
istr_parametre.additional_numbers[1] = 1

/* Sort on long name */

wf_select_column(2)
end on

on w_ccs_chartlist.create
call w_list::create
end on

on w_ccs_chartlist.destroy
call w_list::destroy
end on

type cb_modify from w_list`cb_modify within w_ccs_chartlist
boolean Enabled=true
boolean Default=true
end type

type cb_delete from w_list`cb_delete within w_ccs_chartlist
boolean Visible=false
end type

type cb_new from w_list`cb_new within w_ccs_chartlist
boolean Visible=false
boolean Enabled=false
end type

type cb_refresh from w_list`cb_refresh within w_ccs_chartlist
int Y=321
boolean Visible=false
end type

type rb_header1 from w_list`rb_header1 within w_ccs_chartlist
boolean Checked=false
end type

type rb_header2 from w_list`rb_header2 within w_ccs_chartlist
boolean Checked=true
end type

type cb_ok from w_list`cb_ok within w_ccs_chartlist
boolean Visible=false
end type

