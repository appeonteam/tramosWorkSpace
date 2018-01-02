$PBExportHeader$w_bareboat_management.srw
forward
global type w_bareboat_management from mt_w_response
end type
type cb_ok from commandbutton within w_bareboat_management
end type
type dw_bareboat from datawindow within w_bareboat_management
end type
end forward

global type w_bareboat_management from mt_w_response
integer x = 1499
integer y = 500
integer width = 2423
integer height = 484
string title = "Bareboat Management"
boolean controlmenu = false
cb_ok cb_ok
dw_bareboat dw_bareboat
end type
global w_bareboat_management w_bareboat_management

type variables
datastore		ids
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_bareboat_management
	
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
		01/09/14		CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

event open;ids = message.PowerObjectParm
move(w_tramos_main.x + 1500, w_tramos_main.y + 500)
ids.shareData(dw_bareboat )

end event

on w_bareboat_management.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_bareboat=create dw_bareboat
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_bareboat
end on

on w_bareboat_management.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_bareboat)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_bareboat_management
end type

type cb_ok from commandbutton within w_bareboat_management
integer x = 1042
integer y = 272
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;dw_bareboat.accepttext( )
if dw_bareboat.getItemNumber(1, "third_party") = 1 then 
	if isNull(dw_bareboat.getItemString(1, "coda_el3")) &
	or isNull(dw_bareboat.getItemString(1, "coda_el4")) then
		MessageBox("Validation Error", "When Technical Management is laid out to 3rd party, CODA element 3 and 4 are mandatory")
		dw_bareboat.setColumn("coda_el3")
		dw_bareboat.scrollToRow(1)
		dw_bareboat.setFocus()
		return
	end if
end if

if dw_bareboat.getItemNumber(2, "third_party") = 1 then 
	if isNull(dw_bareboat.getItemString(2, "coda_el3")) &
	or isNull(dw_bareboat.getItemString(2, "coda_el4")) then
		MessageBox("Validation Error", "When Crew Management is laid out to 3rd party, CODA element 3 and 4 are mandatory")
		dw_bareboat.setColumn("coda_el3")
		dw_bareboat.scrollToRow(2)
		dw_bareboat.setFocus()
		return
	end if
end if

ids.shareDataOff()
close(parent)
end event

type dw_bareboat from datawindow within w_bareboat_management
integer x = 5
integer y = 8
integer width = 2395
integer height = 232
integer taborder = 10
string title = "none"
string dataobject = "d_tc_bareboat_management"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_null;setNull(ls_null)

if row < 1 then return

choose case dwo.name
	case "third_party"
		if data <> "1" then
			this.setItem(row, "coda_el3", ls_null)
			this.setItem(row, "coda_el4", ls_null)
			this.setItem(row, "coda_el5", ls_null)
			this.setItem(row, "coda_el6", ls_null)
			this.setItem(row, "coda_el7", ls_null)
		end if
end choose
			
			
end event

