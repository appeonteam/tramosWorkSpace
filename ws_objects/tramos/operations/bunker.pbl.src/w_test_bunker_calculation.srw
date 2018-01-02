$PBExportHeader$w_test_bunker_calculation.srw
forward
global type w_test_bunker_calculation from window
end type
type cb_13 from commandbutton within w_test_bunker_calculation
end type
type cb_12 from commandbutton within w_test_bunker_calculation
end type
type cb_11 from commandbutton within w_test_bunker_calculation
end type
type cb_10 from commandbutton within w_test_bunker_calculation
end type
type cb_9 from commandbutton within w_test_bunker_calculation
end type
type dw_4 from datawindow within w_test_bunker_calculation
end type
type hpb_1 from hprogressbar within w_test_bunker_calculation
end type
type st_6 from statictext within w_test_bunker_calculation
end type
type cb_8 from commandbutton within w_test_bunker_calculation
end type
type sle_departure from singlelineedit within w_test_bunker_calculation
end type
type sle_arrival from singlelineedit within w_test_bunker_calculation
end type
type cb_7 from commandbutton within w_test_bunker_calculation
end type
type cb_6 from commandbutton within w_test_bunker_calculation
end type
type st_5 from statictext within w_test_bunker_calculation
end type
type sle_port from singlelineedit within w_test_bunker_calculation
end type
type sle_pcn from singlelineedit within w_test_bunker_calculation
end type
type st_4 from statictext within w_test_bunker_calculation
end type
type cb_5 from commandbutton within w_test_bunker_calculation
end type
type cb_4 from commandbutton within w_test_bunker_calculation
end type
type sle_bunkerprice from singlelineedit within w_test_bunker_calculation
end type
type dw_3 from datawindow within w_test_bunker_calculation
end type
type sle_offton from singlelineedit within w_test_bunker_calculation
end type
type sle_offprice from singlelineedit within w_test_bunker_calculation
end type
type sle_bunkerton from singlelineedit within w_test_bunker_calculation
end type
type st_3 from statictext within w_test_bunker_calculation
end type
type sle_voyage from singlelineedit within w_test_bunker_calculation
end type
type st_2 from statictext within w_test_bunker_calculation
end type
type sle_vessel from singlelineedit within w_test_bunker_calculation
end type
type sle_bunkertype from singlelineedit within w_test_bunker_calculation
end type
type st_1 from statictext within w_test_bunker_calculation
end type
type cb_3 from commandbutton within w_test_bunker_calculation
end type
type cb_2 from commandbutton within w_test_bunker_calculation
end type
type dw_2 from datawindow within w_test_bunker_calculation
end type
type dw_1 from datawindow within w_test_bunker_calculation
end type
type cb_1 from commandbutton within w_test_bunker_calculation
end type
type gb_1 from groupbox within w_test_bunker_calculation
end type
type ln_1 from line within w_test_bunker_calculation
end type
type ln_2 from line within w_test_bunker_calculation
end type
end forward

global type w_test_bunker_calculation from window
integer width = 3250
integer height = 2748
boolean titlebar = true
string title = "Test Bunker Calculation"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_13 cb_13
cb_12 cb_12
cb_11 cb_11
cb_10 cb_10
cb_9 cb_9
dw_4 dw_4
hpb_1 hpb_1
st_6 st_6
cb_8 cb_8
sle_departure sle_departure
sle_arrival sle_arrival
cb_7 cb_7
cb_6 cb_6
st_5 st_5
sle_port sle_port
sle_pcn sle_pcn
st_4 st_4
cb_5 cb_5
cb_4 cb_4
sle_bunkerprice sle_bunkerprice
dw_3 dw_3
sle_offton sle_offton
sle_offprice sle_offprice
sle_bunkerton sle_bunkerton
st_3 st_3
sle_voyage sle_voyage
st_2 st_2
sle_vessel sle_vessel
sle_bunkertype sle_bunkertype
st_1 st_1
cb_3 cb_3
cb_2 cb_2
dw_2 dw_2
dw_1 dw_1
cb_1 cb_1
gb_1 gb_1
ln_1 ln_1
ln_2 ln_2
end type
global w_test_bunker_calculation w_test_bunker_calculation

type variables
n_voyage_offservice_bunker_consumption	inv_offservice
n_voyage_bunker_consumption	inv_bunker

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		29/07/15		CR3226		XSZ004		Change label for Bunkers type.			
   </HISTORY>
********************************************************************/
end subroutine

on w_test_bunker_calculation.create
this.cb_13=create cb_13
this.cb_12=create cb_12
this.cb_11=create cb_11
this.cb_10=create cb_10
this.cb_9=create cb_9
this.dw_4=create dw_4
this.hpb_1=create hpb_1
this.st_6=create st_6
this.cb_8=create cb_8
this.sle_departure=create sle_departure
this.sle_arrival=create sle_arrival
this.cb_7=create cb_7
this.cb_6=create cb_6
this.st_5=create st_5
this.sle_port=create sle_port
this.sle_pcn=create sle_pcn
this.st_4=create st_4
this.cb_5=create cb_5
this.cb_4=create cb_4
this.sle_bunkerprice=create sle_bunkerprice
this.dw_3=create dw_3
this.sle_offton=create sle_offton
this.sle_offprice=create sle_offprice
this.sle_bunkerton=create sle_bunkerton
this.st_3=create st_3
this.sle_voyage=create sle_voyage
this.st_2=create st_2
this.sle_vessel=create sle_vessel
this.sle_bunkertype=create sle_bunkertype
this.st_1=create st_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.dw_2=create dw_2
this.dw_1=create dw_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.cb_13,&
this.cb_12,&
this.cb_11,&
this.cb_10,&
this.cb_9,&
this.dw_4,&
this.hpb_1,&
this.st_6,&
this.cb_8,&
this.sle_departure,&
this.sle_arrival,&
this.cb_7,&
this.cb_6,&
this.st_5,&
this.sle_port,&
this.sle_pcn,&
this.st_4,&
this.cb_5,&
this.cb_4,&
this.sle_bunkerprice,&
this.dw_3,&
this.sle_offton,&
this.sle_offprice,&
this.sle_bunkerton,&
this.st_3,&
this.sle_voyage,&
this.st_2,&
this.sle_vessel,&
this.sle_bunkertype,&
this.st_1,&
this.cb_3,&
this.cb_2,&
this.dw_2,&
this.dw_1,&
this.cb_1,&
this.gb_1,&
this.ln_1,&
this.ln_2}
end on

on w_test_bunker_calculation.destroy
destroy(this.cb_13)
destroy(this.cb_12)
destroy(this.cb_11)
destroy(this.cb_10)
destroy(this.cb_9)
destroy(this.dw_4)
destroy(this.hpb_1)
destroy(this.st_6)
destroy(this.cb_8)
destroy(this.sle_departure)
destroy(this.sle_arrival)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.st_5)
destroy(this.sle_port)
destroy(this.sle_pcn)
destroy(this.st_4)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.sle_bunkerprice)
destroy(this.dw_3)
destroy(this.sle_offton)
destroy(this.sle_offprice)
destroy(this.sle_bunkerton)
destroy(this.st_3)
destroy(this.sle_voyage)
destroy(this.st_2)
destroy(this.sle_vessel)
destroy(this.sle_bunkertype)
destroy(this.st_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.ln_1)
destroy(this.ln_2)
end on

type cb_13 from commandbutton within w_test_bunker_calculation
integer x = 2761
integer y = 2528
integer width = 343
integer height = 100
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "SaveAs..."
end type

event clicked;dw_4.saveas( )
end event

type cb_12 from commandbutton within w_test_bunker_calculation
integer x = 2761
integer y = 2420
integer width = 343
integer height = 100
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;dw_4.print()
end event

type cb_11 from commandbutton within w_test_bunker_calculation
integer x = 2359
integer y = 2528
integer width = 343
integer height = 100
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear Filter"
end type

event clicked;dw_4.setFilter("")
dw_4.filter()
end event

type cb_10 from commandbutton within w_test_bunker_calculation
integer x = 2359
integer y = 2420
integer width = 343
integer height = 100
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Filter"
end type

event clicked;dw_4.setFilter("compare1 > 0 or compare2 > 0")
dw_4.filter()
end event

type cb_9 from commandbutton within w_test_bunker_calculation
integer x = 1792
integer y = 2420
integer width = 530
integer height = 100
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve Compare DW"
end type

event clicked;dw_4.setTransObject(sqlca)
dw_4.retrieve()
end event

type dw_4 from datawindow within w_test_bunker_calculation
integer x = 78
integer y = 1908
integer width = 1509
integer height = 724
integer taborder = 130
string title = "none"
string dataobject = "d_sq_test_temp_offservice_bunker_compare"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type hpb_1 from hprogressbar within w_test_bunker_calculation
integer x = 1861
integer y = 2220
integer width = 1271
integer height = 68
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type st_6 from statictext within w_test_bunker_calculation
integer x = 1842
integer y = 1924
integer width = 1285
integer height = 272
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculates the offserviceton and value for all voyages in 2006, 2007, 2008 and 2009. Stores the values in the table DONT_DELME_TMP_OFFS_BUNKER. The rows with INITIAL_CALC set to 1 are the ones to compare with."
boolean focusrectangle = false
end type

type cb_8 from commandbutton within w_test_bunker_calculation
integer x = 2112
integer y = 2308
integer width = 731
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Calculate Off Service"
end type

event clicked;decimal {4}	ld_price, ld_ton
n_ds	lds_voyages, lds_temptable
long			ll_row, ll_temprow, ll_#ofVoyages

lds_voyages = create n_ds
lds_voyages.dataobject = "d_sq_test_temp_offservice_voyages"
lds_voyages.setTransObject(sqlca)

lds_temptable = create n_ds
lds_temptable.dataobject = "d_sq_test_temp_offservice_bunker"
lds_temptable.setTransObject(sqlca)

this.enabled = false

// Delete any old calculations except the initial ones
DELETE FROM DONT_DELME_TMP_OFFS_BUNKER  
	WHERE DONT_DELME_TMP_OFFS_BUNKER.INITIAL_CALC = 0   ;
if sqlca.sqlcode = 0 then
	commit;
else
	rollback;
	messagebox("Delete Error", "Error deleting old calculations from temporary offSrevice Bunker Table")
end if
	

ll_#ofVoyages = lds_voyages.retrieve()
hpb_1.maxposition = ll_#ofVoyages

if isValid(inv_offservice) then destroy inv_offservice
inv_offservice = create n_voyage_offservice_bunker_consumption

for ll_row = 1 to ll_#ofVoyages
	hpb_1.position = ll_row
	ll_temprow = lds_temptable.insertRow(0)
	lds_temptable.setItem(ll_temprow, "vessel_nr", lds_voyages.getItemNumber(ll_row, "vessel_nr"))
	lds_temptable.setItem(ll_temprow, "voyage_nr", lds_voyages.getItemString(ll_row, "voyage_nr"))
	lds_temptable.setItem(ll_temprow, "calc_date", datetime(today(), now()))
//	lds_temptable.setItem(ll_temprow, "initial_calc", 1)  // REMOVE THIS AFTER FIRST RUN
	// HFO
	inv_offservice.of_calculate( "HFO" , lds_voyages.getItemNumber(ll_row, "vessel_nr") , &
										lds_voyages.getItemString(ll_row, "voyage_nr"), ld_price, ld_ton )
	lds_temptable.setItem(ll_temprow, "hfo_ton", ld_ton)
	lds_temptable.setItem(ll_temprow, "hfo_value", ld_price)
	// DO
	inv_offservice.of_calculate( "DO" , lds_voyages.getItemNumber(ll_row, "vessel_nr") , &
										lds_voyages.getItemString(ll_row, "voyage_nr"), ld_price, ld_ton )
	lds_temptable.setItem(ll_temprow, "do_ton", ld_ton)
	lds_temptable.setItem(ll_temprow, "do_value", ld_price)
	// GO
	inv_offservice.of_calculate( "GO" , lds_voyages.getItemNumber(ll_row, "vessel_nr") , &
										lds_voyages.getItemString(ll_row, "voyage_nr"), ld_price, ld_ton )
	lds_temptable.setItem(ll_temprow, "go_ton", ld_ton)
	lds_temptable.setItem(ll_temprow, "go_value", ld_price)
	// LSHFO
	inv_offservice.of_calculate( "LSHFO" , lds_voyages.getItemNumber(ll_row, "vessel_nr") , &
										lds_voyages.getItemString(ll_row, "voyage_nr"), ld_price, ld_ton )
	lds_temptable.setItem(ll_temprow, "lshfo_ton", ld_ton)
	lds_temptable.setItem(ll_temprow, "lshfo_value", ld_price)
	
next	

if lds_temptable.update() = 1 then
	commit;
else
	rollback;
	messagebox("Update Error", "Error updating temporary offSrevice Bunker Table")
end if

this.enabled = true
destroy inv_offservice
end event

type sle_departure from singlelineedit within w_test_bunker_calculation
integer x = 923
integer y = 1720
integer width = 544
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_arrival from singlelineedit within w_test_bunker_calculation
integer x = 923
integer y = 1564
integer width = 544
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_7 from commandbutton within w_test_bunker_calculation
integer x = 114
integer y = 1724
integer width = 576
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Departure Bunker Value"
end type

event clicked;n_port_departure_bunker_value 	lnv_bunker
decimal {2} ld_value

lnv_bunker = create n_port_departure_bunker_value

lnv_bunker.of_calculate( sle_bunkertype.text , integer(sle_vessel.text) , sle_voyage.text , sle_port.text  , integer(sle_pcn.text), ld_value )

destroy lnv_bunker

sle_departure.text = string(ld_value)

commit;
end event

type cb_6 from commandbutton within w_test_bunker_calculation
integer x = 110
integer y = 1572
integer width = 503
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Arrival Bunker Value"
end type

event clicked;n_port_arrival_bunker_value 	lnv_bunker
decimal {2} ld_value

lnv_bunker = create n_port_arrival_bunker_value

lnv_bunker.of_calculate( sle_bunkertype.text , integer(sle_vessel.text) , sle_voyage.text , sle_port.text  , integer(sle_pcn.text), ld_value )

destroy lnv_bunker

sle_arrival.text = string(ld_value)

commit;
end event

type st_5 from statictext within w_test_bunker_calculation
integer x = 699
integer y = 48
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port:"
boolean focusrectangle = false
end type

type sle_port from singlelineedit within w_test_bunker_calculation
integer x = 946
integer y = 36
integer width = 343
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_pcn from singlelineedit within w_test_bunker_calculation
integer x = 946
integer y = 140
integer width = 343
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_test_bunker_calculation
integer x = 699
integer y = 156
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "PCN:"
boolean focusrectangle = false
end type

type cb_5 from commandbutton within w_test_bunker_calculation
integer x = 119
integer y = 1296
integer width = 581
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Consumption"
end type

event clicked;decimal {4}  ld_price, ld_ton

this.enabled = false
if isValid(inv_bunker) then destroy inv_bunker
inv_bunker = create n_voyage_bunker_consumption


inv_bunker.of_calculate( sle_bunkertype.text , integer(sle_vessel.text) , sle_voyage.text, ld_price, ld_ton )
sle_bunkerprice.text = string(ld_price)
sle_bunkerton.text = string(ld_ton)

inv_bunker.ids_bunker_lifted.sharedata(dw_3 )

this.enabled = true

commit;





end event

type cb_4 from commandbutton within w_test_bunker_calculation
integer x = 119
integer y = 1396
integer width = 343
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Destroy"
end type

type sle_bunkerprice from singlelineedit within w_test_bunker_calculation
integer x = 827
integer y = 1288
integer width = 343
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_test_bunker_calculation
integer x = 2085
integer y = 1116
integer width = 1006
integer height = 632
string title = "none"
string dataobject = "d_sq_tb_lifted_hfo"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_offton from singlelineedit within w_test_bunker_calculation
integer x = 2574
integer y = 176
integer width = 343
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_offprice from singlelineedit within w_test_bunker_calculation
integer x = 2574
integer y = 60
integer width = 343
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_bunkerton from singlelineedit within w_test_bunker_calculation
integer x = 827
integer y = 1152
integer width = 343
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_test_bunker_calculation
integer x = 59
integer y = 248
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage:"
boolean focusrectangle = false
end type

type sle_voyage from singlelineedit within w_test_bunker_calculation
integer x = 306
integer y = 240
integer width = 343
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "0953"
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_test_bunker_calculation
integer x = 59
integer y = 148
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel:"
boolean focusrectangle = false
end type

type sle_vessel from singlelineedit within w_test_bunker_calculation
integer x = 306
integer y = 136
integer width = 343
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "1008"
borderstyle borderstyle = stylelowered!
end type

type sle_bunkertype from singlelineedit within w_test_bunker_calculation
integer x = 306
integer y = 32
integer width = 343
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "HSFO"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_test_bunker_calculation
integer x = 59
integer y = 48
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Type:"
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_test_bunker_calculation
integer x = 119
integer y = 1152
integer width = 498
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Bunker Consumption"
end type

event clicked;n_voyage_bunker_consumption lnv_bunker
decimal {4}	ld_ton

lnv_bunker = create n_voyage_bunker_consumption 

lnv_bunker.of_getconsumptionton(sle_bunkertype.text , integer(sle_vessel.text) , sle_voyage.text, ld_ton )

sle_bunkerton.text = string(ld_ton)

destroy lnv_bunker 

commit;
end event

type cb_2 from commandbutton within w_test_bunker_calculation
integer x = 1865
integer y = 164
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Destroy"
end type

event clicked;destroy inv_offservice

end event

type dw_2 from datawindow within w_test_bunker_calculation
integer x = 2094
integer y = 356
integer width = 1006
integer height = 648
string title = "none"
string dataobject = "d_sq_tb_lifted_hfo"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_test_bunker_calculation
integer x = 137
integer y = 360
integer width = 1888
integer height = 652
string title = "none"
string dataobject = "d_sq_tb_offservice_used_hfo"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_test_bunker_calculation
integer x = 1865
integer y = 64
integer width = 581
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Offservice Consumption"
end type

event clicked;decimal {4}  ld_price, ld_ton

this.enabled = false
if isValid(inv_offservice) then destroy inv_offservice
inv_offservice = create n_voyage_offservice_bunker_consumption

inv_offservice.of_calculate( sle_bunkertype.text , integer(sle_vessel.text) , sle_voyage.text, ld_price, ld_ton )
sle_offprice.text = string(ld_price)
sle_offton.text = string(ld_ton)

inv_offservice.ids_bunker_used.sharedata(dw_1)
inv_offservice.ids_bunker_lifted.sharedata(dw_2)

this.enabled = true

commit;





end event

type gb_1 from groupbox within w_test_bunker_calculation
integer x = 1774
integer y = 1864
integer width = 1399
integer height = 780
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type ln_1 from line within w_test_bunker_calculation
integer linethickness = 4
integer beginx = 64
integer beginy = 1080
integer endx = 3072
integer endy = 1080
end type

type ln_2 from line within w_test_bunker_calculation
integer linethickness = 4
integer beginx = 64
integer beginy = 1540
integer endx = 1979
integer endy = 1540
end type

