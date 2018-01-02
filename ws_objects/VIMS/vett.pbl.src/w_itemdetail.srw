$PBExportHeader$w_itemdetail.srw
forward
global type w_itemdetail from window
end type
type shl_feedback from statichyperlink within w_itemdetail
end type
type cb_lookup from commandbutton within w_itemdetail
end type
type cb_post from commandbutton within w_itemdetail
end type
type mle_comments from multilineedit within w_itemdetail
end type
type st_itemid from statictext within w_itemdetail
end type
type st_1 from statictext within w_itemdetail
end type
type st_comm from statictext within w_itemdetail
end type
type st_qtitle from statictext within w_itemdetail
end type
type cb_1 from commandbutton within w_itemdetail
end type
type cb_reset from commandbutton within w_itemdetail
end type
type cb_att from commandbutton within w_itemdetail
end type
type cb_search from commandbutton within w_itemdetail
end type
type cb_prev from commandbutton within w_itemdetail
end type
type cb_next from commandbutton within w_itemdetail
end type
type cb_user from commandbutton within w_itemdetail
end type
type cb_viq from commandbutton within w_itemdetail
end type
type cb_sr from commandbutton within w_itemdetail
end type
type dw_item from datawindow within w_itemdetail
end type
type cb_cancel from commandbutton within w_itemdetail
end type
type cb_save from commandbutton within w_itemdetail
end type
type st_text from statictext within w_itemdetail
end type
type sle_num from singlelineedit within w_itemdetail
end type
type cb_get from commandbutton within w_itemdetail
end type
type gb_1 from groupbox within w_itemdetail
end type
type gb_2 from groupbox within w_itemdetail
end type
type dw_hist from datawindow within w_itemdetail
end type
type st_tip from statictext within w_itemdetail
end type
end forward

global type w_itemdetail from window
integer width = 4402
integer height = 2696
boolean titlebar = true
string title = "New Item"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
shl_feedback shl_feedback
cb_lookup cb_lookup
cb_post cb_post
mle_comments mle_comments
st_itemid st_itemid
st_1 st_1
st_comm st_comm
st_qtitle st_qtitle
cb_1 cb_1
cb_reset cb_reset
cb_att cb_att
cb_search cb_search
cb_prev cb_prev
cb_next cb_next
cb_user cb_user
cb_viq cb_viq
cb_sr cb_sr
dw_item dw_item
cb_cancel cb_cancel
cb_save cb_save
st_text st_text
sle_num sle_num
cb_get cb_get
gb_1 gb_1
gb_2 gb_2
dw_hist dw_hist
st_tip st_tip
end type
global w_itemdetail w_itemdetail

type prototypes

end prototypes

type variables

String is_SR, is_AttName
Long il_GN, il_UN, il_ObjID

Integer ii_Disable, ii_ShowNew, ii_ClosedOriginal, ii_RiskOriginal





end variables

forward prototypes
public function string wf_getrisktext (integer ai_risk)
end prototypes

public function string wf_getrisktext (integer ai_risk);String ls_Risk
Choose Case ai_Risk
	Case 0
		ls_Risk="Low"
	Case 1
		ls_Risk="Medium"
	Case 2
		ls_Risk="High"
End Choose

Return ls_Risk
end function

on w_itemdetail.create
this.shl_feedback=create shl_feedback
this.cb_lookup=create cb_lookup
this.cb_post=create cb_post
this.mle_comments=create mle_comments
this.st_itemid=create st_itemid
this.st_1=create st_1
this.st_comm=create st_comm
this.st_qtitle=create st_qtitle
this.cb_1=create cb_1
this.cb_reset=create cb_reset
this.cb_att=create cb_att
this.cb_search=create cb_search
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.cb_user=create cb_user
this.cb_viq=create cb_viq
this.cb_sr=create cb_sr
this.dw_item=create dw_item
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.st_text=create st_text
this.sle_num=create sle_num
this.cb_get=create cb_get
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_hist=create dw_hist
this.st_tip=create st_tip
this.Control[]={this.shl_feedback,&
this.cb_lookup,&
this.cb_post,&
this.mle_comments,&
this.st_itemid,&
this.st_1,&
this.st_comm,&
this.st_qtitle,&
this.cb_1,&
this.cb_reset,&
this.cb_att,&
this.cb_search,&
this.cb_prev,&
this.cb_next,&
this.cb_user,&
this.cb_viq,&
this.cb_sr,&
this.dw_item,&
this.cb_cancel,&
this.cb_save,&
this.st_text,&
this.sle_num,&
this.cb_get,&
this.gb_1,&
this.gb_2,&
this.dw_hist,&
this.st_tip}
end on

on w_itemdetail.destroy
destroy(this.shl_feedback)
destroy(this.cb_lookup)
destroy(this.cb_post)
destroy(this.mle_comments)
destroy(this.st_itemid)
destroy(this.st_1)
destroy(this.st_comm)
destroy(this.st_qtitle)
destroy(this.cb_1)
destroy(this.cb_reset)
destroy(this.cb_att)
destroy(this.cb_search)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.cb_user)
destroy(this.cb_viq)
destroy(this.cb_sr)
destroy(this.dw_item)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.st_text)
destroy(this.sle_num)
destroy(this.cb_get)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_hist)
destroy(this.st_tip)
end on

event open;Integer li_Row, li_CAPGen

dw_item.SetTransobject(SQLCA)
dw_hist.SetTransobject(SQLCA)

//  If (dept other than Vetting) or ('R' user) or (Insp Locked) or (in use), then disable
If g_obj.DeptID > 1 or g_Obj.Access < 2 or g_obj.ReqType = 1 or g_Obj.ObjType = 1 then
	ii_Disable = 1 
	cb_get.Enabled = False
	cb_Lookup.Enabled = False
	sle_Num.Enabled = False
Else 
	ii_Disable = 0
End If

// If user is non-vetting or is Readonly
If g_obj.DeptID > 1 or g_Obj.Access < 2 then cb_Reset.Enabled = False

// Show 'New' label in history only for vetting dept
If g_obj.DeptID = 1 then ii_ShowNew = 1 Else ii_ShowNew = 0

// If external model
If g_obj.param > 0 then 
	cb_get.Enabled = False
	cb_Lookup.Enabled = False
	st_QTitle.Text = "Serial No."
End If

// If insp is autofill (like MIRE), then lock Question No.
Select AUTOFILL Into :li_Row From VETT_INSPMODEL Where IM_ID = :g_Obj.InspModel;
If SQLCA.SQLCode=0 then 
	If li_Row = 1 then
		sle_Num.Enabled = False
		cb_Get.Enabled = False
		cb_Lookup.Enabled = False
	End If
End If

Commit;

st_ItemID.Text = "Item ID: " + String(g_obj.ObjID)

// Check if item is being edited
If g_obj.ObjString = "EditItem" then
	This.Title = "Edit Item"
	li_Row = w_inspdetail.dw_Items.GetRow()
	If g_obj.param = 0 then  // If insp has model
		sle_num.Text = w_inspdetail.dw_Items.GetItemString(li_Row, "fullnum")
		cb_get.event clicked( )		
	Else  // Otherwise get ext number
		sle_num.Text = String(w_inspdetail.dw_Items.GetItemNumber(li_Row, "extnum"))
		shl_Feedback.Visible = False
	End If
	dw_Item.Retrieve(g_obj.Objid, ii_Disable)
	If dw_Item.GetItemNumber( 1, "Closed") = 0 then	dw_Item.SetItem(1, "Closedate", DateTime(Today()))
	If dw_Item.GetItemNumber( 1, "Rect") = 0 then dw_Item.SetItem(1, "Rect_date", DateTime(Today()))
	li_CAPGen = dw_Item.GetItemNumber(1, "cap_gen")
	If IsNull(li_CAPGen) then li_CAPGen = 0
	dw_item.ResetUpdate()
	If ii_Disable=1 or li_CAPGen > 0 then
		If ii_Disable = 1 then dw_item.Object.InspComm.Edit.DisplayOnly = 'Yes'		
		If ii_Disable = 1 then dw_item.Object.OwnComm.Edit.DisplayOnly = 'Yes'
		If ii_Disable = 1 then dw_item.Object.FollowUp.Edit.DisplayOnly = 'Yes'		
	    dw_item.Object.VslComm.Edit.DisplayOnly = 'Yes'
		mle_Comments.Visible = False
		cb_Post.Visible = False
		sle_num.Enabled = False
		cb_Get.Enabled = False
		cb_Lookup.Enabled = False
	End If
	ii_ClosedOriginal = dw_Item.GetItemNumber(1, "Closed")
	ii_RiskOriginal = dw_Item.GetItemNumber(1, "Risk")
	dw_hist.Retrieve(g_Obj.Objid, ii_ShowNew)
	
	Commit;
	
Else   // Otherwise add a new item
	dw_Item.Retrieve(-10, 0)     //  To disable protection
	dw_Item.Reset()
	dw_Item.InsertRow(0)
	dw_Item.SetItem(1, "Insp_ID", g_obj.Inspid)
	dw_Item.SetItem(1, "Ans", 1)
	dw_Item.SetItem(1, "Def", 1)
	dw_Item.SetItem(1, "Closed", 0)
	dw_Item.SetItem(1, "Rect", 0)
	dw_Item.SetItem(1, "Report", 0)
	If g_obj.Param = 1 then	dw_Item.SetItem(1, "Risk", 0)
	dw_Item.SetItem(1, "Closedate", DateTime(Today()))
	dw_Item.SetItem(1, "Rect_date", DateTime(Today()))
	dw_Item.Object.Closed.Visible = 'No'
	shl_Feedback.Visible = False
End If

// If dept is non vetting and user is RW or above and Insp is not locked and not CAP, then show Comments box
If g_Obj.DeptID > 1 and g_Obj.Access > 1 and li_CAPGen = 0 then
	mle_Comments.Visible = True
	cb_Post.Visible = True
End If

// Set Nav buttons
If Mod(g_obj.Level, 2) = 1 then cb_Prev.Enabled = True
If g_obj.Level > 1 then cb_Next.Enabled = True
If g_obj.Level = 10 then 
	cb_Next.Visible = False
	cb_Prev.Visible = False
End If
g_Obj.Level = 0   // Reset Nav flag

cb_Save.Enabled = False

end event

event closequery;
If Trim(mle_Comments.Text, true) > "" then
	If Messagebox("Comments Not Posted", "You have entered comments and not posted them. These comments will be lost.~n~nAre you sure you want to continue?", Question!, YesNo!) = 2 then Return 1
End If
end event

type shl_feedback from statichyperlink within w_itemdetail
integer x = 640
integer y = 128
integer width = 366
integer height = 96
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "Submit Feedback for Question"
boolean focusrectangle = false
end type

event clicked;
ustruct_Feedback lData
String ls_Note, ls_IM

Select NOTE_TEXT into :ls_Note from VETT_NOTES where NOTES_ID = :il_GN;

If SQLCA.Sqlcode<>0 then 
	//MessageBox("DB Error", "Could not retrive Guidance Note from database.~n~n" + Sqlca.Sqlerrtext,Exclamation!)
	Rollback;
	ls_Note = "< No Guidance Notes>"
Else
	Commit;
End If

Select NAME + ' ' + EDITION Into :ls_IM
From VETT_INSPMODEL Inner Join VETT_INSP
On VETT_INSPMODEL.IM_ID=VETT_INSP.IM_ID
Where INSP_ID=:g_Obj.InspID;

If SQLCA.Sqlcode<>0 then 
	MessageBox("DB Error", "Could not retrive Inspection Model from database.~n~n" + Sqlca.Sqlerrtext,Exclamation!)
	Rollback;
	ls_IM = ""
Else
	Commit;
End If

lData.InspModel = ls_IM
lData.Qtext = st_Text.Text
lData.Guidance = ls_Note
lData.RiskRating = dw_item.GetItemNumber(1, "riskrating") 

OpenWithParm(w_Feedback, lData)
end event

type cb_lookup from commandbutton within w_itemdetail
integer x = 512
integer y = 144
integer width = 91
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "?"
end type

event clicked;
Open(w_Lookup)

If Message.StringParm > "" then
	sle_Num.Text = Message.Stringparm
	cb_Get.event Clicked( )
End If
end event

type cb_post from commandbutton within w_itemdetail
boolean visible = false
integer x = 1883
integer y = 1980
integer width = 398
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Post Comment"
end type

event clicked;ustruct_systime lstruct_UTC
DateTime ldt_Date
Long ll_TimeStamp, ll_ItemID
String ls_PostBy

// Trim the text
mle_Comments.Text = Trim(mle_Comments.Text, True)

If mle_Comments.Text = "" then
	MessageBox("No Comments", "There is no comment to post!", Exclamation!)
	Return
End If

// Confirmation added as per Janus' request
If MessageBox("Confirm Post", "Comments cannot be modified after posting and will be exported to the vessel by the Marine Superintendent.~n~nAre you sure you have reviewed your comment and want to post it to the comment history?", Question!, YesNo!) = 2 then Return

// Get UTC Time and create timestamp
GetSystemTime(lstruct_UTC)
ldt_Date = DateTime(Date(lstruct_UTC.wyear, lstruct_UTC.wmonth, lstruct_UTC.wday), Time(lstruct_UTC.whour, lstruct_UTC.wMinute, 0))	
ll_TimeStamp = f_GetTimestamp()

ll_ItemID = dw_Item.GetItemNumber(1, "Item_ID")
ls_PostBy = g_Obj.Dept + ' - ' + gs_FullName

Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA)
Values(:ll_TimeStamp, :ll_ItemID, 0, 1, :ldt_Date, :ls_PostBy , :mle_Comments.Text);

If SQLCA.SQLCode = 0 then
	Commit;
	mle_Comments.Text = ""
	dw_Hist.Retrieve(ll_ItemID, ii_ShowNew)
	If IsValid(w_inspdetail) then w_inspdetail.ib_Modified = True
Else
	Rollback;
	MessageBox("Comment Post Failed", "Unable to post comments! Please wait at least one minute before posting successive comments.")
End If

end event

type mle_comments from multilineedit within w_itemdetail
boolean visible = false
integer x = 78
integer y = 2060
integer width = 2194
integer height = 372
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
integer limit = 10000
borderstyle borderstyle = stylelowered!
end type

type st_itemid from statictext within w_itemdetail
integer x = 1810
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 8388608
long backcolor = 67108864
string text = "Item ID:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_itemdetail
integer x = 2981
integer y = 72
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 10789024
long backcolor = 67108864
string text = "( New on top )"
boolean focusrectangle = false
end type

type st_comm from statictext within w_itemdetail
integer x = 2395
integer y = 64
integer width = 585
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comment History:"
boolean focusrectangle = false
end type

type st_qtitle from statictext within w_itemdetail
integer x = 73
integer y = 80
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Question Number:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_itemdetail
boolean visible = false
integer x = 3438
integer y = 64
integer width = 293
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Make New"
end type

event clicked;Integer li_Row

If Messagebox("Confirm Reset", "Are you sure you want to make all new items?", Question!, YesNo!) = 2 then Return
	
For li_Row = 1 to dw_hist.Rowcount( )
	dw_hist.SetItem(li_Row, "Status", 0)  // Mark all as non-new
Next

If dw_hist.Update() < 1 then Messagebox("DW Update Error", "Reset unsuccessful. Unable to update DW!", Exclamation!)
end event

type cb_reset from commandbutton within w_itemdetail
integer x = 3730
integer y = 64
integer width = 603
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Acknowledge New"
end type

event clicked;Integer li_Row

//If Messagebox("Confirm Reset", "Reset all 'new' items for this question?", Question!, YesNo!) = 2 then Return
	
For li_Row = 1 to dw_hist.Rowcount( )
	If dw_hist.GetItemNumber(li_Row, "Status") < 1 then	dw_hist.SetItem(li_Row, "Status", 1)  // Mark all as non-new
Next

If dw_hist.Update() < 1 then 
	Messagebox("DW Update Error", "Reset unsuccessful. Unable to save changes to database!", Exclamation!)
Else
	This.Enabled = False
	If IsValid(w_inspdetail) then
		w_inspdetail.dw_items.SetItem(w_inspdetail.dw_items.GetRow(), "newitem", 1)
	End If
	
	Commit;
End If
end event

type cb_att from commandbutton within w_itemdetail
integer x = 1079
integer y = 144
integer width = 603
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Question Attachment..."
end type

event clicked;String ls_fPath
Integer li_FileNum
Long ll_FSize
Blob lblob_File
n_VimsAtt ln_Att

SetPointer(HourGlass!)

ln_Att = Create n_VimsAtt

If ln_Att.of_Connect("") < 1 then
	Destroy ln_Att
	Messagebox("DB Error", "Unable to connect to the attachment database.", Exclamation!)
	Return
End If

If ln_Att.of_GetAtt("VETT_OBJ", il_ObjID, lblob_File) < 1 then 
	Messagebox("DB Error", "Could not retrieve file from database.", Exclamation!)	
	Destroy ln_Att
	Return
End If

Destroy ln_Att

ls_FPath = ""

If GetFolder("Select the folder where you wish to save this attachment:", ls_FPath) < 1 then Return

If Right(ls_FPath,1) <> "\" then ls_FPath += "\"
ls_FPath += is_AttName

li_FileNum = Fileopen( ls_FPath, StreamMode!, Write!, LockReadWrite!, Replace!)

If li_FileNum <0 then 
	MessageBox ("File I/O Error", "Could not create a file handle. Please check if you have permission to create this file at the specified location.",Exclamation!)
	Return
End If

ll_FSize = FileWriteEx(li_FileNum, lblob_File)

If ll_FSize < 1 then
	FileClose(li_FileNum)
	MessageBox("File I/O Error", "Could not write to the file.",Exclamation!)
	Return
End If

FileClose(li_FileNum)

If Messagebox("Attachment Saved", "The attachment was saved successfully.~n~nFile Name: " + is_AttName + "~n~nFile Size: " + String(ll_FSize, "#,###,##0") + " Bytes~n~nDo you want to try and open this file with its default application?", Question!, YesNo!) = 2 then Return

ShellExecute( Handle(Parent), "open", ls_FPath, "", "", 3)
end event

type cb_search from commandbutton within w_itemdetail
integer x = 1883
integer y = 64
integer width = 402
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Search"
end type

event clicked;
g_obj.ObjString = sle_num.Text

Open(w_SearchItem)
end event

type cb_prev from commandbutton within w_itemdetail
integer x = 18
integer y = 2496
integer width = 101
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "<"
end type

event clicked;Integer ls_Sel

dw_Item.Accepttext( )

If cb_Save.Enabled then 
	ls_Sel = Messagebox("Item Modified", "You have made changes to this item.~n~nDo you want to save these changes?", Question!, YesNoCancel!)
	
	g_Obj.Level = 1
	If ls_Sel = 1 then cb_Save.PostEvent(Clicked!)
	If ls_Sel = 2 then cb_Cancel.PostEvent(Clicked!)
	If ls_Sel = 3 then g_Obj.Level = 0
	
Else  // If not modified
	
	g_Obj.Level = 1
	cb_Cancel.PostEvent(Clicked!)	
End If


end event

type cb_next from commandbutton within w_itemdetail
integer x = 4261
integer y = 2496
integer width = 101
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = ">"
end type

event clicked;Integer ls_Sel

dw_Item.Accepttext( )

If cb_Save.Enabled then 
	ls_Sel = Messagebox("Item Modified", "You have made changes to this item.~n~nDo you want to save these changes?", Question!, YesNoCancel!)
	
	g_Obj.Level = 2
	If ls_Sel = 1 then cb_Save.PostEvent(Clicked!)
	If ls_Sel = 2 then cb_Cancel.PostEvent(Clicked!)
	If ls_Sel = 3 then g_Obj.Level = 0
Else  // If not modified
	
	g_Obj.Level = 2
	cb_Cancel.PostEvent(Clicked!)
End If
end event

type cb_user from commandbutton within w_itemdetail
integer x = 1481
integer y = 64
integer width = 402
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "User Note"
end type

event clicked;
g_obj.Noteid = il_UN

Open(w_Note)

end event

type cb_viq from commandbutton within w_itemdetail
integer x = 1079
integer y = 64
integer width = 402
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Guide Note"
end type

event clicked;
g_obj.Noteid = il_GN

Open(w_Note)

end event

type cb_sr from commandbutton within w_itemdetail
integer x = 1682
integer y = 144
integer width = 603
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Get Standard Reply"
end type

event clicked;
dw_item.SetItem(dw_Item.GetRow(), "OWNCOMM", is_SR)
end event

type dw_item from datawindow within w_itemdetail
integer x = 55
integer y = 400
integer width = 2231
integer height = 2048
integer taborder = 70
string title = "none"
string dataobject = "d_sq_ff_itemedit"
boolean border = false
end type

event itemfocuschanged;
If (dwo.Name = "risk") and (len(st_Text.Text)>0) then st_Tip.Visible = True else st_Tip.Visible = False
end event

event doubleclicked;
If dwo.Type <> "column" then Return

If ii_Disable = 1 then Return

If Lower(dwo.Edit.DisplayOnly) = 'yes' then Return

Yield()

If dwo.tag = "TX" then
	This.Accepttext( )
	g_obj.ObjString = This.GetItemString(row, String(dwo.name))
	Open(w_textedit)
	If Not IsNull(g_obj.ObjString) then 
		This.SetItem(row, String(dwo.name), Trim(g_obj.ObjString, True))
		cb_Save.Enabled = True
	End If
End If
end event

event itemchanged;
If Lower(dwo.name)="is_cap" then
	If this.GetItemNumber(1, "is_cap") = 0 or IsNull(this.GetItemNumber(1, "is_cap")) Then
			If Messagebox("Confirm CAP Creation","You are flagging this observation as a CAP. It will be exported to ShipNet as a CAP automatically within a few minutes.~n~nAre you sure you want to do this?", Question!, YesNo!) = 2 then Return 2
	End If
End If

cb_Save.Enabled = True

end event

event editchanged;
cb_Save.Enabled = True
end event

type cb_cancel from commandbutton within w_itemdetail
integer x = 2725
integer y = 2496
integer width = 402
integer height = 96
integer taborder = 100
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
g_obj.Objid = 0

Close(Parent)

end event

type cb_save from commandbutton within w_itemdetail
integer x = 1262
integer y = 2496
integer width = 402
integer height = 96
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;Integer li_Ret, li_Req, li_Ans
Long ll_ItemID, ll_TimeStamp, ll_ObjID, ll_InspID
Decimal{4} ldec_extnum
DateTime ldt_Date

// Perform validation

dw_item.AcceptText( )

If g_obj.Param = 0 then     //  If question No. is required
	If (dw_item.GetItemNumber(1, "Obj_ID") = 0) or IsNull(dw_item.GetItemNumber(1, "Obj_ID")) then 
		MessageBox("Invalid Selection", "Please select a question from the Inspection Model.",Exclamation!)
		g_obj.Level = 0
		Return
	End If
Else     //  Insp has no model
	If dw_item.GetItemNumber(1, "Extnum") = 0 then
		MessageBox("Invalid Number", "Please enter a valid serial number.",Exclamation!)
		g_obj.Level = 0				
		Return		
	End If
End If

ll_ItemID=dw_item.GetItemNumber(1, "Item_ID")

// Check if question number is already in use on another item (CR 2640)
If g_obj.Param = 0 and sle_Num.Enabled=True then
	ll_ObjID=dw_item.GetItemNumber(1, "Obj_ID")
	ll_InspID=dw_item.GetItemNumber(1, "Insp_ID")	
	Select Top 1 ITEM_ID Into :ll_ItemID from VETT_ITEM 
	Where OBJ_ID=:ll_ObjID and INSP_ID=:ll_InspID and ITEM_ID<>:ll_ItemID;
	If SQLCA.SQLCode=0 then
		Commit;
		Messagebox("Duplicate Question", "The question number specified is already present in another observation.", Exclamation!)
		g_Obj.Level = 0
		Return
	End If
	Commit;
End If


If IsNull(dw_item.GetItemNumber(1, "Ans")) then     // If no answer selected
	MessageBox("Answer", "Please select an answer for the question.",Exclamation!)
	g_obj.Level = 0		
	Return
End If	

If dw_item.GetItemNumber(1, "Rect") = 1 then  // If rectified on board, check date
	If IsNull(dw_item.GetItemDateTime(1, "Rect_Date")) then
		MessageBox("Date Required", "Please select the 'Rectified on-board' date.",Exclamation!)
		g_obj.Level = 0		
		Return		
	End If
End If

// Trim all text fields
dw_item.SetItem(1, "InspComm", Trim(dw_item.GetItemString(1, "InspComm"), True))
dw_item.SetItem(1, "VslComm", Trim(dw_item.GetItemString(1, "VslComm"), True))
dw_item.SetItem(1, "ownComm", Trim(dw_item.GetItemString(1, "OwnComm"), True))
dw_item.SetItem(1, "followup", Trim(dw_item.GetItemString(1, "followUp"), True))	

li_Req = dw_item.GetItemNumber(1, "Reqtype")
li_Ans = dw_item.GetItemNumber(1, "Ans")
If IsNull(li_Req) then li_Req = 1   // If null, then set to statutory

If (dw_item.GetItemNumber(1, "Closed") = 1) and (li_Req > 0) and (li_Ans = 1) then
	If IsNull(dw_item.GetItemNumber(1, "Resp_ID")) then
		MessageBox("Save Error", "An item cannot be closed until the 'Responsibility' is selected.",Exclamation!)
		g_obj.Level = 0			
		Return
	End If
	If ii_ClosedOriginal = 0 And (IsNull(dw_item.GetItemString(1, "FollowUp")) Or dw_Item.GetItemString(1, "FollowUp") = "") Then
		Integer li_Review
		String ls_SN
		Select COMPLETED, SHORTNAME Into :li_Review, :ls_SN From VETT_INSP
		Inner Join VETT_INSPMODEL On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID
		Where INSP_ID = :g_Obj.InspID;
		
		Commit;
		If li_Review = 1 and ls_SN="SIRE" Then
			Messagebox("Save Error", "Further Operator Comments are required before closing this observation as inspection is already reviewed.", Exclamation!)
			g_Obj.Level = 0
			Return
		End If
	End If
	dw_item.SetItemStatus(1, "CloseDate", Primary!, DataModified!)   // Force date to be updated
End If

If li_Req = 0 then  // If this is a info item
	dw_item.SetItem(1, "Closed", 1)
	dw_item.SetItem(1, "Rect", 0)
	dw_item.SetItem(1, "Def", 0)
	dw_item.SetItem(1, "Report", 0)
	dw_item.SetItem(1, "Ans", 0)
End If

If li_Ans <> 1 then   // If answer is not No
	dw_item.SetItem(1, "Closed", 1)
	dw_item.SetItem(1, "Rect", 0)
	dw_item.SetItem(1, "Def", 0)
	dw_item.SetItem(1, "CloseDate", Today())
	dw_item.SetItem(1, "ownComm", "")
	dw_item.SetItem(1, "followup", "")
Else
	If dw_item.GetItemString(1, "InspComm") = "" or IsNull(dw_item.GetItemString(1, "InspComm")) then
		Messagebox("Save Error", "Inspector's Comments must be present if 'No' answer is selected.", Exclamation!)		
		Return
	End If		
End If

SetPointer(HourGlass!)

// Perform update
If dw_item.Update( ) <> 1 then
	MessageBox("Update Error", "Could not update the database.", Exclamation!)
	Rollback;
	g_obj.Level = 0		
	Return
End If

// If item was closed, post a system comment
If (dw_item.GetItemNumber(1, "Closed") = 1) and (ii_ClosedOriginal=0) Then
	ll_TimeStamp = f_GetTimestamp()
	
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA)
	Values(:ll_TimeStamp, :ll_ItemID, 1, 1, GetUTCDate(), 'System' , 'Observation closed by '+ :gs_FullName);
	
	Commit;
End If

// If item was re-opened, post a system comment
If (dw_item.GetItemNumber(1, "Closed")=0) and (ii_ClosedOriginal=1) Then
	ll_TimeStamp = f_GetTimestamp()
	
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA)
	Values(:ll_TimeStamp, :ll_ItemID, 1, 1, GetUTCDate(), 'System' , 'Observation re-opened by '+ :gs_FullName);
	
	Commit;
End If

// If risk was changed, post a system comment
If dw_item.GetItemNumber(1, "Risk")<>ii_RiskOriginal Then
	String ls_Risk
	ls_Risk = "Risk changed from '" + wf_GetRiskText(ii_RiskOriginal)
	ls_Risk+= "' to '" + wf_GetRiskText(dw_item.GetItemNumber(1, "Risk"))
	ls_Risk+= "' by " + gs_FullName
	
	ll_TimeStamp = f_GetTimestamp()
	Insert Into VETT_ITEMHIST(TIME_ID, ITEM_ID, STATUS, HIST_TYPE, UTC, ORIGIN, DATA)
	Values(:ll_TimeStamp, :ll_ItemID, 1, 1, GetUTCDate(), 'System' , :ls_Risk);
	
	Commit;
End If

If IsValid(w_inspdetail) then w_inspdetail.ib_Modified = True
Commit;

g_obj.Objid = dw_Item.GetItemNumber(1, "Item_ID")

Close(Parent)

end event

type st_text from statictext within w_itemdetail
integer x = 73
integer y = 224
integer width = 2213
integer height = 176
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
long bordercolor = 12632256
boolean focusrectangle = false
end type

type sle_num from singlelineedit within w_itemdetail
event ue_keydown pbm_keydown
integer x = 73
integer y = 144
integer width = 347
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If (key = KeyEnter!) and cb_Get.Enabled then 
	cb_get.event clicked( )
	sle_num.selecttext( 1, len(sle_num.text))
End If
end event

event losefocus;Decimal ldec_extnum
Integer li_Null

If g_obj.param > 0 then  // Item has no insp model
	sle_num.Text = trim(sle_num.Text)
	If Not IsNumber(sle_num.Text) then
		MessageBox("Invalid Number", "A valid serial number is required for this item.",Exclamation!)						
		dw_item.SetItem(1,"Extnum", 0)
		Return
	End If

	SetNull(li_Null)
	ldec_extnum = Dec(sle_num.Text)
	
	dw_item.SetItem(1,"Obj_ID", li_Null)
	dw_item.SetItem(1,"Extnum", ldec_extnum )
End If
end event

event modified;
cb_Save.Enabled = True
end event

type cb_get from commandbutton within w_itemdetail
integer x = 421
integer y = 144
integer width = 91
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

event clicked;Integer li_Count, li_Num[], li_Index, li_Risk, li_RiskRating
String ls_Full, ls_Temp

SetPointer(HourGlass!)
sle_num.Text = Trim(sle_num.Text)

ls_Full = sle_num.Text

st_Text.Text = ""
il_ObjID = 0
cb_viq.Enabled = False
cb_user.Enabled = False
cb_sr.Enabled = False
cb_Search.Enabled = False
shl_Feedback.Visible = False
dw_item.SetItem(1, "riskrating", 1)

If Len(ls_Full)<3 then
	MessageBox ("Invalid Number", "Please specify a proper question number.", Exclamation!)
	Return
End If

// Set all to 0
For li_Count = 1 to 6
	li_Num[li_Count] = 0
Next

//Parse string
For li_Count = 1 to Len(ls_Full)
	If Pos("0123456789", Mid(ls_Full, li_Count, 1)) > 0 then
		ls_Temp += Mid(ls_Full, li_Count, 1)
	Else
		If ls_Temp>"" then
			li_Index++
			li_Num[li_Index] = Integer(ls_Temp)
			ls_Temp = ""
		End If
	End If
Next
If ls_Temp>"" then
	li_Index++
	li_Num[li_Index] = Integer(ls_Temp)
End If

ls_Temp = ""

//Recreate number
For li_Count = 1 to 6
	if li_Num[li_Count] > 0 then 
		if ls_Temp>"" then ls_Temp += "."
		ls_Temp += String(li_Num[li_Count])
	End If
Next
sle_num.Text = ls_Temp

If li_Index < 2 then 
	Messagebox("Invalid Number", "At least 2 numbers must be specified to designate the question.", Exclamation!)
	Return
End If

Declare GetObjID Procedure FOR VETT_GETOBJ @IMID = :g_obj.Inspmodel, @N1 = :li_Num[1], @N2 = :li_Num[2], @N3 = :li_Num[3], @N4 = :li_Num[4], @N5 = :li_Num[5], @N6 = :li_Num[6];

Execute GetObjID;

If SQLCA.Sqlcode <>0 then 
	Messagebox("DB Error", "Could not execute Stored Procedure.~n~n" + sqlca.sqlerrtext, Exclamation!)
	sle_num.SetFocus( )	
	Rollback;
	Return
End If

Fetch GetObjID into :il_objid, :li_Index, :li_Risk, :ls_Full, :li_RiskRating;

Close GetObjID;

If SQLCA.Sqlcode <>0 then 
	Messagebox("DB Error", "Could not retrieve SP resultset.~n~n" + sqlca.sqlerrtext, Exclamation!)
	sle_num.SetFocus( )	
	Rollback;
	Return
End If

Commit;

If il_objid = 0 then
	Messagebox("Invalid Number", "The number entered does not refer to any entity in the Inspection Model.", Exclamation!)
	sle_num.SetFocus( )
End If

If (li_Index < 3) and (il_ObjID > 0) then
	MessageBox("Invalid Number", "The number entered refers to a section and not a question.")
	il_Objid = 0
	sle_num.SetFocus( )
End If

dw_item.SetItem(1, "Obj_ID", il_objid)

If il_ObjID = 0 then Return

dw_Item.SetRedraw(False)

st_Text.Text = sle_num.Text + " - " + ls_Full
dw_Item.SetItem(1, "Risk", li_Risk)
dw_item.SetItem(1, "riskrating", li_RiskRating)
shl_Feedback.Visible = True

dw_Item.SetRedraw(True)

SetNull(il_GN)
SetNull(il_UN)
SetNull(is_SR)

Select	GN.NOTES_ID, 
			UN.NOTES_ID,
			SR.NOTE_TEXT,
			REQTYPE,
			ATTNAME
into 		:il_GN,
			:il_UN,
			:is_SR,
			:li_Risk,
			:is_AttName
from		VETT_NOTES GN,
			VETT_NOTES UN,
			VETT_NOTES SR,
			VETT_OBJ 
where		GN.NOTES_ID =* VETT_OBJ.OBJNOTE and
         GN.NOTETYPE = 1 and
			UN.NOTES_ID =* VETT_OBJ.USERNOTE and
         UN.NOTETYPE = 2 and
			SR.NOTES_ID =* VETT_OBJ.AUTOREPLY and
			SR.NOTETYPE = 3 and
			VETT_OBJ.OBJ_ID = :il_ObjID;

If SQLCA.Sqlcode < 0 then
	Messagebox("DB Error", "Could not retrieve extended information from the Database.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Rollback;
Else
	Commit;
End If

If (g_Obj.DeptID > 1) then SetNull(is_SR)

If IsNull(li_Risk) then li_Risk = 1  // If null, then set statuatory

dw_item.SetItem(1, "reqtype", li_Risk)  
dw_item.SetItem(1, "Closed", 0)
dw_item.SetItem(1, "Def", 1)
dw_item.SetItem(1, "Report", 1)
If li_Risk = 0 then dw_item.SetItem(1, "Ans", 0) else dw_item.SetItem(1, "Ans", 1)

cb_Save.Enabled = True

cb_sr.Enabled = Not IsNull(is_SR) 
cb_VIQ.Enabled = Not IsNull(il_GN)
cb_User.Enabled = Not IsNull(il_UN)
cb_Att.Enabled = Not IsNull(is_AttName)
If g_Obj.DeptId = 1 then cb_Search.Enabled = True  // Vetting only

end event

type gb_1 from groupbox within w_itemdetail
integer x = 18
integer width = 2304
integer height = 2464
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

type gb_2 from groupbox within w_itemdetail
integer x = 2359
integer width = 2011
integer height = 2464
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_hist from datawindow within w_itemdetail
integer x = 2395
integer y = 144
integer width = 1938
integer height = 2288
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_itemhist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount = 0 then cb_reset.Enabled = False

end event

type st_tip from statictext within w_itemdetail
boolean visible = false
integer x = 1061
integer y = 512
integer width = 855
integer height = 272
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 15793151
string text = "The default risk for this question has been selected automatically. Please be very sure if you are changing this selection."
boolean border = true
boolean focusrectangle = false
end type

event clicked;
This.Visible = False
end event

