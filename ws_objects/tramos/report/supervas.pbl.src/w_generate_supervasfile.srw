$PBExportHeader$w_generate_supervasfile.srw
$PBExportComments$Window containing the functionality for generating super vasfiles.
forward
global type w_generate_supervasfile from window
end type
type hpb_1 from hprogressbar within w_generate_supervasfile
end type
type em_year from editmask within w_generate_supervasfile
end type
type st_4 from statictext within w_generate_supervasfile
end type
type cb_3 from commandbutton within w_generate_supervasfile
end type
type cb_2 from commandbutton within w_generate_supervasfile
end type
type st_3 from statictext within w_generate_supervasfile
end type
type st_2 from statictext within w_generate_supervasfile
end type
type st_1 from statictext within w_generate_supervasfile
end type
type cb_generate from commandbutton within w_generate_supervasfile
end type
type dw_vas_log from datawindow within w_generate_supervasfile
end type
type dw_profit_center from datawindow within w_generate_supervasfile
end type
type gb_1 from groupbox within w_generate_supervasfile
end type
end forward

shared variables

end variables

global type w_generate_supervasfile from window
integer x = 832
integer y = 360
integer width = 1216
integer height = 1864
boolean titlebar = true
string title = "VAS File (Est/Act)"
boolean controlmenu = true
boolean minbox = true
long backcolor = 81324524
boolean center = true
hpb_1 hpb_1
em_year em_year
st_4 st_4
cb_3 cb_3
cb_2 cb_2
st_3 st_3
st_2 st_2
st_1 st_1
cb_generate cb_generate
dw_vas_log dw_vas_log
dw_profit_center dw_profit_center
gb_1 gb_1
end type
global w_generate_supervasfile w_generate_supervasfile

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
string 		ls_year, ls_file_name
s_vessel_voyage_list lstr_vessel_voyage_list[]
Integer li_key[], li_vessel_index = 1, li_previous_vessel, li_voyage_index = 1, li_this_voyage_type
Integer li_upper_vessels, li_vessel_counter,li_upper_voyages,li_voyage_counter, li_previous_voyage_type
string notinuse
s_vas_file_container lstr_empty_container[]

/* Get Filename and Save File as an Excel-file without headerfields */
ls_file_name = "VASfile"+string(today(),"ddmmyy") 
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

ls_year = em_year.text
//ls_year = Right(String(Year(today())),2)

lds_vessel_voyages 	= create datastore
lds_vessel_voyages.dataobject ='d_vasfile_vessel_voyage'
lds_vessel_voyages.settransobject(SQLCA)
ll_number_of_voyages = lds_vessel_voyages.retrieve(profitcenter,ls_year, ls_year)

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

/* Set pointer */
setpointer(Hourglass!)

// Loop through voyages and build data for vas file
// dw_vas_log is used as a dummy parameter for lu_vas_control
istr_vas_file_container = lstr_empty_container /* reset container */

hpb_1.maxposition = ll_number_of_voyages
for ll_count = 1 to ll_number_of_voyages 
	st_2.text = lds_vessel_voyages.GetItemString(ll_count,"vessel_ref_nr")
	st_3.text = "Voyage (Get Data) : " + lds_vessel_voyages.GetItemString(ll_count,"voyages_voyage_nr")
	hpb_1.position = ll_count
	if wf_yield() then 
		/* Destroy user objects */
		destroy(lu_vas_control)
		destroy(lds_vessel_voyages)
		return
	end if
	lstr_vessel_voyage_list[1].vessel_nr 		= lds_vessel_voyages.GetItemNumber(ll_count,"voyages_vessel_nr")
	lstr_vessel_voyage_list[1].vessel_ref_nr 	= lds_vessel_voyages.GetItemString(ll_count,"vessel_ref_nr")
	lstr_vessel_voyage_list[1].voyage_nr 		= lds_vessel_voyages.GetItemString(ll_count,"voyages_voyage_nr")
	//wf_first_voyage(lstr_vessel_voyage_list[1].vessel_nr, lstr_vessel_voyage_list[1].voyage_nr)
	lu_vas_control.of_master_control( 7,li_key[], lstr_vessel_voyage_list[], Integer(ls_year), dw_vas_log)
	IF (lstr_vessel_voyage_list[1].vessel_nr <> li_previous_vessel) AND ll_count <> 1 THEN
		li_vessel_index ++
		li_voyage_index = 1
		lb_new_vessel = TRUE
	ELSE
		lb_new_vessel = FALSE
	END IF
	istr_vas_file_container[li_vessel_index].vessel[li_voyage_index] 			= lstr_vessel_voyage_list[1].vessel_nr
	istr_vas_file_container[li_vessel_index].vessel_ref_nr[li_voyage_index] = lstr_vessel_voyage_list[1].vessel_ref_nr
	istr_vas_file_container[li_vessel_index].voyage[li_voyage_index] 			= lstr_vessel_voyage_list[1].voyage_nr
	istr_vas_file_container[li_vessel_index].startdate[li_voyage_index] 		= istr_vas_file.startdate
	istr_vas_file_container[li_vessel_index].enddate[li_voyage_index] 		= istr_vas_file.enddate
	// If there is a previous voyage on same vessel, and the voyage type is TC Out and
	// previous and this voyage type are not equal, we must use another logic for start and end date
	SELECT VOYAGE_TYPE
	INTO :li_this_voyage_type
	FROM VOYAGES
	WHERE VESSEL_NR = :istr_vas_file_container[li_vessel_index].vessel[li_voyage_index] AND 
			Substring(VOYAGE_NR,1,5) = :istr_vas_file_container[li_vessel_index].voyage[li_voyage_index];
	Commit;

	IF NOT(lb_new_vessel) AND ll_count > 1 THEN
		SELECT VOYAGE_TYPE
		INTO :li_previous_voyage_type
		FROM VOYAGES
		WHERE VESSEL_NR = :istr_vas_file_container[li_vessel_index].vessel[li_voyage_index] AND 
				Substring(VOYAGE_NR,1,5) = :istr_vas_file_container[li_vessel_index].voyage[li_voyage_index - 1];
		Commit;		
		IF li_this_voyage_type <> li_previous_voyage_type THEN
			IF li_this_voyage_type = 2 THEN
				//Handle start and end date when TC Out follows a normal voyage.	
				// In this case the previous voyage enddate must be changed to be 
				// the day before this TC Out voyage start date
				istr_vas_file_container[li_vessel_index].enddate[li_voyage_index - 1] = &
				RelativeDate(istr_vas_file.startdate, -1)
			ELSEIF li_previous_voyage_type = 2 THEN
				//Handle start and end date when a normal voyage follows a TC Out voyage.
				// In this case the single voyage start date must be one day after the previous 
				// TC Out voyage departure date for the RED purpose port in POC IF ANY.
				// In no RED, then the startdate must be one day after redelivery for the contract
				// This rule is used when determing the TC end date.
				istr_vas_file_container[li_vessel_index].startdate[li_voyage_index] = &
				RelativeDate(istr_vas_file_container[li_vessel_index].enddate[li_voyage_index - 1], 1)
			END IF
		END IF
	END IF
	istr_vas_file_container[li_vessel_index].offdays[li_voyage_index] = istr_vas_file.offdays
	istr_vas_file_container[li_vessel_index].charter[li_voyage_index] = istr_vas_file.charter
	istr_vas_file_container[li_vessel_index].result[li_voyage_index] = istr_vas_file.result
	istr_vas_file_container[li_vessel_index].bunkerexp[li_voyage_index] = istr_vas_file.bunkerexp
	istr_vas_file_container[li_vessel_index].miscexp[li_voyage_index] = istr_vas_file.miscexp 
	IF li_this_voyage_type = 2 THEN istr_vas_file_container[li_vessel_index].miscexp[li_voyage_index] += istr_vas_file.commission
	istr_vas_file_container[li_vessel_index].exrate[li_voyage_index] = istr_vas_file.exrate
		
	li_voyage_index ++
	li_previous_vessel = lstr_vessel_voyage_list[1].vessel_nr
	
	// Clear voyage data
	lstr_vessel_voyage_list[1].vessel_nr = 0
	lstr_vessel_voyage_list[1].vessel_ref_nr = ""
	lstr_vessel_voyage_list[1].voyage_nr = ""
   SetNull(istr_vas_file.startdate)
	SetNull(istr_vas_file.enddate) 
	istr_vas_file.offdays = 0
	istr_vas_file.charter = 0
   istr_vas_file.result = 0
	istr_vas_file.bunkerexp = 0
	istr_vas_file.miscexp = 0
   istr_vas_file.exrate = 0
next

// Insert data in datastore
// For each vessel istr_vas_file_container[li_vessel_counter], get voyages
// .vessel[li_voyage_counter]) and the other data. 

lds_vas_file = CREATE Datastore
lds_vas_file.Dataobject = "d_vas_file"


li_upper_vessels = UpperBound(istr_vas_file_container) 
FOR li_vessel_counter = 1 TO li_upper_vessels
	li_upper_voyages = UpperBound(istr_vas_file_container[li_vessel_counter].vessel)
	FOR li_voyage_counter = 1 TO li_upper_voyages
		ll_row = lds_vas_file.InsertRow(0)
		lds_vas_file.SetItem(ll_row,"vessel",istr_vas_file_container[li_vessel_counter].vessel_ref_nr[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"voyage",istr_vas_file_container[li_vessel_counter].voyage[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"startdate",String(istr_vas_file_container[li_vessel_counter].startdate[li_voyage_counter],"dd-mm-yy")) 
		lds_vas_file.SetItem(ll_row,"enddate",String(istr_vas_file_container[li_vessel_counter].enddate[li_voyage_counter],"dd-mm-yy")) 
		lds_vas_file.SetItem(ll_row,"offdays",istr_vas_file_container[li_vessel_counter].offdays[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"charter",istr_vas_file_container[li_vessel_counter].charter[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"result",istr_vas_file_container[li_vessel_counter].result[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"bunkerexp",istr_vas_file_container[li_vessel_counter].bunkerexp[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"miscexp",istr_vas_file_container[li_vessel_counter].miscexp[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"exrate",istr_vas_file_container[li_vessel_counter].exrate[li_voyage_counter]) 
	NEXT
NEXT


/* Save File as an Excel-file without headerfields */
ll_result = lds_vas_file.SaveAs(ls_file_name, Excel!, FALSE)

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

on w_generate_supervasfile.create
this.hpb_1=create hpb_1
this.em_year=create em_year
this.st_4=create st_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_generate=create cb_generate
this.dw_vas_log=create dw_vas_log
this.dw_profit_center=create dw_profit_center
this.gb_1=create gb_1
this.Control[]={this.hpb_1,&
this.em_year,&
this.st_4,&
this.cb_3,&
this.cb_2,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_generate,&
this.dw_vas_log,&
this.dw_profit_center,&
this.gb_1}
end on

on w_generate_supervasfile.destroy
destroy(this.hpb_1)
destroy(this.em_year)
destroy(this.st_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_generate)
destroy(this.dw_vas_log)
destroy(this.dw_profit_center)
destroy(this.gb_1)
end on

event open;dw_profit_center.setTransObject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

em_year.text = Right(String(Year(today())),2)
end event

event close;//IF IsValid(w_vas_reports) THEN close(w_vas_reports)
end event

type hpb_1 from hprogressbar within w_generate_supervasfile
integer x = 14
integer y = 184
integer width = 1179
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type em_year from editmask within w_generate_supervasfile
integer x = 681
integer y = 1524
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
string text = "none"
alignment alignment = right!
maskdatatype maskdatatype = datemask!
string mask = "yy"
end type

type st_4 from statictext within w_generate_supervasfile
integer x = 443
integer y = 1528
integer width = 238
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year (yy):"
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_generate_supervasfile
integer x = 832
integer y = 1640
integer width = 311
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

type cb_2 from commandbutton within w_generate_supervasfile
integer x = 82
integer y = 1640
integer width = 311
integer height = 92
integer taborder = 40
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

type st_3 from statictext within w_generate_supervasfile
integer x = 201
integer y = 64
integer width = 805
integer height = 96
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

type st_2 from statictext within w_generate_supervasfile
integer x = 640
integer width = 169
integer height = 68
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
boolean focusrectangle = false
end type

type st_1 from statictext within w_generate_supervasfile
boolean visible = false
integer x = 434
integer width = 169
integer height = 68
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

type cb_generate from commandbutton within w_generate_supervasfile
integer x = 430
integer y = 1640
integer width = 370
integer height = 92
integer taborder = 30
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

type dw_vas_log from datawindow within w_generate_supervasfile
boolean visible = false
integer x = 41
integer y = 1516
integer width = 279
integer height = 116
string dataobject = "d_vas_log"
boolean hscrollbar = true
boolean livescroll = true
end type

type dw_profit_center from datawindow within w_generate_supervasfile
integer x = 274
integer y = 360
integer width = 658
integer height = 1064
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

type gb_1 from groupbox within w_generate_supervasfile
integer x = 238
integer y = 288
integer width = 736
integer height = 1168
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Profitcenter"
end type

