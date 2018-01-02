$PBExportHeader$n_confirmsave.sru
forward
global type n_confirmsave from mt_n_nonvisualobject
end type
end forward

global type n_confirmsave from mt_n_nonvisualobject
end type
global n_confirmsave n_confirmsave

type variables
string is_confirm_title, is_prompt_text
string is_cmdbtn_caption1="Yes", is_cmdbtn_caption2="Yes to All", is_cmdbtn_caption3="No", is_cmdbtn_caption4="No to All", is_cmdbtn_caption5="Cancel"
integer ii_returnvalue
boolean ib_execute_once = false

end variables

forward prototypes
public function integer of_closewindow (ref commandbutton acmd_selected, integer ai_useroption, boolean ab_execute_once)
end prototypes

public function integer of_closewindow (ref commandbutton acmd_selected, integer ai_useroption, boolean ab_execute_once);ii_returnvalue = ai_useroption
ib_execute_once = ab_execute_once
acmd_selected.getparent().triggerevent("ue_close")

return 1
end function

on n_confirmsave.create
call super::create
end on

on n_confirmsave.destroy
call super::destroy
end on

