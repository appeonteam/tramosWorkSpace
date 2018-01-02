$PBExportHeader$w_inspdetail.srw
forward
global type w_inspdetail from window
end type
type cbx_newcomm from checkbox within w_inspdetail
end type
type cb_att from commandbutton within w_inspdetail
end type
type ddlb_officers from dropdownlistbox within w_inspdetail
end type
type st_mat from statictext within w_inspdetail
end type
type st_summ from statictext within w_inspdetail
end type
type cb_quick from commandbutton within w_inspdetail
end type
type cbx_no from checkbox within w_inspdetail
end type
type cb_matrix from commandbutton within w_inspdetail
end type
type cb_viewatt from commandbutton within w_inspdetail
end type
type cb_itematt from commandbutton within w_inspdetail
end type
type cbx_open from checkbox within w_inspdetail
end type
type cb_del from commandbutton within w_inspdetail
end type
type cb_edit from commandbutton within w_inspdetail
end type
type cb_new from commandbutton within w_inspdetail
end type
type dw_items from datawindow within w_inspdetail
end type
type cb_editinsp from commandbutton within w_inspdetail
end type
type dw_insp from datawindow within w_inspdetail
end type
type gb_2 from groupbox within w_inspdetail
end type
type cb_summ from commandbutton within w_inspdetail
end type
type gb_1 from groupbox within w_inspdetail
end type
end forward

global type w_inspdetail from window
integer width = 3351
integer height = 2748
boolean titlebar = true
string title = "Inspection Details"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_newcomm cbx_newcomm
cb_att cb_att
ddlb_officers ddlb_officers
st_mat st_mat
st_summ st_summ
cb_quick cb_quick
cbx_no cbx_no
cb_matrix cb_matrix
cb_viewatt cb_viewatt
cb_itematt cb_itematt
cbx_open cbx_open
cb_del cb_del
cb_edit cb_edit
cb_new cb_new
dw_items dw_items
cb_editinsp cb_editinsp
dw_insp dw_insp
gb_2 gb_2
cb_summ cb_summ
gb_1 gb_1
end type
global w_inspdetail w_inspdetail

type variables

Integer ii_Status, ii_Access, ii_Off
Boolean ibool_Internal, ibool_AutoFill
Datastore ids_Item
end variables

forward prototypes
private subroutine wf_filteritems ()
end prototypes

private subroutine wf_filteritems ();
String ls_Filter

ls_Filter = ""

If g_Obj.login < 2 then // If vessel login, then filter open items
	If cbx_Open.Checked then ls_Filter = "(closed = 0)"
Else  // else filter CAP only
	If cbx_Open.Checked then ls_Filter = "(Is_CAP = 1)"
End If

If cbx_No.Checked then 
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "(Ans = 1)"
End If

If cbx_NewComm.Checked then
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "(NewItem = 0)"
End If

If ii_Off>0 then
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "((Int(-ModelExt/10000)=" + String(ii_Off) + ")"
    ls_Filter += " or (Int(Mod(-ModelExt/100, 100))=" + String(ii_Off) + ")"
	ls_Filter += " or (Mod(-ModelExt,100)=" + String(ii_Off) + "))"	
End If

dw_items.SetFilter(ls_Filter)

dw_items.Filter( )

If dw_items.RowCount() = 0 then
	cb_del.Enabled = False
	cb_edit.Enabled = False
	cb_itematt.Enabled = False
Else
	If Not ibool_AutoFill then cb_del.Enabled = True
	cb_edit.Enabled = True
	cb_ItemAtt.Enabled = True
End If	

end subroutine

on w_inspdetail.create
this.cbx_newcomm=create cbx_newcomm
this.cb_att=create cb_att
this.ddlb_officers=create ddlb_officers
this.st_mat=create st_mat
this.st_summ=create st_summ
this.cb_quick=create cb_quick
this.cbx_no=create cbx_no
this.cb_matrix=create cb_matrix
this.cb_viewatt=create cb_viewatt
this.cb_itematt=create cb_itematt
this.cbx_open=create cbx_open
this.cb_del=create cb_del
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.dw_items=create dw_items
this.cb_editinsp=create cb_editinsp
this.dw_insp=create dw_insp
this.gb_2=create gb_2
this.cb_summ=create cb_summ
this.gb_1=create gb_1
this.Control[]={this.cbx_newcomm,&
this.cb_att,&
this.ddlb_officers,&
this.st_mat,&
this.st_summ,&
this.cb_quick,&
this.cbx_no,&
this.cb_matrix,&
this.cb_viewatt,&
this.cb_itematt,&
this.cbx_open,&
this.cb_del,&
this.cb_edit,&
this.cb_new,&
this.dw_items,&
this.cb_editinsp,&
this.dw_insp,&
this.gb_2,&
this.cb_summ,&
this.gb_1}
end on

on w_inspdetail.destroy
destroy(this.cbx_newcomm)
destroy(this.cb_att)
destroy(this.ddlb_officers)
destroy(this.st_mat)
destroy(this.st_summ)
destroy(this.cb_quick)
destroy(this.cbx_no)
destroy(this.cb_matrix)
destroy(this.cb_viewatt)
destroy(this.cb_itematt)
destroy(this.cbx_open)
destroy(this.cb_del)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.dw_items)
destroy(this.cb_editinsp)
destroy(this.dw_insp)
destroy(this.gb_2)
destroy(this.cb_summ)
destroy(this.gb_1)
end on

event open;String ls_Model
Integer li_Comp
n_miredefault lnvo_mire
n_inspio lnvo_insp

f_Write2Log("w_InspDetail Open")

// ids_Item is used to retrieve a single item and update the same in dw_items
ids_Item = Create Datastore
ids_Item.DataObject = "d_sq_tb_itemsingle"
ids_Item.SetTransObject(SQLCA)

// Init main datawindows
dw_insp.SetTransobject( SQLCA)
dw_items.SetTransobject( SQLCA)

dw_insp.Retrieve(g_Obj.InspID)

// Get status of inspection
ii_Status = dw_insp.GetItemNumber(1, "status")

// Determine if inspection model has officers assigned to questions
If dw_insp.GetItemNumber(1, "MinExtNum") < 0 then 
	ddlb_Officers.AddItem("All Officers")
	ddlb_Officers.AddItem("Master")
	ddlb_Officers.AddItem("Chief Officer")
	ddlb_Officers.AddItem("2nd Officer")
	ddlb_Officers.AddItem("3rd Officer")
	ddlb_Officers.AddItem("Chief Engineer")
	ddlb_Officers.AddItem("2nd Engineer")
	ddlb_Officers.AddItem("3rd Engineer")
	ddlb_Officers.AddItem("4th Engineer")
	ddlb_Officers.AddItem("Maritime Officer")
	ddlb_Officers.AddItem("Gas Engineer")
	ddlb_Officers.AddItem("Electrical Engineer")
	ddlb_Officers.AddItem("Deck Department")
	ddlb_Officers.AddItem("Engine Department")
	ddlb_Officers.SelectItem(1)
	ddlb_Officers.Visible=True
End If

// Determine if Inspection is internal and is MIRE
ls_Model = Upper(dw_insp.GetItemString(1, "ModelName"))
If (Pos(ls_Model, '(INTERNAL)') > 0) Or (Left(ls_Model, 4) = 'MIRE') then	ibool_Internal = True

// User Access Logic
ii_Access = 0
If g_Obj.Install = 0 then   // Vessel Installation
	If g_Obj.Login = 1 then // Vessel Login
		If ii_Status = 0 then
			If ibool_Internal then ii_Access = 1 Else ii_Access = 3
		ElseIf ii_Status = 3 then
			If dw_insp.GetItemNumber(1, "Locked") = 0 then ii_Access = 1
		Else
			ii_Access = 1
		End If
	ElseIf g_Obj.Login = 2 then // Inspector Login
		If ii_Status < 2 then
			If ibool_Internal then
				If g_Obj.Userid = dw_insp.GetItemString(1, "Created") then ii_Access = 2
			End If
		End If
	End If
Else  // Inspector Installation
	If ii_Status = 0 then ii_Access = 2   // If brand new insp, allow inspector access
End If

// Retrieve items
dw_items.Retrieve( g_Obj.InspID)
Commit; 

If g_TestMode then Messagebox("w_inspdetail.open()", "ii_Status=" + String(ii_Status) + " ii_Access=" + String(ii_Access))

// If insp access is restricted
If ii_Access < 2 then
	cb_Del.Visible = False
	cb_EditInsp.Visible = False
	cb_Att.x = cb_EditInsp.x
	cb_Summ.x = cb_Att.x + cb_Att.width
	st_Summ.x = cb_Summ.X + cb_Summ.Width - st_Summ.Width * 2
	cb_New.Visible = False
	cb_ItemAtt.X = cb_Edit.X
	cb_Edit.X = cb_New.X
	cb_Edit.Text = "Open Item"
	cb_itematt.Text = "Attachments"
	cbx_open.x -= cb_New.Width
	cbx_no.x -= cb_New.Width
	cbx_NewComm.x -= cb_New.Width
	cb_Quick.Enabled = False
Else
	cb_EditInsp.Enabled = True
	cb_New.Enabled = True
	cbx_NewComm.Visible = False   // Not required if insp is open (overlaps with Del button)
End If

// Check if default items need to be added to MIRE
If ibool_internal and ii_Status < 2 then
	If (Left(dw_insp.GetItemString(1, "modelname"), 4) = "MIRE") and (dw_items.RowCount( ) + dw_items.FilteredCount() = 0) then
		lnvo_mire = Create n_miredefault
		li_Comp = lnvo_mire.of_adddefaultitems(g_Obj.InspId, dw_insp.GetItemNumber(1, "imid"), dw_insp.GetItemString(1, "VesselName"), String(dw_insp.GetItemNumber(1, "VesselIMO")), String(dw_insp.GetItemDateTime(1, "InspDate"), "dd mmm yyyy"), dw_insp.GetItemString(1, "Ports_Port_n"), dw_insp.GetItemString(1, "InspName") )
		Destroy lnvo_mire
		If li_Comp < 0 then
			MessageBox("DB Error", "Unable to add MIRE items.", Exclamation!)
			f_Write2Log("w_InspDetail > lnvo_mire.of_AddDefaultItems() Failed")
			Return
		End If
		f_Write2Log("w_InspDetail > lnvo_mire.of_AddDefaultItems() Successful")
		dw_Items.Retrieve(g_Obj.InspID)
	End If
	If (g_Obj.Login = 2) and (dw_insp.GetItemNumber(1, "autofill")=1) then cb_Quick.Visible = True  // For MIRE inspectors
End If

// Check if this a autofill insp and fill all items
If ii_Status<2 then
	If (dw_insp.GetItemNumber(1, "autofill")=1) and (dw_items.RowCount( ) + dw_items.FilteredCount() = 0) then		
		li_Comp = lnvo_insp.of_autofillinsp( g_Obj.InspId, dw_insp.GetItemNumber(1, "imid"))
		If li_Comp < 0 then
			MessageBox("DB Error", "Unable to add default items to inspection.", Exclamation!)
			f_Write2Log("w_InspDetail > lnvo_insp.of_AutoFillInsp() Failed")
			Return
		End If
		f_Write2Log("w_InspDetail > lnvo_insp.of_AutoFillInsp() Successful")		
		dw_Items.Retrieve(g_Obj.InspID)
	End If
End If

// Hide Add and Del buttons for autofill inspections
If dw_insp.GetItemNumber(1, "autofill") = 1 then
	ibool_AutoFill = True
	cb_New.Enabled = False
	cb_Del.Enabled = False
	cb_New.Visible = False
	cb_Del.Visible = False
	If cb_Edit.x > cb_New.X then cb_ItemAtt.X = cb_Edit.X
	cb_Edit.X = cb_New.X	
End If

If g_Obj.Login < 2 then  // If user is vessel, hide the risk rating
	dw_items.object.Rating.Visible = False
Else
	cbx_Open.Text = "CAP Only"  // otherwise, change 'Open Items Only' to 'CAP Only' for inspectors
End If

// If not MIRE model, then hide matrix and summary buttons
If Left(dw_insp.GetItemString(1, "modelname"), 4) <> "MIRE" then
	cb_Summ.Enabled = False
	//cb_Matrix.Enabled = False
	st_Summ.Visible = False
	//st_Mat.Visible = False
End If

end event

event close;
g_Obj.Inspid = dw_insp.GetItemNumber(1, "Insp_ID")
	
Destroy ids_Item
	
// Release lock
Update VETT_INSP Set USER_LOCK = Null Where INSP_ID = :g_Obj.Inspid;

If SQLCA.SQLcode <> 0 then 
	Messagebox("DB Error", "Could not release inspection lock.~n~n" + SQLCA.SQLErrtext,Exclamation!)
	Rollback;
Else
	Commit;
End If

w_back.wf_calc()

f_Write2Log("w_InspDetail Close")
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1800)
end event

type cbx_newcomm from checkbox within w_inspdetail
integer x = 2414
integer y = 2544
integer width = 695
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "With New Comments Only"
end type

event clicked;
wf_filteritems( )
end event

type cb_att from commandbutton within w_inspdetail
integer x = 494
integer y = 560
integer width = 443
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Header Att."
end type

event clicked;
g_Obj.InspID = dw_Insp.GetItemNumber(1, "Insp_ID")
g_Obj.Level = 1  // Indicates attachments for header
g_Obj.ParamInt = ii_Access

Open(w_attlist)

end event

type ddlb_officers from dropdownlistbox within w_inspdetail
boolean visible = false
integer x = 2725
integer y = 736
integer width = 549
integer height = 816
integer taborder = 90
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
Choose Case index
	Case 1
		ii_Off = 0
	Case 2 to 5
		ii_Off = index * 5
	Case 6 to 14
		ii_Off = index * 5 + 20
End Choose

wf_FilterItems( )


end event

type st_mat from statictext within w_inspdetail
boolean visible = false
integer x = 2523
integer y = 32
integer width = 37
integer height = 32
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 8388736
long backcolor = 65280
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_summ from statictext within w_inspdetail
integer x = 1298
integer y = 592
integer width = 37
integer height = 32
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 8388736
long backcolor = 65280
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_quick from commandbutton within w_inspdetail
boolean visible = false
integer x = 603
integer y = 720
integer width = 494
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Quick Edit"
end type

event clicked;
If Left(Upper(dw_insp.GetItemString(1, "ModelName")), 4) = "MIRE" then g_Obj.Level = 1 Else g_Obj.Level = 0

Open(w_QuickEdit)

If g_Obj.Level = 1 then dw_items.Retrieve(g_Obj.InspID)
end event

type cbx_no from checkbox within w_inspdetail
integer x = 1426
integer y = 2528
integer width = 457
integer height = 96
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "~'No~' Items Only"
end type

event clicked;
wf_filteritems( )
end event

type cb_matrix from commandbutton within w_inspdetail
boolean visible = false
integer x = 2030
integer width = 590
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Officer Matrix - Obsolete"
end type

event clicked;
g_Obj.Inspid = dw_insp.GetItemNumber(1, "Insp_ID")
g_Obj.ParamString = String(dw_insp.GetItemDateTime(1, "Inspdate"), "yyyyMMdd")  // To verify date on matrix sheet
g_Obj.ParamInt = ii_Access

Open(w_Matrix)

If g_Obj.ParamInt > 0 then st_Mat.BackColor = 65280 Else st_Mat.BackColor = 255
end event

type cb_viewatt from commandbutton within w_inspdetail
integer x = 2560
integer y = 560
integer width = 713
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&View All Attachments"
end type

event clicked;
g_Obj.Inspid = dw_insp.GetItemNumber(1, "Insp_ID")

OpenWithParm(w_AttFull, g_Obj.InspID)

Do While Message.DoubleParm > 0
	If Message.Doubleparm = 1 then OpenWithParm(w_AttFull, g_Obj.InspID) Else OpenWithParm(w_Thumbs, g_Obj.InspID)
Loop

end event

type cb_itematt from commandbutton within w_inspdetail
integer x = 933
integer y = 2528
integer width = 421
integer height = 96
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Item &Att."
end type

event clicked;
g_Obj.Inspid = dw_Insp.GetItemNumber(1, "Insp_ID")
g_Obj.ItemID  = dw_Items.GetItemNumber( dw_items.GetRow(), "Item_ID")
g_Obj.Level = 0  // Indicates attachments for items
g_Obj.ParamInt = ii_Access

Open(w_attlist)

dw_items.SetItem( dw_Items.GetRow(), "attcount", g_Obj.ParamLong)   // Set num of att

end event

type cbx_open from checkbox within w_inspdetail
integer x = 1902
integer y = 2528
integer width = 475
integer height = 96
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Open Items Only"
end type

event clicked;
wf_filteritems( )
end event

type cb_del from commandbutton within w_inspdetail
integer x = 2853
integer y = 2528
integer width = 421
integer height = 96
integer taborder = 170
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete Item"
end type

event clicked;Integer li_Status

li_Status = dw_insp.GetItemNumber(1, "Status")

If (li_Status > 0) then   //  Check if insp is exported
	Messagebox("Access Denied", "The inspection has already been exported. Items can only be removed by the Vetting Dept.",Exclamation!)
	Return
End If

If dw_items.GetItemNumber(dw_Items.GetRow(), "Attcount")>0 then 
	MessageBox("Attachments", "The selected item has attachments. Please remove the attachments before deleting this item.", Exclamation!)
	Return
End If
	
If MessageBox("Confirm Delete", "Are you sure you want to delete the selected item?", Question!, YesNo!) = 2 then Return

g_Obj.ItemID = dw_items.GetItemNumber( dw_Items.GetRow(), "Item_ID")

Delete from VETT_ITEMHIST where ITEM_ID = :g_Obj.ItemID;

If SQLCA.SQlcode >= 0 then 
	Delete from VETT_ITEM where ITEM_ID = :g_Obj.ItemID;
End If

If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could not delete the item.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	f_Write2Log("w_InspDetail > cb_Del: " + SQLCA.SQLErrText)	
	Rollback;
Else
	Messagebox("Deleted", "The selected item was deleted.")
	f_Write2Log("w_InspDetail > cb_Del: Successful")
	Commit;
End If

dw_items.DeleteRow(dw_items.GetRow())
dw_Items.Resetupdate( )

g_Obj.Inspid = dw_insp.GetItemNumber( 1, "Insp_ID")

f_UpdateLastEdit(g_Obj.InspID)
dw_insp.Retrieve(g_Obj.InspID)

w_Back.wf_Calc()

If dw_items.Rowcount( ) = 0 then 
	cb_del.Enabled = False
	cb_edit.Enabled = False
	cb_itematt.Enabled = False
End If

end event

type cb_edit from commandbutton within w_inspdetail
integer x = 494
integer y = 2528
integer width = 439
integer height = 96
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Modify &Item"
end type

event clicked;Integer li_Locked, li_CurRow, li_Comp
String ls_Model

SetPointer(HourGlass!)

// Remember current row
li_CurRow = dw_Items.GetRow()

// Set all info to pass to w_ItemDetail
g_Obj.ItemID = dw_items.GetItemNumber( li_CurRow, "Item_ID")
g_Obj.InspModel = dw_insp.GetItemNumber(1, "ImID")
g_Obj.Inspid = dw_insp.GetItemNumber(1, "Insp_ID")
g_Obj.ParamString = "Edit"
If ibool_AutoFill then g_Obj.ParamString += "Auto"
g_Obj.ParamLong = dw_insp.GetItemNumber(1, "ExtModel")
g_Obj.ParamInt = ii_Access + ii_Status * 100

//  Set navigation buttons in w_itemdetail, 0 = None, 1 = Prev, 2 = Next, 3 = Both
g_Obj.Level = 0
If li_CurRow > 1 then g_Obj.Level += 1
If li_CurRow < dw_items.RowCount( ) then g_Obj.Level += 2

Open(w_Itemdetail)

// If Item was modified
If g_Obj.ItemID > 0 then
	If ids_Item.Retrieve(g_Obj.ItemID) <> 1 then 
		Messagebox("DB Error", "Could not refresh the item in this list.", Exclamation!)
	Else
		If ii_access < 2 then
			dw_Items.SetItem(li_CurRow, "NewItem", ids_Item.GetItemNumber(1, "NewItem"))
			dw_Items.SetItem(li_CurRow, "VslComm", ids_Item.GetItemString(1, "VslComm"))
		Else
			dw_Items.SetItem(li_CurRow, "TextData", ids_Item.GetItemString(1, "TextData"))
			dw_Items.SetItem(li_CurRow, "InspComm", ids_Item.GetItemString(1, "InspComm"))
			dw_Items.SetItem(li_CurRow, "VslComm", ids_Item.GetItemString(1, "VslComm"))
			dw_Items.SetItem(li_CurRow, "TextData", ids_Item.GetItemString(1, "TextData"))
			dw_Items.SetItem(li_CurRow, "Guide", ids_Item.GetItemNumber(1, "Guide"))
			dw_Items.SetItem(li_CurRow, "Ans", ids_Item.GetItemNumber(1, "Ans"))
			dw_Items.SetItem(li_CurRow, "Report", ids_Item.GetItemNumber(1, "Report"))
			dw_Items.SetItem(li_CurRow, "Is_CAP", ids_Item.GetItemNumber(1, "Is_CAP"))
			dw_Items.SetItem(li_CurRow, "Risk", ids_Item.GetItemNumber(1, "Risk"))
			dw_Items.SetItem(li_CurRow, "ExtNum", ids_Item.GetItemNumber(1, "ExtNum"))
			dw_Items.SetItem(li_CurRow, "RiskRating", ids_Item.GetItemNumber(1, "RiskRating"))
			dw_Items.SetItem(li_CurRow, "ObjNum", ids_Item.GetItemNumber(1, "ObjNum"))
			dw_Items.SetItem(li_CurRow, "P1Num", ids_Item.GetItemNumber(1, "P1Num"))
			dw_Items.SetItem(li_CurRow, "P1Type", ids_Item.GetItemNumber(1, "P1Type"))
			dw_Items.SetItem(li_CurRow, "P2Num", ids_Item.GetItemNumber(1, "P2Num"))
			dw_Items.SetItem(li_CurRow, "P2Type", ids_Item.GetItemNumber(1, "P2Type"))
			dw_Items.SetItem(li_CurRow, "P3Num", ids_Item.GetItemNumber(1, "P3Num"))
			dw_Items.SetItem(li_CurRow, "P3Type", ids_Item.GetItemNumber(1, "P3Type"))
		End If
	End If
End If

Commit;

// If navigation buttons were pressed in w_itemdetail
If g_Obj.Level = 1 then	li_CurRow --
If g_Obj.Level = 2 then	li_CurRow ++
If g_Obj.Level > 0 then
	dw_items.SetRow(li_CurRow) 
	dw_items.ScrollToRow(li_CurRow)
	This.PostEvent(Clicked!)
End If



end event

type cb_new from commandbutton within w_inspdetail
integer x = 55
integer y = 2528
integer width = 439
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Add &New Item"
end type

event clicked;Integer li_Status, li_Comp

SetPointer(HourGlass!)
g_Obj.ParamString = "New"
g_Obj.ItemID = 0
g_Obj.InspModel = dw_insp.GetItemNumber(1, "ImID")
g_Obj.InspId = dw_insp.GetItemNumber(1, "Insp_ID")
g_Obj.ParamLong = dw_insp.GetItemNumber(1, "ExtModel")
g_Obj.level = 10  //  No navigation buttons enabled in w_itemdetail
g_Obj.ParamInt = ii_Access

Open(w_itemdetail)

If g_Obj.ItemID > 0 then
	dw_items.Retrieve(g_Obj.InspID)
	dw_items.SetRow( dw_Items.GetRow())
	dw_items.ScrollToRow( dw_Items.GetRow())
	cb_edit.Enabled = True
	cb_del.Enabled = True
	cb_itematt.Enabled = True
	f_UpdateLastEdit(g_Obj.InspID)
	dw_insp.Retrieve(g_Obj.InspID)
	w_Back.wf_Calc()
	// Find and select the new item
	li_Comp = dw_items.Find( "Item_ID = " + String(g_Obj.ItemID), 0, dw_Items.RowCount())
	g_Obj.Level = 0  // To avoid scroll events
	If li_Comp > 0 then
		dw_items.SetRow(li_Comp)
		dw_items.ScrollTorow(li_Comp)
	End If	
End If

Commit;

end event

type dw_items from datawindow within w_inspdetail
integer x = 55
integer y = 816
integer width = 3218
integer height = 1712
integer taborder = 110
string title = "none"
string dataobject = "d_sq_tb_items"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If (rowcount > 0) then
	If (ii_Access > 1) and Not ibool_AutoFill then cb_del.Enabled = True
	cb_edit.Enabled = True
else
	cb_del.Enabled = False
	cb_edit.Enabled = False
End If	

If rowcount > 0 then cb_itematt.Enabled = True else cb_itematt.Enabled = False
end event

event buttonclicked;
If dwo.Tag = "G" then 
	g_Obj.ParamLong = This.GetItemNumber( row, "guide")
	Open(w_note)
End If
end event

event scrollvertical;
//If g_Obj.Level = 0 then This.SetRow(Integer(This.Object.Datawindow.FirstRowOnPage))

// Set row only if not auto-navigating
end event

event doubleclicked;

If (row > 0) and cb_edit.enabled then cb_edit.event clicked( )
end event

type cb_editinsp from commandbutton within w_inspdetail
integer x = 55
integer y = 560
integer width = 439
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Modify Header"
end type

event clicked;
SetPointer (HourGlass!)

g_Obj.ParamString = "Edit"

Open(w_newinsp)

If g_Obj.ParamString > "" then dw_insp.Retrieve(g_Obj.InspID)

g_Obj.ParamString = ""

Commit;
end event

type dw_insp from datawindow within w_inspdetail
integer x = 55
integer y = 96
integer width = 3218
integer height = 464
integer taborder = 20
string title = "none"
string dataobject = "d_sq_ff_inspheader"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;

If RowCount > 0 then 
	cb_ViewAtt.Text = "View All Attachments (" + String(dw_insp.GetItemNumber(1, "AttCount")) + ")"
	If dw_Insp.GetItemNumber(1, "MatCount") = 0 then st_Mat.Backcolor = 255 Else st_Mat.BackColor = 65280
	If dw_Insp.GetItemNumber(1, "SummCount") = 0 then 
		st_Summ.BackColor = 255 
	Else
		If dw_Insp.GetItemNumber(1, "SummCount") > dw_Insp.GetItemNumber(1, "SummText") then st_Summ.Backcolor = 65535 Else st_Summ.Backcolor = 65280
	End If
End If
end event

event doubleclicked;
If (row>0) and cb_editinsp.Visible then cb_editinsp.event clicked( )
end event

type gb_2 from groupbox within w_inspdetail
integer x = 18
integer y = 736
integer width = 3291
integer height = 1904
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 8388736
long backcolor = 67108864
string text = "Inspection Items"
end type

type cb_summ from commandbutton within w_inspdetail
integer x = 933
integer y = 560
integer width = 439
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Summary    "
end type

event clicked;
g_Obj.Inspid = dw_insp.GetItemNumber(1, "Insp_ID")
g_Obj.ParamInt = ii_Access
Open(w_Summary)

If g_Obj.Level = 0 then st_Summ.BackColor = 255
If g_Obj.Level = 1 then st_Summ.BackColor = 65535
If g_Obj.Level = 2 then st_Summ.BackColor = 65280
end event

type gb_1 from groupbox within w_inspdetail
integer x = 18
integer width = 3291
integer height = 688
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 8388736
long backcolor = 67108864
string text = "Inspection Header"
end type

