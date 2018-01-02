$PBExportHeader$w_generate_supervasfile_control.srw
$PBExportComments$Window containing the functionality for generating super vas control file. Shows if there are any differences in estact and act columns
forward
global type w_generate_supervasfile_control from window
end type
type cb_saveas from commandbutton within w_generate_supervasfile_control
end type
type cb_print from commandbutton within w_generate_supervasfile_control
end type
type st_6 from statictext within w_generate_supervasfile_control
end type
type dw_message from datawindow within w_generate_supervasfile_control
end type
type hpb_1 from hprogressbar within w_generate_supervasfile_control
end type
type em_to_year from editmask within w_generate_supervasfile_control
end type
type st_5 from statictext within w_generate_supervasfile_control
end type
type em_from_year from editmask within w_generate_supervasfile_control
end type
type st_4 from statictext within w_generate_supervasfile_control
end type
type dw_profit_center from datawindow within w_generate_supervasfile_control
end type
type cb_3 from commandbutton within w_generate_supervasfile_control
end type
type cb_2 from commandbutton within w_generate_supervasfile_control
end type
type st_3 from statictext within w_generate_supervasfile_control
end type
type st_2 from statictext within w_generate_supervasfile_control
end type
type st_1 from statictext within w_generate_supervasfile_control
end type
type cb_generate from commandbutton within w_generate_supervasfile_control
end type
type gb_1 from groupbox within w_generate_supervasfile_control
end type
type dw_vas_log from datawindow within w_generate_supervasfile_control
end type
end forward

shared variables

end variables

global type w_generate_supervasfile_control from window
integer x = 832
integer y = 360
integer width = 3579
integer height = 1840
boolean titlebar = true
string title = "VAS File Control (Diff.)"
boolean controlmenu = true
boolean minbox = true
long backcolor = 81324524
cb_saveas cb_saveas
cb_print cb_print
st_6 st_6
dw_message dw_message
hpb_1 hpb_1
em_to_year em_to_year
st_5 st_5
em_from_year em_from_year
st_4 st_4
dw_profit_center dw_profit_center
cb_3 cb_3
cb_2 cb_2
st_3 st_3
st_2 st_2
st_1 st_1
cb_generate cb_generate
gb_1 gb_1
dw_vas_log dw_vas_log
end type
global w_generate_supervasfile_control w_generate_supervasfile_control

type variables
boolean ib_interrupt
s_vas_file istr_vas_file
s_vas_file_container istr_vas_file_container[]
Integer ii_first_voyage 
end variables

forward prototypes
public function boolean wf_yield ()
public function integer wf_first_voyage (integer ai_vessel_nr, string as_voyage_nr)
public subroutine wf_generate_file (integer profitcenter[])
public subroutine documentation ()
end prototypes

public function boolean wf_yield ();
Yield( )

If ib_interrupt THEN 
	MessageBox("Notice","Creation of file was interrupted!")
	ib_interrupt = FALSE
	st_1.visible = false
	st_2.visible = false
	st_3.visible = false
	cb_2.enabled = false
	return true
end if

return false
end function

public function integer wf_first_voyage (integer ai_vessel_nr, string as_voyage_nr);/*
 Author    		: Bettina Olsen
 Date       	: November 97
 Description 	: This function checks if the current voyage is the vessels´ first voyage.				voyage accounting system.
 Arguments 		: vessel_nr, voyage_nr
 Returns   		: integer
 Variables 		: 
 Other 			: 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
Nov				5.00			BO				First Release
************************************************************************************/

/*Declare local variables*/
string ls_last_voyage_nr


/* Find out if it is the vessels first voyage */
		SELECT MAX(POC.VOYAGE_NR)  
    	        INTO :ls_last_voyage_nr
    		FROM POC,PORTS  
 		 WHERE  	( POC.PORT_CODE = PORTS.PORT_CODE ) and  
			        ( POC.VESSEL_NR = :ai_vessel_nr ) AND  
         	                (POC.VOYAGE_NR < :as_voyage_nr  ) AND
				POC.PORT_DEPT_DT <> null  ;
		commit;


if sqlca.sqlcode = 100 then
 	return 1
else
	return 0
end if	

end function

public subroutine wf_generate_file (integer profitcenter[]);/* Declare local variables */
u_vas_control lu_vas_control
datastore 	lds_vessel_voyages, lds_vas_file
Boolean lb_new_vessel = TRUE
decimal{2} 	ld_ex_rate[], ld_result, ld_total_days, ld_days
long			ll_result, ll_count,ll_number_of_voyages,ll_row
string 		ls_from_year, ls_to_year, ls_file_name
s_vessel_voyage_list lstr_vessel_voyage_list[]
Integer li_key[], li_vessel_index = 1, li_previous_vessel, li_voyage_index = 1, li_this_voyage_type
Integer li_upper_vessels, li_vessel_counter,li_upper_voyages,li_voyage_counter, li_previous_voyage_type
string notinuse
s_vas_file_container lstr_empty_container[]


/* Get Filename and Save File as an Excel-file without headerfields */
ls_file_name = "VAScontrolFile"+string(today(),"ddmmyy") 
ll_result = GetFileSaveName("Enter valid filename...", &
		ls_file_name, notinuse, "XLS", &
		"Excel Files (*.XLS),*.XLS," + &
		" All Files (*.*), *.*")
if ll_result <> 1 then
	st_3.text = "Wrong filename"
	return
end if

/* Create user objects */
lu_vas_control = create u_vas_control

ls_from_year = em_from_year.text
ls_to_year = em_to_year.text
//ls_year = Right(String(Year(today())),2)

lds_vessel_voyages 	= create datastore
lds_vessel_voyages.dataobject ='d_vasfile_vessel_voyage'
lds_vessel_voyages.settransobject(SQLCA)
ll_number_of_voyages = lds_vessel_voyages.retrieve(profitcenter,ls_from_year, ls_to_year)

IF NOT(ll_number_of_voyages > 0) THEN 
	MessageBox("Information","There are no voyages for selected profitcenter(s)")
	destroy(lu_vas_control)
	destroy(lds_vessel_voyages)
	return
END IF

/* Show progress information to the user */
st_1.visible = true
st_2.visible = true
st_3.visible = true
cb_2.enabled = true

// Loop through voyages and build data for vas file
// dw_vas_log is used as a dummy parameter for lu_vas_control
istr_vas_file_container = lstr_empty_container /* reset container */

hpb_1.maxposition = ll_number_of_voyages
for ll_count = 1 to ll_number_of_voyages 
	hpb_1.position = ll_count
	st_2.text = lds_vessel_voyages.GetItemString(ll_count,"vessel_ref_nr")
	st_3.text = "Voyage (Get Data) : " + lds_vessel_voyages.GetItemString(ll_count,"voyages_voyage_nr")
	if wf_yield() then 
		/* Destroy user objects */
		destroy(lu_vas_control)
		destroy(lds_vessel_voyages)
		return
	end if
	lstr_vessel_voyage_list[1].vessel_nr = lds_vessel_voyages.GetItemNumber(ll_count,"voyages_vessel_nr")
	lstr_vessel_voyage_list[1].vessel_ref_nr = lds_vessel_voyages.GetItemString(ll_count,"vessel_ref_nr")
	lstr_vessel_voyage_list[1].voyage_nr = lds_vessel_voyages.GetItemString(ll_count,"voyages_voyage_nr")
	//wf_first_voyage(lstr_vessel_voyage_list[1].vessel_nr, lstr_vessel_voyage_list[1].voyage_nr)
	lu_vas_control.of_master_control( 7,li_key[], lstr_vessel_voyage_list[], Integer(mid(lstr_vessel_voyage_list[1].voyage_nr,1,2)), dw_vas_log)
	IF (lstr_vessel_voyage_list[1].vessel_nr <> li_previous_vessel) AND ll_count <> 1 THEN
		li_vessel_index ++
		li_voyage_index = 1
		lb_new_vessel = TRUE
	ELSE
		lb_new_vessel = FALSE
	END IF
	istr_vas_file_container[li_vessel_index].vessel[li_voyage_index] = lstr_vessel_voyage_list[1].vessel_nr
	istr_vas_file_container[li_vessel_index].vessel_ref_nr[li_voyage_index] = lstr_vessel_voyage_list[1].vessel_ref_nr
	istr_vas_file_container[li_vessel_index].voyage[li_voyage_index] = lstr_vessel_voyage_list[1].voyage_nr

	istr_vas_file_container[li_vessel_index].freight[li_voyage_index] = istr_vas_file.freight
	istr_vas_file_container[li_vessel_index].demurrage[li_voyage_index] = istr_vas_file.demurrage
	istr_vas_file_container[li_vessel_index].commission[li_voyage_index] =  istr_vas_file.commission
	istr_vas_file_container[li_vessel_index].portexp[li_voyage_index] = istr_vas_file.portexp
	istr_vas_file_container[li_vessel_index].bunkerexp[li_voyage_index] = istr_vas_file.bunkerexp
	istr_vas_file_container[li_vessel_index].miscexp[li_voyage_index] = istr_vas_file.miscexp 
		
	li_voyage_index ++
	li_previous_vessel = lstr_vessel_voyage_list[1].vessel_nr
	
	// Clear voyage data
	lstr_vessel_voyage_list[1].vessel_nr = 0
	lstr_vessel_voyage_list[1].voyage_nr = ""
   SetNull(istr_vas_file.startdate)
	SetNull(istr_vas_file.enddate) 
	istr_vas_file.freight = 0
	istr_vas_file.demurrage = 0
   istr_vas_file.commission = 0
   istr_vas_file.portexp = 0
	istr_vas_file.bunkerexp = 0
	istr_vas_file.miscexp = 0
next

// Insert data in datastore
// For each vessel istr_vas_file_container[li_vessel_counter], get voyages
// .vessel[li_voyage_counter]) and the other data. 

lds_vas_file = CREATE Datastore
lds_vas_file.Dataobject = "d_vas_file_control"

li_upper_vessels = UpperBound(istr_vas_file_container) 
FOR li_vessel_counter = 1 TO li_upper_vessels
	li_upper_voyages = UpperBound(istr_vas_file_container[li_vessel_counter].vessel)
	FOR li_voyage_counter = 1 TO li_upper_voyages
		ll_row = lds_vas_file.InsertRow(0)
		lds_vas_file.SetItem(ll_row,"vessel",istr_vas_file_container[li_vessel_counter].vessel_ref_nr[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"voyage",istr_vas_file_container[li_vessel_counter].voyage[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"freight",istr_vas_file_container[li_vessel_counter].freight[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"demurrage",istr_vas_file_container[li_vessel_counter].demurrage[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"commission",istr_vas_file_container[li_vessel_counter].commission[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"portexp",istr_vas_file_container[li_vessel_counter].portexp[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"bunkerexp",istr_vas_file_container[li_vessel_counter].bunkerexp[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"miscexp",istr_vas_file_container[li_vessel_counter].miscexp[li_voyage_counter]) 
	NEXT
NEXT

/* Save File as an Excel-file without headerfields */
lds_vas_file.filter()
ll_result = lds_vas_file.SaveAs(ls_file_name, Excel!, TRUE)

/* Inform the user about the file is created */
if isnull(ll_result) or ll_result= -1 then
	st_3.text = "An error occured while saving the file"
else
	st_3.text = "The file was succesfully created!"
end if

/* Hide static text-fields*/ 
st_1.visible 	= false
st_2.visible 	= false
st_2.text 		= ""

/* Destroy user objects and datastores */
destroy(lu_vas_control)
destroy(lds_vas_file)
destroy(lds_vessel_voyages)

/* Set pointer */
setpointer(Arrow!)

Return
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/08/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_generate_supervasfile_control.create
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.st_6=create st_6
this.dw_message=create dw_message
this.hpb_1=create hpb_1
this.em_to_year=create em_to_year
this.st_5=create st_5
this.em_from_year=create em_from_year
this.st_4=create st_4
this.dw_profit_center=create dw_profit_center
this.cb_3=create cb_3
this.cb_2=create cb_2
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_generate=create cb_generate
this.gb_1=create gb_1
this.dw_vas_log=create dw_vas_log
this.Control[]={this.cb_saveas,&
this.cb_print,&
this.st_6,&
this.dw_message,&
this.hpb_1,&
this.em_to_year,&
this.st_5,&
this.em_from_year,&
this.st_4,&
this.dw_profit_center,&
this.cb_3,&
this.cb_2,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_generate,&
this.gb_1,&
this.dw_vas_log}
end on

on w_generate_supervasfile_control.destroy
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.st_6)
destroy(this.dw_message)
destroy(this.hpb_1)
destroy(this.em_to_year)
destroy(this.st_5)
destroy(this.em_from_year)
destroy(this.st_4)
destroy(this.dw_profit_center)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_generate)
destroy(this.gb_1)
destroy(this.dw_vas_log)
end on

event open;dw_profit_center.setTransObject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

em_from_year.text = Right(String(Year(today())),2)
em_to_year.text = Right(String(Year(today())),2)

end event

event close;//IF IsValid(w_vas_reports) THEN close(w_vas_reports)
end event

type cb_saveas from commandbutton within w_generate_supervasfile_control
integer x = 2569
integer y = 8
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_message.saveas()
end event

type cb_print from commandbutton within w_generate_supervasfile_control
integer x = 2094
integer y = 8
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_message.print()
end event

type st_6 from statictext within w_generate_supervasfile_control
integer x = 1527
integer y = 16
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Messages:"
boolean focusrectangle = false
end type

type dw_message from datawindow within w_generate_supervasfile_control
integer x = 1527
integer y = 120
integer width = 2011
integer height = 1600
integer taborder = 60
string title = "none"
string dataobject = "d_ex_tb_vasfile_message"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type hpb_1 from hprogressbar within w_generate_supervasfile_control
integer x = 14
integer y = 268
integer width = 1257
integer height = 84
unsignedinteger maxposition = 100
unsignedinteger position = 1
integer setstep = 10
boolean smoothscroll = true
end type

type em_to_year from editmask within w_generate_supervasfile_control
integer x = 873
integer y = 1460
integer width = 96
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
string mask = "00"
end type

type st_5 from statictext within w_generate_supervasfile_control
integer x = 768
integer y = 1468
integer width = 91
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "to:"
boolean focusrectangle = false
end type

type em_from_year from editmask within w_generate_supervasfile_control
integer x = 631
integer y = 1460
integer width = 96
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
string mask = "00"
end type

type st_4 from statictext within w_generate_supervasfile_control
integer x = 242
integer y = 1468
integer width = 366
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year (yy) from:"
boolean focusrectangle = false
end type

type dw_profit_center from datawindow within w_generate_supervasfile_control
integer x = 274
integer y = 460
integer width = 658
integer height = 880
integer taborder = 10
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(row, not this.isSelected(row))
end if
end event

type cb_3 from commandbutton within w_generate_supervasfile_control
integer x = 818
integer y = 1580
integer width = 334
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_2 from commandbutton within w_generate_supervasfile_control
integer x = 59
integer y = 1580
integer width = 334
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "C&ancel"
boolean cancel = true
end type

event clicked;ib_interrupt = true
end event

type st_3 from statictext within w_generate_supervasfile_control
integer x = 201
integer y = 100
integer width = 805
integer height = 128
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_generate_supervasfile_control
integer x = 699
integer y = 8
integer width = 169
integer height = 76
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
boolean focusrectangle = false
end type

type st_1 from statictext within w_generate_supervasfile_control
boolean visible = false
integer x = 494
integer y = 16
integer width = 169
integer height = 76
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Vessel:"
boolean focusrectangle = false
end type

type cb_generate from commandbutton within w_generate_supervasfile_control
integer x = 421
integer y = 1580
integer width = 370
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate File"
end type

event clicked;/*************************************************************************************
Development Log 
DATE			VERSION 		NAME			DESCRIPTION
-------- 	------- 		----- 		-------------------------------------
19-11-97		5.00			BO				First Release
24/4-98						LN				Changed so there will be one datastore with
												vessel, voyages according to users selection.
												lia_pcnumbers is an array for retrieving ds.
************************************************************************************/
/*Declare local variables*/
Integer lia_pcnumbers[] 
long	ll_counter
Boolean lb_next = TRUE

/* First find out if the are any selected profit center */
for ll_counter = 1 to dw_profit_center.rowCount()
	if dw_profit_center.isSelected(ll_counter) then
		lia_pcnumbers[upperBound(lia_pcnumbers)+1]=dw_profit_center.getItemNumber(ll_counter, "pc_nr")
	end if
next
if upperBound(lia_pcnumbers) = 0 then
	MessageBox("Information", "Please select Profitcenter")
	return
end if

/* Reset VAS log datawindow */
dw_vas_log.reset()

wf_generate_file(lia_pcnumbers)
		

end event

type gb_1 from groupbox within w_generate_supervasfile_control
integer x = 238
integer y = 388
integer width = 736
integer height = 992
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Profitcenter"
end type

type dw_vas_log from datawindow within w_generate_supervasfile_control
boolean visible = false
integer x = 1019
integer y = 460
integer width = 192
integer height = 428
string dataobject = "d_vas_log"
boolean hscrollbar = true
boolean livescroll = true
end type

