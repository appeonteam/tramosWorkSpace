$PBExportHeader$w_thumbs.srw
forward
global type w_thumbs from window
end type
type cb_switch from commandbutton within w_thumbs
end type
type ddlb_size from dropdownlistbox within w_thumbs
end type
type st_2 from statictext within w_thumbs
end type
type cb_end from commandbutton within w_thumbs
end type
type cb_inc from commandbutton within w_thumbs
end type
type st_count from statictext within w_thumbs
end type
type cb_dec from commandbutton within w_thumbs
end type
type cb_top from commandbutton within w_thumbs
end type
type st_load from statictext within w_thumbs
end type
type st_box from statictext within w_thumbs
end type
end forward

global type w_thumbs from window
integer width = 4050
integer height = 3216
boolean titlebar = true
string title = "Photo Thumbnail Viewer"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_pictureclick ( integer ai_index )
cb_switch cb_switch
ddlb_size ddlb_size
st_2 st_2
cb_end cb_end
cb_inc cb_inc
st_count st_count
cb_dec cb_dec
cb_top cb_top
st_load st_load
st_box st_box
end type
global w_thumbs w_thumbs

type variables

v_Picture ip_Thumbs[]
StaticText is_Names[]

Long al_InspID
Integer ii_Page, ii_PerPage, ii_CellSize, ii_LastPage
Datastore ids_Att

end variables

forward prototypes
public subroutine wf_loadthumbs ()
end prototypes

event ue_pictureclick(integer ai_index);
uStruct_Att AttStr
Integer li_Loop

// Save info into struct
AttStr.Index = ai_Index
For li_Loop = 1 to ids_Att.RowCount()
	AttStr.IDList[li_Loop] = ids_Att.GetItemNumber(li_Loop, "Att_ID")
	AttStr.NameList[li_Loop] = ids_Att.GetItemString(li_Loop, "filename")
Next

// Open preview window
OpenWithParm(w_attview, AttStr)

end event

public subroutine wf_loadthumbs ();
// This function loads pictures from the database into the picture array and label array

Integer li_From, li_To, li_Loop, li_ThumbCount = 0, li_Index
Long ll_AttID, ll_CurX, ll_CurY, ll_Timer
Blob lblob_Pic
n_VimsAtt ln_Att

st_Count.Text = "Loading..."

SetPointer(HourGlass!)

This.SetRedraw(False)

ln_Att = Create n_VimsAtt

If ln_Att.of_Connect("") < 0 then   // Change this to handle VIMS Mobile when deploying
	Messagebox("DB Error", "An error occurred while trying to retrieve the photos.", Exclamation!)
	Return
End If

// Set initial position
ll_CurX = ii_CellSize / 8 + st_Box.X // Leave 1/8th space of column as padding
ll_CurY = ii_CellSize / 8 + st_Box.Y
li_Loop = (ii_Page - 1) * ii_PerPage + 1
li_Index = 1

Do 
	If li_Index > UpperBound(ip_Thumbs) then  // If index is past array size, then create new
		OpenUserObject(ip_Thumbs[li_Index], "v_Picture" , ll_CurX, ll_CurY)
		OpenUserObject(is_Names[li_Index], "StaticText", ll_CurX, ll_CurY - 60)
		ip_Thumbs[li_Index].Pointer = "HyperLink!"
		is_Names[li_Index].Height = 60
		is_Names[li_Index].BackColor = st_Box.BackColor
		is_Names[li_Index].TextSize = 12		
	Else  // otherwise reposition objects
		ip_Thumbs[li_Index].Move(ll_CurX, ll_CurY)
		is_Names[li_Index].Move(ll_CurX , ll_CurY - 60)		
	End If
	ll_AttID = ids_Att.GetItemNumber(li_Loop, "att_id")  // Get Attachment ID
	If ll_AttID <> ip_Thumbs[li_Index].AttID then // If picture is different, load it
		//S-e-l-e-c-t-b-l-o-b ATTDATA into :lblob_Pic from VETT_ATT Where ATT_ID = :ll_AttID;
		ln_Att.of_GetAtt("VETT_ATT", ll_AttID, lblob_Pic)
		ip_Thumbs[li_Index].Initialize(ll_AttID, li_Loop, ids_Att.GetItemString(li_Loop, "filename"))
		If ip_Thumbs[li_Index].SetPicture(lblob_Pic) = 1 then li_ThumbCount++
		is_Names[li_Index].Text = ids_Att.GetItemString(li_Loop, "filename")
		Commit;
	End If
	// Set size, visibility and text
	ip_Thumbs[li_Index].Resize(ii_CellSize * 3 / 4)
	ip_Thumbs[li_Index].Visible = True	
	is_Names[li_Index].Width = ii_CellSize * 3 / 4
	is_Names[li_Index].Visible = True
	ll_CurX += ii_CellSize
	If ll_CurX > st_Box.X + st_Box.Width then
		ll_CurX = st_Box.X + ii_CellSize / 8
		ll_CurY += ii_CellSize
	End If			
	li_Loop++
	li_Index++
Loop Until (li_Index > ii_PerPage) or (li_Loop > ids_Att.RowCount()) 

Destroy ln_Att

// Hide any extra images
Do While li_Index <= Upperbound(ip_Thumbs)
	ip_Thumbs[li_Index].Visible = False
	is_Names[li_Index].Visible = False
	li_Index++
Loop

If li_ThumbCount = 0 then st_Load.Text = "No displayable images found" Else st_Load.Visible = False

st_Box.SetPosition(ToBottom!)

// Set counter
li_Loop = (ii_Page - 1) * ii_PerPage + 1
li_Index = li_Loop + ii_PerPage - 1
If li_Index > ids_Att.RowCount() then li_Index = ids_Att.RowCount()
st_Count.Text = "Page " + String(ii_Page) + "/" + String(ii_LastPage) + " - Images " + String(li_Loop) + " to " + String(li_Index) + " ( of " + String(ids_Att.RowCount()) + " )"

// Set button
cb_Inc.Enabled = (li_Index < ids_Att.RowCount())
cb_End.Enabled = cb_Inc.Enabled
cb_Dec.Enabled = (ii_Page > 1)
cb_Top.Enabled = cb_Dec.Enabled

This.SetRedraw(True)
	
end subroutine

on w_thumbs.create
this.cb_switch=create cb_switch
this.ddlb_size=create ddlb_size
this.st_2=create st_2
this.cb_end=create cb_end
this.cb_inc=create cb_inc
this.st_count=create st_count
this.cb_dec=create cb_dec
this.cb_top=create cb_top
this.st_load=create st_load
this.st_box=create st_box
this.Control[]={this.cb_switch,&
this.ddlb_size,&
this.st_2,&
this.cb_end,&
this.cb_inc,&
this.st_count,&
this.cb_dec,&
this.cb_top,&
this.st_load,&
this.st_box}
end on

on w_thumbs.destroy
destroy(this.cb_switch)
destroy(this.ddlb_size)
destroy(this.st_2)
destroy(this.cb_end)
destroy(this.cb_inc)
destroy(this.st_count)
destroy(this.cb_dec)
destroy(this.cb_top)
destroy(this.st_load)
destroy(this.st_box)
end on

event open;
// Load all attachments (ID and Name)
al_InspID = Long(Message.DoubleParm)
ids_Att = Create Datastore
ids_Att.DataObject = "d_sq_tb_attnames"
ids_Att.SetTransObject(SQLCA)
If ids_Att.Retrieve(al_InspID) <=0 then 
	st_Load.Text = "No images found"
	cb_dec.Enabled = False
	cb_Inc.Enabled = False
	cb_End.Enabled = False
	cb_Top.Enabled = False
	ddlb_Size.Enabled = False
	st_Count.Text = ""
End If

Commit;

If ddlb_Size.Enabled then
	// Set default size (Medium)
	ddlb_Size.SelectItem(2)
	ddlb_Size.Post event SelectionChanged(2)
End If

end event

type cb_switch from commandbutton within w_thumbs
integer x = 3584
integer y = 16
integer width = 439
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Switch to List"
end type

event clicked;
CloseWithReturn(Parent, 1)
end event

type ddlb_size from dropdownlistbox within w_thumbs
integer x = 2377
integer y = 16
integer width = 590
integer height = 320
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Small (24 per page)","Medium (12 per page)","Large (6 per page)"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
// Set cell size and thumbs per page
// Tiny = 8, Small = 6, Medium = 4, Large = 3
Choose Case Index
	Case 1
		ii_CellSize = st_Box.Width / 6
		ii_PerPage = 24
	Case 2
		ii_CellSize = st_Box.Width / 4
		ii_PerPage = 12
	Case 3
		ii_CellSize = st_Box.Width / 3
		ii_PerPage = 6
End Choose

// Reset page and load
ii_Page = 1
ii_LastPage = Integer((ids_Att.RowCount() - 1) / ii_PerPage) + 1
wf_LoadThumbs( )
end event

type st_2 from statictext within w_thumbs
integer x = 2048
integer y = 32
integer width = 347
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Thumb Size:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_end from commandbutton within w_thumbs
integer x = 1664
integer y = 16
integer width = 146
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">|"
end type

event clicked;
ii_Page = ii_LastPage

wf_LoadThumbs( )
end event

type cb_inc from commandbutton within w_thumbs
integer x = 1518
integer y = 16
integer width = 146
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">"
end type

event clicked;
ii_Page ++

wf_LoadThumbs( )
end event

type st_count from statictext within w_thumbs
integer x = 311
integer y = 16
integer width = 1216
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Loading..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_dec from commandbutton within w_thumbs
integer x = 165
integer y = 16
integer width = 146
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "<"
end type

event clicked;
ii_Page --

wf_LoadThumbs( )
end event

type cb_top from commandbutton within w_thumbs
integer x = 18
integer y = 16
integer width = 146
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "|<"
end type

event clicked;
ii_Page = 1

wf_LoadThumbs( )
end event

type st_load from statictext within w_thumbs
integer x = 37
integer y = 1088
integer width = 3950
integer height = 128
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 15780518
string text = "Loading thumbnails. Please wait..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_box from statictext within w_thumbs
integer x = 18
integer y = 112
integer width = 4000
integer height = 3000
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 15780518
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

