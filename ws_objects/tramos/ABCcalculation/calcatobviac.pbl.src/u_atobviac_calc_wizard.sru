$PBExportHeader$u_atobviac_calc_wizard.sru
$PBExportComments$Wizard subobject - used by u_calculation
forward
global type u_atobviac_calc_wizard from u_atobviac_calc_base_sqlca
end type
type dw_wizard from uo_datawindow within u_atobviac_calc_wizard
end type
type dw_calc_via_dddw from u_datawindow_sqlca within u_atobviac_calc_wizard
end type
type dw_ballasted_speed from u_datawindow_sqlca within u_atobviac_calc_wizard
end type
type dw_laden_speed from u_datawindow_sqlca within u_atobviac_calc_wizard
end type
type gb_1 from groupbox within u_atobviac_calc_wizard
end type
type s_fixup from structure within u_atobviac_calc_wizard
end type
type s_cargodata from structure within u_atobviac_calc_wizard
end type
end forward

type s_fixup from structure
    string s_dw_name
    string s_dw_column
    integer i_dw_type
    integer i_rowno
    integer i_cargono
    u_dddw_search uo_search
    string s_default_value
end type

type s_cargodata from structure
    integer i_loadports
    integer i_dischports
    integer i_laytype
    integer i_laytype_load
    integer i_laytype_disch
    double d_laytime
    double d_laytime_load
    double d_laytime_disch
    double d_laytime_calculated_load
    double d_laytime_calculated_disch
    double d_quantity
    double d_load_quantity
    double d_disch_quantity
    double d_quantity_diff
    double d_despatch
    double d_demurrage
    long l_layterm
    long l_layterm_load
    long l_layterm_disch
end type

global type u_atobviac_calc_wizard from u_atobviac_calc_base_sqlca
integer width = 4603
integer height = 2404
event ue_fixup pbm_custom59
event ue_keydown pbm_dwnkey
event ue_load_vesseldata pbm_custom60
event ue_setfocus pbm_custom38
dw_wizard dw_wizard
dw_calc_via_dddw dw_calc_via_dddw
dw_ballasted_speed dw_ballasted_speed
dw_laden_speed dw_laden_speed
gb_1 gb_1
end type
global u_atobviac_calc_wizard u_atobviac_calc_wizard

type variables
//s_fixup istr_fixup[] ** ændret ved konvertering til PB10
private s_fixup istr_fixup[]  // Fixup array linking the wizard and calculation datawindows
integer ii_fixup_size // no. entries in the fixup array

integer ii_no_loadports, ii_no_dischports // no of load and dischports for each cargo on the wizard
Integer ii_used_loadports, ii_used_dischports // actually used no. of load and dischports

integer ii_set_itinerary
String ls_test
Boolean ib_active  // Boolean if the wizard page is active
Boolean ib_update_speeds // true if speedlist needs to be updated
Boolean  ib_multicargo // true if this is a multicargo wizard
end variables

forward prototypes
public function boolean uf_load_wizard (string as_name)
public function integer uf_deactivate ()
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public subroutine uf_activate ()
private function string uf_create_columnname (string as_dw_name, string as_column_name, integer ai_cargono, integer ai_rowno)
private subroutine uf_itinerary_clicked (boolean ab_rightclicked)
private subroutine uf_split_columnname (string as_data, ref s_fixup as_fixup)
public subroutine uf_load_vesseldata ()
end prototypes

event ue_fixup;call super::ue_fixup;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 7-10-96

 Description : Wizard fixup - creates link between wizard and normal 
 					calculation windows.

 This is how the wizard works:

 Upon creation of a new calculation, the user can select <standard calculation>, or 
 one of the wizards. The Wizard window is one datawindow with lesser fields then 
 the normal (standard) 4 calculation windows. 
 
 The wizards is stored in the Wizard.pbl, and consists only of datawindows. All 
 other logic and code is put together in this object (u_calc_wizard). At runtime, 
 the wizard code creates the link between the wizard window and the normal 
 calculation windows. So, when the user selects "calculation" or any other 
 process-buttons in the calculation, all wizard data is quickly transferred from the 
 wizard window to the normal calculation windows (which - by this time are hidden).

 From this point, the "usual" calculation processes works as normal on the (still 
 hidden) windows. The user can at any time drop the wizard, and return to the 
 normal windows.

 Loading the wizards

 The powerbuilder function LibraryDirectory can return all entrys within a PBL 
 library. This is usefull, since we have not possibilty to create a PBD runtime 
 (this can only be done by using powerbuilder). In the constructor event, the 
 Wizard.pbl file is searched for entrys, enabling the possibillity for 
 dynamics change of wizard datawindows (addition, modification and deletion).

 The fixup & deactivation:

 The fixup and deactivation are the two main processes done by the wizard. Fixup 
 happens during creation of the wizard window, and builds a fixup table with refereces 
 between each Wizard-column and the corresponding column on the calculation windows. 
 The index in the fixup table equals the fieldnumber on the Wizard datawindow.
 The fixup table consists of the following information:

 s_dw_name  : name of the normal datawindow, where 

 				  DWS = calc_summary, 
				  DWC = cargo summary
				  DWL = calc_loadports 
				  DWD = calc_dischports
				  DWB = calc_ballastports
				  
 s_dw_column: name of the column - eg. "port_code" or "CAL_CALC_ADD_EXPENSES"
 i_dw_type  : Column type, where 
 
 				  1 = char
				  2 = date
				  3 = datetime
				  4 = decimal
				  5 = number
				  6 = time
				  
  i_row_no  : normal rownumber
  uo_search : Object for drop-down search-as-you-type columns

  But where does all this information come from ? The Wizard datawindow of course. 
  Each column in the Wizard window has to follow a specific naming guideline, 
  that on the same time identifies the connection between the wizard columns and 
  the columns in the calculation datawindows.

  The naming rule is as this: [datawindowcode][rownumber]_[columnname]

  So, if we want to create a wizard column, that corresponds to the column 
  "vessel_name" in the calc_summary window, row 1, the name must be "dws1_vessel_name". 
  If the column should correspond to row 2 instead, the name must be 
  "dws2_vessel_name". The Wizard automaticly supports insertion and deletion of rows, 
  when columns are left with null value, that is, if "dwl2_port_code" (port_code column 
  in row 2 of the calc_loadports datawindow) is NULL no second row wil be inserted. 

  Other examples:
  Wizard fieldname:          		Corrosponds to:                      
  dwc1_cal_carg_adr_commision		CAL_CARG_ADR_COMMISSION on row 1 of the Cargo summary datawindow
  dws1_cal_calc_ballast_from		CAL_CALC_BALLAST_FROM on row 1 of the Calculation summary datawindow
  dwl1_cal_caio_expenses			CAL_CAIO_EXPENSES on row 1 of the loadports datawindow
  dwl2_cal_caio_expenses			CAL_CAIO_EXPENSES on row 2 of the dischports datawindow
  
  The deactivation event happes whenever the users does something, that requires 
  transfer from the wizard to the normal window (calculate, print etc.). In this event, 
  each entry in the fixup table is copied from the wizard to the calculation window:

  For COUNT = 1 To Upperbound(Fixup) 
  		dw_datawindowcode.SetItem(fixup[COUNT].rownumber, fixup[COUNT].columnname, 
	  									dw_wizard.GetItem(1, count))
  NEXT

  Gotcha !

  So, what's the point with all this ? Easy creation and less or even none maintence. 
  NO coding is requiered upon creation of a new wizard window - and - whats even more 
  interesting - this system opens up for user-creation of wizard-windows, since no 
  compilation are required. It could actually be possible to create a "Wizard maintence"
  module in the system, that gives the user ability to create, modify or delete wizard 
  (data)windows - again without ever touching powerbuilder, and compiling the program.

 IMPORTANT NOTICE: Whenever a port column is specified, VIA_POINT_1, ITINERARY and 
 						 PORT_EXPENSES fields must also be declared for that line.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-12-96		3.1			MI		Added support for ballast expenses + viapoints  
08-01-97		4.0			MI		Added <non> as dw identifier for read-only calcule data
************************************************************************************/

Integer li_count, li_tmp
Long ll_tmp
String ls_name, ls_tmp, ls_wname
DataWindowChild dwc_tmp
DataWindow ldw
String ls_null

// Turn redraw off
This.uf_redraw_off()

// Set the transaction object for the wizard datawindow, and retrieve data to the
// dropdown datawindow
dw_wizard.SetTransObject(SQLCA)
dw_calc_via_dddw.Retrieve()
COMMIT;

// Get number of fields in the wizard datawindow
ii_fixup_size = Long(dw_wizard.Describe("datawindow.column.count"))

// And loop through all fields to build the istr_fixup array, that is
// used during deactivation (moving data from the wizard to the normal
// calculation datawindows). The istr_fixup array contains all information
// needed for coping the data.
For li_count = 1 To ii_fixup_size

	// Convert from Wizard-dw columncode to datawindow name
	ls_wname = "#"+String(li_count)
	ls_name = dw_wizard.describe(ls_wname+".name")

	// Split field name returned from the datawindow into the istr_fixup array
	uf_split_columnname(ls_name, istr_fixup[li_count])

	// Set multicargo to true, if cargono in the fieldname is > 0
	If istr_fixup[li_count].i_cargono > 0 Then ib_multicargo = true

	// Get Column type
	ls_tmp = dw_wizard.describe(ls_wname+".coltype")
	li_tmp = Pos(ls_tmp,"(")
	If li_tmp > 0 Then ls_tmp = Left(ls_tmp, li_tmp -1) // Remove ( )

	// Convert datatype as text to nummeric type and store it to the fixup array
	CHOOSE CASE ls_tmp
		CASE "char"
			li_tmp = 1
		CASE "date"
			li_tmp = 2
		CASE "datetime"
			li_tmp = 3
		CASE "decimal"
			li_tmp = 4
		CASE "number"
			li_tmp = 5
		CASE "time"
			li_tmp = 6
		CASE ELSE
	END CHOOSE
	
	istr_fixup[li_count].i_dw_type = li_tmp		

	// Get type of datawindow from the datawindow name, and store it in ldw_tmp for
	// easier access in the rest of the code
	CHOOSE CASE istr_fixup[li_count].s_dw_name
		CASE "dws" // Datawindw calc summary
			ldw = iuo_calc_nvo.iuo_calc_summary.dw_calc_summary
		CASE "dwc" // Datawindow cargo summary
			ldw = iuo_calc_nvo.iuo_calc_cargos.dw_cargo_summary
		CASE "dwl" // Datawindow load 
			ldw = iuo_calc_nvo.iuo_calc_cargos.dw_loadports
		CASE "dwd" // Datawindow disch
			ldw = iuo_calc_nvo.iuo_calc_cargos.dw_dischports
		CASE "dwb" // Datawindow ballast
			ldw = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
		CASE "non"
		CASE ELSE
			// Show error message if datawindow is not known to the system
			Messagebox("Wizard error", "Unknown datawindow ("+istr_fixup[li_count].s_dw_name+")")
			istr_fixup[li_count].s_dw_name = ""
			Continue
	END CHOOSE

	// Do special processing there might be needed for the field, eg. setting up
	// a search-as-you-type object, getting default values etc.
	CHOOSE CASE istr_fixup[li_count].s_dw_column 

		CASE "rate", "quantity", "laytime", "laytime_load", "laytime_disch", "ratetype", "itinerary", &
			"laytime_calculated_load", "laytime_calculated_disch", "despatch", "demurrage"
			// Ok, Do nothing - those fields are handled specially

		CASE "layterm", "layterm_load", "layterm_disch"
			// Share these fields with the layterm field in calculation.
			dw_wizard.GetChild(ls_name, dwc_tmp)
			If iuo_calc_nvo.iuo_calculation.dw_shared_terms.ShareData(dwc_tmp) <> 1 Then &
				MessageBox("System error", "Error sharing shared terms")

			// Set min. ID as default value in this field
			SELECT MIN(CAL_RATY_ID)
			INTO :ll_tmp
			FROM CAL_RATY;
			COMMIT;

			dw_wizard.SetItem(1, li_count, ll_tmp)

		CASE "cal_carg_freight_type"
			// Set freight type values to the same as in the calculation window
			dw_wizard.modify(ls_wname+".values = '"+ ldw.describe("cal_carg_freight_type.values")+"'")

		CASE "laytype", "laytype_load", "laytype_disch"
			// Set laytype values to the same as in the calculation window
			dw_wizard.modify(ls_wname+".values = '"+ iuo_calc_nvo.iuo_calc_cargos.dw_loadports.describe("cal_caio_load_terms.values")+"'")

		CASE ELSE
			// Processing not handled yet. Check if datawindow name is "non"
			If istr_fixup[li_count].s_dw_name<>"non" Then
				
				// Validate that the field really exists in the calculation datawindow, by calling
				// describe on the field. If the field doesn't exists, PB will return ! as 
				// result value.
				ls_tmp = ldw.describe(istr_fixup[li_count].s_dw_column+".name")
				If ls_tmp = "!" Then
					MessageBox("Wizard column error", "Illegal column "+istr_fixup[li_count].s_dw_column+"~r~n~r~n"+ls_name)		
				
					// Clear this field, so we won't get errors during deactivation
					istr_fixup[li_count].s_dw_name = ""	
					Continue
				End if
			End if
	END CHOOSE

	// Set the search object to null for this fixup entry
	SetNull(istr_fixup[li_count].uo_search)

	// Check to see if a search-as-you-type dddw needed for this field. We do that
	// by checking the name, if "port_code" or "_ballast_" (port) exists in the name
	// it's a port field, and do require a search as you type object.
	If (pos(istr_fixup[li_count].s_dw_column, "port_code") > 0 ) Or &
	   (pos(istr_fixup[li_count].s_dw_column, "_ballast_") > 0) Then
		
		// Create the search object
		istr_fixup[li_count].uo_search = CREATE u_dddw_search
		// Let the search object point to your field in the wizard datawindow
		istr_fixup[li_count].uo_search.uf_setup(dw_wizard, ls_name, "port_n", true)

		// And share the datawindow child to hidden dw_calc_port_ddw on the w_share window
		dw_wizard.GetChild(ls_name, dwc_tmp)
		If uf_sharechild("dw_calc_port_dddw", dwc_tmp)<>1 Then MessageBox("Name", istr_fixup[li_count].s_dw_column)

		// Count number of all load and disch port entries in the wizard. This in only done if
		// cargono if below 2, so we only count for the first cargo. 
		if (istr_fixup[li_count].s_dw_column="port_code") and (istr_fixup[li_count].i_cargono<2) Then
			CHOOSE CASE istr_fixup[li_count].s_dw_name
				CASE "dwl" 
					ii_no_loadports ++
				CASE "dwd"
					ii_no_dischports ++
			END CHOOSE
		End if
	Elseif Pos(istr_fixup[li_count].s_dw_column,"via_point") > 0 Then
		// Viapoints should be shared to the dw_calc_via_dddw datawindow, that contains
		// all viapoints.
		dw_wizard.GetChild(ls_name, dwc_tmp)
		If dw_calc_via_dddw.ShareData(dwc_tmp) <> 1 Then MessageBox("System Error", "Error sharing via points") 
	Elseif Pos(istr_fixup[li_count].s_dw_column, "_speed") > 0 Then
		// and speed lists should be shared to the dw_ballast_speed or dw_laden_speed 
		// datawindows, that contains the speed lists.
		dw_wizard.GetChild(ls_name, dwc_tmp)

		If istr_fixup[li_count].s_dw_name = "dwb" Then
			// Ballast speedlist must be shared to the dw_ballast_speed datawindow,
			If dw_ballasted_speed.ShareData(dwc_tmp) <> 1 Then MessageBox("System Error", "Error sharing ballasted speeds")
		Else
			// while all others must be shared to the dw_laden_speed datawindow.
			If dw_laden_speed.ShareData(dwc_tmp) <> 1 Then MessageBox("System Error", "Error sharing laden speeds")
		End if

		// Signal that we need to update the speedlists this will trigger an ue_load_vesseldata
		// later in the code.
		ib_update_speeds = true
	End if
Next

// Normally, the wizard will contain one row of data, that is set to 0 or other default 
// values. In case there is no data in the wizard datawindow, we'll add one row here
If dw_wizard.RowCount()=0 Then

	SetNull(ls_null)

	// Insert a new row in the wizard
	dw_wizard.ScrollToRow(dw_wizard.InsertRow(0))

	// Loop through all fields, and insert default value, unless a default value
	// is given in the istr_fixup array
	For li_count = 1 To ii_fixup_size 
		If istr_fixup[li_count].s_default_value<>"" Then
			// A default value is given, insert this value into the field,
			// either as a string or nummeric value. Only datatypes 1, 4 and 5
			// is currently supported for default values.
			
			CHOOSE CASE istr_fixup[li_count].i_dw_type
				CASE 1
					dw_wizard.SetItem(1, li_count, istr_fixup[li_count].s_default_value)
				CASE 4
					dw_wizard.SetItem(1, li_count, Double(istr_fixup[li_count].s_default_value))
				CASE 5
					dw_wizard.SetItem(1, li_count, Double(istr_fixup[li_count].s_default_value))
			END CHOOSE
		Else
			// Default value is not given, set field to 0 or null, depending on type.
			
			CHOOSE CASE istr_fixup[li_count].s_dw_column
				CASE "cal_carg_freight_type"
					// Special handling for freight type, this should be set to 1.
					dw_wizard.SetItem(1, li_count, 1)
				CASE "cal_carg_description"
					// Special handling for description, this should be set to <New cargo #>
					dw_wizard.Setitem(1, li_count, "<New cargo "+String(istr_fixup[li_count].i_cargono)+">")
				CASE ELSE
					// Otherwise set to 0 or null, depending on type
					CHOOSE CASE istr_fixup[li_count].i_dw_type
						CASE 1
							dw_wizard.SetItem(1,li_count,ls_null)
						CASE 2
						CASE 3
						CASE 4
							dw_wizard.SetItem(1,li_count,0);
						CASE 5
							dw_wizard.SetItem(1,li_count,0);
						CASE 6
					END CHOOSE
			END CHOOSE
		End if
	Next
End if

// If dropdown speedlists is used on this wizard, then request load of speedlist
If ib_update_speeds Then PostEvent("ue_load_vesseldata") 

// We're done, Turn screen updates back on
This.uf_redraw_on()

end event

event ue_load_vesseldata;call super::ue_load_vesseldata;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Triggers an ue_load_speedlist event to parent and Calls 
 					on to uf_load_vesseldata. The UE_LOAD_SPEEDLIST will get make
					the calculation module retrieve the vessel data, and UF_LOAD_SPEEDLIST
					will move this data to the wizard

 Arguments : None
 
 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Parent.TriggerEvent("ue_load_speedlist")
uf_load_vesseldata()

end event

public function boolean uf_load_wizard (string as_name);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Loads the wizard given in argument as_name from the wizard.pbl

 Arguments : as_name as string

 Returns   : True if ok  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Check to see if dw_wizard is valid. This is due to an error (probably in PB4, 
// not sure if it exists in PB5+. WIll give an error if the dw_wizard is not valid
If Not IsValid(dw_wizard) Then MessageBox("Error", "dw_wizard er NOT VALID "+ls_test)

// Set seleted name as DataObject (datawindow)

// Set dataobject and transactionobject
dw_wizard.DataObject = as_name
dw_wizard.SetTransObject(SQLCA)

// Break if any errors
If dw_wizard.DataObject <> as_name Then
	MessageBox("Error", "Error loading wizard window "+as_name)
	Return(false)
End if

// Post the ue_fixup event
PostEvent("ue_fixup")

// And set this page to active
ib_active = true
uf_activate()

Return(true)
end function

public function integer uf_deactivate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 25-10-96

 Description : Deactivates the wizard. By deactivation, all information is 
 transferred to the "real" calculation fields, so that the rest of the system can 
 work with the data. In an error occures during deactivation, the transfer is aborted 
 and an errormessage is shown.

 This rutine also handles itinerary order, just in that case that the user havn't 
 chosen a rute.

 Arguments : None

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE      VERSION     NAME     DESCRIPTION
--------  -------     ------   ------------------------------------
14/01/16  CR3248      LHG008	 ECA zone implementation  
************************************************************************************/

// Check if we're active, and exit if not.
If not ib_active Then
	Return 1
End if

DataWindow ldw
Double ld_tmp
Integer li_count, li_row, li_current_cargo, li_no_cargoes
Integer li_itinerary_max, li_itinerary_count, li_itinerary, li_tmp, li_type, li_indexed
Integer li_itinerary_list[20] // List of itinerary points used for finding itinerary numbers
Integer li_index[0 TO 5]		// List of cargoes, used to convert between "our" cargo. and wizard cargo no.
String ls_col, ls_tmp, ls_errortext
s_cargodata lstr_cargodata[0 TO 4] // List of cargo data, used for temporary time & terms calculation

// Call accept text to update changes and exit if error.
If dw_wizard.AcceptText()<>1 Then Return(-1)

// Ok, lets start the processing
This.uf_redraw_off()


// Itinerary number fixup. 
// Loop through all ports on the wizard. Count the number of load and disch ports,
// and find the maximum used itinerary number.

li_no_cargoes = 0

For li_count = 1 To ii_fixup_size
	
	// Check if it's a portcode, and it's not null
	If istr_fixup[li_count].s_dw_column = "port_code" Then
		ls_tmp = dw_wizard.GetItemString(1, li_count)
		If Not(IsNull(ls_tmp)) Then
			
			// Get itinerary number from the wizard datawindow
			li_itinerary = dw_wizard.GetItemNumber(1, uf_create_columnname(istr_fixup[li_count].s_dw_name, &
				"itinerary", istr_fixup[li_count].i_cargono, istr_fixup[li_count].i_rowno ))
			// Set to 0 if it's null
			If Isnull(li_itinerary) Then li_itinerary = 0

			// Increment number of used ports (either loadports or dischports)
			CHOOSE CASE istr_fixup[li_count].s_dw_name
				CASE "dwl"
					lstr_cargodata[istr_fixup[li_count].i_cargono].i_loadports ++
				CASE "dwd"
					lstr_cargodata[istr_fixup[li_count].i_cargono].i_dischports ++
			END CHOOSE

			// If this number is larger than itinerary_max (number) then set the
			// max itinerary number to this number.
			if li_itinerary > li_itinerary_max Then li_itinerary_max = li_itinerary
			
			// If no itinerary number is given, then add this entry to the itinerary list.
			// this list is later on used to calculate the itinerary number for this entry
			if li_itinerary = 0 Then 
				li_itinerary_count ++
				li_itinerary_list[li_itinerary_count] = li_count
			End if
		End if
	End if

	// increment number of used cargoes, if quantity is > 0. This is because a
	// cargo can be disable on multi-cargo wizards, by setting the quantity to 0.
	// The li_index is an index array to each cargo (that has a quantity > 0).
	// Eg. li_index[1] might point to the wizard cargo #2 (if cargo 1 quantity = 0)
	If (istr_fixup[li_count].s_dw_column="quantity") Then
		If (dw_wizard.GetItemNumber(1, li_count) > 0) Then
			li_no_cargoes ++	
			li_index[li_no_cargoes] = istr_fixup[li_count].i_cargono
		End if
	End if
Next

// Now loop through the li_itinerary_list, and set the itinerary number on cargos
// that doesn't have an itinerary number. 
// li_type is a loopcounter for load and dischports, while li_count loops through
// the array for each port type. By looping through first the loadports and second
// the dischports, we'll ensure that dischport by default will have a larger 
// itinerary number than the loadports.
If li_itinerary_count > 0 Then
	For li_type = 1 To 2 
		For li_count = 1 To li_itinerary_count 
			li_tmp = li_itinerary_list[li_count]		

			// Process this if its a loadport and li_type is 1 or
			// it's a dischport and li_type is 2. 
			If ((istr_fixup[li_tmp].s_dw_name = "dwl") And (li_type=1)) &
				Or ((istr_fixup[li_tmp].s_dw_name = "dwd") and (li_type=2)) Then
				li_itinerary_max ++

				// Update itinerary number
				dw_wizard.SetItem(1, uf_create_columnname(istr_fixup[li_tmp].s_dw_name, "itinerary", istr_fixup[li_tmp].i_cargono, istr_fixup[li_tmp].i_rowno), li_itinerary_max)
			End if
		Next
	Next	
End if

// Return error if no cargoes is given (quantity was 0 on all cargoes).
If li_no_cargoes = 0 Then 
	MessageBox("Error", "No enough data given, please fill out all lightblue fields", StopSign!)
	Goto Stop
End if

// Update cargo, so that the correct number of port exists. The uf_set_no_cargos
// function updates the underlying calculation by deleting or adding cargoes.
iuo_calc_nvo.iuo_calc_cargos.uf_set_no_cargos(li_no_cargoes)

// Fix, this line is needed if it's a single cargo wizard (since single cargos
// is cargo number 0), while multicargos starts from number 1.
If not ib_multicargo then li_index[1] = 0

// Loop through the list of cargoes, check number of load/dischports and
// update number of ports on each cargo.
For li_count = 1 To li_no_cargoes 

	// Get the actual wizard cargo number from the li_index array
	li_indexed = li_index[li_count]

	If lstr_cargodata[li_indexed].i_loadports=0 or  lstr_cargodata[li_indexed].i_dischports=0 Then
		ls_errortext = "Error in cargo #"+String(li_indexed)+"~r~n~r~nLoadport and/or dischport not defined"
		Goto Stop
	End if	

	// Update number of ports for this cargo.
	iuo_calc_nvo.iuo_calc_cargos.uf_set_no_ports(li_count, lstr_cargodata[li_indexed].i_loadports, lstr_cargodata[li_indexed].i_dischports, true)
Next

// Now, get the laytype, time & terms from each cargo into an temporary array 
// (lstr_cargodata). This array is used later for conversion between wizard values 
// and actual values used in the calculation. This is needed, because the wizard uses
// total terms for all ports, whereas the calculation has seperate terms for each port.
//
// In the cargodata list, layterm can be for both load and disch (l_layterm) or
// specific for load and disch ports (l_layterm_load) and (l_layterm_disch).

// First, Set default values to null for all cargoes
For li_count = 0 To 4
	SetNull(lstr_cargodata[li_count].i_laytype)
	SetNull(lstr_cargodata[li_count].d_laytime)
	SetNull(lstr_cargodata[li_count].l_layterm)
	SetNull(lstr_cargodata[li_count].l_layterm_load)
	SetNull(lstr_cargodata[li_count].l_layterm_disch)
Next

// Next, loop through all wizard fields, and get the values if the laytype, time & terms
// into the array
For li_count = 1 To ii_fixup_size 
	// Get row no, column no and current cargo to local variables for
	// easier access (less code).
	li_row = istr_fixup[li_count].i_rowno
	ls_col = istr_fixup[li_count].s_dw_column
	li_current_cargo = istr_fixup[li_count].i_cargono

	// copy information to lstr_cargodata array depending on field type
	CHOOSE CASE istr_fixup[li_count].s_dw_column
		CASE "laytype"
			lstr_cargodata[li_current_cargo].i_laytype = dw_wizard.GetItemNumber(1, li_count)
		CASE "laytype_load"
			lstr_cargodata[li_current_cargo].i_laytype_load = dw_wizard.GetItemNumber(1, li_count)
		CASE "laytype_disch"
			lstr_cargodata[li_current_cargo].i_laytype_disch = dw_wizard.GetItemNumber(1, li_count)
		
		CASE "laytime"
			lstr_cargodata[li_current_cargo].d_laytime = dw_wizard.GetItemNumber(1, li_count)
		CASE "laytime_load"
			lstr_cargodata[li_current_cargo].d_laytime_load = dw_wizard.GetItemNumber(1, li_count)
		CASE "laytime_disch"
			lstr_cargodata[li_current_cargo].d_laytime_disch = dw_wizard.GetItemNumber(1, li_count)
		CASE "laytime_calculated_load"
			lstr_cargodata[li_current_cargo].d_laytime_calculated_load = dw_wizard.GetItemNumber(1, li_count)
		CASE "laytime_calculated_disch"
			lstr_cargodata[li_current_cargo].d_laytime_calculated_disch = dw_wizard.GetItemNumber(1, li_count)

		CASE "quantity"
			lstr_cargodata[li_current_cargo].d_quantity = dw_wizard.GetItemNumber(1, li_count) 

		CASE "despatch"
			lstr_cargodata[li_current_cargo].d_despatch = dw_wizard.GetItemNumber(1, li_count)
		CASE "demurrage"
			lstr_cargodata[li_current_cargo].d_demurrage = dw_wizard.GetItemNumber(1, li_count)

		CASE "layterm"
			lstr_cargodata[li_current_cargo].l_layterm = dw_wizard.GetItemNumber(1, li_count)  
		CASE "layterm_load"
			lstr_cargodata[li_current_cargo].l_layterm_load = dw_wizard.GetItemNumber(1, li_count)  
		CASE "layterm_disch"
			lstr_cargodata[li_current_cargo].l_layterm_disch = dw_wizard.GetItemNumber(1, li_count)  
	END CHOOSE
Next				

// Now calculate the actual time & terms for each cargo. The calculation depends on the
// terms and if it's reversible or not.
For li_count = 1 To li_no_cargoes  

	// Again we use the li_index array to convert from our cargo number to the wizard
	// cargo number.
	li_indexed = li_index[li_count]

	// Calculate laytime for laytype 0 or 4 (hours or days)
	// If reversible:
	// 	Laytime equals laytime divided by 2 (to split the no. of time to load and dischports)
	// If not reversible:
	// 	Load & disch time equals laytime divided by no. of cargoes

	If IsNull(lstr_cargodata[li_indexed].i_laytype) Then
		// Seperate BULK processing. Laytime is not given, instead laytype_load and laytype_disch 
		// is used to find allowance.
		if  not iuo_calc_nvo.iuo_calc_cargos.dw_cargo_summary.GetItemNumber(li_count, "cal_carg_cal_carg_reversible") = 1 Then
			If (lstr_cargodata[li_indexed].i_laytype_load = 0) or (lstr_cargodata[li_indexed].i_laytype_load = 4) Then	
				lstr_cargodata[li_indexed].d_laytime_load = lstr_cargodata[li_indexed].d_laytime_load / lstr_cargodata[li_indexed].i_loadports
				lstr_cargodata[li_indexed].d_laytime_calculated_load = lstr_cargodata[li_indexed].d_laytime_calculated_load / lstr_cargodata[li_indexed].i_loadports
			End if
	
			If (lstr_cargodata[li_indexed].i_laytype_disch = 0) or (lstr_cargodata[li_indexed].i_laytype_disch = 4) Then
				lstr_cargodata[li_indexed].d_laytime_disch = lstr_cargodata[li_indexed].d_laytime_disch / lstr_cargodata[li_indexed].i_dischports
				lstr_cargodata[li_indexed].d_laytime_calculated_disch = lstr_cargodata[li_indexed].d_laytime_calculated_disch / lstr_cargodata[li_indexed].i_dischports
			End if
		End if
	ElseIf (lstr_cargodata[li_indexed].i_laytype = 0) or (lstr_cargodata[li_indexed].i_laytype = 4) Then
		if  iuo_calc_nvo.iuo_calc_cargos.dw_cargo_summary.GetItemNumber(li_count, "cal_carg_cal_carg_reversible") = 1 Then
			// Reversible demurrage 
			lstr_cargodata[li_indexed].d_laytime = lstr_cargodata[li_indexed].d_laytime / 2
		Else
			// non-reversible demurrage
			lstr_cargodata[li_indexed].d_laytime = lstr_cargodata[li_indexed].d_laytime / (lstr_cargodata[li_indexed].i_loadports + lstr_cargodata[li_indexed].i_dischports)
		End if
	End if

	// Calculate load and disch quantity as total quantity divided by no of load hhv. disch ports.
	// this value is later stored to each port on the calculation.
	lstr_cargodata[li_indexed].d_load_quantity = Round(lstr_cargodata[li_indexed].d_quantity / lstr_cargodata[li_indexed].i_loadports , 0)
	lstr_cargodata[li_indexed].d_disch_quantity = Round(lstr_cargodata[li_indexed].d_quantity / lstr_cargodata[li_indexed].i_dischports , 0)

	// Calculate eventual difference between the sum of splitted quanties and total
	// quantity.
	lstr_cargodata[li_indexed].d_quantity_diff =  (lstr_cargodata[li_indexed].d_disch_quantity * lstr_cargodata[li_indexed].i_dischports) - &
		(lstr_cargodata[li_indexed].d_load_quantity * lstr_cargodata[li_indexed].i_loadports)

	// Is layterm is not given, then default to MT/Hour
	If IsNull(lstr_cargodata[li_indexed].l_layterm) And IsNull(lstr_cargodata[li_indexed].l_layterm_load) Then
		lstr_cargodata[li_indexed].l_layterm = 1
		lstr_cargodata[li_indexed].l_layterm_load =1
		lstr_cargodata[li_indexed].l_layterm_disch = 1
	End if
Next

// Do the final fixup, and move all data from the wizard fields (or the lstr_cargodata 
// array) to the calculation fields. 
//	This is done with a loop for all cargoes, and a loop for all wizards fields for
// each cargo.

// Loop through all cargoes, and all wizard fields for each cargo. 
For li_current_cargo = 1 To li_no_cargoes 

	// Select cargo on calcuation, and get our index to the same cargo in
	// li_indxed
	iuo_calc_nvo.iuo_calc_cargos.uf_select_cargo(li_current_cargo)	
	li_indexed = li_index[li_current_cargo]

	// Loop through all wizard fields
	For li_count = 1 To ii_fixup_size
		
		// Check if this field is to be used on this cargo. If (cargo no = li_indexed) or
		// if (not multicargo) or mail calculcation fields.
		If (istr_fixup[li_count].i_cargono = li_indexed) or (not ib_multicargo) or & 
			(istr_fixup[li_count].s_dw_name = "dws") or (istr_fixup[li_count].s_dw_name = "dwb") Then

			// Get row no and coloumn no for calculation field
			li_row = istr_fixup[li_count].i_rowno
			ls_col = istr_fixup[li_count].s_dw_column

			// Store actual datawindow pointer in the ldw variable.
			CHOOSE CASE istr_fixup[li_count].s_dw_name
				CASE "dws" // Datawindw calc summary
					ldw = iuo_calc_nvo.iuo_calc_summary.dw_calc_summary
				CASE "dwc" // Datawindow cargo summary
					ldw = iuo_calc_nvo.iuo_calc_cargos.dw_cargo_summary
					li_row = li_current_cargo
				CASE "dwl" // Datawindow load 
					ldw = iuo_calc_nvo.iuo_calc_cargos.dw_loadports
				CASE "dwd" // Datawindow disch
					ldw = iuo_calc_nvo.iuo_calc_cargos.dw_dischports
				CASE "dwb" // Datawindow ballast
					ldw = iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast
				CASE ELSE
					Continue
			END CHOOSE

			// Store wizard fields to calculation fields
			CHOOSE CASE istr_fixup[li_count].s_dw_column
				CASE "itinerary"
					ldw.SetItem(li_row, "cal_caio_itinerary_number", dw_wizard.GetItemNumber(1, li_count))
				CASE "rate"
					// Transfer rate to appropriate calculation field, depending on freigth type
					CHOOSE CASE ldw.GetItemNumber(li_row, "cal_carg_freight_type")
						CASE 1,2 // $ pr. ton
							ldw.SetItem(li_row, "cal_carg_freight_rate", dw_wizard.GetItemNumber(1, li_count))
						CASE 3
							ldw.SetItem(li_row, "cal_carg_lumpsum", dw_wizard.GetItemNumber(1, li_count))
						CASE 4
							ldw.SetItem(li_row, "cal_carg_ws_rate", dw_wizard.GetItemNumber(1, li_count))
					END CHOOSE
				CASE "laytype", "laytype_load", "laytype_disch", &
					"laytime", "laytime_load", "laytime_disch", "quantity", &
					"layterm", "layterm_load", "layterm_disch", "laytime_calculated_load", "laytime_calculated_disch", &
					"despatch", "demurrage"

					// Time & terms is store when storing the portcode, so no code is nessary here
				CASE "port_code"

					// Store quantity as as plus if load or minus if disch
					If istr_fixup[li_count].s_dw_name="dwd" Then 
						ld_tmp = - lstr_cargodata[li_indexed].d_disch_quantity 
					Else 
						ld_tmp = lstr_cargodata[li_indexed].d_load_quantity 

						// Include calculated quantity difference on loadport 1.
						If li_row = 1 Then ld_tmp += lstr_cargodata[li_indexed].d_quantity_diff
					End if
			
					// Store number of units to calculation field
					ldw.SetItem(li_row, "cal_caio_number_of_units", ld_tmp)

					// and store the portcode to the portcode field.
					ldw.SetItem(li_row, ls_col, dw_wizard.GetItemString(1, li_count))

					// Now store the laytime & terms
					If IsNull(lstr_cargodata[li_indexed].i_laytype) Then
						// Special bulk processing (different load and disch terms)

						If ld_tmp >= 0 Then // Load
							ldw.SetItem(li_row, "cal_caio_load_terms", lstr_cargodata[li_indexed].i_laytype_load)
							ldw.SetItem(li_row, "cal_caio_rate_estimated", lstr_cargodata[li_indexed].d_laytime_load)
							ldw.SetItem(li_row, "cal_caio_rate_calculated", lstr_cargodata[li_indexed].d_laytime_calculated_load)
							ldw.SetItem(li_row, "cal_raty_id", lstr_cargodata[li_indexed].l_layterm_load)
						Else
							ldw.SetItem(li_row, "cal_caio_load_terms", lstr_cargodata[li_indexed].i_laytype_disch)
							ldw.SetItem(li_row, "cal_caio_rate_estimated", lstr_cargodata[li_indexed].d_laytime_disch)
							ldw.SetItem(li_row, "cal_caio_rate_calculated", lstr_cargodata[li_indexed].d_laytime_calculated_disch)
							ldw.SetItem(li_row, "cal_raty_id", lstr_cargodata[li_indexed].l_layterm_disch)
						End if
					Else
						// Normal processing (load and disch time & terms is the same
						ldw.SetItem(li_row, "cal_caio_load_terms", lstr_cargodata[li_indexed].i_laytype)
						ldw.SetItem(li_row, "cal_caio_rate_estimated", lstr_cargodata[li_indexed].d_laytime)
						ldw.SetItem(li_row, "cal_raty_id", lstr_cargodata[li_indexed].l_layterm)
					End if

					// Store dispatch and demurrage values
					ldw.SetItem(li_row, "cal_caio_despatch", lstr_cargodata[li_indexed].d_despatch)
					ldw.SetItem(li_row, "cal_caio_demurrage", lstr_cargodata[li_indexed].d_demurrage)

				CASE ELSE
					// Ok, this field wasn't stored earlier. This means that the field
					// doesn't require special handling, and it can just be transferred
					// directly to the corrosponding calculation field.
					CHOOSE CASE istr_fixup[li_count].i_dw_type
						CASE 1 // Char
							ldw.SetItem(li_row, ls_col, dw_wizard.GetItemString(1, li_count))
						CASE 2 // Date
							ldw.SetItem(li_row, ls_col, dw_wizard.GetItemDate(1, li_count))
						CASE 3 // datetime
							ldw.SetItem(li_row, ls_col, dw_wizard.GetItemDateTime(1, li_count))
						CASE 4 // Decimal 
							ldw.SetItem(li_row, ls_col, dw_wizard.GetItemDecimal(1, li_count))
						CASE 5 // Number
							ldw.SetItem(li_row, ls_col, dw_wizard.GetItemNumber(1, li_count))
						CASE 6 // Time
							ldw.SetItem(li_row, ls_col, dw_wizard.GetItemTime(1, li_count))
					END CHOOSE
			END CHOOSE

			// Additional (post) processing goes here:
			CHOOSE CASE istr_fixup[li_count].s_dw_column
				CASE "cal_calc_ballast_from"
					// Ballast from is not allowed to be null, so we set it to empty string
					// if it's null and stores it to the calculation fields
					ls_tmp = dw_wizard.GetItemString(1, li_count)
					If IsNull(ls_tmp) Then ls_tmp = ""

					iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast.SetItem(1, "port_code", ls_tmp)
				CASE "cal_calc_ballast_to"
					// ...and the same for ballast to port.
					
					ls_tmp = dw_wizard.GetItemString(1, li_count)
					If IsNull(ls_tmp) Then ls_tmp = ""

					iuo_calc_nvo.iuo_calc_summary.dw_calc_ballast.SetItem(2, "port_code", ls_tmp)
				CASE "cal_caio_expenses"
					// Update summ of expenses to total port expenses on the calculation
					
					If li_row <=ldw.RowCount() Then
						ld_tmp = ldw.GetItemNumber(li_row, "cal_caio_load_unit_expenses")
						ld_tmp = ld_tmp *  Abs(ldw.GetItemNumber(li_row, "cal_caio_number_of_units"))
						ld_tmp = ld_tmp + ldw.GetItemNumber(li_row, "cal_caio_expenses")
						ld_tmp = ld_tmp + ldw.GetItemNumber(li_row, "cal_caio_misc_expenses")
						ld_tmp = ld_tmp + ldw.GetItemNumber(li_row, "cal_caio_misc_expenses_2")

						ldw.SetItem(li_row, "cal_caio_total_port_expenses", ld_tmp)			
					End if
			END CHOOSE
		End if
	Next
Next 

Stop:

// Turn redraw on
This.uf_redraw_on()

// And display error message if any errors
If ls_errortext <> "" Then
	MessageBox("Error", ls_errortext, StopSign!)
	Return(-1)
Else
	// Otherwise clear the itinerary cache, so it will be updated, next time the
	// user selects the Itinerary page.
	iuo_calc_nvo.iuo_calc_itinerary.uf_clear_cache()
	ib_active = false
	Return(1)
End if
end function

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw off

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_wizard.uf_redraw_off()
end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Turns redraw on

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_wizard.uf_redraw_on()
end subroutine

public subroutine uf_activate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Set active to true and call anscestor

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

ib_active = true
Super::uf_activate()
end subroutine

private function string uf_create_columnname (string as_dw_name, string as_column_name, integer ai_cargono, integer ai_rowno);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Creates a valid columnname, eg. "dws1_vessel_name" from given arguments
					cargo-identity is omitted if 0

 Arguments : AS_DW_NAME, AS_COLUMN_NAME as String,
 				 AI_CARGONO, AI_ROWNO as integer.

 Returns   : Combined columnname as string

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_tmp

ls_tmp = as_dw_name
If ai_cargono <> 0 Then ls_tmp += String(ai_cargono) + "_"
ls_tmp += String(ai_rowno) +"_" + as_column_name

Return ls_tmp
end function

private subroutine uf_itinerary_clicked (boolean ab_rightclicked);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Handles clicking on the itinerary "buttons" in the wizard window

 Arguments : ab_Rightclicked as boolean

************************************************************************************/

String ls_columnname
s_fixup lstr_fixup
Integer li_pos, li_count, li_tmp

// Get columnname from wizard datawindow
ls_columnname = dw_wizard.GetObjectAtPointer()

// Search for the ~t (tab) character to get the columnname only
li_pos = Pos(ls_columnname, "~t")
If li_pos > 0 Then
	// Convert columnname to columnname without rownumber
	ls_columnname = Left(ls_columnname, li_pos -1 )
	// and split the columnname to a lstr_fixup record
	uf_split_columnname(ls_columnname, lstr_fixup)

	// Continue only if it's a itinerary field
	If lstr_fixup.s_dw_column = "itinerary" Then
		
		If lstr_fixup.i_cargono>0 Then
			// Check that quantity is valid, else return.
			If dw_wizard.GetItemNumber(1, uf_create_columnname("dwc", "quantity", lstr_fixup.i_cargono, 1) )= 0 Then Return
		End if

		// If left-clicked, we're gonna increment the itinerary number, if none is given.
		If not ab_rightclicked then
			// Return if no port name is given
			If IsNull(dw_wizard.GetItemString(1, uf_create_columnname(lstr_fixup.s_dw_name, "port_code", lstr_fixup.i_cargono, lstr_fixup.i_rowno))) Then Return
	
			// Get current itinerary number, set to zero if it's null and exit if
			// it's > 0 (already set).
			li_tmp = dw_wizard.GetItemNumber(1, ls_columnname)
			If Isnull(li_tmp) Then li_tmp = 0
			If li_tmp <> 0 Then Return

			// else increment itinerary counter
			ii_set_itinerary ++

			// and set the itinerary value
			dw_wizard.SetItem(1, ls_columnname, ii_set_itinerary)
		Elseif (lstr_fixup.s_dw_name="dwl") Then
			// We use right-clicking to reset the itinerary order, but it has to be on a loadport.
		
			// Reset itinerary numbering
			ii_set_itinerary = 1
			
			// Clear all itinerary fields to zeros		
			For li_count = 1 To ii_fixup_size
				If istr_fixup[li_count].s_dw_column = "itinerary" Then dw_wizard.SetItem(1, li_count, 0)
			Next

			// and set this rownumber as row 1.
			dw_wizard.SetItem(1, ls_columnname, ii_set_itinerary)
		End if
	End if
End if



end subroutine

private subroutine uf_split_columnname (string as_data, ref s_fixup as_fixup);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Splits a combined columnname to the appropriate fields in a s_fixup record
					eg. "dwl1_port_code" to: 
					dw_as ("dwl") ai_rowno ("1") and as_column ("port_code")

 Arguments : AS_DATA as string and AS_FIXUP as S_FIXUP REF

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// New (version 4) - multi cargo capabilities
// If string is in the form "dwc1_1_field", then the first number (1) 
// identifies cargonumber, while the second value identifies rownumber


Integer li_tmp

// Search for default information. If default information is given, it will be set as
// data in the field. Eg. "dws1_vessel_name_default_Inger maersk" will set "Inger maersk"
// as the value in the vessel name field.

// Search for _default_
li_tmp = pos(as_data, "_default_")
If li_tmp > 0 Then
	// If found, the copy the data to the s_fixup.s_default_value and remove the information
	// from the as_data string.
	as_fixup.s_default_value = Mid(as_data, li_tmp + 9)
	as_data = Left(as_data, li_tmp -1 )
Else
	// otherwise set default data to nothing
	as_fixup.s_default_value = ""
End if

// Check if field contains cargo no. information.
If Mid(as_data,5,1)="_" And Mid(as_data,7,1)="_" Then
	// Update fields as given in the record

	as_fixup.s_dw_name = Left(as_data,3)
	as_fixup.i_cargono = Long(Mid(as_data,4,1))
	as_fixup.i_rowno = Long(Mid(as_data,6,1))
	as_fixup.s_dw_column = Mid(as_data,8)
Else
	// Old style - no cargo no given, default cargo no. to 0

	as_fixup.s_dw_name = Left(as_data, 3)
	as_fixup.i_rowno = Long(Mid(as_data, 4,1))
	as_fixup.s_dw_column = Mid(as_data, 6)
	as_fixup.i_cargono =0
End if

Return
end subroutine

public subroutine uf_load_vesseldata ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 8-1-97

 Description : loads the vessel speedlist from the calculation to the dropdown windows

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DataWindow ldw_tmp
Integer li_count
Long ll_max, ll_count, ll_row

// Update both ballasted and laden speed, but looping through this code. First for
// ballasted speed and afterwards for laden speed. Store information to the ldw_tmp
// datawindow, which points to either the ballasted or laden datawindow
For li_count = 1 To 2 
	
	// Select ballast or laden datawindow
	CHOOSE CASE li_count
		CASE 1
			ldw_tmp = dw_ballasted_speed
		CASE 2
			ldw_tmp = dw_laden_speed
	END CHOOSE

	// reset the datawindow
	ldw_tmp.Reset()

	// And loop through all entries in the istr_speedlist on the calculation 
	ll_max = UpperBound(iuo_calc_nvo.istr_speedlist[])
	For ll_count = 1 To ll_max

		// include this entry, if the speedlist type equals our type (ballast or laden)
		If iuo_calc_nvo.istr_speedlist[ll_count].i_type = li_count Then
			ll_row = ldw_tmp.InsertRow(0)
			ldw_tmp.SetItem(ll_row, "speed", iuo_calc_nvo.istr_speedlist[ll_count].d_speed)
			ldw_tmp.SetItem(ll_row, "name", iuo_calc_nvo.istr_speedlist[ll_count].s_name)
		End if			
	Next
Next

// Update fo, do, mgo and deadweight fields on the wizard, if such fields exists.
For li_count = 1 To ii_fixup_size
	CHOOSE CASE istr_fixup[li_count].s_dw_column
		CASE "cal_calc_fo_price"
			dw_wizard.SetItem(1, li_count, iuo_calc_nvo.istr_calc_vessel_data.d_fo_price)
		CASE "cal_calc_do_price"
			dw_wizard.SetItem(1, li_count, iuo_calc_nvo.istr_calc_vessel_data.d_do_price)
		CASE "cal_calc_mgo_price"
			dw_wizard.SetItem(1, li_count, iuo_calc_nvo.istr_calc_vessel_data.d_mgo_price)
		CASE "deadweight"
			dw_wizard.SetItem(1, li_count, iuo_calc_nvo.istr_calc_vessel_data.d_sdwt)
	END CHOOSE
Next
end subroutine

event destructor;call super::destructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 7-10-96

 Description : Does the cleanup, by destroying search objects allocated in the 
 					fixup event

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_max, li_count

// Free all searchobjects allocation in the fixup event
li_max = UpperBound(istr_fixup)
For li_count = 1 To li_max
	If Not(IsNull(istr_fixup[li_count].uo_search)) Then DESTROY istr_fixup[li_count].uo_Search
Next
end event

on u_atobviac_calc_wizard.create
int iCurrent
call super::create
this.dw_wizard=create dw_wizard
this.dw_calc_via_dddw=create dw_calc_via_dddw
this.dw_ballasted_speed=create dw_ballasted_speed
this.dw_laden_speed=create dw_laden_speed
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_wizard
this.Control[iCurrent+2]=this.dw_calc_via_dddw
this.Control[iCurrent+3]=this.dw_ballasted_speed
this.Control[iCurrent+4]=this.dw_laden_speed
this.Control[iCurrent+5]=this.gb_1
end on

on u_atobviac_calc_wizard.destroy
call super::destroy
destroy(this.dw_wizard)
destroy(this.dw_calc_via_dddw)
destroy(this.dw_ballasted_speed)
destroy(this.dw_laden_speed)
destroy(this.gb_1)
end on

type dw_wizard from uo_datawindow within u_atobviac_calc_wizard
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 64
integer width = 2816
integer height = 1328
integer taborder = 30
string dataobject = "d_wizard"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_keydown;call super::ue_keydown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Deletes expenses when a via point is deleted

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_null, ls_name
Integer li_column

SetNull(ls_null)

// Then if it's a keydown, and current field is a "via_point"
If (Keydown( keyDelete!)) then
	ls_name = this.GetColumnName()
	If Pos(ls_name, "via_point") > 0 Then
		
		// Set this viapoint to null (instead of empty string)
		This.SetText(ls_null)
		This.SetItem(1,This.GetColumn(), ls_null)		

		// And delete expenses for this via_point
		li_column = This.GetColumn()
		dw_wizard.SetItem(1, uf_create_columnname(istr_fixup[li_column].s_dw_name, "cal_caio_via_expenses_1", istr_fixup[li_column].i_cargono, istr_fixup[li_column].i_rowno), 0.0) 
	End if
End if

end event

event rbuttondown;call super::rbuttondown;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description :  Call uf_itinerary_clicked with true as the rbutton argument

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uf_itinerary_clicked(true)

end event

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calls on to UF_ITINERARY_CLICKED

 Arguments : None

 Returns   : NOne  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uf_itinerary_clicked(false)
end event

event itemchanged;call super::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Handles itemchanged events for dddw_search objects

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_column, li_max, li_rowno
String ls_originalvalue, ls_dwname, ls_null

// Get column number and check if there's an dddw_search object connected to this field
li_column = This.GetColumn()
If (not isnull(istr_fixup[li_column].uo_search)) Then

	// Get original text value, and call dddw search object.uf_itemchanged
	ls_originalvalue = This.GetText()
	istr_fixup[li_column].uo_search.uf_itemchanged()
	
	// If the field is a port code, and it has been deleted, then move the rest of
	// ports (and information to each port) up one row.
	If (istr_fixup[li_column].s_dw_column = "port_code") And (This.GetText()="") Then

		// Get rowno, max. no of ports and datawindow name to local variables
		li_rowno = istr_fixup[li_column].i_rowno
		If istr_fixup[li_column].s_dw_name = "dwl" Then li_max = ii_no_loadports Else li_max = ii_no_dischports
		ls_dwname = istr_fixup[li_column].s_dw_name

		// Move data up in this loop
		DO WHILE li_rowno < li_max
			dw_wizard.SetItem(1, uf_create_columnname(ls_dwname, "port_code", istr_fixup[li_column].i_cargono, li_rowno), & 
			dw_wizard.GetItemString(1, uf_create_columnname(ls_dwname, "port_code", istr_fixup[li_column].i_cargono, li_rowno+1)))

			dw_wizard.SetItem(1, uf_create_columnname(ls_dwname, "cal_caio_expenses", istr_fixup[li_column].i_cargono, li_rowno), &
			dw_wizard.GetItemNumber(1, uf_create_columnname(ls_dwname, "cal_caio_expenses", istr_fixup[li_column].i_cargono, li_rowno+1)))

			dw_wizard.SetItem(1, uf_create_columnname(ls_dwname,  "cal_caio_via_point_1", istr_fixup[li_column].i_cargono, li_rowno), &
			dw_wizard.GetItemString(1, uf_create_columnname(ls_dwname,  "cal_caio_via_point_1", istr_fixup[li_column].i_cargono, li_rowno+1)))

			dw_wizard.SetItem(1, uf_create_columnname(ls_dwname,  "cal_caio_via_expenses_1", istr_fixup[li_column].i_cargono, li_rowno), &
			dw_wizard.GetItemNumber(1, uf_create_columnname(ls_dwname,  "cal_caio_via_expenses_1", istr_fixup[li_column].i_cargono, li_rowno+1)))

			li_rowno ++
		LOOP

		// and set fieldvalues to null for the last row
		SetNull(ls_null)

		dw_wizard.SetItem(1, uf_create_columnname(ls_dwname, "port_code", istr_fixup[li_column].i_cargono, li_rowno), ls_null)
		dw_wizard.SetItem(1, uf_create_columnname(ls_dwname, "cal_caio_expenses", istr_fixup[li_column].i_cargono, li_rowno), 0.0) 
		dw_wizard.SetItem(1, uf_create_columnname(ls_dwname,  "cal_caio_via_point_1", istr_fixup[li_column].i_cargono, li_rowno), ls_null)
		dw_wizard.SetItem(1, uf_create_columnname(ls_dwname, "cal_caio_via_expenses_1", istr_fixup[li_column].i_cargono, li_rowno), 0.0) 
	End if
End if



end event

event editchanged;call super::editchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Edit changed event, check to see if a dddw_search object is connected 
					to this field (column no). If so, call the uf_editchanged for that 
					object.


 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_tmp

li_tmp = This.GetColumn()

If (not isnull(istr_fixup[li_tmp].uo_search)) Then
	istr_fixup[li_tmp].uo_search.uf_editchanged()
End if

end event

type dw_calc_via_dddw from u_datawindow_sqlca within u_atobviac_calc_wizard
boolean visible = false
integer x = 1847
integer y = 992
integer height = 80
integer taborder = 40
string dataobject = "d_calc_via_dddw"
end type

type dw_ballasted_speed from u_datawindow_sqlca within u_atobviac_calc_wizard
boolean visible = false
integer x = 1006
integer y = 960
integer taborder = 20
string dataobject = "d_calc_speed"
end type

type dw_laden_speed from u_datawindow_sqlca within u_atobviac_calc_wizard
boolean visible = false
integer x = 494
integer y = 960
integer taborder = 10
string dataobject = "d_calc_speed"
end type

type gb_1 from groupbox within u_atobviac_calc_wizard
integer width = 2866
integer height = 1420
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Wizard"
borderstyle borderstyle = stylebox!
end type

