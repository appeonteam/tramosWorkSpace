$PBExportHeader$w_vmic.srw
forward
global type w_vmic from window
end type
type st_name from statictext within w_vmic
end type
type st_id from statictext within w_vmic
end type
type st_install from statictext within w_vmic
end type
type cb_cancel from commandbutton within w_vmic
end type
type cb_ok from commandbutton within w_vmic
end type
type st_nametext from statictext within w_vmic
end type
type st_idtext from statictext within w_vmic
end type
type st_insttext from statictext within w_vmic
end type
type cb_vmic from commandbutton within w_vmic
end type
type st_1 from statictext within w_vmic
end type
type mle_vmic from multilineedit within w_vmic
end type
type st_dis from statictext within w_vmic
end type
type gb_1 from groupbox within w_vmic
end type
type cb_paste from commandbutton within w_vmic
end type
end forward

global type w_vmic from window
integer width = 2208
integer height = 1620
boolean titlebar = true
string title = "VIMS Mobile Identification Code (VMIC)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_name st_name
st_id st_id
st_install st_install
cb_cancel cb_cancel
cb_ok cb_ok
st_nametext st_nametext
st_idtext st_idtext
st_insttext st_insttext
cb_vmic cb_vmic
st_1 st_1
mle_vmic mle_vmic
st_dis st_dis
gb_1 gb_1
cb_paste cb_paste
end type
global w_vmic w_vmic

type variables

Byte ib_Install
Long il_IMO
String is_Vessel, is_UserID, is_FName, is_LName, is_VesselNum
end variables

forward prototypes
private function byte wf_hex2byte (string as_hex)
end prototypes

private function byte wf_hex2byte (string as_hex);// Function to convert hex values to byte

Byte lb_Val

If Len(as_hex) <> 2 then Return 0    // reject any hex value other than 2 chars

lb_Val = 0

If Left(as_Hex, 1) <= '9' then lb_Val = Byte(Left(as_Hex, 1)) Else lb_Val = Byte(AscA(Left(as_Hex, 1)) - 55)

lb_Val *= 16

If Right(as_Hex, 1) <= '9' then lb_Val += Byte(Right(as_Hex, 1)) Else lb_Val += Byte(AscA(Right(as_Hex, 1)) - 55)

Return lb_Val
end function

on w_vmic.create
this.st_name=create st_name
this.st_id=create st_id
this.st_install=create st_install
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_nametext=create st_nametext
this.st_idtext=create st_idtext
this.st_insttext=create st_insttext
this.cb_vmic=create cb_vmic
this.st_1=create st_1
this.mle_vmic=create mle_vmic
this.st_dis=create st_dis
this.gb_1=create gb_1
this.cb_paste=create cb_paste
this.Control[]={this.st_name,&
this.st_id,&
this.st_install,&
this.cb_cancel,&
this.cb_ok,&
this.st_nametext,&
this.st_idtext,&
this.st_insttext,&
this.cb_vmic,&
this.st_1,&
this.mle_vmic,&
this.st_dis,&
this.gb_1,&
this.cb_paste}
end on

on w_vmic.destroy
destroy(this.st_name)
destroy(this.st_id)
destroy(this.st_install)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_nametext)
destroy(this.st_idtext)
destroy(this.st_insttext)
destroy(this.cb_vmic)
destroy(this.st_1)
destroy(this.mle_vmic)
destroy(this.st_dis)
destroy(this.gb_1)
destroy(this.cb_paste)
end on

event open;
f_Write2Log("w_VMIC Open")

If g_Obj.paramstring > "" then  // VMIC to be changed
	st_dis.Text = "Please enter the new VIMS Mobile Identification Code received and click on the 'Check VMIC' button."
End If
end event

event closequery;

If ib_install = 255 then  // Cancel pressed
	If g_Obj.Install = 255 then
		If Messagebox("VMIC Required", "The VMIC has not been entered/accepted. The application cannot continue without the VMIC.~n~nDo you really want to cancel?", Question!, YesNo!) = 2 then Return 1
		f_Write2Log("w_VMIC Cancel")
	End if	
	If g_Obj.Paramstring = "" then g_Obj.Paramstring = "Exit"  // New VMIC not supplied/accepted
End If

end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 3800)
end event

type st_name from statictext within w_vmic
integer x = 823
integer y = 1248
integer width = 1335
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_id from statictext within w_vmic
integer x = 823
integer y = 1152
integer width = 695
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_install from statictext within w_vmic
integer x = 823
integer y = 1056
integer width = 402
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_vmic
integer x = 1317
integer y = 1392
integer width = 512
integer height = 112
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
ib_Install = 255

Close(Parent)
end event

type cb_ok from commandbutton within w_vmic
integer x = 402
integer y = 1392
integer width = 512
integer height = 112
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Accept"
end type

event clicked;String ls_Data

// Accept code and update database

// Check if changing install type
If (g_Obj.Install <> ib_Install) And (g_Obj.Install<10) then
	Messagebox("Installation Type", "The VIMS Mobile installation type cannot be changed without a complete reset of the database.", Exclamation!)
	Return
End If

// Check if IMO number has changed (very remote possibility) on a vessel
If (g_Obj.Install = 0) and (ib_Install = 0) then
	If il_IMO <> g_Obj.Vesselimo Then
		If Messagebox("IMO Number", "The IMO Number has changed. All inspections will be updated with the new number.~n~nDo you want to continue?", Question!, YesNo!) = 2 then Return
		Update VETT_INSP Set VESSELIMO = :il_IMO;
		If SQLCA.SQLCode < 0 then
			Messagebox("Update Error", "Inspections could not be updated with the new IMO number.", Exclamation!)
			Return
		End If
		Commit;
	End If
End If

ls_Data = String(ib_Install)
If f_Config("INST", ls_Data, 1) < 0 then
	Messagebox("DB Error", "Could not save settings - INST", StopSign!)
	Return 
End If

If ib_Install = 0 then
	g_Obj.VesselIMO = il_IMO
	ls_Data = String(il_imo)
	If f_Config("VIMO", ls_Data, 1) < 0 then
		Messagebox("DB Error", "Could not save all settings - VIMO", StopSign!)
		Return 
	End If
	If f_Config("VLNM", is_Vessel, 1) < 0 then
		Messagebox("DB Error", "Could not save all settings - VLNM", StopSign!)
		Return 
	End If
	If f_Config("VLNR", is_VesselNum, 1) < 0 then
		Messagebox("DB Error", "Could not save all settings - VLNR", StopSign!)
		Return 
	End If	
Else
	If f_Config("INID", is_UserID , 1) < 0 then
		Messagebox("DB Error", "Could not save all settings - INID", StopSign!)
		Return 
	End If		
	If f_Config("INFN", is_FName, 1) < 0 then
		Messagebox("DB Error", "Could not save all settings - INFN", StopSign!)
		Return 
	End If	
	If f_Config("INLN", is_LName, 1) < 0 then
		Messagebox("DB Error", "Could not save all settings - INLN", StopSign!)
		Return 
	End If		
End If

MessageBox("ID Accepted", "Identification Information Accepted")
If ib_Install = 0 then
	f_Write2Log("w_VMIC > cb_OK; Type: 0; Vessel: " + is_VesselNum + " - " + is_Vessel)
Else
	f_Write2Log("w_VMIC > cb_OK; Type: 1; User: " + is_UserID + " - " + is_FName + is_LName)	
End If

If IsValid(w_back) then w_back.wf_UpdateVer()

Close(Parent)
end event

type st_nametext from statictext within w_vmic
integer x = 128
integer y = 1248
integer width = 530
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_idtext from statictext within w_vmic
integer x = 128
integer y = 1152
integer width = 512
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_insttext from statictext within w_vmic
integer x = 128
integer y = 1056
integer width = 567
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_vmic from commandbutton within w_vmic
integer x = 622
integer y = 704
integer width = 951
integer height = 112
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Check VMIC"
end type

event clicked;String ls_Code, ls_Hex
Integer li_Loop, li_Pos, li_Temp
Long ll_Checksum
Integer li_Array[]

mle_vmic.Text = Upper(Trim(mle_vmic.Text))
ls_Code = ""

For li_Loop = 1 to Len(mle_vmic.text)
	If mid(mle_vmic.Text, li_Loop, 1) >= 'A' and mid(mle_vmic.Text, li_Loop, 1) <= 'Z' then ls_Code = ls_Code + mid(mle_vmic.Text, li_Loop, 1)
Next

mle_vmic.Text = ls_Code

f_Write2Log("w_VMIC > cb_VMIC: Code = " + ls_Code)

// Reset display fields
st_insttext.Text = ""
st_install.Text = ""
st_nametext.Text = ""
st_idtext.Text = ""
st_id.Text = ""
st_name.Text = ""
cb_ok.Enabled = False
If g_Obj.install = 255 then cb_cancel.Text = 'Exit'

// Check of length of code is too short or not an even number
If (Len(ls_Code) < 10) or (Mod(Len(ls_Code), 2) = 1) then 
	Messagebox("Invalid Code", "The VMIC entered is not valid. Please check and try again.", Exclamation!)
	mle_vmic.SetFocus( )
	Return
End If

// Convert to Hexadecimal
li_Pos = Len(ls_Code)
For li_Loop = 1 to li_Pos
	ls_Hex = Mid(ls_Code, li_Loop, 1)
	If ls_Hex > 'G' then ls_Code = Replace(ls_Code, li_Loop, 1, CharA(AscA(ls_Hex) - 33))
Next

// Convert to Byte Array
li_Pos =  1 
Do
	ls_Hex = Mid(ls_Code, li_Pos, 2)
	li_Array[(li_Pos + 1)/2] = wf_Hex2Byte(ls_Hex)
	li_Pos++
	li_Pos++
Loop Until li_Pos > len(ls_Code)
li_Pos = UpperBound(li_Array)

// Invert all bytes
For li_Loop = 1 to li_Pos
	li_Array[li_Loop] = 255 - li_Array[li_Loop]
Next

// Calculate checksum
ll_Checksum = 0
For li_Loop = 1 to li_Pos - 2
	ll_Checksum += li_Array[li_Loop] * li_Loop
Next
ll_Checksum = mod(ll_Checksum, 65536)

// Compare checksum
If ll_Checksum <> li_Array[li_Pos - 1] * 256 + li_Array[li_Pos] then
	Messagebox("Invalid Checksum", "The VMIC provided is incorrect. Please check the code and try again.", Exclamation!)
	f_Write2Log("w_VMIC > cb_VMIC: Checksum Failed")
	Return
End If

// Install Type
li_Pos = 5
ib_Install = li_Array[li_Pos]

// Get ID
ls_Code = ""
li_Pos++
li_Temp = li_Array[li_Pos]
For li_Loop = 1 to li_Temp
	li_Pos++
	ls_Code += String(CharA(li_Array[li_Pos]))
Next 
If ib_Install = 0 then il_IMO = Long(ls_Code) else is_userid = ls_Code 

// Get vesselname / inspectors first name
ls_Code = ""
li_Pos++
li_Temp = li_Array[li_Pos]
For li_Loop = 1 to li_Temp
	li_Pos++
	ls_Code += String(CharA(li_Array[li_Pos]))
Next 
If ib_Install = 0 then is_vessel = ls_Code else is_fname = ls_Code

// Get inspector's last name or vessel number
ls_Code = ""
li_Pos++
li_Temp = li_Array[li_Pos]
For li_Loop = 1 to li_Temp
	li_Pos++
	ls_Code += String(CharA(li_Array[li_Pos]))
Next 
If ib_Install = 0 then is_VesselNum = ls_Code Else is_LName = ls_Code	

// Get any extra info
ls_Code = ""
li_Pos++
li_Temp = li_Array[li_Pos]
For li_Loop = 1 to li_Temp
	li_Pos++
	ls_Code += String(CharA(li_Array[li_Pos]))
Next 
//  Extra info in ls_Code not presently used. Insert code here to use this info

st_insttext.Text = "Installation Type:"

If ib_Install = 0 then   // Vessel installation
	st_install.Text = "Vessel"
	st_nametext.Text = "Vessel No./Name:"
	st_idtext.Text = "Vessel IMO:"
	st_id.Text = String(il_IMO)
	st_name.Text = is_VesselNum + " / " + is_Vessel
Else  // Inspector's installation
	st_install.Text = "Inspector"
	st_nametext.Text = "Inspector's Name:"
	st_idtext.Text = "User ID:"
	st_id.Text = is_UserID
	st_name.Text = is_fname + " " + is_lname
End If

cb_ok.Enabled = True
cb_cancel.Text = 'Cancel'

Messagebox("VMIC Valid", "The code is valid. Please check the 'Identification Information' for this installation carefully.~n~nIf the information is correct, click on the 'Accept' button.~n~nIf the information is not correct for this installation, click on 'Cancel' and notify the Maersk Tankers Vetting Department.")


end event

type st_1 from statictext within w_vmic
integer x = 18
integer y = 240
integer width = 219
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMIC:"
boolean focusrectangle = false
end type

type mle_vmic from multilineedit within w_vmic
integer x = 18
integer y = 304
integer width = 2158
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
textcase textcase = upper!
integer limit = 500
borderstyle borderstyle = stylelowered!
end type

type st_dis from statictext within w_vmic
integer x = 18
integer y = 16
integer width = 2121
integer height = 160
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "This installation of VIMS Mobile needs to be initialized before use. Please enter the VIMS Mobile Identification Code and click on the ~'Check VMIC~' button."
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_vmic
integer x = 18
integer y = 944
integer width = 2158
integer height = 400
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "Identification Information"
end type

type cb_paste from commandbutton within w_vmic
integer x = 1957
integer y = 240
integer width = 219
integer height = 68
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Paste"
end type

event clicked;
String ls_Code 

ls_Code = Clipboard()

If Len(Trim(ls_Code, True)) > 0 then 
	mle_vmic.Text = ls_Code
Else
	Messagebox("Paste Error", "The clipboard does not contain any text!", Exclamation!)
End If
end event

