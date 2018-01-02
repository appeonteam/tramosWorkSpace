$PBExportHeader$w_syswin_master.srw
forward
global type w_syswin_master from w_system_base
end type
type uo_search from u_searchbox within w_syswin_master
end type
type st_background from u_topbar_background within w_syswin_master
end type
end forward

global type w_syswin_master from w_system_base
integer width = 1435
integer height = 1880
string title = "System Tables"
boolean ib_update_after_del = true
uo_search uo_search
st_background st_background
end type
global w_syswin_master w_syswin_master

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_syswin_master
   <OBJECT> Template window to maintain system tables	</OBJECT>
   <USAGE>	   </USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
		Date     	CR-Ref   Author      Comments
		00/00/00									First Version
		09/08/11 	CR2542   JMC112  		Change to response window, add constraint for
													performing agents.
		25/08/11  	CR2569	JMC112		Fix, performing agents can be edited by users,
													not only superusers.
		12/10/11	   CRD3-2  	ZSW001		Background color changed
		06/03/12    M5-8     LGX001      add the case of voyage type
		10/07/12		CRM		WWG004		Add system Configuration for contract type 
													and commerical segment.
		12/03/13		CR2658	LHG008		Add system Configuration of zone for consumption type
		06/06/14		CR3427	CCY018		Set enabled or unenabled for the button.
		06/06/14		CR3427	CCY018		Modified event clicked.
   </HISTORY>
********************************************************************/
end subroutine

on w_syswin_master.create
int iCurrent
call super::create
this.uo_search=create uo_search
this.st_background=create st_background
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
this.Control[iCurrent+2]=this.st_background
end on

on w_syswin_master.destroy
call super::destroy
destroy(this.uo_search)
destroy(this.st_background)
end on

event ue_postupdate;call super::ue_postupdate;/********************************************************************
   ue_postupdate
   <DESC>Perform Post Update process. </DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	 </USAGE>
   <HISTORY>
   	Date		CR-Ref		Author		Comments
   	29/07/14	CR3427		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_row

dw_1.setredraw(false)
for ll_row = dw_1.rowcount() to 1 step -1
	if dw_1.getitemstatus(ll_row, 0, primary!) = new! then
		dw_1.rowsdiscard( ll_row, ll_row, primary!)
	end if
next
dw_1.setredraw(true)

cb_update.enabled = false

return C#Return.Success
end event

event ue_postadd;call super::ue_postadd;cb_delete.Enabled = true
cb_update.Enabled = true

return C#Return.Success
end event

event ue_postdelete;call super::ue_postdelete;if dw_1.rowcount( ) = 0 then cb_delete.enabled = false
if not ib_update_after_del then cb_update.enabled = true

return C#Return.Success
end event

event open;call super::open;uo_search.sle_search.border = false
uo_search.backcolor = c#color.mt_listheader_bg
uo_search.st_search.backcolor = c#color.mt_listheader_bg
uo_search.st_search.textcolor = c#color.mt_listheader_text

end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_syswin_master
end type

type cb_cancel from w_system_base`cb_cancel within w_syswin_master
integer x = 1061
integer y = 1676
end type

event cb_cancel::clicked;call super::clicked;if dw_1.object.datawindow.readonly <> "yes" then
	cb_delete.enabled = (dw_1.rowcount() > 0)
end if
end event

type cb_refresh from w_system_base`cb_refresh within w_syswin_master
integer x = 2542
integer y = 1936
end type

type cb_delete from w_system_base`cb_delete within w_syswin_master
integer x = 713
integer y = 1676
boolean enabled = false
end type

type cb_update from w_system_base`cb_update within w_syswin_master
integer x = 366
integer y = 1676
boolean enabled = false
end type

type cb_new from w_system_base`cb_new within w_syswin_master
integer x = 18
integer y = 1676
boolean enabled = false
end type

type dw_1 from w_system_base`dw_1 within w_syswin_master
integer y = 240
integer width = 1353
integer height = 1420
boolean ib_columntitlesort = true
end type

event dw_1::itemchanged;call super::itemchanged;cb_update.Enabled = true
end event

event dw_1::editchanged;call super::editchanged;cb_update.Enabled = true
end event

event dw_1::ue_clicked;call super::ue_clicked;if row = 0 then
	if dwo.type = "text" then this.event rowfocuschanged(this.getrow())
end if
end event

type uo_search from u_searchbox within w_syswin_master
integer x = 37
integer y = 32
integer taborder = 30
boolean ib_standard_ui = true
end type

on uo_search.destroy
call u_searchbox::destroy
end on

event constructor;call super::constructor;this.of_setlabel("Search", false)
this.of_setlabelcolor(c#color.HighlightText)
end event

type st_background from u_topbar_background within w_syswin_master
integer width = 4567
end type

