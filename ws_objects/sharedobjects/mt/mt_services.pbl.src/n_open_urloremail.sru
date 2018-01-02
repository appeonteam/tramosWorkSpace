$PBExportHeader$n_open_urloremail.sru
forward
global type n_open_urloremail from mt_n_baseservice
end type
end forward

global type n_open_urloremail from mt_n_baseservice autoinstantiate
end type

forward prototypes
public function integer of_openlink (string as_string, string as_type)
public subroutine of_open_urloremail (string as_hyperlinkshortcut, string as_columnname, datawindow adw)
public subroutine documentation ()
end prototypes

public function integer of_openlink (string as_string, string as_type);/********************************************************************
   of_openlink()
   <DESC>	  open url or outlook	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	of_open_urloremail	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/09/14	CR3760        KSH092   First Version
   </HISTORY>
********************************************************************/


string ls_return, ls_subject, ls_emailto,ls_emailaddress[]
 inet  liinet_base

if as_type = 'url' then
	
	liinet_base = Create inet
	getcontextservice("internet",liinet_base)
	liinet_base.hyperlinktourl(as_string)
	destroy liinet_base
	return c#return.success

elseif as_type = 'email' then
	
	mt_n_stringfunctions	lnv_string
	n_sendtomailclient	lnv_mailclient
	ls_emailaddress[1] = as_string
	lnv_string.of_arraytostring(ls_emailaddress, '; ', ls_emailto)
	return lnv_mailclient.of_sendmailbyoutlook(ls_subject, ls_emailto)

end if
	
end function

public subroutine of_open_urloremail (string as_hyperlinkshortcut, string as_columnname, datawindow adw);/********************************************************************
  event doubleclicked()
<DESC>   
                             Apply basic sort on single column level
</DESC>
<RETURN>
                             Long:
                                                          <LI> 0
</RETURN>
<ACCESS> 
                             Public
</ACCESS>
<ARGS>   
                             PB standard for dw doubleclicked event
</ARGS>
<USAGE>
                             if property ib_columntitlesort is true apply.  Column headers must have column name of 
                             referenced detail in addition to postfix of "_t".  
                             ie column 'vessel_id' has a header text control of 'vessel_id_t'.
</USAGE>
********************************************************************/
string ls_columntype, ls_style, ls_testchar, ls_data,ls_return
long ll_selectedlength, ll_startpos, ll_endpos, ll_position, ll_textlen
int li_return
boolean lb_email = true, lb_url = true
mt_n_stringfunctions lnv_stringfuncs


if as_hyperlinkshortcut<>""  then
	/* test dwo if functionality is required (controlled by is_hyperlinkshortcut) */
	if pos(as_hyperlinkshortcut,as_columnname)>0 or upper(as_hyperlinkshortcut)="ALL" then
		
		ls_columntype = adw.describe(as_columnname +  ".ColType")
		ls_style = adw.describe(as_columnname + ".Edit.Style")
		
		if (lower(left(ls_columntype,4)) = "char") and (ls_style = "edit") then 
			// prefix cursor position
			for ll_startpos = adw.position() to 1 step -1
				if mid(adw.gettext(),ll_startpos,1) = " " or mid(adw.gettext(),ll_startpos,2) = "~r~n" or mid(adw.gettext(),ll_startpos,1) = "~t" then
					exit
				elseif ll_startpos = 0 then
					exit
				end if                 
				ll_selectedlength ++
			next
			// postfix cursor position
			ll_textlen = len(adw.gettext())
			for ll_endpos = adw.position() to ll_textlen
				if mid(adw.gettext(),ll_endpos,1) = " " or mid(adw.gettext(),ll_endpos,2) = "~r~n" or mid(adw.gettext(),ll_startpos,1) = "~t" then
					
					exit
				elseif ll_endpos = ll_textlen then
					exit
				end if                 
				ll_selectedlength ++
			next
			/* what type of string do we have, url/email/nothing ? */
			ls_data = lower(lefttrim(mid(string(adw.gettext()), ll_startpos+1, ll_selectedlength)))
			
			lnv_stringfuncs.of_replaceinstring(ls_data, char(10))
		   lnv_stringfuncs.of_replaceinstring(ls_data, char(13))
			lnv_stringfuncs.of_replaceinstring(ls_data, ' ')
			ls_return = lnv_stringfuncs.of_is_urloremailaddress(ls_data)
			 
			if ls_return = 'url' or ls_return = 'email' then
			   
				li_return = of_openlink(ls_data,ls_return)
				adw.selecttext(ll_startpos + 1, ll_selectedlength)
				
			end if

		end if
	end if
end if



end subroutine

public subroutine documentation ();/********************************************************************
   n_open_urloremail: Object Short Description
	
	<OBJECT>
		doubleclick column open urloremail
	
   <DESC>
		doubleclicked clicked ()
	</DESC>
  	
	<USAGE>
		
	</USAGE>
   
	<ALSO>
		TODO: Apply header group functionality also.	
	</ALSO>
   
		Date   		Ref    	Author   	Comments
  		17/10/14 	?      	Name Here	First Version
	  
	
	<LIMITATIONS>  
		
	</LIMITATIONS>  	  
********************************************************************/

end subroutine

on n_open_urloremail.create
call super::create
end on

on n_open_urloremail.destroy
call super::destroy
end on

