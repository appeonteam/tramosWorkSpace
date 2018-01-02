$PBExportHeader$u_tran_changeuser.sru
forward
global type u_tran_changeuser from transaction
end type
end forward

global type u_tran_changeuser from transaction
end type
global u_tran_changeuser u_tran_changeuser

type prototypes
SUBROUTINE sp_do_update_statistics() RPCFUNC ALIAS FOR "dbo.sp_do_update_statistics"

end prototypes

on u_tran_changeuser.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tran_changeuser.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

