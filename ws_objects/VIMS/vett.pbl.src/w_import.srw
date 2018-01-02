$PBExportHeader$w_import.srw
forward
global type w_import from window
end type
type cb_close from commandbutton within w_import
end type
type lb_files from listbox within w_import
end type
type st_msg from statictext within w_import
end type
type st_title from statictext within w_import
end type
type gb_1 from groupbox within w_import
end type
end forward

global type w_import from window
integer width = 2286
integer height = 588
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
string pointer = "Arrow!"
boolean center = true
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = centeranimation!
cb_close cb_close
lb_files lb_files
st_msg st_msg
st_title st_title
gb_1 gb_1
end type
global w_import w_import

type variables

String is_Path

end variables

forward prototypes
public subroutine wf_importinspections ()
end prototypes

public subroutine wf_importinspections ();n_inspio lnvo_insp
Integer li_Total, li_Count, li_MsgType
Long ll_InspID
String ls_CurDir, ls_id, ls_Ver, ls_Info
Boolean lbool_New

// Exit if developer on production
If g_Obj.Developer and Upper(SQLCA.Servername) = guo_Global.is_ProductionServer then 
	Close(This)
	Return
End If

// If no temp folder
If g_Obj.TempFolder = "" then
	st_msg.Text = "No temp folder available"
	cb_Close.Visible = True
	Return
End If

li_Total = lb_Files.TotalItems()   // total number of incoming files

If li_Total = 0 then
	st_msg.Text = "No packages found"
	cb_Close.Visible = True
	Return
End If

ls_CurDir = g_Obj.TempFolder   // get app folder

For li_Count = 1 to li_Total  // loop thru files
	st_msg.Text = "Importing " + lb_Files.Text(li_Count)
	f_Write2Log(st_Msg.Text)
	
   // Check for communication package or ping response	
	If (Upper(Left(lb_Files.Text(li_Count),7)) = "COMMPKG") or (Upper(Left(lb_Files.Text(li_Count),8)) = "PINGRESP") then
		guo_Global.of_ProcessCommPackage(is_Path + lb_Files.Text(li_Count))
	Else		  // otherwise handle inspection
		ll_InspID = lnvo_insp.of_ImportIntoOffice(is_Path, lb_Files.Text(li_Count), ls_CurDir, li_MsgType, ls_ID, ls_Ver, ls_Info, lbool_New)
		If ll_InspID > 0 then
			guo_Global.of_AddInspHist(ll_InspID, 1, "")
			guo_Global.of_AddSysMsg(li_MsgType, ls_ID, ls_Ver, ls_Info, ll_InspID, "")
			If lbool_New then 
				guo_Global.of_SendMail2Tech(ll_InspID)
				guo_Global.of_NotifyManagement(ll_InspID, 0, ls_Info)
			End If
			f_Write2Log("Import Success. InspID: " + String(ll_InspID))
		Else
			guo_Global.of_AddSysMsg(1, ls_ID, ls_Ver, ls_Info, 0, "")
			f_Write2Log("Import Failed: " + ls_Info)
		End If
	End If
Next

Close(This)
end subroutine

on w_import.create
this.cb_close=create cb_close
this.lb_files=create lb_files
this.st_msg=create st_msg
this.st_title=create st_title
this.gb_1=create gb_1
this.Control[]={this.cb_close,&
this.lb_files,&
this.st_msg,&
this.st_title,&
this.gb_1}
end on

on w_import.destroy
destroy(this.cb_close)
destroy(this.lb_files)
destroy(this.st_msg)
destroy(this.st_title)
destroy(this.gb_1)
end on

event open;String ls_CurFolder

is_Path = Message.StringParm

lb_files.Dirlist(is_path + "*.vpkg", 0)

ChangeDirectory(g_obj.Appfolder)

// Let window open and then call wf_ImportInspections()
Post wf_ImportInspections( )



end event

type cb_close from commandbutton within w_import
boolean visible = false
integer x = 951
integer y = 432
integer width = 329
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type lb_files from listbox within w_import
boolean visible = false
integer x = 55
integer y = 64
integer width = 366
integer height = 432
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_msg from statictext within w_import
integer x = 73
integer y = 272
integer width = 2121
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Arrow!"
long textcolor = 8421376
long backcolor = 67108864
string text = "Checking for packages..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_import
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
string pointer = "Arrow!"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incoming Package Import"
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
string pointer = "Arrow!"
long textcolor = 33554432
long backcolor = 67108864
end type

