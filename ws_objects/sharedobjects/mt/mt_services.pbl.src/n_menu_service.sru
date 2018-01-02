$PBExportHeader$n_menu_service.sru
$PBExportComments$service for handling menu behaviour
forward
global type n_menu_service from mt_n_baseservice
end type
end forward

global type n_menu_service from mt_n_baseservice
end type
global n_menu_service n_menu_service

forward prototypes
public function integer of_setshortcuts (menu am_rootmenuid, string as_enableditems[])
public subroutine documentation ()
public function integer of_addhelpmenu (window aw_window, string as_enableditems[])
end prototypes

public function integer of_setshortcuts (menu am_rootmenuid, string as_enableditems[]);/********************************************************************
of_setshortcuts( /*menu am_rootmenuid*/, /*string as_enableditems[] */) 

<DESC>
	General function to be used recursively so only items passed will be available as a shortcut.
	This is done by hiding this menu and all its items.  We enable only the shortcuts we need.

</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private/Public
</ACCESS>
<ARGS>
	as_docpath: file path and name
</ARGS>
<USAGE>
	To be used only on main window containers that are opened outside the w_main_tramos window.
	Can be improved upon so that it could make use of the service management.
	
		lnv_menu.of_setshortcuts(this.menuid, { & 
		"F1", &
		"F2", &
		"F4", &
		"F7", &
		"Shift+F7", &
		"F8", &
		"F9", &
		"F10", &
		"F11", &
		"F12" &
		})
	
	Potential issue with character string array passed that may match unintended menu item.
</USAGE>
********************************************************************/

long ll_menuindex, ll_itemindex
boolean lb_enabled	
string ls_temp
mt_n_stringfunctions		lnv_stringfuncs	
	
   for ll_menuindex = 1 to upperbound(am_rootmenuid.item)
		lb_enabled=false
		ls_temp = am_rootmenuid.item[ll_menuindex].text
		lnv_stringfuncs.of_replacectrlchars(ls_temp)
		for ll_itemindex = 1 to upperbound(as_enableditems)
			if pos(ls_temp,as_enableditems[ll_itemindex]) > 0 then
				lb_enabled = true
				exit 				
			end if	
		next
		am_rootmenuid.item[ll_menuindex].visible = false
		am_rootmenuid.item[ll_menuindex].enabled = lb_enabled
		of_setshortcuts(am_rootmenuid.item[ll_menuindex],as_enableditems)
   next

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   n_menu_service: 
	
	<OBJECT>
		service object menu
	</OBJECT>
   <DESC>
		Specific functions used to control the behaviour of the menubar items
		expect functions working directly with the help and other special cases
		to reside inside here.
	</DESC>
   <USAGE>
		n_service_manager	lnv_servicemgr
		n_menu_service   	lnv_menu
		lnv_serviceMgr.of_loadservice( lnv_menu, "n_menu_service")
	</USAGE>
   <ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	04/08/14 	CR3708   AGL027			First Version
********************************************************************/
end subroutine

public function integer of_addhelpmenu (window aw_window, string as_enableditems[]);/********************************************************************
   of_addhelpmenu
   <DESC></DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		aw_window: the window that need to add helpmenu.
   </ARGS>
   <USAGE>	To be used only on main window containers that are opened outside the w_main_tramos window.	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/08/14 CR3708            CCY018        First Version
   </HISTORY>
********************************************************************/

boolean lb_valid, lb_opensheet
string ls_classname
window lw_sheet
n_service_manager lnv_servicemgr
n_menu_service lnv_menu

lb_opensheet = false

if isvalid(w_tramos_main) then
	lw_sheet = w_tramos_main.GetFirstSheet()	
	if isvalid(lw_sheet) then
		do
			  ls_classname = lw_sheet.classname( )
			  if ls_classname = aw_window.classname( ) then 
				 lb_opensheet = true
				 exit
			  end if
  
			  lw_sheet = w_tramos_main.GetNextSheet(lw_sheet)		 
			  lb_valid = isvalid (lw_sheet)				 
		loop while lb_valid
	end if
end if

if lb_opensheet or isvalid(aw_window.menuid) or aw_window.windowtype = child! then
       return c#return.Failure
end if

lnv_serviceMgr.of_loadservice( lnv_menu, "n_menu_service")	

aw_window.toolbarvisible = false
/* in order to make keyboard shortcuts available, create a hidden menu */
aw_window.changemenu(m_helpmain)
	
lnv_menu.of_setshortcuts(aw_window.menuid, as_enableditems)

return c#return.Success
end function

on n_menu_service.create
call super::create
end on

on n_menu_service.destroy
call super::destroy
end on

