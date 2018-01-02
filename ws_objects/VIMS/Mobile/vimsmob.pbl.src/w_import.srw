$PBExportHeader$w_import.srw
forward
global type w_import from window
end type
type lb_files from listbox within w_import
end type
type st_msg from statictext within w_import
end type
type st_1 from statictext within w_import
end type
type gb_1 from groupbox within w_import
end type
end forward

global type w_import from window
integer width = 2286
integer height = 580
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
string pointer = "HourGlass!"
boolean center = true
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = centeranimation!
integer animationtime = 100
lb_files lb_files
st_msg st_msg
st_1 st_1
gb_1 gb_1
end type
global w_import w_import

type variables

String is_Folder
end variables

forward prototypes
public subroutine wf_importinspections ()
end prototypes

public subroutine wf_importinspections ();n_inspio lnvo_insp
Integer li_Total, li_Count, li_Temp
String ls_Result

// Check if is_Folder is a folder (when importing from comm folder)
If Right(is_Folder,1)="\" then

	// Get files in folder
	lb_Files.DirList(is_Folder + "vims_*.vpkg", 0)

	// Change folder back to app folder
	ChangeDirectory(g_Obj.AppFolder)
	
	// Import files
	li_Total = lb_Files.TotalItems()	
	For li_Count = 1 to li_Total
		st_msg.Text = "Importing " + lb_Files.Text(li_Count)
		f_Write2Log(st_Msg.Text)
		If Upper(Left(lb_Files.Text(li_Count), 8)) = "VIMS_DB_" then   // This is a database issue
			g_Obj.Paramstring = is_Folder + lb_Files.Text(li_Count)
			f_Write2Log("DB Update found: " + lb_Files.Text(li_Count))
			Open(w_db)			
			FileDelete(is_Folder + lb_Files.Text(li_Count))
		Else
			lnvo_insp.of_ImportIntoMobile(is_Folder + lb_Files.Text(li_Count), g_Obj.Install + 1, g_Obj.VesselIMO, g_Obj.TempFolder, ls_Result)
			li_Temp = Pos(ls_Result, ";")  // find split pos
			f_CreateCommPackage(Left(ls_Result, li_Temp - 1), Right(ls_Result, Len(ls_Result) - li_Temp))
			f_Write2Log("f_CreateCommPackage(" + ls_Result + ")")
		End If
	Next
Else   // otherwise import single file (used when importing manually)
	st_msg.Text = "Importing " + is_Folder
	f_Write2Log(st_Msg.Text)
	lnvo_insp.of_ImportIntoMobile(is_Folder, g_Obj.Install + 1, g_Obj.VesselIMO, g_Obj.TempFolder, ls_Result)
	li_Temp = Pos(ls_Result, ";")  // find split pos
	f_CreateCommPackage(Left(ls_Result, li_Temp - 1), Right(ls_Result, Len(ls_Result) - li_Temp))
   f_Write2Log("f_CreateCommPackage(" + ls_Result + ")")
End If

w_Back.wf_Calc()

g_Obj.Level = 1

// If installation is Inspector, reset all comments
If g_Obj.Install = 2 then
	Update VETT_ITEMHIST Set STATUS = 1 Where STATUS<1;
	Commit;
End If

Close(This)
end subroutine

on w_import.create
this.lb_files=create lb_files
this.st_msg=create st_msg
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.lb_files,&
this.st_msg,&
this.st_1,&
this.gb_1}
end on

on w_import.destroy
destroy(this.lb_files)
destroy(this.st_msg)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
is_Folder = g_Obj.ParamString

// Let window open and then call wf_ImportInspections()
Post wf_ImportInspections( )



end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1700)
end event

type lb_files from listbox within w_import
boolean visible = false
integer x = 91
integer y = 80
integer width = 480
integer height = 400
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type st_msg from statictext within w_import
integer x = 73
integer y = 272
integer width = 2121
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HourGlass!"
long textcolor = 8421376
long backcolor = 67108864
string text = "Checking for inspection packages..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_import
integer x = 311
integer y = 80
integer width = 1664
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HourGlass!"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Import"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_import
integer x = 37
integer width = 2194
integer height = 528
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HourGlass!"
long textcolor = 33554432
long backcolor = 67108864
end type

