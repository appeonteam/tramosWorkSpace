$PBExportHeader$uo_fin_agent_sno.sru
forward
global type uo_fin_agent_sno from userobject
end type
type dw_1 from datawindow within uo_fin_agent_sno
end type
type sle_find from singlelineedit within uo_fin_agent_sno
end type
type st_1 from statictext within uo_fin_agent_sno
end type
end forward

global type uo_fin_agent_sno from userobject
integer width = 2021
integer height = 736
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
sle_find sle_find
st_1 st_1
end type
global uo_fin_agent_sno uo_fin_agent_sno

event constructor;dw_1.settransobject(SQLCA)
dw_1.setrowfocusindicator(FocusRect!)
end event

on uo_fin_agent_sno.create
this.dw_1=create dw_1
this.sle_find=create sle_find
this.st_1=create st_1
this.Control[]={this.dw_1,&
this.sle_find,&
this.st_1}
end on

on uo_fin_agent_sno.destroy
destroy(this.dw_1)
destroy(this.sle_find)
destroy(this.st_1)
end on

type dw_1 from datawindow within uo_fin_agent_sno
integer x = 37
integer y = 172
integer width = 1943
integer height = 536
integer taborder = 20
string title = "none"
string dataobject = "d_fin_agent_sno"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;long ll_array[]

if row = 0 Then row = GetSelectedRow(0)

If (Row > 0) And (row <> GetSelectedRow(row - 1)) Then 
	SelectRow(0,false)
	SetRow(row)
	SelectRow(row,True)

	ll_array[1] = dw_1.getitemnumber(row, "agent_nr")
	IF isvalid(w_fin_agent_payments.dw_agent_payments) THEN
		w_fin_agent_payments.dw_agent_payments.retrieve(ll_array)
	END IF
End if

end event

event doubleclicked;if (row > 0) then
	openwithparm(w_agent, dw_1.getitemnumber(dw_1.getrow(), "agent_nr"))
end if
end event

type sle_find from singlelineedit within uo_fin_agent_sno
event ue_key pbm_keyup
integer x = 347
integer y = 32
integer width = 859
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_key;long ll_array[], ll_row, ll_rows

if (key = KeyEnter!) then
	dw_1.retrieve(sle_find.text)
	ll_rows = dw_1.rowcount()
	
	if ll_rows > 100 then
		Messagebox("Limit selection" , "Please limit your selection.")
		return
	end if
	
	if ll_rows > 0 then 
		FOR ll_row= 1 TO ll_rows
			ll_array[ll_row] = dw_1.getitemnumber(ll_row, "agent_nr")
		NEXT
		w_fin_agent_payments.dw_agent_payments.retrieve(ll_array)

	end if

end if
end event

type st_1 from statictext within uo_fin_agent_sno
integer x = 32
integer y = 56
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "S-number:"
boolean focusrectangle = false
end type

