$PBExportHeader$u_creq_search.sru
forward
global type u_creq_search from u_searchbox
end type
end forward

global type u_creq_search from u_searchbox
end type
global u_creq_search u_creq_search

forward prototypes
public subroutine of_dofilter ()
public subroutine documentation ()
end prototypes

public subroutine of_dofilter ();// this function performs the actual filtering based on the text in the textbox 

string ls_filter

ls_filter = trim(sle_search.text, true)
if ls_filter > "" then
	ls_filter = "lower(" + is_columns + ") like '%" + lower(ls_filter) + "%'"
	if is_dwfilter > ""  then ls_filter = is_dwfilter + " or (" + ls_filter + ")"
end if

idw_dw.setfilter(ls_filter)
idw_dw.filter()
idw_dw.sort()
end subroutine

public subroutine documentation ();/********************************************************************
   u_creq_search
   <OBJECT>		his object implements a search-as-you-type functionality for any datawindow.
					The datawindow is filtered based on the text entered in the text box.
	</OBJECT>
   <USAGE>		Change Request email adderss search: w_select_emailaddress.event open() </USAGE>
   <ALSO>		u_creq_email ;
					Ancestor object is syswin_newlay_out::u_searchbox.  
					This descendent exists because ancestor cannot always include the data filtered by is_DWFilter,
					For change detials see of_dofilter() function.
	</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	29/01/2013	CR2614		LHG008		First Version
		15/07/2013	CR3254		LHG008		Add comment
   </HISTORY>
********************************************************************/
end subroutine

on u_creq_search.create
call super::create
end on

on u_creq_search.destroy
call super::destroy
end on

type st_search from u_searchbox`st_search within u_creq_search
end type

type cb_clear from u_searchbox`cb_clear within u_creq_search
end type

event cb_clear::clicked;sle_Search.Text = ""
of_dofilter( )
end event

type sle_search from u_searchbox`sle_search within u_creq_search
end type

