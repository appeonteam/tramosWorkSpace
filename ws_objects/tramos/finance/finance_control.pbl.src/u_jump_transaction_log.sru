$PBExportHeader$u_jump_transaction_log.sru
forward
global type u_jump_transaction_log from nonvisualobject
end type
end forward

global type u_jump_transaction_log from nonvisualobject
end type
global u_jump_transaction_log u_jump_transaction_log

forward prototypes
public subroutine of_open_translog (string as_txnumber)
end prototypes

public subroutine of_open_translog (string as_txnumber);IF Not IsValid(w_transaction_log_list) THEN
	Opensheet(w_transaction_log_list, w_tramos_main, 0, Original!)
END IF

w_transaction_log_list.SetRedraw(FALSE)
w_transaction_log_list.cbx_all.checked = False
w_transaction_log_list.cbx_all.Event Clicked()
w_transaction_log_list.cbx_disb_expenses.checked = true
w_transaction_log_list.cbx_disb_expenses.Event Clicked()
w_transaction_log_list.rb_transfered.checked = true
w_transaction_log_list.rb_transfered.Event Clicked()
w_transaction_log_list.sle_docno_from.text = mid(as_txnumber, 3, 10)
w_transaction_log_list.cb_retrieve_transactions.Post Event Clicked()
w_transaction_log_list.cb_open_transaction.Post Event Clicked()
w_transaction_log_list.SetRedraw(TRUE)
w_transaction_log_list.SetFocus()

Return

end subroutine

on u_jump_transaction_log.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_transaction_log.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

