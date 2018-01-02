$PBExportHeader$w_expand_hotlist.srw
$PBExportComments$Expand Status description from hot list, only with read rights.
forward
global type w_expand_hotlist from w_expand_text
end type
end forward

global type w_expand_hotlist from w_expand_text
end type
global w_expand_hotlist w_expand_hotlist

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_exspand_hotlist
  
 Object     : 
  
 Event	 :Open! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 10-09-96

 Description :Response Window expands text into a read only window

 Arguments : Must be opened with a structure s_expand_text, where string attribute 'text' is the text to be 
			edited, and string attribute 'name' is the name to be figured in titlebar 

 Returns   : Returns "!" if no changes were made to text, else returns the modified text as string  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
10-09-96		1.0	 		JH		Initial version
  
************************************************************************************/


/* Override ancestor to stop retrieve of templates */

long ll_row
istr_parm = Message.PowerObjectParm

/* set text in edit field */
This.Title = "Text for: " + istr_parm.name
ll_row=Dw_1.insertrow(0)
dw_1.scrolltorow(ll_row)
dw_1.setitem(ll_row,"Text",istr_parm.text)
dw_1.SetFocus()

end event

on w_expand_hotlist.create
call w_expand_text::create
end on

on w_expand_hotlist.destroy
call w_expand_text::destroy
end on

type cb_cancel from w_expand_text`cb_cancel within w_expand_hotlist
int TabOrder=0
boolean Enabled=false
end type

type cb_temp_cancel from w_expand_text`cb_temp_cancel within w_expand_hotlist
int TabOrder=20
end type

type cb_print from w_expand_text`cb_print within w_expand_hotlist
boolean Enabled=false
end type

type cb_update from w_expand_text`cb_update within w_expand_hotlist
int TabOrder=0
boolean Enabled=false
end type

type cb_close from w_expand_text`cb_close within w_expand_hotlist
int TabOrder=10
end type

type dw_1 from w_expand_text`dw_1 within w_expand_hotlist
boolean BringToTop=true
end type

type cb_templates from w_expand_text`cb_templates within w_expand_hotlist
int TabOrder=0
boolean Enabled=false
end type

type cb_temp_ok from w_expand_text`cb_temp_ok within w_expand_hotlist
int TabOrder=40
end type

