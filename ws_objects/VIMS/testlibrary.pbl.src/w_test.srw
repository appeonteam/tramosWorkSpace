$PBExportHeader$w_test.srw
forward
global type w_test from window
end type
type cb_4 from commandbutton within w_test
end type
type cb_2 from commandbutton within w_test
end type
type cb_1 from commandbutton within w_test
end type
type dw_mire from datawindow within w_test
end type
type dw_sire from datawindow within w_test
end type
end forward

global type w_test from window
integer width = 4800
integer height = 2860
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_4 cb_4
cb_2 cb_2
cb_1 cb_1
dw_mire dw_mire
dw_sire dw_sire
end type
global w_test w_test

type prototypes
Private Function Long GetDC(Long hWnd) Library "user32.dll"

end prototypes

type variables

nvo_img in_image

Long il_DC, il_XPos
end variables

on w_test.create
this.cb_4=create cb_4
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_mire=create dw_mire
this.dw_sire=create dw_sire
this.Control[]={this.cb_4,&
this.cb_2,&
this.cb_1,&
this.dw_mire,&
this.dw_sire}
end on

on w_test.destroy
destroy(this.cb_4)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_mire)
destroy(this.dw_sire)
end on

event resize;

//ole_pic.width = newwidth - ole_pic.x * 2
//ole_pic.height = newheight - ole_pic.x * 2
end event

event open;String ls_SQL
Long ll_ImageHnd

SQLCA.DBMS = "SYC Adaptive Server Enterprise"
//SQLCA.Database = "LAPTOPTRAMOS"
//SQLCA.Servername = "THIS_LAPTOP"
//SQLCA.Database = "TEST_TRAMOS"
//SQLCA.Servername = "SCRBTRADKESP003"
SQLCA.Database = "TG_TRAMOS_PRIMARY_CPH"
SQLCA.Servername = "SCRBTRADKESP001"
SQLCA.Logid = "CONASW"
SQLCA.logpass	= "April2009"
SQLCA.AutoCommit = false

Connect using SQLCA;
If SQLCA.SQLCode<>0 then MessageBox("Connect Error", sqlca.SQLErrtext)
//
//
dw_sire.SetTransObject(SQLCA)
dw_mire.SetTransobject(SQLCA)

//Integer li_Year, li_PrevYear, li_Day, li_Week
//Date ad_Date
//
//ad_Date = Today()
//
//// Get day of week and convert to ISO standard (Monday = 1)
//li_Day = DayNumber(ad_Date) - 1
//If li_Day = 0 then li_Day = 7
//
//// Get to the closest Thursday
//Do While li_Day <> 4 
//	If li_Day < 4 then   // Mon, Tue, Wed
//		 ad_Date = RelativeDate(ad_Date, 1)
//		 li_Day ++
//	Else		 // Fri, Sat, Sun
//		 ad_Date = RelativeDate(ad_Date, -1)
//		 li_Day --
//	End If
//Loop
//
//li_Year = Year(ad_Date)
//
//// Count weeks backwards until the previous year
//Do
//	li_week ++
//  ad_Date = RelativeDate(ad_Date, -7)
//  li_PrevYear = Year(ad_date)
//Loop Until li_Year > li_PrevYear
//
//Messagebox("Week", f_GetWeekNumber(Today()))



end event

event close;
//in_image.ReleaseDC(Handle(st_1), il_DC)

//destroy in_image
Disconnect using SQLCA;

end event

type cb_4 from commandbutton within w_test
integer x = 4315
integer y = 2240
integer width = 402
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
end type

event clicked;
dw_mire.update()

commit;


end event

type cb_2 from commandbutton within w_test
integer x = 37
integer y = 2240
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;
dw_sire.Retrieve(65)
end event

type cb_1 from commandbutton within w_test
integer x = 2414
integer y = 2240
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;
dw_mire.Retrieve(66)
end event

type dw_mire from datawindow within w_test
integer x = 2414
integer y = 80
integer width = 2304
integer height = 2160
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_mireupdate"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sire from datawindow within w_test
integer x = 37
integer y = 80
integer width = 2304
integer height = 2160
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_mireupdate"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

