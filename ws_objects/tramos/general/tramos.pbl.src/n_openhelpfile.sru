$PBExportHeader$n_openhelpfile.sru
$PBExportComments$CR3222
forward
global type n_openhelpfile from mt_n_nonvisualobject
end type
end forward

global type n_openhelpfile from mt_n_nonvisualobject autoinstantiate
end type

type variables
string is_chmfile, is_pdffile
end variables

forward prototypes
public subroutine documentation ()
public function integer of_openchm ()
public function integer of_openpdf ()
public function integer of_gethelpindex (window aw_window, ref long al_index)
public function integer of_openchm (window aw_window)
end prototypes

public subroutine documentation ();/********************************************************************
   n_openhelpfile
   <OBJECT></OBJECT>
   <USAGE>	</USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date				CR-Ref		Author				Comments
	26/05/2014		CR3222		CCY018				Open the chm file or PDF file.
	26/05/2014		CR3708		CCY018				add function of_gethelpindex and of_openchm( /*window aw_window */)
	04/02/2015		CR3624		LHG008				Avoid dependency on P: drive mapping
   </HISTORY>
********************************************************************/

end subroutine

public function integer of_openchm ();/********************************************************************
   of_openchm
   <DESC>	open the help file	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	26/05/2014	CR3222		CCY018		open the chm help file.
   </HISTORY>
********************************************************************/
string ls_helpfile

ls_helpfile = is_chmfile

if  FileExists(ls_helpfile) then
	showhelp(ls_helpfile, Index!)  
	return c#return.Success
else
	messagebox("Error message ", " Help file (" + ls_helpfile + ") is not found, please contact the system administrator!" )
	return c#return.Failure
end if
end function

public function integer of_openpdf ();/********************************************************************
   of_openpdf
   <DESC>	open the pdf file	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author		Comments
   	26/05/14	CR3222		CCY018		open pdf file.
   </HISTORY>
********************************************************************/
String		ls_helpfile, ls_null

ls_helpfile = is_pdffile
setnull(ls_null)

if  FileExists(ls_helpfile) and isvalid(w_tramos_main) then
	ShellExecute(handle(w_tramos_main.GetActiveSheet()), ls_null, ls_helpfile, ls_null, ls_null, 1)
	return c#return.Success
else
	messagebox("Error message ", " Help file (" + ls_helpfile + ") is not found, please contact the system administrator!" )
	return c#return.Failure
end if



end function

public function integer of_gethelpindex (window aw_window, ref long al_index);/********************************************************************
   of_openpdf
   <DESC>	open the pdf file	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author		Comments
   	25/08/14	CR3708		CCY018		get the chm help index.
   </HISTORY>
********************************************************************/

string ls_window_name, ls_parent_name, ls_findstr
long ll_find, ll_find_start, ll_find_end, ll_rowcount, ll_index
boolean lb_position
integer li_disabled
window lw_sheet

al_index = 0
li_disabled = 0

//get the window name
aw_window.dynamic event ue_getwindowname(ls_window_name)
if ls_window_name = "" then
	ls_window_name = aw_window.classname()  
end if
if ls_window_name = 'w_tramos_main' then
	ls_window_name = ""
	lw_sheet = w_tramos_main.getactivesheet()
	if isvalid(lw_sheet) then
		lw_sheet.dynamic event ue_getwindowname(ls_window_name)
		if ls_window_name = "" then
			ls_window_name = lw_sheet.classname( )
		end if
	end if
end if

if ls_window_name <> "" then
	//get the parentwindow name
	if isvalid(aw_window.parentwindow()) then
		aw_window.parentwindow().dynamic event ue_getwindowname(ls_parent_name)
		if ls_parent_name = "" then
			ls_parent_name = aw_window.parentwindow().classname()
		end if
	end if
	
	if not isvalid(aw_window.parentwindow()) or ls_parent_name = "w_tramos_main" then
		ls_parent_name = ""
		if isvalid(w_tramos_main) then
			lw_sheet = w_tramos_main.getactivesheet()
			if isvalid(lw_sheet) then
				lw_sheet.dynamic event ue_getwindowname(ls_parent_name)
				if ls_parent_name = "" then
					ls_parent_name = lw_sheet.classname( )
				end if
				if ls_window_name = ls_parent_name then ls_parent_name = "w_tramos_main"
			end if
		end if
	end if
	
	//if exist route = 1, then find parentwindow index.
	ll_rowcount = uo_global.gds_chmmapping.rowcount()
	ls_findstr = "window_name='" + ls_window_name+  "' and route = 1" 
	ll_find = uo_global.gds_chmmapping.find(ls_findstr, 1, ll_rowcount)
	if ll_find > 0 and ls_parent_name <> "" then 
		ls_window_name = ls_parent_name
		ls_parent_name = ""
	end if
		
	//get the chm help index
	ls_findstr = "window_name='" + ls_window_name + "'" 
	ll_find_start = uo_global.gds_chmmapping.find(ls_findstr, 1, ll_rowcount)
	ll_find_end = uo_global.gds_chmmapping.find(ls_findstr, ll_rowcount, 1)
	if ll_find_start > 0 then
		if ll_find_start = ll_find_end then
			al_index = uo_global.gds_chmmapping.getitemnumber(ll_find_start, "chm_index")
			li_disabled = uo_global.gds_chmmapping.getitemnumber(ll_find_start, "disabled")
		elseif ls_parent_name <> "" then
			ls_findstr = "window_name='" +ls_window_name+ "' and parent_window_name='" +ls_parent_name+ "'"
			ll_find = uo_global.gds_chmmapping.find(ls_findstr, 1, ll_rowcount)
			if ll_find > 0 then
				al_index = uo_global.gds_chmmapping.getitemnumber(ll_find, "chm_index")
				li_disabled = uo_global.gds_chmmapping.getitemnumber(ll_find, "disabled")
			end if
		end if
	end if

end if

if isnull(al_index) then al_index = 0
if isnull(li_disabled) then li_disabled = 0

if li_disabled = 0 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_openchm (window aw_window);/********************************************************************
   of_openchm
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		aw_window: menu.parentwindow
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	26/08/14 CR378            CCY018        open the chm help file
   </HISTORY>
********************************************************************/

long ll_index

if of_gethelpindex(aw_window, ll_index) = c#return.Failure then return c#return.Failure

if  FileExists(is_chmfile) then
	if ll_index = 0 then
		showhelp(is_chmfile, Index!)  
	else
		if showhelp(is_chmfile, Topic!, ll_index) = -1 then
			messagebox("Warning", "Help content is not found, please contact the system administrator!", Information! )
			showhelp(is_chmfile, Index!)  
		end if
	end if
	
	return c#return.Success
else
	messagebox("Error message ", " Help file (" + is_chmfile + ") is not found, please contact the system administrator!" )
	return c#return.Failure
end if

return c#return.Success
end function

on n_openhelpfile.create
call super::create
end on

on n_openhelpfile.destroy
call super::destroy
end on

event constructor;call super::constructor;is_chmfile = uo_global.of_getapplicationpath() + "\Help\TramosHelp.chm"
is_pdffile = uo_global.of_getapplicationpath() + "\Help\TramosHelp.pdf"

if not fileexists(is_chmfile) then
	is_chmfile = uo_global.gs_help_path + "\TramosHelp.chm"
end if

if not fileexists(is_pdffile) then
	is_pdffile = uo_global.gs_help_path + "\TramosHelp.pdf"
end if

end event

