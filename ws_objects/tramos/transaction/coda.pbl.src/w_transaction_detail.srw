$PBExportHeader$w_transaction_detail.srw
$PBExportComments$Window used for displaying A and B posts from the transactions log.
forward
global type w_transaction_detail from mt_w_response
end type
type st_rows from statictext within w_transaction_detail
end type
type st_rowtext2 from statictext within w_transaction_detail
end type
type st_row from statictext within w_transaction_detail
end type
type st_rowtext1 from statictext within w_transaction_detail
end type
type cb_print from commandbutton within w_transaction_detail
end type
type cb_forward from commandbutton within w_transaction_detail
end type
type cb_back from commandbutton within w_transaction_detail
end type
type cb_close from commandbutton within w_transaction_detail
end type
type tab_transaction from tab within w_transaction_detail
end type
type tabpage_trans_a from userobject within tab_transaction
end type
type dw_trans_a from datawindow within tabpage_trans_a
end type
type tabpage_trans_a from userobject within tab_transaction
dw_trans_a dw_trans_a
end type
type tabpage_trans_b from userobject within tab_transaction
end type
type st_1 from statictext within tabpage_trans_b
end type
type dw_trans_aandb from datawindow within tabpage_trans_b
end type
type tabpage_trans_b from userobject within tab_transaction
st_1 st_1
dw_trans_aandb dw_trans_aandb
end type
type tab_transaction from tab within w_transaction_detail
tabpage_trans_a tabpage_trans_a
tabpage_trans_b tabpage_trans_b
end type
end forward

global type w_transaction_detail from mt_w_response
integer x = 187
integer y = 416
integer width = 3547
integer height = 1764
string title = "Transaction Detail"
long backcolor = 81324524
st_rows st_rows
st_rowtext2 st_rowtext2
st_row st_row
st_rowtext1 st_rowtext1
cb_print cb_print
cb_forward cb_forward
cb_back cb_back
cb_close cb_close
tab_transaction tab_transaction
end type
global w_transaction_detail w_transaction_detail

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_transaction_log
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_transaction_detail.create
int iCurrent
call super::create
this.st_rows=create st_rows
this.st_rowtext2=create st_rowtext2
this.st_row=create st_row
this.st_rowtext1=create st_rowtext1
this.cb_print=create cb_print
this.cb_forward=create cb_forward
this.cb_back=create cb_back
this.cb_close=create cb_close
this.tab_transaction=create tab_transaction
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_rows
this.Control[iCurrent+2]=this.st_rowtext2
this.Control[iCurrent+3]=this.st_row
this.Control[iCurrent+4]=this.st_rowtext1
this.Control[iCurrent+5]=this.cb_print
this.Control[iCurrent+6]=this.cb_forward
this.Control[iCurrent+7]=this.cb_back
this.Control[iCurrent+8]=this.cb_close
this.Control[iCurrent+9]=this.tab_transaction
end on

on w_transaction_detail.destroy
call super::destroy
destroy(this.st_rows)
destroy(this.st_rowtext2)
destroy(this.st_row)
destroy(this.st_rowtext1)
destroy(this.cb_print)
destroy(this.cb_forward)
destroy(this.cb_back)
destroy(this.cb_close)
destroy(this.tab_transaction)
end on

event open;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Populates the data windows.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
************************************************************************************/
Double ld_key

ld_key = Message.DoubleParm

// Get the B transaction
tab_transaction.tabpage_trans_b.dw_trans_aandb.SetTransObject(SQLCA)
tab_transaction.tabpage_trans_b.dw_trans_aandb.Retrieve(ld_key)

// Get the A transaction
tab_transaction.tabpage_trans_a.dw_trans_a.SetTransObject(SQLCA)
tab_transaction.tabpage_trans_a.dw_trans_a.Retrieve(ld_key)


end event

type st_rows from statictext within w_transaction_detail
integer x = 672
integer y = 1564
integer width = 119
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_rowtext2 from statictext within w_transaction_detail
integer x = 576
integer y = 1564
integer width = 82
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "of "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_row from statictext within w_transaction_detail
integer x = 475
integer y = 1564
integer width = 87
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_rowtext1 from statictext within w_transaction_detail
integer x = 210
integer y = 1564
integer width = 233
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = " B post"
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_transaction_detail
event clicked pbm_bnclicked
integer x = 2597
integer y = 1552
integer width = 425
integer height = 108
integer taborder = 31
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Prints the tabpage that are on top.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
************************************************************************************/

If tab_transaction.SelectedTab = 1 then w_transaction_detail.tab_transaction.tabpage_trans_a.dw_trans_a.Print(TRUE)
IF tab_transaction.SelectedTab = 2 then w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.Print(TRUE)

end event

type cb_forward from commandbutton within w_transaction_detail
event clicked pbm_bnclicked
integer x = 1673
integer y = 1552
integer width = 425
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&>>"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Scroll one row forward in the B-Post datawindow if not last row.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
************************************************************************************/
long ll_no_of_rows, ll_row

ll_no_of_rows = w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.RowCount()
ll_row = w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.GetRow()

If (ll_row + 1) <= ll_no_of_rows Then 
	w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.SetRow(ll_row +1)
	w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.ScrollToRow(ll_row +1)
	w_transaction_detail.st_row.Text = String(ll_row + 1)
End if
end event

type cb_back from commandbutton within w_transaction_detail
event clicked pbm_bnclicked
integer x = 1207
integer y = 1552
integer width = 425
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&<<"
end type

event clicked;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Scroll one row backwards in the B-Post datawindow if not first row
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
************************************************************************************/
long ll_row

ll_row = w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.GetRow()

If (ll_row - 1) >= 1 Then 
	w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.SetRow(ll_row -1)
	w_transaction_detail.tab_transaction.tabpage_trans_b.dw_trans_aandb.ScrollToRow(ll_row -1)
	w_transaction_detail.st_row.Text = String(ll_row - 1)
End if
end event

type cb_close from commandbutton within w_transaction_detail
integer x = 3063
integer y = 1552
integer width = 425
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
boolean default = true
end type

event clicked;Close(w_transaction_detail)
end event

type tab_transaction from tab within w_transaction_detail
integer x = 50
integer y = 28
integer width = 3438
integer height = 1496
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean raggedright = true
integer selectedtab = 1
tabpage_trans_a tabpage_trans_a
tabpage_trans_b tabpage_trans_b
end type

on tab_transaction.create
this.tabpage_trans_a=create tabpage_trans_a
this.tabpage_trans_b=create tabpage_trans_b
this.Control[]={this.tabpage_trans_a,&
this.tabpage_trans_b}
end on

on tab_transaction.destroy
destroy(this.tabpage_trans_a)
destroy(this.tabpage_trans_b)
end on

event selectionchanged;/***********************************************************************************
Creator:	Teit Aunt
Date:		20-05-1999
Purpose:	Controlls the enabling of the scroll buttons.
************************************************************************************
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------ 	----- 	-------------------------------------
20-05-99		1.0		ta			Initial version
************************************************************************************/
long ll_rows

// If the clicked tab is B-Posts, then enable scroll buttons
If tab_transaction.SelectedTab = 2 Then
	ll_rows = tabpage_trans_b.dw_trans_aandb.RowCount()
	If ll_rows > 1 Then
		cb_forward.Enabled = True
		cb_back.Enabled = True
		st_row.Text = "1"
		st_rows.Text = string(ll_rows)
		tabpage_trans_b.dw_trans_aandb.ScrollTorow(1)
	End if
Else
	cb_forward.Enabled = False
	cb_back.Enabled = False
End if

st_rowtext1.visible = cb_back.Enabled
st_rowtext2.visible = cb_back.Enabled
st_row.visible = cb_back.Enabled
st_rows.visible = cb_back.Enabled


end event

type tabpage_trans_a from userobject within tab_transaction
integer x = 18
integer y = 100
integer width = 3401
integer height = 1380
long backcolor = 81324524
string text = "A-transaction"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_trans_a dw_trans_a
end type

on tabpage_trans_a.create
this.dw_trans_a=create dw_trans_a
this.Control[]={this.dw_trans_a}
end on

on tabpage_trans_a.destroy
destroy(this.dw_trans_a)
end on

type dw_trans_a from datawindow within tabpage_trans_a
integer x = 69
integer y = 68
integer width = 3218
integer height = 1256
integer taborder = 3
string dataobject = "d_trans_a"
boolean livescroll = true
end type

type tabpage_trans_b from userobject within tab_transaction
integer x = 18
integer y = 100
integer width = 3401
integer height = 1380
long backcolor = 81324524
string text = "B-transaction"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
st_1 st_1
dw_trans_aandb dw_trans_aandb
end type

on tabpage_trans_b.create
this.st_1=create st_1
this.dw_trans_aandb=create dw_trans_aandb
this.Control[]={this.st_1,&
this.dw_trans_aandb}
end on

on tabpage_trans_b.destroy
destroy(this.st_1)
destroy(this.dw_trans_aandb)
end on

type st_1 from statictext within tabpage_trans_b
integer x = 91
integer y = 1320
integer width = 965
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Grey fields are identical with A-post fields."
boolean focusrectangle = false
end type

type dw_trans_aandb from datawindow within tabpage_trans_b
integer x = 82
integer y = 80
integer width = 3214
integer height = 1236
integer taborder = 4
string dataobject = "d_trans_aandb"
boolean livescroll = true
end type

