HA$PBExportHeader$w_voyconvert.srw
forward
global type w_voyconvert from window
end type
type st_msg from statictext within w_voyconvert
end type
type cb_convert from commandbutton within w_voyconvert
end type
type cb_get from commandbutton within w_voyconvert
end type
type dw_voy from datawindow within w_voyconvert
end type
end forward

global type w_voyconvert from window
integer width = 2048
integer height = 2600
boolean titlebar = true
string title = "Voyage Number Converter"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_msg st_msg
cb_convert cb_convert
cb_get cb_get
dw_voy dw_voy
end type
global w_voyconvert w_voyconvert

forward prototypes
public subroutine wf_enable (boolean ab_enable)
end prototypes

public subroutine wf_enable (boolean ab_enable);
cb_Get.Enabled = ab_Enable
cb_Convert.Enabled = ab_Enable

end subroutine

on w_voyconvert.create
this.st_msg=create st_msg
this.cb_convert=create cb_convert
this.cb_get=create cb_get
this.dw_voy=create dw_voy
this.Control[]={this.st_msg,&
this.cb_convert,&
this.cb_get,&
this.dw_voy}
end on

on w_voyconvert.destroy
destroy(this.st_msg)
destroy(this.cb_convert)
destroy(this.cb_get)
destroy(this.dw_voy)
end on

event open;
dw_voy.SetTransObject(SQLCA)
end event

type st_msg from statictext within w_voyconvert
integer x = 1298
integer y = 2432
integer width = 713
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_convert from commandbutton within w_voyconvert
integer x = 421
integer y = 2400
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Convert"
end type

event clicked;
Long ll_Count, ll_VoyID
String ls_NewVoyNum

If Messagebox("Confirm Convert", "The conversion process may take a long time. Are you sure you want to start?", Question!, YesNo!)= 2 then Return

SetPointer(HourGlass!)

wf_Enable(False)

For ll_Count = 1 to dw_Voy.Rowcount( )
	If dw_voy.GetItemString(ll_Count, "Ver") <> "New" then
		ls_NewVoyNum = dw_Voy.GetItemString(ll_Count, "Final")
		ll_VoyID = dw_Voy.GetItemNumber(ll_Count, "Voy_ID")
		
		Update TPERF_VOY Set VOY_NUM=:ls_NewVoyNum Where VOY_ID = :ll_VoyID;
		
		If SQLCA.SQLCode = 0  then
			Commit;
		Else
			Rollback;
		End If
	End If
	st_Msg.Text = string(ll_Count/dw_Voy.Rowcount( ) * 100, "0") + "% completed"
Next

dw_Voy.Retrieve()

end event

type cb_get from commandbutton within w_voyconvert
integer x = 18
integer y = 2400
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Retrieve"
end type

event clicked;
dw_Voy.Retrieve()
end event

type dw_voy from datawindow within w_voyconvert
integer x = 18
integer y = 16
integer width = 1993
integer height = 2384
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_voynum"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrievestart;
wf_Enable(False)
end event

event retrieveend;
wf_Enable(True)

st_Msg.Text = String(rowcount, "#,##0") + " rows retrieved"
end event

