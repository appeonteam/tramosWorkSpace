$PBExportHeader$w_import_voyage_notes.srw
$PBExportComments$Window for importing voyage notes from Global Agent
forward
global type w_import_voyage_notes from window
end type
type dw_voyage_list from datawindow within w_import_voyage_notes
end type
type cb_1 from commandbutton within w_import_voyage_notes
end type
type cb_print from commandbutton within w_import_voyage_notes
end type
type cb_update from commandbutton within w_import_voyage_notes
end type
type cb_validate_errors from commandbutton within w_import_voyage_notes
end type
type dw_rejected from datawindow within w_import_voyage_notes
end type
type dw_accepted from datawindow within w_import_voyage_notes
end type
type cb_import from commandbutton within w_import_voyage_notes
end type
type gb_1 from groupbox within w_import_voyage_notes
end type
end forward

global type w_import_voyage_notes from window
integer x = 1074
integer y = 484
integer width = 4247
integer height = 2076
boolean titlebar = true
string title = "Import Voyage Notes"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 79741120
dw_voyage_list dw_voyage_list
cb_1 cb_1
cb_print cb_print
cb_update cb_update
cb_validate_errors cb_validate_errors
dw_rejected dw_rejected
dw_accepted dw_accepted
cb_import cb_import
gb_1 gb_1
end type
global w_import_voyage_notes w_import_voyage_notes

type variables
u_import_voyage_notes iuo_import_voyage_notes
datastore ids_vessel

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_import_voyage_notes.create
this.dw_voyage_list=create dw_voyage_list
this.cb_1=create cb_1
this.cb_print=create cb_print
this.cb_update=create cb_update
this.cb_validate_errors=create cb_validate_errors
this.dw_rejected=create dw_rejected
this.dw_accepted=create dw_accepted
this.cb_import=create cb_import
this.gb_1=create gb_1
this.Control[]={this.dw_voyage_list,&
this.cb_1,&
this.cb_print,&
this.cb_update,&
this.cb_validate_errors,&
this.dw_rejected,&
this.dw_accepted,&
this.cb_import,&
this.gb_1}
end on

on w_import_voyage_notes.destroy
destroy(this.dw_voyage_list)
destroy(this.cb_1)
destroy(this.cb_print)
destroy(this.cb_update)
destroy(this.cb_validate_errors)
destroy(this.dw_rejected)
destroy(this.dw_accepted)
destroy(this.cb_import)
destroy(this.gb_1)
end on

event open;iuo_import_voyage_notes = Create u_import_voyage_notes
iuo_import_voyage_notes.of_SetShareOn(dw_accepted, dw_rejected)

dw_voyage_list.setTransObject(SQLCA)

ids_vessel = create datastore
ids_vessel.dataObject = "d_sq_tb_find_vessel_nr"
ids_vessel.setTransObject( sqlca )
ids_vessel.retrieve( )

end event

event close;Destroy iuo_import_voyage_notes


end event

event closequery;
IF iuo_import_voyage_notes.ids_voyage_notes.RowCount() > 0 OR iuo_import_voyage_notes.ids_rejected.RowCount() > 0 THEN
	IF MessageBox("Closing window", "You have data present ! Are you sure you want to close window ?", & 
																									Question!, YesNo!) = 2 THEN
		RETURN 1
	ELSE
		RETURN 0
	END IF
END IF
end event

type dw_voyage_list from datawindow within w_import_voyage_notes
integer x = 3003
integer y = 212
integer width = 1152
integer height = 1704
integer taborder = 90
string title = "none"
string dataobject = "d_voyage_list_impexp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_import_voyage_notes
integer x = 3808
integer y = 60
integer width = 347
integer height = 104
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;Close(parent)
end event

type cb_print from commandbutton within w_import_voyage_notes
integer x = 2542
integer y = 1808
integer width = 389
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print Errors"
end type

event clicked;
IF dw_rejected.RowCount() > 0 THEN
	dw_rejected.Print(TRUE)
ELSE
	MessageBox("Information","There are no rejected transactions to print.")
END IF
end event

type cb_update from commandbutton within w_import_voyage_notes
integer x = 841
integer y = 60
integer width = 782
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update Voyage Notes"
end type

event clicked;IF dw_rejected.RowCount() > 0 THEN
	MessageBox("Information","You must correct all rejected notes before update!")
	Return
END IF

IF dw_accepted.RowCount() < 1 THEN
	MessageBox("Information","There is nothing to update!")
	Return
END IF

IF iuo_import_voyage_notes.of_update() = 1 THEN 
	iuo_import_voyage_notes.of_clear_datastore()
ELSE
	MessageBox("Error","Update error! No records updated")
END IF
				
end event

type cb_validate_errors from commandbutton within w_import_voyage_notes
integer x = 59
integer y = 1808
integer width = 407
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Validate Errors"
end type

event clicked;
Integer li_return

IF dw_rejected.RowCount() > 0 THEN 
	dw_rejected.AcceptText()
	li_return = iuo_import_voyage_notes.of_validate()
ELSE
	MessageBox("Information","there are no errors to validate.")
END IF

IF li_return = -1 THEN 
	MessageBox("Error","Error in the validation process. All import is halted !")
	iuo_import_voyage_notes.of_clear_datastore()
END IF
end event

type dw_rejected from datawindow within w_import_voyage_notes
integer x = 55
integer y = 1020
integer width = 2875
integer height = 764
integer taborder = 20
string dataobject = "d_import_notes_rejected"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;choose case dwo.name
	case "vessel_nr", "voyage_nr"
		iuo_import_voyage_notes.POST of_rejected_modified(row, dwo.name, data)
		return 2
end choose
end event

event rowfocuschanged;//if currentrow > 0 then
if (currentrow = 0) then
	RETURN
end if

integer li_vessel
long ll_found

// populate the dwc dw_voyage_list

string ls_vessel_ref_nr
ls_vessel_ref_nr = this.getItemString(currentrow, "vessel_nr")

string ls_voyage
ls_voyage = this.getItemString(currentrow, "voyage_nr")
	
/* only retrieve if vessel and voyage changed */
if dw_voyage_list.rowcount() > 0 then 
	
	if (ls_vessel_ref_nr = dw_voyage_list.getItemString(1, "vessel_ref_nr")) and &
		(mid(ls_voyage,1,2) = mid(dw_voyage_list.getItemString(1, "voyage_nr"),1,2)) then
		/* no retrieve */
	else
			
		// li_vessel = ids_vessel.getItemNumber( ids_vessel.find( "vessel_ref_nr='"+ls_vessel_ref_nr+"'", 1, 999999) , "vessel_nr")
		integer i_row_vessel_ref_number 
		i_row_vessel_ref_number = ids_vessel.find( "vessel_ref_nr='"+ls_vessel_ref_nr+"'", 1, 999999)
			
		// VALIDATE THAT THE REFERENCE NUMBER IS VALID BEFORE USING IT 
		// This validation check was first identified as being needed in 
		// dw_rejected.rowfocuschanged(), but it has also 
		// been copied out to the object function u_import_voyage_notes.of_check_voyage(), to check the error 
		// BEFORE we get to this point. 

		if (i_row_vessel_ref_number > 0) then
			// messagebox("TRAMOS", "Vessel Reference Number (" + string(i_row_vessel_ref_number) +") is not valid." )

			// get the vessel number from the vessel ref number 
			li_vessel = ids_vessel.getItemNumber( i_row_vessel_ref_number, "vessel_nr")
		
			dw_voyage_list.retrieve(li_vessel, mid(ls_voyage,1,2))
		end if 

	end if
else
	ll_found = ids_vessel.find( "vessel_ref_nr='"+ls_vessel_ref_nr+"'", 1, 999999)
	if ll_found > 0 then 
		li_vessel = ids_vessel.getItemNumber( ll_found,  "vessel_nr")
		dw_voyage_list.retrieve(li_vessel, mid(ls_voyage,1,2))
	else
		//MessageBox("Error", "Entered vessel number not correct!")
	end if
end if

/* Find voyage */
ll_found = dw_voyage_list.find("voyage_nr='"+ls_voyage+"'", 1, 99999)
if ll_found < 1 then
	ll_found = dw_voyage_list.find("voyage_nr>'"+ls_voyage+"'", 1, 99999)
end if
if ll_found > 0 then
	dw_voyage_list.scrolltorow(ll_found)
end if
	

end event

type dw_accepted from datawindow within w_import_voyage_notes
integer x = 55
integer y = 212
integer width = 2875
integer height = 688
integer taborder = 80
string dataobject = "d_import_notes"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_import from commandbutton within w_import_voyage_notes
integer x = 55
integer y = 60
integer width = 750
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Import Voyage Notes"
boolean default = true
end type

event clicked;Integer li_return

li_return = iuo_import_voyage_notes.of_import_notes()

IF li_return = -1 THEN 
	MessageBox("Error","Error in the validation process. All import is halted!")
	iuo_import_voyage_notes.of_clear_datastore()
END IF


end event

type gb_1 from groupbox within w_import_voyage_notes
integer x = 27
integer y = 944
integer width = 2926
integer height = 976
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
string text = "Rejected transactions"
end type

