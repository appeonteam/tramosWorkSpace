$PBExportHeader$w_model.srw
forward
global type w_model from window
end type
type st_copy from statictext within w_model
end type
type cb_cancel from commandbutton within w_model
end type
type cb_paste from commandbutton within w_model
end type
type cb_copy from commandbutton within w_model
end type
type cb_notes from commandbutton within w_model
end type
type hpb_prg from hprogressbar within w_model
end type
type cb_viq from commandbutton within w_model
end type
type st_2 from statictext within w_model
end type
type tv_con from treeview within w_model
end type
type cb_itemedit from commandbutton within w_model
end type
type cb_itemdel from commandbutton within w_model
end type
type cb_itemnew from commandbutton within w_model
end type
type cb_modeldel from commandbutton within w_model
end type
type cb_modeledit from commandbutton within w_model
end type
type cb_modeldup from commandbutton within w_model
end type
type cb_modeladd from commandbutton within w_model
end type
type st_1 from statictext within w_model
end type
type dw_model from datawindow within w_model
end type
end forward

global type w_model from window
integer width = 3717
integer height = 2124
boolean titlebar = true
string title = "Inspection Models"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Model.ico"
boolean center = true
event ue_printmodel ( integer ai_type )
st_copy st_copy
cb_cancel cb_cancel
cb_paste cb_paste
cb_copy cb_copy
cb_notes cb_notes
hpb_prg hpb_prg
cb_viq cb_viq
st_2 st_2
tv_con tv_con
cb_itemedit cb_itemedit
cb_itemdel cb_itemdel
cb_itemnew cb_itemnew
cb_modeldel cb_modeldel
cb_modeledit cb_modeledit
cb_modeldup cb_modeldup
cb_modeladd cb_modeladd
st_1 st_1
dw_model dw_model
end type
global w_model w_model

type variables

Long il_InspID, il_SelHnd, il_objid, il_NewInspID, il_ObjIDBuf[]

Integer ii_ObjTypeBuf, ii_BufCount

Boolean lbool_VettSuperUser

m_modelprint im_Print
end variables

forward prototypes
public subroutine wf_populatetree (long al_objid, integer ai_handle)
public function string wf_copytree (long parentid, long newid)
public subroutine wf_drawtree (integer ai_row)
public function string wf_getobjtype (integer ai_objtype)
public function boolean wf_copyitem (long ai_objid, long ai_newparent)
end prototypes

event ue_printmodel(integer ai_type);Integer li_Risk
SetNull(li_Risk)

SetPointer(HourGlass!)

g_obj.InspModel = dw_Model.GetItemNumber( dw_Model.GetRow(), "IM_ID")
g_Obj.Level = 200

// Check if officers are assigned in model questions and show selection dialog
If (ai_type < 3) and dw_Model.GetItemNumber(dw_Model.GetRow(), "MinExtNum") < 0 then
	Open(w_Select)
	If g_Obj.Level = 250 then Return
End If

OpenSheet(w_preview, w_main, 0, Original!)

Choose Case ai_type
	Case 1
		If g_Obj.Level = 200 then 
			w_preview.dw_rep.dataobject = "d_rep_modelviq"
		Else
			w_preview.dw_rep.dataobject = "d_rep_modelviq_officer"
			w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_model_officer"
		End If
	Case 2
		If g_Obj.Level = 200 then 
			w_preview.dw_rep.dataobject = "d_rep_modelviq"
			w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_model_noguide"
		Else
			w_preview.dw_rep.dataobject = "d_rep_modelviq_officer"
			w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_model_officer_noguide"			
		End If
	Case 3
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a4"
	Case 4
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a4"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_roviq_a4_noguide"
	Case 5
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a5"
	Case 6
		w_preview.dw_rep.dataobject = "d_rep_modelroviq_a5"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_tb_roviq_a5_noguide"
	Case 7
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk_noguide"
	Case 8
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk"
	Case 9
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk"
		li_Risk=0
	Case 10
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk"
		li_Risk=1
	Case 11
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk"
		li_Risk=2
	Case 12
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk_noguide"
		li_Risk=0
	Case 13
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk_noguide"
		li_Risk=1
	Case 14
		w_preview.dw_rep.dataobject = "d_rep_modelviq"
		w_preview.dw_rep.object.dw_main.dataobject = "d_sq_ff_modelbyrisk_noguide"
		li_Risk=2
End Choose

w_preview.dw_rep.SetTransObject(SQLCA)

If g_Obj.Level = 200 then  // No officer selection
	w_preview.dw_rep.Retrieve(g_Obj.inspmodel, li_Risk)
Else	
	w_preview.dw_rep.Retrieve(g_Obj.inspmodel, g_Obj.Level)
End If

w_preview.wf_ShowReport()
end event

public subroutine wf_populatetree (long al_objid, integer ai_handle);// This function creates the tree by calling itself recursively

// Parameters
// al_objid    : The id of the current object
// ai_handle   : The handle of the current treeviewitem


Long ll_Count, ll_Handle
Integer li_ReqType
datastore ds_obj
treeviewitem ltvi_x

ds_Obj = Create datastore
ds_Obj.DataObject = "d_sq_tb_obj"
ds_Obj.SetTransObject (SQLCA)
ds_Obj.Retrieve( il_InspID, al_ObjID)  // Get all children of current object

// Advance progress bar
hpb_prg.stepit( )
if al_ObjID=27680 then debugbreak()

If ds_Obj.RowCount( ) > 0 then  // If there are children present

	For ll_Count = 1 to ds_Obj.rowcount( )  // Step thru all children
		
		// Get the text of the child
		ltvi_x.label = String(ds_Obj.GetItemNumber(ll_Count, "ObjNum")) + ". " + ds_Obj.GetItemString(ll_Count, "textdata")
		
		// Make it bold if it is a chapter
		If ds_Obj.GetItemNumber(ll_Count, "ObjType") = 1 then ltvi_x.Bold = True else ltvi_x.Bold = False
		
		// Set the data string for the child that holds its object id and type
		ltvi_x.data = String(ds_Obj.GetItemNumber(ll_Count, "Obj_ID"), "000000000000") + String(ds_Obj.GetItemNumber(ll_Count, "ObjType"), "00")
		
		// Set default picture
		ltvi_x.PictureIndex = 8
		ltvi_x.SelectedPictureIndex = 8
		
		// Set picture as per type
		Choose Case ds_Obj.GetItemNumber(ll_Count, "ObjType") 
			Case 1
				ltvi_x.Pictureindex = 6
				ltvi_x.Selectedpictureindex = 6
			Case 2
				ltvi_x.Pictureindex = 7
				ltvi_x.Selectedpictureindex = 7
			Case 3,4
				li_ReqType = ds_Obj.GetItemNumber(ll_Count, "ReqType") 
				if Not IsNull(li_ReqType) then
					If li_ReqType = 0 then li_ReqType = 9
					ltvi_x.Pictureindex = li_ReqType
					ltvi_x.Selectedpictureindex = li_ReqType
				End If
		End Choose
		
		// Insert the child into the tree and get back handle
		ll_Handle = tv_con.insertitemlast(ai_handle, ltvi_x)
		
		// If the child has children call function recursively for this child
		If ds_Obj.GetItemNumber(ll_Count, "NumChild") > 0 then wf_populatetree( Long(left(ltvi_x.data, 12)), ll_Handle)
		
	Next
End If

Destroy ds_Obj
end subroutine

public function string wf_copytree (long parentid, long newid);
datastore ds_1, ds_2
integer li_count, li_newrow
String ls_ret

ds_1 = Create datastore
ds_2 = Create datastore
ds_1.DataObject = "d_sq_tb_obj"
ds_2.DataObject = "d_sq_tb_obj"
ds_1.SetTransObject( SQLCA)
ds_2.SetTransObject( SQLCA)

ds_1.Retrieve(il_inspid, parentid )

ls_ret = ""

For li_count = 1 to ds_1.RowCount()
	li_newrow = ds_2.Insertrow(0)
	ds_2.SetItem(li_newrow, "IM_ID", il_newinspid)
	ds_2.SetItem(li_newrow, "OBJTYPE", ds_1.GetItemNumber(li_count, "OBJTYPE"))
	ds_2.SetItem(li_newrow, "OBJTEXT", ds_1.GetItemNumber(li_count, "OBJTEXT"))
	ds_2.SetItem(li_newrow, "OBJNOTE", ds_1.GetItemNumber(li_count, "OBJNOTE"))
	ds_2.SetItem(li_newrow, "PARENT", NewID)
	ds_2.SetItem(li_newrow, "REQTYPE", ds_1.GetItemNumber(li_count, "REQTYPE"))
	ds_2.SetItem(li_newrow, "OBJNUM", ds_1.GetItemNumber(li_count, "OBJNUM"))
	ds_2.SetItem(li_newrow, "DEFRISK", ds_1.GetItemNumber(li_count, "DEFRISK"))
	ds_2.SetItem(li_newrow, "USERNOTE", ds_1.GetItemNumber(li_count, "USERNOTE"))
	ds_2.SetItem(li_newrow, "RISKRATING", ds_1.GetItemNumber(li_count, "RISKRATING"))
	ds_2.SetItem(li_newrow, "AUTOREPLY", ds_1.GetItemNumber(li_count, "AUTOREPLY"))
	ds_2.SetItem(li_newrow, "EXTNUM", ds_1.GetItemNumber(li_count, "EXTNUM"))
	ds_2.SetItem(li_newrow, "ACTIVE", ds_1.GetItemNumber(li_count, "ACTIVE"))
	ds_2.SetItem(li_newrow, "SECTMAIN", ds_1.GetItemNumber(li_count, "SECTMAIN"))
	ds_2.SetItem(li_newrow, "SECTHEAD", ds_1.GetItemNumber(li_count, "SECTHEAD"))
	ds_2.SetItem(li_newrow, "SECTMAINNOTE", ds_1.GetItemNumber(li_count, "SECTMAINNOTE"))
	ds_2.SetItem(li_newrow, "SECTHEADNOTE", ds_1.GetItemNumber(li_count, "SECTHEADNOTE"))
	
    If ds_2.Update( ) = 1 then
		ls_ret = wf_copytree( ds_1.GetItemNumber(li_count, "OBJ_ID")  , ds_2.GetItemNumber(li_newrow, "OBJ_ID") )
	Else
		ls_ret = "Update Error"
	End If
Next

destroy ds_1
destroy ds_2

Return ls_Ret
end function

public subroutine wf_drawtree (integer ai_row);Long ll_Root
Treeviewitem ltvi_x

cb_viq.enabled = True

il_InspID = dw_Model.GetItemNumber(ai_row, "IM_ID")

ll_Root = tv_con.Finditem( RootTreeItem!, 0)  
if ll_Root>=0 then tv_con.DeleteItem(ll_Root)   // Clear Tree

If dw_Model.GetItemNumber(ai_Row, "ExtModel") > 0 then Return

ltvi_x.label = dw_Model.GetItemString(ai_Row, "Name")
ltvi_x.data = String(il_inspid, "000000000000") + "00"
ltvi_x.Pictureindex = 5
ltvi_x.SelectedPictureindex = 5
ltvi_x.bold = True

ll_Root = tv_con.InsertItemFirst(0, ltvi_x)

tv_con.SetRedraw(False)

hpb_prg.Position = 0
hpb_prg.visible = True

wf_PopulateTree(il_Inspid, ll_Root)

tv_con.setredraw(True)

hpb_prg.visible = False
end subroutine

public function string wf_getobjtype (integer ai_objtype);
Choose Case ai_ObjType
	Case 0
		Return "Model"
	Case 1
		Return "Chapter"
	Case 2
		Return "Section"
	Case 3
		Return "Question"
	Case 4
		Return "Sub-question"
	Case Else
		Return "<Invalid>"
End Choose
			
end function

public function boolean wf_copyitem (long ai_objid, long ai_newparent);Integer li_IMID, li_Num, li_Req
String ls_Err

li_IMID = dw_model.GetItemNumber( dw_Model.GetRow(), "IM_ID")

Insert Into VETT_OBJ (IM_ID, OBJTYPE, OBJTEXT, PARENT, REQTYPE, OBJNUM, OBJNOTE, DEFRISK, USERNOTE, AUTOREPLY, RISKRATING, EXTNUM, SECTMAIN, SECTHEAD, SECTMAINNOTE, SECTHEADNOTE)
Select :li_IMID, OBJTYPE, OBJTEXT, :ai_NewParent, REQTYPE, OBJNUM, OBJNOTE, DEFRISK, USERNOTE, AUTOREPLY, RISKRATING, EXTNUM, SECTMAIN, SECTHEAD, SECTMAINNOTE, SECTHEADNOTE
From VETT_OBJ Where OBJ_ID = :ai_ObjID;

If SQLCA.SQLCode<>0 then 
	MessageBox("DB Error", "An error occurred while copying the item. An item with the same number already exists.", Exclamation!)
	Rollback;
	Return False
Else
	Commit;

	Select Max(OBJ_ID) Into :g_Obj.ObjID from VETT_OBJ;
	Commit;
		
	// Get some info to update tree
	Select OBJNUM, TEXTDATA, REQTYPE 
	Into :li_Num, :g_Obj.ObjString, :li_Req
	From VETT_OBJ Inner Join VETT_TEXT On OBJTEXT=TEXT_ID
	Where OBJ_ID = :ai_ObjID;
	Commit;
	
	g_Obj.ObjType = ii_ObjTypeBuf
	g_obj.ObjString = String(li_Num) + ". " + g_Obj.ObjString
	g_obj.Reqtype = li_Req
	Return True
End If
end function

on w_model.create
this.st_copy=create st_copy
this.cb_cancel=create cb_cancel
this.cb_paste=create cb_paste
this.cb_copy=create cb_copy
this.cb_notes=create cb_notes
this.hpb_prg=create hpb_prg
this.cb_viq=create cb_viq
this.st_2=create st_2
this.tv_con=create tv_con
this.cb_itemedit=create cb_itemedit
this.cb_itemdel=create cb_itemdel
this.cb_itemnew=create cb_itemnew
this.cb_modeldel=create cb_modeldel
this.cb_modeledit=create cb_modeledit
this.cb_modeldup=create cb_modeldup
this.cb_modeladd=create cb_modeladd
this.st_1=create st_1
this.dw_model=create dw_model
this.Control[]={this.st_copy,&
this.cb_cancel,&
this.cb_paste,&
this.cb_copy,&
this.cb_notes,&
this.hpb_prg,&
this.cb_viq,&
this.st_2,&
this.tv_con,&
this.cb_itemedit,&
this.cb_itemdel,&
this.cb_itemnew,&
this.cb_modeldel,&
this.cb_modeledit,&
this.cb_modeldup,&
this.cb_modeladd,&
this.st_1,&
this.dw_model}
end on

on w_model.destroy
destroy(this.st_copy)
destroy(this.cb_cancel)
destroy(this.cb_paste)
destroy(this.cb_copy)
destroy(this.cb_notes)
destroy(this.hpb_prg)
destroy(this.cb_viq)
destroy(this.st_2)
destroy(this.tv_con)
destroy(this.cb_itemedit)
destroy(this.cb_itemdel)
destroy(this.cb_itemnew)
destroy(this.cb_modeldel)
destroy(this.cb_modeledit)
destroy(this.cb_modeldup)
destroy(this.cb_modeladd)
destroy(this.st_1)
destroy(this.dw_model)
end on

event open;Integer li_Wid, li_Hgt
String ls_Temp

dw_model.settransobject( SQLCA )
dw_model.Retrieve( )

If (g_Obj.Access = 3) and (g_Obj.DeptID = 1) then 
	cb_modeladd.Enabled = True
	lbool_VettSuperUser = True
End If

im_Print = Create m_modelprint

f_Registry("w_model_w", ls_Temp, False)
li_Wid = Integer(ls_Temp)
f_Registry("w_model_h", ls_Temp, False)
li_Hgt = Integer(ls_Temp)

If (li_wid > 500) and (li_Hgt > 500) then
	If li_Wid > This.Parentwindow( ).WorkspaceWidth( ) then li_Wid = This.Parentwindow( ).WorkspaceWidth( )
	If li_Hgt > This.Parentwindow( ).WorkspaceHeight( ) then li_Hgt = This.Parentwindow( ).WorkspaceHeight( )
	This.Width = li_Wid
	This.Height = li_Hgt
	This.X = (this.parentwindow( ).workspaceWidth( ) - li_Wid) / 2
	This.Y = (this.parentwindow( ).workspaceHeight( ) - li_Hgt) / 2
End If

If lbool_VettSuperUser and (g_obj.DBModif = 0) then Post Messagebox("Warning", "Any modification to the inspection models (internal or external) will require a new database update to be issued for VIMS Mobile.")
end event

event resize;integer li_x, li_spc

li_spc = dw_model.x

dw_model.width = newwidth - (li_spc * 2)
tv_con.width = newwidth - (li_spc * 2)

li_x = newheight - tv_con.y - li_spc - cb_itemdel.height
if li_x < 100 then li_x = 100
tv_con.height = li_x

li_x +=  tv_con.y 
cb_itemdel.y = li_x
cb_itemedit.y = li_x
cb_itemnew.y = li_x

li_x = newwidth - cb_itemdel.width - li_spc
if li_x < cb_modeledit.x + cb_modeledit.width then li_x = cb_modeledit.x + cb_modeledit.width
cb_itemdel.x = li_x
cb_modeldel.x = li_x

li_x = newwidth - (cb_copy.width*3) - li_spc - st_Copy.Width 
If li_x < hpb_prg.x + hpb_prg.width then li_x = hpb_prg.x + hpb_prg.width
st_Copy.x = li_x
cb_Copy.x = li_x + st_Copy.Width
cb_Paste.x = cb_Copy.x + cb_Copy.width
cb_Cancel.x = cb_Copy.x + cb_Copy.width * 2
end event

event close;String ls_Temp

If This.windowstate = Normal! then   // if not maximized or minimized, remember size
	ls_Temp = String(This.Width)
	f_Registry("w_model_w", ls_Temp, True)
	ls_Temp = String(This.Height)
	f_Registry("w_model_h", ls_Temp, True)
End If

Destroy im_print
end event

type st_copy from statictext within w_model
integer x = 2560
integer y = 848
integer width = 489
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = " Empty"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_model
integer x = 3456
integer y = 832
integer width = 201
integer height = 96
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Clear"
end type

event clicked;
ii_BufCount = 0

cb_Copy.Enabled = True

This.Enabled = False
cb_Paste.Enabled = False

st_Copy.Text = "Empty"
st_Copy.TextColor = 4210752
end event

type cb_paste from commandbutton within w_model
integer x = 3255
integer y = 832
integer width = 201
integer height = 96
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Paste"
end type

event clicked;Long ll_ObjID, ll_ObjType, ll_Node
Integer li_Loop, li_Success = 0
String ls_Data

TreeViewItem ltvi_x, ltvi_new

tv_con.GetItem( il_Selhnd, ltvi_x)  // Get selected item

ll_ObjID = Long(Left(ltvi_x.Data, 12))  // get Object ID
ll_ObjType = Integer(Right(ltvi_x.Data, 2))  //  get Object Type

If ll_ObjType <> ii_ObjTypeBuf - 1 then
	If Not ((ll_ObjType = 4 and ii_ObjTypeBuf = 4) Or (ll_ObjType = 1 and ii_ObjTypeBuf = 3)) then 
		MessageBox("Incompatible Destination", "You cannot paste a '" + wf_GetObjType(ii_ObjTypeBuf) + "' under a '" + wf_GetObjType(ll_ObjType) + "'.", Exclamation!)
		Return
	End If
End If

For li_Loop = 1 to ii_BufCount
	If wf_CopyItem(il_ObjIDBuf[li_Loop], ll_ObjID) then
		li_Success ++
		ltvi_new.Data = String(g_obj.ObjID, "000000000000") + String(ii_ObjTypeBuf,"00")
		ltvi_new.Label = g_obj.ObjString
		If ii_ObjTypeBuf = 1 then ltvi_new.Bold = True else ltvi_new.Bold = False
		If ii_ObjTypeBuf > 2 then  // question or sub-question
			If IsNull(g_obj.ReqType) then 
				ltvi_new.Pictureindex = 8 
			ElseIf g_obj.Reqtype = 0 then 
				ltvi_new.Pictureindex = 9
			Else
				ltvi_new.Pictureindex = g_obj.ReqType
			End If
		Else
			If ii_ObjTypeBuf = 1 then ltvi_new.Pictureindex = 6 else ltvi_new.Pictureindex = 7		
		End If
		ltvi_new.Selectedpictureindex = ltvi_new.Pictureindex
		ll_node = tv_con.InsertitemLast( il_Selhnd, ltvi_new)  // Add new item to tree		
	End If
Next

If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
	ls_Data = "1"
	If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
End If

Messagebox("Paste Completed", "The Paste operation was completed.~n~nTotal Items Copied: " + String(ii_BufCount) + "~nTotal Items Pasted: " + String(li_Success))
		
cb_Cancel.event clicked( )
end event

type cb_copy from commandbutton within w_model
integer x = 3054
integer y = 832
integer width = 201
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Copy"
end type

event clicked;Long ll_ObjID
Integer li_ObjType, li_Loop

TreeViewItem ltvi_x

tv_con.GetItem( il_Selhnd, ltvi_x)  // Get selected item

ll_ObjID = Long(Left(ltvi_x.Data, 12))  // Get Object ID
li_ObjType = Integer(Right(ltvi_x.Data, 2))  //  Get Object Type

// Check if item has already been copied
For li_Loop = 1 to ii_BufCount
	If il_ObjIDBuf[li_Loop] = ll_ObjID Then
		Messagebox("Duplicate Item", "The selected item has already been copied.", Exclamation!)
		Return
	End If
Next

// If object type has changed, clear buffer
If li_ObjType <> ii_ObjTypeBuf Then
	ii_BufCount = 0
	ii_ObjTypeBuf = li_ObjType
End If

ii_BufCount ++

il_ObjIDBuf[ii_BufCount] = ll_ObjID

st_Copy.Text = String(ii_BufCount) + " item"
If ii_BufCount > 1 then st_Copy.Text += "s"
st_Copy.Text += " copied"
st_Copy.TextColor = 0

cb_Paste.Enabled = True
cb_Cancel.Enabled = True


end event

type cb_notes from commandbutton within w_model
boolean visible = false
integer x = 3456
integer width = 210
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Notes"
end type

event clicked;
g_obj.Objid = 0

Open(w_NoteDetail)
end event

type hpb_prg from hprogressbar within w_model
boolean visible = false
integer x = 347
integer y = 848
integer width = 1371
integer height = 64
unsignedinteger maxposition = 50
integer setstep = 1
boolean smoothscroll = true
end type

type cb_viq from commandbutton within w_model
integer x = 1298
integer y = 720
integer width = 421
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "      Print      >"
end type

event clicked;
If dw_Model.GetItemNumber( dw_Model.GetRow(), "extmodel") = 1 then
	MessageBox("External Model", "The selected model is an external model.", Exclamation!)
	Return
End If

im_Print.popmenu(Parent.x + Parent.pointerx(), Parent.y + Parent.pointery())


end event

type st_2 from statictext within w_model
integer x = 37
integer y = 848
integer width = 293
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contents:"
boolean focusrectangle = false
end type

type tv_con from treeview within w_model
integer x = 37
integer y = 928
integer width = 3621
integer height = 944
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean hideselection = false
boolean tooltips = false
boolean singleexpand = true
string picturename[] = {"J:\TramosWS\VIMS\images\Vims\Red_S.gif","J:\TramosWS\VIMS\images\Vims\Yellow_R.gif","J:\TramosWS\VIMS\images\Vims\Green_D.gif","J:\TramosWS\VIMS\images\Vims\White_N.gif","J:\TramosWS\VIMS\images\Vims\Insp.gif","J:\TramosWS\VIMS\images\Vims\Chap.gif","J:\TramosWS\VIMS\images\Vims\Sec.gif","J:\TramosWS\VIMS\images\Vims\White_None.gif","J:\TramosWS\VIMS\images\Vims\Info.gif"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event selectionchanged;
Treeviewitem ltvi_x

tv_con.GetItem( newhandle, ltvi_x)   // Get selected item

il_SelHnd = Newhandle    // Save handle

il_ObjID = Long(Left(ltvi_x.data, 12))   // Save Object ID

if (ltvi_x.Level = 1) or Not lbool_VettSuperUser then        // Set buttons
	cb_ItemDel.Enabled = False
	cb_ItemEdit.Enabled = False
	cb_Copy.Enabled = False	
	cb_Paste.Enabled = ii_BufCount > 0 and ii_ObjTypeBuf = 1
Else
	cb_ItemDel.Enabled = True
	cb_ItemEdit.Enabled = True
	cb_Copy.Enabled = True
	cb_Paste.Enabled = ii_BufCount > 0
End if

If lbool_VettSuperUser then cb_ItemNew.Enabled = True

end event

event doubleclicked;
If cb_itemedit.Enabled then cb_itemedit.event clicked( )
end event

type cb_itemedit from commandbutton within w_model
integer x = 457
integer y = 1904
integer width = 421
integer height = 96
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Edit"
end type

event clicked;String ls_Data

TreeViewItem ltvi_x, ltvi_parent
SetPointer(HourGlass!)
tv_con.GetItem( il_Selhnd, ltvi_x)  // Get selected item

g_obj.inspmodel =  il_inspid   //  Set Inspection Model ID
g_obj.objid = Long(Left(ltvi_x.Data, 12))  // Set Object ID
g_obj.level = Integer(Right(ltvi_x.Data, 2))  //  Set Object Type
g_obj.objstring = "Edit"   //  Set edit mode

g_obj.Objparent = "Tree Error"
tv_con.GetItem(tv_con.FindItem(ParentTreeItem!, il_SelHnd), ltvi_parent)
g_obj.Objparent = ltvi_parent.label

open(w_itemedit)

if g_obj.objid > 0 then  // If item was modified
	ltvi_x.Label = g_obj.ObjString
	If g_obj.Level > 2 then 
		If g_obj.Reqtype = 0 then g_obj.Reqtype = 9
		ltvi_x.Pictureindex = g_obj.ReqType 
		ltvi_x.Selectedpictureindex = ltvi_x.Pictureindex
	End If
	tv_con.SetItem( il_Selhnd, ltvi_x )
	If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
		ls_Data = "1"
		If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
	End If
End If



end event

type cb_itemdel from commandbutton within w_model
integer x = 3237
integer y = 1904
integer width = 421
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Delete"
end type

event clicked;String ls_Data

TreeViewItem ltvi_x
SetPointer(HourGlass!)
tv_con.GetItem( il_Selhnd, ltvi_x)  // Get selected item

If ltvi_x.Children then
	MessageBox("Delete Error", "Cannot delete an entity that has items under it.",Exclamation!)
	Return
End If

g_obj.objid = Long(Left(ltvi_x.Data, 12))  // Set Object ID

If MessageBox("Confirm Delete", "Are you sure you want to delete the selected item?",Question!, YesNo!) = 2 then return

Delete from VETT_OBJ where OBJ_ID = :g_obj.objid;

If SQLCA.Sqlcode <> 0 then
	Rollback;
	MessageBox ("DB Error", "Could not delete selected item.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
Else
	commit;
	tv_con.Deleteitem( il_Selhnd)
	If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
		ls_Data = "1"
		If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
	End If	
	MessageBox ("Deleted", "The selected item was deleted sucessfully.")
End If
	
end event

type cb_itemnew from commandbutton within w_model
integer x = 37
integer y = 1904
integer width = 421
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "New..."
end type

event clicked;String ls_Data
Integer li_level
long ll_node
TreeViewItem ltvi_x, ltvi_new
SetPointer(HourGlass!)
tv_con.GetItem( il_Selhnd, ltvi_x)   // Get selected item

g_obj.inspmodel =  il_inspid   //  Set Inspection Model ID

If ltvi_x.Level = 1 then   // Root level
	g_obj.Objid = il_inspid   // Pass InspModel as parent
	g_obj.level = 0   //  Set level to 0
Else
	g_obj.objid = Long(Left(ltvi_x.Data, 12))  // Set Object ID
	g_obj.level = Integer(Right(ltvi_x.Data, 2))  //  Set Object Type
End If

g_obj.ObjParent = ltvi_x.Label   // Pass parent string
g_obj.Objstring = ""

open(w_itemedit)   //  Open window to Add

If g_obj.objid > 0 then  //  If new child was added
	ltvi_new.Data = String(g_obj.objid, "000000000000") + String(g_Obj.ObjType,"00")
	ltvi_new.Label = g_obj.ObjString
	If g_obj.ObjType = 1 then ltvi_new.Bold = True else ltvi_new.Bold = False
	If g_obj.ObjType > 2 then  // question or sub-question
		If IsNull(g_obj.Reqtype) then 
			ltvi_new.Pictureindex = 8 
		ElseIf g_obj.Reqtype = 0 then 
			ltvi_new.Pictureindex = 9
		Else
			ltvi_new.Pictureindex = g_obj.ReqType
		End If		
		ltvi_new.Selectedpictureindex = ltvi_new.Pictureindex
	Else
		If g_obj.ObjType = 1 then ltvi_new.Pictureindex = 6 else ltvi_new.Pictureindex = 7
		ltvi_new.Selectedpictureindex = ltvi_new.Pictureindex		
	End If
	ll_node = tv_con.InsertitemLast( il_Selhnd, ltvi_new)  // Add new item to tree
	If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
		ls_Data = "1"
		If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
	End If	
End If	



end event

type cb_modeldel from commandbutton within w_model
integer x = 3237
integer y = 720
integer width = 421
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Delete"
end type

event clicked;String ls_Data

If il_inspid = 30 then   //  Is PSC
	MessageBox("Delete Error", "The 'Port State Control' inspection model cannot be deleted.", Exclamation!)
	Return
End If

If MessageBox("Confirm Delete", "The selected Inspection Model will be completely deleted.~n~nCAUTION: THIS STEP IS NOT REVERSIBLE!~n~nDo you want to continue?",Question!,YesNo!)=2 then Return

SetPointer (HourGlass!)
Delete from VETT_OBJ where IM_ID = :il_inspid;

If SQLCA.SQLcode <> 0 then
	Messagebox("DB Error", "Could not delete contents.~n~n" + SQLCA.SQLErrText, Exclamation!)
	Rollback;
	Return
End If

Delete from VETT_INSPMODEL Where IM_ID = :il_inspid;

If SQLCA.SQLcode <> 0 then
	Messagebox("DB Error", "Could not delete header.~n~n" + SQLCA.SQLErrText, Exclamation!)
	Rollback;
	Return
End If

Commit;

dw_model.Retrieve()

If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
	ls_Data = "1"
	If f_Config("DBST", ls_Data, 1) = 0 then g_Obj.DBModif = 1
End If

end event

type cb_modeledit from commandbutton within w_model
integer x = 878
integer y = 720
integer width = 421
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Edit..."
end type

event clicked;
SetPointer(HourGlass!)

g_obj.inspmodel = -10
g_obj.inspmodel = dw_model.GetItemNumber( dw_Model.GetRow(), "IM_ID")

if g_obj.inspmodel >= 0 then 
	open(w_modeledit)
	If g_obj.inspmodel >= 0 then dw_Model.ReselectRow(dw_Model.GetRow())
End If

end event

type cb_modeldup from commandbutton within w_model
integer x = 457
integer y = 720
integer width = 421
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Duplicate"
end type

event clicked;String ls_Name
Long ll_NewID

If MessageBox("Confirm Duplication", "Are you sure you want to duplicate the selected Inspection Model?", Question!, YesNo!) = 2 then Return

SetPointer (HourGlass!)
// Get the name of the original model first
Select NAME into :ls_Name from VETT_INSPMODEL where IM_ID = :il_inspid;

If SQLCA.SQLcode <> 0 then
	Rollback;
	MessageBox ("DB Error", "Could not retrieve model header.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Return
End If

Commit;

// Append to name
ls_Name += " - Duplicate"

// Check if duplicate exists
Select IM_ID into :ll_NewID from VETT_INSPMODEL where NAME = :ls_Name;  // Check for duplicates first

If SQLCA.SQLcode < 0 then 
	MessageBox ("DB Error", "Could not perform pre-check for duplicates.~n~n" + SQLCA.Sqlerrtext, Exclamation!)	
	Rollback;
	Return
End If

If SQLCA.sqlnrows > 0 then
	MessageBox ("Duplication Error", "A duplicate model header already exists. Please rename the model before continuing.")
	Return
End If

Insert into VETT_INSPMODEL (NAME, EDITION, NOTES, WEBSITE, MAXSCORE, EXTMODEL, SHORTNAME, INTERVAL, PLANNING, ACTIVE, HASRATING, AUTOFILL) Select NAME + " - Duplicate", EDITION, NOTES, WEBSITE, MAXSCORE, EXTMODEL, SHORTNAME, INTERVAL, PLANNING, ACTIVE, HASRATING, AUTOFILL From VETT_INSPMODEL Where IM_ID = :il_inspid;

If SQLCA.SQLcode <> 0 then
	Rollback;
	MessageBox ("DB Error", "Could not duplicate model header.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Return
End If
Commit;

// Retrieve duplicate model ID
Select IM_ID into :il_NewInspID from VETT_INSPMODEL Where NAME = :ls_Name;
If SQLCA.SQLcode <> 0 then
	Rollback;
	MessageBox ("DB Error", "Could retrieve duplicate model ID.~n~n" + SQLCA.Sqlerrtext, Exclamation!)
	Return
End If

ls_Name = wf_copytree(il_inspid, il_NewInspID )

If ls_Name > "" then	
	MessageBox("Duplication Error", "There was an error copying the contents. All contents may not have been copied.", Exclamation!)	
	Rollback;
End If

dw_model.Retrieve( )

Commit;

If g_obj.DBModif = 0 then  // If DB is not modified then set to 'modified'
	ls_Name = "1"
	If f_Config("DBST", ls_Name, 1) = 0 then g_Obj.DBModif = 1
End If

end event

type cb_modeladd from commandbutton within w_model
integer x = 37
integer y = 720
integer width = 421
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "New..."
end type

event clicked;
SetPointer(HourGlass!)
g_obj.inspmodel = -1
open(w_modeledit)

if g_obj.inspmodel >= 0 then dw_model.retrieve( )

Commit;
end event

type st_1 from statictext within w_model
integer x = 37
integer y = 32
integer width = 805
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Defined Inspection Models:"
boolean focusrectangle = false
end type

type dw_model from datawindow within w_model
integer x = 37
integer y = 96
integer width = 3621
integer height = 624
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_inspmodel"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
This.SetRedraw(False)
This.SetRedraw(True)

SetPointer(HourGlass!)

wf_DrawTree(currentrow)

If lbool_VettSuperUser then
	cb_modeldel.Enabled = True
	cb_modeledit.Enabled = True
	cb_modeldup.Enabled = True
	cb_ItemEdit.Enabled = False
	cb_Copy.Enabled = False
	cb_Paste.Enabled = False
End If


end event

