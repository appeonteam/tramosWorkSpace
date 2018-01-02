$PBExportHeader$w_weballocation_pool_partner.srw
$PBExportComments$This window is used to update which vessels that have to be showed for a pool partner
forward
global type w_weballocation_pool_partner from mt_w_sheet
end type
type rb_swift from radiobutton within w_weballocation_pool_partner
end type
type rb_handy from radiobutton within w_weballocation_pool_partner
end type
type cb_close from commandbutton within w_weballocation_pool_partner
end type
type st_1 from statictext within w_weballocation_pool_partner
end type
type cb_update from commandbutton within w_weballocation_pool_partner
end type
type dw_poolpartner from datawindow within w_weballocation_pool_partner
end type
type gb_1 from groupbox within w_weballocation_pool_partner
end type
end forward

global type w_weballocation_pool_partner from mt_w_sheet
integer width = 2683
integer height = 2176
string title = "Update Web Pool Partner"
boolean maxbox = false
boolean resizable = false
boolean center = false
rb_swift rb_swift
rb_handy rb_handy
cb_close cb_close
st_1 st_1
cb_update cb_update
dw_poolpartner dw_poolpartner
gb_1 gb_1
end type
global w_weballocation_pool_partner w_weballocation_pool_partner

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14		CR3781	CCY018			modified ancestor and the window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_weballocation_pool_partner.create
int iCurrent
call super::create
this.rb_swift=create rb_swift
this.rb_handy=create rb_handy
this.cb_close=create cb_close
this.st_1=create st_1
this.cb_update=create cb_update
this.dw_poolpartner=create dw_poolpartner
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_swift
this.Control[iCurrent+2]=this.rb_handy
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.dw_poolpartner
this.Control[iCurrent+7]=this.gb_1
end on

on w_weballocation_pool_partner.destroy
call super::destroy
destroy(this.rb_swift)
destroy(this.rb_handy)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.cb_update)
destroy(this.dw_poolpartner)
destroy(this.gb_1)
end on

event open;call super::open;string	ls_sql

/* SQL hardcoded to Prodoction Database Handytankers = 4 and Swift Tankers = 5 */
ls_sql = "insert into WEB_POOL_PARTNER (POOL_VESSEL_NUMBER, POOL_PARTNER_NAME, POOL_ID) "+&
			"SELECT VESSEL_NR, 'Owner not entered!', POOL_ID FROM NTC_POOL_VESSELS WHERE POOL_ID IN (4, 5)  AND VESSEL_NR NOT IN (SELECT POOL_VESSEL_NUMBER FROM WEB_POOL_PARTNER)"

execute immediate :ls_sql;

dw_poolpartner.setTransObject(SQLCA)
dw_poolpartner.POST retrieve()


end event

event closequery;dw_poolpartner.acceptText()

if dw_poolpartner.modifiedCount() > 0 then
	if messageBox("", "Data modified but not saved. Are you sure you don't want to update", Question!,YesNo!,2) = 2 then
		return 1
	else
		return 0
	end if
end if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_weballocation_pool_partner
end type

type rb_swift from radiobutton within w_weballocation_pool_partner
integer x = 626
integer y = 68
integer width = 448
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Swift Tankers"
end type

event clicked;if dw_poolpartner.dataObject = "d_web_pool_partner_swift" then return

dw_poolpartner.acceptText()

if dw_poolpartner.modifiedCount() > 0 then
	if messageBox("", "Data modified but not saved. Are you sure you don't want to update", Question!,YesNo!,2) = 1 then
		//
	else
		rb_handy.checked = false
		rb_swift.checked = true
		return 
	end if
end if

dw_poolpartner.dataObject = "d_web_pool_partner_swift"
dw_poolpartner.setTransObject(sqlca)
dw_poolpartner.retrieve()

end event

type rb_handy from radiobutton within w_weballocation_pool_partner
integer x = 101
integer y = 68
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Handytankers"
boolean checked = true
end type

event clicked;if dw_poolpartner.dataObject = "d_web_pool_partner_handy" then return

dw_poolpartner.acceptText()

if dw_poolpartner.modifiedCount() > 0 then
	if messageBox("", "Data modified but not saved. Are you sure you don't want to update", Question!,YesNo!,2) = 1 then
		//
	else
		rb_handy.checked = false
		rb_swift.checked = true
		return 
	end if
end if

dw_poolpartner.dataObject = "d_web_pool_partner_handy"
dw_poolpartner.setTransObject(sqlca)
dw_poolpartner.retrieve()

end event

type cb_close from commandbutton within w_weballocation_pool_partner
integer x = 2071
integer y = 1956
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
boolean cancel = true
end type

event clicked;close(parent)
end event

type st_1 from statictext within w_weballocation_pool_partner
integer x = 2007
integer y = 236
integer width = 645
integer height = 500
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Update Owner name to be shown on Web-site"
boolean focusrectangle = false
end type

type cb_update from commandbutton within w_weballocation_pool_partner
integer x = 2071
integer y = 1816
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
boolean default = true
end type

event clicked;if dw_poolpartner.update() = 1 then
	commit;
else
	Rollback;
	MessageBox("Update Error", "Error updating rates")
end if
end event

type dw_poolpartner from datawindow within w_weballocation_pool_partner
integer x = 64
integer y = 192
integer width = 1883
integer height = 1868
integer taborder = 10
string title = "Web Pool Partner"
string dataobject = "d_web_pool_partner_handy"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_weballocation_pool_partner
integer x = 69
integer y = 8
integer width = 1065
integer height = 160
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Pool"
end type

