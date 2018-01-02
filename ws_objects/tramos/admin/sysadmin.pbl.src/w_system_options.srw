$PBExportHeader$w_system_options.srw
forward
global type w_system_options from mt_w_sheet
end type
type cb_cancel from commandbutton within w_system_options
end type
type cb_ok from commandbutton within w_system_options
end type
type tab_options from tab within w_system_options
end type
type tabpage_local from userobject within tab_options
end type
type dw_rulesetup from mt_u_datawindow within tabpage_local
end type
type dw_cms_path from mt_u_datawindow within tabpage_local
end type
type dw_local from mt_u_datawindow within tabpage_local
end type
type tabpage_local from userobject within tab_options
dw_rulesetup dw_rulesetup
dw_cms_path dw_cms_path
dw_local dw_local
end type
type tabpage_citrix from userobject within tab_options
end type
type dw_citrix from mt_u_datawindow within tabpage_citrix
end type
type tabpage_citrix from userobject within tab_options
dw_citrix dw_citrix
end type
type tabpage_citrix_backup from userobject within tab_options
end type
type dw_citrix_backup from mt_u_datawindow within tabpage_citrix_backup
end type
type tabpage_citrix_backup from userobject within tab_options
dw_citrix_backup dw_citrix_backup
end type
type tab_options from tab within w_system_options
tabpage_local tabpage_local
tabpage_citrix tabpage_citrix
tabpage_citrix_backup tabpage_citrix_backup
end type
end forward

global type w_system_options from mt_w_sheet
integer width = 3150
integer height = 2444
string title = "System Options"
boolean maxbox = false
boolean resizable = false
cb_cancel cb_cancel
cb_ok cb_ok
tab_options tab_options
end type
global w_system_options w_system_options

forward prototypes
public subroutine documentation ()
public function boolean of_is_it_admin ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
	Date   			Ref    		Author		Comments
	17-04-11			CR2381		AGL027    	added accruals lock to datawindow and adjusted sizes
	11-07-13			CR3286		LHC010		added MSPS setup and adjusted sizes
	08-01-14			CR3240		XSZ004		Ruls engine configuration
	28-09-14			CR3753		SSX014		Current file database configuration
	07-09-15			CR3226		XSZ004		Change label for Bunker Types.
	08/10/15			CR4161		XSZ004		Remove informaker reports.
	09/10/15			CR4112		LHG008		Send email to the general operations when chartering fixes a calculation
********************************************************************/

end subroutine

public function boolean of_is_it_admin ();/********************************************************************
   of_is_it_admin
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
            <LI>true
            <LI>false	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/11/14 CR3753        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_cnt

if uo_global.is_userid = 'sa' then
	return true
else
	if uo_global.ii_access_level <> c#usergroup.#ADMINISTRATOR then
		return false
	else
		SELECT count(*) INTO :ll_cnt
		FROM USERS 
		WHERE USER_GROUP = :uo_global.ii_access_level and BU_ID = 5
		AND USERID = :uo_global.is_userid;
		return (ll_cnt > 0)
	end if
end if

end function

on w_system_options.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.tab_options=create tab_options
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.tab_options
end on

on w_system_options.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.tab_options)
end on

event open;call super::open;tab_options.tabpage_local.dw_local.setTransObject(sqlca)
tab_options.tabpage_local.dw_cms_path.setTransObject(sqlca)
tab_options.tabpage_local.dw_rulesetup.settransobject(sqlca)

tab_options.tabpage_local.dw_local.sharedata(tab_options.tabpage_citrix.dw_citrix)
tab_options.tabpage_local.dw_local.sharedata(tab_options.tabpage_citrix_backup.dw_citrix_backup)

tab_options.tabpage_local.dw_local.post retrieve()
tab_options.tabpage_local.dw_cms_path.post retrieve()
tab_options.tabpage_local.dw_rulesetup.post retrieve()

/* Only administrators can change system Options */ 
if uo_global.ii_access_level <> 3 then
	tab_options.tabpage_local.dw_local.Object.DataWindow.ReadOnly = "Yes"
	tab_options.tabpage_local.dw_cms_path.Object.DataWindow.ReadOnly = "Yes"
	tab_options.tabpage_citrix.dw_citrix.Object.DataWindow.ReadOnly = "Yes"
	tab_options.tabpage_citrix_backup.dw_citrix_backup.Object.DataWindow.ReadOnly = "Yes"
	cb_ok.enabled = FALSE
end if

tab_options.tabpage_local.dw_rulesetup.object.datawindow.readonly = true
if uo_global.ii_access_level = 3 then
	if uo_global.ib_msps_visible then
		tab_options.tabpage_local.dw_rulesetup.object.datawindow.readonly = not uo_global.ib_rul_generatealerts
	end if
end if

if of_is_it_admin() then
	tab_options.tabpage_local.dw_local.modify("current_filedb.protect=0 current_filedb.background.mode=2 current_filedb.background.color=1073741824")
else
	tab_options.tabpage_local.dw_local.modify("current_filedb.protect=1 current_filedb.background.mode=1 current_filedb.background.color=553648127")
end if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_system_options
end type

type cb_cancel from commandbutton within w_system_options
integer x = 2729
integer y = 2244
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;close(parent)
end event

type cb_ok from commandbutton within w_system_options
integer x = 2382
integer y = 2244
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;
/* General Options */
tab_options.tabpage_local.dw_local.acceptText()
tab_options.tabpage_local.dw_cms_path.acceptText()
tab_options.tabpage_citrix.dw_citrix.accepttext()
tab_options.tabpage_citrix_backup.dw_citrix_backup.accepttext( )

if tab_options.tabpage_local.dw_local.modifiedcount( ) &
+ tab_options.tabpage_citrix.dw_citrix.modifiedcount( ) &
+ tab_options.tabpage_local.dw_rulesetup.modifiedcount()&
+ tab_options.tabpage_citrix_backup.dw_citrix_backup.modifiedcount( )  > 0 then
	if tab_options.tabpage_local.dw_local.Update() = 1 and tab_options.tabpage_local.dw_rulesetup.update() = 1 then
		commit;
	else
		MessageBox("Update Failed", "Updating System Options Failed!")
		rollback;
		return 
	end if
end if

/* CMS Path */
tab_options.tabpage_local.dw_cms_path.acceptText()
if tab_options.tabpage_local.dw_cms_path.modifiedcount( )  > 0 then
	if tab_options.tabpage_local.dw_cms_path.update() = 1 then
		commit;
	else
		MessageBox("Update Failed", "Updating System Options (CMS PATH) Failed!")
		rollback;
		return 
	end if
end if

uo_global.uf_load( )
close(parent)


end event

type tab_options from tab within w_system_options
integer x = 73
integer y = 32
integer width = 2999
integer height = 2196
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_local tabpage_local
tabpage_citrix tabpage_citrix
tabpage_citrix_backup tabpage_citrix_backup
end type

on tab_options.create
this.tabpage_local=create tabpage_local
this.tabpage_citrix=create tabpage_citrix
this.tabpage_citrix_backup=create tabpage_citrix_backup
this.Control[]={this.tabpage_local,&
this.tabpage_citrix,&
this.tabpage_citrix_backup}
end on

on tab_options.destroy
destroy(this.tabpage_local)
destroy(this.tabpage_citrix)
destroy(this.tabpage_citrix_backup)
end on

type tabpage_local from userobject within tab_options
integer x = 18
integer y = 100
integer width = 2962
integer height = 2080
long backcolor = 67108864
string text = "Local"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_rulesetup dw_rulesetup
dw_cms_path dw_cms_path
dw_local dw_local
end type

on tabpage_local.create
this.dw_rulesetup=create dw_rulesetup
this.dw_cms_path=create dw_cms_path
this.dw_local=create dw_local
this.Control[]={this.dw_rulesetup,&
this.dw_cms_path,&
this.dw_local}
end on

on tabpage_local.destroy
destroy(this.dw_rulesetup)
destroy(this.dw_cms_path)
destroy(this.dw_local)
end on

type dw_rulesetup from mt_u_datawindow within tabpage_local
integer x = 315
integer y = 1100
integer width = 750
integer height = 512
integer taborder = 40
string dataobject = "d_sq_tb_rules_setup"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_cms_path from mt_u_datawindow within tabpage_local
integer x = 32
integer y = 1820
integer width = 2889
integer height = 224
integer taborder = 30
string dataobject = "d_sq_ff_cms_path"
boolean border = false
end type

type dw_local from mt_u_datawindow within tabpage_local
integer x = 32
integer width = 2889
integer height = 1932
integer taborder = 30
string dataobject = "d_sq_ff_system_options"
boolean border = false
end type

event itemchanged;call super::itemchanged;long ll_other, ll_value
int li_row, li_count

choose case dwo.name
	case "msps_visible", "rul_generatealerts"
		ll_value = long(data)
		
		if dwo.name = "msps_visible" then
			this.setitem(row, "msps_shownoon", ll_value)
			this.setitem(row, "msps_noonbuttons", ll_value)
			this.setitem(row, "msps_showheating", ll_value)
			this.setitem(row, "msps_heatingbuttons", ll_value)
			this.setitem(row, "msps_showarrival", ll_value)
			this.setitem(row, "msps_arrivalbuttons", ll_value)
			this.setitem(row, "msps_showcanal", ll_value)
			this.setitem(row, "msps_canalbuttons", ll_value)
			this.setitem(row, "msps_showfwodrift", ll_value)
			this.setitem(row, "msps_fwodriftbuttons", ll_value)
			this.setitem(row, "msps_showload", ll_value)
			this.setitem(row, "msps_loadbuttons", ll_value)
			this.setitem(row, "msps_loadcargo", ll_value)
			this.setitem(row, "msps_showdischarge", ll_value)
			this.setitem(row, "msps_dischargebuttons", ll_value)
			this.setitem(row, "msps_dischargecargo", ll_value)
			this.setitem(row, "rul_generatealerts", ll_value)
		end if
		
		tab_options.tabpage_local.dw_rulesetup.object.datawindow.readonly = ll_value = 0
		li_count = tab_options.tabpage_local.dw_rulesetup.rowcount()
		for li_row = 1 to li_count
			tab_options.tabpage_local.dw_rulesetup.setitem(li_row, "rul_enabled", ll_value)
		next
		
	case "msps_shownoon"
		this.setitem(row, "msps_noonbuttons", long(data))
	case "msps_showheating"
		this.setitem(row, "msps_heatingbuttons", long(data))
	case "msps_showarrival"
		this.setitem(row, "msps_arrivalbuttons", long(data))
	case "msps_showcanal"
		this.setitem(row, "msps_canalbuttons", long(data))
	case "msps_showfwodrift"
		this.setitem(row, "msps_fwodriftbuttons", long(data))
	case "msps_showload"
		this.setitem(row, "msps_loadbuttons", long(data))
		this.setitem(row, "msps_loadcargo", long(data))
	case "msps_loadbuttons"
		this.setitem(row, "msps_loadcargo", long(data))
	case "msps_showdischarge"
		this.setitem(row, "msps_dischargebuttons", long(data))
		this.setitem(row, "msps_dischargecargo", long(data))
	case "msps_dischargebuttons"
		this.setitem(row, "msps_dischargecargo", long(data))
end choose

end event

type tabpage_citrix from userobject within tab_options
integer x = 18
integer y = 100
integer width = 2962
integer height = 2080
long backcolor = 67108864
string text = "Citrix"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_citrix dw_citrix
end type

on tabpage_citrix.create
this.dw_citrix=create dw_citrix
this.Control[]={this.dw_citrix}
end on

on tabpage_citrix.destroy
destroy(this.dw_citrix)
end on

type dw_citrix from mt_u_datawindow within tabpage_citrix
integer x = 37
integer y = 160
integer width = 2894
integer height = 1072
integer taborder = 20
string dataobject = "d_sq_ff_system_options_citrix"
boolean border = false
end type

type tabpage_citrix_backup from userobject within tab_options
integer x = 18
integer y = 100
integer width = 2962
integer height = 2080
long backcolor = 67108864
string text = "Citrix Backup"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_citrix_backup dw_citrix_backup
end type

on tabpage_citrix_backup.create
this.dw_citrix_backup=create dw_citrix_backup
this.Control[]={this.dw_citrix_backup}
end on

on tabpage_citrix_backup.destroy
destroy(this.dw_citrix_backup)
end on

type dw_citrix_backup from mt_u_datawindow within tabpage_citrix_backup
integer x = 37
integer y = 160
integer width = 2793
integer height = 1196
integer taborder = 20
string dataobject = "d_sq_ff_system_options_citrix_backup"
boolean border = false
end type

