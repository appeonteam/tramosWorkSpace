$PBExportHeader$w_voyage_notepad.srw
$PBExportComments$This window lets the user enter anything (data) about a voyage.
forward
global type w_voyage_notepad from w_vessel_basewindow
end type
type dw_voyages from uo_datawindow within w_voyage_notepad
end type
type dw_notes from uo_datawindow within w_voyage_notepad
end type
type cb_1 from commandbutton within w_voyage_notepad
end type
type cb_3 from commandbutton within w_voyage_notepad
end type
type cb_4 from commandbutton within w_voyage_notepad
end type
type dw_posted_bunker from datawindow within w_voyage_notepad
end type
type cb_history from commandbutton within w_voyage_notepad
end type
end forward

global type w_voyage_notepad from w_vessel_basewindow
integer x = 9
integer y = 8
integer width = 3410
integer height = 1844
string title = "Voyage Notepad"
boolean maxbox = false
windowtype windowtype = child!
string icon = "images\TRAMOS.ICO"
dw_voyages dw_voyages
dw_notes dw_notes
cb_1 cb_1
cb_3 cb_3
cb_4 cb_4
dw_posted_bunker dw_posted_bunker
cb_history cb_history
end type
global w_voyage_notepad w_voyage_notepad

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_voyage_notepad: 
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>
		
	</USAGE>
   <ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	21/10/16		CR3320	AGL027			Removed u_attach object showing the voyage change attachments
********************************************************************/
end subroutine

on closequery;call w_vessel_basewindow::closequery;// Closequery - if calculation modified then prompt user for action

Integer li_return = 0
dw_notes.accepttext()
If dw_notes.modifiedcount() > 0 Then
	CHOOSE CASE MessageBox("Warning", "There is data that has not been saved. ~rSave before closing ?", Exclamation!, YesNoCancel!)
		CASE 1
			If dw_notes.update() = 1 Then 
				commit;
			Else
				rollback;
				li_return = 1
			End if
		CASE 2
			// No, just exit
		CASE 3
			li_return = 1
	END CHOOSE
End if

message.returnvalue = li_return
	
end on

event open;call super::open;move(5,5)
dw_voyages.settransobject(sqlca)
dw_notes.settransobject(sqlca)
dw_posted_bunker.settransobject(sqlca)

uo_vesselselect.of_registerwindow( w_voyage_notepad )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
end event

on w_voyage_notepad.create
int iCurrent
call super::create
this.dw_voyages=create dw_voyages
this.dw_notes=create dw_notes
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.dw_posted_bunker=create dw_posted_bunker
this.cb_history=create cb_history
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_voyages
this.Control[iCurrent+2]=this.dw_notes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.dw_posted_bunker
this.Control[iCurrent+7]=this.cb_history
end on

on w_voyage_notepad.destroy
call super::destroy
destroy(this.dw_voyages)
destroy(this.dw_notes)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.dw_posted_bunker)
destroy(this.cb_history)
end on

event ue_retrieve;call super::ue_retrieve;dw_voyages.retrieve(ii_vessel_nr)
dw_voyages.scrolltorow(dw_voyages.rowcount())

end event

event ue_vesselselection;call super::ue_vesselselection;postevent("ue_retrieve")
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_voyage_notepad
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_voyage_notepad
end type

type dw_voyages from uo_datawindow within w_voyage_notepad
integer x = 18
integer y = 240
integer width = 402
integer height = 1312
integer taborder = 30
string dataobject = "d_voyage_list"
boolean vscrollbar = true
boolean livescroll = false
end type

event clicked;call super::clicked;if row > 0 then
	this.selectrow(0,false)
	this.selectrow(row,true)
	dw_notes.retrieve(ii_vessel_nr,this.getitemstring(row,"voyage_nr"))
	dw_posted_bunker.retrieve(ii_vessel_nr,this.getitemstring(row,"voyage_nr"))
	dw_notes.setfocus()
end if
end event

type dw_notes from uo_datawindow within w_voyage_notepad
event ue_downkey pbm_dwnkey
integer x = 434
integer y = 244
integer width = 2007
integer height = 1316
integer taborder = 10
string dataobject = "d_voyage_notes"
boolean livescroll = false
end type

event ue_downkey;if keydown(keyenter!) or keydown(keyuparrow!) or keydown(keydownarrow!) then
//	this.setactioncode(1)
	return 1
elseif keydown(keytab!) and keydown(keyshift!) and this.getcolumnname() = "mail_to" then
//	this.setactioncode(1)
	return 1
elseif keydown(keytab!) and keydown(keyshift!) and this.getcolumnname() = "mail_subject" then
//	this.setactioncode(1)
	return 1
elseif keydown(keytab!) and not keydown(keyshift!) and this.getcolumnname() = "mail_message" then
//	this.setactioncode(1)
	return 1
end if

end event

event constructor;call super::constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

type cb_1 from commandbutton within w_voyage_notepad
integer x = 2222
integer y = 1600
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
boolean default = true
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

if dw_notes.update() = 1 then
	commit;
else
	rollback;
end if
end event

type cb_3 from commandbutton within w_voyage_notepad
integer x = 2606
integer y = 1600
integer width = 343
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

on clicked;dw_notes.print()
end on

type cb_4 from commandbutton within w_voyage_notepad
integer x = 2990
integer y = 1600
integer width = 343
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;close(parent)
end on

type dw_posted_bunker from datawindow within w_voyage_notepad
integer x = 2455
integer y = 244
integer width = 878
integer height = 844
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_ff_posted_bunker"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_history from commandbutton within w_voyage_notepad
integer x = 1838
integer y = 1600
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Show History"
end type

event clicked;long ll_row
string ls_voyage_nr

ll_row = dw_voyages.getselectedrow(0)
if ll_row < 1 then
	messagebox("Information", "Please select a voyage before opening log window.")
	return
end if

ls_voyage_nr  = dw_voyages.getitemstring(ll_row, "voyage_nr")

if not isvalid(w_interface_log) then
	opensheetwithparm(w_interface_log, ls_voyage_nr, w_tramos_main, 0, Original!)
	yield()
else
	w_interface_log.wf_refresh_showlog(ii_vessel_nr, ls_voyage_nr)
end if

w_interface_log.bringtotop = true
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
02w_voyage_notepad.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12w_voyage_notepad.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
