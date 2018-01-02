$PBExportHeader$w_save_as_file.srw
$PBExportComments$A window to filter,sort datawindows and save them as different types of files.
forward
global type w_save_as_file from Window
end type
type sle_1 from singlelineedit within w_save_as_file
end type
type st_1 from statictext within w_save_as_file
end type
type cb_reset from commandbutton within w_save_as_file
end type
type cb_close from commandbutton within w_save_as_file
end type
type cb_save from commandbutton within w_save_as_file
end type
type cb_sort from commandbutton within w_save_as_file
end type
type cb_filter from commandbutton within w_save_as_file
end type
type dw_contact from datawindow within w_save_as_file
end type
end forward

global type w_save_as_file from Window
int X=65
int Y=133
int Width=2830
int Height=1653
boolean TitleBar=true
string Title="Save As File"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
sle_1 sle_1
st_1 st_1
cb_reset cb_reset
cb_close cb_close
cb_save cb_save
cb_sort cb_sort
cb_filter cb_filter
dw_contact dw_contact
end type
global w_save_as_file w_save_as_file

type variables
string is_sort_order
end variables

on open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_contact_person
  
 Object     : cb_save
  
 Event	 : clicked

 Scope     : button

 ************************************************************************************

 Author    : Bettina Olsen
   
 Date       : 02-02-97

 Description :	Saves the contents of the datavindow as a file. 
					The name and format of the file is chosen by
					the user.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
04-02-97		1.0			BHO			INITIAL VERSION
************************************************************************************/


dw_contact.dataobject = message.Stringparm
dw_contact.settransobject(sqlca)
dw_contact.retrieve()
sle_1.text=string(dw_contact.rowcount())
end on

on w_save_as_file.create
this.sle_1=create sle_1
this.st_1=create st_1
this.cb_reset=create cb_reset
this.cb_close=create cb_close
this.cb_save=create cb_save
this.cb_sort=create cb_sort
this.cb_filter=create cb_filter
this.dw_contact=create dw_contact
this.Control[]={ this.sle_1,&
this.st_1,&
this.cb_reset,&
this.cb_close,&
this.cb_save,&
this.cb_sort,&
this.cb_filter,&
this.dw_contact}
end on

on w_save_as_file.destroy
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.cb_reset)
destroy(this.cb_close)
destroy(this.cb_save)
destroy(this.cb_sort)
destroy(this.cb_filter)
destroy(this.dw_contact)
end on

type sle_1 from singlelineedit within w_save_as_file
int X=2318
int Y=1317
int Width=183
int Height=81
int TabOrder=60
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_save_as_file
int X=2510
int Y=1317
int Width=183
int Height=89
boolean Enabled=false
string Text="Rows"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_reset from commandbutton within w_save_as_file
int X=810
int Y=1337
int Width=362
int Height=81
int TabOrder=70
string Text="Reset"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;/*Set the filter off again to get the original data into the datawindow*/
dw_contact.setfilter("")
dw_contact.filter()
dw_contact.setsort("#1A")
dw_contact.sort()
dw_contact.retrieve()
sle_1.text=string(dw_contact.rowcount())


end event

type cb_close from commandbutton within w_save_as_file
int X=1569
int Y=1337
int Width=362
int Height=81
int TabOrder=50
string Text="Close"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;/*close the window*/
close(parent)
end on

type cb_save from commandbutton within w_save_as_file
int X=1189
int Y=1337
int Width=362
int Height=81
int TabOrder=40
string Text="Save"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;integer 			li_value,li_save_value
string 			ls_docname,ls_named,ls_extension
saveastype 		lsav_format

/*Call the windows dialog to get the filename and format from the user*/
/*GetFileSaveName (title,rfilename{,extension{,filter}})*/
li_value = GetFileSaveName("Select File",&
				ls_docname,ls_named,"CSV",&
				"commaseparated(*.CSV),*.CSV,"+&
				"Excel Files (*.xls),*.xls,"+&
				"Lotus 1-2-3 (*.WK1),*.WK1,"+&
				"Lotus 1-2-3 (*.WKS),*.WKS")


/*Save the file in the chosen format and with the written document name*/
if li_value = 1 then
	ls_extension=right(ls_named,3)
	if ls_extension='CSV' then
		lsav_format=CSV!
	elseif ls_extension='xls' then
		lsav_format=excel!
	elseif ls_extension='WK1' then
		lsav_format=WK1!
	elseif ls_extension='WKS' then
		lsav_format=WKS!
   else
		return
	end if	
		
	li_save_value=dw_contact.SaveAs(ls_docname,lsav_format,true)
	if li_save_value=1 then
		messagebox("Notice","The file is saved")
	else
		messagebox("Error","An error occured. The file is not saved!")
	end if
	
elseif li_value = 0 then
	return	
else	
	messagebox("Error","An error occured. The file is not saved!")
end if

end on

type cb_sort from commandbutton within w_save_as_file
int X=430
int Y=1337
int Width=362
int Height=81
int TabOrder=30
string Text="Sort"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;string null_str

/*Call the sort dialog*/
SetNull(null_str)
dw_contact.SetSort(null_str)
dw_contact.Sort( )
sle_1.text=string(dw_contact.rowcount())
end on

type cb_filter from commandbutton within w_save_as_file
int X=51
int Y=1337
int Width=362
int Height=81
int TabOrder=20
string Text="Filter"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;string null_str

/*Call the filter dialog*/
SetNull(null_str)
dw_contact.SetFilter(null_str)
dw_contact.Filter( )
sle_1.text=string(dw_contact.rowcount())

end on

type dw_contact from datawindow within w_save_as_file
int X=65
int Y=53
int Width=2689
int Height=1241
int TabOrder=10
string DataObject="d_brokers_clndr"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

