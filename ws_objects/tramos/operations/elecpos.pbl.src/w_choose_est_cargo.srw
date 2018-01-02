$PBExportHeader$w_choose_est_cargo.srw
forward
global type w_choose_est_cargo from mt_w_response
end type
type dw_est_cargo from u_datagrid within w_choose_est_cargo
end type
type cb_delete from commandbutton within w_choose_est_cargo
end type
type cb_new from commandbutton within w_choose_est_cargo
end type
type cb_update from commandbutton within w_choose_est_cargo
end type
end forward

global type w_choose_est_cargo from mt_w_response
integer width = 1166
integer height = 1412
string title = "Estimated Cargo Grades"
boolean ib_setdefaultbackgroundcolor = true
dw_est_cargo dw_est_cargo
cb_delete cb_delete
cb_new cb_new
cb_update cb_update
end type
global w_choose_est_cargo w_choose_est_cargo

type variables
s_poc_est_cargo	istr_poc_est_cargo

boolean	ib_modified

mt_n_dddw_searchasyoutype	inv_searchasyoutype

end variables

forward prototypes
public subroutine documentation ()
public function integer of_update ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_choose_est_cargo
   <OBJECT> Select one or many different cargo grades </OBJECT>
   <USAGE> </USAGE>
   <ALSO> </ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	01/09/2011   2531         ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

public function integer of_update ();/********************************************************************
   of_Update
   <DESC>	Update Estimated Cargo	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	When click the update button or before close window </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	02/09/2011   2531         ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_row, ll_cargo_rows, ll_found
integer	li_return
string	ls_grade_name, ls_cargo_list

CONSTANT string ls_DELIMITER = "~n"

dw_est_cargo.accepttext()

ll_cargo_rows = dw_est_cargo.rowcount()
for ll_row = 1 to ll_cargo_rows
	ls_grade_name = dw_est_cargo.getitemstring(ll_row, "grade_name")
	if not isnull(ls_grade_name) and ls_grade_name <> "" then
		ll_found = dw_est_cargo.find('grade_name = "' + ls_grade_name + '"', ll_row + 1, ll_cargo_rows + 1)
		if ll_found > 0 then
			messagebox("Update Error", "You are attempting to create a duplicate!", stopsign!)
			dw_est_cargo.scrolltorow(ll_found)
			dw_est_cargo.setrow(ll_found)
			dw_est_cargo.post setfocus()
			return c#return.Failure
		end if
		ls_cargo_list += ls_grade_name + ls_DELIMITER
	end if
next

if right(ls_cargo_list, len(ls_DELIMITER)) = ls_DELIMITER then ls_cargo_list = left(ls_cargo_list, len(ls_cargo_list) - len(ls_DELIMITER))

choose case istr_poc_est_cargo.si_poc_type
	case 0		//Actual
		UPDATE POC
			SET EST_CD_GRADE_LIST = :ls_cargo_list
		 WHERE VESSEL_NR = :istr_poc_est_cargo.sl_vessel_nr AND
				 VOYAGE_NR = :istr_poc_est_cargo.ss_voyage_nr AND
				 PORT_CODE = :istr_poc_est_cargo.ss_port_code AND
				 PCN       = :istr_poc_est_cargo.si_pcn;
	case 1		//Estimated
		UPDATE POC_EST
			SET EST_CD_GRADE_LIST = :ls_cargo_list
		 WHERE VESSEL_NR = :istr_poc_est_cargo.sl_vessel_nr AND
				 VOYAGE_NR = :istr_poc_est_cargo.ss_voyage_nr AND
				 PORT_CODE = :istr_poc_est_cargo.ss_port_code AND
				 PCN       = :istr_poc_est_cargo.si_pcn;
end choose

if SQLCA.SQLCode = 0 then
	COMMIT;
	dw_est_cargo.setrow(dw_est_cargo.getrow())		//select current column text
	dw_est_cargo.setfocus()
	cb_update.enabled = false
	ib_modified = false
	li_return = c#return.Success
else
	ROLLBACK;
	messagebox("Update Error", "Failed to update the Estimated Cargo.", stopsign!)
	li_return = c#return.Failure
end if

return li_return

end function

on w_choose_est_cargo.create
int iCurrent
call super::create
this.dw_est_cargo=create dw_est_cargo
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_update=create cb_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_est_cargo
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_update
end on

on w_choose_est_cargo.destroy
call super::destroy
destroy(this.dw_est_cargo)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_update)
end on

event open;call super::open;long		ll_voyagefinished
string	ls_cargo_list

n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style
datawindowchild		ldwc_child

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_est_cargo)
lnv_style.of_autoadjustdddwwidth(dw_est_cargo)

dw_est_cargo.getchild("grade_name", ldwc_child)
ldwc_child.settransobject(SQLCA)
ldwc_child.retrieve()

istr_poc_est_cargo = message.powerobjectparm
choose case istr_poc_est_cargo.si_poc_type
	case 0		//Actual
		SELECT VOYAGE_FINISHED
		  INTO :ll_voyagefinished
		  FROM VOYAGES
		 WHERE VESSEL_NR = :istr_poc_est_cargo.sl_vessel_nr AND
		       VOYAGE_NR = :istr_poc_est_cargo.ss_voyage_nr;
		
		if ll_voyagefinished <> 0 then
			dw_est_cargo.modify("datawindow.readonly = 'yes' datawindow.selected.mouse = 'no' grade_name.protect = '1'")
			dw_est_cargo.modify("datawindow.color = " + string(c#color.MT_FORMDETAIL_BG))
			dw_est_cargo.modify("datawindow.detail.color = " + string(c#color.MT_FORMDETAIL_BG))
			cb_new.enabled    = false
			cb_update.enabled = false
			cb_delete.enabled = false
		end if
		
		SELECT EST_CD_GRADE_LIST
		  INTO :ls_cargo_list
		  FROM POC
		 WHERE VESSEL_NR = :istr_poc_est_cargo.sl_vessel_nr AND
				 VOYAGE_NR = :istr_poc_est_cargo.ss_voyage_nr AND
				 PORT_CODE = :istr_poc_est_cargo.ss_port_code AND
				 PCN       = :istr_poc_est_cargo.si_pcn;
	case 1		//Estimated
		SELECT EST_CD_GRADE_LIST
		  INTO :ls_cargo_list
		  FROM POC_EST
		 WHERE VESSEL_NR = :istr_poc_est_cargo.sl_vessel_nr AND
				 VOYAGE_NR = :istr_poc_est_cargo.ss_voyage_nr AND
				 PORT_CODE = :istr_poc_est_cargo.ss_port_code AND
				 PCN       = :istr_poc_est_cargo.si_pcn;
end choose

if isnull(ls_cargo_list) then ls_cargo_list = ""
dw_est_cargo.importstring(ls_cargo_list)

cb_delete.enabled = (dw_est_cargo.rowcount() > 0 and ll_voyagefinished = 0)

end event

event closequery;call super::closequery;integer	li_return

dw_est_cargo.accepttext()

if ib_modified then
	li_return = messagebox("Data Not Saved", "Would you like to update data before closing?", Question!, YesNo!, 1)
	if li_return = 1 then
		li_return = of_update()
		if li_return < 0 then
			return 1
		end if
	end if
end if

end event

type dw_est_cargo from u_datagrid within w_choose_est_cargo
integer x = 37
integer y = 32
integer width = 1079
integer height = 1156
integer taborder = 10
string title = ""
string dataobject = "d_ex_gr_est_cargo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_update.enabled = true
ib_modified = true

end event

event editchanged;call super::editchanged;choose case dwo.name
	case "grade_name"
		inv_searchasyoutype.event mt_editchanged(row, dwo, data, dw_est_cargo)
end choose

cb_update.enabled = true
ib_modified = true

end event

event constructor;call super::constructor;inv_searchasyoutype.of_setautofilter(true)

end event

event rowfocuschanged;call super::rowfocuschanged;string	ls_value

dwobject	ldwo_object

if this.getcolumnname() = "grade_name" then
	if currentrow <= 0 then return
	
	ls_value = this.getitemstring(currentrow, "grade_name")
	if isnull(ls_value) then ls_value = ""
	
	ldwo_object = this.object.grade_name
	inv_searchasyoutype.event mt_editchanged(currentrow, ldwo_object, ls_value, dw_est_cargo)
end if

end event

type cb_delete from commandbutton within w_choose_est_cargo
integer x = 773
integer y = 1200
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;long	ll_row

dw_est_cargo.deleterow(0)

ll_row = dw_est_cargo.getrow()
if ll_row > 0 then
	dw_est_cargo.scrolltorow(ll_row)
	dw_est_cargo.setrow(ll_row)
end if

dw_est_cargo.setfocus()

this.enabled = (dw_est_cargo.rowcount() > 0)
cb_update.enabled = true
ib_modified = true

end event

type cb_new from commandbutton within w_choose_est_cargo
integer x = 78
integer y = 1200
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
boolean default = true
end type

event clicked;long	ll_row

ll_row = dw_est_cargo.insertrow(0)
dw_est_cargo.scrolltorow(ll_row)
dw_est_cargo.setrow(ll_row)
dw_est_cargo.post setfocus()

cb_update.enabled = true
cb_delete.enabled = true
ib_modified = true

end event

type cb_update from commandbutton within w_choose_est_cargo
integer x = 425
integer y = 1200
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Update"
end type

event clicked;setpointer(hourglass!)
of_update()
setpointer(arrow!)

end event

