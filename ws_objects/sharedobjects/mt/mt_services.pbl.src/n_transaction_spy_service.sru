$PBExportHeader$n_transaction_spy_service.sru
$PBExportComments$Used to monitor transactions to database
forward
global type n_transaction_spy_service from mt_n_baseservice
end type
end forward

global type n_transaction_spy_service from mt_n_baseservice
end type
global n_transaction_spy_service n_transaction_spy_service

type variables
datastore	ids_monitorMessage


end variables

forward prototypes
public subroutine documentation ()
public function integer of_addmonitordetail (powerobject apo_classdef, string as_method, string as_sqlsyntax)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
********************************************************************/


/*  


Monitor levels: 0 = No logging, 1 = Log to db, 2 = Log to file

maybe by default we should send the content eg. of the sqlpreview
to the capture window...

*/
end subroutine

public function integer of_addmonitordetail (powerobject apo_classdef, string as_method, string as_sqlsyntax);classdefinition cd_sentfrom
cd_sentfrom=apo_classdef

long ll_row


ll_row = ids_monitormessage.insertRow(0)

if ll_row < 1 then return c#return.failure

ids_monitormessage.setItem(ll_row, "classname", cd_sentfrom.name )
ids_monitormessage.setItem(ll_row, "method", as_method )
ids_monitormessage.setItem(ll_row, "sqlsyntax", as_sqlsyntax)

// check window
if not isvalid(w_transaction_spy) then openwithparm(w_transaction_spy, ids_monitormessage)


return c#return.success
end function

on n_transaction_spy_service.create
call super::create
end on

on n_transaction_spy_service.destroy
call super::destroy
end on

event constructor;call super::constructor;
ids_monitorMessage = create datastore

ids_monitorMessage.dataObject = "d_ex_tb_sqlsyntax_transaction"




end event

event destructor;call super::destructor;destroy ids_monitorMessage
end event

