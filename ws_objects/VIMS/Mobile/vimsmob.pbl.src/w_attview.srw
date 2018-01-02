$PBExportHeader$w_attview.srw
forward
global type w_attview from window
end type
type st_file from statictext within w_attview
end type
type st_msg from statictext within w_attview
end type
type cb_prev from commandbutton within w_attview
end type
type cb_next from commandbutton within w_attview
end type
type cb_close from commandbutton within w_attview
end type
type p_pic from picture within w_attview
end type
type st_back from statictext within w_attview
end type
end forward

global type w_attview from window
integer width = 4197
integer height = 2880
boolean titlebar = true
string title = "Photo View"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_file st_file
st_msg st_msg
cb_prev cb_prev
cb_next cb_next
cb_close cb_close
p_pic p_pic
st_back st_back
end type
global w_attview w_attview

type variables

ustruct_Att AttStr
end variables

forward prototypes
public subroutine wf_loadpicture ()
end prototypes

public subroutine wf_loadpicture ();
Blob lbl_Data
String ls_File
Integer li_temp
n_VimsAtt ln_Att

ln_Att = Create n_VimsAtt

If ln_Att.of_GetAtt(AttStr.IDList[AttStr.Index], lbl_Data) < 1 then 
	Destroy ln_Att
	Messagebox("DB Error", "Unable to retrieve attachment from database!", Exclamation!)
	Return		
End If

Destroy ln_Att

// Set nav buttons and title
cb_prev.Enabled = (AttStr.Index > 1 )
cb_Next.Enabled = (AttStr.Index < UpperBound(AttStr.IDList))
This.Title = "Photo View - " + AttStr.NameList[AttStr.Index] + "  (" + String(AttStr.Index) + " of " + String(Upperbound(AttStr.IDList)) + ")"
	
// Get file extension
ls_File = Upper(right(AttStr.NameList[AttStr.Index], 3))

SetRedraw(False)

// Check for file type
If ls_File = "JPG" or ls_File = "BMP" or ls_File = "GIF" or ls_File = "WMF" then 
	If p_pic.Setpicture(lbl_Data) < 1 then   	// Try to load picture
		st_msg.Visible = True 
		st_File.Text = AttStr.NameList[AttStr.Index]
		st_File.Visible = True
		p_pic.Visible = False
	Else 
		st_msg.Visible = False
		st_File.Visible = False
		p_pic.x = (This.Width - p_pic.Width) / 2
		p_pic.y = (st_Back.Height - p_Pic.Height) / 2
		p_pic.Visible = True
	End If
Else
	st_msg.Visible = True 
	st_File.Text = AttStr.NameList[AttStr.Index]
	st_File.Visible = True
	p_pic.Visible = False
End If	

SetRedraw(True)

end subroutine

on w_attview.create
this.st_file=create st_file
this.st_msg=create st_msg
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.cb_close=create cb_close
this.p_pic=create p_pic
this.st_back=create st_back
this.Control[]={this.st_file,&
this.st_msg,&
this.cb_prev,&
this.cb_next,&
this.cb_close,&
this.p_pic,&
this.st_back}
end on

on w_attview.destroy
destroy(this.st_file)
destroy(this.st_msg)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.cb_close)
destroy(this.p_pic)
destroy(this.st_back)
end on

event open;
AttStr = Message.PowerObjectParm

wf_Loadpicture( )







end event

type st_file from statictext within w_attview
integer x = 37
integer y = 992
integer width = 4114
integer height = 96
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 15780518
string text = "Filename"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_msg from statictext within w_attview
integer x = 1152
integer y = 1216
integer width = 1883
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 15780518
string text = "The attachment could not be opened as a photo"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_prev from commandbutton within w_attview
integer x = 18
integer y = 2672
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "< Previous"
end type

event clicked;
AttStr.Index --

wf_LoadPicture()
end event

type cb_next from commandbutton within w_attview
integer x = 3767
integer y = 2672
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "   Next    >"
end type

event clicked;
AttStr.Index ++

wf_LoadPicture()

end event

type cb_close from commandbutton within w_attview
integer x = 1829
integer y = 2672
integer width = 530
integer height = 112
integer taborder = 20
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

type p_pic from picture within w_attview
integer x = 183
integer y = 96
integer width = 3200
integer height = 2300
boolean originalsize = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_back from statictext within w_attview
integer x = 18
integer y = 16
integer width = 4151
integer height = 2640
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 12632256
long backcolor = 15780518
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

