$PBExportHeader$w_choose_non_cargo_agents.srw
$PBExportComments$This window lets the user choose non-cargo agents for a POC.
forward
global type w_choose_non_cargo_agents from mt_w_response
end type
type cb_update from mt_u_commandbutton within w_choose_non_cargo_agents
end type
type cb_delete from mt_u_commandbutton within w_choose_non_cargo_agents
end type
type cb_new from mt_u_commandbutton within w_choose_non_cargo_agents
end type
type dw_non_cargo_agents from uo_datawindow within w_choose_non_cargo_agents
end type
end forward

global type w_choose_non_cargo_agents from mt_w_response
integer width = 928
integer height = 1080
string title = "Non-Cargo Agents"
boolean ib_setdefaultbackgroundcolor = true
cb_update cb_update
cb_delete cb_delete
cb_new cb_new
dw_non_cargo_agents dw_non_cargo_agents
end type
global w_choose_non_cargo_agents w_choose_non_cargo_agents

type variables
s_poc_non_cargo_agents is_struct
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_choose_non_cargo_agents
	
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

event open;call super::open;n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle

is_struct = message.powerobjectparm

dw_non_cargo_agents.settransobject(sqlca)

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")

lnv_dwStyle.of_dwlistformater(dw_non_cargo_agents)

this.move(300,300)

dw_non_cargo_agents.retrieve(is_struct.si_vessel_nr,is_struct.ss_voyage_nr,is_struct.ss_port_code,is_struct.si_pcn)

end event

on w_choose_non_cargo_agents.create
int iCurrent
call super::create
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_non_cargo_agents=create dw_non_cargo_agents
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_update
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.dw_non_cargo_agents
end on

on w_choose_non_cargo_agents.destroy
call super::destroy
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_non_cargo_agents)
end on

event closequery;call super::closequery;dw_non_cargo_agents.acceptText()

IF dw_non_cargo_agents.ModifiedCount() > 0 THEN

	IF MessageBox("Data Not Saved", "Would you like to update data before closing?", Question!, YesNo!, 1) = 1 THEN
		this.cb_update.event clicked( )
	end if
END IF
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_choose_non_cargo_agents
end type

type cb_update from mt_u_commandbutton within w_choose_non_cargo_agents
integer x = 571
integer y = 244
integer taborder = 50
string text = "&Update"
end type

event clicked;call super::clicked;dw_non_cargo_agents.accepttext()
dw_non_cargo_agents.update()
end event

type cb_delete from mt_u_commandbutton within w_choose_non_cargo_agents
integer x = 571
integer y = 132
integer taborder = 50
string text = "&Delete"
end type

event clicked;call super::clicked;if dw_non_cargo_agents.getrow() < 1 then return
If MessageBox("Delete Message","You are about to DELETE a Non-Cargo Agent.~r~n~r~nAre you sure?",Question!,YesNo!,2) = 2 THEN Return
dw_non_cargo_agents.deleterow(dw_non_cargo_agents.getrow())
dw_non_cargo_agents.update()
end event

type cb_new from mt_u_commandbutton within w_choose_non_cargo_agents
integer x = 571
integer y = 20
integer taborder = 50
string text = "&New "
boolean default = true
end type

event clicked;call super::clicked;long ll_row
dw_non_cargo_agents.insertrow(0)
dw_non_cargo_agents.scrolltorow(dw_non_cargo_agents.rowcount())
ll_row = dw_non_cargo_agents.rowcount()
dw_non_cargo_agents.setitem(ll_row,"tra_ncag_vessel_nr",is_struct.si_vessel_nr)
dw_non_cargo_agents.setitem(ll_row,"tra_ncag_voyage_nr",is_struct.ss_voyage_nr)
dw_non_cargo_agents.setitem(ll_row,"tra_ncag_port_code",is_struct.ss_port_code)
dw_non_cargo_agents.setitem(ll_row,"tra_ncag_pcn",is_struct.si_pcn)
end event

type dw_non_cargo_agents from uo_datawindow within w_choose_non_cargo_agents
integer x = 18
integer y = 16
integer width = 530
integer height = 960
integer taborder = 10
string dataobject = "d_poc_non_cargo_agents"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;call super::itemchanged;integer	li_null;setNull(li_null)

accepttext( )
choose case dwo.name
	CASE "tra_ncag_agent_nr"
		if f_agent_active( long(data)) = false then 
			MessageBox("Validation Error", "Selected Agent is marked as inactive. Please select another Agent")
			if this.getItemNumber(row, "tra_ncag_agent_nr", primary!, true) <>  this.getItemNumber(row, "tra_ncag_agent_nr", primary!, false) then
				this.setItem(row, "tra_ncag_agent_nr", this.getItemNumber(row, "tra_ncag_agent_nr", primary!, true) )
			else
				this.setItem(row, "tra_ncag_agent_nr", li_null)
			end if
			setColumn("tra_ncag_agent_nr")
			return 2
		end if
end choose
end event

