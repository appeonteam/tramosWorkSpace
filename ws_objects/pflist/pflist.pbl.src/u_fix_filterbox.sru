$PBExportHeader$u_fix_filterbox.sru
forward
global type u_fix_filterbox from u_base_filterbox
end type
type em_days_filter from mt_u_editmask within u_fix_filterbox
end type
type st_days_filter from mt_u_statictext within u_fix_filterbox
end type
type st_vessel_filter from mt_u_statictext within u_fix_filterbox
end type
type st_competitior_filter from mt_u_statictext within u_fix_filterbox
end type
type st_charterer_filter from mt_u_statictext within u_fix_filterbox
end type
type st_broker_filter from mt_u_statictext within u_fix_filterbox
end type
type st_office_filter from mt_u_statictext within u_fix_filterbox
end type
type st_larea from mt_u_statictext within u_fix_filterbox
end type
type st_darea from mt_u_statictext within u_fix_filterbox
end type
type st_cargotype_filter from mt_u_statictext within u_fix_filterbox
end type
type dw_cargotype_filter from u_base_filterdw within u_fix_filterbox
end type
type dw_charterer_filter from u_base_filterdw within u_fix_filterbox
end type
type dw_broker_filter from u_base_filterdw within u_fix_filterbox
end type
type dw_vessel_filter from u_base_filterdw within u_fix_filterbox
end type
type dw_darea_filter from u_base_filterdw within u_fix_filterbox
end type
type dw_competitor_filter from u_base_filterdw within u_fix_filterbox
end type
type dw_larea_filter from u_base_filterdw within u_fix_filterbox
end type
type dw_office_filter from u_base_filterdw within u_fix_filterbox
end type
type cb_save from mt_u_commandbutton within u_fix_filterbox
end type
end forward

global type u_fix_filterbox from u_base_filterbox
integer height = 1776
em_days_filter em_days_filter
st_days_filter st_days_filter
st_vessel_filter st_vessel_filter
st_competitior_filter st_competitior_filter
st_charterer_filter st_charterer_filter
st_broker_filter st_broker_filter
st_office_filter st_office_filter
st_larea st_larea
st_darea st_darea
st_cargotype_filter st_cargotype_filter
dw_cargotype_filter dw_cargotype_filter
dw_charterer_filter dw_charterer_filter
dw_broker_filter dw_broker_filter
dw_vessel_filter dw_vessel_filter
dw_darea_filter dw_darea_filter
dw_competitor_filter dw_competitor_filter
dw_larea_filter dw_larea_filter
dw_office_filter dw_office_filter
cb_save cb_save
end type
global u_fix_filterbox u_fix_filterbox

forward prototypes
public function integer of_updatefilterdddw (integer ai_pcgroup)
public function long of_getnbrofdays ()
public function string of_save_filter ()
public function string of_generate_filter (integer ai_dwindex)
end prototypes

public function integer of_updatefilterdddw (integer ai_pcgroup);/********************************************************************
   FunctionName
   <DESC>   Description</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

integer li_control_index, li_i, li_datawindows, li_dw_index
u_base_filterdw ldw
datawindowchild ldwc
long ll_temp_days, ll_rows
String			  ls_filter_value, ls_dropdown_name, ls_filter_array[], ls_filterstring
n_Usersetting uo_usersetting

ii_pcgroup=ai_pcgroup

SELECT MAX(DAYSONLIST) 
INTO :il_max_days
FROM PF_FIXTURE_STATUS_CONFIG 
WHERE PCGROUP_ID=:ii_pcgroup;

em_days_filter.MinMax = ("1 ~~ " + string(il_max_days))

if long(em_days_filter.text)>il_max_days then
	em_days_filter.text=string(il_max_days)
	
end if

of_reset_filters()

//this is where we get the user saved settings
ls_filter_value = ""
uo_usersetting.of_getsetting(uo_global.is_userid, "pflist.pbl>w_fixture_list>uo_filter-" + string(ai_pcgroup), ls_filter_value,"")		
f_split(ls_filter_array,ls_filter_value,";")
if ls_filter_value <> "" then
	if ls_filter_array[Upperbound(ls_filter_array)] <> ""  then
		 this.em_days_filter.text = trim(ls_filter_array[Upperbound(ls_filter_array)])
		 em_days_filter.event modified( )
	end if
end if
for li_control_index = 1 to Upperbound(idddw_filter) 
	ldw=idddw_filter[li_control_index]
	ldw.getchild(ldw.Describe("#1.Name"), ldwc)
	ldwc.retrieve( ai_pcgroup )
	if lower(ldw.is_port_type)="load" then
		ldwc.setfilter("type_LD=1")
		ldwc.filter()
	elseif lower(ldw.is_port_type)="discharge" then 
		ldwc.setfilter("type_LD=2")
		ldwc.filter()
	end if
	if  ls_filter_value <> ""  then
		if ls_filter_array[li_control_index] <> "" then
			ls_dropdown_name = ldw.Describe("#1.Name")		
			ldw.setitem(1, ls_dropdown_name,Integer(trim(ls_filter_array[li_control_index])))
			is_dddwfilter[li_control_index] = ldw.is_filter_field + " = " + trim(ls_filter_array[li_control_index])
		end if
	end if
next 
//just filter without change
if ls_filter_value <> "" then
	of_setfilter("",-1) 
end if


return 1
end function

public function long of_getnbrofdays ();/*
	used to return the correct value used in the retrieval of the dw's
*/

if long(this.em_days_filter.text)>il_user_days then
	return long(this.em_days_filter.text)
else
	return il_user_days
end if
end function

public function string of_save_filter ();/********************************************************************
   of_save_filter()
   <DESC>   This function builds the filter string to be saved in DB</DESC>
   <RETURN> String:
            </RETURN>
   <ACCESS> Private</ACCESS>
   <USAGE>  the order of the saved filter items is: 
				cargo grade;charterer;broker;vessel;D area;
				competitor;L area;office;days
	</USAGE>
********************************************************************/


string ls_filter, ls_days, ls_name
integer li_control_index
u_base_filterdw ldw

ls_filter=""
for li_control_index = 1 to Upperbound(idddw_filter) 
	ldw=idddw_filter[li_control_index]
	ls_name = ldw.Describe("#1.Name")
	if isnull(ldw.getitemnumber(1, ls_name)) then
		ls_filter = ls_filter + ";"
	else
		ls_filter = ls_filter + ";" + string(ldw.getitemnumber(1, ls_name))
	end if	
next 

if isnull(this.em_days_filter.text) or this.em_days_filter.text = ""  then
	ls_days = "0"
else
	ls_days = this.em_days_filter.text
end if
ls_filter = ls_filter + ";" + ls_days

return mid(ls_filter,2)
end function

public function string of_generate_filter (integer ai_dwindex);/********************************************************************
   of_generate_filter( /*integer ai_dwindex */)
   <DESC>   This function builds the filter string</DESC>
   <RETURN> String:
            </RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   ai_dwindex: reference to the datawindow to be filtered
            </ARGS>
   <USAGE>  The space character at the end of the is_dddwfilter array element
				is important to control the process.  There is validation to check if
				the filtered column reference exists in the target datawindow</USAGE>
********************************************************************/


string ls_filter, ls_validcontrol, ls_filtercontrol, ls_days
integer li_index

ls_filter=""


for li_index = 1 to upperbound(is_dddwfilter)
	if pos(is_dddwfilter[li_index],"=")>0 then
		ls_filtercontrol = left(is_dddwfilter[li_index],pos(is_dddwfilter[li_index]," ")-1)
		ls_validcontrol=idw_data[ai_dwindex].Describe(ls_filtercontrol + ".ColType")
		if ls_validcontrol<>"!" then
			ls_filter = ls_filter + " and " + is_dddwfilter[li_index]
		end if
	end if
next



if isnull(this.em_days_filter.text) or this.em_days_filter.text = ""  then
	ls_days = "0"
else
	ls_days = this.em_days_filter.text
end if

ls_filter = ls_filter + " and daysafter(reported, today()) <= " + ls_days

return mid(ls_filter,6)
end function

on u_fix_filterbox.create
int iCurrent
call super::create
this.em_days_filter=create em_days_filter
this.st_days_filter=create st_days_filter
this.st_vessel_filter=create st_vessel_filter
this.st_competitior_filter=create st_competitior_filter
this.st_charterer_filter=create st_charterer_filter
this.st_broker_filter=create st_broker_filter
this.st_office_filter=create st_office_filter
this.st_larea=create st_larea
this.st_darea=create st_darea
this.st_cargotype_filter=create st_cargotype_filter
this.dw_cargotype_filter=create dw_cargotype_filter
this.dw_charterer_filter=create dw_charterer_filter
this.dw_broker_filter=create dw_broker_filter
this.dw_vessel_filter=create dw_vessel_filter
this.dw_darea_filter=create dw_darea_filter
this.dw_competitor_filter=create dw_competitor_filter
this.dw_larea_filter=create dw_larea_filter
this.dw_office_filter=create dw_office_filter
this.cb_save=create cb_save
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_days_filter
this.Control[iCurrent+2]=this.st_days_filter
this.Control[iCurrent+3]=this.st_vessel_filter
this.Control[iCurrent+4]=this.st_competitior_filter
this.Control[iCurrent+5]=this.st_charterer_filter
this.Control[iCurrent+6]=this.st_broker_filter
this.Control[iCurrent+7]=this.st_office_filter
this.Control[iCurrent+8]=this.st_larea
this.Control[iCurrent+9]=this.st_darea
this.Control[iCurrent+10]=this.st_cargotype_filter
this.Control[iCurrent+11]=this.dw_cargotype_filter
this.Control[iCurrent+12]=this.dw_charterer_filter
this.Control[iCurrent+13]=this.dw_broker_filter
this.Control[iCurrent+14]=this.dw_vessel_filter
this.Control[iCurrent+15]=this.dw_darea_filter
this.Control[iCurrent+16]=this.dw_competitor_filter
this.Control[iCurrent+17]=this.dw_larea_filter
this.Control[iCurrent+18]=this.dw_office_filter
this.Control[iCurrent+19]=this.cb_save
end on

on u_fix_filterbox.destroy
call super::destroy
destroy(this.em_days_filter)
destroy(this.st_days_filter)
destroy(this.st_vessel_filter)
destroy(this.st_competitior_filter)
destroy(this.st_charterer_filter)
destroy(this.st_broker_filter)
destroy(this.st_office_filter)
destroy(this.st_larea)
destroy(this.st_darea)
destroy(this.st_cargotype_filter)
destroy(this.dw_cargotype_filter)
destroy(this.dw_charterer_filter)
destroy(this.dw_broker_filter)
destroy(this.dw_vessel_filter)
destroy(this.dw_darea_filter)
destroy(this.dw_competitor_filter)
destroy(this.dw_larea_filter)
destroy(this.dw_office_filter)
destroy(this.cb_save)
end on

type gb_1 from u_base_filterbox`gb_1 within u_fix_filterbox
integer height = 1760
integer taborder = 0
end type

type cb_reset from u_base_filterbox`cb_reset within u_fix_filterbox
integer y = 1632
end type

event cb_reset::clicked;call super::clicked;if of_reset_filters()=-1 then
	messagebox("Error","seems to be an error here")
end if

if em_days_filter.text <> string(il_user_days) then
	em_days_filter.text = string(il_user_days)
 	em_days_filter.event modified()
end if
end event

type em_days_filter from mt_u_editmask within u_fix_filterbox
event ue_bndoubleclicked pbm_bndoubleclicked
event ue_change pbm_enchange
accessiblerole accessiblerole = alertrole!
integer x = 41
integer y = 1488
integer width = 274
integer height = 80
integer taborder = 90
boolean bringtotop = true
string text = "1000"
alignment alignment = center!
string mask = "####"
boolean spin = true
double increment = 10
string minmax = "0~~1000"
end type

event ue_change;this.event modified()
end event

event constructor;call super::constructor;string ls_userid

/* Get number of days to retrieve */
ls_userid = uo_global.is_userid

SELECT FIXTURE_DAYS
INTO :il_user_days
FROM USERS
WHERE USERID = :ls_userid;

//if il_user_days<1 then
 if il_user_days<1 or isnull(il_user_days) then
	il_user_days=30
end if

em_days_filter.text = string(il_user_days)



end event

event modified;call super::modified;string ls_filterstring
integer li_datawindows
window  lw_fixture


if long(this.text)>il_max_days then
	this.text=string(il_max_days)
//	messagebox("Notice","Due to settings in the fixture status options the maximum amount of days available is: " + string(il_max_days))
elseif long(this.text)<1 then
	this.text="0"
end if

// force retreive
if il_user_days<=long(this.text) then
	lw_fixture = parent.getparent( )
	lw_fixture.PostEvent("ue_refreshrequest")
	//temporary adding of this line
//	il_user_days=long(this.text)
end if
	
for li_datawindows = 1 to upperbound(idw_data)
//	ls_filterstring = of_generate_filter(li_datawindows)
//	idw_data[li_datawindows].setfilter(ls_filterstring)
//	idw_data[li_datawindows].filter()
	of_setfilter("", -1)
next


end event

type st_days_filter from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 1408
integer width = 439
boolean bringtotop = true
string text = "By Number Of Days"
end type

event doubleclicked;call super::doubleclicked;w_f_status w_fix_status_days

//OpenSheet(pw_window,w_tramos_main,0,Original!)
//OpenSheet(w_fix_status_days,"w_f_status",0,Original!)

open(w_fix_status_days, "w_f_status")
w_fix_status_days.dw_status.enabled=false
//w_fix_status_days.uo_pcgroup.enabled=false
w_fix_status_days.cb_edit.visible=false



end event

type st_vessel_filter from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 96
integer width = 411
boolean bringtotop = true
string text = "By Vessel"
end type

event doubleclicked;call super::doubleclicked;messagebox("Info","This filter only works for the fixture list")
end event

type st_competitior_filter from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 252
integer width = 471
boolean bringtotop = true
string text = "By Competitor Vessel"
end type

event doubleclicked;call super::doubleclicked;messagebox("Info","This filter only works for the fixture list")
end event

type st_charterer_filter from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 408
integer width = 411
boolean bringtotop = true
string text = "By Charterer"
end type

type st_broker_filter from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 564
integer width = 411
boolean bringtotop = true
string text = "By Broker"
end type

type st_office_filter from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 720
boolean bringtotop = true
string text = "By Office"
end type

type st_larea from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 876
boolean bringtotop = true
string text = "By Load Area"
end type

type st_darea from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 1032
integer width = 411
boolean bringtotop = true
string text = "By Discharge Area"
end type

type st_cargotype_filter from mt_u_statictext within u_fix_filterbox
integer x = 37
integer y = 1188
integer width = 411
boolean bringtotop = true
string text = "By Cargo Grade"
end type

type dw_cargotype_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 1264
integer width = 663
integer height = 80
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_sq_tb_cleaningtype_by_pcgroup"
string is_filter_field = "cleaningtypeid"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_cargotype_filter)
end event

type dw_charterer_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 464
integer width = 663
integer height = 80
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sq_tb_charterer_by_pcgroup"
string is_filter_field = "chartererid"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_charterer_filter)
end event

type dw_broker_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 624
integer width = 663
integer height = 80
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sq_tb_broker_by_pcgroup"
string is_filter_field = "brokerid"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_broker_filter)
end event

type dw_vessel_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 160
integer width = 663
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sq_tb_vessel_by_pcgroup"
string is_filter_field = "vesselid"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_vessel_filter)
end event

type dw_darea_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 1104
integer width = 663
integer height = 80
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sq_tb_area_by_pcgroup"
string is_port_type = "discharge"
string is_filter_field = "pf_fixture_trade_dischargeareaid"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_darea_filter)
end event

type dw_competitor_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 320
integer width = 663
integer height = 80
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sq_tb_competitor_by_pcgroup"
string is_filter_field = "pf_fixture_vesselid_web"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_competitor_filter)
end event

type dw_larea_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 944
integer width = 663
integer height = 80
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sq_tb_area_by_pcgroup"
string is_port_type = "load"
string is_filter_field = "pf_fixture_trade_loadareaid"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_larea_filter)
end event

type dw_office_filter from u_base_filterdw within u_fix_filterbox
integer x = 32
integer y = 784
integer width = 663
integer height = 80
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sq_tb_office_by_pcgroup"
string is_filter_field = "officeid"
end type

event editchanged;call super::editchanged;datawindowchild ldwc
this.getchild(this.Describe("#1.Name"), ldwc)
if ldwc.rowcount()=0 then ldwc.retrieve(ii_pcgroup)
inv_dddw_search.event mt_editchanged(row, dwo, data, dw_office_filter)
end event

type cb_save from mt_u_commandbutton within u_fix_filterbox
integer x = 311
integer y = 1632
integer width = 361
integer height = 96
integer taborder = 110
boolean bringtotop = true
string text = "Save Fil&ter"
end type

event clicked;call super::clicked;String			  ls_filterstring, ls_value
integer		  li_datawindows
n_Usersetting uo_usersetting

ls_value = of_save_filter()
if ls_value <> "" then
	ls_filterstring = "pflist.pbl>w_fixture_list>uo_filter-" + string(ii_pcgroup) 
	uo_usersetting.of_savesetting(uo_global.is_userid, ls_filterstring, ls_value)
end if


end event

