$PBExportHeader$w_edit_single_offservice.srw
$PBExportComments$Window used to edit single Off-service record
forward
global type w_edit_single_offservice from mt_w_response
end type
type cb_cancel from mt_u_commandbutton within w_edit_single_offservice
end type
type cb_ok from mt_u_commandbutton within w_edit_single_offservice
end type
type dw_offservice from u_ntchire_dw within w_edit_single_offservice
end type
end forward

global type w_edit_single_offservice from mt_w_response
integer x = 1001
integer y = 500
integer width = 2098
integer height = 1336
string title = "Edit - Off-Hire"
boolean ib_setdefaultbackgroundcolor = true
cb_cancel cb_cancel
cb_ok cb_ok
dw_offservice dw_offservice
end type
global w_edit_single_offservice w_edit_single_offservice

type variables
s_off_service		istr_data
s_off_service     istr_data_original

end variables

forward prototypes
public subroutine documentation ()
public function integer of_init ()
public function integer of_update ()
public function integer of_setreturnparm ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_edit_single_offservice
	
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
		18/11/2014 	CR3781   	CCY018		The window title match with the text of a menu item.
		23/09/2015  CR3133      SSX014      Modified to align with the UX standard.
		12/09/2015  CR4182      SSX014
	</HISTORY>
********************************************************************/
end subroutine

public function integer of_init ();if dw_offservice.RowCount() <= 0 then
	dw_offservice.insertRow(0)
end if

istr_data = istr_data_original

dw_offservice.setItem(1, "ops_off_service_id", istr_data.ops_off_service_id )
dw_offservice.setItem(1, "port_code", istr_data.port_code)
dw_offservice.setItem(1, "vessel_nr", istr_data.vessel_nr)
dw_offservice.setItem(1, "voyage_nr", istr_data.voyage_nr)
dw_offservice.setItem(1, "off_start", istr_data.off_start)
dw_offservice.setItem(1, "off_end", istr_data.off_end)
dw_offservice.setItem(1, "off_time_days", istr_data.days)
dw_offservice.setItem(1, "off_time_hours", istr_data.hours)
dw_offservice.setItem(1, "off_time_minutes", istr_data.minutes)
dw_offservice.setItem(1, "off_fuel_oil_used", istr_data.fuel_oil)
dw_offservice.setItem(1, "off_diesel_oil_used", istr_data.diesel_oil)
dw_offservice.setItem(1, "off_gas_oil_used", istr_data.gas_oil)
dw_offservice.setItem(1, "off_lshfo_oil_used", istr_data.lshfo_oil)
dw_offservice.setItem(1, "hfo_stock_start", istr_data.hfo_start)
dw_offservice.setItem(1, "hfo_stock_end", istr_data.hfo_end)
dw_offservice.setItem(1, "do_stock_start", istr_data.do_start)
dw_offservice.setItem(1, "do_stock_end", istr_data.do_end)
dw_offservice.setItem(1, "go_stock_start", istr_data.go_start)
dw_offservice.setItem(1, "go_stock_end", istr_data.go_end)
dw_offservice.setItem(1, "lshfo_stock_start", istr_data.lshfo_start)
dw_offservice.setItem(1, "lshfo_stock_end", istr_data.lshfo_end)
dw_offservice.setItem(1, "off_description", istr_data.description)
dw_offservice.setItem(1, "comments", istr_data.comment)

if istr_data.scheduled = true then
	dw_offservice.setItem(1, "off_scheduled", 1)
else
	dw_offservice.setItem(1, "off_scheduled", 0)
end if

if istr_data.new_record = true then
	dw_offservice.setItemStatus(1, 0, primary!, new!)
else
	dw_offservice.setItemStatus(1, 0, primary!, DataModified!)
	dw_offservice.setItemStatus(1, 0, primary!, NotModified!)
	
	/* Because the is a bug in PB. We can't set status to notModified! directly*/
end if

return 1
end function

public function integer of_update ();integer			li_finished
n_offservice		lnv_offservice

dw_offservice.acceptText()

istr_data.port_code 	= dw_offservice.getItemString(1, "port_code")
istr_data.vessel_nr 	= dw_offservice.getItemNumber(1, "vessel_nr")
istr_data.voyage_nr 	= dw_offservice.getItemString(1, "voyage_nr")
istr_data.off_start 	= dw_offservice.getItemDatetime(1, "off_start")
istr_data.off_end		= dw_offservice.getItemDatetime(1, "off_end")
istr_data.days			= dw_offservice.getItemNumber(1, "off_time_days")
istr_data.hours			= dw_offservice.getItemNumber(1, "off_time_hours")
istr_data.minutes		= dw_offservice.getItemNumber(1, "off_time_minutes")
istr_data.fuel_oil		= dw_offservice.getItemDecimal(1, "off_fuel_oil_used")
istr_data.diesel_oil	= dw_offservice.getItemDecimal(1, "off_diesel_oil_used")
istr_data.gas_oil		= dw_offservice.getItemDecimal(1, "off_gas_oil_used")
istr_data.lshfo_oil		= dw_offservice.getItemDecimal(1, "off_lshfo_oil_used") 
istr_data.hfo_start	= dw_offservice.getItemDecimal(1, "hfo_stock_start") 
istr_data.hfo_end		= dw_offservice.getItemDecimal(1, "hfo_stock_end") 
istr_data.do_start		= dw_offservice.getItemDecimal(1, "do_stock_start") 
istr_data.do_end		= dw_offservice.getItemDecimal(1, "do_stock_end") 
istr_data.go_start		= dw_offservice.getItemDecimal(1, "go_stock_start") 
istr_data.go_end		= dw_offservice.getItemDecimal(1, "go_stock_end") 
istr_data.lshfo_start	= dw_offservice.getItemDecimal(1, "lshfo_stock_start") 
istr_data.lshfo_end	= dw_offservice.getItemDecimal(1, "lshfo_stock_end") 
istr_data.description	= dw_offservice.getItemString(1, "off_description")
istr_data.comment		= dw_offservice.getItemString(1, "comments")

if dw_offservice.getItemNumber(1, "off_scheduled") = 1 then
	istr_data.scheduled= true
else
	istr_data.scheduled= false
end if

dw_offservice.setTransObject(SQLCA)
if istr_data.businessObject.of_update(dw_offservice) = 1 then
	istr_data.ops_off_service_id = dw_offservice.getItemNumber(1, "ops_off_service_id")

	/* if voyage finished then check if offservice OK. Messages only warnings */
	SELECT VOYAGE_FINISHED
		INTO :li_finished
		FROM VOYAGES
		WHERE VESSEL_NR = :istr_data.vessel_nr
		AND VOYAGE_NR = :istr_data.voyage_nr;
	commit;
	
	if li_finished = 1 then
		lnv_offservice = create n_offservice
		lnv_offservice.of_voyagefinishvalidate( istr_data.vessel_nr, istr_data.voyage_nr )
		destroy lnv_offservice
	end if
	
else
	of_setreturnparm()
	dw_offservice.POST setFocus()	
	return -1
end if

return 1

end function

public function integer of_setreturnparm ();setNull(istr_data.port_code)
setNull(istr_data.vessel_nr)
setNull(istr_data.voyage_nr)
setNull(istr_data.off_start)
setNull(istr_data.off_end)
setNull(istr_data.days)
setNull(istr_data.hours)
setNull(istr_data.minutes)
setNull(istr_data.fuel_oil)
setNull(istr_data.diesel_oil)
setNull(istr_data.gas_oil)
setNull(istr_data.lshfo_oil)
setNull(istr_data.hfo_start)
setNull(istr_data.hfo_end)
setNull(istr_data.do_start)
setNull(istr_data.do_end)
setNull(istr_data.go_start)
setNull(istr_data.go_end)
setNull(istr_data.lshfo_start)
setNull(istr_data.lshfo_end)
setNull(istr_data.description)
setNull(istr_data.scheduled)

return 1

end function

on w_edit_single_offservice.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_offservice=create dw_offservice
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_offservice
end on

on w_edit_single_offservice.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_offservice)
end on

event open;call super::open;istr_data = message.PowerObjectParm
istr_data_original = istr_data

of_init()

/* If offservice settled - read only */

if istr_data.businessObject.of_getreadonlystatus(istr_data.ops_off_service_id) > 0 &
	or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2) then
	dw_offservice.object.datawindow.readonly = "Yes"
	cb_ok.enabled = false
	cb_cancel.enabled = false
	dw_offservice.modify("off_start.background.mode=1")
	dw_offservice.modify("off_end.background.mode=1")
	dw_offservice.modify("off_start.protect=1")
	dw_offservice.modify("off_end.protect=1")
	dw_offservice.modify("off_time_days.background.mode=1")
	dw_offservice.modify("off_time_hours.background.mode=1")
	dw_offservice.modify("off_time_minutes.background.mode=1")
	dw_offservice.modify("off_description.background.mode=1")
	dw_offservice.modify("comments.background.mode=1")
	dw_offservice.modify("hfo_stock_start.background.mode=1")
	dw_offservice.modify("hfo_stock_end.background.mode=1")
	dw_offservice.modify("off_fuel_oil_used.background.mode=1")
	dw_offservice.modify("do_stock_start.background.mode=1")
	dw_offservice.modify("do_stock_end.background.mode=1")
	dw_offservice.modify("off_diesel_oil_used.background.mode=1")
	dw_offservice.modify("go_stock_start.background.mode=1")
	dw_offservice.modify("go_stock_end.background.mode=1")
	dw_offservice.modify("off_gas_oil_used.background.mode=1")
	dw_offservice.modify("lshfo_stock_start.background.mode=1")
	dw_offservice.modify("lshfo_stock_end.background.mode=1")
	dw_offservice.modify("off_lshfo_oil_used.background.mode=1")
	dw_offservice.modify("off_scheduled.background.mode=1")
end if

of_setreturnparm()
end event

event close;call super::close;closeWithReturn(this, istr_data)
end event

event closequery;call super::closequery;dw_offservice.accepttext()
if dw_offservice.modifiedcount() + dw_offservice.deletedcount() > 0 then
	if messagebox("Updates Pending", "Data has been changed, but not saved. ~n~nWould you like to save data?", Question!, YesNo!, 1) = 1 then
		if of_update() = C#Return.Failure then
			return 1
		end if
	end if
end if

return 0
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_edit_single_offservice
end type

type cb_cancel from mt_u_commandbutton within w_edit_single_offservice
integer x = 1723
integer y = 1124
integer taborder = 30
string text = "&Cancel"
end type

event clicked;Parent.of_init()
of_setreturnparm()

end event

type cb_ok from mt_u_commandbutton within w_edit_single_offservice
integer x = 1376
integer y = 1124
integer taborder = 20
string text = "&Update"
end type

event clicked;call super::clicked;if of_update() = 1 then
	close(parent)
end if


end event

type dw_offservice from u_ntchire_dw within w_edit_single_offservice
integer x = 27
integer y = 16
integer width = 2254
integer height = 1136
integer taborder = 10
string title = ""
string dataobject = "d_edit_single_offservice"
boolean border = false
end type

event itemchanged;call super::itemchanged;Long 			ll_minutes
Integer 		li_days, li_hours, li_minutes
decimal {4}	ld_start, ld_end

//CHOOSE CASE this.GetColumnName()
CHOOSE CASE dwo.name
	CASE "off_start", "off_end"
		this.AcceptText()
		ll_minutes = f_timedifference( this.GetItemDateTime(row,"off_start") ,&
								this.GetItemDateTime(row,"off_end") )
		li_days = Int(ll_minutes/1440)
		li_hours = ( ll_minutes - ( li_days * 1440 ) ) / 60 
		li_minutes = ll_minutes - (li_days * 1440 ) - ( li_hours * 60 )
		this.SetItem(row,"off_time_days",li_days)
		this.SetItem(row,"off_time_hours",li_hours)
		this.SetItem(row,"off_time_minutes",li_minutes)
	CASE "hfo_stock_start", "hfo_stock_end"
		this.accepttext( )
		ld_start = this.getItemDecimal(row, "hfo_stock_start")
		if isNull(ld_start) then return
		ld_end = this.getItemDecimal(row, "hfo_stock_end")
		if isNull(ld_end) then return
		this.setItem(row, "off_fuel_oil_used", ld_start - ld_end)
	CASE "do_stock_start", "do_stock_end"
		this.accepttext( )
		ld_start = this.getItemDecimal(row, "do_stock_start")
		if isNull(ld_start) then return
		ld_end = this.getItemDecimal(row, "do_stock_end")
		if isNull(ld_end) then return
		this.setItem(row, "off_diesel_oil_used", ld_start - ld_end)
	CASE "go_stock_start", "go_stock_end"
		this.accepttext( )
		ld_start = this.getItemDecimal(row, "go_stock_start")
		if isNull(ld_start) then return
		ld_end = this.getItemDecimal(row, "go_stock_end")
		if isNull(ld_end) then return
		this.setItem(row, "off_gas_oil_used", ld_start - ld_end)
	CASE "lshfo_stock_start", "lshfo_stock_end"
		this.accepttext( )
		ld_start = this.getItemDecimal(row, "lshfo_stock_start")
		if isNull(ld_start) then return
		ld_end = this.getItemDecimal(row, "lshfo_stock_end")
		if isNull(ld_end) then return
		this.setItem(row, "off_lshfo_oil_used", ld_start - ld_end)
END CHOOSE


end event

