$PBExportHeader$w_non_port_broker_comm.srw
$PBExportComments$Maintain Non Port expenses Broker Commission
forward
global type w_non_port_broker_comm from mt_w_response
end type
type st_1 from statictext within w_non_port_broker_comm
end type
type cb_cancel from commandbutton within w_non_port_broker_comm
end type
type cb_ok from commandbutton within w_non_port_broker_comm
end type
type cb_delete from commandbutton within w_non_port_broker_comm
end type
type cb_new from commandbutton within w_non_port_broker_comm
end type
type dw_broker_comm from u_ntchire_grid_dw within w_non_port_broker_comm
end type
end forward

global type w_non_port_broker_comm from mt_w_response
integer width = 1481
integer height = 732
string title = "Create Broker Commission"
boolean ib_setdefaultbackgroundcolor = true
st_1 st_1
cb_cancel cb_cancel
cb_ok cb_ok
cb_delete cb_delete
cb_new cb_new
dw_broker_comm dw_broker_comm
end type
global w_non_port_broker_comm w_non_port_broker_comm

type variables
s_non_port_broker_comm		istr_parm
n_service_manager inv_servicemgr
end variables

forward prototypes
public function integer wf_validate ()
public subroutine documentation ()
end prototypes

public function integer wf_validate ();long 			ll_rows, ll_row
integer 		li_broker_nr, li_CheckBroker
decimal {2}	ld_broker_pct

dw_broker_comm.accepttext( )
ll_rows = dw_broker_comm.rowCount()

for ll_row = 1 to ll_rows
	/* Ensure that data is entered */
	if isNull(dw_broker_comm.getItemNumber(ll_row, "broker_nr")) then
		MessageBox("Validation Error", "Please select a Broker in row #"+string(ll_row))
		dw_broker_comm.POST setColumn( "broker_name")
		dw_broker_comm.POST setFocus( )
		dw_broker_comm.POST ScrollToRow( ll_row )
		return -1
	end if
	if isNull(dw_broker_comm.getItemNumber(ll_row, "broker_comm")) then
		MessageBox("Validation Error", "Please enter a commission % in row #"+string(ll_row))
		dw_broker_comm.POST setColumn( "broker_comm")
		dw_broker_comm.POST setFocus( )
		dw_broker_comm.POST ScrollToRow( ll_row )
		return -1
	end if
	if NOT(dw_broker_comm.getItemNumber(ll_row, "broker_comm") > 0) then
		MessageBox("Validation Error", "Please enter a commission % greater than 0 in row #"+string(ll_row))
		dw_broker_comm.POST setColumn( "broker_comm")
		dw_broker_comm.POST setFocus( )
		dw_broker_comm.POST ScrollToRow( ll_row )
		return -1
	end if
	/* Find out if Broker is registered in TC Contract. If not reject. */
	li_broker_nr = dw_broker_comm.getItemNumber(ll_row, "broker_nr")
	SELECT NTC_CONT_BROKER_COMM.BROKER_NR, NTC_CONT_BROKER_COMM.BROKER_COMM  
		INTO :li_CheckBroker, :ld_broker_pct  
		FROM NTC_CONT_BROKER_COMM,   
			NTC_PAYMENT  
		WHERE NTC_CONT_BROKER_COMM.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID  
		AND NTC_CONT_BROKER_COMM.BROKER_NR = :li_broker_nr 
		AND NTC_PAYMENT.PAYMENT_ID = :istr_parm.payment_id   ;
	if sqlca.sqlcode = 100	then
		MessageBox("Validation Error", "Selected Broker in row #"+string(ll_row)+ ", is not registred in TC Contract and therefore not allowed here")
		dw_broker_comm.POST setColumn( "broker_name")
		dw_broker_comm.POST setFocus( )
		dw_broker_comm.POST ScrollToRow( ll_row )
		return -1
	end if
	if ld_broker_pct <> dw_broker_comm.getItemNumber(ll_row, "broker_comm") then
		MessageBox("Warning", "Please be aware of that the commission percentage in row #"+string(ll_row)+"~r~nis different than the percentage registred on Contract level" )
	end if
next	

return 1
end function

public subroutine documentation ();/********************************************************************
	w_non_port_broker_comm
	
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
		27/01/2015  CR3570      KSH092      Change UI  
	</HISTORY>
********************************************************************/
end subroutine

event open;long ll_row
n_dw_style_service   lnv_style


inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_broker_comm, false)

istr_parm = message.powerobjectparm

this.move( w_tramos_main.x +3000,  w_tramos_main.y +2000)

/* If no ID then just return */
if isNull(istr_parm.non_port_id) then
	MessageBox("Information", "Please save contract/non-port expenses before entering Brokers")
	setNull(istr_parm.broker_pct)
//	istr_parm.broker_pct = 0
	POST CloseWithReturn(this, istr_parm)
	return
end if

dw_broker_comm.setTransObject(sqlca)

ll_row = dw_broker_comm.retrieve(istr_parm.non_port_id)
if ll_row < 1 then
	dw_broker_comm.insertRow(0)
	dw_broker_comm.setItem(1, "non_port_id", istr_parm.non_port_id)
	dw_broker_comm.setItem(1, "comm_set_off", 0)
	dw_broker_comm.setitemstatus(1,0,Primary!,NotModified!)
end if

/* If expense settled not able to change Broker */
if istr_parm.trans_to_coda then
	dw_broker_comm.Object.DataWindow.ReadOnly='Yes'
	cb_new.enabled = false
	cb_delete.enabled = false
	cb_ok.enabled = false
	cb_cancel.default = true
else
	dw_broker_comm.POST setColumn("broker_name")
	dw_broker_comm.POST setFocus()
end if

istr_parm.broker_pct = -2     /* Used to control that window is not closed by Alt-F4 */
end event

on w_non_port_broker_comm.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_broker_comm=create dw_broker_comm
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.dw_broker_comm
end on

on w_non_port_broker_comm.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_broker_comm)
end on

event closequery;call super::closequery;dw_broker_comm.accepttext()

if dw_broker_comm.modifiedCount() + dw_broker_comm.deletedCount() > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		if wf_validate( ) < 0 then
			return 1
		end if
		cb_ok.triggerevent( Clicked!)
			
	else
		dw_broker_comm.reset()
		dw_broker_comm.retrieve(istr_parm.non_port_id)
		
	end if
end if
//if istr_parm.broker_pct = -2 then
//	return 1
//else
//	return 0
//end if
end event

event close;call super::close;if dw_broker_comm.rowCount( ) > 0 then
	istr_parm.broker_pct = dw_broker_comm.getItemNumber(1, "sum_set_off_pct")
else
	setNull(istr_parm.broker_pct)
end if	

closewithreturn(this, istr_parm)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_non_port_broker_comm
integer x = 18
integer y = 16
end type

type st_1 from statictext within w_non_port_broker_comm
integer x = 32
integer y = 20
integer width = 704
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Non Port Expenses Brokers"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_non_port_broker_comm
integer x = 1106
integer y = 528
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;
 dw_broker_comm.retrieve(istr_parm.non_port_id)

end event

type cb_ok from commandbutton within w_non_port_broker_comm
integer x = 402
integer y = 528
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
boolean default = true
end type

event clicked;if wf_validate( ) = 1 then
	if dw_broker_comm.update() = 1 then
		commit;
	else 
		rollback;
		dw_broker_comm.resetupdate()
		MessageBox("Update Error", "There where an error when updating Brokers. Please correct and try again")
		return
	end if
else
	return
end if


end event

type cb_delete from commandbutton within w_non_port_broker_comm
integer x = 754
integer y = 528
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;dw_broker_comm.deleteRow(0)
end event

type cb_new from commandbutton within w_non_port_broker_comm
integer x = 55
integer y = 528
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;long 	ll_row

ll_row = dw_broker_comm.insertRow(0)

if ll_row > 0 then
	dw_broker_comm.setItem(ll_row, "non_port_id", istr_parm.non_port_id)
	dw_broker_comm.setItem(ll_row, "comm_set_off", 0)	
	dw_broker_comm.POST setColumn( "broker_name")
	dw_broker_comm.POST setFocus( )
	dw_broker_comm.POST ScrollToRow( ll_row )
end if
	
end event

type dw_broker_comm from u_ntchire_grid_dw within w_non_port_broker_comm
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 100
integer width = 1426
integer height = 400
integer taborder = 10
string dataobject = "d_table_non_port_broker_comm"
boolean vscrollbar = true
boolean border = false
end type

event ue_keydown;if key = KeySpaceBar! and this.getColumnName() = "broker_name" then
	this.Event DoubleClicked(0,0, this.getRow(), this.object.broker_name)
end if
end event

event doubleclicked;STRING rc
LONG	rc_long
STRING fullname

if istr_parm.trans_to_coda = true then return

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "broker_name"
			rc = f_select_from_list("dw_active_broker_list", 2, "Short Name", 3, "Long Name", 1, "Select broker", false)
			IF NOT IsNull(rc) THEN
				rc_long = Long(rc)
				SELECT BROKER_NAME INTO :fullname
				FROM BROKERS WHERE BROKER_NR = :rc_long;
				this.SetItem(row, "broker_name", fullname)
				this.SetItem(row, "broker_nr", rc_long)
			END IF
	END CHOOSE
end if
end event

