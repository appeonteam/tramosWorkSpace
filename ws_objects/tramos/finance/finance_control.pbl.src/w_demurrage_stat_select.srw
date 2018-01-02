$PBExportHeader$w_demurrage_stat_select.srw
$PBExportComments$This window is used to select vessel, charterer, broker, office
forward
global type w_demurrage_stat_select from mt_w_response
end type
type cb_deselect from commandbutton within w_demurrage_stat_select
end type
type cb_ok from commandbutton within w_demurrage_stat_select
end type
type cb_cancel from commandbutton within w_demurrage_stat_select
end type
type st_1 from statictext within w_demurrage_stat_select
end type
type dw_select_list from datawindow within w_demurrage_stat_select
end type
type cb_selectall from commandbutton within w_demurrage_stat_select
end type
end forward

global type w_demurrage_stat_select from mt_w_response
integer width = 1509
integer height = 1992
string title = "Select ..."
boolean controlmenu = false
event ue_retrieve pbm_custom01
cb_deselect cb_deselect
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
dw_select_list dw_select_list
cb_selectall cb_selectall
end type
global w_demurrage_stat_select w_demurrage_stat_select

type variables
s_demurrage_stat_selection istr_parm
integer 	ii_number[]
string		is_string[]
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_retrieve;integer li_upper, li_x, li_row, li_y
string ls_search, ls_vessel_nr, ls_analyst
		
setnull(ls_analyst)
if  istr_parm.called_from = "vessel" then
	if istr_parm.analyst = "" or isnull(istr_parm.analyst) then
		dw_select_list.retrieve(istr_parm.profitcenter)
	else
		dw_select_list.retrieve(istr_parm.analyst, istr_parm.profitcenter)
	end if
else
	dw_select_list.retrieve(istr_parm.profitcenter)
end if
dw_select_list.SetRowFocusIndicator(FocusRect!)

CHOOSE CASE lower(istr_parm.called_from)
	CASE "claimtype"
		li_upper = UpperBound(is_string)
	CASE ELSE 
		li_upper = UpperBound(ii_number)
END CHOOSE		

for li_x = 1 to li_upper
	CHOOSE CASE lower(istr_parm.called_from)
		CASE "claimtype"
			ls_search = "string='"+string(is_string[li_x])+"'"
		CASE ELSE
			ls_search = "number="+string(ii_number[li_x])
	END CHOOSE		
	li_row = dw_select_list.find(ls_search, 1, dw_select_list.rowcount())
	if li_row > 0 then dw_select_list.selectrow(li_row,True)
next 
end event

public subroutine documentation ();/********************************************************************
	w_demurrage_stat_select
	
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
		13/01/2017	CR2679		CCY018		Fixed a bug
	</HISTORY>
********************************************************************/
end subroutine

on w_demurrage_stat_select.create
int iCurrent
call super::create
this.cb_deselect=create cb_deselect
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.dw_select_list=create dw_select_list
this.cb_selectall=create cb_selectall
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_deselect
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_select_list
this.Control[iCurrent+6]=this.cb_selectall
end on

on w_demurrage_stat_select.destroy
call super::destroy
destroy(this.cb_deselect)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.dw_select_list)
destroy(this.cb_selectall)
end on

event open;istr_parm = message.PowerObjectParm
CHOOSE CASE istr_parm.called_from
	CASE "vessel"
		ii_number = istr_parm.vessel_nr
		if istr_parm.analyst = "" or isnull(istr_parm.analyst) then
			dw_select_list.DataObject = "d_demurrage_stat_select_vessel"
		else
			dw_select_list.DataObject = "d_demurrage_stat_select_vessel_demanalyst"
		end if
		if istr_parm.come_from = "w_print_r_outstanding_freights" then
			dw_select_list.DataObject = "d_sq_gr_outfrt_select_vessel"
		end if
		
		this.title = "Select Vessel from list"
	CASE "chart"
		ii_number = istr_parm.chart_nr
		dw_select_list.DataObject = "d_demurrage_stat_select_chart"
		if istr_parm.come_from = "w_print_r_outstanding_freights" then
			dw_select_list.DataObject = "d_sq_gr_outfrt_select_chart"
		end if
		
		this.title = "Select Charterer from list"
	CASE "broker"
		ii_number = istr_parm.broker_nr
		dw_select_list.DataObject = "d_demurrage_stat_select_broker"
		this.title = "Select Broker from list"
	CASE "office"
		ii_number = istr_parm.office_nr
		dw_select_list.DataObject = "d_demurrage_stat_select_office"
		if istr_parm.come_from = "w_print_r_outstanding_freights" then
			dw_select_list.DataObject = "d_sq_gr_outfrt_select_office"
		end if
		
		this.title = "Select Office from list"
	CASE "profitcenter"
		ii_number = istr_parm.chart_nr   /* profitcenter not in structure */
		dw_select_list.DataObject = "d_demurrage_stat_select_profitc"
		this.title = "Select Profitcenter from list"
	CASE "claimtype"
		is_string = istr_parm.claimtype
		dw_select_list.DataObject = "d_demurrage_stat_select_claimtype"
		this.title = "Select Claimtype from list"
END CHOOSE

dw_select_list.settransobject(SQLCA)

n_service_manager		lnv_serviceMgr
n_dw_style_service   lnv_style
lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_select_list)


this.PostEvent("ue_retrieve")
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_demurrage_stat_select
end type

type cb_deselect from commandbutton within w_demurrage_stat_select
integer x = 384
integer y = 1780
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Deselect All"
end type

event clicked;dw_select_list.selectRow(0, false)

end event

type cb_ok from commandbutton within w_demurrage_stat_select
integer x = 773
integer y = 1780
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;integer 	li_clean_array[]
string	ls_clean_array[]	
long 		ll_row, ll_rows

ii_number = li_clean_array 
is_string = ls_clean_array

ll_row = dw_select_list.getselectedrow(0)
if ll_row > 0 then
	ll_rows = dw_select_list.rowcount()
	FOR ll_row=0 TO ll_rows
		if (dw_select_list.isselected(ll_row)) then
			CHOOSE CASE lower(istr_parm.called_from)
				CASE "claimtype"
					is_string[UpperBound(is_string)+1] = dw_select_list.getitemstring(ll_row, "string")
				CASE "vessel"
					is_string[UpperBound(is_string)+1] = dw_select_list.getitemstring(ll_row, "vessel_ref_nr")
					ii_number[UpperBound(ii_number)+1] = dw_select_list.getitemnumber(ll_row, "number")
				CASE ELSE
					ii_number[UpperBound(ii_number)+1] = dw_select_list.getitemnumber(ll_row, "number")
			END CHOOSE		
		end if
	NEXT
end if

CHOOSE CASE lower(istr_parm.called_from)
	CASE "vessel"
		istr_parm.vessel_nr = li_clean_array
		istr_parm.vessel_nr = ii_number
		istr_parm.vessel_ref_nr = ls_clean_array
		istr_parm.vessel_ref_nr = is_string
	CASE "chart"
		istr_parm.chart_nr = li_clean_array
		istr_parm.chart_nr = ii_number
	CASE "broker"
		istr_parm.broker_nr = li_clean_array
		istr_parm.broker_nr = ii_number
	CASE "office"
		istr_parm.office_nr = li_clean_array
		istr_parm.office_nr = ii_number
	CASE "profitcenter"
		istr_parm.chart_nr = li_clean_array /* as profitcenter not in structure */
		istr_parm.chart_nr = ii_number
	CASE "claimtype"
		istr_parm.claimtype = ls_clean_array 
		istr_parm.claimtype = is_string
END CHOOSE

closewithreturn(parent,istr_parm)


end event

type cb_cancel from commandbutton within w_demurrage_stat_select
integer x = 1120
integer y = 1780
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
boolean cancel = true
end type

event clicked;closewithreturn(parent,istr_parm)

end event

type st_1 from statictext within w_demurrage_stat_select
integer x = 37
integer y = 16
integer width = 457
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Select from list"
boolean focusrectangle = false
end type

type dw_select_list from datawindow within w_demurrage_stat_select
integer x = 37
integer y = 80
integer width = 1426
integer height = 1680
integer taborder = 10
string title = "none"
string dataobject = "d_demurrage_stat_select_vessel"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string ls_sort

if (row >0) then
	this.selectrow(row,not this.isselected(row))
end if

if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
end if
end event

type cb_selectall from commandbutton within w_demurrage_stat_select
integer x = 37
integer y = 1780
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Select All"
end type

event clicked;dw_select_list.selectRow(0, true)

end event

