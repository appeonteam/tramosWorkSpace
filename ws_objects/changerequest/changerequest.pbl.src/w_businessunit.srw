$PBExportHeader$w_businessunit.srw
forward
global type w_businessunit from w_maintain_base
end type
end forward

global type w_businessunit from w_maintain_base
integer width = 3739
integer height = 1872
string title = "Business Units"
end type
global w_businessunit w_businessunit

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_businessunit
   <OBJECT>		Maintain Business Unit	</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
		02-04-2013 CR2614       LHG008        Change GUI, add status maintainance for Business Unit
		28/08/2014 CR3781	    CCY018		 The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_businessunit.create
call super::create
end on

on w_businessunit.destroy
call super::destroy
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"bu_name", "bu_sort"}

wf_format_datawindow(dw_1, ls_mandatory_column)

wf_register('bu_accessstatus', 'status_id')

end event

type st_hidemenubar from w_maintain_base`st_hidemenubar within w_businessunit
end type

type cb_cancel from w_maintain_base`cb_cancel within w_businessunit
integer x = 3351
integer y = 1664
end type

type cb_refresh from w_maintain_base`cb_refresh within w_businessunit
integer x = 3785
integer y = 1808
end type

type cb_delete from w_maintain_base`cb_delete within w_businessunit
integer x = 3003
integer y = 1664
end type

event cb_delete::clicked;long ll_cont, ll_bu_id

ll_bu_id = dw_1.getitemnumber(dw_1.getrow(), "bu_id")
//Check dependence
if not isnull(ll_bu_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_REQUEST
	 WHERE CREQ_REQUEST.BU_ID = :ll_bu_id
		AND CREQ_REQUEST.BU_ID IS NOT NULL;
		
	if ll_cont = 0 then
		SELECT COUNT(1) INTO :ll_cont
		  FROM PROFIT_C
		 WHERE PROFIT_C.BU_FINANCE_HANDLED_BY = :ll_bu_id
			AND PROFIT_C.BU_FINANCE_HANDLED_BY IS NOT NULL;
	end if
	
	if ll_cont = 0 then
		SELECT COUNT(1) INTO :ll_cont
		  FROM USERS
		 WHERE USERS.BU_ID = :ll_bu_id
			AND USERS.BU_ID IS NOT NULL;
	end if
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies such as users on this business unit.")
	return
end if

call super::clicked

end event

type cb_update from w_maintain_base`cb_update within w_businessunit
integer x = 2656
integer y = 1664
end type

type cb_new from w_maintain_base`cb_new within w_businessunit
integer x = 2309
integer y = 1664
end type

type dw_1 from w_maintain_base`dw_1 within w_businessunit
integer width = 2725
integer height = 1616
string dataobject = "d_sq_tb_business_unit"
boolean hscrollbar = true
end type

event dw_1::clicked;call super::clicked;string ls_accesstype

if row > 0 then
	this.setrow(row)
	this.selectrow(0, false)
	this.selectrow(row, true)
end if

if dwo.name = "p_accesstype" then

	ls_accesstype = dw_1.getitemstring(row, "bu_accesstypes")

	openwithparm(w_bu_accesstype, ls_accesstype)
	
	if ls_accesstype = message.stringparm then
		//Do nothing
	else
		dw_1.setitem(row, "bu_accesstypes", message.stringparm)
	end if
end if
end event

type dw_detail from w_maintain_base`dw_detail within w_businessunit
integer x = 2798
integer width = 896
integer height = 1616
string dataobject = "d_sq_gr_status_select"
end type

