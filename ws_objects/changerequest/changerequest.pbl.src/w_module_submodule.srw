$PBExportHeader$w_module_submodule.srw
forward
global type w_module_submodule from w_system_base
end type
type dw_2 from u_datagrid within w_module_submodule
end type
type st_module from statictext within w_module_submodule
end type
type st_2 from statictext within w_module_submodule
end type
type cb_new_s from commandbutton within w_module_submodule
end type
type cb_update_s from commandbutton within w_module_submodule
end type
type cb_delete_s from commandbutton within w_module_submodule
end type
end forward

global type w_module_submodule from w_system_base
integer width = 1637
integer height = 1968
string title = "Modules/Sub Modules"
dw_2 dw_2
st_module st_module
st_2 st_2
cb_new_s cb_new_s
cb_update_s cb_update_s
cb_delete_s cb_delete_s
end type
global w_module_submodule w_module_submodule

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_module_submodule
   <OBJECT>	Maintain Modules and Sub-modules	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		02-04-2013	CR2614		LHG008		Change GUI
		28/08/2014	CR3781		CCY018		The window title match with the text of a menu item
		12/09/14  	CR3773		XSZ004		Change icon absolute path to reference path
   </HISTORY>
********************************************************************/
end subroutine

on w_module_submodule.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.st_module=create st_module
this.st_2=create st_2
this.cb_new_s=create cb_new_s
this.cb_update_s=create cb_update_s
this.cb_delete_s=create cb_delete_s
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.st_module
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_new_s
this.Control[iCurrent+5]=this.cb_update_s
this.Control[iCurrent+6]=this.cb_delete_s
end on

on w_module_submodule.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.st_module)
destroy(this.st_2)
destroy(this.cb_new_s)
destroy(this.cb_update_s)
destroy(this.cb_delete_s)
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"mt_sortorder", "module_desc"}
wf_format_datawindow(dw_1, ls_mandatory_column)

ls_mandatory_column = {"mt_sortorder", "sub_module_desc"}
wf_format_datawindow(dw_2, ls_mandatory_column)

dw_2.settransObject(sqlca)

end event

event closequery;dw_1.accepttext()
if dw_1.modifiedcount() > 0 then
	if messagebox("Change Request Updates Pending", "Module data changed but not saved. ~n~nWould you like to save data?", Question!, YesNo!, 1) = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if

dw_2.accepttext()
if dw_2.modifiedcount() > 0 then
	if messagebox("Change Request Updates Pending", "Sub-module data changed but not saved. ~n~nWould you like to save data?", Question!, YesNo!, 1) = 1 then
		if cb_update_s.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if

if isvalid(inv_validation) then
	destroy inv_validation
end if

return 0

end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_module_submodule
end type

type cb_cancel from w_system_base`cb_cancel within w_module_submodule
integer x = 2121
integer y = 736
integer taborder = 90
end type

type cb_refresh from w_system_base`cb_refresh within w_module_submodule
integer x = 1911
integer y = 428
integer taborder = 100
end type

type cb_delete from w_system_base`cb_delete within w_module_submodule
integer x = 1248
integer y = 728
end type

event cb_delete::clicked;long ll_currentrow, ll_row, ll_rows, ll_cont, ll_module_id

ll_rows = dw_1.rowcount()
ll_currentrow = dw_1.getrow()
ll_module_id = dw_1.getitemnumber(ll_currentrow, "module_id")
//Check dependence
if not isnull(ll_module_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_REQUEST
	 WHERE CREQ_REQUEST.MODULE_ID = :ll_module_id
		AND CREQ_REQUEST.MODULE_ID IS NOT NULL;
		
	if ll_cont = 0 then
		SELECT COUNT(1) INTO :ll_cont
		  FROM CREQ_SUB_MODULE
		 WHERE CREQ_SUB_MODULE.MODULE_ID = :ll_module_id
			AND CREQ_SUB_MODULE.MODULE_ID IS NOT NULL;
	end if
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies on this module.")
	return
end if

//CR2438  Begin modified by JMY014 on 05-08-2011
if messagebox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!,2) = 1 then
	//Update the sort order column
	for ll_row = ll_rows to ll_currentrow + 1 step -1
		dw_1.setitem(ll_row, "mt_sortorder", ll_row - 1)
	next
	
	//Delete the current row
	dw_1.deleterow(dw_1.getrow())
	
	if dw_1.update() = 1 then
		COMMIT;
	else
		ROLLBACK;
		messagebox("Update Error", "Update failure.")
	end if
end if
//CR2438 End modified by JMY014 on 05-08-2011
end event

type cb_update from w_system_base`cb_update within w_module_submodule
integer x = 901
integer y = 728
end type

event cb_update::clicked;n_dw_column_definition lnv_ruledefinition[], inv_null

cb_new_s.enabled = true
cb_update_s.enabled = true
cb_delete_s.enabled = true

inv_servicemgr.of_loadservice(inv_validation, "n_dw_validation_service")

lnv_ruledefinition = inv_validation.inv_ruledefinition

//Exclude sub module column
inv_validation.inv_ruledefinition[3] = inv_null
inv_validation.inv_ruledefinition[4] = inv_null

call super::clicked

//Reset column
inv_validation.inv_ruledefinition = lnv_ruledefinition

return ancestorreturnvalue
end event

type cb_new from w_system_base`cb_new within w_module_submodule
integer x = 553
integer y = 728
end type

event cb_new::clicked;long		ll_row

cb_new_s.enabled = false
cb_update_s.enabled = false
cb_delete_s.enabled = false

//CR2406 Begin added by JMY014 on 05-08-2011
ll_row = dw_1.insertrow(0)
dw_1.setitem(ll_row, "mt_sortorder", dw_1.rowcount())
dw_1.setitem(ll_row, "module_active", 1)
dw_1.scrolltorow(ll_row)
dw_1.post setfocus()
//CR2406 End added by JMY014 on 05-08-2011

end event

type dw_1 from w_system_base`dw_1 within w_module_submodule
integer y = 80
integer width = 1554
integer height = 632
string dragicon = "images\DRAG.ICO"
string dataobject = "d_sq_gr_module"
boolean ib_enablesortindex = true
end type

event dw_1::dragdrop;call super::dragdrop;this.event rowfocuschanged(row)
end event

event dw_1::rowfocuschanging;call super::rowfocuschanging;if currentrow < 1 then return

dw_2.accepttext()
if dw_2.modifiedcount() > 0 then
	if messagebox("Change Request Updates Pending", "Sub-module data changed but not saved. ~n~nWould you like to save data before switching?", Question!, YesNo!, 1) = 1 then
		if cb_update_s.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve(dw_1.getitemnumber(currentrow, "module_id"))
end event

type dw_2 from u_datagrid within w_module_submodule
integer x = 37
integer y = 848
integer width = 1554
integer height = 896
integer taborder = 50
string dragicon = "images\DRAG.ICO"
boolean bringtotop = true
string dataobject = "d_sq_gr_submodule"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
boolean ib_enablesortindex = true
end type

event clicked;call super::clicked;if row <= 0 then return
selectrow(0, false)
selectrow(row, true)
end event

type st_module from statictext within w_module_submodule
integer x = 37
integer y = 16
integer width = 329
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Modules"
boolean focusrectangle = false
end type

type st_2 from statictext within w_module_submodule
integer x = 37
integer y = 788
integer width = 421
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sub-Modules"
boolean focusrectangle = false
end type

type cb_new_s from commandbutton within w_module_submodule
integer x = 553
integer y = 1760
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "N&ew"
end type

event clicked;long		ll_row, ll_currentrow


//CR2438  Begin modified by JMY014 on 05-08-2011
ll_row = dw_2.insertrow(0)

if ll_row < 1 then return

ll_currentrow = dw_1.getrow()
if ll_currentrow <= 0 then return

dw_2.setitem(ll_row, "module_id", dw_1.getitemnumber(ll_currentrow, "module_id"))
dw_2.setitem(ll_row, "mt_sortorder", dw_2.rowcount())
dw_2.setitem(ll_row, "sub_module_active", 1)
dw_2.scrolltorow(ll_row)
dw_2.post setfocus()
//CR2438 End modified by JMY014 on 05-08-2011

end event

type cb_update_s from commandbutton within w_module_submodule
integer x = 901
integer y = 1760
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "U&pdate"
end type

event clicked;n_dw_column_definition lnv_ruledefinition[], inv_null
long ll_ret, ll_errorrow
integer li_errorcolumn
string  ls_message

inv_servicemgr.of_loadservice(inv_validation, "n_dw_validation_service")

lnv_ruledefinition = inv_validation.inv_ruledefinition

//Exclude main module column
inv_validation.inv_ruledefinition[1] = inv_null
inv_validation.inv_ruledefinition[2] = inv_null

dw_2.accepttext()
ll_ret = inv_validation.of_validate(dw_2, ls_message, ll_errorrow, li_errorcolumn)

//Reset column
inv_validation.inv_ruledefinition = lnv_ruledefinition

if ll_ret = C#Return.Failure then
	dw_2.setfocus()
	dw_2.setrow(ll_errorrow)
	dw_2.setcolumn(li_errorcolumn)
	messagebox("Update Error", ls_message)	
	return C#Return.Failure
end if


if dw_2.update() = 1 then
	COMMIT;
	return C#Return.Success
else
	ROLLBACK;
	messagebox("Update Error", "Update failure.")
	return C#Return.Failure
end if
end event

type cb_delete_s from commandbutton within w_module_submodule
integer x = 1248
integer y = 1760
integer width = 343
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "De&lete"
end type

event clicked;long ll_currentrow, ll_row, ll_rows, ll_cont, ll_submodule_id

ll_rows = dw_2.rowcount()
ll_currentrow = dw_2.getrow()
ll_submodule_id = dw_2.getitemnumber(ll_currentrow, "submodule_id")
//Check dependence
if not isnull(ll_submodule_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_REQUEST
	 WHERE CREQ_REQUEST.SUBMODULE_ID = :ll_submodule_id
		AND CREQ_REQUEST.SUBMODULE_ID IS NOT NULL;
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies on this sub-modules.")
	return
end if

//CR2438  Begin modified by JMY014 on 05-08-2011
if MessageBox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!,2) = 1 then
	//Update the sort order column
	for ll_row = ll_rows to ll_currentrow + 1 step -1
		dw_2.setitem(ll_row, "mt_sortorder", ll_row - 1)
	next
	
	//Delete the current row
	dw_2.deleterow(ll_currentrow)
	
	if dw_2.update() = 1 then
		commit;
	else
		rollback;
		messagebox("Update Error", "Update failure.")
	end if
end if
//CR2438 End modified by JMY014 on 05-08-2011
end event

