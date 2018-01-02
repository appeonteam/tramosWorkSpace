$PBExportHeader$n_dw_style_service.sru
$PBExportComments$MUST BE DELETED!
forward
global type n_dw_style_service from mt_n_baseservice
end type
end forward

global type n_dw_style_service from mt_n_baseservice
end type
global n_dw_style_service n_dw_style_service

type variables
n_dw_column_definition inv_columnDef[]

constant integer NOFORMAT_DATAWINDOW=0
constant integer LIST_DATAWINDOW=1
constant integer FORM_DATAWINDOW=2
end variables

forward prototypes
private function boolean of_isclientvalid (ref powerobject apo)
public function integer of_dwlistformater (ref powerobject apo)
public function integer of_split (ref string as_array[], string as_string, string as_separator)
public function integer of_dwformformater (ref powerobject apo)
public function integer of_registercolumn (string as_column, boolean ab_mandatory, boolean ab_special)
public subroutine documentation ()
public function integer of_registercolumn (string as_column, boolean ab_mandatory)
public function integer of_dwlistformater (ref powerobject apo, boolean ab_alt_colours_on)
private function string _replacemodstringdefault (string as_property, string as_new_value)
public subroutine of_autoadjustdddwwidth (datawindow adw_target, string as_colname)
public subroutine of_autoadjustdddwwidth (datawindow adw_target)
end prototypes

private function boolean of_isclientvalid (ref powerobject apo);choose case apo.typeOf()
	case 	datawindow!, datastore!, datawindowchild!
		return True
	case else
		return False
end choose

		
end function

public function integer of_dwlistformater (ref powerobject apo);/********************************************************************
   of_dwlistformater( /*ref powerobject apo */)
   <DESC>   Amends design of datawindow passed to align with MT's
				standards</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   apo: Powerbuilder Object, should be datawindow.</ARGS>
   <USAGE>  With the service manager:
	
	/* setup datawindow formatter service */
	n_service_manager		lnv_serviceMgr
	n_dw_style_service   lnv_style

	lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_registerColumn("port_code",true)
	lnv_style.of_dwlistformater(dw_sample)
	</USAGE>
********************************************************************/

return of_dwlistformater( apo, false)

end function

public function integer of_split (ref string as_array[], string as_string, string as_separator);string   ls,sep  
long   i,lpos,p,ln  


sep = as_separator  
ls=as_string+sep  

i=1  
lpos=1  
ln=len(sep)  

p=pos(ls,sep,lpos)  
do   while   p>0  
as_array[i]=mid(ls,lpos,p   -   lpos)  
lpos=p+ln  
i++  
p=pos(ls,sep,lpos)  
loop  
return   i   -1   



end function

public function integer of_dwformformater (ref powerobject apo);/********************************************************************
   of_dwformformater( /*ref powerobject apo */)
   <DESC>   Amends design of datawindow passed to align with MT's
				standards</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   apo: Powerbuilder Object, should be datawindow.</ARGS>
   <USAGE>  With the service manager:
	
	/* setup datawindow formatter service */
	n_service_manager		lnv_serviceMgr
	n_dw_style_service   lnv_style

	lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_registerColumn("port_code",true)
	lnv_style.of_dwformformater(dw_sample)
	
	</USAGE>
********************************************************************/

string ls_objectNames[], ls_type, ls_band, ls_modstring, ls_tag, ls_property
integer li_loop, li_start_pos
datawindow ldw
n_dw_column_definition lnv_dummy[]



if NOT of_isClientValid( apo ) then return c#return.noAction

/* Set Pointer to Datawindow */
ldw = create datawindow
ldw = apo

// Get all objects in source datawindow and split names into array
If of_Split(ls_ObjectNames,string(ldw.Describe("DataWindow.Objects")), Chara(9)) = -1 then
	Messagebox("Error","Unable to split columns")
	Return  c#return.failure
End if

	/* Set datawindow background color*/
	ldw.Object.DataWindow.Color=string(C#COLOR.MT_FORM_BG)
	
	/* Set Detail band background color */
	ldw.Object.DataWindow.Detail.Color=string(C#COLOR.MT_FORMDETAIL_BG)

	For li_Loop = 1 to Upperbound(inv_columndef)
		ls_type = lower(ldw.Describe(inv_columndef[li_Loop].is_column_name +".type"))
		if ls_type = "column" then	
			ldw.modify(inv_columndef[li_Loop].is_column_name + ".Background.Mode = '0'")
			ls_property = inv_columndef[li_Loop].is_column_name + ".Background.Color"
			if inv_columndef[li_Loop].ib_mandatory then
				ldw.modify(&
					ls_property + "=" + _replaceModStringDefault(ldw.Describe(ls_property), &
					string(C#COLOR.MT_MAERSK)))
			end if
			if inv_columndef[li_Loop].ib_special then
				ldw.modify(&
					ls_property + "=" + _replaceModStringDefault(ldw.Describe(ls_property), &
					string(C#COLOR.MT_BUTTON_RED)))
			end if
		end if	
	next	
	
	// clear column definition array
	inv_columndef=lnv_dummy

return 1

end function

public function integer of_registercolumn (string as_column, boolean ab_mandatory, boolean ab_special);/********************************************************************
   of_registerColumn( /*string as_column*/, /*boolean ab_mandatory*/, /*boolean ab_special */)
   <DESC>   Used to identify columns that have a special formatting requirement</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   as_column: the name of the column to be used
            ab_mandatory: A flag to identify if column is a mandatory field
				ab_special: A flag identifying column as a special field</ARGS>
   <USAGE>  This will most probably change as time goes on.  Before the
				Basically before applying the format function of_dwformformater(), register the columns you want to adapt, 
				Code Example:
				
				lnv_style.of_dwlistformater(dw_profitcenter, false)
				/* setup mandatory columns for dw_detail*/
				lnv_style.of_registerColumn( "document_description",true,false)
				lnv_style.of_registerColumn("owned_by",true,false)
				lnv_style.of_dwformformater(dw_detail)
				
				</USAGE>
********************************************************************/

integer	li_newindex,	li_index

// Check arguments.
if IsNull(as_column) or Len(Trim(as_column))=0 Then 
	return c#return.Failure
end if

as_column = Lower(Trim(as_column))
li_newindex = UpperBound(inv_columndef) + 1

for li_index = 1 to li_newindex - 1
	if inv_columndef[li_index].is_column_name = as_column Then
		// Column was previously registered.
		inv_columndef[li_index].ib_mandatory = ab_mandatory
		inv_columndef[li_index].ib_special = ab_special
		return c#return.Success 
	end if	
next

// Add to array.
inv_columndef[li_newindex].is_column_name = as_column
inv_columndef[li_newindex].ib_mandatory = ab_mandatory
inv_columndef[li_newindex].ib_special = ab_special

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   n_dw_style_service: Datawindow Formatter Service
	
   <OBJECT> Applies a format over a datawindow.</OBJECT>
   <DESC>   n/a</DESC>
   <USAGE>  The datawindow must
	have a dataobject assigned before the format can be applied
	
	
	Setup Datawindow Formatter Service Sample
	=========================================
	
	n_service_manager		lnv_serviceMgr
	n_dw_style_service   lnv_style

	lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater(dw_file_listing)

	</USAGE>

	<LIMITATION>
		- The style services does not work for the dropdown fields with Auto retrieve property checked.
		- The style services does not work for the child datawindows.
	</LIMITATION>
   
	<ALSO>   other object used here to store column detail in an array is
	n_dw_column_definition.
	
	With function _replacemodstringdefault() it is possible to maintain logic in expression contained with
	column.  for columns registered as mandatory, the process replaces only occurances of the default value in
	the expression.
	</ALSO>
    
	 Date   Ref    Author         Comments
  00/00/10 ?      Name Here      First Version
  20/07/10 ?      AGL027			Added new function of_registerColumn()
  29/07/10 ?      AGL027			New function _replacemodstringdefault()
  07/09/11 ?      ZSW001         New function of_autoadjustdddwwidth()
  01/02/13 CR2614	LHG008			Modified function of_dwformformater() and of_dwlistformater, 
  											set <Column>.Background.Mode = '0'.
  11/09/14 CR3758	CCY018	Set DataWindow.selected.mouse = "no"
											  DataWindow.grid.columnmove = "no"
********************************************************************/

end subroutine

public function integer of_registercolumn (string as_column, boolean ab_mandatory);/********************************************************************
   of_registerColumn( /*string as_column*/, /*boolean ab_mandatory*/)
   <DESC>   Used to identify columns that have a madatory column format requirement</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   as_column: the name of the column to be used
            ab_mandatory: A flag to identify if column is a mandatory field
	</ARGS>
   <USAGE>  This will most probably change as time goes on.  Before the
				Basically before applying the format function of_dwformformater(), register the columns you want to adapt, 
				Code Example:
				
				lnv_style.of_dwlistformater(dw_profitcenter, false)
				/* setup mandatory columns for dw_detail*/
				lnv_style.of_registercolumn( "document_description",true)
				lnv_style.of_registercolumn("owned_by",true)
				lnv_style.of_dwformformater(dw_detail)
				
				</USAGE>
********************************************************************/

return of_registerColumn(as_column, ab_mandatory, false)
end function

public function integer of_dwlistformater (ref powerobject apo, boolean ab_alt_colours_on);/********************************************************************
   of_dwlistformater( /*ref powerobject apo */)
   <DESC>   Amends design of datawindow passed to align with MT's
				standards</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   apo						: Powerbuilder Object, should be datawindow.
				ab_alt_colours_on		:switch on/off alternate row colouring</ARGS>
   <USAGE>  With the service manager:
	
	/* setup datawindow formatter service */
	n_service_manager		lnv_serviceMgr
	n_dw_style_service   lnv_style

	lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_registerColumn("port_code",true)
	lnv_style.of_dwlistformater(dw_sample)
	</USAGE>
********************************************************************/


string ls_objectNames[], ls_type, ls_band, ls_modstring, ls_tag, ls_property
integer li_loop
datawindow ldw

n_dw_column_definition lnv_dummy[]

if NOT of_isClientValid( apo ) then return c#return.noAction

/* Set Pointer to Datawindow */
ldw = create datawindow
ldw = apo

// Get all objects in source datawindow and split names into array
If of_Split(ls_ObjectNames,string(ldw.Describe("DataWindow.Objects")), Chara(9)) = -1 then
	Messagebox("Error","Unable to split columns")
	Return  c#return.failure
End if

//if ldw.ii_dw_type=LIST_DATAWINDOW then
	/* Set datawindow background color*/
	ldw.Object.DataWindow.Color=string(C#COLOR.MT_LIST_BG)
	
	/* Set Header and Detail band background color */
	ldw.Object.DataWindow.Header.Color=string( C#COLOR.MT_LISTHEADER_BG )
	
	if ab_alt_colours_on then
		ldw.Object.DataWindow.Detail.Color="0~tif(mod(getRow(),2)=0,"+string(C#COLOR.MT_LISTDETAIL_BG)+","+ string(C#COLOR.MT_LISTDETAIL_BG_ALT)+")"
	else
		ldw.Object.DataWindow.Detail.Color=string(C#COLOR.MT_LISTDETAIL_BG)
	end if
	
	//set selected row with retangle
	ldw.setrowfocusindicator( FocusRect!)
	
	// Find object types and modify
	For li_Loop=1 to Upperbound(ls_ObjectNames)   // loop thru the headers first to create table columns
		ls_type=ldw.Describe(ls_objectnames[li_loop]+".type")
		ls_band=Lower(ldw.Describe(ls_objectnames[li_loop]+".band"))	
		
		if lower(ls_type) = "text" and  lower(ls_band) = "header" then 
			ls_modstring = string(ls_objectnames[li_loop])+".Color="+string( C#COLOR.MT_LISTHEADER_TEXT )
			ldw.modify(ls_modstring)
			ls_modstring = string(ls_objectnames[li_loop])+".Background.Color="+string( C#COLOR.Transparent )
			ldw.modify(ls_modstring)
			ls_modstring = string(ls_objectnames[li_loop])+".Border=0"
			ldw.modify(ls_modstring)
		end if
	next

	For li_Loop = 1 to Upperbound(inv_columndef)
		ls_type = lower(ldw.Describe(inv_columndef[li_Loop].is_column_name +".type"))
		
		if ls_type = "column" then
			ldw.modify(inv_columndef[li_Loop].is_column_name + ".Background.Mode = '0'")
			ls_property = inv_columndef[li_Loop].is_column_name + ".Background.Color"
			if inv_columndef[li_Loop].ib_mandatory then
				ldw.modify(&
					ls_property + "=" + _replaceModStringDefault(ldw.Describe(ls_property), &
					string(C#COLOR.MT_MAERSK)))
			end if	
			if inv_columndef[li_Loop].ib_special then
				ldw.modify(&
					ls_property + "=" + _replaceModStringDefault(ldw.Describe(ls_property), &
					string(C#COLOR.MT_BUTTON_RED)))
			end if	
		end if	
	next	
	
	ldw.Object.DataWindow.selected.mouse = "no"
	ldw.Object.DataWindow.grid.columnmove = "no"
		
	// clear column definition array
	inv_columndef=lnv_dummy
	
return c#return.Success

end function

private function string _replacemodstringdefault (string as_property, string as_new_value);/********************************************************************
   _replaceModStringDefault( /*string as_property*/, /*string as_new_value */)
   <DESC>   Transforms describe expression for use in modify</DESC>
   <RETURN> String
            Transformed expression</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   as_property: the property itself.  
					eg.1 "16777215"
					eg.2 "16777215~tIf (edit_locked>0 or purpose_code<>~"D~",  80269524, 16777215)"
					
            as_new_value: What we want to replace the old value with</ARGS>
   <USAGE>  How to use this function. 
	
	
				ldw.modify(&
					"port_code.Background.Color=" + _replaceModStringDefault(ldw.Describe("port_code.Background.Color"), &
					string(C#COLOR.MT_MAERSK)))
	
	</USAGE>
********************************************************************/

string ls_property_expression, ls_property, ls_old_value
integer li_start_pos

if isnumber(as_property) then 
	return as_new_value
else
	ls_property = as_property
	ls_old_value=mid(ls_property, 2, Pos(ls_property, "~t") - 2)
	li_start_pos = Pos(ls_property, ls_old_value, 1)
	do while li_start_pos > 0
		ls_property = Replace(ls_property, li_start_pos, len(ls_old_value), as_new_value)
		li_start_pos = Pos(ls_property, ls_old_value, li_start_pos+Len(as_new_value))
	loop
end if

return ls_property

 
end function

public subroutine of_autoadjustdddwwidth (datawindow adw_target, string as_colname);/********************************************************************
   of_autoadjustdddwwidth
   <DESC> Auto adjust the width of dropdown of the columns </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_target : the target datawindow in which the width of dropdown datawindow will be reset
		as_colname : the column name which the width of dropdown datawindow will be reset. 
						If this parameter is "", all the dropdown datawindows in target datawindow will be reset.
   </ARGS>
   <USAGE> Suggest to use in the Open event of the window </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/09/2011   N/A	        ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_colname[], ls_objects, ls_objname
long		ll_xpos, ll_pos, ll_width, ll_dddwwidth, ll_colwidth, ll_percent
long		ll_column, ll_count

datawindowchild	ldwc_child

CONSTANT string  ls_TABCHAR = "~t"
CONSTANT integer li_VSCROLLBARWIDTH = 78		//The width of the vertical scroll bar

if trim(as_colname) = "" then
	ll_count = long(adw_target.describe("datawindow.column.count"))
	for ll_column = 1 to ll_count
		if adw_target.describe("#" + string(ll_column) + ".edit.style") = "dddw" then
			ls_colname[upperbound(ls_colname) + 1] = adw_target.describe("#" + string(ll_column) + ".name")
		end if
	next
else
	if adw_target.describe(as_colname + ".edit.style") = "dddw" then
		ls_colname[upperbound(ls_colname) + 1] = as_colname
	end if
end if

ll_count = upperbound(ls_colname)
for ll_column = 1 to ll_count
	ll_dddwwidth = 0
	adw_target.getchild(ls_colname[ll_column], ldwc_child)
	ls_objects = ldwc_child.describe("datawindow.objects") + ls_TABCHAR
	ll_pos = pos(ls_objects, ls_TABCHAR)
	do while ll_pos > 0
		ls_objname = left(ls_objects, ll_pos - 1)
		ls_objects = mid(ls_objects, ll_pos + len(ls_TABCHAR))
		ll_pos = pos(ls_objects, ls_TABCHAR)
		
		if trim(ls_objname) = "" then continue
		if ldwc_child.describe(ls_objname + ".visible") = '0' then continue
		
		ll_xpos = long(ldwc_child.describe(ls_objname + ".x"))
		ll_width = long(ldwc_child.describe(ls_objname + ".width"))
		if ll_xpos + ll_width > ll_dddwwidth then
			ll_dddwwidth = ll_xpos + ll_width
		end if
	loop
	
	ll_colwidth = long(adw_target.describe(ls_colname[ll_column] + ".width"))
	ll_percent = ceiling(((ll_dddwwidth + li_VSCROLLBARWIDTH) * 100.0) / ll_colwidth)
	if ll_percent < 100 then ll_percent = 100
	
	adw_target.modify(ls_colname[ll_column] + ".dddw.vscrollbar = yes")
	adw_target.modify(ls_colname[ll_column] + ".dddw.percentwidth = " + string(ll_percent))
next

end subroutine

public subroutine of_autoadjustdddwwidth (datawindow adw_target);/********************************************************************
   of_autoadjustdddwwidth
   <DESC> Auto adjust the width of dropdown of the columns </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_target : the target datawindow in which the width of dropdown datawindow will be reset
   </ARGS>
   <USAGE> Suggest to use in the Open event of the window </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/09/2011   N/A	        ZSW001       First Version
   </HISTORY>
********************************************************************/

of_autoadjustdddwwidth(adw_target, "")

end subroutine

on n_dw_style_service.create
call super::create
end on

on n_dw_style_service.destroy
call super::destroy
end on

event constructor;call super::constructor;this.#pooled=true

end event

