$PBExportHeader$w_performing_agent.srw
$PBExportComments$performing agent
forward
global type w_performing_agent from w_syswin_master
end type
type cb_selectpoc from commandbutton within w_performing_agent
end type
end forward

global type w_performing_agent from w_syswin_master
integer width = 1815
string title = "Performing Agents"
windowtype windowtype = response!
cb_selectpoc cb_selectpoc
end type
global w_performing_agent w_performing_agent

type variables
long	il_companyid
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>		</DESC>
   <RETURN>(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref	Author             Comments
   	06/06/14	CR3427	CCY018			First Version
   </HISTORY>
********************************************************************/
end subroutine

on w_performing_agent.create
int iCurrent
call super::create
this.cb_selectpoc=create cb_selectpoc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_selectpoc
end on

on w_performing_agent.destroy
call super::destroy
destroy(this.cb_selectpoc)
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column[1] = "company_sn"
ls_mandatory_column[2] = "company_n_1"

wf_format_datawindow(dw_1, ls_mandatory_column)

uo_search.of_initialize(dw_1, "company_sn+'#'+company_n_1")
uo_search.sle_search.setfocus()

if isvalid(message.powerobjectparm) then
	if message.powerobjectparm.classname( ) = 's_poc_performing_agent' then
		cb_selectpoc.visible = true
	end if
end if

If uo_global.ii_access_level > 0 then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.rowcount() > 0)
	cb_selectpoc.enabled = true
Else
	dw_1.object.datawindow.readonly = "Yes"
	cb_selectpoc.enabled = false
End if
end event

event ue_predelete;call super::ue_predelete;long ll_row, ll_count, ll_company_id
pointer lp_oldpointer

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
else
	ll_company_id = dw_1.getitemnumber(ll_row, 'company_id')
	lp_oldpointer = setpointer(HourGlass!)
	
	SELECT COUNT(1) into :ll_count FROM POC WHERE POC_PERFORMING_AGENT_NR = :ll_company_id;
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM POC_EST WHERE POC_EST_PERFORMING_AGENT_NR = :ll_company_id;
	end if
	
	setpointer(lp_oldpointer)
	
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the Performing Agent, because it has been used.")
		return c#return.Failure
	end if
end if

return c#return.Success


end event

type cb_cancel from w_syswin_master`cb_cancel within w_performing_agent
integer x = 1426
end type

type cb_refresh from w_syswin_master`cb_refresh within w_performing_agent
end type

type cb_delete from w_syswin_master`cb_delete within w_performing_agent
integer x = 1079
end type

type cb_update from w_syswin_master`cb_update within w_performing_agent
integer x = 731
end type

type cb_new from w_syswin_master`cb_new within w_performing_agent
integer x = 384
end type

type dw_1 from w_syswin_master`dw_1 within w_performing_agent
integer width = 1733
string dataobject = "d_sq_tb_performing_agent"
end type

type uo_search from w_syswin_master`uo_search within w_performing_agent
end type

type st_background from w_syswin_master`st_background within w_performing_agent
end type

type cb_selectpoc from commandbutton within w_performing_agent
boolean visible = false
integer x = 37
integer y = 1676
integer width = 343
integer height = 100
integer taborder = 59
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Select to POC"
end type

event clicked;long	ll_row

ll_row = dw_1.GetRow()

if ll_row <1 then
	MessageBox("Warning", "Please select an Agent from the list.")
	Return
end if

il_companyid = dw_1.getitemnumber( ll_row, "company_id")

Closewithreturn(parent, il_companyid)
end event

