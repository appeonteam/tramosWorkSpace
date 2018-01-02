$PBExportHeader$w_matrix.srw
forward
global type w_matrix from window
end type
type cb_clear from commandbutton within w_matrix
end type
type dw_matrix from datawindow within w_matrix
end type
type cb_close from commandbutton within w_matrix
end type
type cb_import from commandbutton within w_matrix
end type
type st_imp from statictext within w_matrix
end type
end forward

global type w_matrix from window
integer width = 4457
integer height = 2288
boolean titlebar = true
string title = "Officer Matrix"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_clear cb_clear
dw_matrix dw_matrix
cb_close cb_close
cb_import cb_import
st_imp st_imp
end type
global w_matrix w_matrix

type variables

n_matrix invo_matrix
end variables

on w_matrix.create
this.cb_clear=create cb_clear
this.dw_matrix=create dw_matrix
this.cb_close=create cb_close
this.cb_import=create cb_import
this.st_imp=create st_imp
this.Control[]={this.cb_clear,&
this.dw_matrix,&
this.cb_close,&
this.cb_import,&
this.st_imp}
end on

on w_matrix.destroy
destroy(this.cb_clear)
destroy(this.dw_matrix)
destroy(this.cb_close)
destroy(this.cb_import)
destroy(this.st_imp)
end on

event open;
invo_matrix = Create n_matrix

dw_matrix.SetTransObject(SQLCA)
dw_matrix.Retrieve(g_Obj.InspID)

If g_Obj.Level = 0 then   // Readonly mode
	cb_Import.Enabled = False
	cb_Clear.Enabled = False
End If
end event

event close;
Destroy invo_matrix
end event

type cb_clear from commandbutton within w_matrix
integer x = 512
integer y = 1984
integer width = 494
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear Matrix"
end type

event clicked;
If g_obj.DeptID > 1 then   // Check if user is not from Vetting Dept
	MessageBox("Access Denied", "Your department does not have access to modify the matrix.", Exclamation!)
	Return
End If
 
If Messagebox("Confirm Clear", "Are you sure you want to clear the officer matrix from this inspection?", Question!, YesNo!) = 2 then Return

Delete From VETT_MATRIX Where INSP_ID = :g_Obj.InspID;

If SQLCA.SQLCode < 0 then
	Messagebox("DB Error", "Unable to delete matrix.~n~n" + SQLCA.SQLErrtext, Exclamation!)
	Rollback;
Else
	If IsValid(w_inspdetail) then w_inspdetail.ib_Modified = True
End If

dw_matrix.Retrieve(g_Obj.InspID)


end event

type dw_matrix from datawindow within w_matrix
integer x = 18
integer y = 16
integer width = 4407
integer height = 1968
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_matrixdisp1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_close from commandbutton within w_matrix
integer x = 1975
integer y = 2080
integer width = 494
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

type cb_import from commandbutton within w_matrix
integer x = 18
integer y = 1984
integer width = 494
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Import Matrix..."
end type

event clicked;Integer li_Return
String ls_Path, ls_xlsFile

If g_obj.DeptID > 1 then   // Check if user is not from Vetting Dept
	MessageBox("Access Denied", "Your department does not have access to modify the matrix.", Exclamation!)
	Return
End If
 
li_Return = GetFileOpenName("Select Matrix File", ls_Path, ls_xlsFile, "xls", "Microsoft Excel Files (*.xls),*.xls","",27)

If li_Return < 1 then Return  // User cancelled

SetPointer(HourGlass!)

This.Enabled = False
This.Text = "Importing..."
cb_Clear.Enabled = False
cb_Close.Enabled = False
Parent.Pointer = "HourGlass!"
dw_matrix.Visible = False

Yield()

Try
	li_Return = invo_matrix.of_importmatrix(ls_Path, g_Obj.InspID, g_Obj.ObjString)
	If IsValid(w_inspdetail) then w_inspdetail.ib_Modified = True
Catch (RuntimeError re)
	Messagebox("Import Error", "The Excel file could not be imported.~n~nFunction: of_importmatrix()", Exclamation!)
	dw_matrix.Retrieve(g_Obj.InspID)
	li_Return = -1
End Try

If li_Return <> 0 then dw_matrix.Retrieve(g_Obj.InspID)

If li_Return = 1 then MessageBox("Import Completed", "The matrix was successfully imported from the Excel sheet.")

This.Enabled = True
This.Text = "Import Matrix..."
cb_Clear.Enabled = True
cb_Close.Enabled = True
Parent.Pointer = "Arrow!"
dw_matrix.Visible = True
end event

type st_imp from statictext within w_matrix
integer x = 1317
integer y = 960
integer width = 1719
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "Importing Matrix. Please wait..."
alignment alignment = center!
boolean focusrectangle = false
end type

