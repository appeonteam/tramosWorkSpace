$PBExportHeader$w_calc_misc_expenses.srw
$PBExportComments$Misc expenses for a port
forward
global type w_calc_misc_expenses from mt_w_response_calc
end type
type cb_close from uo_cb_base within w_calc_misc_expenses
end type
type dw_calc_port_expenses from u_datawindow_sqlca within w_calc_misc_expenses
end type
type cb_new from uo_cb_base within w_calc_misc_expenses
end type
type cb_delete from uo_cb_base within w_calc_misc_expenses
end type
end forward

global type w_calc_misc_expenses from mt_w_response_calc
integer x = 768
integer y = 520
integer width = 1573
integer height = 896
string title = "Miscellaneous Expenses"
string icon = "images\calcmenu.ICO"
cb_close cb_close
dw_calc_port_expenses dw_calc_port_expenses
cb_new cb_new
cb_delete cb_delete
end type
global w_calc_misc_expenses w_calc_misc_expenses

type variables
Private s_misc_expenses is_misc_expenses
Private integer ii_order
n_service_manager inv_serviceMgr
n_dw_style_service   inv_style

end variables

forward prototypes
public function double wf_update ()
public subroutine wf_get_amount ()
public subroutine documentation ()
end prototypes

public function double wf_update ();double ld_ret, ld_count, ld_rowcount
//
//dw_port_expenses.Accepttext()
//
//ld_rowcount = dw_port_expenses.RowCount()
//
//FOR ld_count = 1TO ld_rowcount
//	dw_port_expenses.SetItem(ld_count,"cal_caio_id",is_misc_expenses.d_caio_id)
//NEXT
//
//IF dw_port_expenses.Update() = 1 THEN
//	COMMIT;
//	ld_ret = 1
//	open(w_updated)
//ELSE
//	ROLLBACK;
//	ld_ret = -1
//END IF
//
return(ld_ret)
//
end function

public subroutine wf_get_amount ();

//double ld_rowcount, ld_count
double ld_tmp, ld_count,ld_rowcount,ld_sum_tmp = 0



ld_rowcount = dw_calc_port_expenses.RowCount()

FOR ld_count = 1 TO ld_rowcount
	ld_tmp = dw_calc_port_expenses.GetItemNumber(ld_count,"cal_pexp_amount")
	If Not IsNull(ld_tmp) Then
		ld_sum_tmp  += ld_tmp
		
	End if
NEXT


is_misc_expenses.d_total_misc_expenses = ld_sum_tmp



end subroutine

public subroutine documentation ();/********************************************************************
   w_calc_misc_expenses
	
	<OBJECT>
		Claims window, requires a refactor as soon as possible.
	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>
		Used to generate new claims among other things
	</USAGE>
  	<ALSO>
		
	</ALSO>
	<HISTORY>
		Date   	 	Ref   	Author		Comments
		03/06/2014	CR3642	KITTY 		The amount in the Calculation has been doubled when click button "close" 		 
		07/08/2014	CR3708	AGL027		F1 help application coverage - corrected ancestor
		12/09/2014	CR3773	XSZ004		Change icon absolute path to reference path
	</HISTORY>
*****************************************************************/
end subroutine

event open;call super::open;/****************************************************************************
Author		: Teit Aunt
Date			: 1-1-98
Description	: inserts data into datawindow and locks window if the portrow is
				  locked.

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
Integer li_max, li_count
Boolean lb_not_modified

is_misc_expenses = Message.PowerObjectParm

// Datawindow is shared with hidden datawindow on u_calc_calculation
If is_misc_expenses.dw_port_expenses.ShareData(dw_calc_port_expenses) <> 1 Then &
	messageBox("Error","Error getting/sharing d_calc_port_exp_all")

// Set filter so only misc. expenses relevant for specified port id shown
dw_calc_port_expenses.SetFilter("cal_caio_id = " + string(is_misc_expenses.d_caio_id))
dw_calc_port_expenses.Filter()

li_max = dw_calc_port_expenses.Rowcount()

lb_not_modified = dw_calc_port_expenses.ModifiedCount() + dw_calc_port_expenses.DeletedCount() = 0

For li_count = 1 To li_max
	dw_calc_port_expenses.SetItem(li_count,"edit_locked",is_misc_expenses.d_edit_locked)
Next

If lb_not_modified Then
	dw_calc_port_expenses.ResetUpdate()
End if

ii_order = li_max

If is_misc_expenses.d_edit_locked > 1 then
	dw_calc_port_expenses.Modify("DataWindow.ReadOnly=Yes")
	cb_new.Enabled = False
	cb_delete.Enabled = False
	dw_calc_port_expenses.SetFocus()
	dw_calc_port_expenses.SelectRow(0,False)
Else
	cb_delete.enabled = li_max > 0
	dw_calc_port_expenses.SetFocus()
//	dw_calc_port_expenses.SelectRow(0,False)
//	dw_calc_port_expenses.SelectRow(1,True)
	dw_calc_port_expenses.SetRow(1)
End if




end event

on w_calc_misc_expenses.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.dw_calc_port_expenses=create dw_calc_port_expenses
this.cb_new=create cb_new
this.cb_delete=create cb_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.dw_calc_port_expenses
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_delete
end on

on w_calc_misc_expenses.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.dw_calc_port_expenses)
destroy(this.cb_new)
destroy(this.cb_delete)
end on

event ue_closeitem;//
end event

event close;call super::close;cb_close.triggerevent(clicked!)

end event

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_misc_expenses
end type

type cb_close from uo_cb_base within w_calc_misc_expenses
boolean visible = false
integer x = 1710
integer y = 376
integer taborder = 40
boolean enabled = false
string text = "&Close"
boolean default = true
end type

event clicked;call super::clicked;/****************************************************************************
Author		: Teit Aunt
Date			: 1-1-98
Description	: Inserts an id number and gets the total amount of expenses. Allso
				  signals the calculation if there are modifications.

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
double ld_rowcount, ld_count
string ls_desc
dec    ldc_amount
/* If there is unsaved data the user is queried if they should be saved */
dw_calc_port_expenses.AcceptText()
//delete empty row
for ld_count = dw_calc_port_expenses.RowCount() to 1 step -1
	ls_desc = dw_calc_port_expenses.getitemstring(ld_count,'cal_pexp_description')
	ldc_amount = dw_calc_port_expenses.getitemdecimal(ld_count,'cal_pexp_amount')
	if (isnull(ls_desc) or trim(ls_desc) = '') and (isnull(ldc_amount) or ldc_amount = 0) then
		dw_calc_port_expenses.DeleteRow(ld_count)
	end if
next

ld_rowcount = dw_calc_port_expenses.RowCount()
FOR ld_count = 1 TO ld_rowcount
	If IsNull(dw_calc_port_expenses.GetItemNumber(ld_count, "cal_caio_id")) Then &
		dw_calc_port_expenses.SetItem(ld_count,"cal_caio_id", Round(is_misc_expenses.d_caio_id,0) )
NEXT

Wf_get_amount()

If ( dw_calc_port_expenses.ModifiedCount() + dw_calc_port_expenses.DeletedCount() ) > 0 Then
	is_misc_expenses.b_modified = True
Else
	is_misc_expenses.b_modified = False
End if	

CloseWithReturn(Parent,is_misc_expenses)
Return


end event

type dw_calc_port_expenses from u_datawindow_sqlca within w_calc_misc_expenses
integer x = 37
integer y = 32
integer width = 1490
integer height = 644
integer taborder = 30
string dataobject = "d_calc_port_expenses"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

on clicked;call u_datawindow_sqlca::clicked;If is_misc_expenses.d_edit_locked > 1 then
	ib_auto = False
	this.SelectRow(0,False)
Else
	ib_auto = True
End if

end on

event constructor;call super::constructor;ib_newstandard = true
inv_serviceMgr.of_loadservice( inv_style, "n_dw_style_service")
inv_style.of_dwlistformater(dw_calc_port_expenses,false)
end event

event itemfocuschanged;call super::itemfocuschanged;if dwo.name ='cal_pexp_amount' then
	selecttext(1,15)
end if
end event

type cb_new from uo_cb_base within w_calc_misc_expenses
integer x = 837
integer y = 692
integer width = 343
integer height = 100
integer taborder = 10
string text = "&New"
end type

event clicked;call super::clicked;/****************************************************************************
Author		: Teit Aunt
Date			: 1-1-98
Description	: Inserts a new row in the datawindow

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
Long ll_rowno

dw_calc_port_expenses.Accepttext()

dw_calc_port_expenses.SetFocus()
dw_calc_port_expenses.SelectRow(0,False)

ll_rowno = dw_calc_port_expenses.InsertRow(0)

//dw_calc_port_expenses.SetFocus()
dw_calc_port_expenses.SetRow(ll_rowno)
//dw_calc_port_expenses.SelectRow(ll_rowno,True)

//dw_calc_port_expenses.SetItem(ll_rowno,"cal_pexp_amount",0)

ii_order ++
dw_calc_port_expenses.SetItem(ll_rowno,"cal_pexp_cal_pexp_order",ii_order)

cb_delete.enabled = true

end event

type cb_delete from uo_cb_base within w_calc_misc_expenses
integer x = 1184
integer y = 692
integer width = 343
integer height = 100
integer taborder = 20
string text = "&Delete"
end type

event clicked;call super::clicked;/****************************************************************************
Author		: Teit Aunt
Date			: 1-1-98
Description	: Delete the current row in the window

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
Long ll_rowno, ll_max

ll_rowno = dw_calc_port_expenses.GetRow()
If ll_rowno > 0 Then
	dw_calc_port_expenses.DeleteRow(ll_rowno)
End if

cb_delete.enabled = dw_calc_port_expenses.RowCount() > 0

ll_max = dw_calc_port_expenses.RowCount() 
If ll_rowno > ll_max Then ll_rowno = ll_max

dw_calc_port_expenses.uf_select_row(ll_rowno )
end event

