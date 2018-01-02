$PBExportHeader$u_base_filterbox.sru
forward
global type u_base_filterbox from userobject
end type
type gb_1 from groupbox within u_base_filterbox
end type
type cb_reset from mt_u_commandbutton within u_base_filterbox
end type
end forward

global type u_base_filterbox from userobject
integer width = 736
integer height = 644
long backcolor = 67108864
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
gb_1 gb_1
cb_reset cb_reset
end type
global u_base_filterbox u_base_filterbox

type variables
datawindow idw_data[]
u_base_filterdw idddw_filter[]
string is_dddwfilter[]
long il_user_days, il_max_days
integer ii_pcgroup

end variables

forward prototypes
public function integer of_updatefilterdddw (integer ai_pcgroup)
public function integer of_registerdw (ref datawindow adw)
public function integer of_setfilter (string as_data, integer ai_filterindex)
public function string of_generate_filter (integer ai_dwindex)
public function integer of_reset_filters ()
end prototypes

public function integer of_updatefilterdddw (integer ai_pcgroup);/********************************************************************
   FunctionName
   <DESC>   Description</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

ii_pcgroup=ai_pcgroup

of_reset_filters()

return 1



end function

public function integer of_registerdw (ref datawindow adw);/********************************************************************
   of_registerdw( /*ref datawindow adw */)
   <DESC>   Builds an array of datawindows that will be filtered on</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw: datawindow to be filtered on</ARGS>
   <USAGE>  Very useful so we can reference the target dw's directly from this
				user object</USAGE>
********************************************************************/


idw_data[upperbound(idw_data)+1] = adw
return 1
end function

public function integer of_setfilter (string as_data, integer ai_filterindex);/********************************************************************
   of_setfilter( /*string as_data*/, /*integer ai_filterindex */)
   <DESC>   loops through the target dw array (requiring filters) 
				Sets the filter on them accordingly</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   as_data: the value (usually an id of the record row)
            ai_filterindex: the control array index of the filter dddw</ARGS>
   <USAGE>	if ai_filterindex is 0 it means all filters need
				to be cleared so we need to handle that</USAGE>
********************************************************************/


integer li_datawindows, li_button
string ls_filterstring, ls_validcontrol, ls_filtercontrol

if upperbound(idw_data)>0 then
	if ai_filterindex>0 then
		ls_filtercontrol = left(is_dddwfilter[ai_filterindex],pos(is_dddwfilter[ai_filterindex]," ")-1)
		if isnull(as_data) then 
			is_dddwfilter[ai_filterindex] = ls_filtercontrol + " "
		else
			is_dddwfilter[ai_filterindex] = ls_filtercontrol + " = " + as_data
		end if
	end if
	for li_datawindows = 1 to upperbound(idw_data)
		if ai_filterindex<1 then				
			idw_data[li_datawindows].setfilter(of_generate_filter(li_datawindows))
			idw_data[li_datawindows].filter()			
		else
			ls_validcontrol=idw_data[li_datawindows].Describe(ls_filtercontrol + ".ColType")
			if ls_validcontrol<>"!" then
				ls_filterstring = of_generate_filter(li_datawindows)
				idw_data[li_datawindows].setfilter(ls_filterstring)
				idw_data[li_datawindows].filter()
			end if
		end if
	next
	return 1
else
	return -1
end if




end function

public function string of_generate_filter (integer ai_dwindex);/********************************************************************
   of_generate_filter( /*integer ai_dwindex */)
   <DESC>   This function builds the filter string</DESC>
   <RETURN> String:
            </RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   ai_dwindex: reference to the datawindow to be filtered
            </ARGS>
   <USAGE>  The space character at the end of the is_dddwfilter array element
				is important to control the process.  There is validation to check if
				the filtered column reference exists in the target datawindow</USAGE>
********************************************************************/


string ls_filter, ls_validcontrol, ls_filtercontrol, ls_days
integer li_index

ls_filter=""


for li_index = 1 to upperbound(is_dddwfilter)
	if pos(is_dddwfilter[li_index],"=")>0 then
		ls_filtercontrol = left(is_dddwfilter[li_index],pos(is_dddwfilter[li_index]," ")-1)
		ls_validcontrol=idw_data[ai_dwindex].Describe(ls_filtercontrol + ".ColType")
		if ls_validcontrol<>"!" then
			ls_filter = ls_filter + " and " + is_dddwfilter[li_index]
		end if
	end if
next


return mid(ls_filter,6)
end function

public function integer of_reset_filters ();
/********************************************************************
   of_reset_filters( )
   <DESC>   Resets the filter boxes and also filters applied to dw's</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   n/a</ARGS>
   <USAGE>  Called from both the command button and the change of pcgroup</USAGE>
********************************************************************/

integer li_control_index
u_base_filterdw ldw_dddw
long ll_null

setnull(ll_null)

for li_control_index = 1 to Upperbound(idddw_filter) 
	ldw_dddw=idddw_filter[li_control_index]
	is_dddwfilter[li_control_index]=left(is_dddwfilter[li_control_index],pos(is_dddwfilter[li_control_index]," "))
	ldw_dddw.SelectRow(0, FALSE)
	ldw_dddw.SetItem(1,1,ll_null)
next 
of_setfilter("",0)
return 1
end function

on u_base_filterbox.create
this.gb_1=create gb_1
this.cb_reset=create cb_reset
this.Control[]={this.gb_1,&
this.cb_reset}
end on

on u_base_filterbox.destroy
destroy(this.gb_1)
destroy(this.cb_reset)
end on

event constructor;/********************************************************************
   event constructor( ) 
	<DESC>   Description</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  This saves an index of the datawindow into the tag property
				It also loads 
	</USAGE>
********************************************************************/


integer li_control_index, li_dw_counter=0
u_base_filterdw ldw_dddw


for li_control_index = 1 to Upperbound(this.control) 
   if TypeOf(this.control[li_control_index]) = DataWindow! then 
			ldw_dddw=this.control[li_control_index]
			li_dw_counter++
			ldw_dddw.tag = string(li_dw_counter)
			idddw_filter[upperbound(idddw_filter)+1]=ldw_dddw
			is_dddwfilter[upperbound(is_dddwfilter)+1]= ldw_dddw.is_filter_field + " "
   end if 
next 
end event

type gb_1 from groupbox within u_base_filterbox
integer x = 18
integer width = 695
integer height = 624
integer taborder = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filters"
end type

type cb_reset from mt_u_commandbutton within u_base_filterbox
integer x = 55
integer y = 496
integer width = 219
integer height = 96
integer taborder = 100
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;

if of_reset_filters()=-1 then
	messagebox("Error","seems to be an error here")
end if




end event

