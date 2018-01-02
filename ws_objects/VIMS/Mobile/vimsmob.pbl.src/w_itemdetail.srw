$PBExportHeader$w_itemdetail.srw
forward
global type w_itemdetail from window
end type
type shl_feedback from statichyperlink within w_itemdetail
end type
type cb_lookup from commandbutton within w_itemdetail
end type
type st_1 from statictext within w_itemdetail
end type
type cb_comm from commandbutton within w_itemdetail
end type
type st_comm from statictext within w_itemdetail
end type
type st_qno from statictext within w_itemdetail
end type
type cb_1 from commandbutton within w_itemdetail
end type
type cb_reset from commandbutton within w_itemdetail
end type
type dw_hist from datawindow within w_itemdetail
end type
type cb_search from commandbutton within w_itemdetail
end type
type cb_prev from commandbutton within w_itemdetail
end type
type cb_next from commandbutton within w_itemdetail
end type
type st_tip from statictext within w_itemdetail
end type
type cb_viq from commandbutton within w_itemdetail
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
type gb_comments from groupbox within w_itemdetail
end type
end forward

global type w_itemdetail from window
integer width = 4402
integer height = 2616
boolean titlebar = true
string title = "New Item"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
shl_feedback shl_feedback
cb_lookup cb_lookup
st_1 st_1
cb_comm cb_comm
st_comm st_comm
st_qno st_qno
cb_1 cb_1
cb_reset cb_reset
dw_hist dw_hist
cb_search cb_search
cb_prev cb_prev
cb_next cb_next
st_tip st_tip
cb_viq cb_viq
dw_item dw_item
cb_cancel cb_cancel
cb_save cb_save
st_text st_text
sle_num sle_num
cb_get cb_get
gb_1 gb_1
gb_comments gb_comments
end type
global w_itemdetail w_itemdetail

type prototypes


end prototypes

type variables

Long il_GN, il_UN, il_ObjID
Integer ii_Lock, ii_Status





end variables

on w_itemdetail.create
this.shl_feedback=create shl_feedback
this.cb_lookup=create cb_lookup
this.st_1=create st_1
this.cb_comm=create cb_comm
this.st_comm=create st_comm
this.st_qno=create st_qno
this.cb_1=create cb_1
this.cb_reset=create cb_reset
this.dw_hist=create dw_hist
this.cb_search=create cb_search
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.st_tip=create st_tip
this.cb_viq=create cb_viq
this.dw_item=create dw_item
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.st_text=create st_text
this.sle_num=create sle_num
this.cb_get=create cb_get
this.gb_1=create gb_1
this.gb_comments=create gb_comments
this.Control[]={this.shl_feedback,&
this.cb_lookup,&
this.st_1,&
this.cb_comm,&
this.st_comm,&
this.st_qno,&
this.cb_1,&
this.cb_reset,&
this.dw_hist,&
this.cb_search,&
this.cb_prev,&
this.cb_next,&
this.st_tip,&
this.cb_viq,&
this.dw_item,&
this.cb_cancel,&
this.cb_save,&
this.st_text,&
this.sle_num,&
this.cb_get,&
this.gb_1,&
this.gb_comments}
end on

on w_itemdetail.destroy
destroy(this.shl_feedback)
destroy(this.cb_lookup)
destroy(this.st_1)
destroy(this.cb_comm)
destroy(this.st_comm)
destroy(this.st_qno)
destroy(this.cb_1)
destroy(this.cb_reset)
destroy(this.dw_hist)
destroy(this.cb_search)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.st_tip)
destroy(this.cb_viq)
destroy(this.dw_item)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.st_text)
destroy(this.sle_num)
destroy(this.cb_get)
destroy(this.gb_1)
destroy(this.gb_comments)
end on

event open;Integer li_Row

dw_item.SetTransobject(SQLCA)
dw_hist.SetTransobject(SQLCA)

f_Write2Log("w_ItemDetail Open")

 // If external model
If g_Obj.ParamLong > 0 then 
	cb_get.Enabled = False
	st_qno.Text = 'Serial Number:'
End If

// ii_Lock: 0 = No Access, 1 = Only comments open, 2 = All except comments, 3 = All except risk
ii_Lock = Mod(g_Obj.ParamInt, 100)

// ii_Status: 0 = New Insp, 1 = Imported from Insp, 2 = Exported to office, 3 = Imported from Office
ii_Status = Integer(g_Obj.ParamInt / 100)

If g_TestMode then Messagebox("w_itemdetail.open()", "ii_Status=" + String(ii_Status) + " ii_Lock=" + String(ii_Lock))

// Check if item is being edited
If Left(g_Obj.ParamString, 4) = "Edit" then
	This.Title = "Edit Item"
	li_Row = w_inspdetail.dw_Items.GetRow()
	If g_Obj.paramLong = 0 Then  // If insp has model
		sle_num.Text = w_inspdetail.dw_Items.GetItemString(li_Row, "fullnum")
		cb_get.event clicked( )		
	Else  // Otherwise get ext number
		sle_num.Text = String(w_inspdetail.dw_Items.GetItemNumber(li_Row, "extnum"))
		shl_Feedback.Visible = False
	End If
	If Right(g_Obj.ParamString, 4) = "Auto" then // If Autofill insp
		cb_Get.Enabled = False
		cb_Lookup.Enabled = False
		sle_num.Enabled = False
	End If
	dw_Item.Retrieve(g_Obj.ItemID, ii_Lock, ii_Status)
    If dw_hist.Retrieve(g_Obj.ItemID)>0 then 
		gb_comments.Visible = False
	Else
		cb_Reset.Enabled = False
	End If

	If ii_Lock < 2 then  // If lock < 2, disable question number
		cb_Get.Enabled = False
		cb_Lookup.Enabled = False
		sle_num.Enabled = False
		dw_Item.Modify('inspcomm.Edit.displayonly = True')
	End If
	If Mod(ii_Lock, 2) = 0 then dw_Item.Modify('vslcomm.Edit.displayonly = True')
Else   // Otherwise add a new item
	dw_Item.Retrieve(-10, ii_Lock, 0)     //  Set locking mechanism
	dw_Item.Reset()
	dw_Item.InsertRow(0)
	dw_Item.SetItem(1, "Insp_ID", g_Obj.Inspid)
	dw_Item.SetItem(1, "Ans", 1)
	dw_Item.SetItem(1, "Def", 1)
	dw_Item.SetItem(1, "Closed", 0)
	dw_Item.SetItem(1, "Rect", 0)
	dw_Item.SetItem(1, "Rect_Date", DateTime(Today()))
	dw_Item.SetItem(1, "is_cap", 0)
	If g_Obj.ParamLong = 1 then dw_Item.SetItem(1, "Risk", 0)   // insp has no model, set low risk
	cb_comm.Visible = False
	shl_Feedback.Visible = False
	dw_Item.SetItem(1, "VslComm", "1. Vessel's subjective interpretation of the deficiency.~n~r[ Enter answer here]~n~r~n~r2. Root cause for this deficiency~n~r[ Enter answer here]~n~r~n~r3. Immediate action taken to rectify the deficiency~n~r[ Enter answer here]~n~r~n~r4. Lessons to be learned~n~r[ Enter answer here]~n~r~n~r5. Action taken / to be taken to ensure avoidance of future reoccurrence.~n~r[ Enter answer here]~n~r~n~r6. Any rectifications: when have they been / will be completed.~n~r[ Enter answer here]~n~r~n~r7. Any other comments.~n~r[ Enter answer here]~n~r")
End If

// Set navigation buttons
If Mod(g_Obj.Level, 2) = 1 then cb_Prev.Enabled = True   
If g_Obj.Level > 1 then cb_Next.Enabled = True
If g_Obj.Level = 10 then 
	cb_Next.Visible = False
	cb_Prev.Visible = False
End If

// Hide Risk 'arrow' if not required
If ii_Lock <> 2 then dw_Item.Modify("Risk.DDLB.UseAsBorder = 'No'")

// Reset button only available to vessels
If g_Obj.Login <> 1 then cb_Reset.Visible = False

g_Obj.Level = 0

cb_comm.event Clicked( )

end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2100)
end event

type shl_feedback from statichyperlink within w_itemdetail
integer x = 768
integer y = 112
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

OpenWithParm(w_vmFeedback, lData)
end event

type cb_lookup from commandbutton within w_itemdetail
integer x = 658
integer y = 128
integer width = 91
integer height = 80
integer taborder = 90
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

type st_1 from statictext within w_itemdetail
integer x = 2834
integer y = 56
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "( New on top )"
boolean focusrectangle = false
end type

type cb_comm from commandbutton within w_itemdetail
integer x = 1426
integer y = 48
integer width = 731
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show Comment &History"
end type

event clicked;Integer li_x, li_Wid

li_x = Parent.X

If gb_comments.Visible then
	gb_Comments.Visible = False
	li_Wid = 2240
	If dw_hist.Rowcount( ) = 0 then	This.Text = 'Show Comment History' Else This.Text = 'Show Comment History (' + String(dw_hist.RowCount()) + ')'
	li_x += 1088
Else
	gb_Comments.Visible = True
	gb_Comments.SetPosition(ToBottom!)
	li_Wid = 4415
	This.Text = 'Hide Comment History'
	li_x -= 1088
End If

If li_x < 0 then li_x = 0

If li_Wid > 3000 then
	Parent.Move(li_x, Parent.Y)
	Parent.Width = li_Wid
Else
	Parent.Width = li_Wid
	Parent.Move(li_x, Parent.Y)
End If

cb_Save.X = (Parent.Width / 3) - (cb_Save.Width / 2)
cb_Cancel.X = (Parent.Width * 2 / 3) - (cb_Save.Width / 2)
cb_Next.X = Parent.Width - cb_Next.Width - 40

end event

type st_comm from statictext within w_itemdetail
integer x = 2249
integer y = 48
integer width = 585
integer height = 80
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

type st_qno from statictext within w_itemdetail
integer x = 73
integer y = 64
integer width = 407
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
integer x = 3529
integer y = 48
integer width = 293
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Make New Items"
end type

event clicked;Integer li_Row

If Messagebox("Confirm Reset", "Are you sure you want to make all new items?", Question!, YesNo!) = 2 then Return
	
For li_Row = 1 to dw_hist.Rowcount( )
	dw_hist.SetItem(li_Row, "Status", 0)  // Mark all as non-new
Next

If dw_hist.Update() < 1 then Messagebox("DW Update Error", "Reset unsuccessful. Unable to update DW!", Exclamation!)
end event

type cb_reset from commandbutton within w_itemdetail
integer x = 3822
integer y = 48
integer width = 512
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ac&knowledge New"
end type

event clicked;Integer li_Row

//If Messagebox("Confirm Reset", "Reset all 'new' items for this question?", Question!, YesNo!) = 2 then Return
	
For li_Row = 1 to dw_hist.Rowcount( )
	If dw_Hist.GetItemNumber(li_Row, "Status") = 0 then dw_hist.SetItem(li_Row, "Status", 1)  // Mark all as non-new
Next

If dw_hist.Update() < 1 then 
	Messagebox("DW Update Error", "Reset unsuccessful. Unable to update DW!", Exclamation!)
	f_Write2Log("w_ItemDetail > cb_Reset Failed")	
Else
	f_Write2Log("w_ItemDetail > cb_Reset Successful")	
	w_InspDetail.dw_Items.SetItem(w_InspDetail.dw_Items.GetRow(), "NewItem", 1)	
End If


end event

type dw_hist from datawindow within w_itemdetail
integer x = 2249
integer y = 128
integer width = 2085
integer height = 2208
integer taborder = 80
string title = "none"
string dataobject = "d_sq_tb_itemhist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_search from commandbutton within w_itemdetail
integer x = 1792
integer y = 128
integer width = 366
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Search"
end type

event clicked;
g_Obj.ParamString = sle_num.Text

Open(w_SearchItem)
end event

type cb_prev from commandbutton within w_itemdetail
integer x = 18
integer y = 2416
integer width = 329
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "< &Previous"
end type

event clicked;Integer ls_Sel

dw_Item.Accepttext( )

If dw_item.Modifiedcount( ) > 0 then 
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
integer x = 4005
integer y = 2416
integer width = 329
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Next >"
end type

event clicked;Integer ls_Sel

dw_Item.Accepttext( )

If dw_item.Modifiedcount( ) > 0 then 
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

type st_tip from statictext within w_itemdetail
boolean visible = false
integer x = 1573
integer y = 480
integer width = 622
integer height = 304
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

type cb_viq from commandbutton within w_itemdetail
integer x = 1426
integer y = 128
integer width = 366
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Guide Note"
end type

event clicked;
g_Obj.ParamLong = il_GN

Open(w_Note)

end event

type dw_item from datawindow within w_itemdetail
integer x = 73
integer y = 384
integer width = 2103
integer height = 1952
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

Yield()

// ii_Lock contains following values
// 0 = No Access, 1 = Only comments open, 2 = All except comments, 3 = All except risk

If dwo.tag = "TX" then
	This.Accepttext( )
	g_Obj.ParamString = This.GetItemString(row, String(dwo.name))
	g_Obj.Level = 0  // Assume Lock
	If dwo.Name = "vslcomm" and Mod(ii_Lock, 2) = 1 then g_Obj.Level = 1  // Enable edit
	If dwo.Name = "inspcomm" and (ii_Lock > 1) then g_Obj.Level = 1  // Enable edit
	Open(w_textedit)
	If Not IsNull(g_Obj.ParamString) and (g_Obj.Level = 1) Then This.SetItem(row, String(dwo.name), g_Obj.ParamString)
	g_Obj.Level = 0
End If
end event

event itemchanged;
//If dwo.name = "ans" then
//	If Integer(data)=1 then
//		dw_hist.Visible = True
//		cb_Reset.Visible = True
//		st_Comm.Visible = True
////		cb_comm.Enabled = True
//	Else
//		dw_hist.Visible = False
//		cb_Reset.Visible = False		
//		st_Comm.Visible = False
////		cb_comm.Enabled = False
//	End If
//End If
end event

type cb_cancel from commandbutton within w_itemdetail
integer x = 1682
integer y = 2400
integer width = 402
integer height = 112
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
f_Write2Log("w_ItemDetail Cancel")	

g_Obj.ItemID = 0

Close(Parent)

end event

type cb_save from commandbutton within w_itemdetail
integer x = 1243
integer y = 2400
integer width = 402
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
end type

event clicked;Integer li_Ret, li_Req, li_Ans
Decimal{4} ldec_extnum
String ls_Comm

dw_item.Accepttext( )

// Perform all validation
If g_Obj.ParamLong = 0 then     //  If question No. is required
	If cb_Get.Enabled and ((dw_item.GetItemNumber(1, "Obj_ID") = 0) or IsNull(dw_item.GetItemNumber(1, "Obj_ID"))) then cb_Get.event clicked( )
	If (dw_item.GetItemNumber(1, "Obj_ID") = 0) or IsNull(dw_item.GetItemNumber(1, "Obj_ID")) then
		g_Obj.Level = 0
		Return
	End If
Else     //  Insp has no model
	If dw_item.GetItemNumber(1, "Extnum") = 0 then
		MessageBox("Invalid Number", "Please enter a valid serial number.",Exclamation!)
		g_Obj.Level = 0				
		Return		
	End If
End If

// Check if question number is already in use on another item (CR 2640)
If g_obj.ParamLong = 0 then
	Long ll_ObjID, ll_InspID, ll_ItemID
	ll_ObjID=dw_item.GetItemNumber(1, "Obj_ID")
	ll_InspID=dw_item.GetItemNumber(1, "Insp_ID")
	ll_ItemID=dw_item.GetItemNumber(1, "Item_ID")
	If IsNull(ll_ItemID) Then ll_ItemID=0
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

If IsNull(dw_item.GetItemNumber(1, "Ans")) then  // If no answer selected
	MessageBox("Answer", "Please select an answer for the question.",Exclamation!)
	g_Obj.Level = 0		
	Return
End If	

If dw_item.GetItemNumber(1, "Rect") = 1 then  // If rectified on board, check date
	If IsNull(dw_item.GetItemDateTime(1, "Rect_Date")) then
		MessageBox("Date Required", "Please select the 'Rectified on-board' date.",Exclamation!)
		g_Obj.Level = 0		
		Return		
	End If
End If

If Not IsNull(dw_item.GetItemString(1, "InspComm")) then  // Trim inspectors comments
	ls_Comm = Trim(dw_Item.GetItemString(1, "InspComm"), True)
	If ls_Comm = "" then SetNull(ls_Comm)
	dw_Item.SetItem(1, "InspComm", ls_Comm)
End If

If dw_item.GetItemNumber(1, "Ans") = 1 then   // If 'No' selected, ensure Inspcomm is present
	If IsNull(dw_Item.GetItemString(1, "InspComm")) then 
		MessageBox("Comments Required", "Inspector's comments are required if 'No' is selected for answer", Exclamation!)
		Return
	End If
End If

If Not IsNull(dw_item.GetItemString(1, "VslComm")) then  // Trim vessel comments
	ls_Comm = Trim(dw_Item.GetItemString(1, "VslComm"), True)
	If (Len(ls_Comm) < 5) and (Len(ls_Comm) > 0) then 
		dw_Item.SetItem(1, "VslComm", ls_Comm)
		MessageBox("Vessel Comments", "The Vessel Comments must be at least 5 characters.",Exclamation!)		
		g_Obj.Level = 0
		Return	
	End If
	If ls_Comm = "" then SetNull(ls_Comm)
	dw_Item.SetItem(1, "VslComm", ls_Comm)
End If

ls_Comm = dw_Item.GetItemString(1, "InspComm")
If f_CheckInvalid(ls_Comm) then 
	dw_Item.SetItem(1, "InspComm", ls_Comm)	
	MessageBox("Invalid Characters", "The inspector's comments contained one or more invalid characters that have been replaced by underscores.~n~nPlease check and replace all underscores as appropriate.",Exclamation!)
	g_Obj.Level = 0		
	Return	
End If

ls_Comm = dw_Item.GetItemString(1, "VslComm")
If f_CheckInvalid(ls_Comm) then
	dw_Item.SetItem(1, "VslComm", ls_Comm)	
	MessageBox("Invalid Characters", "The vessel comments contained one or more invalid characters that have been replaced by underscores.~n~nPlease check and replace all underscores as appropriate.",Exclamation!)
	g_Obj.Level = 0		
	Return	
End If

li_Req = dw_item.GetItemNumber(1, "Reqtype")
li_Ans = dw_item.GetItemNumber(1, "Ans")
If IsNull(li_Req) then li_Req = 1   // If null, then set to statutory

If li_Req = 0 then dw_item.SetItem(1, "Ans", 0)

If li_Ans <> 1 then
	dw_item.SetItem(1, "Is_CAP", 0)
	If ii_Lock > 1 then 
		dw_item.SetItem(1, "Closed", 1)
		dw_item.SetItem(1, "Report", 0)
		dw_item.SetItem(1, "Def", 0)
	End If
Else
	If ii_Lock > 1 then 
		dw_item.SetItem(1, "Closed", 0)
		dw_item.SetItem(1, "Report", 1)
		dw_item.SetItem(1, "Def", 1)
	End If
End If

SetPointer(HourGlass!)

// Perform update
If dw_item.Update( ) <> 1 then
	MessageBox("Update Error", "Could not update the database.", Exclamation!)
	Rollback;
	g_Obj.Level = 0		
	f_Write2Log("w_ItemDetail > cb_Save Failed")	
	Return
End If

Commit;

g_Obj.ItemID = dw_Item.GetItemNumber(1, "Item_ID")

f_Write2Log("w_ItemDetail Save Successful")	

Close(Parent)

end event

type st_text from statictext within w_itemdetail
integer x = 73
integer y = 208
integer width = 2085
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
integer y = 128
integer width = 494
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

If g_Obj.ParamLong > 0 then  // Item has no insp model
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

type cb_get from commandbutton within w_itemdetail
integer x = 567
integer y = 128
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
cb_Search.Enabled = False
shl_Feedback.Visible = False
dw_item.SetItem(1, "riskrating", 1)

If Len(ls_Full)<3 then
	MessageBox ("Invalid Number", "Please specify a proper question number.", Exclamation!)
	sle_num.SetFocus( )
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
	sle_num.SetFocus( )
	Return
End If

Declare GetObjID Procedure FOR VETT_GETOBJ @IMID = :g_Obj.Inspmodel, @N1 = :li_Num[1], @N2 = :li_Num[2], @N3 = :li_Num[3], @N4 = :li_Num[4], @N5 = :li_Num[5], @N6 = :li_Num[6];

Execute GetObjID;

If SQLCA.Sqlcode <>0 then 
	Messagebox("DB Error", "Could not execute Stored Procedure.~n~n" + sqlca.sqlerrtext, Exclamation!)
	sle_num.SetFocus( )	
	f_Write2Log("w_ItemDetail > cb_Get > SP VETT_GETOBJ Failed: " + sqlca.SQLErrtext)
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
	MessageBox("Invalid Number", "The number entered refers to a section and not a question in the Inspection Model.")
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

Select	GN.NOTES_ID, 
			UN.NOTES_ID,
			REQTYPE
into  :il_GN,
			:il_UN,
			:li_Risk
from	VETT_OBJ LEFT OUTER JOIN VETT_NOTES GN ON GN.NOTES_ID = VETT_OBJ.OBJNOTE
      LEFT OUTER JOIN VETT_NOTES UN ON UN.NOTES_ID = VETT_OBJ.USERNOTE
where	VETT_OBJ.OBJ_ID = :il_ObjID;

If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could not retrieve extended info from DB.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Rollback;
Else
	Commit;
End If

If IsNull(li_Risk) then li_Risk = 1  // If null, then set Statuatory

dw_item.SetItem(1, "reqtype", li_Risk)  
If li_Risk = 0 then dw_item.SetItem(1, "Ans", 0) else dw_item.SetItem(1, "Ans", 1)
 
cb_VIQ.Enabled = Not IsNull(il_GN)
cb_Search.Enabled = True

f_Write2Log("w_ItemDetail > cb_Get Completed")
end event

type gb_1 from groupbox within w_itemdetail
integer x = 18
integer width = 2176
integer height = 2368
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

type gb_comments from groupbox within w_itemdetail
integer x = 2213
integer width = 2158
integer height = 2368
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

