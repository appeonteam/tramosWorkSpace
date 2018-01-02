$PBExportHeader$w_system_error.srw
$PBExportComments$Displays system error information; called in the systemerror event of the application
forward
global type w_system_error from mt_w_response
end type
type dw_error from datawindow within w_system_error
end type
type cb_print from commandbutton within w_system_error
end type
type cb_exit from commandbutton within w_system_error
end type
type cb_continue from commandbutton within w_system_error
end type
end forward

global type w_system_error from mt_w_response
integer x = 320
integer y = 420
integer width = 2135
integer height = 1356
string title = "System Error"
boolean controlmenu = false
dw_error dw_error
cb_print cb_print
cb_exit cb_exit
cb_continue cb_continue
end type
global w_system_error w_system_error

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_system_error
	
	<OBJECT>
		window displayed when runtime error is thrown
	</OBJECT>
   <DESC>
		Provides user with detail of where runtime error occurred.  
		Recommended that user restarts Tramos session if this window is displayed.
	</DESC>
  	<USAGE>
		Called from the systemerror event in the application object
	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	05/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

on open;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.open
//
// Purpose:
// 			Displays system errors and allows the user to either continue
//				running the application, exit the application, or print the 
//				error message.  Called from the systemerror event in the
//				application object.
//
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

dw_error.insertrow (1)

dw_error.setitem (1,"errornum",string(error.number))
dw_error.setitem (1,"message" ,error.text)
dw_error.setitem (1,"where"   ,error.windowmenu)
dw_error.setitem (1,"object"  ,error.object)
dw_error.setitem (1,"event"   ,error.objectevent)
dw_error.setitem (1,"line"    ,string(error.line))

dw_error.setitem (1,"userid"    ,string(uo_global.getuserid()))
if NOT string(uo_global.getvessel_nr()) = "" and NOT isnull(string(uo_global.getvessel_nr())) then
	dw_error.setitem (1,"vessel"    ,string(uo_global.getvessel_nr()))
end if
if NOT string(uo_global.getvoyage_nr()) = "" and NOT isnull(string(uo_global.getvoyage_nr())) then
	dw_error.setitem (1,"voyage"    ,string(uo_global.getvoyage_nr()))
end if
if NOT string(uo_global.getport_code()) = "" and NOT isnull(string(uo_global.getport_code())) then
	dw_error.setitem (1,"port"    ,string(uo_global.getport_code()))
end if
end on

on w_system_error.create
int iCurrent
call super::create
this.dw_error=create dw_error
this.cb_print=create cb_print
this.cb_exit=create cb_exit
this.cb_continue=create cb_continue
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_error
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_exit
this.Control[iCurrent+4]=this.cb_continue
end on

on w_system_error.destroy
call super::destroy
destroy(this.dw_error)
destroy(this.cb_print)
destroy(this.cb_exit)
destroy(this.cb_continue)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_system_error
end type

type dw_error from datawindow within w_system_error
integer x = 14
integer y = 16
integer width = 2085
integer height = 1100
integer taborder = 10
boolean enabled = false
string dataobject = "d_system_error"
end type

type cb_print from commandbutton within w_system_error
integer x = 1531
integer y = 1148
integer width = 562
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.cb_print.clicked!
//
// Purpose:
// 			Event cb_print.clicked - Print the current error message
//				and write the error message to the supplied file name.
//
// Log:
// 
//  DATE		NAME				REVISION
// ------	-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

string ls_line
long  ll_prt

ll_prt   = printopen("System Error")

// Print each string variable

print    (ll_prt, "System error message - "+string(today())+" - "+string(now(), "HH:MM:SS"))
print    (ll_prt, " ")

ls_line = "Error Number  : " + getitemstring(dw_error,1,1)
print    (ll_prt, ls_line)

ls_line = "Error Message : " + getitemstring(dw_error,1,2)
print    (ll_prt, ls_line)

ls_line = "Window/Menu   : " + getitemstring(dw_error,1,3)
print    (ll_prt, ls_line)

ls_line = "Object        : " + getitemstring(dw_error,1,4)
print    (ll_prt, ls_line)

ls_line = "Event         : " + getitemstring(dw_error,1,5)
print    (ll_prt, ls_line)

ls_line = "Line Number   : " + getitemstring(dw_error,1,6)
print    (ll_prt, ls_line)

printclose(ll_prt)
return
end event

type cb_exit from commandbutton within w_system_error
integer x = 14
integer y = 1148
integer width = 562
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "E&xit The Program"
boolean default = true
end type

on clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.cb_exit
//
// Purpose:
// 			Ends the application session
//
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

halt close
end on

type cb_continue from commandbutton within w_system_error
integer x = 782
integer y = 1148
integer width = 562
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Continue"
end type

on clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_system_error.cb_continue
//
// Purpose:
// 			Closes w_system_error
//
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
///////////////////////////////////////////////////////////////////////////

close(parent)
end on

