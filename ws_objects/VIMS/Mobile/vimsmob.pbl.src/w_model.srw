$PBExportHeader$w_model.srw
forward
global type w_model from window
end type
type cb_close from commandbutton within w_model
end type
type cb_viq from commandbutton within w_model
end type
type st_1 from statictext within w_model
end type
type dw_model from datawindow within w_model
end type
type gb_1 from groupbox within w_model
end type
end forward

global type w_model from window
integer width = 2231
integer height = 1772
boolean titlebar = true
string title = "Inspection Models"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Model.ico"
boolean center = true
event ue_printmodel ( integer ai_type )
cb_close cb_close
cb_viq cb_viq
st_1 st_1
dw_model dw_model
gb_1 gb_1
end type
global w_model w_model

type variables

Long il_InspID, il_SelHnd, il_objid, il_NewInspID

m_modelprint im_Print
end variables

event ue_printmodel(integer ai_type);
SetPointer(HourGlass!)

g_Obj.paramlong = dw_Model.GetItemNumber(dw_Model.GetRow(), "IM_ID")
g_Obj.Level = 200

// Check if officers are assigned in model questions and show selection dialog
If (ai_type < 3) and dw_Model.GetItemNumber(dw_Model.GetRow(), "MinExtNum") < 0 then
	Open(w_Select)
	If g_Obj.Level = 250 then Return
End If

OpenSheet(w_preview, w_main, 0, Original!)

Choose Case ai_type
	Case 1
		If g_Obj.Level = 200 then 
			w_preview.dw_rep.dataobject = "d_rep_modelviq"
		Else
			w_preview.dw_rep.dataobject = "d_rep_modelviq_officer"
			w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_model_officer"
		End If
	Case 2
		If g_Obj.Level = 200 then 
			w_preview.dw_rep.dataobject = "d_rep_modelviq"
			w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_model_noguide"
		Else
			w_preview.dw_rep.dataobject = "d_rep_modelviq_officer"
			w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_model_officer_noguide"			
		End If
	Case 3
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a4"
	Case 4
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a4"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_roviq_a4_noguide"
	Case 5
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a5"
	Case 6
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a5"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_roviq_a5_noguide"		
End Choose

w_preview.dw_rep.SetTransObject(SQLCA)
If g_Obj.Level = 200 then  // No officer selection
	If w_preview.dw_rep.dataobject = "d_rep_modelviq" then w_preview.dw_rep.Retrieve(g_Obj.ParamLong, 0) else w_preview.dw_rep.Retrieve(g_Obj.ParamLong)
Else	
	w_preview.dw_rep.Retrieve(g_Obj.ParamLong, g_Obj.Level)
End If

f_Write2Log("w_Model > ue_PrintModel: Type " + String(ai_Type))

w_preview.wf_ShowReport()
end event

on w_model.create
this.cb_close=create cb_close
this.cb_viq=create cb_viq
this.st_1=create st_1
this.dw_model=create dw_model
this.gb_1=create gb_1
this.Control[]={this.cb_close,&
this.cb_viq,&
this.st_1,&
this.dw_model,&
this.gb_1}
end on

on w_model.destroy
destroy(this.cb_close)
destroy(this.cb_viq)
destroy(this.st_1)
destroy(this.dw_model)
destroy(this.gb_1)
end on

event open;Integer li_Wid, li_Hgt
String ls_Temp

dw_model.settransobject( SQLCA )
If dw_model.Retrieve( ) = 0 then cb_viq.Enabled = False

f_Write2Log("w_Model Open")

im_Print = Create m_modelprint
end event

event close;String ls_Temp


Destroy im_print
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2500)
end event

type cb_close from commandbutton within w_model
integer x = 859
integer y = 1552
integer width = 475
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cb_viq from commandbutton within w_model
integer x = 37
integer y = 1376
integer width = 421
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "      Print      >"
end type

event clicked;
If dw_Model.GetItemNumber( dw_Model.GetRow(), "extmodel") = 1 then
	MessageBox("External Model", "The selected model is an external model.", Exclamation!)
	Return
End If

im_Print.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())


end event

type st_1 from statictext within w_model
integer x = 55
integer y = 64
integer width = 786
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Defined Inspection Models:"
boolean focusrectangle = false
end type

type dw_model from datawindow within w_model
integer x = 55
integer y = 144
integer width = 2103
integer height = 1232
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_inspmodel"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
// Force redraw
This.SetRedraw(False)
This.SetRedraw(True)



end event

type gb_1 from groupbox within w_model
integer x = 18
integer width = 2176
integer height = 1520
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

