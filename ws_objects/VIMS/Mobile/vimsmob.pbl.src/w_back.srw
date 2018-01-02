$PBExportHeader$w_back.srw
forward
global type w_back from window
end type
type st_test from statictext within w_back
end type
type lb_files from listbox within w_back
end type
type st_id from statictext within w_back
end type
type st_valid from statictext within w_back
end type
type st_all from statictext within w_back
end type
type st_hi from statictext within w_back
end type
type st_med from statictext within w_back
end type
type st_low from statictext within w_back
end type
type st_14 from statictext within w_back
end type
type st_13 from statictext within w_back
end type
type st_12 from statictext within w_back
end type
type st_11 from statictext within w_back
end type
type st_10 from statictext within w_back
end type
type st_login from statictext within w_back
end type
type st_new from statictext within w_back
end type
type st_db from statictext within w_back
end type
type st_3 from statictext within w_back
end type
type rr_2 from roundrectangle within w_back
end type
type st_7 from statictext within w_back
end type
type st_insp from statictext within w_back
end type
type st_5 from statictext within w_back
end type
type st_4 from statictext within w_back
end type
type st_built from statictext within w_back
end type
type st_ver from statictext within w_back
end type
type st_1 from statictext within w_back
end type
type rr_1 from roundrectangle within w_back
end type
type ln_1 from line within w_back
end type
type r_low from rectangle within w_back
end type
type r_med from rectangle within w_back
end type
type r_high from rectangle within w_back
end type
type r_all from rectangle within w_back
end type
end forward

global type w_back from window
integer width = 2359
integer height = 1388
boolean enabled = false
boolean border = false
windowtype windowtype = child!
long backcolor = 12639424
string icon = "AppIcon!"
st_test st_test
lb_files lb_files
st_id st_id
st_valid st_valid
st_all st_all
st_hi st_hi
st_med st_med
st_low st_low
st_14 st_14
st_13 st_13
st_12 st_12
st_11 st_11
st_10 st_10
st_login st_login
st_new st_new
st_db st_db
st_3 st_3
rr_2 rr_2
st_7 st_7
st_insp st_insp
st_5 st_5
st_4 st_4
st_built st_built
st_ver st_ver
st_1 st_1
rr_1 rr_1
ln_1 ln_1
r_low r_low
r_med r_med
r_high r_high
r_all r_all
end type
global w_back w_back

forward prototypes
public subroutine wf_calc ()
public subroutine wf_checkincoming ()
public subroutine wf_updatever ()
end prototypes

public subroutine wf_calc ();// This function updates all info on the window

Long ll_Insp, ll_Temp, ll_Max
String ls_Temp

f_Write2Log("w_Back > wf_Calc")

// DB Issue
If f_Config("DBVR", ls_Temp, 0) = 0 then st_DB.Text = "DB Issue: " + ls_Temp

// Number of reviewed inspections
Select Count(INSP_ID) Into :ll_Insp from VETT_INSP Where (COMPLETED = 1);
If SQLCA.SQLCode < 0 then
	Rollback;
	Return
End If
Commit;
st_insp.Text = String(ll_Insp)

// Number of valid obs
Select Count(ANS) Into :ll_Temp from VETT_ITEM Inner Join VETT_INSP On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID Where (DEF = 1) And (COMPLETED = 1);
If SQLCA.SQLCode < 0 then
	Rollback;
	Return
End If
Commit;
st_Valid.Text = String(ll_Temp)

If ll_Insp = 0 then
	st_Low.Text = "NA"
	st_Med.Text = "NA"
	st_Hi.Text = "NA"
	st_All.Text = "NA"
	r_low.Width = 640
	r_med.Width = 640
	r_high.Width = 640
	r_all.Width = 640
	Return
End If

st_all.text = String(ll_Temp/ll_Insp, "0.0")

ll_Max = ll_Temp  // For highest avg

If g_Obj.Login = 0 then  // For vessels only	
	// Number of new comments
	Select Count(*) Into :ll_Temp from VETT_ITEMHIST Where STATUS = 0;
	If SQLCA.SQLCode < 0 then 
		Rollback;
		ll_Temp = 0
	Else
		Commit;
	End If
	
	If ll_Temp = 0 then
		st_New.Text = "No new comments"
		st_New.TextColor = 10789024
	Else
		st_New.Text = String(ll_Temp) + " new comment"
		If ll_Temp > 1 then st_New.Text += "s"
		st_New.TextColor = 192
	End If
End If

// Number of valid low risk obs
Select Count(ANS) Into :ll_Temp from VETT_ITEM Inner Join VETT_INSP On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID Where (DEF = 1) and (RISK = 0) And (COMPLETED = 1);
If SQLCA.SQLCode < 0 then
	Rollback;
	Return
End If
Commit;
st_Low.Text = String(ll_Temp/ll_Insp, "0.0")
If ll_Temp > ll_Max then ll_Max = ll_Temp

// Number of valid med risk obs
Select Count(ANS) Into :ll_Temp from VETT_ITEM Inner Join VETT_INSP On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID Where (DEF = 1) and (RISK = 1) And (COMPLETED = 1);
If SQLCA.SQLCode < 0 then
	Rollback;
	Return
End If
Commit;
st_Med.Text = String(ll_Temp/ll_Insp, "0.0")
If ll_Temp > ll_Max then ll_Max = ll_Temp

// Number of valid high risk obs
Select Count(ANS) Into :ll_Temp from VETT_ITEM Inner Join VETT_INSP On VETT_ITEM.INSP_ID = VETT_INSP.INSP_ID Where (DEF = 1) and (RISK = 2) And (COMPLETED = 1);
If SQLCA.SQLCode < 0 then
	Rollback;
	Return
End If

Commit;

st_Hi.Text = String(ll_Temp/ll_Insp, "0.0")
If ll_Temp > ll_Max then ll_Max = ll_Temp

r_all.Visible = True
r_High.Visible = True
r_Med.Visible = True
r_Low.Visible = True

ll_Max = Ceiling(ll_Max / ll_Insp)  // Int of highest avg

ll_Max = 3 * Ceiling(ll_Max / 3)  // Set to next interval of 3

If ll_Max < 10 then ll_Max = 10  // Use 10 obs as minimum scale

r_low.Width = (Dec(st_low.Text)/ll_Max) * 640
r_med.Width = (Dec(st_med.Text)/ll_Max) * 640
r_high.Width = (Dec(st_hi.Text)/ll_Max) * 640
r_all.Width = (Dec(st_all.Text)/ll_Max) * 640


end subroutine

public subroutine wf_checkincoming ();// This function executes under a timer and checks for any incoming inspection packages.
Integer li_Count 

f_Write2Log("wf_CheckIncoming()")

// Check for comm folder. If not present, exit
If Not DirectoryExists(g_DB.is_Import) then 
	f_Write2Log("Import folder not found: " + g_DB.is_Import)
	Return
End If

f_Write2Log("Looking for vims_*.vpkg in " + g_DB.is_Import)

// Get the files
lb_Files.DirList(g_DB.is_Import + "vims_*.vpkg", 0)

// Change folder back to app folder
ChangeDirectory(g_Obj.AppFolder)

f_Write2Log("Found: " + String(lb_Files.TotalItems()))

// If incoming found, call w_Import
If lb_Files.TotalItems()>0 then
	g_Obj.ParamString = g_DB.is_Import
	Open(w_Import)
End If


end subroutine

public subroutine wf_updatever ();
If g_Obj.Install = 0 then   // Vessel Installation 
	st_ID.Text = g_Obj.Vesselname + ", IMO: " + String(g_Obj.VesselIMO)
Else
	st_ID.Text = g_Obj.UserID + " - " + g_Obj.InspFirstName + " " + g_Obj.InspLastName
End If
end subroutine

on w_back.create
this.st_test=create st_test
this.lb_files=create lb_files
this.st_id=create st_id
this.st_valid=create st_valid
this.st_all=create st_all
this.st_hi=create st_hi
this.st_med=create st_med
this.st_low=create st_low
this.st_14=create st_14
this.st_13=create st_13
this.st_12=create st_12
this.st_11=create st_11
this.st_10=create st_10
this.st_login=create st_login
this.st_new=create st_new
this.st_db=create st_db
this.st_3=create st_3
this.rr_2=create rr_2
this.st_7=create st_7
this.st_insp=create st_insp
this.st_5=create st_5
this.st_4=create st_4
this.st_built=create st_built
this.st_ver=create st_ver
this.st_1=create st_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.r_low=create r_low
this.r_med=create r_med
this.r_high=create r_high
this.r_all=create r_all
this.Control[]={this.st_test,&
this.lb_files,&
this.st_id,&
this.st_valid,&
this.st_all,&
this.st_hi,&
this.st_med,&
this.st_low,&
this.st_14,&
this.st_13,&
this.st_12,&
this.st_11,&
this.st_10,&
this.st_login,&
this.st_new,&
this.st_db,&
this.st_3,&
this.rr_2,&
this.st_7,&
this.st_insp,&
this.st_5,&
this.st_4,&
this.st_built,&
this.st_ver,&
this.st_1,&
this.rr_1,&
this.ln_1,&
this.r_low,&
this.r_med,&
this.r_high,&
this.r_all}
end on

on w_back.destroy
destroy(this.st_test)
destroy(this.lb_files)
destroy(this.st_id)
destroy(this.st_valid)
destroy(this.st_all)
destroy(this.st_hi)
destroy(this.st_med)
destroy(this.st_low)
destroy(this.st_14)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_login)
destroy(this.st_new)
destroy(this.st_db)
destroy(this.st_3)
destroy(this.rr_2)
destroy(this.st_7)
destroy(this.st_insp)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_built)
destroy(this.st_ver)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.r_low)
destroy(this.r_med)
destroy(this.r_high)
destroy(this.r_all)
end on

event open;
f_Write2Log("w_Back Open")

wf_UpdateVer()

If g_Obj.Login = 0 then
	st_Login.Text = 'General Login (Read-Only)'
ElseIf g_Obj.Login = 1 then
	st_Login.Text = 'Vessel Management Login'
Else
	st_Login.Text = 'Inspector Login'
End If

st_Ver.Text = 'Ver: ' + String(Integer(Left(g_Obj.Appver,2))) + "." + String(Integer(Mid(g_Obj.Appver,4,2))) + "." + String(Integer(Right(g_Obj.Appver,2)))
st_Built.Text = 'Built: ' + g_Obj.Appbuilt

wf_calc( )

r_high.Fillcolor = 9479632
r_med.Fillcolor = 9496016
r_low.Fillcolor = 9495952
r_all.Fillcolor = 13673872

If g_TestMode = true Then st_Test.Visible = true

// If vessel installation and no inspection open and not disabled then check for incoming inspections
If Not IsValid(w_InspDetail) and g_Obj.Install = 0 and m_mobile.m_Inspections.m_Browser.Enabled = True then Post wf_CheckIncoming( )

end event

type st_test from statictext within w_back
boolean visible = false
integer x = 91
integer y = 432
integer width = 2176
integer height = 144
integer textsize = -24
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 12639424
string text = "This is a Test Version"
alignment alignment = center!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type lb_files from listbox within w_back
boolean visible = false
integer x = 110
integer y = 224
integer width = 384
integer height = 128
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
end type

type st_id from statictext within w_back
integer x = 110
integer y = 288
integer width = 2158
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_valid from statictext within w_back
integer x = 1335
integer y = 704
integer width = 475
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "<Err>"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_all from statictext within w_back
integer x = 1701
integer y = 1136
integer width = 137
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 10789024
long backcolor = 12639424
string text = "<Err>"
boolean focusrectangle = false
end type

type st_hi from statictext within w_back
integer x = 1701
integer y = 1056
integer width = 137
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "<Err>"
boolean focusrectangle = false
end type

type st_med from statictext within w_back
integer x = 1701
integer y = 992
integer width = 137
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "<Err>"
boolean focusrectangle = false
end type

type st_low from statictext within w_back
integer x = 1701
integer y = 928
integer width = 137
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "<Err>"
boolean focusrectangle = false
end type

type st_14 from statictext within w_back
integer x = 658
integer y = 1136
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 10789024
long backcolor = 12639424
string text = "Overall:"
boolean focusrectangle = false
end type

type st_13 from statictext within w_back
integer x = 658
integer y = 1056
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "High Risk:"
boolean focusrectangle = false
end type

type st_12 from statictext within w_back
integer x = 658
integer y = 992
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Medium Risk:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_back
integer x = 658
integer y = 928
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Low Risk:"
boolean focusrectangle = false
end type

type st_10 from statictext within w_back
integer x = 549
integer y = 848
integer width = 750
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Average Valid Obs/Insp:"
boolean focusrectangle = false
end type

type st_login from statictext within w_back
integer x = 731
integer y = 368
integer width = 896
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 10789024
long backcolor = 12639424
string text = "Vessel Management Login"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_new from statictext within w_back
integer x = 91
integer y = 64
integer width = 517
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "No new comments"
boolean focusrectangle = false
end type

type st_db from statictext within w_back
integer x = 1920
integer y = 1280
integer width = 357
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "DB Issue: <NA>"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_back
integer x = 91
integer y = 128
integer width = 2176
integer height = 144
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
boolean underline = true
long textcolor = 10789024
long backcolor = 12639424
string text = "VIMS  -  Mobile"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_back
long linecolor = 10789024
integer linethickness = 7
long fillcolor = 12639424
integer x = 37
integer y = 32
integer width = 2286
integer height = 1328
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_7 from statictext within w_back
integer x = 768
integer y = 1280
integer width = 805
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "M a e r s k   T a n k e r s"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_insp from statictext within w_back
integer x = 1591
integer y = 608
integer width = 219
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "<Err>"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_back
integer x = 549
integer y = 704
integer width = 768
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Valid Observations:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_back
integer x = 549
integer y = 608
integer width = 823
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Reviewed Inspections:"
boolean focusrectangle = false
end type

type st_built from statictext within w_back
integer x = 1810
integer y = 64
integer width = 466
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Built: XXXX"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ver from statictext within w_back
integer x = 91
integer y = 1280
integer width = 357
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Version x.x.x"
boolean focusrectangle = false
end type

type st_1 from statictext within w_back
integer x = 512
integer y = 64
integer width = 1335
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 12639424
string text = "Vetting and Inspection Management System"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_back
long linecolor = 10789024
integer linethickness = 7
long fillcolor = 12639424
integer x = 55
integer y = 48
integer width = 2249
integer height = 1296
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_back
long linecolor = 10789024
integer linethickness = 4
integer beginx = 512
integer beginy = 816
integer endx = 1865
integer endy = 816
end type

type r_low from rectangle within w_back
long linecolor = 10789024
integer linethickness = 4
long fillcolor = 65280
integer x = 1042
integer y = 928
integer width = 640
integer height = 48
end type

type r_med from rectangle within w_back
long linecolor = 10789024
integer linethickness = 4
long fillcolor = 65535
integer x = 1042
integer y = 992
integer width = 640
integer height = 48
end type

type r_high from rectangle within w_back
long linecolor = 10789024
integer linethickness = 4
long fillcolor = 255
integer x = 1042
integer y = 1056
integer width = 640
integer height = 48
end type

type r_all from rectangle within w_back
long linecolor = 10789024
integer linethickness = 4
long fillcolor = 16711680
integer x = 1042
integer y = 1136
integer width = 640
integer height = 48
end type

