$PBExportHeader$w_fin_agent_payments.srw
$PBExportComments$Default select/edit window
forward
global type w_fin_agent_payments from window
end type
type st_year from statictext within w_fin_agent_payments
end type
type sle_year from singlelineedit within w_fin_agent_payments
end type
type rb_sno from radiobutton within w_fin_agent_payments
end type
type rb_profit_center_search from radiobutton within w_fin_agent_payments
end type
type rb_agent from radiobutton within w_fin_agent_payments
end type
type uo_profit_center from uo_fin_profitcenter within w_fin_agent_payments
end type
type rb_2 from radiobutton within w_fin_agent_payments
end type
type rb_1 from radiobutton within w_fin_agent_payments
end type
type cb_print from commandbutton within w_fin_agent_payments
end type
type rb_this_year from radiobutton within w_fin_agent_payments
end type
type rb_all_voyages from radiobutton within w_fin_agent_payments
end type
type cb_close from commandbutton within w_fin_agent_payments
end type
type gb_2 from groupbox within w_fin_agent_payments
end type
type dw_agent_payments from datawindow within w_fin_agent_payments
end type
type uo_agent from uo_fin_agent within w_fin_agent_payments
end type
type uo_agent_sno from uo_fin_agent_sno within w_fin_agent_payments
end type
type gb_3 from groupbox within w_fin_agent_payments
end type
type gb_4 from groupbox within w_fin_agent_payments
end type
type gb_profit_center_search from groupbox within w_fin_agent_payments
end type
end forward

global type w_fin_agent_payments from window
integer x = 677
integer y = 268
integer width = 4654
integer height = 2620
boolean titlebar = true
string title = "Agent list"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 81324524
event ue_entry_chosen pbm_custom01
event ue_retrieve pbm_custom02
st_year st_year
sle_year sle_year
rb_sno rb_sno
rb_profit_center_search rb_profit_center_search
rb_agent rb_agent
uo_profit_center uo_profit_center
rb_2 rb_2
rb_1 rb_1
cb_print cb_print
rb_this_year rb_this_year
rb_all_voyages rb_all_voyages
cb_close cb_close
gb_2 gb_2
dw_agent_payments dw_agent_payments
uo_agent uo_agent
uo_agent_sno uo_agent_sno
gb_3 gb_3
gb_4 gb_4
gb_profit_center_search gb_profit_center_search
end type
global w_fin_agent_payments w_fin_agent_payments

type variables
long   il_selectedrow

// string  is_filter
s_list istr_parametre
boolean ib_column_string[0 to 2] // True, False 

// integer ii_current_column

u_jump_disbursement iuo_jump_disbursement


end variables

forward prototypes
public subroutine wf_open_detail ()
public subroutine wf_gotodisbursement ()
end prototypes

event ue_retrieve;//dw_1.Retrieve()
//COMMIT;
////ii_search_column = istr_parametre.search_column_1
////ib_search_column_string = ib_search_column_1_string
//sle_find.SetFocus()
end event

public subroutine wf_open_detail ();w_list_detail mydata
Window mywindow

If (IsNull(istr_parametre.edit_window_title)) Or (istr_parametre.edit_window_title = "")  Then &
	istr_parametre.edit_window_title = Istr_parametre.window_title

If Not IsNull(istr_parametre.edit_datawindow) Then
	OpenSheetWithParm( mydata, istr_parametre, w_tramos_main, 7, Original!)
Elseif Not IsNull(istr_parametre.edit_window) Then
	If ib_column_string[0] Then
		OpenSheetWithParm(mywindow, istr_parametre.edit_key_text, istr_parametre.edit_window,  w_tramos_main, 7, original!)
	else
		OpenSheetWithParm(mywindow,  istr_parametre.edit_key_number, istr_parametre.edit_window, w_tramos_main, 7, original!)
	end if
end if


end subroutine

public subroutine wf_gotodisbursement ();string ls_agent_sn, ls_voyage_nr, ls_port_code
integer li_vessel_nr, li_pcn

li_vessel_nr = dw_agent_payments.getitemnumber(dw_agent_payments.getrow(), "disbursements_vessel_nr")
ls_voyage_nr = dw_agent_payments.getitemstring(dw_agent_payments.getrow(), "disbursements_voyage_nr")
ls_port_code = dw_agent_payments.getitemstring(dw_agent_payments.getrow(), "disbursements_port_code")
ls_agent_sn  = dw_agent_payments.getitemstring(dw_agent_payments.getrow(), "agents_agent_sn")
li_pcn		 = dw_agent_payments.getitemnumber(dw_agent_payments.getrow(), "disbursements_pcn")

iuo_jump_disbursement.of_open_disbursement(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, ls_agent_sn)
end subroutine

event open;dw_agent_payments.settransobject(SQLCA)

this.Title = "Agent Payments"

this.move(0,0)

uo_agent.wf_initialize()
uo_profit_center.wf_initialize()
dw_agent_payments.SetRowFocusIndicator(FOCUSRECT!)
iuo_jump_disbursement = create u_jump_disbursement




end event

on w_fin_agent_payments.create
this.st_year=create st_year
this.sle_year=create sle_year
this.rb_sno=create rb_sno
this.rb_profit_center_search=create rb_profit_center_search
this.rb_agent=create rb_agent
this.uo_profit_center=create uo_profit_center
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_print=create cb_print
this.rb_this_year=create rb_this_year
this.rb_all_voyages=create rb_all_voyages
this.cb_close=create cb_close
this.gb_2=create gb_2
this.dw_agent_payments=create dw_agent_payments
this.uo_agent=create uo_agent
this.uo_agent_sno=create uo_agent_sno
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_profit_center_search=create gb_profit_center_search
this.Control[]={this.st_year,&
this.sle_year,&
this.rb_sno,&
this.rb_profit_center_search,&
this.rb_agent,&
this.uo_profit_center,&
this.rb_2,&
this.rb_1,&
this.cb_print,&
this.rb_this_year,&
this.rb_all_voyages,&
this.cb_close,&
this.gb_2,&
this.dw_agent_payments,&
this.uo_agent,&
this.uo_agent_sno,&
this.gb_3,&
this.gb_4,&
this.gb_profit_center_search}
end on

on w_fin_agent_payments.destroy
destroy(this.st_year)
destroy(this.sle_year)
destroy(this.rb_sno)
destroy(this.rb_profit_center_search)
destroy(this.rb_agent)
destroy(this.uo_profit_center)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_print)
destroy(this.rb_this_year)
destroy(this.rb_all_voyages)
destroy(this.cb_close)
destroy(this.gb_2)
destroy(this.dw_agent_payments)
destroy(this.uo_agent)
destroy(this.uo_agent_sno)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_profit_center_search)
end on

event close;destroy iuo_jump_disbursement
end event

type st_year from statictext within w_fin_agent_payments
boolean visible = false
integer x = 256
integer y = 528
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year (yyyy)"
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_fin_agent_payments
boolean visible = false
integer x = 256
integer y = 592
integer width = 343
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_filter

ls_filter =  "left(compute_voyage_sort , 4 ) = " + "'" + sle_year.text +"'"  
dw_agent_payments.setredraw(false)
dw_agent_payments.setfilter(ls_filter)
dw_agent_payments.filter()
dw_agent_payments.setredraw(true)
end event

type rb_sno from radiobutton within w_fin_agent_payments
integer x = 251
integer y = 228
integer width = 530
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agent S-number"
end type

event clicked;If not (uo_agent_sno.visible) then 
	uo_agent.visible = false
	uo_agent_sno.visible = true
end if
	
end event

type rb_profit_center_search from radiobutton within w_fin_agent_payments
boolean visible = false
integer x = 251
integer y = 128
integer width = 859
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profitcenter number or name"
boolean checked = true
end type

type rb_agent from radiobutton within w_fin_agent_payments
integer x = 251
integer y = 128
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agent short or full name"
boolean checked = true
end type

event clicked;If not (uo_agent.visible) then 
	uo_agent_sno.visible = false
	uo_agent.visible = true
end if

end event

type uo_profit_center from uo_fin_profitcenter within w_fin_agent_payments
boolean visible = false
integer x = 1298
integer y = 40
integer taborder = 40
end type

on uo_profit_center.destroy
call uo_fin_profitcenter::destroy
end on

type rb_2 from radiobutton within w_fin_agent_payments
integer x = 3954
integer y = 172
integer width = 411
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Profitcenter"
end type

event clicked;dw_agent_payments.DataObject = "d_fin_agent_profit_center_payments"
dw_agent_payments.settransobject(SQLCA)
dw_agent_payments.SetRowFocusIndicator(FOCUSRECT!)

uo_agent.visible = false
uo_agent_sno.visible = false
uo_profit_center.visible = true
gb_profit_center_search.visible = true
rb_profit_center_search.checked = true
gb_2.visible = false

rb_sno.visible = false
rb_agent.visible = false
rb_profit_center_search.visible = true
rb_all_voyages.visible = false
rb_this_year.visible = false
st_year.visible = true
sle_year.visible = true
sle_year.text = string(year(today()))
end event

type rb_1 from radiobutton within w_fin_agent_payments
integer x = 3959
integer y = 104
integer width = 343
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agent"
boolean checked = true
end type

event clicked;dw_agent_payments.DataObject = "d_fin_agent_payments"
dw_agent_payments.settransobject(SQLCA)
dw_agent_payments.SetRowFocusIndicator(FOCUSRECT!)
uo_agent.visible = true
uo_agent_sno.visible = false
uo_profit_center.visible = false
rb_agent.checked = true
gb_profit_center_search.visible = true
gb_2.visible = false

rb_sno.visible = true
rb_agent.visible = true
rb_profit_center_search.visible = false
rb_all_voyages.visible = true
rb_this_year.visible = true
st_year.visible = false
sle_year.visible = false
end event

type cb_print from commandbutton within w_fin_agent_payments
integer x = 3831
integer y = 640
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_agent_payments.Object.DataWindow.Print.orientation = 1
dw_agent_payments.print()
end event

type rb_this_year from radiobutton within w_fin_agent_payments
integer x = 251
integer y = 624
integer width = 440
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Only This Year"
boolean checked = true
end type

event clicked;string ls_filter

ls_filter =  "left(compute_voyage_sort , 4 ) = " + "'" + string(year(today())) +"'"
dw_agent_payments.setredraw(false)
dw_agent_payments.setfilter(ls_filter)
dw_agent_payments.filter()
dw_agent_payments.setredraw(true)

end event

type rb_all_voyages from radiobutton within w_fin_agent_payments
integer x = 251
integer y = 528
integer width = 393
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
end type

event clicked;string ls_filter

ls_filter =  ""
dw_agent_payments.setredraw(false)
dw_agent_payments.setfilter(ls_filter)
dw_agent_payments.filter()
dw_agent_payments.setredraw(true)

end event

type cb_close from commandbutton within w_fin_agent_payments
integer x = 4201
integer y = 640
integer width = 375
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

on clicked;close(parent)
end on

type gb_2 from groupbox within w_fin_agent_payments
integer x = 50
integer y = 16
integer width = 1147
integer height = 344
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search on:"
end type

type dw_agent_payments from datawindow within w_fin_agent_payments
integer x = 37
integer y = 864
integer width = 4562
integer height = 1604
integer taborder = 30
string title = "none"
string dataobject = "d_fin_agent_payments"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort

If (Row > 0) And (row <> GetSelectedRow(row - 1)) Then 
	SelectRow(0,false)
	SetRow(row)
	SelectRow(row,True)
End if

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

event retrieveend;IF rb_1.checked = true THEN
	if (rb_all_voyages.checked) then
		rb_all_voyages.TriggerEvent(Clicked!)
	else
		rb_this_year.TriggerEvent(Clicked!)
	end if
ELSE
	sle_year.TriggerEvent(Modified!)
END IF
end event

event doubleclicked;if row > 0 then
	wf_gotodisbursement()
end if
end event

type uo_agent from uo_fin_agent within w_fin_agent_payments
integer x = 1298
integer y = 40
integer height = 768
integer taborder = 30
end type

on uo_agent.destroy
call uo_fin_agent::destroy
end on

type uo_agent_sno from uo_fin_agent_sno within w_fin_agent_payments
boolean visible = false
integer x = 1298
integer y = 32
integer taborder = 40
end type

on uo_agent_sno.destroy
call uo_fin_agent_sno::destroy
end on

type gb_3 from groupbox within w_fin_agent_payments
integer x = 55
integer y = 408
integer width = 1147
integer height = 344
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show Voyages"
end type

type gb_4 from groupbox within w_fin_agent_payments
integer x = 3886
integer y = 32
integer width = 631
integer height = 252
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agent Payments by"
end type

type gb_profit_center_search from groupbox within w_fin_agent_payments
boolean visible = false
integer x = 50
integer y = 16
integer width = 1147
integer height = 344
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search on:"
end type

