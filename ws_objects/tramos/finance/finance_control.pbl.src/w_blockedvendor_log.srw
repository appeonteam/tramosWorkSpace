$PBExportHeader$w_blockedvendor_log.srw
$PBExportComments$Shows history of Blocked Vendors
forward
global type w_blockedvendor_log from w_sheet
end type
type cb_print from commandbutton within w_blockedvendor_log
end type
type cb_close from commandbutton within w_blockedvendor_log
end type
type dw_log from u_dw within w_blockedvendor_log
end type
end forward

global type w_blockedvendor_log from w_sheet
integer x = 214
integer y = 221
integer width = 4224
integer height = 2420
string title = "Blocked Vendors Log"
cb_print cb_print
cb_close cb_close
dw_log dw_log
end type
global w_blockedvendor_log w_blockedvendor_log

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
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_blockedvendor_log.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_log=create dw_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_log
end on

on w_blockedvendor_log.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_log)
end on

event pfc_postopen;call super::pfc_postopen;move(0,0)
this.of_setResize( TRUE )
//dw_log.of_setResize( TRUE )
this.inv_resize.of_register(dw_log, this.inv_resize.SCALERIGHTBOTTOM)
this.inv_resize.of_Register(cb_print, this.inv_resize.FIXEDRIGHTBOTTOM)
this.inv_resize.of_Register(cb_close, this.inv_resize.FIXEDRIGHTBOTTOM)

end event

type cb_print from commandbutton within w_blockedvendor_log
integer x = 3383
integer y = 2172
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_log.print()
end event

type cb_close from commandbutton within w_blockedvendor_log
integer x = 3808
integer y = 2172
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_log from u_dw within w_blockedvendor_log
integer x = 18
integer y = 12
integer width = 4133
integer height = 2112
integer taborder = 10
string dataobject = "d_sq_tb_blockedvendor_view"
boolean hscrollbar = true
end type

event pfc_retrieve;call super::pfc_retrieve;return this.retrieve()
end event

event constructor;call super::constructor;of_SetTransObject(sqlca) 

of_SetSort(true) 

//inv_sort.of_SetStyle(inv_sort.DRAGDROP)
inv_sort.of_SetColumnNameSource(inv_sort.HEADER)
inv_sort.of_SetVisibleOnly(true)
inv_sort.of_SetColumnHeader(true)
inv_sort.of_SetUseDisplay(true)
of_SetUpdateable(false)
of_setRowManager(false)
ib_rmbmenu = false

of_retrieve()
end event

