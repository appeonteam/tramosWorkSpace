$PBExportHeader$n_dataexport.sru
forward
global type n_dataexport from mt_n_nonvisualobject
end type
type str_css_class from structure within n_dataexport
end type
end forward

type str_css_class from structure
	string		s_name
	string		s_type
end type

global type n_dataexport from mt_n_nonvisualobject autoinstantiate
end type

type variables
// datawindow idw_export
datastore ids_export
end variables

forward prototypes
public function integer of_checkcomputed (mt_u_datawindow adw_export)
public function integer of_export (ref mt_u_datawindow adw_export)
public subroutine documentation ()
public function string of_datatohtml (mt_u_datawindow adw_export, boolean ab_usehtmlversion4, boolean ab_generatecss, boolean ab_nowrap, boolean ab_solidborder, boolean ab_defaultborder)
public function string of_asctochar (integer ai_char)
public function string of_handlespecialcharacter (string as_str)
end prototypes

public function integer of_checkcomputed (mt_u_datawindow adw_export);string ls_Temp, ls_Obj_Names[], ls_Data, ls_Visible, ls_Type
integer li_Loop
mt_n_stringfunctions		lnv_stringfunc

// Get all objects in source datawindow and split names into array
ls_Temp=adw_Export.Describe("DataWindow.Objects")
If lnv_stringfunc.of_split(ls_Obj_Names,string(adw_Export.Describe("DataWindow.Objects")), Chara(9)) = -1 then
	Return c#return.Failure
End if
// Redefine source table columns in export datawindow
//ls_modify_syntax="table(column=(type=number updatewhereclause=yes name=serial_number dbname='serial_number' )"
For li_Loop=1 to Upperbound(ls_Obj_Names)   // loop thru the headers first to create table columns
	ls_Type=adw_Export.Describe(ls_obj_names[li_loop]+".type")
	ls_visible = adw_Export.Describe(ls_Obj_Names[li_Loop]+".visible")
	if left(ls_visible,1)=char(34) then
		ls_visible=mid(ls_visible,2,1)
	end if
	If integer(ls_visible) = 1 and ls_Type="compute" then
		return c#return.Success
	end if
Next

Return c#return.NoAction
end function

public function integer of_export (ref mt_u_datawindow adw_export);/********************************************************************
	of_export( /*ref datawindow adw_export */)
   <DESC>By default datawindow saveas() method does not export computed fields
	this function overcomes that limitation</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw_export: Source datawindow</ARGS>
   <USAGE>  Use instead of SaveAs() method.</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	20-05-2013 ?            LHC010        Fix the column order is not same and export dddw and ddlb display value
	11/11/16   CR2001       LHG008        Set column header to uppercase
	06/04/17   CR4556       EPE080        Saved As documents have the same column headers as the ones in the window,add:checkbox column exported yes/no,radiobuttons/codetable column exported display	
   </HISTORY>
********************************************************************/

Integer li_loop, li_col_count, li_is_visible, li_newrow, li_rowcount, li_decilen
String   ls_modify_syntax, ls_temp, ls_obj_names[], ls_sql = "Select ", ls_visible, ls_format
String   ls_new_syntax, ls_error_syntaxfromsql, ls_data, ls_colname, ls_edittype, ls_value, ls_headertext, ls_editcodetable
long	  ll_col_x
mt_n_datastore lds_export, lds_properties
mt_n_stringfunctions		lnv_stringfunc

// Create datawindow for export
lds_export=create mt_n_datastore
lds_export.Dataobject="d_ex_tb_empty"

lds_properties = create mt_n_datastore
lds_properties.Dataobject="d_ex_gr_dw_properties"


// Get all objects in source datawindow and split names into array
ls_temp=adw_Export.Describe("DataWindow.Objects")
If lnv_stringfunc.of_split(ls_obj_names,string(adw_Export.Describe("DataWindow.Objects")), Chara(9)) = -1 then
	Messagebox("Error","Unable to split columns")
	Return -1
End if

// Redefine source table columns in export datawindow
//ls_modify_syntax="table(column=(type=number updatewhereclause=yes name=serial_number dbname='serial_number' )"
ls_modify_syntax="table("
For li_Loop=1 to Upperbound(ls_obj_names)   // loop thru the headers first to create table columns
	ls_temp=adw_Export.Describe(ls_obj_names[li_loop]+".type")
	ls_data=Lower(adw_Export.Describe(ls_obj_names[li_loop]+".band"))	
	
	ls_visible = adw_Export.Describe(ls_obj_names[li_Loop]+".visible")
	if left(ls_visible,1)=char(34) then
		ls_visible=mid(ls_visible,2,1)
	end if
	
	If integer(ls_visible) = 1 and (ls_temp="column" or ls_temp="compute") and (Left(ls_data,7)="header." or ls_data="detail") then
		ls_edittype=lower(adw_export.Describe(ls_obj_names[li_loop] + ".Edit.Style"))		
		ls_temp = lower(adw_Export.Describe(ls_obj_names[li_Loop] + ".ColType"))
		ls_editcodetable = lower(adw_Export.Describe(ls_obj_names[li_Loop] + ".Edit.Codetable"))

		// limitation - 1000 chars for a computed field as by default coltype returns only char.  This throws an error.
		//add radiobuttons checkbox cr4556 
		If ls_temp = "char" or ls_edittype = "dddw" or ls_edittype = "ddlb" or ls_edittype = "radiobuttons" or ls_edittype = "checkbox"  or (ls_edittype = 'edit' and ls_editcodetable = 'yes') then ls_temp = "char(1000)"
		//when column type is computer decimal, get 'decimal' ?		
		ls_format = lower(adw_export.Describe(ls_obj_names[li_loop] + ".Format"))
		If (ls_temp = "decimal" OR  ls_temp = "number") and adw_Export.Describe(ls_obj_names[li_loop]+".type") = "compute"  then 
			if pos(ls_format,';') > 0 then
				ls_format = left(ls_format, pos(ls_format,';') - 1)
			end if
			if pos(ls_format,'.') > 0 then
				li_decilen = len(ls_format) - pos(ls_format,'.')
				ls_temp = "decimal(" + string(li_decilen) + ")" 
			else
				ls_temp = "decimal(2)" 
			end if
		end if
		If ls_temp = "datetime" then 
			//change datetime to date	
			if  ls_edittype = "editmask" then				                    
				if lower(adw_export.Describe(ls_obj_names[li_loop] + ".editmask.useformat")) = 'yes' then
				else
					ls_format = lower(adw_export.Describe(ls_obj_names[li_loop] + ".EditMask.Mask"))
				end if
			end if
			if pos(ls_format,'h:')  = 0 and pos(ls_format,'[time]') = 0 then ls_temp = 'date'
		end if
				
		ls_headertext = adw_Export.Describe(ls_obj_names[li_loop]+"_t.text")  //get header text by column name
		//if header text valid and not equal object name,set dbname=header text  cr4556
		if ls_headertext <> '!' and  ls_headertext <> '?' and ls_headertext <> ls_obj_names[li_loop] then
			//Header text contain "
			ls_headertext = lnv_stringfunc.of_replace(ls_headertext,'.',' ')
			ls_headertext = of_handlespecialcharacter(ls_headertext)
			ls_modify_syntax = "column=(type=" + ls_temp + " updatewhereclause=yes name=" + ls_obj_names[li_loop] + ' dbname="' + ls_headertext + '" ) '
		else
			ls_modify_syntax = "column=(type=" + ls_temp + " updatewhereclause=yes name=" + ls_obj_names[li_loop] + ' dbname="' + upper(ls_obj_names[li_loop]) + '" ) '
		end if
		
		li_newrow = lds_properties.insertrow(0)
		lds_properties.setitem(li_newrow, "col_name", ls_obj_names[li_loop])
		ll_col_x = long(adw_export.describe(ls_obj_names[li_Loop] + ".x"))
		lds_properties.setitem(li_newrow, "col_x", ll_col_x)
		lds_properties.setitem(li_newrow, "col_syntax", ls_modify_syntax)
	Else
		ls_obj_names[li_Loop]=''   // If not a valid control, then make it empty
	End if
Next

lds_properties.setsort("col_x A")
lds_properties.sort( )

li_rowcount = lds_properties.rowcount( )

ls_modify_syntax="table("

for li_loop = 1 to li_rowcount
	ls_temp = lds_properties.getitemstring(li_loop, "col_syntax")
	ls_modify_syntax += ls_temp
next

ls_modify_syntax += ")"
ls_temp=lds_export.Modify(ls_modify_syntax)

for li_col_count = 1 to li_rowcount
	ls_colname = lds_properties.getitemstring(li_col_count, "col_name")
	ls_temp="create column(band=detail id=" + String(li_col_count) + " alignment='0' tabsequence=" + string(li_col_count*10) + " border='0' color='0' x='" + String(li_col_count * 200) + "' y='4' height='76' width='200' html.valueishtml='0'  name=" + ls_colname + " visible='1' edit.limit=200 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face='Tahoma' font.height='-12' font.weight='400'  font.family='2' font.pitch='2' font.charset='0' background.mode='2' background.color='16777215' background.transparency='0' background.gradient.color='8421504' background.gradient.transparency='0' background.gradient.angle='0' background.brushmode='0' background.gradient.repetition.mode='0' background.gradient.repetition.count='0' background.gradient.repetition.length='100' background.gradient.focus='0' background.gradient.scale='100' background.gradient.spread='100' tooltip.backcolor='134217752' tooltip.delay.initial='0' tooltip.delay.visible='32000' tooltip.enabled='0' tooltip.hasclosebutton='0' tooltip.icon='0' tooltip.isbubble='0' tooltip.maxwidth='0' tooltip.textcolor='134217751' tooltip.transparency='0' transparency='0')"
	ls_temp=lds_export.Modify(ls_temp)	
next

// Convert all data into string and copy
For li_Loop = 1 to adw_Export.RowCount()   // Loop thru rows
	li_NewRow = lds_export.InsertRow(0)     // Insert new row
	If li_NewRow <= 0 then 
		Messagebox("Export Error", "Unable to add rows in export datawindow!")
		Destroy lds_export
		Return -1
	End If
	//lds_export.SetItem(li_NewRow, "Serial_Number", li_Loop)
	For li_Col_Count = 1 to Upperbound(ls_obj_names)  // Loop thru columns
		If ls_obj_names[li_Col_Count] <> "" then       // If column is valid
			
			ls_temp = adw_Export.Describe(ls_obj_names[li_Col_Count] + ".ColType") // get type of column
			ls_data = adw_Export.Describe(ls_obj_names[li_Col_Count] + ".Format") // get format of column
			ls_edittype=lower(adw_Export.Describe(ls_obj_names[li_Col_Count] + ".Edit.Style"))//get edit style
			ls_editcodetable = lower(adw_Export.Describe(ls_obj_names[li_Col_Count] + ".Edit.Codetable")) //get edit codetable
			
			/* add checkbox radiobuttons  cr4556 */
			if ls_edittype = "checkbox" then
				//messagebox(adw_Export.describe("evaluate('" + ls_obj_names[li_Col_Count] + "')," + string( li_Loop)),adw_Export.describe(ls_obj_names[li_Col_Count]+".checkbox.on"))
				if adw_Export.describe("evaluate('" + ls_obj_names[li_Col_Count] + "'," + string( li_Loop)+ ")") = adw_Export.describe(ls_obj_names[li_Col_Count]+".checkbox.on") then
					ls_value = 'Yes'
				else
					ls_value = 'No'
				end if
				lds_export.setitem(li_newrow, ls_obj_names[li_Col_Count], ls_value)
			elseif ls_edittype = "dddw" or ls_edittype = "ddlb" or ls_edittype = "radiobuttons" or (ls_edittype = 'edit' and ls_editcodetable = 'yes') then
				ls_value = adw_Export.describe("Evaluate('LookUpDisplay(" + ls_obj_names[li_Col_Count] + ") '," + string(li_loop) + " )")
				lds_export.setitem(li_newrow, ls_obj_names[li_Col_Count], ls_value)
			else	
				Choose Case Lower(Left(ls_temp, 5))  // Use right function to extract and save data
					Case "datet"	
						//changed datetime to date 
						if lower(lds_export.Describe(ls_obj_names[li_col_count] + ".ColType")) = 'date' then
							lds_export.SetItem(li_NewRow, ls_obj_names[li_col_count],Date(adw_Export.GetItemDateTime(li_Loop, ls_obj_names[li_Col_Count]) ) )		
						else
							lds_export.SetItem(li_NewRow, ls_obj_names[li_col_count],adw_Export.GetItemDateTime(li_Loop, ls_obj_names[li_Col_Count]) )
						end if
					Case "date"
						lds_export.SetItem(li_NewRow, ls_obj_names[li_Col_Count], adw_Export.GetItemDate(li_Loop, ls_obj_names[li_Col_Count]))
					Case "time"
						lds_export.SetItem(li_NewRow, ls_obj_names[li_Col_Count], adw_Export.GetItemTime(li_Loop, ls_obj_names[li_Col_Count]))										
					Case "int", "long", "real", "numbe", "decim"
						lds_export.SetItem(li_NewRow, ls_obj_names[li_Col_Count], adw_Export.GetItemNumber(li_Loop, ls_obj_names[li_Col_Count]))
					Case "char", "char("
						lds_export.SetItem(li_NewRow, ls_obj_names[li_Col_Count], adw_Export.GetItemString(li_Loop, ls_obj_names[li_Col_Count]))
					Case Else
						Messagebox("", "Different datatype than expected: " + ls_temp)
				End Choose
			end if
		End if
	Next
Next

// No rows
If lds_export.RowCount() = 0 then 
	Messagebox("Info", "There are no rows to export in current selection")
	Return -1	
End If

lds_export.object.dataWindow.nouserprompt='No'

lds_export.saveas("",XLSX!,true)

Destroy lds_export

Return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_dataexport
	
	<OBJECT>
		Used to export data from datawindow, extracts calculated controls and controls 
		that are visible.
	</OBJECT>
   <DESC>
		
	</DESC>
   <USAGE>
		Used directly in mt_u_datawindow ancestor
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
   Date   		Ref    				Author   	Comments
  	18/02/13 	CR????      		AGL027		First Version
	30/05/16		CR4291				AGL027		Standardized file dialogue SaveAs to use Excel12  
	06/09/16		CR2009				LHG008		Add funcion of_datatohtml used to generate user friendly html data
	11/11/16		CR2001				LHG008		Set column header to uppercase
	06/04/17     CR4556                EPE080        Saved As documents have the same column headers as the ones in the window,checkbox exported yes/no,radiobuttons exported display	
********************************************************************/
end subroutine

public function string of_datatohtml (mt_u_datawindow adw_export, boolean ab_usehtmlversion4, boolean ab_generatecss, boolean ab_nowrap, boolean ab_solidborder, boolean ab_defaultborder);/********************************************************************
   of_datatohtml
   <DESC>	By default datawindow to html method use for mail not user friendly,
	this function generate user friendly html data	</DESC>
   <RETURN>	string	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_export
		ab_generatecss
		ab_nowrap
		ab_usehtmlversion4
		ab_solidborder
		ab_defaultborder
   </ARGS>
   <USAGE>	Use to generate html	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/09/16 CR2009        LHG008   First Version
   </HISTORY>
********************************************************************/

string	ls_strhtml, ls_classstr, ls_strfinalhtml, ls_table_classid, ls_style
integer	li_pos1, li_pos2, li_index, li_i, li_classnlength

str_css_class			lstr_array_css_class[], lstr_css_class
mt_n_stringfunctions	lnv_string

constant string ls_CLASSPREFIX = "~r~n.htmldw"

if ab_usehtmlversion4 then adw_export.object.datawindow.htmlgen.htmlversion = "4.0"

//1. Get html string, contain CLASS
if ab_generatecss then adw_export.object.datawindow.htmltable.generatecss = 'yes'

ls_strhtml = adw_export.describe("datawindow.data.html")

//2. Find all of the class in used(not include duplicates) and add to lstr_array_css_class
li_pos1 = pos(ls_strhtml, "CLASS=", li_pos1 + 1)

li_pos2 = pos(ls_strhtml, ls_CLASSPREFIX)
li_classnlength = pos(ls_strhtml, '{', li_pos2) - li_pos2 - 3

do while li_pos1 > 0
	lstr_css_class.s_name = mid(ls_strhtml, li_pos1 + 6, li_classnlength)
	
	li_pos2 = lastpos(ls_strhtml, '<', li_pos1)
	lstr_css_class.s_type = mid(ls_strhtml, li_pos2 + 1, pos(ls_strhtml, c#string.Space, li_pos2) - 1 - li_pos2)
	
	if li_index = 0 then
		li_index ++
		lstr_array_css_class[li_index] = lstr_css_class
	else
		for li_i = 1 to li_index
			if lstr_css_class.s_name = lstr_array_css_class[li_i].s_name &
				and lstr_css_class.s_type = lstr_array_css_class[li_i].s_type then
				exit
			end if
			
			if li_i = li_index then
				li_index ++
				lstr_array_css_class[li_index] = lstr_css_class
				exit
			end if
		next
	end if
	
	li_pos1 = pos(ls_strhtml, "CLASS=", li_pos1 + 6)
loop

//3. Replace css definition, enrich class prefix(s_type + s_name)
/*	eg.
		
		.htmldw4A8{;background-color:#ffffff}
		.htmldw7A2E{;background-color:#234a59; width:100%}
		
	change to:
		TABLE.htmldw4A8{background-color:#ffffff}
		TR.htmldw4A8{background-color:#ffffff}
		TR.htmldw7A2E{background-color:#234a59; width:100%}
*/

li_pos1 = 1
li_pos1 = pos(ls_strhtml, ls_CLASSPREFIX, li_pos1)
if li_pos1 > 0 then ls_strfinalhtml = mid(ls_strhtml, 1, li_pos1 - 1)

do while li_pos1 > 0
	li_pos2 = pos(ls_strhtml, "}", li_pos1 + 7)
	ls_classstr = mid(ls_strhtml, li_pos1 + 2, li_pos2 - li_pos1 - 1)
	ls_classstr = lnv_string.of_replace(ls_classstr, "{;", '{')
	
	lstr_css_class.s_name = mid(ls_classstr, 2, pos(ls_classstr, '{') - 2)
	
	for li_index = 1 to upperbound(lstr_array_css_class)
		if lstr_css_class.s_name = lstr_array_css_class[li_index].s_name then
			ls_strfinalhtml += c#string.CRLF + lstr_array_css_class[li_index].s_type + ls_classstr
		end if
	next
	
	li_pos1 = pos(ls_strhtml, ls_CLASSPREFIX, li_pos2 + 1)
loop

ls_strfinalhtml += mid(ls_strhtml, li_pos2 + 1)

//4. Set style
if ab_solidborder then ls_strfinalhtml = lnv_string.of_replace(ls_strfinalhtml, 'BORDER-STYLE:none', 'BORDER-STYLE:solid')
if ab_defaultborder then ls_strfinalhtml = lnv_string.of_replace(ls_strfinalhtml, 'BORDER-STYLE:none', '')

if ab_generatecss then
	ls_table_classid = mid(ls_strfinalhtml, pos(ls_strfinalhtml, "<TABLE CLASS=") + len("<TABLE CLASS="), li_classnlength)
else
	ls_table_classid = string(rand(1000))
	ls_strfinalhtml = lnv_string.of_replace(ls_strfinalhtml, '<TABLE ', '<TABLE CLASS="' + ls_table_classid + '" ')
end if

ls_table_classid = "table." + ls_table_classid
ls_style = ls_table_classid + "{border-collapse:collapse}"

if ab_nowrap then ls_style += "~r~n" + ls_table_classid + " th, " + ls_table_classid + " td{white-space:nowrap}"

ls_strfinalhtml = "<style>" + ls_style + "</style>~r~n" + ls_strfinalhtml

ls_strfinalhtml = lnv_string.of_replace(ls_strfinalhtml, c#string.Tab, c#string.Space)
ls_strfinalhtml = lnv_string.of_replace(ls_strfinalhtml, c#string.Space + c#string.Space, c#string.Space)
ls_strfinalhtml = lnv_string.of_replace(ls_strfinalhtml, c#string.CRLF + c#string.CRLF, c#string.CRLF)

return ls_strfinalhtml
end function

public function string of_asctochar (integer ai_char);string	ls_char  , ls_Char1, ls_Char2
integer	li , li_mod

li = int( ai_char / 26 )
li_mod = mod( ai_char, 26 )

IF li > 0 and li_mod > 0 then
	ls_char1 = char( 64 + li )
	ls_char2 = char( 64 + li_mod )
elseif li > 1 and li_mod = 0 then
	ls_char1 = char( 64 + li - 1 )
	ls_char2 = 'Z'
elseif li <= 1   then
	ls_Char1 = ''
	ls_Char2 = char( 64 + ai_Char )
end if

ls_char = ls_char1 + ls_char2
return ls_char
end function

public function string of_handlespecialcharacter (string as_str);string ls_headertext
int li_pos,li_len

ls_headertext = as_str
if left(ls_headertext,1) = '"' and right(ls_headertext,1) = '"' then
	ls_headertext = right(ls_headertext,len(ls_headertext) - 1)
	ls_headertext = left(ls_headertext,len(ls_headertext) - 1)
end if

li_len = len(ls_headertext)
li_pos = 1
do while li_pos <= li_len
	li_pos = pos(ls_headertext,'~~',li_pos)
	if li_pos = 0 then exit
	if mid(ls_headertext,li_pos + 1,1) <> '"' then
		ls_headertext = left(ls_headertext,li_pos ) + '~~' +  right(ls_headertext,li_len - li_pos )
		li_pos = li_pos + 2
	else
		li_pos = li_pos + 1
	end if
	li_len = len(ls_headertext)
loop 

li_len = len(ls_headertext)
li_pos = 1
do while li_pos <= li_len
	li_pos = pos(ls_headertext,'"',li_pos)
	if li_pos = 0 then exit
	if mid(ls_headertext,li_pos - 1,1) <> '~~' then
		ls_headertext = left(ls_headertext,li_pos - 1) + '~~' +  right(ls_headertext,li_len - li_pos + 1)
		li_pos = li_pos + 2
	else
		li_pos = li_pos + 1
	end if
	li_len = len(ls_headertext)
loop 
if right(ls_headertext,1) = '~~'  and  mid(ls_headertext,len(ls_headertext) - 1,1) <> '~~' then ls_headertext =  ls_headertext + '~~'

return ls_headertext
end function

on n_dataexport.create
call super::create
end on

on n_dataexport.destroy
call super::destroy
end on

