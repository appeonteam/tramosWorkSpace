$PBExportHeader$w_adjustgenerator.srw
forward
global type w_adjustgenerator from mt_w_main
end type
type st_3 from statictext within w_adjustgenerator
end type
type st_2 from statictext within w_adjustgenerator
end type
type st_1 from statictext within w_adjustgenerator
end type
end forward

global type w_adjustgenerator from mt_w_main
boolean visible = false
integer width = 1015
integer height = 336
string title = "Adjust $ Amounts Generator"
boolean resizable = false
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_adjustgenerator w_adjustgenerator

type prototypes
FUNCTION ulong GetModuleFileName (ulong hinstModule, ref string lpszPath, ulong cchPath )  &
   LIBRARY "KERNEL32.DLL" &
   ALIAS FOR "GetModuleFileNameA;ansi"  // ;ansi  required for PB10 or better
end prototypes

type variables
string is_inifileName = "claimcurrencyadjustments.ini"
end variables

on w_adjustgenerator.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
end on

on w_adjustgenerator.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;call super::open;/********************************************************************
  event open( )
  
   	<DESC>   
		initialises configuration and calls object n_accrualgenerator
	</DESC>
   	<RETURN>
		Failure: 
		Success: 
	</RETURN>
   	<ACCESS> Public</ACCESS>
   	<ARGS></ARGS>
   	<USAGE></USAGE>
********************************************************************/

boolean					lb_debug = false
n_service_manager 	lnv_servicemanager
n_error_service 		lnv_errservice
n_adjustgenerator		lnv_adjust
string					ls_applicationname
ulong						lul_handle, lul_length=255

ClassDefinition  lcd

//handle(getapplication())
//if handle(getapplication()) = 0 then
//    // running from the IDE
//    lcd=getapplication().classdefinition
//    ls_applicationname = lcd.libraryname
//ELSE
//     running from EXE
//    lul_handle = handle( getapplication() )
//    ls_applicationname =space(lul_length) 
//    GetModuleFilename( lul_handle, ls_applicationname, lul_length )
//END IF
//
///* set the error/logging output to a log file instead of a window */
//
//messagebox("test", ls_applicationname)
//return


// TODO: check this works as an executable..
lnv_servicemanager.of_loadservice( lnv_errService , "n_error_service")
lnv_errService.of_setoutput(2, "claimcurrencyadjustments.log")

lnv_adjust = create n_adjustgenerator

if fileexists(is_inifileName) = false then return
_addmessage( this.classdefinition, "open()", "Application Started", "Application Started")
/* set DB profile. If connect fails, return */
SQLCA.DBMS 			= ProfileString ( is_inifileName, "database", "dbms", "None" )
SQLCA.Database 		= ProfileString (is_inifileName, "database", "database", "None" )
SQLCA.LogPass 		= ProfileString ( is_inifileName, "login", "pwd", "None" )
SQLCA.ServerName 	= ProfileString ( is_inifileName, "database", "servername", "None" )
SQLCA.LogId 			= ProfileString ( is_inifileName, "login", "uid", "None" )
SQLCA.AutoCommit 	= False
SQLCA.DBParm 		= "Release='15',UTF8=1, appname='server_claimcurrencyadjust', host='server_claimcurrencyadjust' "

connect using sqlca;
if sqlca.sqlcode <> 0 then
	_addmessage( this.classdefinition, "open()", "Error, Could not login to database! [sqlcode=" + string(sqlca.sqlcode) + " sqltext=" + sqlca.sqlerrtext + "]", "cannot connect to db transaction!")
	rollback;
	disconnect using sqlca;
	return c#return.Failure
end if
commit;
if ProfileInt( is_inifileName, "debug", "enabled", 0) = 1 then lb_debug = true 
/* load any debug functions into object */
lnv_adjust.of_setdebugmode(lb_debug)
if lb_debug then
	_addmessage( this.classdefinition, "open()", "* Debug mode ON *","")
	this.visible = true
end if

/* call the main function of_generate() to start process */
lnv_adjust.of_main()
/* close this window and application */
destroy lnv_adjust
close(this)
end event

event closequery;call super::closequery;if sqlca.dbhandle()>0 then
	disconnect using sqlca;
end if
garbagecollect()
end event

type st_3 from statictext within w_adjustgenerator
integer y = 188
integer width = 1006
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 32768
string text = "usually hidden"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_adjustgenerator
integer x = 329
integer y = 8
integer width = 695
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "USD adjustments"
boolean focusrectangle = false
end type

type st_1 from statictext within w_adjustgenerator
integer x = 329
integer y = 72
integer width = 695
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Running..."
boolean focusrectangle = false
end type

