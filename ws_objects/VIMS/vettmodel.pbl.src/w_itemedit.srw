$PBExportHeader$w_itemedit.srw
forward
global type w_itemedit from window
end type
type st_ObjID from statictext within w_itemedit
end type
type sle_extnum from singlelineedit within w_itemedit
end type
type cb_ext from commandbutton within w_itemedit
end type
type cb_delminornote from picturebutton within w_itemedit
end type
type cb_minornote from picturebutton within w_itemedit
end type
type st_15 from statictext within w_itemedit
end type
type cb_majornote from picturebutton within w_itemedit
end type
type cb_delmajornote from picturebutton within w_itemedit
end type
type cb_delminor from picturebutton within w_itemedit
end type
type cb_minor from picturebutton within w_itemedit
end type
type cb_delatt from picturebutton within w_itemedit
end type
type cb_addatt from picturebutton within w_itemedit
end type
type mle_majornote from multilineedit within w_itemedit
end type
type st_14 from statictext within w_itemedit
end type
type cb_major from picturebutton within w_itemedit
end type
type cb_delmajor from picturebutton within w_itemedit
end type
type cb_reply from picturebutton within w_itemedit
end type
type cb_delreply from picturebutton within w_itemedit
end type
type cb_delunote from picturebutton within w_itemedit
end type
type cb_unote from picturebutton within w_itemedit
end type
type cb_gnote from picturebutton within w_itemedit
end type
type cb_clear from picturebutton within w_itemedit
end type
type cb_delgnote from picturebutton within w_itemedit
end type
type mle_minornote from multilineedit within w_itemedit
end type
type mle_minor from multilineedit within w_itemedit
end type
type st_13 from statictext within w_itemedit
end type
type mle_major from multilineedit within w_itemedit
end type
type st_11 from statictext within w_itemedit
end type
type cbx_disable from checkbox within w_itemedit
end type
type st_att from statictext within w_itemedit
end type
type st_12 from statictext within w_itemedit
end type
type rb_info from radiobutton within w_itemedit
end type
type st_serial from statictext within w_itemedit
end type
type ddlb_riskrating from dropdownlistbox within w_itemedit
end type
type st_10 from statictext within w_itemedit
end type
type cb_addguide from commandbutton within w_itemedit
end type
type cb_addtext from commandbutton within w_itemedit
end type
type mle_reply from multilineedit within w_itemedit
end type
type st_9 from statictext within w_itemedit
end type
type mle_unote from multilineedit within w_itemedit
end type
type st_8 from statictext within w_itemedit
end type
type rb_na from radiobutton within w_itemedit
end type
type ddlb_risk from dropdownlistbox within w_itemedit
end type
type st_7 from statictext within w_itemedit
end type
type mle_text from multilineedit within w_itemedit
end type
type mle_note from multilineedit within w_itemedit
end type
type st_6 from statictext within w_itemedit
end type
type rb_sub from radiobutton within w_itemedit
end type
type rb_ques from radiobutton within w_itemedit
end type
type rb_sec from radiobutton within w_itemedit
end type
type rb_chap from radiobutton within w_itemedit
end type
type st_5 from statictext within w_itemedit
end type
type cb_cancel from commandbutton within w_itemedit
end type
type cb_ok from commandbutton within w_itemedit
end type
type st_parent from statictext within w_itemedit
end type
type st_4 from statictext within w_itemedit
end type
type rb_non from radiobutton within w_itemedit
end type
type rb_des from radiobutton within w_itemedit
end type
type rb_rec from radiobutton within w_itemedit
end type
type rb_stat from radiobutton within w_itemedit
end type
type st_3 from statictext within w_itemedit
end type
type st_2 from statictext within w_itemedit
end type
type em_num from editmask within w_itemedit
end type
type st_1 from statictext within w_itemedit
end type
type gb_2 from groupbox within w_itemedit
end type
type gb_1 from groupbox within w_itemedit
end type
end forward

global type w_itemedit from window
integer width = 2798
integer height = 2620
boolean titlebar = true
string title = "New Entity"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_ObjID st_ObjID
sle_extnum sle_extnum
cb_ext cb_ext
cb_delminornote cb_delminornote
cb_minornote cb_minornote
st_15 st_15
cb_majornote cb_majornote
cb_delmajornote cb_delmajornote
cb_delminor cb_delminor
cb_minor cb_minor
cb_delatt cb_delatt
cb_addatt cb_addatt
mle_majornote mle_majornote
st_14 st_14
cb_major cb_major
cb_delmajor cb_delmajor
cb_reply cb_reply
cb_delreply cb_delreply
cb_delunote cb_delunote
cb_unote cb_unote
cb_gnote cb_gnote
cb_clear cb_clear
cb_delgnote cb_delgnote
mle_minornote mle_minornote
mle_minor mle_minor
st_13 st_13
mle_major mle_major
st_11 st_11
cbx_disable cbx_disable
st_att st_att
st_12 st_12
rb_info rb_info
st_serial st_serial
ddlb_riskrating ddlb_riskrating
st_10 st_10
cb_addguide cb_addguide
cb_addtext cb_addtext
mle_reply mle_reply
st_9 st_9
mle_unote mle_unote
st_8 st_8
rb_na rb_na
ddlb_risk ddlb_risk
st_7 st_7
mle_text mle_text
mle_note mle_note
st_6 st_6
rb_sub rb_sub
rb_ques rb_ques
rb_sec rb_sec
rb_chap rb_chap
st_5 st_5
cb_cancel cb_cancel
cb_ok cb_ok
st_parent st_parent
st_4 st_4
rb_non rb_non
rb_des rb_des
rb_rec rb_rec
rb_stat rb_stat
st_3 st_3
st_2 st_2
em_num em_num
st_1 st_1
gb_2 gb_2
gb_1 gb_1
end type
global w_itemedit w_itemedit

type variables

Long il_NoteID, il_TextID, il_UNoteID, il_ReplyID, il_MajorID, il_MinorID, il_MajorNoteID, il_MinorNoteID, il_ExtNum
Integer ii_Risk, ii_RiskRating, ii_EditMode
end variables

on w_itemedit.create
this.st_ObjID=create st_ObjID
this.sle_extnum=create sle_extnum
this.cb_ext=create cb_ext
this.cb_delminornote=create cb_delminornote
this.cb_minornote=create cb_minornote
this.st_15=create st_15
this.cb_majornote=create cb_majornote
this.cb_delmajornote=create cb_delmajornote
this.cb_delminor=create cb_delminor
this.cb_minor=create cb_minor
this.cb_delatt=create cb_delatt
this.cb_addatt=create cb_addatt
this.mle_majornote=create mle_majornote
this.st_14=create st_14
this.cb_major=create cb_major
this.cb_delmajor=create cb_delmajor
this.cb_reply=create cb_reply
this.cb_delreply=create cb_delreply
this.cb_delunote=create cb_delunote
this.cb_unote=create cb_unote
this.cb_gnote=create cb_gnote
this.cb_clear=create cb_clear
this.cb_delgnote=create cb_delgnote
this.mle_minornote=create mle_minornote
this.mle_minor=create mle_minor
this.st_13=create st_13
this.mle_major=create mle_major
this.st_11=create st_11
this.cbx_disable=create cbx_disable
this.st_att=create st_att
this.st_12=create st_12
this.rb_info=create rb_info
this.st_serial=create st_serial
this.ddlb_riskrating=create ddlb_riskrating
this.st_10=create st_10
this.cb_addguide=create cb_addguide
this.cb_addtext=create cb_addtext
this.mle_reply=create mle_reply
this.st_9=create st_9
this.mle_unote=create mle_unote
this.st_8=create st_8
this.rb_na=create rb_na
this.ddlb_risk=create ddlb_risk
this.st_7=create st_7
this.mle_text=create mle_text
this.mle_note=create mle_note
this.st_6=create st_6
this.rb_sub=create rb_sub
this.rb_ques=create rb_ques
this.rb_sec=create rb_sec
this.rb_chap=create rb_chap
this.st_5=create st_5
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_parent=create st_parent
this.st_4=create st_4
this.rb_non=create rb_non
this.rb_des=create rb_des
this.rb_rec=create rb_rec
this.rb_stat=create rb_stat
this.st_3=create st_3
this.st_2=create st_2
this.em_num=create em_num
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.st_ObjID,&
this.sle_extnum,&
this.cb_ext,&
this.cb_delminornote,&
this.cb_minornote,&
this.st_15,&
this.cb_majornote,&
this.cb_delmajornote,&
this.cb_delminor,&
this.cb_minor,&
this.cb_delatt,&
this.cb_addatt,&
this.mle_majornote,&
this.st_14,&
this.cb_major,&
this.cb_delmajor,&
this.cb_reply,&
this.cb_delreply,&
this.cb_delunote,&
this.cb_unote,&
this.cb_gnote,&
this.cb_clear,&
this.cb_delgnote,&
this.mle_minornote,&
this.mle_minor,&
this.st_13,&
this.mle_major,&
this.st_11,&
this.cbx_disable,&
this.st_att,&
this.st_12,&
this.rb_info,&
this.st_serial,&
this.ddlb_riskrating,&
this.st_10,&
this.cb_addguide,&
this.cb_addtext,&
this.mle_reply,&
this.st_9,&
this.mle_unote,&
this.st_8,&
this.rb_na,&
this.ddlb_risk,&
this.st_7,&
this.mle_text,&
this.mle_note,&
this.st_6,&
this.rb_sub,&
this.rb_ques,&
this.rb_sec,&
this.rb_chap,&
this.st_5,&
this.cb_cancel,&
this.cb_ok,&
this.st_parent,&
this.st_4,&
this.rb_non,&
this.rb_des,&
this.rb_rec,&
this.rb_stat,&
this.st_3,&
this.st_2,&
this.em_num,&
this.st_1,&
this.gb_2,&
this.gb_1}
end on

on w_itemedit.destroy
destroy(this.st_ObjID)
destroy(this.sle_extnum)
destroy(this.cb_ext)
destroy(this.cb_delminornote)
destroy(this.cb_minornote)
destroy(this.st_15)
destroy(this.cb_majornote)
destroy(this.cb_delmajornote)
destroy(this.cb_delminor)
destroy(this.cb_minor)
destroy(this.cb_delatt)
destroy(this.cb_addatt)
destroy(this.mle_majornote)
destroy(this.st_14)
destroy(this.cb_major)
destroy(this.cb_delmajor)
destroy(this.cb_reply)
destroy(this.cb_delreply)
destroy(this.cb_delunote)
destroy(this.cb_unote)
destroy(this.cb_gnote)
destroy(this.cb_clear)
destroy(this.cb_delgnote)
destroy(this.mle_minornote)
destroy(this.mle_minor)
destroy(this.st_13)
destroy(this.mle_major)
destroy(this.st_11)
destroy(this.cbx_disable)
destroy(this.st_att)
destroy(this.st_12)
destroy(this.rb_info)
destroy(this.st_serial)
destroy(this.ddlb_riskrating)
destroy(this.st_10)
destroy(this.cb_addguide)
destroy(this.cb_addtext)
destroy(this.mle_reply)
destroy(this.st_9)
destroy(this.mle_unote)
destroy(this.st_8)
destroy(this.rb_na)
destroy(this.ddlb_risk)
destroy(this.st_7)
destroy(this.mle_text)
destroy(this.mle_note)
destroy(this.st_6)
destroy(this.rb_sub)
destroy(this.rb_ques)
destroy(this.rb_sec)
destroy(this.rb_chap)
destroy(this.st_5)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_parent)
destroy(this.st_4)
destroy(this.rb_non)
destroy(this.rb_des)
destroy(this.rb_rec)
destroy(this.rb_stat)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_num)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;
String ls_1, ls_2, ls_Note, ls_Text, ls_UNote, ls_Reply, ls_AttName, ls_Major, ls_Minor, ls_MajorNote, ls_MinorNote
Integer li_Type, li_Num, li_Req, li_Risk, li_RiskRating, li_Active

st_Parent.Text = g_obj.ObjParent

If g_Obj.Objstring = "Edit" then     // If Edit mode

	ii_EditMode = 1
	st_ObjID.Text = "ID: " + String(g_Obj.ObjID)
	
	// Set options
	This.Title = "Edit Entity"
	If g_obj.Level = 1 then rb_Chap.Checked = True    // Question
	If g_obj.Level = 2 then rb_Sec.Checked = True     // Section
	If g_obj.Level = 3 then rb_Ques.Checked = True    // Question
	If g_obj.Level = 4 then rb_Sub.Checked = True     // Sub-question
	
	// If item is not question
	If g_obj.Level < 3 then 
		ddlb_risk.Visible = False 
		ddlb_riskrating.Visible = False
		st_7.Visible = False
		st_10.Visible = False
		sle_Extnum.Visible = False
		st_Serial.Visible = False
		cb_Ext.Visible = False
	End If
	
	// Get item data
	Select OBJNUM, TEXTDATA, OBJTYPE, OBJTEXT, REQTYPE, 
	       OBJNOTE, USERNOTE, AUTOREPLY,
			 (Select TEXTDATA from VETT_TEXT Where TEXT_ID = VETT_OBJ.SECTMAIN),
			 (Select TEXTDATA from VETT_TEXT Where TEXT_ID = VETT_OBJ.SECTHEAD),
			 DEFRISK, RISKRATING, EXTNUM, ATTNAME, ACTIVE,
			 SECTMAIN, SECTHEAD, SECTMAINNOTE, SECTHEADNOTE
	into :li_Num, :ls_Text, :li_Type, :il_TextID, :li_Req, 
		  :il_NoteID, :il_UNoteID, :il_ReplyID,	:ls_Major, :ls_Minor,
		  :li_Risk, :li_RiskRating, :il_ExtNum, :ls_AttName, :li_Active,
		  :il_MajorID, :il_MinorID,	:il_MajorNoteID, :il_MinorNoteID
	from VETT_OBJ INNER JOIN VETT_TEXT ON VETT_TEXT.TEXT_ID = VETT_OBJ.OBJTEXT
  Where VETT_OBJ.OBJ_ID = :g_Obj.Objid;
	
	// Get notes
	If SQLCA.SQLCode >= 0 then 
		Select NOTE_TEXT into :ls_Note from VETT_NOTES Where NOTES_ID = :il_NoteID;
	End If
	If SQLCA.SQLCode >= 0 then
		Select NOTE_TEXT into :ls_UNote from VETT_NOTES Where NOTES_ID = :il_UNoteID;
	End If
	If SQLCA.SQLCode >= 0 then 
		Select NOTE_TEXT into :ls_Reply from VETT_NOTES Where NOTES_ID = :il_ReplyID;
	End If
	If SQLCA.SQLCode >= 0 then 
		Select NOTE_TEXT into :ls_MajorNote from VETT_NOTES Where NOTES_ID = :il_MajorNoteID;
	End If
	If SQLCA.SQLCode >= 0 then 
		Select NOTE_TEXT into :ls_MinorNote from VETT_NOTES Where NOTES_ID = :il_MinorNoteID;
	End If
	
	// If any error, roll back and close
	If SQLCA.SQLCode < 0 then
		MessageBox ("DB Error", "Could not retrieve item from database.~n~n" + SQLCA.SQLErrText, Exclamation!)
		g_Obj.Objid = -10
		Rollback;
		Close(This)
		Return
	End If
	
	Commit;
	
	// Fill fields
	em_num.Text = String(li_Num)
	sle_Extnum.Text = f_GetOfficer(il_ExtNum, 1)
	If il_ExtNum < 0 then sle_Extnum.Enabled = False
	mle_Text.Text = ls_Text
	mle_note.Text = ls_Note
	mle_unote.Text = ls_UNote
	mle_reply.Text = ls_Reply
	mle_major.Text = ls_Major
	mle_minor.Text = ls_Minor
	mle_majornote.Text = ls_MajorNote
	mle_minornote.Text = ls_MinorNote
	st_Att.Text = " " + ls_AttName
	If IsNull(ls_AttName) then cb_Delatt.Enabled = False
	If li_Active = 0 then cbx_Disable.Checked = True
 
	If li_Req = 0 then rb_Info.Checked = True
	If li_Req = 1 then rb_Stat.Checked = True
	If li_Req = 2 then rb_Rec.Checked = True
	If li_Req = 3 then rb_Des.Checked = True
	If li_Req = 4 then rb_Non.Checked = True
	
	ii_Risk = li_Risk
	ii_RiskRating = li_RiskRating
	ddlb_risk.Selectitem(li_Risk + 1)
	ddlb_riskrating.Selectitem(li_RiskRating)
	If li_Type < 3 then
		rb_Info.Enabled = False
		rb_Stat.Enabled = False
		rb_Rec.Enabled = False
		rb_Des.Enabled = False
		rb_Non.Enabled = False
		rb_Na.Enabled = False
		cbx_Disable.Enabled = False
	End If	
Else
	ii_EditMode = 0
	ii_Risk = 0
	ii_RiskRating = 1
	li_Type = g_obj.Level + 1
	if li_Type = 5 then li_Type = 4
	cb_addatt.Enabled = False  
	cb_delatt.Enabled = False
	cbx_Disable.Enabled = False
	Choose case g_obj.Level
		Case 0     // New Chapter
			rb_Des.Enabled = False
			rb_non.Enabled = False
			rb_rec.Enabled = False
			rb_stat.Enabled = False
			rb_Info.Enabled = False
			rb_stat.Checked = False
			rb_chap.Checked = True
			rb_chap.Enabled = True
			rb_na.Enabled = False
			st_7.Visible = False
			st_10.Visible = False
			ddlb_risk.Visible = False
			ddlb_riskrating.Visible = False
			cb_addtext.Enabled = False
			sle_Extnum.Visible = False
			st_Serial.visible = False
			cb_Ext.Visible = False
		Case 1    //  New Section or Question
			rb_Ques.Checked = True
			rb_Sec.Enabled = True
			rb_Ques.Enabled = True
			ddlb_risk.Selectitem(1)
			ddlb_riskrating.SelectItem(1)
		Case 2    //  New Question
			rb_Ques.Checked = True
			rb_Ques.Enabled = True
			ddlb_risk.Selectitem(1)
			ddlb_riskrating.SelectItem(1)			
		Case else    //  New Sub-question
			rb_Sub.Checked = True
			rb_Sub.Enabled = True
			ddlb_risk.Selectitem(1)
			ddlb_riskrating.SelectItem(1)			
	End Choose
End If
end event

type st_ObjID from statictext within w_itemedit
integer y = 2480
integer width = 658
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 12632256
long backcolor = 67108864
long bordercolor = 12632256
boolean focusrectangle = false
end type

type sle_extnum from singlelineedit within w_itemedit
integer x = 1115
integer y = 560
integer width = 457
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 15
borderstyle borderstyle = stylelowered!
end type

event losefocus;
Long ll_Int

If Len(This.Text) > 6 then This.Text = Left(This.Text, 6)

If IsNumber(This.Text) then ll_Int = Abs(Long(This.Text)) Else ll_Int = 0

If ll_Int = 0 then This.Text = "" Else This.Text = String(ll_Int)

il_ExtNum = ll_Int
end event

type cb_ext from commandbutton within w_itemedit
integer x = 1573
integer y = 560
integer width = 91
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;
g_Obj.NoteID = il_ExtNum

Open(w_ExtInfo)

il_ExtNum = g_Obj.NoteID

sle_ExtNum.Text = f_GetOfficer(il_ExtNum, 1)

If il_ExtNum < 0 then sle_ExtNum.Enabled = False else sle_ExtNum.Enabled = True
end event

type cb_delminornote from picturebutton within w_itemedit
integer x = 2615
integer y = 2144
integer width = 110
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
alignment htextalign = left!
end type

event clicked;
If MessageBox("Confirm Remove", "Are you sure you want to remove the minor prefix note?~n~n(The actual note content will not be deleted)",Question!,YesNo!) = 2 then Return

mle_minornote.Text = ""
il_MinorNoteID = 0
end event

type cb_minornote from picturebutton within w_itemedit
integer x = 2615
integer y = 2048
integer width = 110
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
g_obj.noteid = il_MinorNoteID
g_obj.objtype = 1   

Open(w_guidenotes)

if g_obj.noteid > 0 then 
	mle_Minornote.Text = g_obj.objparent
	il_MinorNoteID = g_obj.noteid
End If
end event

type st_15 from statictext within w_itemedit
integer x = 73
integer y = 2048
integer width = 329
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Minor Prefix Notes:"
boolean focusrectangle = false
end type

type cb_majornote from picturebutton within w_itemedit
integer x = 2615
integer y = 1696
integer width = 110
integer height = 96
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
g_obj.noteid = il_MajorNoteID
g_obj.objtype = 1   

Open(w_guidenotes)

if g_obj.noteid > 0 then 
	mle_Majornote.Text = g_obj.objparent
	il_MajorNoteID = g_obj.noteid
End If
end event

type cb_delmajornote from picturebutton within w_itemedit
integer x = 2615
integer y = 1792
integer width = 110
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
alignment htextalign = left!
end type

event clicked;
If MessageBox("Confirm Remove", "Are you sure you want to remove the major prefix note?~n~n(The actual note content will not be deleted)",Question!,YesNo!) = 2 then Return

mle_majornote.Text = ""
il_MajorNoteID = 0
end event

type cb_delminor from picturebutton within w_itemedit
integer x = 2615
integer y = 1920
integer width = 110
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
alignment htextalign = left!
end type

event clicked;
If MessageBox("Confirm Remove", "Are you sure you want to remove the minor prefix?",Question!,YesNo!) = 2 then Return

mle_minor.Text = ""
il_MinorID = 0
end event

type cb_minor from picturebutton within w_itemedit
integer x = 2505
integer y = 1920
integer width = 110
integer height = 96
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
g_obj.objtype = 2
g_obj.noteid = il_MinorID

Open(w_text)

If g_obj.noteid > 0 then 
	mle_minor.Text = g_obj.objparent
	il_MinorID = g_obj.noteid
End If
end event

type cb_delatt from picturebutton within w_itemedit
integer x = 2615
integer y = 2256
integer width = 110
integer height = 96
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
string disabledname = "Custom009!"
alignment htextalign = left!
end type

event clicked;If MessageBox("Remove Attachment", "You have chosen to remove this attachment. This file will be removed even if you later 'Cancel' other changes.~n~nAre you sure you want to remove this attachment?", Question!, YesNo!) = 2 then Return

SetPointer(HourGlass!)
	
Update VETT_OBJ Set ATTNAME = Null, ATT = Null Where OBJ_ID = :g_Obj.ObjID;

If SQLCA.Sqlcode <> 0 then		
	Messagebox ("DB Error", "Unable to delete attachment.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Rollback;
End If

n_VimsAtt ln_Att
ln_Att = Create n_VimsAtt

ln_Att.of_Connect("")
If ln_Att.of_DeleteAtt("VETT_OBJ", g_Obj.ObjID)<0 then 
	ln_Att.of_Commit(False)
	Rollback;
	Destroy ln_Att
	Messagebox ("DB Error", "Unable to delete attachment.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Return
End If

ln_Att.of_Commit(True)
Commit;

Destroy ln_Att

st_Att.Text = ""
This.Enabled = False

MessageBox("Deleted", "The attachment was successfully deleted.")	

end event

type cb_addatt from picturebutton within w_itemedit
integer x = 2505
integer y = 2256
integer width = 110
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "J:\TramosWS\VIMS\images\Vims\Att.gif"
alignment htextalign = left!
end type

event clicked;String ls_FPath, ls_FileName
Integer li_FileNum
Blob lblob_File
Long ll_FSize
n_VimsAtt ln_Att

SetPointer(HourGlass!)	
	
// Get filename
If GetFileOpenName("Add Attachment", ls_FPath, ls_FileName, "", "All Files (*.*),*.*", "", 16402) < 1 then Return
	
// Open file
li_FileNum = Fileopen( ls_FPath, StreamMode!)
	
If li_FileNum <0 then 
	MessageBox ("File I/O Error", "Could not open the selected file. Please check that the file is accessible and not in use.",Exclamation!)
	Return
End If
	
// Read file into blob
ll_FSize = FileReadEx(li_FileNum, lblob_File)
	
If ll_FSize < 1 then
	FileClose(li_FileNum)
	MessageBox("File I/O Error", "Could not read the selected file.",Exclamation!)
	Return
End If
	
FileClose(li_FileNum)
	
// Save file name
Update VETT_OBJ Set ATTNAME = :ls_FileName Where OBJ_ID = :g_Obj.ObjID ;
	
If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could save file name in database.~n~n" + sqlca.sqlerrtext, Exclamation!)
	Rollback;	
	Return
End If

ln_Att = Create n_VimsAtt

If ln_Att.of_Connect("") < 1 then 
	Rollback;
	Destroy ln_Att
	Messagebox("DB Error", "Could not save file in database.", Exclamation!)
	Return
End If

// Save file	
If ln_Att.of_AddAtt("VETT_OBJ", g_Obj.ObjID, lblob_File, ll_FSize) < 0 then
	ln_Att.of_Commit(False)
	Rollback;
	Destroy ln_Att
	Messagebox("DB Error", "Could not save file in database.", Exclamation!)
	Return
End If

ln_Att.of_Commit(True)
Commit;

Destroy ln_Att

	
st_Att.Text = " " + ls_FileName
cb_delatt.Enabled = True

Messagebox("File Attached", "The selected file was attached successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize, "#,###,##0") + " Bytes~n~nThis file will be retained even if you choose to 'Cancel' other changes. To remove this file, please use the 'X' button.")

end event

type mle_majornote from multilineedit within w_itemedit
integer x = 475
integer y = 1696
integer width = 2139
integer height = 192
integer taborder = 110
integer textsize = -8
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

type st_14 from statictext within w_itemedit
integer x = 73
integer y = 1696
integer width = 311
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Major Prefix Notes:"
boolean focusrectangle = false
end type

type cb_major from picturebutton within w_itemedit
integer x = 2505
integer y = 1568
integer width = 110
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
g_obj.objtype = 2
g_obj.noteid = il_MajorID

Open(w_text)

If g_obj.noteid > 0 then 
	mle_major.Text = g_obj.objparent
	il_MajorID = g_obj.noteid
End If
end event

type cb_delmajor from picturebutton within w_itemedit
integer x = 2615
integer y = 1568
integer width = 110
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
alignment htextalign = left!
end type

event clicked;
If MessageBox("Confirm Remove", "Are you sure you want to remove the major prefix?",Question!,YesNo!) = 2 then Return

mle_major.Text = ""
il_MajorID = 0
end event

type cb_reply from picturebutton within w_itemedit
integer x = 2615
integer y = 1344
integer width = 110
integer height = 96
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
g_obj.noteid = il_ReplyID
g_obj.objtype = 3   // Standard Reply

Open(w_guidenotes)

if g_obj.noteid > 0 then 
	mle_reply.Text = g_obj.objparent
	il_ReplyID = g_obj.noteid
End If
end event

type cb_delreply from picturebutton within w_itemedit
integer x = 2615
integer y = 1440
integer width = 110
integer height = 96
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
alignment htextalign = left!
end type

event clicked;
If MessageBox("Confirm Remove", "Are you sure you want to remove the standard reply?~n~n(The actual note content will not be deleted)",Question!,YesNo!) = 2 then Return

mle_reply.Text = ""
il_ReplyID = 0
end event

type cb_delunote from picturebutton within w_itemedit
integer x = 2615
integer y = 1216
integer width = 110
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
alignment htextalign = left!
end type

event clicked;
If MessageBox("Confirm Remove", "Are you sure you want to remove the user note?~n~n(The actual note content will not be deleted)",Question!,YesNo!) = 2 then Return

mle_unote.Text = ""
il_unoteid = 0
end event

type cb_unote from picturebutton within w_itemedit
integer x = 2615
integer y = 1120
integer width = 110
integer height = 96
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
g_obj.noteid = il_unoteid
g_obj.objtype = 2   // User note

Open(w_guidenotes)

if g_obj.noteid > 0 then 
	mle_unote.Text = g_obj.objparent
	il_unoteid = g_obj.noteid
End If
end event

type cb_gnote from picturebutton within w_itemedit
integer x = 2615
integer y = 896
integer width = 110
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
g_obj.noteid = il_noteid
g_obj.objtype = 1

Open(w_guidenotes)

if g_obj.noteid > 0 then 
	mle_note.Text = g_obj.objparent
	il_noteid = g_obj.noteid
End If
end event

type cb_clear from picturebutton within w_itemedit
integer x = 2615
integer y = 672
integer width = 110
integer height = 96
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
end type

event clicked;
SetPointer(HourGlass!)
If rb_chap.checked then g_obj.objtype = 1
If rb_sec.checked then g_obj.objtype = 2
If rb_ques.checked then g_obj.objtype = 3
If rb_sub.checked then g_obj.objtype = 4

g_obj.noteid = il_textid

Open(w_text)

if g_obj.noteid > 0 then 
	mle_text.Text = g_obj.objparent
	il_Textid = g_obj.noteid
End If
end event

type cb_delgnote from picturebutton within w_itemedit
integer x = 2615
integer y = 992
integer width = 110
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "NotFound!"
alignment htextalign = left!
end type

event clicked;
If MessageBox("Confirm Remove", "Are you sure you want to remove the guidance note?~n~n(The actual note content will not be deleted)",Question!,YesNo!) = 2 then Return

mle_note.Text = ""
il_noteid = 0
end event

type mle_minornote from multilineedit within w_itemedit
integer x = 475
integer y = 2048
integer width = 2139
integer height = 192
integer taborder = 210
integer textsize = -8
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

type mle_minor from multilineedit within w_itemedit
integer x = 475
integer y = 1920
integer width = 2030
integer height = 96
integer taborder = 240
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

type st_13 from statictext within w_itemedit
integer x = 73
integer y = 1936
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Minor Prefix:"
boolean focusrectangle = false
end type

type mle_major from multilineedit within w_itemedit
integer x = 475
integer y = 1568
integer width = 2030
integer height = 96
integer taborder = 90
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

type st_11 from statictext within w_itemedit
integer x = 73
integer y = 1584
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Major Prefix:"
boolean focusrectangle = false
end type

type cbx_disable from checkbox within w_itemedit
integer x = 2432
integer width = 274
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Disabled"
end type

type st_att from statictext within w_itemedit
integer x = 475
integer y = 2272
integer width = 2030
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_12 from statictext within w_itemedit
integer x = 73
integer y = 2272
integer width = 370
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Attachment:"
boolean focusrectangle = false
end type

type rb_info from radiobutton within w_itemedit
integer x = 1499
integer y = 368
integer width = 475
integer height = 64
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Information Only"
end type

type st_serial from statictext within w_itemedit
integer x = 896
integer y = 576
integer width = 215
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ext Info:"
boolean focusrectangle = false
end type

type ddlb_riskrating from dropdownlistbox within w_itemedit
integer x = 2450
integer y = 560
integer width = 274
integer height = 384
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"1","2","3","4","5"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;

ii_RiskRating = Index

Choose Case Index
	Case 1,2
		ddlb_risk.SelectItem(1)
		ii_Risk = 0
	Case 3,4
		ddlb_risk.SelectItem(2)
		ii_Risk = 1
	Case 5
		ddlb_risk.SelectItem(3)
		ii_Risk = 2
End Choose
end event

type st_10 from statictext within w_itemedit
integer x = 2450
integer y = 496
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Risk Rating:"
boolean focusrectangle = false
end type

type cb_addguide from commandbutton within w_itemedit
boolean visible = false
integer x = 2615
integer y = 1088
integer width = 110
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add && Select"
end type

event clicked;String ls_Text
Integer li_Count, li_Type
Long ll_ID
datastore lds_text

ls_Text = Trim(mle_note.Text)

If Len(ls_Text)<10 then 
	MessageBox("Invalid Text", "Please enter a valid guide note for adding and attaching.", Exclamation!)
	Return
End If

Do While (AscA(Right(ls_Text,1)) < 33) and (Len(ls_Text)>5)
	ls_Text = Left(ls_Text, Len(ls_Text)-1)
Loop

If Len(ls_Text)<10 then 
	MessageBox("Invalid Text", "Please enter a valid guide note for adding and attaching.", Exclamation!)
	Return
End If

lds_text = Create Datastore

lds_text.DataObject = "d_sq_tb_guidenotes"
lds_text.SetTransObject(SQLCA)

li_Count = lds_text.InsertRow(0)

ll_ID = 0

If li_Count=1 then
	lds_text.SetItem(1, "note_text", ls_Text)
	lds_text.SetItem(1, "notetype", 1)
	If lds_text.Update() = 1 then
		ll_ID = lds_text.GetItemNumber(1, "notes_id")
		Commit;
	Else
		Rollback;
		MessageBox("DB Error", "Could not update database.",Exclamation!)
	End If
Else
	MessageBox("DW Error", "Could not insert guide note into datawindow.",Exclamation!)
End If

Destroy lds_text

If ll_ID > 0 then
	il_noteid = ll_ID
	Messagebox("Successful", "The guide note was added and selected successfully.")
Else
	Messagebox("Error","No Text_ID returned. Unable to select.",Exclamation!)
End If
end event

type cb_addtext from commandbutton within w_itemedit
boolean visible = false
integer x = 2615
integer y = 752
integer width = 110
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add && Select"
end type

event clicked;String ls_Text
Integer li_Count, li_Type
Long ll_ID
datastore lds_text

ls_Text = Trim(mle_text.Text)

If Len(ls_Text)<4 then 
	MessageBox("Invalid Text", "Please enter valid text note for adding and attaching.", Exclamation!)
	Return
End If

Do While (AscA(Right(ls_Text,1)) < 33) and (Len(ls_Text)>2)
	ls_Text = Left(ls_Text, Len(ls_Text)-1)
Loop

If Len(ls_Text)<4 then 
	MessageBox("Invalid Text", "Please enter valid text note for adding and attaching.", Exclamation!)
	Return
End If

For li_Count = 1 to Len(ls_Text)
	If AscA(Mid(ls_Text, li_Count, 1)) < 32 then
		MessageBox("Invalid Characters", "Invalid characters were found in the text. Please make sure the text string does not contain special characters such as carraige returns or tabs.",Exclamation!)
		Return
	End If
Next

lds_text = Create Datastore

lds_text.DataObject = "d_sq_tb_textlist"
lds_text.SetTransObject(SQLCA)

li_Count = lds_text.InsertRow(0)

ll_ID = 0

If li_Count=1 then
	If rb_ques.Checked then li_Type = 3 else li_Type = 4
	lds_text.SetItem(1, "textdata", ls_Text)
	lds_text.SetItem(1, "texttype", li_Type)
	lds_text.SetItem(1, "tag", "XX")
	If lds_text.Update() = 1 then
		ll_ID = lds_text.GetItemNumber(1, "text_id")
		Commit;
	Else
		Rollback;
		MessageBox("DB Error", "Could not update database.",Exclamation!)
	End If
Else
	MessageBox("DW Error", "Could not insert text into datawindow.",Exclamation!)
End If

Destroy lds_text

If ll_ID > 0 then
	il_Textid = ll_ID
	Messagebox("Successful", "The text was added and selected successfully.")
Else
	Messagebox("Error","No Text_ID returned. Unable to select.",Exclamation!)
End If
end event

type mle_reply from multilineedit within w_itemedit
integer x = 475
integer y = 1344
integer width = 2139
integer height = 192
integer taborder = 140
integer textsize = -8
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

type st_9 from statictext within w_itemedit
integer x = 73
integer y = 1344
integer width = 370
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Standard Reply:"
boolean focusrectangle = false
end type

type mle_unote from multilineedit within w_itemedit
integer x = 475
integer y = 1120
integer width = 2139
integer height = 192
integer taborder = 150
integer textsize = -8
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

type st_8 from statictext within w_itemedit
integer x = 73
integer y = 1120
integer width = 370
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "User Notes:"
boolean focusrectangle = false
end type

type rb_na from radiobutton within w_itemedit
integer x = 1499
integer y = 448
integer width = 475
integer height = 64
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Not Defined"
boolean checked = true
end type

type ddlb_risk from dropdownlistbox within w_itemedit
integer x = 2066
integer y = 560
integer width = 366
integer height = 320
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Low","Medium","High"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Risk = Index - 1

end event

type st_7 from statictext within w_itemedit
integer x = 2066
integer y = 496
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Default Risk:"
boolean focusrectangle = false
end type

type mle_text from multilineedit within w_itemedit
integer x = 475
integer y = 672
integer width = 2139
integer height = 192
integer taborder = 30
integer textsize = -8
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

type mle_note from multilineedit within w_itemedit
integer x = 475
integer y = 896
integer width = 2139
integer height = 192
integer taborder = 120
integer textsize = -8
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

type st_6 from statictext within w_itemedit
integer x = 73
integer y = 896
integer width = 370
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Guidance Notes:"
boolean focusrectangle = false
end type

type rb_sub from radiobutton within w_itemedit
integer x = 2030
integer y = 240
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Sub-Question"
end type

event clicked;
//rb_stat.Enabled = True
//rb_des.Enabled = True
//rb_rec.Enabled = True
//rb_non.Enabled = True
//rb_na.Enabled = True
end event

type rb_ques from radiobutton within w_itemedit
integer x = 1499
integer y = 240
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Question"
end type

event clicked;
rb_stat.Enabled = True
rb_des.Enabled = True
rb_rec.Enabled = True
rb_non.Enabled = True
rb_na.Enabled = True
rb_info.Enabled = True
st_7.Visible = True
ddlb_risk.Visible = True
cb_addtext.Enabled = True
sle_ExtNum.Visible = True
st_Serial.Visible = True
mle_text.Text = ""
il_textid = 0
end event

type rb_sec from radiobutton within w_itemedit
integer x = 969
integer y = 240
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Section"
end type

event clicked;
rb_stat.Enabled = False
rb_des.Enabled = False
rb_rec.Enabled = False
rb_non.Enabled = False
rb_na.Enabled = False
rb_info.Enabled = False
st_7.visible = False
cb_addtext.Enabled = False
ddlb_risk.Visible = False
sle_ExtNum.Visible = False
st_Serial.Visible = False

mle_text.Text = ""
il_textid = 0
end event

type rb_chap from radiobutton within w_itemedit
integer x = 475
integer y = 240
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Chapter"
end type

type st_5 from statictext within w_itemedit
integer x = 73
integer y = 240
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Type:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_itemedit
integer x = 1719
integer y = 2416
integer width = 402
integer height = 96
integer taborder = 190
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
g_obj.Objid = -10
Close(Parent)
end event

type cb_ok from commandbutton within w_itemedit
integer x = 658
integer y = 2416
integer width = 402
integer height = 96
integer taborder = 180
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;Long ll_Num
Integer li_Req, li_ObjType, li_Active

If il_textid = 0 then
	MessageBox("Text Missing", "Text must be selected before saving.",Exclamation!)
	Return
End If

If Abs(ii_RiskRating - (ii_Risk*2)) > 2 then
	If Messagebox("Info", "The Default Risk and Risk Rating specified do not match. Do you want to continue?", Question!, YesNo!) = 2 then Return
End If

If cbx_Disable.Checked then 
	If MessageBox("Confirm Disabled", "Are you sure you want to mark this item as disabled?", Question!, YesNo!) = 2 then Return
	li_Active = 0
Else 
	li_Active = 1 
End If

SetPointer(HourGlass!)
If rb_chap.Checked then li_ObjType = 1
If rb_Sec.Checked then li_ObjType = 2
If rb_Ques.Checked then li_ObjType = 3
If rb_Sub.Checked then li_ObjType = 4

If rb_NA.Checked then SetNull(li_Req)
If rb_Info.Checked then li_Req = 0
If rb_stat.Checked then li_Req = 1
If rb_rec.Checked then li_Req = 2
If rb_des.Checked then li_Req = 3
If rb_non.Checked then li_Req = 4

If li_ObjType < 3 then li_Req = 0

ll_Num = Integer(em_num.Text )
If sle_ExtNum.Enabled then il_ExtNum=Integer(sle_ExtNum.Text)

If il_NoteID = 0 then SetNull(il_NoteID)
If il_UNoteID = 0 then SetNull(il_UNoteID)
If il_ReplyID = 0 then SetNull(il_ReplyID)
If il_ExtNum = 0 then SetNull(il_ExtNum)
If (il_MajorID = 0) or (IsNull(il_MajorID)) then
	SetNull(il_MajorID)
	SetNull(il_MajorNoteID)
End If
If (il_MinorID = 0) or (IsNull(il_MinorID)) then
	SetNull(il_MinorID)
	SetNull(il_MinorNoteID)
End If

If ii_EditMode = 1 then
	
	Update VETT_OBJ Set OBJTEXT = :il_TextID, REQTYPE = :li_Req, OBJNUM = :ll_Num, OBJNOTE = :il_NoteID, USERNOTE = :il_UNoteID, AUTOREPLY = :il_ReplyID, DEFRISK = :ii_Risk, RISKRATING = :ii_RiskRating, EXTNUM = :il_ExtNum, ACTIVE = :li_Active, SECTMAIN = :il_Majorid, SECTHEAD = :il_Minorid, SECTMAINNOTE = :il_MajorNoteID, SECTHEADNOTE = :il_MinorNoteID Where OBJ_ID = :g_Obj.Objid ;

	If SQLCA.SQLCode <> 0 then
		MessageBox("DB Error", SQLCA.SQLerrtext, Exclamation!)
		Rollback;
		Return
	Else
		Commit;
		g_obj.ObjType = li_ObjType
		g_obj.objstring = String(ll_Num) + ". " + mle_Text.Text
		g_obj.Reqtype = li_Req
	End If	
	Close(Parent)	
Else
	
	Insert VETT_OBJ (IM_ID, OBJTYPE, OBJTEXT, PARENT, REQTYPE, OBJNUM, OBJNOTE, USERNOTE, AUTOREPLY, DEFRISK, RISKRATING, EXTNUM) Values (:g_obj.Inspmodel, :li_ObjType, :il_TextID, :g_obj.Objid, :li_Req, :ll_Num, :il_NoteID, :il_UNoteID, :il_ReplyID, :ii_Risk, :ii_RiskRating, :il_ExtNum);
	
	If SQLCA.SQLCode <> 0 then
		MessageBox("DB Error", SQLCA.SQLerrtext, Exclamation!)
		Rollback;
		Return
	Else
		Commit;
		
		Select OBJ_ID into :g_obj.ObjID  from VETT_OBJ Where IM_ID = :g_obj.Inspmodel and OBJTYPE = :li_ObjType and PARENT = :g_Obj.ObjID and OBJNUM = :ll_Num;
		
		If SQLCA.SQLCode <> 0 then 
			MessageBox("DB Error", "Save successful. Identity not returned.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
			g_obj.Objid = -10
			Rollback;
		Else
			Commit;
			g_obj.ObjType = li_ObjType			
			g_obj.objstring = String(ll_Num) + ". " + mle_text.Text
			g_obj.Reqtype = li_Req
		End If
		Close(Parent) 
	End If
End If

end event

type st_parent from statictext within w_itemedit
integer x = 475
integer y = 80
integer width = 2249
integer height = 128
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parent"
boolean focusrectangle = false
end type

type st_4 from statictext within w_itemedit
integer x = 73
integer y = 80
integer width = 265
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Belongs To:"
boolean focusrectangle = false
end type

type rb_non from radiobutton within w_itemedit
integer x = 969
integer y = 448
integer width = 384
integer height = 64
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Non-scoring"
end type

type rb_des from radiobutton within w_itemedit
integer x = 475
integer y = 448
integer width = 329
integer height = 64
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desirable"
end type

type rb_rec from radiobutton within w_itemedit
integer x = 969
integer y = 368
integer width = 439
integer height = 64
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Recommended"
end type

type rb_stat from radiobutton within w_itemedit
integer x = 475
integer y = 368
integer width = 347
integer height = 64
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Statutory"
end type

type st_3 from statictext within w_itemedit
integer x = 73
integer y = 368
integer width = 306
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Requirement:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_itemedit
integer x = 73
integer y = 672
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Text:"
boolean focusrectangle = false
end type

type em_num from editmask within w_itemedit
integer x = 475
integer y = 560
integer width = 347
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "1"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##0"
boolean spin = true
string minmax = "1~~1000"
end type

type st_1 from statictext within w_itemedit
integer x = 73
integer y = 576
integer width = 256
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Number:"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_itemedit
boolean visible = false
integer x = 366
integer y = 192
integer width = 2121
integer height = 144
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_itemedit
integer x = 18
integer width = 2743
integer height = 2384
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

