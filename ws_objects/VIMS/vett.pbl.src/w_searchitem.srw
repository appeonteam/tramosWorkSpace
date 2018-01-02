$PBExportHeader$w_searchitem.srw
forward
global type w_searchitem from window
end type
type cbx_3p from checkbox within w_searchitem
end type
type cbx_tc from checkbox within w_searchitem
end type
type st_3 from statictext within w_searchitem
end type
type cb_search from commandbutton within w_searchitem
end type
type st_4 from statictext within w_searchitem
end type
type rb_allmodel from radiobutton within w_searchitem
end type
type rb_model from radiobutton within w_searchitem
end type
type st_1 from statictext within w_searchitem
end type
type sle_num from singlelineedit within w_searchitem
end type
type st_2 from statictext within w_searchitem
end type
type rb_all from radiobutton within w_searchitem
end type
type rb_20items from radiobutton within w_searchitem
end type
type cb_close from commandbutton within w_searchitem
end type
type dw_result from datawindow within w_searchitem
end type
type gb_2 from groupbox within w_searchitem
end type
type gb_1 from groupbox within w_searchitem
end type
type st_model from statictext within w_searchitem
end type
end forward

global type w_searchitem from window
integer width = 3566
integer height = 2620
boolean titlebar = true
string title = "Search Result"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Bino.ico"
boolean center = true
cbx_3p cbx_3p
cbx_tc cbx_tc
st_3 st_3
cb_search cb_search
st_4 st_4
rb_allmodel rb_allmodel
rb_model rb_model
st_1 st_1
sle_num sle_num
st_2 st_2
rb_all rb_all
rb_20items rb_20items
cb_close cb_close
dw_result dw_result
gb_2 gb_2
gb_1 gb_1
st_model st_model
end type
global w_searchitem w_searchitem

type variables

String is_ShortName
end variables

forward prototypes
private subroutine wf_search ()
end prototypes

private subroutine wf_search ();Integer li_Count, li_Num[], li_Index
String ls_Where, ls_Clause, ls_Temp, ls_SQL

SetPointer(HourGlass!)

ls_Clause = sle_Num.Text

// Set all to 0
For li_Count = 1 to 6
	li_Num[li_Count] = 0
Next

li_Index = 0

//Parse string
For li_Count = 1 to Len(ls_Clause)
	If Pos("0123456789", Mid(ls_Clause, li_Count, 1)) > 0 then
		ls_Temp += Mid(ls_Clause, li_Count, 1)
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
ls_Clause = ""
//Recreate number
For li_Count = 1 to 6
	If li_Num[li_Count] > 0 then 
		If li_Num[li_Count] > 9999 then
			MessageBox("Search Error", "Invalid question number specfied.",Exclamation!)
			Return
		End If
		ls_Temp = String(li_Num[li_Count])
		ls_Temp = Space(4 - Len(ls_Temp)) + ls_Temp
		ls_Clause += ls_Temp
	End If
Next

// Create SQL string
ls_Where = " and ((Str(CHAPNUM,4) + Str(SECTNUM,4) + Str(QPARNUM1,4) + Str(QPARNUM2,4) + Str(QPARNUM3,4) + Str(QNUM,4)) like '" + ls_Clause + "%')"	

// If excluding 3P vessels
If Not cbx_3P.Checked then	ls_Where += " and (TYPE_NAME not like '%3P%')"

// If excluding T/C vessels
If Not cbx_TC.Checked then ls_Where += " and (TYPE_NAME not like '%T/C%')"

// If using only same model
If rb_Model.Checked then ls_Where += " and (SHORTNAME = '" + is_ShortName + "')"

// If limiting to 20 items
If rb_20Items.Checked then ls_SQL = "SELECT TOP 20 " else ls_SQL = "SELECT "

ls_SQL += "VETT_MASTER.CHAPNUM, VETT_MASTER.SECTNUM,"&
  + "VETT_MASTER.QPARNUM1, VETT_MASTER.QPARNUM2, VETT_MASTER.QNAME,"&
  + "VETT_MASTER.QNUM, VETT_MASTER.ANS, VETT_MASTER.INSPCOMM,"&
  + "VETT_MASTER.OWNCOMM, VETT_MASTER.FOLLOWUP, VETT_MASTER.DEF, VETT_MASTER.CAUSETEXT, VETT_MASTER.RESPTEXT,"&
  + "VETT_MASTER.RISK, VETT_MASTER.CLOSED, VETT_MASTER.CLOSEDATE, VETT_MASTER.REQTYPE,"&
  + "VETT_MASTER.QPARNUM3, VETT_MASTER.INSP_ID, VETT_MASTER.INSPDATE, VETT_MASTER.IMNAME, VETT_MASTER.EDITION,"&
  + "VESSELS.VESSEL_NAME, VETT_COMP.NAME, VETT_MASTER.RATING, VETT_MASTER.IM_ID "&
  + "FROM VETT_MASTER Inner Join VESSELS On VETT_MASTER.VESSEL_ID = VESSELS.VESSEL_ID "&
  + "Inner Join VETT_COMP On VETT_MASTER.COMP_ID = VETT_COMP.COMP_ID "&
  + "Inner Join VETT_INSPMODEL On VETT_MASTER.IM_ID = VETT_INSPMODEL.IM_ID "&
  + "Inner Join VETT_VSLTYPE On VETT_MASTER.VETT_TYPE = VETT_VSLTYPE.TYPE_ID "&
  + "WHERE (VETT_MASTER.ANS = 1) and (VETT_MASTER.QNUM is not Null) and (VETT_MASTER.VESSEL_ACTIVE = 1)" + ls_Where + " ORDER BY VETT_MASTER.INSPDATE DESC"
  
dw_result.SetSQLSelect(ls_SQL)

dw_result.Retrieve()

end subroutine

on w_searchitem.create
this.cbx_3p=create cbx_3p
this.cbx_tc=create cbx_tc
this.st_3=create st_3
this.cb_search=create cb_search
this.st_4=create st_4
this.rb_allmodel=create rb_allmodel
this.rb_model=create rb_model
this.st_1=create st_1
this.sle_num=create sle_num
this.st_2=create st_2
this.rb_all=create rb_all
this.rb_20items=create rb_20items
this.cb_close=create cb_close
this.dw_result=create dw_result
this.gb_2=create gb_2
this.gb_1=create gb_1
this.st_model=create st_model
this.Control[]={this.cbx_3p,&
this.cbx_tc,&
this.st_3,&
this.cb_search,&
this.st_4,&
this.rb_allmodel,&
this.rb_model,&
this.st_1,&
this.sle_num,&
this.st_2,&
this.rb_all,&
this.rb_20items,&
this.cb_close,&
this.dw_result,&
this.gb_2,&
this.gb_1,&
this.st_model}
end on

on w_searchitem.destroy
destroy(this.cbx_3p)
destroy(this.cbx_tc)
destroy(this.st_3)
destroy(this.cb_search)
destroy(this.st_4)
destroy(this.rb_allmodel)
destroy(this.rb_model)
destroy(this.st_1)
destroy(this.sle_num)
destroy(this.st_2)
destroy(this.rb_all)
destroy(this.rb_20items)
destroy(this.cb_close)
destroy(this.dw_result)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.st_model)
end on

event open;
dw_result.SetTransObject(SQLCA)

sle_num.Text = g_Obj.ObjString

Select SHORTNAME into :is_ShortName From VETT_INSPMODEL Inner Join VETT_INSP On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID Where VETT_INSP.INSP_ID = :g_Obj.InspID;

If (SQLCA.SQLCode <> 0) or IsNull(is_ShortName) then
	st_Model.Visible = False
	rb_Model.Visible = False
	rb_AllModel.Visible = False
	rb_AllModel.Checked = True
	Rollback;
End If

Commit;

rb_Model.Text = is_ShortName + ' Only'

cb_Search.PostEvent(Clicked!)
end event

type cbx_3p from checkbox within w_searchitem
integer x = 2085
integer y = 288
integer width = 471
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "3P Vessels"
end type

type cbx_tc from checkbox within w_searchitem
integer x = 2085
integer y = 208
integer width = 471
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "T/C Vessels"
end type

type st_3 from statictext within w_searchitem
integer x = 2030
integer y = 128
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
string text = "Include:"
boolean focusrectangle = false
end type

type cb_search from commandbutton within w_searchitem
integer x = 2944
integer y = 128
integer width = 475
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Search"
end type

event clicked;
SetPointer(HourGlass!)

rb_20items.Enabled = False
rb_All.Enabled = False
rb_Model.Enabled = False
rb_AllModel.Enabled = False
cbx_TC.Enabled = False
cbx_3P.Enabled = False
This.Enabled = False
This.Text = "Searching..."

wf_Search()

rb_20items.Enabled = True
rb_All.Enabled = True
rb_Model.Enabled = True
rb_AllModel.Enabled = True
cbx_TC.Enabled = True
cbx_3P.Enabled = True
This.Enabled = True
This.Text = "Search"
end event

type st_4 from statictext within w_searchitem
integer x = 73
integer y = 416
integer width = 457
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Results:"
boolean focusrectangle = false
end type

type rb_allmodel from radiobutton within w_searchitem
integer x = 841
integer y = 304
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
end type

type rb_model from radiobutton within w_searchitem
integer x = 841
integer y = 224
integer width = 329
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "XXXX Only"
boolean checked = true
end type

type st_1 from statictext within w_searchitem
integer x = 1426
integer y = 128
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
string text = "Results:"
boolean focusrectangle = false
end type

type sle_num from singlelineedit within w_searchitem
integer x = 110
integer y = 208
integer width = 402
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_searchitem
integer x = 73
integer y = 128
integer width = 457
integer height = 80
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

type rb_all from radiobutton within w_searchitem
integer x = 1463
integer y = 288
integer width = 384
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "All Items"
end type

type rb_20items from radiobutton within w_searchitem
integer x = 1463
integer y = 208
integer width = 475
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "20 Items Only"
boolean checked = true
end type

type cb_close from commandbutton within w_searchitem
integer x = 2944
integer y = 320
integer width = 475
integer height = 112
integer taborder = 20
integer textsize = -10
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

type dw_result from datawindow within w_searchitem
integer x = 55
integer y = 496
integer width = 3438
integer height = 1984
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_search"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event sqlpreview;
string ls_sql

ls_sql = sqlsyntax
end event

type gb_2 from groupbox within w_searchitem
boolean visible = false
integer x = 805
integer y = 128
integer width = 475
integer height = 304
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type gb_1 from groupbox within w_searchitem
integer x = 18
integer width = 3511
integer height = 2512
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item Search"
end type

type st_model from statictext within w_searchitem
integer x = 805
integer y = 128
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Model:"
boolean focusrectangle = false
end type

