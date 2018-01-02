$PBExportHeader$w_select_cp_charterer.srw
forward
global type w_select_cp_charterer from mt_w_response
end type
type dw_charterer from u_datagrid within w_select_cp_charterer
end type
end forward

global type w_select_cp_charterer from mt_w_response
integer width = 1975
integer height = 792
string title = "CP Charterer List"
boolean ib_setdefaultbackgroundcolor = true
dw_charterer dw_charterer
end type
global w_select_cp_charterer w_select_cp_charterer

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_select_cp_charterer
   <OBJECT>		This window will not be used any more. </OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	11/06/2013   CR2877       ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

event open;call super::open;long		ll_cerpid, ll_count
string	ls_fullname

n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_charterer)

ll_cerpid = message.doubleparm
if ll_cerpid > 1 then
	dw_charterer.settransobject(sqlca)
	ll_count = dw_charterer.retrieve(ll_cerpid)
else
	ls_fullname = message.stringparm
	ll_count = dw_charterer.insertrow(0)
	dw_charterer.setitem(ll_count, "chart_chart_n_1", ls_fullname)
	dw_charterer.setitem(ll_count, "cal_chart_isprimary", 1)
end if

if ll_count > 0 then
	dw_charterer.scrolltorow(1)
	dw_charterer.selectrow(1, true)
end if

dw_charterer.setfocus()

end event

on w_select_cp_charterer.create
int iCurrent
call super::create
this.dw_charterer=create dw_charterer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_charterer
end on

on w_select_cp_charterer.destroy
call super::destroy
destroy(this.dw_charterer)
end on

type dw_charterer from u_datagrid within w_select_cp_charterer
integer x = 37
integer y = 32
integer width = 1893
integer height = 648
integer taborder = 10
string title = ""
string dataobject = "d_sq_gr_print_charterer"
boolean vscrollbar = true
boolean border = false
end type

