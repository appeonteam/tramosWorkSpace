$PBExportHeader$w_disb_print_payment.srw
$PBExportComments$This window lets the user print a payment, either as a transfer or check payment.
forward
global type w_disb_print_payment from w_print_basewindow
end type
type gb_1 from groupbox within w_disb_print_payment
end type
type rb_1 from radiobutton within w_disb_print_payment
end type
type rb_2 from radiobutton within w_disb_print_payment
end type
end forward

global type w_disb_print_payment from w_print_basewindow
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
end type
global w_disb_print_payment w_disb_print_payment

type variables
s_disbursement lstr_disb

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_disb_print_payment
	<OBJECT>	</OBJECT>
   	<DESC>	</DESC>
   	<USAGE>	</USAGE>
   	<ALSO> 	</ALSO>
    	Date   		Ref    	Author   		Comments
  		00/00/07 	??? 		RMO      		First Version
		30/01/12  	CR2421	JMC112		Disable payment transaction
********************************************************************/
end subroutine

event open;call super::open;
//string ls_amount_as_string, ls_alfa_amount
//decimal {2} ld_payment_amount
//long ll_string_length, ll_counter, ll_pc_nr

lstr_disb = Message.PowerObjectParm

ib_autoclose = TRUE

//dw_print.Retrieve(lstr_disb.vessel_nr,lstr_disb.voyage_nr,lstr_disb.port_code,lstr_disb.pcn, lstr_disb.agent_nr, lstr_disb.payment_counter)
//ld_payment_amount = dw_print.GetItemNumber(1,"disb_payments_payment_amount")
//ls_amount_as_string = string(ld_payment_amount)
//ll_string_length = len(ls_amount_as_string)
//FOR ll_counter = 1 TO (ll_string_length - 3)
//	CHOOSE CASE mid(ls_amount_as_string,ll_counter,1)
//		CASE "0"
//			ls_alfa_amount = ls_alfa_amount + "Zero"
//		CASE "1"
//			ls_alfa_amount = ls_alfa_amount + "One"
//		CASE "2"
//			ls_alfa_amount = ls_alfa_amount + "Two"
//		CASE "3"
//			ls_alfa_amount = ls_alfa_amount + "Three"
//		CASE "4"
//			ls_alfa_amount = ls_alfa_amount + "Four"
//		CASE "5"
//			ls_alfa_amount = ls_alfa_amount + "Five"
//		CASE "6"
//			ls_alfa_amount = ls_alfa_amount + "Six"
//		CASE "7"
//			ls_alfa_amount = ls_alfa_amount + "Seven"
//		CASE "8"
//			ls_alfa_amount = ls_alfa_amount + "Eight"
//		CASE "9"
//			ls_alfa_amount = ls_alfa_amount + "Nine"
//	END CHOOSE
//	IF ll_counter < (ll_string_length - 3) THEN ls_alfa_amount = ls_alfa_amount + "-"
//NEXT
//ls_alfa_amount = ls_alfa_amount + " " + mid(ls_amount_as_string,(ll_string_length - 1),2) +"/100"
//dw_print.modify("amount_string.text='"+ls_alfa_amount+"'")
//  SELECT VESSELS.PC_NR  
//    INTO :ll_pc_nr
//    FROM VESSELS  
//   WHERE VESSELS.VESSEL_NR = :lstr_disb.vessel_nr   ;
//commit;
//if ll_pc_nr = 8 then
//	dw_print.modify("company_text_1.text='"+"071"+"'")
//	dw_print.modify("company_text_2.text='"+"071"+"'")
//end if
cb_print.SetFocus()
end event

on w_disb_print_payment.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
end on

on w_disb_print_payment.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
end on

type cbx_save_size from w_print_basewindow`cbx_save_size within w_disb_print_payment
end type

type dw_print from w_print_basewindow`dw_print within w_disb_print_payment
integer y = 172
integer taborder = 200
string dataobject = "dw_empty_cms"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_disb_print_payment
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_disb_print_payment
end type

type em_zoom from w_print_basewindow`em_zoom within w_disb_print_payment
integer taborder = 150
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_disb_print_payment
integer taborder = 190
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_disb_print_payment
integer taborder = 180
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_disb_print_payment
integer taborder = 170
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_disb_print_payment
integer taborder = 160
end type

type st_percent from w_print_basewindow`st_percent within w_disb_print_payment
end type

type st_1 from w_print_basewindow`st_1 within w_disb_print_payment
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_disb_print_payment
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_disb_print_payment
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_disb_print_payment
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_disb_print_payment
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_disb_print_payment
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_disb_print_payment
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_disb_print_payment
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_disb_print_payment
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_disb_print_payment
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_disb_print_payment
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_disb_print_payment
end type

type st_range from w_print_basewindow`st_range within w_disb_print_payment
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_disb_print_payment
integer taborder = 120
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_disb_print_payment
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_disb_print_payment
end type

type st_options_text from w_print_basewindow`st_options_text within w_disb_print_payment
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_disb_print_payment
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_disb_print_payment
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_disb_print_payment
integer x = 402
integer taborder = 140
end type

event cb_cancel::clicked;CloseWithReturn(Parent,-1)
Return
end event

type cb_print from w_print_basewindow`cb_print within w_disb_print_payment
integer width = 283
integer taborder = 130
string text = "&Generate"
end type

event cb_print::clicked;string ls_command, ls_tmp, ls_docname
Long ll_Row
Decimal {2} ld_payment_amount
Integer li_trans_ok

IF rb_2.Checked THEN 	
	if cbx_misc_collate_copies.checked then 
		 ls_command = ls_command + " datawindow.print.collate = yes" 
	else
		 ls_command = ls_command + " datawindow.print.collate = no"
	end if
	
	if rb_range_current.checked then
		  ll_row = dw_print.getrow ()
		  ls_tmp = dw_print.describe("evalute('Page()',"+String(ll_Row)+")")  
	elseif rb_range_pages.checked then
		  ls_tmp = sle_range_range.text
	else 
		  ls_tmp = ""
	End if
	
	ls_command = ls_command +  " datawindow.print.page.range = '"+ls_tmp+"'"
	if len(sle_options_no_copies.text) > 0 Then 
		 ls_command=ls_command + "datawindow.print.copies = "+sle_options_no_copies.text
	End if
	
	If cbx_misc_print_to_file.checked and sle_misc_print_file.text="" Then
		 ls_tmp = ""  
		 If GetFileSaveName("Print to file", ls_docname, ls_tmp, "PRN", "Print (*.PRN),*.PRN") = 1 then
			  sle_misc_print_file.text = ls_docname   
		 else
				return
		 end if
	end if
	
	if cbx_misc_print_to_file.checked then 
			ls_command = ls_command + " datawindow.print.filename = '"+sle_misc_print_file.text+"'"
	Else
			ls_command = ls_command + " datawindow.print.filename = '' "
	End If
	
	ls_tmp = dw_print.modify(ls_command)
	if len(ls_tmp) > 0 then 
		 messagebox("Error Setting Print Options", "Error message = " +ls_tmp +" ~r~nCommand = " + ls_command)
		return
	end if
	
	/////////////////////////////////////////////////////////
	// Check to see if negative payment, or positive payment // 
	////////////////////////////////////////////////////////
	ld_payment_amount = dw_print.GetItemNumber(1,"disb_payments_payment_amount")
	IF ld_payment_amount > 0 THEN 
		if dw_print.Print () <> 1 Then
			 messagebox("error", "print() returned with error")
			 Return
		End if
	ELSE
		CloseWithReturn(Parent,1)
		Return	
	END IF
END IF

CloseWithReturn(Parent,1)
Return
end event

type gb_misc_print from w_print_basewindow`gb_misc_print within w_disb_print_payment
end type

type gb_range from w_print_basewindow`gb_range within w_disb_print_payment
end type

type gb_options from w_print_basewindow`gb_options within w_disb_print_payment
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_disb_print_payment
end type

type gb_1 from groupbox within w_disb_print_payment
integer x = 18
integer y = 808
integer width = 1097
integer height = 360
integer taborder = 110
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Telex Transfer or Check"
end type

type rb_1 from radiobutton within w_disb_print_payment
integer x = 206
integer y = 916
integer width = 873
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Telex Transfer (no print)"
boolean checked = true
end type

event clicked;//string ls_amount_as_string, ls_alfa_amount
//decimal {2} ld_payment_amount
//long ll_string_length, ll_counter,ll_pc_nr

dw_print.DataObject = "dw_empty_cms"

//dw_print.SetTransObject(SQLCA)
//dw_print.Retrieve(lstr_disb.vessel_nr,lstr_disb.voyage_nr,lstr_disb.port_code,lstr_disb.pcn, lstr_disb.agent_nr, lstr_disb.payment_counter)
//
//ld_payment_amount = dw_print.GetItemNumber(1,"disb_payments_payment_amount")
//ls_amount_as_string = string(ld_payment_amount)
//ll_string_length = len(ls_amount_as_string)
//FOR ll_counter = 1 TO (ll_string_length - 3)
//	CHOOSE CASE mid(ls_amount_as_string,ll_counter,1)
//		CASE "0"
//			ls_alfa_amount = ls_alfa_amount + "Zero"
//		CASE "1"
//			ls_alfa_amount = ls_alfa_amount + "One"
//		CASE "2"
//			ls_alfa_amount = ls_alfa_amount + "Two"
//		CASE "3"
//			ls_alfa_amount = ls_alfa_amount + "Three"
//		CASE "4"
//			ls_alfa_amount = ls_alfa_amount + "Four"
//		CASE "5"
//			ls_alfa_amount = ls_alfa_amount + "Five"
//		CASE "6"
//			ls_alfa_amount = ls_alfa_amount + "Six"
//		CASE "7"
//			ls_alfa_amount = ls_alfa_amount + "Seven"
//		CASE "8"
//			ls_alfa_amount = ls_alfa_amount + "Eight"
//		CASE "9"
//			ls_alfa_amount = ls_alfa_amount + "Nine"
//	END CHOOSE
//	IF ll_counter < (ll_string_length - 3) THEN ls_alfa_amount = ls_alfa_amount + "-"
//NEXT
//ls_alfa_amount = ls_alfa_amount + " " + mid(ls_amount_as_string,(ll_string_length - 1),2) +"/100"
//dw_print.modify("amount_string.text='"+ls_alfa_amount+"'")
//  SELECT VESSELS.PC_NR  
//    INTO :ll_pc_nr
//    FROM VESSELS  
//   WHERE VESSELS.VESSEL_NR = :lstr_disb.vessel_nr   ;
//commit;
//if ll_pc_nr = 8 then
//	dw_print.modify("company_text_1.text='"+"071"+"'")
//	dw_print.modify("company_text_2.text='"+"071"+"'")
//end if
//dw_print.TriggerEvent(RetrieveEnd!)
//

end event

type rb_2 from radiobutton within w_disb_print_payment
integer x = 206
integer y = 1032
integer width = 873
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Check"
end type

event clicked;dw_print.DataObject = "dw_disb_print_payment_check"
dw_print.SetTransObject(SQLCA)
dw_print.Retrieve(lstr_disb.vessel_nr,lstr_disb.voyage_nr,lstr_disb.port_code,lstr_disb.pcn, lstr_disb.agent_nr, lstr_disb.payment_counter)
dw_print.Modify("date.text='"+fdate(Today())+"'")
dw_print.Modify("user.text='"+Upper(uo_global.Getuserid())+"/-'")
dw_print.TriggerEvent(RetrieveEnd!)
end event

