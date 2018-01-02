$PBExportHeader$w_tc_final_balance.srw
forward
global type w_tc_final_balance from window
end type
type st_2 from statictext within w_tc_final_balance
end type
type cb_2 from commandbutton within w_tc_final_balance
end type
type st_1 from statictext within w_tc_final_balance
end type
type rb_3 from radiobutton within w_tc_final_balance
end type
type rb_2 from radiobutton within w_tc_final_balance
end type
type rb_1 from radiobutton within w_tc_final_balance
end type
type dw_1 from datawindow within w_tc_final_balance
end type
type cb_1 from commandbutton within w_tc_final_balance
end type
type gb_1 from groupbox within w_tc_final_balance
end type
end forward

global type w_tc_final_balance from window
integer width = 4571
integer height = 2580
boolean titlebar = true
string title = "Final Payment Balance"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_retrieve ( )
st_2 st_2
cb_2 cb_2
st_1 st_1
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
dw_1 dw_1
cb_1 cb_1
gb_1 gb_1
end type
global w_tc_final_balance w_tc_final_balance

forward prototypes
public subroutine documentation ()
end prototypes

event ue_retrieve();//
setPointer(Hourglass!)

dw_1.Retrieve( uo_global.is_userid )
dw_1.Modify("DataWindow.Print.Orientation = 1")

setPointer(Arrow!)

end event

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_tc_final_balance.create
this.st_2=create st_2
this.cb_2=create cb_2
this.st_1=create st_1
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_1=create dw_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.st_2,&
this.cb_2,&
this.st_1,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.dw_1,&
this.cb_1,&
this.gb_1}
end on

on w_tc_final_balance.destroy
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;dw_1.SetTransObject(SQLCA)
/* If user is some kind of external no access to TC-in contracts */
if uo_global.ii_access_level < 1 then
	dw_1.setFilter("ntc_tc_contract_tc_hire_in=0")
else
	dw_1.setFilter("")
end if
dw_1.filter()

this.postevent( "ue_retrieve" )

end event

type st_2 from statictext within w_tc_final_balance
integer x = 50
integer y = 160
integer width = 965
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Click on header to sort. Sort Column is blue."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_tc_final_balance
integer x = 3653
integer y = 68
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_1.print()

end event

type st_1 from statictext within w_tc_final_balance
integer x = 1134
integer y = 52
integer width = 2473
integer height = 148
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Shows balances <> 0 for final payment (Final Hire Statement) on TC Contracts where payment status are Final/Part-paid/Paid and all previous payments are paid. Balances with due dates older than 60 days are Red."
boolean border = true
boolean focusrectangle = false
end type

type rb_3 from radiobutton within w_tc_final_balance
integer x = 681
integer y = 60
integer width = 270
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC &Out"
end type

event clicked;dw_1.SetFilter("ntc_tc_contract_tc_hire_in = 0")
dw_1.FIlter()
end event

type rb_2 from radiobutton within w_tc_final_balance
integer x = 379
integer y = 60
integer width = 238
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC &In"
end type

event clicked;if uo_global.ii_access_level < 1 then
	// External users not allowed to se TC-IN contracts  2 is not existing
	dw_1.setFilter("ntc_tc_contract_tc_hire_in=2")
else
	dw_1.SetFilter("ntc_tc_contract_tc_hire_in = 1")
end if
dw_1.filter()

end event

type rb_1 from radiobutton within w_tc_final_balance
integer x = 96
integer y = 60
integer width = 219
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&All"
boolean checked = true
end type

event clicked;if uo_global.ii_access_level < 1 then
	// External users not allowed to se TC-IN contracts
	dw_1.setFilter("ntc_tc_contract_tc_hire_in=0")
else
	dw_1.SetFilter("")
end if
dw_1.filter()

end event

type dw_1 from datawindow within w_tc_final_balance
integer x = 5
integer y = 244
integer width = 4507
integer height = 2200
integer taborder = 20
string title = "none"
string dataobject = "d_tc_final_balance"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String ls_sort

IF dwo.Type = "text" THEN
	dw_1.object.vessels_vessel_name_t.color = RGB(0,0,0)
	dw_1.object.ntc_tc_contract_tc_hire_in_t.color = RGB(0,0,0)
	dw_1.object.owner_charter_t.color = RGB(0,0,0)
	dw_1.object.ntc_tc_contract_tc_hire_cp_date_t.color = RGB(0,0,0)
	dw_1.object.ntc_tc_contract_tc_hire_cp_text_t.color = RGB(0,0,0)
	dw_1.object.ntc_tc_contract_delivery_t.color = RGB(0,0,0)
	dw_1.object.redelivery_t.color = RGB(0,0,0)
	dw_1.object.ntc_payment_est_due_date_t.color = RGB(0,0,0)
	dw_1.object.payment_balance_t.color = RGB(0,0,0)
	
	dwo.Color = RGB(0,0,255)

	ls_sort = dwo.Tag

	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
END IF


end event

type cb_1 from commandbutton within w_tc_final_balance
integer x = 4110
integer y = 68
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type gb_1 from groupbox within w_tc_final_balance
integer x = 50
integer y = 8
integer width = 969
integer height = 140
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter"
end type

