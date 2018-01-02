$PBExportHeader$w_vmic.srw
forward
global type w_vmic from window
end type
type st_fullname from statictext within w_vmic
end type
type st_idnum from statictext within w_vmic
end type
type cb_close from commandbutton within w_vmic
end type
type st_3 from statictext within w_vmic
end type
type cb_copy from commandbutton within w_vmic
end type
type mle_vmic from multilineedit within w_vmic
end type
type st_name from statictext within w_vmic
end type
type st_id from statictext within w_vmic
end type
type st_1 from statictext within w_vmic
end type
type gb_1 from groupbox within w_vmic
end type
end forward

global type w_vmic from window
integer width = 2857
integer height = 1040
boolean titlebar = true
string title = "VMIC Generator"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_fullname st_fullname
st_idnum st_idnum
cb_close cb_close
st_3 st_3
cb_copy cb_copy
mle_vmic mle_vmic
st_name st_name
st_id st_id
st_1 st_1
gb_1 gb_1
end type
global w_vmic w_vmic

forward prototypes
private function string w_generatecode (integer ai_type, string as_id, string as_param1, string as_param2, string as_extra)
private function string w_hex (integer ai_value)
end prototypes

private function string w_generatecode (integer ai_type, string as_id, string as_param1, string as_param2, string as_extra);String ls_Code, ls_Hex
Integer li_Loop, li_Pos, li_Temp
Long ll_Checksum
Integer li_Array[]

// Header
li_Array[1] = AscA('V')
li_Array[2] = AscA('M')
li_Array[3] = AscA('I')
li_Array[4] = AscA('C')
li_Array[5] = ai_Type

// Size of ID
li_Temp = Len(as_id)
li_Array[6] = li_Temp
li_Pos = 6

// ID
For li_Loop = 1 to li_Temp
	li_Pos ++
	li_Array[li_Pos] = AscA(Mid(as_id, li_Loop, 1))
Next

// Size of vessel's name or inspector's first name
li_Pos ++
li_Temp = Len(as_param1)
li_Array[li_Pos] = li_Temp

// Vessel's name or inspector's first name
For li_Loop = 1 to li_Temp
	li_Pos ++
	li_Array[li_Pos] = AscA(Mid(as_param1, li_Loop, 1))
Next

// Size of inspector's last name or Vessel Number
li_Pos ++
li_Temp = Len(as_param2)
li_Array[li_Pos] = li_Temp

// Inspector's last name or vessel number
For li_Loop = 1 to li_Temp
	li_Pos ++
	li_Array[li_Pos] = AscA(Mid(as_param2, li_Loop, 1))
Next

// Size of extra info
li_Pos ++
li_Temp = Len(as_extra)
li_Array[li_Pos] = li_Temp

// Extra info
For li_Loop = 1 to li_Temp
	li_Pos ++
	li_Array[li_Pos] = AscA(Mid(as_extra, li_Loop, 1))
Next

// Calculate and append 2-byte checksum
ll_Checksum = 0
For li_Loop = 1 to li_Pos
	ll_Checksum += li_Array[li_Loop] * li_Loop
Next
ll_Checksum = mod(ll_Checksum, 65536)
li_Pos ++
li_Array[li_Pos] = Int(ll_Checksum/256)
li_Pos ++
li_Array[li_Pos] = Mod(ll_Checksum, 256)

// Invert bytes
For li_Loop = 1 to li_Pos
	li_Array[li_Loop] = 255 - li_Array[li_Loop]
Next

// Convert to Hex
ls_Code = ''
For li_Loop = 1 to li_Pos
	ls_Hex = w_Hex(li_Array[li_Loop])
	if len(ls_Hex) = 1 then ls_Hex = '0' + ls_Hex
	ls_Code += ls_Hex
Next

// Convert to alphabets
li_Pos = Len(ls_Code)
For li_Loop = 1 to li_Pos
	ls_Hex = Mid(ls_Code, li_Loop, 1)
	If ls_Hex < 'A' then ls_Code = Replace(ls_Code, li_Loop, 1, CharA(AscA(ls_Hex) + 33))
Next

Return ls_Code
end function

private function string w_hex (integer ai_value);String ls_Hex
Integer li_ASCII

Do
	li_ASCII= Mod(ai_Value, 16) + 48   // Get ASCII
	If li_ASCII > 57 then li_ASCII += 7  // Convert to Hex
	ls_Hex = CharA(li_ASCII) + ls_Hex  // Append
	ai_Value = Int(ai_Value / 16)  // Truncate to next digit
Loop Until ai_Value = 0

Return ls_Hex
end function

on w_vmic.create
this.st_fullname=create st_fullname
this.st_idnum=create st_idnum
this.cb_close=create cb_close
this.st_3=create st_3
this.cb_copy=create cb_copy
this.mle_vmic=create mle_vmic
this.st_name=create st_name
this.st_id=create st_id
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_fullname,&
this.st_idnum,&
this.cb_close,&
this.st_3,&
this.cb_copy,&
this.mle_vmic,&
this.st_name,&
this.st_id,&
this.st_1,&
this.gb_1}
end on

on w_vmic.destroy
destroy(this.st_fullname)
destroy(this.st_idnum)
destroy(this.cb_close)
destroy(this.st_3)
destroy(this.cb_copy)
destroy(this.mle_vmic)
destroy(this.st_name)
destroy(this.st_id)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
If g_obj.level = 0 then   // Vessel VMIC
	st_id.Text = "IMO Number:"
	st_name.Text = "Vessel No./Name:"
	st_idnum.Text = string(g_obj.vesselimo)
	st_fullname.Text = g_obj.sql + " / " + g_obj.objstring
	mle_vmic.Text = w_generatecode( 0, st_idnum.text, g_obj.objstring, g_obj.sql, '')
Else                      // Inspector VMIC
	st_id.Text = "User ID:"
	st_name.Text = "Inspector's Name:"
	st_idnum.Text = g_obj.objparent
	st_fullname.Text = g_obj.objstring + " " + g_obj.sql
	mle_vmic.Text = w_generatecode( 1, st_idnum.text, g_obj.objstring, g_obj.sql, '')
End if
end event

type st_fullname from statictext within w_vmic
integer x = 622
integer y = 176
integer width = 1719
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "xx"
boolean focusrectangle = false
end type

type st_idnum from statictext within w_vmic
integer x = 622
integer y = 80
integer width = 713
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "xx"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_vmic
integer x = 1152
integer y = 816
integer width = 567
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type st_3 from statictext within w_vmic
integer x = 91
integer y = 640
integer width = 2693
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
string text = "The VIMS Mobile Identification Code must be sent to the vessel / inspector where VIMS Mobile is being installed. The code only needs to be sent once for each installation. The code may be resent if a vessel changes its name."
boolean focusrectangle = false
end type

type cb_copy from commandbutton within w_vmic
integer x = 2523
integer y = 288
integer width = 238
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;
mle_vmic.SelectText(1, Len(mle_vmic.Text))

If mle_vmic.Copy( )  > 0 then Messagebox("VMIC Copied", "The code was copied to the clipboard.") Else MessageBox("Copy Fail", "The code was not copied.", Exclamation!)
end event

type mle_vmic from multilineedit within w_vmic
integer x = 73
integer y = 368
integer width = 2688
integer height = 256
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_name from statictext within w_vmic
integer x = 73
integer y = 176
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "xxx:"
boolean focusrectangle = false
end type

type st_id from statictext within w_vmic
integer x = 73
integer y = 80
integer width = 384
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "xxx:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_vmic
integer x = 73
integer y = 288
integer width = 864
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VIMS Mobile Identification Code:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_vmic
integer x = 18
integer width = 2798
integer height = 784
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

