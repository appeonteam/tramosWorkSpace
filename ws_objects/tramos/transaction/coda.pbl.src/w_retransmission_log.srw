$PBExportHeader$w_retransmission_log.srw
$PBExportComments$The window used to display the rettransmission log.
forward
global type w_retransmission_log from mt_w_response
end type
type st_found from statictext within w_retransmission_log
end type
type cb_close from commandbutton within w_retransmission_log
end type
type dw_retrans_log from datawindow within w_retransmission_log
end type
end forward

global type w_retransmission_log from mt_w_response
integer x = 1074
integer y = 484
integer width = 3223
integer height = 1920
string title = "Retransmission Log Window"
long backcolor = 81324524
st_found st_found
cb_close cb_close
dw_retrans_log dw_retrans_log
end type
global w_retransmission_log w_retransmission_log

type variables
datastore ids_retrans
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_retransmission_log
	
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
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_retransmission_log.create
int iCurrent
call super::create
this.st_found=create st_found
this.cb_close=create cb_close
this.dw_retrans_log=create dw_retrans_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_found
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_retrans_log
end on

on w_retransmission_log.destroy
call super::destroy
destroy(this.st_found)
destroy(this.cb_close)
destroy(this.dw_retrans_log)
end on

event open;/***********************************************************************************
Creator:	Teit Aunt
Date:		02-06-1999
Purpose:	Populates the datawindow
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
02-06-99		1.0		ta			Initial version
10-06-99		1.1		ta			The retrans window is opened with the row selected that 
										corresponds to the selected row in the log window.
************************************************************************************/
//s_retrans_log_argument ls_retrans_log_argument
//double ldb_key
//long ll_tmp, ll_rows
//boolean lb_found
//
//ll_tmp = 1

// Get the data from the messageobject
//ls_retrans_log_argument = Message.PowerObjectParm

// Share the data in the datastore with the data window
//ls_retrans_log_argument.lds_retrans.ShareData(dw_retrans_log)

// Retrieve and scroll to row

dw_retrans_log.setTransObject( sqlca)
dw_retrans_log.POST Retrieve()

//ll_rows = dw_retrans_log.RowCount()
//
//If (ll_rows > 0) and (ls_retrans_log_argument.ldb_key_no > 0) Then
//	DO
//		ldb_key = dw_retrans_log.GetItemNumber(ll_tmp,"trans_key")
//		If ldb_key = ls_retrans_log_argument.ldb_key_no Then
//			dw_retrans_log.SelectRow(ll_tmp,True)
//			dw_retrans_log.ScrollToRow(ll_tmp)
//			lb_found = true
//			st_found.Text = "Entry found"
//		End if
//		ll_tmp ++
//		If ll_tmp = ll_rows Then 
//			lb_found = True
//			st_found.Text = "No previouse history"
//		End if
//	LOOP UNTIL lb_found
//End if
//
//If (ll_rows = 0) And (ls_retrans_log_argument.ldb_key_no > 0) Then st_found.Text = "No rows"
//	
//If (ls_retrans_log_argument.ldb_key_no = 0) Then st_found.Text = "No previouse history"
//
end event

type st_found from statictext within w_retransmission_log
integer x = 690
integer y = 1720
integer width = 1166
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_retransmission_log
integer x = 2853
integer y = 1712
integer width = 334
integer height = 96
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		02-06-1999
Purpose:	Close the window
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
02-06-99		1.0		ta			Initial version
************************************************************************************/

Close(w_retransmission_log)
end event

type dw_retrans_log from datawindow within w_retransmission_log
integer x = 27
integer y = 20
integer width = 3159
integer height = 1664
integer taborder = 1
string dataobject = "d_retrans_log"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

