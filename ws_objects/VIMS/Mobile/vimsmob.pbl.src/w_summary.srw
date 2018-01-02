$PBExportHeader$w_summary.srw
forward
global type w_summary from window
end type
type p_15 from picture within w_summary
end type
type p_14 from picture within w_summary
end type
type p_13 from picture within w_summary
end type
type p_12 from picture within w_summary
end type
type p_11 from picture within w_summary
end type
type st_4 from statictext within w_summary
end type
type st_2 from statictext within w_summary
end type
type p_5 from picture within w_summary
end type
type p_4 from picture within w_summary
end type
type p_3 from picture within w_summary
end type
type p_2 from picture within w_summary
end type
type p_1 from picture within w_summary
end type
type p_g5 from picture within w_summary
end type
type p_g4 from picture within w_summary
end type
type p_g3 from picture within w_summary
end type
type p_g2 from picture within w_summary
end type
type p_g1 from picture within w_summary
end type
type st_stars from statictext within w_summary
end type
type st_1 from statictext within w_summary
end type
type dw_sect from datawindow within w_summary
end type
type cb_ok from commandbutton within w_summary
end type
type dw_overall from datawindow within w_summary
end type
type gb_2 from groupbox within w_summary
end type
type st_nostar from statictext within w_summary
end type
type gb_1 from groupbox within w_summary
end type
type p_s1 from picture within w_summary
end type
type p_s2 from picture within w_summary
end type
type p_s3 from picture within w_summary
end type
end forward

global type w_summary from window
integer width = 3328
integer height = 2560
boolean titlebar = true
string title = "Inspection Summary"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
p_15 p_15
p_14 p_14
p_13 p_13
p_12 p_12
p_11 p_11
st_4 st_4
st_2 st_2
p_5 p_5
p_4 p_4
p_3 p_3
p_2 p_2
p_1 p_1
p_g5 p_g5
p_g4 p_g4
p_g3 p_g3
p_g2 p_g2
p_g1 p_g1
st_stars st_stars
st_1 st_1
dw_sect dw_sect
cb_ok cb_ok
dw_overall dw_overall
gb_2 gb_2
st_nostar st_nostar
gb_1 gb_1
p_s1 p_s1
p_s2 p_s2
p_s3 p_s3
end type
global w_summary w_summary

type variables

Integer ii_InspMode
end variables

forward prototypes
public subroutine wf_calcstars (integer ai_nullstars, decimal ad_rating)
end prototypes

public subroutine wf_calcstars (integer ai_nullstars, decimal ad_rating);// This function displays the correct numbers of stars for the overall summary
// including 1/4th, half or 3/4ths of a star.

// Some are still null or rating is not possible
If ai_NullStars > 0 or ad_rating = 0.0 then	
	st_Nostar.Visible = True
	p_g1.visible = False
	p_g2.visible = False
	p_g3.visible = False
	p_g4.visible = False
	p_g5.visible = False
	p_s1.visible = False
	p_s2.visible = False
	p_s3.visible = False
	st_Stars.Visible = False		
	Return
End If

String ls_Star = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
String ls_Empty = "J:\TramosWS\VIMS\images\VIMS\emptystar.png"

This.SetRedraw(False)

// Show all full stars
p_g1.visible = True
p_g2.visible = True
p_g3.visible = True
p_g4.visible = True
p_g5.visible = True
st_NoStar.Visible = False

// Hide partial stars
p_s1.visible = False
p_s2.visible = False
p_s3.visible = False


Integer li_Rating
li_Rating = Round(ad_Rating * 4, 0)   // Rounded rating varies from 4 to 20  (For 1 to 5 stars)
st_Stars.Visible = True
st_Stars.Text = " ( " + String(li_Rating / 4) + " star"
If li_Rating > 4 then st_Stars.Text += "s )" else st_Stars.Text += " )"

p_g1.Visible = True   // First star is always visible (as mininum rating is 1 star)

If li_Rating = 4 then  // Lowest rating (1 star)
	This.SetRedraw(True)
	Return
End If
	
// Show full and empty stars
If li_Rating >= 8 then p_g2.PictureName = ls_Star Else p_g2.PictureName = ls_Empty  
If li_Rating >= 12 then p_g3.PictureName = ls_Star Else p_g3.PictureName = ls_Empty 
If li_Rating >= 16 then p_g4.PictureName = ls_Star Else p_g4.PictureName = ls_Empty 
If li_Rating = 20 then p_g5.PictureName = ls_Star Else p_g5.PictureName = ls_Empty

// Show any partial stars
If Mod(li_Rating, 4) > 0 then  
	Integer li_X
	li_X = p_g1.X + Integer(li_Rating / 4) * p_g1.Width
	Choose Case Mod(li_Rating, 4)
		Case 1
			p_s1.Visible = True
			p_s1.X = li_X
		Case 2
			p_s2.Visible = True
			p_s2.X = li_X
		Case 3
			p_s3.Visible = True
			p_s3.X = li_X			
	End Choose
End If

This.SetRedraw(True)
end subroutine

on w_summary.create
this.p_15=create p_15
this.p_14=create p_14
this.p_13=create p_13
this.p_12=create p_12
this.p_11=create p_11
this.st_4=create st_4
this.st_2=create st_2
this.p_5=create p_5
this.p_4=create p_4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.p_g5=create p_g5
this.p_g4=create p_g4
this.p_g3=create p_g3
this.p_g2=create p_g2
this.p_g1=create p_g1
this.st_stars=create st_stars
this.st_1=create st_1
this.dw_sect=create dw_sect
this.cb_ok=create cb_ok
this.dw_overall=create dw_overall
this.gb_2=create gb_2
this.st_nostar=create st_nostar
this.gb_1=create gb_1
this.p_s1=create p_s1
this.p_s2=create p_s2
this.p_s3=create p_s3
this.Control[]={this.p_15,&
this.p_14,&
this.p_13,&
this.p_12,&
this.p_11,&
this.st_4,&
this.st_2,&
this.p_5,&
this.p_4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.p_g5,&
this.p_g4,&
this.p_g3,&
this.p_g2,&
this.p_g1,&
this.st_stars,&
this.st_1,&
this.dw_sect,&
this.cb_ok,&
this.dw_overall,&
this.gb_2,&
this.st_nostar,&
this.gb_1,&
this.p_s1,&
this.p_s2,&
this.p_s3}
end on

on w_summary.destroy
destroy(this.p_15)
destroy(this.p_14)
destroy(this.p_13)
destroy(this.p_12)
destroy(this.p_11)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.p_5)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_g5)
destroy(this.p_g4)
destroy(this.p_g3)
destroy(this.p_g2)
destroy(this.p_g1)
destroy(this.st_stars)
destroy(this.st_1)
destroy(this.dw_sect)
destroy(this.cb_ok)
destroy(this.dw_overall)
destroy(this.gb_2)
destroy(this.st_nostar)
destroy(this.gb_1)
destroy(this.p_s1)
destroy(this.p_s2)
destroy(this.p_s3)
end on

event open;Integer li_Rows, li_Loop
DataStore lds_smtypes

/* 

Following values populated by calling window:

g_Obj.InspID - Holds the inspection ID
g_Obj.ParamInt - Holds the inspection access level

*/

f_Write2Log("w_Summary Open")

ii_InspMode = g_Obj.ParamInt

dw_Overall.SetTransObject(SQLCA)
dw_sect.SetTransObject(SQLCA)

dw_Overall.Retrieve(g_Obj.InspID)
li_Rows = dw_Sect.Retrieve(g_Obj.InspID)

// If no rows then
If (li_Rows = 0) and (ii_InspMode > 1) then   // If no rows and new inspection
	lds_smtypes = Create Datastore
	lds_smtypes.DataObject = "d_sq_tb_smtypes"
	lds_smtypes.SetTransObject(SQLCA)
	lds_smtypes.Retrieve( )
	For li_Loop = 1 to lds_smtypes.RowCount()
		li_Rows = dw_Sect.InsertRow(0)
		If li_Rows > 0 then
			dw_Sect.SetItem(li_Rows, "Insp_ID", g_Obj.InspID)
			dw_Sect.SetItem(li_Rows, "AttCount", 0)
			dw_Sect.SetItem(li_Rows, "Smtype_id", lds_smtypes.GetItemNumber(li_Loop, "smtype_id"))
			dw_Sect.SetItem(li_Rows, "sm_name", lds_smtypes.GetItemString(li_Loop, "sm_name"))
			dw_Sect.SetItem(li_Rows, "serial", lds_smtypes.GetItemNumber(li_Loop, "serial"))
		End If
	Next
	Destroy lds_smtypes
	If dw_Sect.Update() <> 1 then 
		Messagebox("DW Error", "DW Update Error. Could not initialize summaries.", Exclamation!)
		f_Write2Log("w_Summary > Could not initialize summaries")
		dw_Sect.Reset()
		st_1.Visible = False
	End If
End If

If ii_InspMode < 2 then  // If summary locked
	dw_overall.Modify("summary.edit.displayonly = true")
	dw_overall.Modify("summary.background.color = 15395562")
	dw_sect.Modify("sm_text.edit.displayonly = true")
	dw_sect.Modify("sm_text.background.color = 15395562")
	dw_sect.Modify("norating.tabsequence = '0'")
	For li_Loop = 1 to 5
		dw_Sect.Modify("p_g" + String(li_Loop) + ".pointer='Arrow!'")
		dw_Sect.Modify("p_s" + String(li_Loop) + ".pointer='Arrow!'")
	Next	
End If

wf_Calcstars(dw_sect.GetItemNumber(1, "nullstars"), dw_sect.GetItemNumber(1, "overallrating"))

end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 3500)
end event

event closequery;Integer li_Rows, li_Loop
String ls_Text

If ii_InspMode > 1 then  // If inspection open
	
	dw_overall.Accepttext( )
	
	ls_Text = dw_Overall.GetItemString(1, "summary")
	If f_CheckInvalid(ls_Text) then
		dw_Overall.SetItem(1, "summary", ls_Text)
		MessageBox("Invalid Characters", "The overall summary contained one or more invalid characters that have been replaced by underscores.~n~nPlease check all underscores and replace as appropriate.")
		dw_Overall.SetFocus()
		Return 1
	End If
	
	dw_Overall.SetItem(1, "summary", Trim(dw_Overall.GetItemString(1, "summary"), True))
		
	If dw_overall.Update( ) <> 1 then
		Messagebox("DW Error", "Could not update overall summary", Exclamation!)
		f_Write2Log("w_Summary > cb_OK: dw_Overall.Update Failed()")
	End If
	
	dw_sect.Accepttext()

	// Check for blanks and invalid characters
	li_Rows = 0
	For li_Loop = 1 to dw_Sect.RowCount()
		ls_Text = Trim(dw_sect.GetItemString(li_Loop, "sm_text"), True)
		If (ls_Text = "") or IsNull(ls_Text) then li_Rows ++
		dw_sect.SetItem(li_Loop, "sm_text", ls_Text)
		If f_CheckInvalid(ls_Text) then
			dw_sect.SetItem(li_Loop, "sm_text", ls_Text)
			dw_Sect.SetRow(li_Loop)
			dw_Sect.ScrollToRow(li_Loop)
			MessageBox("Invalid Characters", "The selected section summary contained one or more invalid characters that have been replaced by underscores.~n~nPlease check and replace all underscores as appropriate.")
			dw_Sect.SetFocus()
			Return 1
		End If
	Next
	
	// Warn if blanks present
	If li_Rows > 0 then MessageBox("Blank Summary Section", "One or more summary sections are empty.~n~nPlease ensure that all summaries are completed before exporting the inspection.")
	
	// Warn if not all rating specified
	If dw_sect.GetItemNumber(1, "Nullstars") > 0 then MessageBox("Star Ratings", "All section summaries must be rated or marked as 'NA'.~n~nPlease complete all sections summaries before exporting the inspection.")

	If dw_Sect.Update( ) <> 1 then
		Messagebox("DW Error", "Could not update section summaries", Exclamation!)
		f_Write2Log("w_Summary > cb_OK: dw_Sect.Update Failed()")
	End If

End If

If dw_Sect.Rowcount( ) = 0 then
	g_Obj.Level = 0   // Red status
Else
	g_Obj.Level = 1   // Yellow status
	If dw_Sect.GetItemNumber(1, "EmptyCount") = 0 and dw_Sect.GetItemNumber(1, "NullStars") = 0 then g_Obj.Level = 2  // Green status
End If

f_Write2Log("w_Summary Close")

end event

type p_15 from picture within w_summary
integer x = 329
integer y = 2400
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
boolean focusrectangle = false
end type

type p_14 from picture within w_summary
integer x = 256
integer y = 2400
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
boolean focusrectangle = false
end type

type p_13 from picture within w_summary
integer x = 183
integer y = 2400
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
boolean focusrectangle = false
end type

type p_12 from picture within w_summary
integer x = 110
integer y = 2400
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
boolean focusrectangle = false
end type

type p_11 from picture within w_summary
integer x = 37
integer y = 2400
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
boolean focusrectangle = false
end type

type st_4 from statictext within w_summary
integer x = 421
integer y = 2400
integer width = 329
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "= Excellent"
boolean focusrectangle = false
end type

type st_2 from statictext within w_summary
integer x = 421
integer y = 2336
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
string text = "= Poor"
boolean focusrectangle = false
end type

type p_5 from picture within w_summary
integer x = 329
integer y = 2336
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\emptystar.png"
boolean focusrectangle = false
end type

type p_4 from picture within w_summary
integer x = 256
integer y = 2336
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\emptystar.png"
boolean focusrectangle = false
end type

type p_3 from picture within w_summary
integer x = 183
integer y = 2336
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\emptystar.png"
boolean focusrectangle = false
end type

type p_2 from picture within w_summary
integer x = 110
integer y = 2336
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\emptystar.png"
boolean focusrectangle = false
end type

type p_1 from picture within w_summary
integer x = 37
integer y = 2336
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
boolean focusrectangle = false
end type

type p_g5 from picture within w_summary
boolean visible = false
integer x = 859
integer y = 16
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_g4 from picture within w_summary
boolean visible = false
integer x = 786
integer y = 16
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_g3 from picture within w_summary
boolean visible = false
integer x = 713
integer y = 16
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_g2 from picture within w_summary
boolean visible = false
integer x = 640
integer y = 16
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_g1 from picture within w_summary
boolean visible = false
integer x = 567
integer y = 16
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\goldstar.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_stars from statictext within w_summary
boolean visible = false
integer x = 933
integer y = 20
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = " ( 3.25 stars )"
boolean focusrectangle = false
end type

type st_1 from statictext within w_summary
integer x = 603
integer y = 552
integer width = 1426
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "( Max 1500 characters per box; Double-click box for larger box )"
boolean focusrectangle = false
end type

type dw_sect from datawindow within w_summary
integer x = 55
integer y = 624
integer width = 3182
integer height = 1664
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_sectsumm"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;
If (row > 0) and (dwo.name = "b_att") then
	g_Obj.ItemID = This.GetItemNumber(Row, "SM_ID")
	g_Obj.Level = 2
	Open(w_attlist)
	This.SetItem(Row, "attcount", g_Obj.ParamLong)
	This.SetRow(Row)
End If
end event

event doubleclicked;
If dwo.Type <> "column" then Return

Yield()

If dwo.tag = "TX" then
	This.Accepttext( )
	If g_Obj.ParamInt > 1 then g_Obj.Level = 1 else g_Obj.Level = 0
	g_Obj.ParamString = This.GetItemString(Row, String(dwo.name))
	Open(w_textedit)
	If Len(g_Obj.ParamString)>1500 then
		g_Obj.ParamString = Left(g_Obj.ParamString, 1500)
		Messagebox("Comment Limit", "The text entered was too long and has been truncated to 1500 characters.")
	End If
	If Not IsNull(g_Obj.ParamString) then This.SetItem(Row, String(dwo.name), g_Obj.ParamString)
End If
end event

event clicked;
If (Row < 1) or (ii_InspMode < 2) then Return

If Left(dwo.name, 2) = "p_" then
	Integer li_NewRating
	
	Choose Case dwo.name
		Case "p_g1", "p_s1"
			li_NewRating = 1
		Case "p_g2", "p_s2"
			li_NewRating = 2
		Case "p_g3", "p_s3"
			li_NewRating = 3
		Case "p_g4", "p_s4"
			li_NewRating = 4
		Case "p_g5", "p_s5"
			li_NewRating = 5
	End Choose
	
	dw_sect.SetItem(row, "norating", 0)
	
	dw_sect.SetItem(row, "Stars", li_NewRating)
	
	wf_Calcstars(dw_sect.GetItemNumber(row, "nullstars"), dw_Sect.GetItemNumber(row, "overallrating"))
	
End If
end event

event itemchanged;
If dwo.name = "norating" then
	If Data = "1" then 
		dw_Sect.SetItem(row, "stars", 0)
	Else
		Integer li_Tmp
		SetNull(li_Tmp)
		dw_Sect.SetItem(row, "stars", li_Tmp)
	End If
	wf_Calcstars(dw_sect.GetItemNumber(row, "nullstars"), dw_Sect.GetItemNumber(row, "overallrating"))
End If
end event

type cb_ok from commandbutton within w_summary
integer x = 1463
integer y = 2352
integer width = 421
integer height = 96
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

type dw_overall from datawindow within w_summary
integer x = 55
integer y = 96
integer width = 3218
integer height = 416
integer taborder = 20
string title = "none"
string dataobject = "d_sq_ff_overallsumm"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_summary
integer x = 18
integer y = 544
integer width = 3273
integer height = 1776
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Section Summaries   "
end type

type st_nostar from statictext within w_summary
integer x = 549
integer y = 20
integer width = 754
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "( Insufficient data for star rating )"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_summary
integer x = 18
integer y = 16
integer width = 3273
integer height = 512
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Overall Summary"
end type

type p_s1 from picture within w_summary
boolean visible = false
integer x = 1408
integer y = 16
integer width = 23
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\star_1.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_s2 from picture within w_summary
boolean visible = false
integer x = 1445
integer y = 16
integer width = 37
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\star_2.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_s3 from picture within w_summary
boolean visible = false
integer x = 1518
integer y = 16
integer width = 50
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "J:\TramosWS\VIMS\images\VIMS\star_3.png"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

