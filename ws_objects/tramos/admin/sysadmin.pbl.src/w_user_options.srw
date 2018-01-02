$PBExportHeader$w_user_options.srw
forward
global type w_user_options from mt_w_sheet
end type
type cb_cancel from commandbutton within w_user_options
end type
type cb_ok from commandbutton within w_user_options
end type
type dw_useroptions from mt_u_datawindow within w_user_options
end type
end forward

global type w_user_options from mt_w_sheet
integer width = 2880
integer height = 2152
string title = "User Options"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
event ue_retrieve ( )
cb_cancel cb_cancel
cb_ok cb_ok
dw_useroptions dw_useroptions
end type
global w_user_options w_user_options

forward prototypes
public subroutine documentation ()
end prototypes

event ue_retrieve();/********************************************************************
   ue_retrieve()
   <DESC>	 retrieve record when open or cancal
   <RETURN>	integer:
           	
            
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	open,cb_cancal.clicked()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		18/07/14	CR3562       KSH092  First Version
   </HISTORY>
********************************************************************/

datawindowchild	ldwc, ldwc_agent

dw_useroptions.getChild("office_nr", ldwc)
ldwc.setTransObject(sqlca)

/* for all users except the user administrator retrieve offices */
if uo_global.is_userid <> "sa" then ldwc.retrieve(uo_global.is_userid)
ldwc.insertrow(1)

dw_useroptions.setTransObject(sqlca)

if uo_global.is_userid = "sa" then 
	/* if the user i 'sa' there will not be any settings to retrieve for the user */
	dw_useroptions.insertRow(0)
else
	dw_useroptions.retrieve(uo_global.is_userid)
end if

// add null agent_nr value for select.
dw_useroptions.getchild("agent_nr", ldwc_agent)
ldwc_agent.insertrow(1)

/* Only administrators can be set as developers */
if uo_global.ii_access_level <> 3 then
	dw_useroptions.settaborder( "delevoper", 0)
end if	
end event

public subroutine documentation ();/*************************************************************
   ObjectName: 
   <OBJECT>w_user_options</OBJECT>
   <DESC>Standard user user_options window for Tramos Application</DESC>
   <USAGE> </USAGE>
   <ALSO> </ALSO>
		Date    		Ref   		Author		Comments
		21/05/11		CR2415		TTY004		Added a column AGENT_NR to use default cargo agent
		24/05/11		CR2410		WWG004		Added a column poc_setting to save user's setting.
		21/12/13		CR3240		XSZ004		Alerts view configuratioin
		18/07/14		CR3562		KSH092		Added a column default consumption zone.
		08/10/15		CR4161		XSZ004		Remove informaker reports.
		25/03/16		CR4157		LHG008		Default Speed extended
  ********************************************************************/

end subroutine

on w_user_options.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_useroptions=create dw_useroptions
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_useroptions
end on

on w_user_options.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_useroptions)
end on

event closequery;call super::closequery;
blob blb_changes
int li_return

dw_useroptions.accepttext()
if dw_useroptions.modifiedcount( ) > 0 then
	CHOOSE CASE MessageBox("Data Not Saved", "Data modified but not saved,~n~r~n~r Do you like to save data ?", Question!, YesNoCancel!)
			CASE 1
			    cb_ok. event clicked()
			CASE 2
				// No, just exit
			CASE 3
				// Cancel, dont close
				li_return = 1
	END CHOOSE
	
end If



Message.ReturnValue = li_return


end event

event open;call super::open;this.event ue_retrieve()
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_user_options
end type

type cb_cancel from commandbutton within w_user_options
integer x = 2496
integer y = 1948
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;parent.event ue_retrieve()

end event

type cb_ok from commandbutton within w_user_options
integer x = 2149
integer y = 1948
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
boolean default = true
end type

event clicked;/* If 'sa' there is no need for saving anything. User not registred in USERS table  */
if uo_global.is_userid = "sa" then 
	close(parent)
	return
end if

/* General Options */
dw_useroptions.accepttext( )

if dw_useroptions.getitemnumber(1, "calc_full_speed") = 2 then
	if isnull(dw_useroptions.getitemnumber(1, "calc_default_speed")) then
		dw_useroptions.setitem(1, "calc_default_speed", 0.00)
	elseif dw_useroptions.getitemnumber(1, "calc_default_speed") < 0 then
		messagebox("Validation Error", "The default speed instruction cannot be negative.", StopSign!)
		dw_useroptions.setcolumn("calc_default_speed")
		dw_useroptions.selecttext(1, len(dw_useroptions.gettext()))
		dw_useroptions.setfocus()
		return
	end if
end if

if dw_useroptions.modifiedcount( ) > 0 then
	if dw_useroptions.Update() = 1 then
		dw_useroptions.resetupdate()
		commit;
	else
		MessageBox("Update Failed", "Updating User Options Failed!")
		rollback;
		return 
	end if
end if

uo_global.uf_load( )

end event

type dw_useroptions from mt_u_datawindow within w_user_options
integer width = 2871
integer height = 1936
integer taborder = 30
string dataobject = "d_sq_ff_user_options"
boolean border = false
end type

event itemchanged;call super::itemchanged;choose case dwo.name
	case "poc_enable_auto_schedule"
		this.setitem(row, "poc_enabled_notification", long(data))
		
	case 'calc_full_speed'
		if integer(dw_useroptions.gettext()) = 2 then
			dw_useroptions.post setcolumn("calc_default_speed")
		end if
end choose
end event

event clicked;call super::clicked;choose case dwo.name
	case 'b_changewizard'
		s_opencalc_parm lstr_opencalc_parm
		
		OpenWithParm(w_calc_select_wizard,1)
		lstr_opencalc_parm = Message.PowerObjectParm
		
		if isvalid(lstr_opencalc_parm) then
			If lstr_opencalc_parm.s_wizardtitle<>"" Then
			dw_useroptions.setItem(1, "calc_default_wizard", lstr_opencalc_parm.s_wizardtitle)
			End if
		end if
	case 'b_clear'
		dw_useroptions.setItem(1, "calc_default_wizard", "")
	case 'calc_full_speed'
		if integer(dw_useroptions.gettext()) = 2 then
			dw_useroptions.setcolumn("calc_default_speed")
		end if
end choose
end event

event itemfocuschanged;call super::itemfocuschanged;if dwo.name = "calc_default_speed" and row > 0 then
	dw_useroptions.setitem(1, "calc_full_speed", 2)
	dw_useroptions.selecttext(1, len(dw_useroptions.gettext()))
end if
end event

