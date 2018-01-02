$PBExportHeader$w_generate_supervasfile_table.srw
$PBExportComments$Window containing the functionality for generating VAS data to a table (VAS_FILE_VERSION & VAS_FILE_DATA)
forward
global type w_generate_supervasfile_table from window
end type
type st_1 from statictext within w_generate_supervasfile_table
end type
type dw_versions from datawindow within w_generate_supervasfile_table
end type
type hpb_1 from hprogressbar within w_generate_supervasfile_table
end type
type em_year from editmask within w_generate_supervasfile_table
end type
type st_4 from statictext within w_generate_supervasfile_table
end type
type dw_profit_center from datawindow within w_generate_supervasfile_table
end type
type cb_3 from commandbutton within w_generate_supervasfile_table
end type
type cb_2 from commandbutton within w_generate_supervasfile_table
end type
type st_info from statictext within w_generate_supervasfile_table
end type
type cb_1 from commandbutton within w_generate_supervasfile_table
end type
type gb_1 from groupbox within w_generate_supervasfile_table
end type
type dw_vas_log from datawindow within w_generate_supervasfile_table
end type
end forward

shared variables

end variables

global type w_generate_supervasfile_table from window
integer x = 832
integer y = 360
integer width = 3246
integer height = 1716
boolean titlebar = true
string title = "VAS File Table (Est/Act)"
boolean controlmenu = true
boolean minbox = true
long backcolor = 81324524
st_1 st_1
dw_versions dw_versions
hpb_1 hpb_1
em_year em_year
st_4 st_4
dw_profit_center dw_profit_center
cb_3 cb_3
cb_2 cb_2
st_info st_info
cb_1 cb_1
gb_1 gb_1
dw_vas_log dw_vas_log
end type
global w_generate_supervasfile_table w_generate_supervasfile_table

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
	cb_2.enabled = false
	return true
end if

return false
end function

public function integer wf_first_voyage (integer ai_vessel_nr, string as_voyage_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  		: w_generate_vasfiles
  
 Object     	: wf_first_voyage
  
 Event	 		: 

 Scope     		: Public

 ************************************************************************************

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

public subroutine wf_generate_file (integer profitcenter[]);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_generate_vasfile_TABLE
 Object     	: cb_1
 Event	 		: clicked event
 Scope     		: Public
 ************************************************************************************
 Author    		: Bettina Olsen
 Date       	: 18-11-97
 Description 	: 	This function creates an excel-file containing the defined data from the 
 						voyage accounting system.
						 
						Making the file on the following format:
						Column one contains the vessel number.
						Column two and the next columns:
									- Voyage number
									- Start date
									- End date
									- Off days
									- Charterer
									- Result before drc/tc
									- Bunker expenses
									- Miscellanous expenses
									- Voyage rate in USD

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
23-06-97			5.00			BO				First Release
22-01-97			5.00			BO				Change the filenames from
													mmyy.xls to ddmmyy.xls	
23-01-98			5.00			BO				Change the way we calculate the end date.
02-04-98			5.00			BO				Change the date format from dd/mm/yy to
													dd-mm-yy
03-04-98			5.00			BO				Modified the way we find voyage numbers for a 
													specified vessel and year. Now we use a data
													store instead of calling u_vas_functions.
													a function in u_vas_function 
27-04-06			14.14			REM			Implemented save to DB-table													
************************************************************************************/
/* Declare local variables */
u_vas_control lu_vas_control
n_ds		 	lds_vessel_voyages, lds_vas_file
decimal{2} 	ld_ex_rate[], ld_result, ld_total_days, ld_days
long			ll_count,ll_number_of_voyages, ll_row, ll_file_versionID
string 		ls_year, ls_sqlstring
s_vessel_voyage_list lstr_vessel_voyage_list[]
Integer 		li_key[], li_vessel_index = 1, li_previous_vessel, li_voyage_index = 1, li_this_voyage_type, li_version
Integer 		li_upper_vessels, li_vessel_counter,li_upper_voyages,li_voyage_counter, li_previous_voyage_type, li_year
Boolean 		lb_new_vessel
s_vas_file_container lstr_empty_container[]

/* Create user objects */
lu_vas_control = create u_vas_control

ls_year = em_year.text

//ls_year = Right(String(Year(today())),2)

lds_vessel_voyages 	= create n_ds
lds_vessel_voyages.dataobject ='d_vasfile_vessel_voyage'
lds_vessel_voyages.settransobject(SQLCA)
ll_number_of_voyages = lds_vessel_voyages.retrieve(profitcenter,ls_year, ls_year)

IF NOT(ll_number_of_voyages > 0) THEN 
	MessageBox("Information","There are no voyages for selected profitcenter(s)")
	destroy(lu_vas_control)
	destroy(lds_vessel_voyages)
	return
END IF

cb_2.enabled = true

// Loop through voyages and build data for vas file
// dw_vas_log is used as a dummy parameter for lu_vas_control
istr_vas_file_container = lstr_empty_container /* Reset Container */

hpb_1.maxPosition = ll_number_of_voyages
for ll_count = 1 to ll_number_of_voyages 
	st_info.text = "V"+String(lds_vessel_voyages.GetItemNumber(ll_count,"voyages_vessel_nr")) &
				+" / T"+ lds_vessel_voyages.GetItemString(ll_count,"voyages_voyage_nr")
	hpb_1.position = ll_count			
	if wf_yield() then 
		/* Destroy user objects */
		destroy(lu_vas_control)
		destroy(lds_vessel_voyages)
		return
	end if
	lstr_vessel_voyage_list[1].vessel_nr = lds_vessel_voyages.GetItemNumber(ll_count,"voyages_vessel_nr")
	lstr_vessel_voyage_list[1].voyage_nr = lds_vessel_voyages.GetItemString(ll_count,"voyages_voyage_nr")
	wf_first_voyage(lstr_vessel_voyage_list[1].vessel_nr, lstr_vessel_voyage_list[1].voyage_nr)
	lu_vas_control.of_master_control( 7, li_key[], lstr_vessel_voyage_list[], Integer(ls_year), dw_vas_log)
	IF (lstr_vessel_voyage_list[1].vessel_nr <> li_previous_vessel) AND ll_count <> 1 THEN
		li_vessel_index ++
		li_voyage_index = 1
		lb_new_vessel = TRUE
	ELSE
		lb_new_vessel = FALSE
	END IF
	istr_vas_file_container[li_vessel_index].vessel[li_voyage_index] = lstr_vessel_voyage_list[1].vessel_nr
	istr_vas_file_container[li_vessel_index].voyage[li_voyage_index] = lstr_vessel_voyage_list[1].voyage_nr
	istr_vas_file_container[li_vessel_index].startdate[li_voyage_index] = istr_vas_file.startdate
	istr_vas_file_container[li_vessel_index].enddate[li_voyage_index] = istr_vas_file.enddate

	SELECT VOYAGE_TYPE
	INTO :li_this_voyage_type
	FROM VOYAGES
	WHERE VESSEL_NR = :istr_vas_file_container[li_vessel_index].vessel[li_voyage_index] AND 
			VOYAGE_NR = :istr_vas_file_container[li_vessel_index].voyage[li_voyage_index];
	Commit;
	
	// If there is a previous voyage on same vessel, and the voyage type is TC Out and
	// previous and this voyage type are not equal, we must use another logic for start and end date
	IF NOT(lb_new_vessel) AND ll_count > 1 THEN
	SELECT VOYAGE_TYPE
		INTO :li_previous_voyage_type
		FROM VOYAGES
		WHERE VESSEL_NR = :istr_vas_file_container[li_vessel_index].vessel[li_voyage_index] AND 
				VOYAGE_NR = :istr_vas_file_container[li_vessel_index].voyage[li_voyage_index - 1];
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
//	Messagebox("str_vas_file_container",string(istr_vas_file_container[li_vessel_index].offdays[li_voyage_index]))
//	Messagebox("str_vas_file", string(istr_vas_file.offdays))
	istr_vas_file_container[li_vessel_index].charter[li_voyage_index] = istr_vas_file.charter
	istr_vas_file_container[li_vessel_index].result[li_voyage_index] = istr_vas_file.result
	istr_vas_file_container[li_vessel_index].bunkerexp[li_voyage_index] = istr_vas_file.bunkerexp
	istr_vas_file_container[li_vessel_index].miscexp[li_voyage_index] = istr_vas_file.miscexp
	istr_vas_file_container[li_vessel_index].exrate[li_voyage_index] = istr_vas_file.exrate
	istr_vas_file_container[li_vessel_index].income[li_voyage_index] = istr_vas_file.income
	istr_vas_file_container[li_vessel_index].commission[li_voyage_index] = istr_vas_file.commission
	istr_vas_file_container[li_vessel_index].portexp[li_voyage_index] = istr_vas_file.portexp
	istr_vas_file_container[li_vessel_index].grossincome[li_voyage_index] = istr_vas_file.grossincome
	istr_vas_file_container[li_vessel_index].demurrage[li_voyage_index] = istr_vas_file.demurrage
	istr_vas_file_container[li_vessel_index].freight[li_voyage_index] = istr_vas_file.freight
	istr_vas_file_container[li_vessel_index].tchire[li_voyage_index] = istr_vas_file.tchire

	li_voyage_index ++
	li_previous_vessel = lstr_vessel_voyage_list[1].vessel_nr
	
	// Clear voyage data
	lstr_vessel_voyage_list[1].vessel_nr = 0
	lstr_vessel_voyage_list[1].voyage_nr = ""
   SetNull(istr_vas_file.startdate)
	SetNull(istr_vas_file.enddate) 
	istr_vas_file.offdays = 0
	istr_vas_file.charter = 0
   istr_vas_file.result = 0
	istr_vas_file.bunkerexp = 0
	istr_vas_file.miscexp = 0
   istr_vas_file.exrate = 0
	istr_vas_file.income = 0
	istr_vas_file.commission = 0
	istr_vas_file.portexp = 0
	istr_vas_file.grossincome = 0
   istr_vas_file.demurrage = 0
	istr_vas_file.freight = 0
	istr_vas_file.tchire = 0
next

// Insert data in datastore
// For each vessel istr_vas_file_container[li_vessel_counter], get voyages
// .vessel[li_voyage_counter]) and the other data. 

/* Generete new item in file version id  */
ll_row = dw_versions.insertRow(0)
dw_versions.setItem(ll_row, "pc_nr", profitcenter[1])
dw_versions.setItem(ll_row, "userid", uo_global.is_userid)
SELECT MAX(VERSION_NUMBER) 
	INTO :li_version
	FROM VAS_FILE_VERSION
	WHERE PC_NR = :profitcenter[1] ;
if sqlca.sqlcode = -1 then
	MessageBox("Select Error", "Error reading version number from database")
	rollback;
	return
end if
if isNull(li_version) or sqlca.sqlcode = 100 then
	li_version = 1
else
	li_version ++
end if	
commit;	
dw_versions.setItem(ll_row, "version_number", li_version)
dw_versions.setItem(ll_row, "generated_date", datetime(today(), now()))
if integer(ls_year) < 50 then
	li_year = 2000 + integer(ls_year)
else
	li_year = 1900 + integer(ls_year)
end if	
dw_versions.setItem(ll_row, "voyage_year", li_year)
if dw_versions.update() <> 1 then
	MessageBox("Update Error", "Application failed when updating version data")
	rollback;
	return
end if
ll_file_versionID = dw_versions.getItemNumber(ll_row, "file_version_id")
if isNull(ll_file_versionID) then
	MessageBox("Information", "Application failed when trying to get generation version number")
	rollback;
	return
end if

lds_vas_file = CREATE n_ds
lds_vas_file.Dataobject = "d_vas_file_table_data"
lds_vas_file.setTransObject(SQLCA)

li_upper_vessels = UpperBound(istr_vas_file_container) 
FOR li_vessel_counter = 1 TO li_upper_vessels
	li_upper_voyages = UpperBound(istr_vas_file_container[li_vessel_counter].vessel)
	FOR li_voyage_counter = 1 TO li_upper_voyages
		if istr_vas_file_container[li_vessel_counter].charter[li_voyage_counter] = 0 then continue 
		ll_row = lds_vas_file.InsertRow(0)
		lds_vas_file.SetItem(ll_row,"file_version_id", ll_file_versionID ) 
		lds_vas_file.SetItem(ll_row,"vessel_nr",istr_vas_file_container[li_vessel_counter].vessel[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"voyage_nr",istr_vas_file_container[li_vessel_counter].voyage[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"voyage_start",datetime(istr_vas_file_container[li_vessel_counter].startdate[li_voyage_counter])) 
		lds_vas_file.SetItem(ll_row,"voyage_end",datetime(istr_vas_file_container[li_vessel_counter].enddate[li_voyage_counter])) 
		lds_vas_file.SetItem(ll_row,"chart_nr",istr_vas_file_container[li_vessel_counter].charter[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"freight",ROUND(istr_vas_file_container[li_vessel_counter].freight[li_voyage_counter],0))
		lds_vas_file.SetItem(ll_row,"tchire",ROUND(istr_vas_file_container[li_vessel_counter].tchire[li_voyage_counter],0))
		lds_vas_file.SetItem(ll_row,"demurrage",ROUND(istr_vas_file_container[li_vessel_counter].demurrage[li_voyage_counter],0))
		lds_vas_file.SetItem(ll_row,"broker_commission",ROUND(istr_vas_file_container[li_vessel_counter].commission[li_voyage_counter],0)) 
		lds_vas_file.SetItem(ll_row,"port_expenses",ROUND(istr_vas_file_container[li_vessel_counter].portexp[li_voyage_counter],0)) 
		lds_vas_file.SetItem(ll_row,"bunker_expenses",ROUND(istr_vas_file_container[li_vessel_counter].bunkerexp[li_voyage_counter],0)) 
		if lds_vas_file.GetItemNumber(ll_row,"tchire") <> 0 then
			lds_vas_file.SetItem(ll_row,"misc_expenses",ROUND(istr_vas_file_container[li_vessel_counter].miscexp[li_voyage_counter],0))
		else		
			lds_vas_file.SetItem(ll_row,"misc_expenses",ROUND(istr_vas_file_container[li_vessel_counter].miscexp[li_voyage_counter],0) &
																- ROUND(istr_vas_file_container[li_vessel_counter].portexp[li_voyage_counter],0) &
																- ROUND(istr_vas_file_container[li_vessel_counter].commission[li_voyage_counter],0)) 
		end if
		/* fixes problem where difference = +/- 1 */
		if abs(lds_vas_file.getItemNumber(ll_row,"misc_expenses")) = 1 then lds_vas_file.SetItem(ll_row,"misc_expenses",0)
		lds_vas_file.SetItem(ll_row,"off_service_days",istr_vas_file_container[li_vessel_counter].offdays[li_voyage_counter]) 
		lds_vas_file.SetItem(ll_row,"voyage_ex_rate",istr_vas_file_container[li_vessel_counter].exrate[li_voyage_counter]) 
	NEXT
NEXT

if lds_vas_file.update() <> 1 then
	MessageBox("Update Error", "Application failed when updating VAS file data to table~n~r~n~r" &
										+"SQLCode = "+string(sqlca.sqlcode)+"~n~r" &
										+"ErrText   = " +sqlca.sqlerrtext)
	rollback;
	st_info.text = "Error occured while saving the data!"
	return
end if

ls_sqlstring = "INSERT INTO VAS_FILE_OFFSERVICE ( DATA_ID, "+&
"	START_DATE,  "+&
"	END_DATE,  "+&
"	DAYS,  "+&
"	HOURS,  "+&
"	MINUTES,  "+&
"	DESCRIPTION) "+&
" SELECT VAS_FILE_DATA.DATA_ID,    "+&
"         OFF_SERVICES.OFF_START,    "+&
"         OFF_SERVICES.OFF_END,    "+&
"         OFF_SERVICES.OFF_TIME_DAYS,  "+&  
"         OFF_SERVICES.OFF_TIME_HOURS,    "+&
"         OFF_SERVICES.OFF_TIME_MINUTES,    "+&
"         OFF_SERVICES.OFF_DESCRIPTION   "+&
"    FROM OFF_SERVICES,    "+&
"         VAS_FILE_DATA   "+&
"   WHERE OFF_SERVICES.VESSEL_NR = VAS_FILE_DATA.VESSEL_NR and   "+&
"          OFF_SERVICES.VOYAGE_NR = VAS_FILE_DATA.VOYAGE_NR  and   "+&
"          VAS_FILE_DATA.FILE_VERSION_ID = "+string(ll_file_versionID)

execute immediate :ls_sqlstring;
if sqlca.sqlcode <> 0 then
	MessageBox("Update Error", "Application failed when updating VAS file Off Service table")
	rollback;
	st_info.text = "Error occured while saving the data!"
	return
end if
	
commit;	
dw_versions.post retrieve()
hpb_1.position = 0
st_info.text = "The data was succesfully saved!"

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

on w_generate_supervasfile_table.create
this.st_1=create st_1
this.dw_versions=create dw_versions
this.hpb_1=create hpb_1
this.em_year=create em_year
this.st_4=create st_4
this.dw_profit_center=create dw_profit_center
this.cb_3=create cb_3
this.cb_2=create cb_2
this.st_info=create st_info
this.cb_1=create cb_1
this.gb_1=create gb_1
this.dw_vas_log=create dw_vas_log
this.Control[]={this.st_1,&
this.dw_versions,&
this.hpb_1,&
this.em_year,&
this.st_4,&
this.dw_profit_center,&
this.cb_3,&
this.cb_2,&
this.st_info,&
this.cb_1,&
this.gb_1,&
this.dw_vas_log}
end on

on w_generate_supervasfile_table.destroy
destroy(this.st_1)
destroy(this.dw_versions)
destroy(this.hpb_1)
destroy(this.em_year)
destroy(this.st_4)
destroy(this.dw_profit_center)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.st_info)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.dw_vas_log)
end on

event open;dw_profit_center.setTransObject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)
dw_versions.setTransObject(SQLCA)
dw_versions.POST retrieve()

em_year.text = Right(String(Year(today())),2)
end event

event close;//IF IsValid(w_vas_reports) THEN close(w_vas_reports)
end event

type st_1 from statictext within w_generate_supervasfile_table
integer x = 251
integer y = 1368
integer width = 2290
integer height = 200
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Not Converted to Alphanumeric vessel numbers !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
boolean focusrectangle = false
end type

type dw_versions from datawindow within w_generate_supervasfile_table
integer x = 1285
integer y = 48
integer width = 1893
integer height = 1192
integer taborder = 10
string title = "none"
string dataobject = "d_vas_file_table_version"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type hpb_1 from hprogressbar within w_generate_supervasfile_table
integer x = 96
integer y = 184
integer width = 1038
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type em_year from editmask within w_generate_supervasfile_table
integer x = 677
integer y = 1040
integer width = 96
integer height = 72
integer taborder = 60
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

type st_4 from statictext within w_generate_supervasfile_table
integer x = 434
integer y = 1044
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

type dw_profit_center from datawindow within w_generate_supervasfile_table
integer x = 274
integer y = 364
integer width = 658
integer height = 612
integer taborder = 20
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	this.selectrow(0, false)
	this.selectrow(row, true)
end if
end event

type cb_3 from commandbutton within w_generate_supervasfile_table
integer x = 818
integer y = 1148
integer width = 334
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_2 from commandbutton within w_generate_supervasfile_table
integer x = 59
integer y = 1148
integer width = 334
integer height = 92
integer taborder = 50
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

type st_info from statictext within w_generate_supervasfile_table
integer x = 96
integer y = 48
integer width = 1038
integer height = 76
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_generate_supervasfile_table
integer x = 421
integer y = 1148
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

event clicked;/*Declare local variables*/
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

type gb_1 from groupbox within w_generate_supervasfile_table
integer x = 238
integer y = 292
integer width = 736
integer height = 716
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Profitcenter"
end type

type dw_vas_log from datawindow within w_generate_supervasfile_table
boolean visible = false
integer x = 9
integer y = 348
integer width = 142
integer height = 140
string dataobject = "d_vas_log"
boolean hscrollbar = true
boolean livescroll = true
end type

