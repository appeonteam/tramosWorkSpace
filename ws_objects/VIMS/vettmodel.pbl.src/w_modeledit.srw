$PBExportHeader$w_modeledit.srw
forward
global type w_modeledit from window
end type
type sle_doctype from singlelineedit within w_modeledit
end type
type st_15 from statictext within w_modeledit
end type
type htb_remdays from htrackbar within w_modeledit
end type
type st_14 from statictext within w_modeledit
end type
type st_12 from statictext within w_modeledit
end type
type st_remdays from statictext within w_modeledit
end type
type cbx_toreview from checkbox within w_modeledit
end type
type htb_extint from htrackbar within w_modeledit
end type
type st_13 from statictext within w_modeledit
end type
type st_extint from statictext within w_modeledit
end type
type st_11 from statictext within w_modeledit
end type
type st_10 from statictext within w_modeledit
end type
type cbx_autofill from checkbox within w_modeledit
end type
type cbx_rating from checkbox within w_modeledit
end type
type cbx_active from checkbox within w_modeledit
end type
type st_int from statictext within w_modeledit
end type
type htb_int from htrackbar within w_modeledit
end type
type st_9 from statictext within w_modeledit
end type
type st_8 from statictext within w_modeledit
end type
type st_7 from statictext within w_modeledit
end type
type st_6 from statictext within w_modeledit
end type
type sle_short from singlelineedit within w_modeledit
end type
type cbx_ext from checkbox within w_modeledit
end type
type em_max from editmask within w_modeledit
end type
type st_3 from statictext within w_modeledit
end type
type st_5 from statictext within w_modeledit
end type
type sle_web from singlelineedit within w_modeledit
end type
type cb_cancel from commandbutton within w_modeledit
end type
type cb_ok from commandbutton within w_modeledit
end type
type mle_notes from multilineedit within w_modeledit
end type
type sle_edn from singlelineedit within w_modeledit
end type
type sle_name from singlelineedit within w_modeledit
end type
type st_4 from statictext within w_modeledit
end type
type st_2 from statictext within w_modeledit
end type
type st_1 from statictext within w_modeledit
end type
type gb_1 from groupbox within w_modeledit
end type
end forward

global type w_modeledit from window
integer width = 1998
integer height = 1956
boolean titlebar = true
string title = "New Inspection Model"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_doctype sle_doctype
st_15 st_15
htb_remdays htb_remdays
st_14 st_14
st_12 st_12
st_remdays st_remdays
cbx_toreview cbx_toreview
htb_extint htb_extint
st_13 st_13
st_extint st_extint
st_11 st_11
st_10 st_10
cbx_autofill cbx_autofill
cbx_rating cbx_rating
cbx_active cbx_active
st_int st_int
htb_int htb_int
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
sle_short sle_short
cbx_ext cbx_ext
em_max em_max
st_3 st_3
st_5 st_5
sle_web sle_web
cb_cancel cb_cancel
cb_ok cb_ok
mle_notes mle_notes
sle_edn sle_edn
sle_name sle_name
st_4 st_4
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_modeledit w_modeledit

type variables

string is_Name, is_Edn, is_Notes, is_Web, is_Short, is_DocType
Long il_Max
Integer ii_Ext, ii_Int, ii_IntExt, ii_Active, ii_Rating, ii_Autofill, ii_NoTechReview, ii_RemDays

end variables

on w_modeledit.create
this.sle_doctype=create sle_doctype
this.st_15=create st_15
this.htb_remdays=create htb_remdays
this.st_14=create st_14
this.st_12=create st_12
this.st_remdays=create st_remdays
this.cbx_toreview=create cbx_toreview
this.htb_extint=create htb_extint
this.st_13=create st_13
this.st_extint=create st_extint
this.st_11=create st_11
this.st_10=create st_10
this.cbx_autofill=create cbx_autofill
this.cbx_rating=create cbx_rating
this.cbx_active=create cbx_active
this.st_int=create st_int
this.htb_int=create htb_int
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.sle_short=create sle_short
this.cbx_ext=create cbx_ext
this.em_max=create em_max
this.st_3=create st_3
this.st_5=create st_5
this.sle_web=create sle_web
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.mle_notes=create mle_notes
this.sle_edn=create sle_edn
this.sle_name=create sle_name
this.st_4=create st_4
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.sle_doctype,&
this.st_15,&
this.htb_remdays,&
this.st_14,&
this.st_12,&
this.st_remdays,&
this.cbx_toreview,&
this.htb_extint,&
this.st_13,&
this.st_extint,&
this.st_11,&
this.st_10,&
this.cbx_autofill,&
this.cbx_rating,&
this.cbx_active,&
this.st_int,&
this.htb_int,&
this.st_9,&
this.st_8,&
this.st_7,&
this.st_6,&
this.sle_short,&
this.cbx_ext,&
this.em_max,&
this.st_3,&
this.st_5,&
this.sle_web,&
this.cb_cancel,&
this.cb_ok,&
this.mle_notes,&
this.sle_edn,&
this.sle_name,&
this.st_4,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_modeledit.destroy
destroy(this.sle_doctype)
destroy(this.st_15)
destroy(this.htb_remdays)
destroy(this.st_14)
destroy(this.st_12)
destroy(this.st_remdays)
destroy(this.cbx_toreview)
destroy(this.htb_extint)
destroy(this.st_13)
destroy(this.st_extint)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.cbx_autofill)
destroy(this.cbx_rating)
destroy(this.cbx_active)
destroy(this.st_int)
destroy(this.htb_int)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_short)
destroy(this.cbx_ext)
destroy(this.em_max)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.sle_web)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.mle_notes)
destroy(this.sle_edn)
destroy(this.sle_name)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
If g_Obj.InspModel>=0 then	
	Select NAME, EDITION, NOTES, WEBSITE, MAXSCORE, EXTMODEL, SHORTNAME, INTERVAL, EXTINTERVAL, ACTIVE, HASRATING, AUTOFILL, NOTECHREVIEW, REMDAYS, OCIMFDOCTYPE
	Into :is_Name, :is_Edn, :is_Notes, :is_Web, :il_Max, :ii_Ext, :is_Short, :ii_Int, :ii_IntExt, :ii_Active, :ii_Rating, :ii_Autofill, :ii_NoTechReview, :ii_RemDays, :is_DocType from VETT_INSPMODEL where IM_ID = :g_obj.inspmodel;
	If SQLCA.Sqlcode<>0 then
		Rollback;
		Messagebox("SQL Error", "Could not retrieve the inspection model from the database.",Exclamation!)
		close(This)
	else
		commit;
		sle_name.text = is_name
		sle_edn.text = is_edn
		sle_short.text = is_short
		mle_notes.text = is_notes
		sle_Web.text = is_Web
		sle_Doctype.text = is_DocType
		em_max.Text = String(il_Max, "#,##0")
		If IsNull(ii_Int) then htb_int.Position = 2 Else htb_int.Position = ii_Int
		htb_int.event Moved(ii_Int)
		If IsNull(ii_IntExt) then htb_extint.Position = 2 Else htb_extint.Position = ii_IntExt
		htb_extint.event Moved(ii_IntExt)
		If ii_RemDays = 0 then htb_RemDays.Position = 6 Else htb_RemDays.Position = ii_RemDays
		htb_RemDays.event Moved(ii_RemDays)
		htb_RemDays.Visible = Not IsNull(ii_Int)
		This.Title = "Edit Inspection Model"
		cbx_ext.Enabled = False
		cbx_Autofill.Enabled = False
		If ii_ext = 1 then cbx_ext.Checked = True
		If ii_Active = 1 then cbx_Active.Checked = True
		If ii_Rating = 1 then cbx_Rating.Checked = True
		If ii_Autofill = 1 then cbx_Autofill.Checked = True
		If ii_NoTechReview = 0 then cbx_TOReview.Checked = True
		If g_obj.inspmodel = 30 then sle_name.Enabled = False   // Disable if PSC
	End If
Else
	htb_int.Position = 2
	cbx_Active.Checked = True
	cbx_Active.Enabled = False
End if

end event

type sle_doctype from singlelineedit within w_modeledit
integer x = 1591
integer y = 1184
integer width = 293
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_15 from statictext within w_modeledit
integer x = 1097
integer y = 1192
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "OCIMF Doc Type:"
boolean focusrectangle = false
end type

type htb_remdays from htrackbar within w_modeledit
integer x = 914
integer y = 624
integer width = 969
integer height = 80
integer minposition = 6
integer maxposition = 30
integer position = 6
integer tickfrequency = 1
integer slidersize = 20
htickmarks tickmarks = hticksonneither!
end type

event moved;
If Position = 6 then st_RemDays.Text = "" Else st_RemDays.Text = String(Position)
end event

event lineleft;
If Position = 6 then st_RemDays.Text = "" Else st_RemDays.Text = String(Position)
end event

event lineright;
If Position = 6 then st_RemDays.Text = "" Else st_RemDays.Text = String(Position)
end event

event pageleft;
If Position = 6 then st_RemDays.Text = "" Else st_RemDays.Text = String(Position)
end event

event pageright;
If Position = 6 then st_RemDays.Text = "" Else st_RemDays.Text = String(Position)
end event

type st_14 from statictext within w_modeledit
integer x = 73
integer y = 640
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
string text = "Reminder Email:"
boolean focusrectangle = false
end type

type st_12 from statictext within w_modeledit
integer x = 731
integer y = 640
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "days"
boolean focusrectangle = false
end type

type st_remdays from statictext within w_modeledit
integer x = 585
integer y = 624
integer width = 128
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cbx_toreview from checkbox within w_modeledit
integer x = 585
integer y = 1472
integer width = 622
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Requires T.O. Review"
end type

type htb_extint from htrackbar within w_modeledit
integer x = 914
integer y = 528
integer width = 969
integer height = 80
integer minposition = 2
integer maxposition = 24
integer position = 6
integer tickfrequency = 1
integer slidersize = 20
htickmarks tickmarks = hticksonneither!
end type

event moved;
If Position = 2 then st_ExtInt.Text = "" Else st_ExtInt.Text = String(Position)
end event

event lineleft;
If Position = 2 then st_ExtInt.Text = "" Else st_ExtInt.Text = String(Position)
end event

event lineright;
If Position = 2 then st_ExtInt.Text = "" Else st_ExtInt.Text = String(Position)
end event

event pageleft;
If Position = 2 then st_ExtInt.Text = "" Else st_ExtInt.Text = String(Position)
end event

event pageright;
If Position = 2 then st_ExtInt.Text = "" Else st_ExtInt.Text = String(Position)
end event

type st_13 from statictext within w_modeledit
integer x = 731
integer y = 544
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "months"
boolean focusrectangle = false
end type

type st_extint from statictext within w_modeledit
integer x = 585
integer y = 528
integer width = 128
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_11 from statictext within w_modeledit
integer x = 73
integer y = 544
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
string text = "Interval (T/C,3P):"
boolean focusrectangle = false
end type

type st_10 from statictext within w_modeledit
integer x = 73
integer y = 1296
integer width = 407
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Model Options:"
boolean focusrectangle = false
end type

type cbx_autofill from checkbox within w_modeledit
integer x = 1262
integer y = 1376
integer width = 535
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Auto-fill"
end type

type cbx_rating from checkbox within w_modeledit
integer x = 1262
integer y = 1472
integer width = 535
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Display Rating"
end type

type cbx_active from checkbox within w_modeledit
integer x = 585
integer y = 1568
integer width = 498
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Active"
end type

type st_int from statictext within w_modeledit
integer x = 585
integer y = 432
integer width = 128
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type htb_int from htrackbar within w_modeledit
integer x = 914
integer y = 432
integer width = 969
integer height = 80
integer minposition = 2
integer maxposition = 24
integer position = 6
integer tickfrequency = 1
integer slidersize = 20
htickmarks tickmarks = hticksonneither!
end type

event moved;
If Position = 2 then 
	st_Int.Text = "" 
	htb_remdays.Visible = False
	htb_remdays.Position = 6
	st_RemDays.Text = ""
Else 
	st_Int.Text = String(Position)
	htb_remdays.Visible = True
End If
end event

event pageleft;
If Position = 2 then st_Int.Text = "" Else st_Int.Text = String(Position)
end event

event pageright;
st_Int.Text = String(Position)
htb_RemDays.visible= True
end event

event lineleft;
If Position = 2 then 
	st_Int.Text = "" 
	htb_remdays.Visible = False
	htb_remdays.Position = 6
	st_RemDays.Text = ""
Else 
	st_Int.Text = String(Position)
	htb_remdays.Visible = True
End If
end event

event lineright;
st_Int.Text = String(Position)
htb_RemDays.visible= True
end event

type st_9 from statictext within w_modeledit
integer x = 731
integer y = 448
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "months"
boolean focusrectangle = false
end type

type st_8 from statictext within w_modeledit
integer x = 73
integer y = 448
integer width = 416
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Interval (Own):"
boolean focusrectangle = false
end type

type st_7 from statictext within w_modeledit
integer x = 896
integer y = 352
integer width = 677
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "( Max 4 characters only )"
boolean focusrectangle = false
end type

type st_6 from statictext within w_modeledit
integer x = 73
integer y = 352
integer width = 347
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Short Name:"
boolean focusrectangle = false
end type

type sle_short from singlelineedit within w_modeledit
integer x = 585
integer y = 336
integer width = 293
integer height = 80
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type cbx_ext from checkbox within w_modeledit
integer x = 585
integer y = 1376
integer width = 498
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Empty Model"
end type

event clicked;
If This.Checked then 
	cbx_Autofill.Checked = False
	cbx_Autofill.Enabled = False
Else
	cbx_Autofill.Enabled = True
End If
end event

type em_max from editmask within w_modeledit
integer x = 585
integer y = 1184
integer width = 384
integer height = 80
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "29000"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,##0"
string minmax = "1000~~100000"
end type

type st_3 from statictext within w_modeledit
integer x = 73
integer y = 1192
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Max Score:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_modeledit
integer x = 73
integer y = 1104
integer width = 247
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Website:"
boolean focusrectangle = false
end type

type sle_web from singlelineedit within w_modeledit
integer x = 585
integer y = 1088
integer width = 1298
integer height = 80
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_modeledit
integer x = 1189
integer y = 1740
integer width = 402
integer height = 96
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_obj.inspmodel = -10
close(Parent)
end event

type cb_ok from commandbutton within w_modeledit
integer x = 384
integer y = 1740
integer width = 402
integer height = 96
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;String ls_Data

is_Name = Trim(sle_name.Text, True)

If is_name = "" then
	MessageBox("Error","Please specify a name for the inspection model.",Exclamation!)
	Return
End if

If (Upper(is_Name) = "PORT STATE CONTROL") and (sle_name.Enabled) then
	Messagebox("Invalid Name", "'Port State Control' is a special inspection model name that cannot be used twice.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

is_edn = Trim(sle_edn.Text)
is_Short = Trim(sle_short.Text)
If is_Short = "" then SetNull(is_Short)
is_notes = Trim(mle_notes.Text)
is_web = Trim(sle_web.Text)
is_DocType = Trim(sle_DocType.Text)
if is_DocType="" then SetNull(is_DocType)
ii_Int = htb_int.Position
If ii_Int = 2 then SetNull(ii_Int)
ii_IntExt = htb_extint.Position
If ii_IntExt = 2 then SetNull(ii_IntExt)
ii_RemDays = htb_RemDays.Position
If ii_RemDays = 6 then ii_RemDays = 0
il_Max = Long(em_max.Text)
If cbx_ext.checked then ii_Ext = 1 else ii_Ext = 0
If cbx_Active.Checked then ii_Active = 1 Else ii_Active = 0
If cbx_Rating.Checked then ii_Rating = 1 Else ii_Rating = 0
If cbx_AutoFill.Checked then ii_Autofill = 1 Else ii_AutoFill = 0
If cbx_TOReview.Checked then ii_NoTechReview = 0 Else ii_NoTechReview = 1  // DB field is opposite of checkbox

If g_obj.inspmodel < 0 then // New entry
	INSERT VETT_INSPMODEL (NAME, EDITION, WEBSITE, NOTES, MAXSCORE, EXTMODEL, SHORTNAME, INTERVAL, EXTINTERVAL, HASRATING, AUTOFILL, NOTECHREVIEW, REMDAYS, OCIMFDOCTYPE) Values (:is_name, :is_edn, :is_web, :is_notes, :il_Max, :ii_Ext, :is_Short, :ii_Int, :ii_IntExt, :ii_Rating, :ii_AutoFill, :ii_NoTechReview, :ii_RemDays, :is_DocType);
Else
	UPDATE VETT_INSPMODEL SET NAME = :is_name, EDITION = :is_edn, WEBSITE = :is_Web, NOTES = :is_notes, MAXSCORE = :il_Max, SHORTNAME = :is_Short, INTERVAL = :ii_Int, EXTINTERVAL = :ii_IntExt, ACTIVE = :ii_Active, HASRATING = :ii_Rating, NOTECHREVIEW=:ii_NoTechReview, REMDAYS=:ii_RemDays, OCIMFDOCTYPE=:is_DocType WHERE IM_ID = :g_obj.inspmodel ;
End if	

If SQLCA.SQlCode<>0 then
	MessageBox("Error","DB error when adding/updating Inspection Model.~n~nError:" + SQLCA.SQLerrtext, Exclamation!)
	rollback;
	Return
Else
	Commit;
	g_obj.Inspmodel = 1
	If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
		ls_Data = "1"
		If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
	End If
	Close(Parent)
End If
end event

type mle_notes from multilineedit within w_modeledit
integer x = 585
integer y = 720
integer width = 1298
integer height = 352
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
integer limit = 1000
borderstyle borderstyle = stylelowered!
end type

type sle_edn from singlelineedit within w_modeledit
integer x = 585
integer y = 240
integer width = 1298
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type sle_name from singlelineedit within w_modeledit
integer x = 585
integer y = 144
integer width = 1298
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_modeledit
integer x = 73
integer y = 736
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Notes:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_modeledit
integer x = 73
integer y = 256
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Edition:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_modeledit
integer x = 73
integer y = 160
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
string text = "Name:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_modeledit
integer x = 37
integer y = 32
integer width = 1902
integer height = 1664
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Model"
end type

