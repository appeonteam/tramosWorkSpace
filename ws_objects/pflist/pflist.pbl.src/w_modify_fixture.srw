$PBExportHeader$w_modify_fixture.srw
forward
global type w_modify_fixture from window
end type
type st_broker from statictext within w_modify_fixture
end type
type st_chart from statictext within w_modify_fixture
end type
type st_label1 from statictext within w_modify_fixture
end type
type p_source from picture within w_modify_fixture
end type
type p_broker from picture within w_modify_fixture
end type
type p_char from picture within w_modify_fixture
end type
type pb_refreshtc from picturebutton within w_modify_fixture
end type
type uo_calculation from u_tccalculation within w_modify_fixture
end type
type cb_calculation from mt_u_commandbutton within w_modify_fixture
end type
type cb_update from mt_u_commandbutton within w_modify_fixture
end type
type cb_cancel from mt_u_commandbutton within w_modify_fixture
end type
type dw_fixture from datawindow within w_modify_fixture
end type
end forward

global type w_modify_fixture from window
integer width = 1765
integer height = 2472
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
event type integer ue_update ( )
st_broker st_broker
st_chart st_chart
st_label1 st_label1
p_source p_source
p_broker p_broker
p_char p_char
pb_refreshtc pb_refreshtc
uo_calculation uo_calculation
cb_calculation cb_calculation
cb_update cb_update
cb_cancel cb_cancel
dw_fixture dw_fixture
end type
global w_modify_fixture w_modify_fixture

type variables
s_pf 		istr_fixture
mt_n_dddw_searchasyoutype inv_dddw_search
end variables

forward prototypes
public function integer uf_tc_calc (ref datawindow idw_fixture)
public subroutine uf_setdddw (datawindow adw)
private subroutine _select_company (string as_field)
private function string _gettotalfixed (integer ai_type, long al_id)
public subroutine documentation ()
end prototypes

event type integer ue_update();/********************************************************************
   clicked
   <DESC>  </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author             Comments
   	26/06/2013   CR3244       WWA048        		Duplicate the features specific to profit center group Crude to Nova
	29/08/2017	 CR3350		 KSH092					Change this window close tramos
   </HISTORY>
********************************************************************/

datawindowchild	ldwc
string 				ls_portcode
long					ll_found, ll_year
dec					ldc_tc, ldc_tcdays
n_messagebox		lnv_messagebox
n_fixture lnv_fixture
lnv_fixture = CREATE n_fixture

if  dw_fixture.rowcount( ) <> 0 then
	
	//FULLFILL TC CALCULATION FOR CRUDE/NOVA

	//if dw_fixture.getitemnumber( 1, "pc_nr") = 2 then		
	if istr_fixture.pcgroup = c#pcgroup.ii_CRUDE or istr_fixture.pcgroup = c#pcgroup.ii_NOVA then
		dw_fixture.accepttext()
		if dw_fixture.getitemnumber( 1, "maersktcrt") = 0 or  isnull(dw_fixture.getitemnumber( 1, "maersktcrt")) then
			uf_tc_calc(dw_fixture)
		end if
	end if
	
	// dw_fixture.setitem( 1,"fixturereported",today())
	//dw_fixture.setitem(1,"isfixture",1)
	if isnull(dw_fixture.getitemdatetime( 1, "fixturereported")) then
		dw_fixture.setitem(1,"fixturereported",today())
	end if
	dw_fixture.acceptText()
	/* Validate that the loadport is in the dropdown list */
	ls_portcode = dw_fixture.getItemString(1, "lportcode")
	if not isNull(ls_portcode) then
		ll_found = w_share.dw_calc_port_dddw.find("port_code='"+ls_portcode+"'", 1, 99999)
		if ll_found = 0 then 
			MessageBox("Validation Error", "Entered Loadport is not correct. Please select a valid port from the list.")
			dw_fixture.post setcolumn( "lportcode" )
			dw_fixture.post setFocus()
			return c#return.failure
		end if
	end if
	/* Validate that the dischargeport is in the dropdown list */
	ls_portcode = dw_fixture.getItemString(1, "dportcode")
	if not isNull(ls_portcode) then
		ll_found = w_share.dw_calc_port_dddw.find("port_code='"+ls_portcode+"'", 1, 99999)
		if ll_found = 0 then 
			MessageBox("Validation Error", "Entered Dischargeport is not correct. Please select a valid port from the list.")
			dw_fixture.post setcolumn( "dportcode" )
			dw_fixture.post setFocus()
			return c#return.failure
		end if
	end if
	
	if isNull(dw_fixture.getItemnumber(1, "brokerid")) and not isNull(dw_fixture.getItemNumber(1, "sourceid")) then
		dw_fixture.setitem(1, "brokerid",dw_fixture.getitemnumber(1,"sourceid"))
	end if
	
	ldc_tc = dw_fixture.getitemdecimal(1,'maersktcrt')
	if ldc_tc = 0 then
		lnv_messagebox.of_messagebox(lnv_messagebox.is_TYPE_VALIDATION_ERROR, 'You cannot enter 0.', this)
		dw_fixture.setfocus()
		dw_fixture.setcolumn('maersktcrt')
		dw_fixture.selecttext(1,30)
		return c#return.failure
	end if
	
	ldc_tcdays = dw_fixture.getitemdecimal(1,'maersktcrtdays')
	if ldc_tcdays = 0 then
		lnv_messagebox.of_messagebox(lnv_messagebox.is_TYPE_VALIDATION_ERROR, 'You cannot enter 0.', this)
		dw_fixture.setfocus()
		dw_fixture.setcolumn('maersktcrtdays')
		dw_fixture.selecttext(1,30)
		return c#return.failure
	end if

	ll_year = dw_fixture.getitemnumber(1,'flatrateyear')
	if not isnull(ll_year) then
		if ll_year = 0 or ll_year <> year(today()) then
			if messagebox(this.title,"You have typed a Flatrate Year that is not the current year.~r~n~r~nAre you sure you want to continue?", Exclamation!,YesNo!,2) = 2 then
				dw_fixture.setfocus()
				dw_fixture.setcolumn('flatrateyear')
				dw_fixture.selecttext(1,30)
				return c#return.failure
			end if
		end if
	end if
	//Process any status exceptions (currently these are the status' covered: Fixed, Failed)
	lnv_fixture.uf_f_status_exceptions( dw_fixture)
	
	//update
	if dw_fixture.update() = 1 then
		commit;
		return c#return.success
	else
		rollback;
		MessageBox("Update Error", "Error updating position.")
		return c#return.failure
	end if
	
end if
end event

public function integer uf_tc_calc (ref datawindow idw_fixture);integer	li_pc_nr, li_pcgroup
long		ll_vesselid, ll_clarkid
long		ll_flatrateyear, ll_ratetypeid,ll_tradeid
string 	ls_errormessage, ls_dportid,ls_lportid
dec{2}	ld_rate, ld_cargoSize,ld_waitingdays
dec{2}	id_owntc, id_owntcdays

ll_vesselid = idw_fixture.getitemnumber( 1, "vesselid")
ll_clarkid = idw_fixture.getitemnumber( 1, "pf_fixture_vesselid_web")
ld_rate = idw_fixture.getitemnumber( 1, "rate")
ll_flatrateyear = idw_fixture.getitemnumber( 1, "flatrateyear")
ll_ratetypeid = idw_fixture.getitemnumber( 1, "ratetypeid")
ld_cargoSize = idw_fixture.getitemnumber( 1, "cargosize")
ll_tradeid =  idw_fixture.getitemnumber( 1, "pf_fixture_tradeid")
ld_waitingdays = idw_fixture.getitemnumber( 1, "waitindays")

 ls_dportid = idw_fixture.getitemstring ( 1, "lportcode")
 ls_lportid =  idw_fixture.getitemstring( 1, "dportcode")
// li_pc_nr = idw_fixture.getitemnumber( 1, "pc_nr")
 li_pcgroup = idw_fixture.getitemnumber( 1, "pcgroup_id")

if uo_calculation.uf_tccalculation(li_pcgroup, ll_vesselid, ll_clarkid, ld_rate, ll_flatrateyear,ll_ratetypeid,  ll_tradeid, ls_lportid,ls_dportid,   ld_cargoSize, ld_waitingdays,id_owntc, id_owntcdays, ls_errormessage)=0 then
  idw_fixture.setitem(1,"maersktcrt",id_owntc)
  idw_fixture.setitem(1,"maersktcrtdays",id_owntcdays)
  idw_fixture.acceptText()
end if
return 0
end function

public subroutine uf_setdddw (datawindow adw);datawindowchild	ldwc
long					ll_rows, ll_row

/* retrieve DDDW - vessel*/
adw.getchild("vesselid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - competitor vessel*/
adw.getchild("pf_fixture_vesselid_web", ldwc)
ldwc.SetTransObject(SQLCA)
// fix - just in case there are no competitor vessels
if ldwc.retrieve(istr_fixture.pcgroup) = 0 then
	ldwc.insertrow(0)
end if

/* retrieve DDDW - charterer*/
adw.getchild("chartererid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - broker*/
adw.getchild("brokerid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - source*/
adw.getchild("sourceid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - areA
adw.getchild("areaid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(pc_nr)*/
/* retrieve DDDW - cargo*/
adw.getchild("cargoid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - trade*/
adw.getchild("pf_fixture_tradeid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - status*/
adw.getchild("pf_fixture_statusid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - optrade*/
adw.getchild("optradeid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - office*/
adw.getchild("officeid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - operator*/
adw.getchild("operatorid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - owner*/
adw.getchild("ownerid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
/* retrieve DDDW - area*/
adw.getchild("areaid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_fixture.pcgroup)
end subroutine

private subroutine _select_company (string as_field);/********************************************************************
   _select_company
   <DESC> Opens window with company details and contacts list </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>	as_field: string - company field - chartererid, brokerid, sourceid
   </ARGS>
   <USAGE>		- if a company is selected, then the user visualizes the company details
						- if a company is not selected, then it´s possible to add a new company.
	</USAGE>
********************************************************************/

s_company 	lstr_company
long				ll_companyid
datawindowchild	ldwc

dw_fixture.accepttext()
if isnull(dw_fixture.getitemnumber( 1, as_field)) then
	lstr_company.companyid = 0
else 
	lstr_company.companyid = dw_fixture.getitemnumber( 1, as_field)
end if
lstr_company.pcgroup = dw_fixture.getitemnumber( 1, "pcgroup_id")

//TEST
//OpenWithParm(w_contacts_overview, lstr_company)
OpenWithParm(w_company_contacts_overview, lstr_company)

ll_companyid =  message.doubleparm

if lstr_company.companyid = 0 and  ll_companyid>0 then
	uf_setdddw( dw_fixture)
	dw_fixture.setitem( 1, as_field,ll_companyid)
end if

end subroutine

private function string _gettotalfixed (integer ai_type, long al_id);string	ls_res
long	ll_total, ll_fixed, ll_pcgroupid

ls_res = ""
if al_id<1 then return ls_res

ll_pcgroupid = dw_fixture.getitemnumber( 1, "pcgroup_id")

if ai_type = 1 then
	//CHART
	SELECT count(*) as total, isnull(sum((select case when PF_FIXTURE.STATUSID=104 then 1 else 0 end )),0) as fixed
	INTO :ll_total, :ll_fixed
	FROM PF_FIXTURE  
	WHERE  ISFIXTURE=1 AND  STATUSID NOT IN (102, 114)
	AND PCGROUP_ID = :ll_pcgroupid AND CHARTERERID = :al_id
	and STATUSCHANGED > dateadd(yy, -1, getdate());
	commit using SQLCA;
	ls_res = string(ll_fixed) + " / " + string(ll_total)
	
elseif ai_type = 2 then
	//BROKER
	SELECT count(*) as total, isnull(sum((select case when PF_FIXTURE.STATUSID=104 then 1 else 0 end )),0) as fixed
	INTO :ll_total, :ll_fixed
	FROM PF_FIXTURE  
	WHERE  ISFIXTURE=1 AND  STATUSID NOT IN (102, 114)
	AND PCGROUP_ID = :ll_pcgroupid AND BROKERID = :al_id
	and STATUSCHANGED > dateadd(yy, -1, getdate());
	commit using SQLCA;
	ls_res = string(ll_fixed) + " / " + string(ll_total)
	

//   WHERE ISFIXTURE=1 and STATUSCHANGED > "25 Oct 2009"

end if

return ls_res
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_modify_fixture
   <OBJECT> </OBJECT>
   <DESC> </DESC>
   <USAGE> </USAGE>
   <ALSO></ALSO>
    Date       CR-Ref    Author       Comments
	 26/06/13	CR3244	 WWA048		  Duplicate the features specific to profit center group Crude to Nova
	 14/08/17	CR2894 	 KSH092			  As soon as user types a value in a numeric field ,allowed to leave it empay.
********************************************************************/
end subroutine

on w_modify_fixture.create
this.st_broker=create st_broker
this.st_chart=create st_chart
this.st_label1=create st_label1
this.p_source=create p_source
this.p_broker=create p_broker
this.p_char=create p_char
this.pb_refreshtc=create pb_refreshtc
this.uo_calculation=create uo_calculation
this.cb_calculation=create cb_calculation
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.dw_fixture=create dw_fixture
this.Control[]={this.st_broker,&
this.st_chart,&
this.st_label1,&
this.p_source,&
this.p_broker,&
this.p_char,&
this.pb_refreshtc,&
this.uo_calculation,&
this.cb_calculation,&
this.cb_update,&
this.cb_cancel,&
this.dw_fixture}
end on

on w_modify_fixture.destroy
destroy(this.st_broker)
destroy(this.st_chart)
destroy(this.st_label1)
destroy(this.p_source)
destroy(this.p_broker)
destroy(this.p_char)
destroy(this.pb_refreshtc)
destroy(this.uo_calculation)
destroy(this.cb_calculation)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.dw_fixture)
end on

event open;/********************************************************************
   open
   <DESC>  </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author             Comments
   	26/06/2013   CR3244       WWA048        		Duplicate the features specific to profit center group Crude to Nova
   </HISTORY>
********************************************************************/

long 					ll_row
int 					li_pc_nr, li_officeid,li_office_group

istr_fixture = message.powerobjectparm

dw_fixture.setTransObject(SQLCA)

this.move(1050,0)

if isNull(istr_fixture.id) then
	this.title = "Create New Fixture"
	uf_setDDDW(dw_fixture)

	dw_fixture.retrieve(0)
	ll_row = dw_fixture.InsertRow(0)
	if ll_row < 1 then return
	dw_fixture.setitem( 1,"isfixture",1)
	dw_fixture.setitem( 1,"fixturereported",today())
	dw_fixture.setitem( 1,"flatrateyear",Year(today()))
	dw_fixture.setitem( 1,"pcgroup_id",istr_fixture.pcgroup)
	// set status = subs when creating new fixture
	dw_fixture.setitem( 1,"pf_fixture_statusid",111) 
	// for crude/nova we also set a default cargoid
	if istr_fixture.pcgroup = c#pcgroup.ii_CRUDE then
		dw_fixture.setitem(1, "cargoid", 89)
	elseif istr_fixture.pcgroup = c#pcgroup.ii_NOVA then
		dw_fixture.setitem(1, "cargoid", 306)
	end if
	
	dw_fixture.setitem( 1,"cargotypeid",1) //spot
	dw_fixture.resetUpdate()    //set status to notModified!
	dw_fixture.setitemstatus( 1,0, Primary!, New!)  //set status back to New!
	
	SELECT USERS.OFFICE_NR, OFFICES.PCGROUP_ID 
	INTO :li_officeid, :li_office_group
	FROM USERS, OFFICES
	WHERE USERID=:uo_global.is_userid AND USERS.OFFICE_NR= OFFICES.OFFICE_NR;
	 if li_office_group = istr_fixture.pcgroup then
	  dw_fixture.setitem( 1,"officeid",li_officeid) 
	end if

else
	this.title = "Modify Fixture #"+string(istr_fixture.id)
	uf_setDDDW(dw_fixture)
	dw_fixture.retrieve(istr_fixture.id)
	if dw_fixture.getitemnumber( 1, "isfixture") = 0 then
		dw_fixture.setitem( 1,"isfixture",1)
	end if
	
	if isnull(dw_fixture.getitemnumber( 1,"chartererid" ))=false then
		w_modify_fixture.st_chart.text =_gettotalfixed( 1, dw_fixture.getitemnumber( 1,"chartererid" ))
	end if
	
	if isnull(dw_fixture.getitemnumber( 1,"brokerid" ))=false then
		w_modify_fixture.st_broker.text =_gettotalfixed( 2, dw_fixture.getitemnumber( 1,"brokerid" ))
	end if
	
end if

end event

event closequery;n_messagebox lnv_messagebox
integer			li_messagebox

dw_fixture.accepttext()
if dw_fixture.modifiedcount() > 0 then
	 w_fixture_list.bringtotop = true
	 if  w_fixture_list.windowstate = Minimized! then
		w_fixture_list.windowstate = Normal!
	end if
	li_messagebox = lnv_messagebox.of_messagebox(lnv_messagebox.is_TYPE_UNSAVED_DATA, this.title + ' window', this)
	choose case li_messagebox
		case 1
			if this.event ue_update() = C#return.Failure then
				return C#return.Failure
			end if
		case 2
			dw_fixture.retrieve(0)
		case else
			return C#return.Failure
	end choose
end if

return 0
end event

type st_broker from statictext within w_modify_fixture
integer x = 1330
integer y = 300
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0/0"
boolean focusrectangle = false
end type

type st_chart from statictext within w_modify_fixture
integer x = 1330
integer y = 228
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0/0"
boolean focusrectangle = false
end type

type st_label1 from statictext within w_modify_fixture
integer x = 1285
integer y = 156
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fixed / Total"
boolean focusrectangle = false
end type

type p_source from picture within w_modify_fixture
integer x = 1230
integer y = 376
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "images\DISTLSTL.GIF"
boolean focusrectangle = false
string powertiptext = "See details (if empty, click to create new source)"
end type

event clicked;_select_company( "sourceid")



end event

type p_broker from picture within w_modify_fixture
integer x = 1230
integer y = 304
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "images\DISTLSTL.GIF"
boolean focusrectangle = false
string powertiptext = "See details (if empty, click to create new broker)"
end type

event clicked;_select_company( "brokerid")

end event

type p_char from picture within w_modify_fixture
integer x = 1230
integer y = 228
integer width = 73
integer height = 64
string picturename = "images\DISTLSTL.GIF"
boolean focusrectangle = false
string powertiptext = "See details (if empty, click to create new charterer)"
end type

event clicked;_select_company( "chartererid")

end event

type pb_refreshtc from picturebutton within w_modify_fixture
integer x = 1230
integer y = 1664
integer width = 110
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Update5!"
alignment htextalign = left!
end type

event clicked;	dw_fixture.accepttext()
	uf_tc_calc (dw_fixture)
		
end event

type uo_calculation from u_tccalculation within w_modify_fixture
boolean visible = false
integer x = 1586
integer y = 2028
integer width = 352
integer height = 320
integer taborder = 20
end type

on uo_calculation.destroy
call u_tccalculation::destroy
end on

type cb_calculation from mt_u_commandbutton within w_modify_fixture
integer x = 41
integer y = 2256
integer width = 535
integer height = 112
integer taborder = 20
string facename = "Arial"
string text = "&Show TC Calculation"
end type

event clicked;
//openWithParm(w_f_tc_calculation, dw_fixture.getitemnumber(1,"fixtureid")) 
dw_fixture.accepttext()
openWithParm(w_f_tc_calculation, dw_fixture) 
return 1
end event

type cb_update from mt_u_commandbutton within w_modify_fixture
integer x = 919
integer y = 2256
integer width = 402
integer height = 112
integer taborder = 20
string facename = "Arial"
string text = "&Update"
end type

event clicked;/********************************************************************
   clicked
   <DESC>  </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author             Comments
   	26/06/2013   CR3244       WWA048        		Duplicate the features specific to profit center group Crude to Nova
	29/08/2017	  CR3350		  KSH092					New window event ue_update		
   </HISTORY>
********************************************************************/

if parent.event ue_update() = c#return.success then
	if isValid(w_fixture_list) then	
		w_fixture_list.post uf_setDDDW(w_fixture_list.dw_fixture)
		w_fixture_list.post event ue_refreshonerow(dw_fixture.getitemnumber(1, "fixtureid"))
	end if
	close(parent)
end if
	
end event

type cb_cancel from mt_u_commandbutton within w_modify_fixture
integer x = 1321
integer y = 2256
integer width = 402
integer height = 112
integer taborder = 30
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type dw_fixture from datawindow within w_modify_fixture
event ue_dwnkeypress pbm_dwnkey
integer width = 1733
integer height = 2232
integer taborder = 10
string title = "none"
string dataobject = "d_fixture"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_dwnkeypress;string ls_getcolumnname 
dec 	ldc_null

setnull(ldc_null)
ls_getcolumnname = this.getcolumnname()
if keyflags = 2 and (key = Key0! or key = KeyNumpad0!) then 
	if ls_getcolumnname = 'cargosize' or ls_getcolumnname = 'oprate' or ls_getcolumnname = 'rate' or ls_getcolumnname = 'flatrateyear' or ls_getcolumnname = 'demurragerate' or ls_getcolumnname = 'maersktcrt' or ls_getcolumnname = 'maersktcrtdays' or ls_getcolumnname = 'waitindays' then
		this.setitem(this.getrow(),ls_getcolumnname,ldc_null)
		this.selecttext(1,30)
	end if
end if
end event

event editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_fixture)


end event

event itemchanged;long ll_null; setNull(ll_null)
long ll_id

choose case dwo.name
	case "vesselid" 
		this.post setItem(row, "pf_fixture_vesselid_web",ll_null )
	case "pf_fixture_vesselid_web" 
		this.post setItem(row, "vesselid",ll_null )
	case "rate"
		this.accepttext( )
		if isnull(getitemnumber( row,"ratetypeid" ))then
		choose case long(data)
			case is > 1000
				this.setitem(1, "ratetypeid", 2)//LS
			case 100 to 1000
				this.setitem(1, "ratetypeid", 1)//WS
			case is < 100
				this.setitem(1, "ratetypeid", 3)//$/MT
		end choose
	end if
	case "brokerid"
		this.accepttext( )
		if isnull(getitemnumber( row,"sourceid" )) then
			this.setitem(row, "sourceid",getitemnumber(row,"brokerid"))
		else
			//Show totals
			ll_id = getitemnumber( row,"brokerid" )
			w_modify_fixture.st_broker.text = _gettotalfixed(2,ll_id)
		end if
		
	case "chartererid"
		//totals
		this.accepttext( )
		if isnull(getitemnumber( row,"chartererid" ))=false then
			//Show totals
			ll_id = getitemnumber( row,"chartererid" )
			w_modify_fixture.st_chart.text =_gettotalfixed(1,ll_id)
		end if
end choose

if dwo.name = 'cargosize' or dwo.name = 'oprate' or dwo.name = 'rate' or dwo.name = 'flatrateyear' or dwo.name = 'demurragerate'  or dwo.name = 'waitindays' then
	
		this.setitem( row, string(dwo.name), abs(dec(data)))
		return 2
end if


end event

event getfocus;string ls_getcolumnname 

ls_getcolumnname = this.getcolumnname()

if ls_getcolumnname = 'cargosize' or ls_getcolumnname = 'oprate' or ls_getcolumnname = 'rate' or ls_getcolumnname = 'flatrateyear' or ls_getcolumnname = 'demurragerate' or ls_getcolumnname = 'maersktcrt' or ls_getcolumnname = 'maersktcrtdays' or ls_getcolumnname = 'waitindays' then
	this.selecttext(1,30)
end if
end event

event itemfocuschanged;dec ldc_data
if dwo.name = 'cargosize' or dwo.name = 'oprate' or dwo.name = 'rate' or dwo.name = 'flatrateyear' or dwo.name = 'demurragerate' or dwo.name = 'maersktcrt' or dwo.name = 'maersktcrtdays' or dwo.name = 'waitindays' then
	this.selecttext(1,30)
end if



end event

