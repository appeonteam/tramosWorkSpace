HA$PBExportHeader$w_vslcode.srw
forward
global type w_vslcode from window
end type
type cb_gen from commandbutton within w_vslcode
end type
type sle_name from singlelineedit within w_vslcode
end type
type sle_code from singlelineedit within w_vslcode
end type
type cb_copy from commandbutton within w_vslcode
end type
type st_4 from statictext within w_vslcode
end type
type st_vslnum from statictext within w_vslcode
end type
type st_3 from statictext within w_vslcode
end type
type st_2 from statictext within w_vslcode
end type
type st_1 from statictext within w_vslcode
end type
type cb_close from commandbutton within w_vslcode
end type
type rr_1 from roundrectangle within w_vslcode
end type
end forward

global type w_vslcode from window
integer width = 2313
integer height = 1320
boolean titlebar = true
string title = "Vessel ID Code"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_gen cb_gen
sle_name sle_name
sle_code sle_code
cb_copy cb_copy
st_4 st_4
st_vslnum st_vslnum
st_3 st_3
st_2 st_2
st_1 st_1
cb_close cb_close
rr_1 rr_1
end type
global w_vslcode w_vslcode

type variables
public long il_VesselID

end variables

forward prototypes
public function string wf_hex (integer ai_value)
public function string wf_createcode ()
end prototypes

public function string wf_hex (integer ai_value);String ls_Hex
Integer li_ASCII

Do
	li_ASCII= Mod(ai_Value, 16) + 48   // Get ASCII
	If li_ASCII > 57 then li_ASCII += 7  // Convert to Hex
	ls_Hex = CharA(li_ASCII) + ls_Hex  // Append
	ai_Value = Int(ai_Value / 16)  // Truncate to next digit
Loop Until ai_Value = 0

Return ls_Hex
end function

public function string wf_createcode ();
Byte lb_ByteStr[]
String ls_StrID, ls_tmp, ls_VslName, ls_VslNum, ls_VslID
Integer li_lxp, li_Counter
Long ll_Checksum, ll_VesselID

ls_VslName = Trim(sle_name.Text)
ls_VslNum = st_vslnum.Text
ll_VesselID = g_parameters.Vesselid
sle_code.Text = ""

lb_ByteStr[1] = Len(ls_VslName)
li_Counter = 2
For li_lxp = 1 to Len(ls_VslName)
  lb_ByteStr[li_Counter] = AscA(Mid(ls_VslName, li_lxp, 1))
  li_Counter ++
Next
lb_ByteStr[li_Counter] = Len(ls_VslNum)
li_Counter++
For li_lxp = 1 to Len(ls_VslNum)
  lb_ByteStr[li_Counter] = AscA(Mid(ls_VslNum, li_lxp, 1))
  li_Counter ++
Next
ls_VslID = CharA(Int(ll_VesselID / 676) + 65)
ll_VesselID = Mod(ll_VesselID, 676)
ls_VslID = ls_VslID + CharA(Int(ll_VesselID / 26) + 65) + CharA(Mod(ll_VesselID, 26) + 65)
For li_lxp = 1 to 3
	lb_ByteStr[li_Counter] = AscA(Mid(ls_VslID, li_lxp, 1))
	li_Counter ++
Next
ll_CheckSum = 0
For li_lxp = 1 to li_Counter - 1
	ll_CheckSum = ll_Checksum + lb_ByteStr[li_lxp]
Next
ll_CheckSum = mod(ll_CheckSum, 65536)
lb_ByteStr[li_Counter] = Int(ll_Checksum / 256)
li_Counter++
lb_ByteStr[li_Counter] = Mod(ll_Checksum, 256)
For li_lxp = 1 to li_Counter
	lb_ByteStr[li_lxp] = 255 - lb_ByteStr[li_lxp]
Next
ls_VslID = ""
For li_lxp = 1 to li_Counter
	ls_tmp = wf_Hex(lb_ByteStr[li_lxp])
	if Len(ls_tmp)=1 then ls_tmp = "0" + ls_tmp
	ls_VslID = ls_VslID + ls_tmp
Next
ls_StrID = ""
li_Counter *= 2
For li_lxp = 1 to li_Counter
	ls_tmp = Mid(ls_VslID, li_lxp, 1)
	Choose Case ls_tmp
		Case "A" to "F"
			ls_StrID = ls_StrID + CharA(155 - AscA(ls_tmp))
		Case "0" to "9"
			ls_StrID = ls_StrID + CharA(17 + AscA(ls_tmp))
	End Choose
Next

sle_code.Enabled = True
cb_copy.Enabled = True

Return ls_StrID


end function

on w_vslcode.create
this.cb_gen=create cb_gen
this.sle_name=create sle_name
this.sle_code=create sle_code
this.cb_copy=create cb_copy
this.st_4=create st_4
this.st_vslnum=create st_vslnum
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_close=create cb_close
this.rr_1=create rr_1
this.Control[]={this.cb_gen,&
this.sle_name,&
this.sle_code,&
this.cb_copy,&
this.st_4,&
this.st_vslnum,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_close,&
this.rr_1}
end on

on w_vslcode.destroy
destroy(this.cb_gen)
destroy(this.sle_name)
destroy(this.sle_code)
destroy(this.cb_copy)
destroy(this.st_4)
destroy(this.st_vslnum)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.rr_1)
end on

event open;
String ls_vslname, ls_vslnum

SELECT VESSEL_NAME, VESSEL_REF_NR INTO :ls_VslName, :ls_VslNum FROM VESSELS WHERE VESSEL_ID=:g_parameters.vesselid;

If SQLCA.SQLCode <> 0 then
	MessageBox ("Database Error", "Could not retrieve vessel name/number.~n~n" + sqlca.sqlerrtext, Exclamation!)
	st_vslnum.text = "< DB Error >"
	sle_name.text = "< DB Error >"
	sle_name.Enabled = False
	sle_code.Enabled = False
	cb_gen.Enabled = False
	cb_copy.Enabled = False 
else
	sle_name.text = ls_VslName
	st_vslnum.text = ls_VslNum	
End If

Commit;

end event

type cb_gen from commandbutton within w_vslcode
integer x = 750
integer y = 608
integer width = 841
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate Vessel ID Code"
end type

event clicked;
sle_code.Text = ""
sle_code.Enabled = False
cb_copy.Enabled = False

if Len(Trim(sle_name.Text)) < 2 then 
	MessageBox("Vessel Name", "Please enter a valid name for the vessel.",Exclamation!)
	Return
End If

sle_code.text = wf_createcode( )
end event

type sle_name from singlelineedit within w_vslcode
integer x = 585
integer y = 416
integer width = 1627
integer height = 80
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

event modified;
sle_code.text = ""

end event

type sle_code from singlelineedit within w_vslcode
integer x = 73
integer y = 976
integer width = 2158
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_copy from commandbutton within w_vslcode
integer x = 1701
integer y = 880
integer width = 530
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Copy to Clipboard"
end type

event clicked;
clipboard(sle_code.text)

MessageBox("Vessel ID Code", "Vessel Identification Code copied to clipboard. Please paste the code in an email to the vessel.")
end event

type st_4 from statictext within w_vslcode
integer x = 73
integer y = 896
integer width = 718
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Identification Code:"
boolean focusrectangle = false
end type

type st_vslnum from statictext within w_vslcode
integer x = 585
integer y = 336
integer width = 421
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "< DB Error >"
boolean focusrectangle = false
end type

type st_3 from statictext within w_vslcode
integer x = 73
integer y = 336
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Number:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_vslcode
integer x = 73
integer y = 432
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Name:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_vslcode
integer x = 55
integer y = 48
integer width = 2194
integer height = 224
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "The following code must be sent to the vessel when installing the T-Perf system on the vessel OR when the name/number of the vessel has changed. Please specify the correct vessel name (without prefixes and suffixes) before generating the code."
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_vslcode
integer x = 878
integer y = 1120
integer width = 585
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
boolean cancel = true
boolean default = true
end type

event clicked;
close(parent)

end event

type rr_1 from roundrectangle within w_vslcode
long linecolor = 33538240
integer linethickness = 4
long fillcolor = 67108864
integer x = 18
integer y = 16
integer width = 2267
integer height = 1088
integer cornerheight = 40
integer cornerwidth = 46
end type

