$PBExportHeader$w_chart_agent_broker_files.srw
$PBExportComments$Window that lets the user generate a file of debitors and creditors for use in connection with the CMS.
forward
global type w_chart_agent_broker_files from mt_w_main
end type
type cb_close from commandbutton within w_chart_agent_broker_files
end type
type cb_start from commandbutton within w_chart_agent_broker_files
end type
type rb_brokers from radiobutton within w_chart_agent_broker_files
end type
type rb_agents from radiobutton within w_chart_agent_broker_files
end type
type rb_charterers from radiobutton within w_chart_agent_broker_files
end type
type rb_all from radiobutton within w_chart_agent_broker_files
end type
type gb_1 from groupbox within w_chart_agent_broker_files
end type
end forward

global type w_chart_agent_broker_files from mt_w_main
integer x = 832
integer y = 360
integer width = 1326
integer height = 716
string title = "Charterer/Agent/Broker Files"
boolean maxbox = false
boolean resizable = false
long backcolor = 81324524
cb_close cb_close
cb_start cb_start
rb_brokers rb_brokers
rb_agents rb_agents
rb_charterers rb_charterers
rb_all rb_all
gb_1 gb_1
end type
global w_chart_agent_broker_files w_chart_agent_broker_files

forward prototypes
public function boolean wf_generate_file ()
public subroutine documentation ()
end prototypes

public function boolean wf_generate_file ();/************************************************************************************

 Author  : Teit Aunt 
   
 Date    : 1-6-98

 Description : Generate a file which is used together with the CMS files. For each data-
 					base there is made a file with agents, brokers and charterers. The file 
					is put in the same place as the CMS files.

 Arguments   : None

 Returns     : True is all went well

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
6-1-98	1.0		TA		Initial version
21-1-98           LN    Changed to check on database, and to be able to run in SIN, NY  
19-3-98  1.0		BO		Inserted a messagebox to give the user information about the
								file name(s) and if the creation of the file succeeded.
************************************************************************************/
// Variables
boolean lb_return, lb_agents, lb_brokers, lb_charterers, lb_all
string ls_path, ls_path1,ls_database, ls_tmp, ls_message
datastore lds_agents, lds_brokers, lds_chart
long ll_length
Integer li_rows, li_counter

// Set pointer
Pointer = "HourGlass!"

// Initiate return value
lb_return = True

ls_database = uo_global.is_database
ls_database = Mid (ls_database,1,2)

If rb_all.Checked = True Then lb_all = True
If rb_agents.Checked = True Then lb_agents = True
If rb_brokers.Checked = True Then lb_brokers = True
If rb_charterers.Checked = True Then lb_charterers = True

// Find file name
SELECT CMS_PATH
INTO :ls_path
FROM CMS_RRIS_NR;

Commit;

// Test of last sign in path
ll_length = Len(ls_path)
ls_tmp = Mid(ls_path, ll_length, 1)
If ls_tmp = "\" Then
	ls_path = Mid(ls_path, 1, ll_length - 1)
End if

// Create Agents file
If lb_all Or lb_agents Then
	
	// Create and populate populate
	lds_agents = Create datastore
	lds_agents.DataObject = "d_agent_file"
	
	lds_agents.SetTransObject(SQLCA)
	li_rows = lds_agents.Retrieve()
	For li_counter = 1 to li_rows
		IF lds_agents.GetItemNumber(li_counter,"agent_custsupp") = 0 THEN 
			lds_agents.SetItem(li_counter,"own_foreign","Foreign")
		ELSE
			lds_agents.SetItem(li_counter,"own_foreign","Own")
		END IF
	NEXT

	// Treating the data

	// Create file name
	CHOOSE CASE ls_database
		CASE "TG"
			ls_path1 = ls_path + "\TG_AGENT.XLS" 
		CASE "BU"
			ls_path1= ls_path + "\BU_AGENT.XLS"
		CASE "VL"
			ls_path1 = ls_path + "\VL_AGENT.XLS"
		CASE ELSE
			ls_path1 = ls_path + "\DB_AGENT.XLS"
	END CHOOSE

	// Write to file
	If lds_agents.SaveAs(ls_path1,Excel!,FALSE) = -1 Then 
		lb_return = False
	else
		ls_message = ls_path1
	end if
	
	// Destroy datastore
	Destroy lds_agents
End if

// Create Broker file
If lb_all Or lb_brokers Then

	// Create and populate populate
	lds_brokers = Create datastore
	lds_brokers.DataObject = "d_broker_file"
	
	lds_brokers.SetTransObject(SQLCA)
	li_rows = lds_brokers.Retrieve()
	For li_counter = 1 to li_rows
		IF lds_brokers.GetItemNumber(li_counter,"broker_custsupp") = 0 THEN 
			lds_brokers.SetItem(li_counter,"own_foreign","Foreign")
		ELSE
			lds_brokers.SetItem(li_counter,"own_foreign","Own")
		END IF
	NEXT

	
	// Treating the data
	
	// Create file name
	CHOOSE CASE ls_database
		CASE "TG"
			ls_path1 = ls_path + "\TG_BROKR.XLS" 
		CASE "BU"
			ls_path1= ls_path + "\BU_BROKR.XLS"
		CASE "VL"
			ls_path1 = ls_path + "\VL_BROKR.XLS"
		CASE ELSE
			ls_path1 = ls_path + "\DB_BROKR.XLS"
	END CHOOSE
	
	// Write to file
	If lds_brokers.SaveAs(ls_path1,Excel!,FALSE) = -1 Then 
		lb_return = False
	else
		if len(ls_message) > 0 then
			ls_message += " and " + ls_path1
	   else
			ls_message = ls_path1
		end if
   end if

	// Destroy datastore
	Destroy lds_brokers
End if

// Create Charterer file
If lb_all Or lb_charterers Then

	// Create and populate populate
	lds_chart = Create datastore
	lds_chart.DataObject = "d_chart_file"
	
	lds_chart.SetTransObject(SQLCA)
	li_rows = lds_chart.Retrieve()
	For li_counter = 1 to li_rows
		IF lds_chart.GetItemNumber(li_counter,"chart_custsupp") = 0 THEN 
			lds_chart.SetItem(li_counter,"own_foreign","Foreign")
		ELSE
			lds_chart.SetItem(li_counter,"own_foreign","Own")
		END IF
	NEXT
	
	
	// Treating the data
	
	// Create file name
	CHOOSE CASE ls_database
		CASE "TG"
			ls_path1 = ls_path + "\TG_CHART.XLS" 
		CASE "BU"
			ls_path1= ls_path + "\BU_CHART.XLS"
		CASE "VL"
			ls_path1 = ls_path + "\VL_CHART.XLS"
		CASE ELSE
			ls_path1 = ls_path + "\DB_CHART.XLS"
	END CHOOSE
	
	// Write to file
	If lds_chart.SaveAs(ls_path1,Excel!,FALSE) = -1 Then 
		lb_return = False
	else
		if len(ls_message) > 0 then
			ls_message += " and " + ls_path1
		else
			ls_message = ls_path1
		end if
	end if
	
	// Destroy datastore
	Destroy lds_chart
End if

// Set pointer
Pointer = "Arrow!"


/* Give the user information */
if lb_return  then
	if lb_all then
		messagebox("Information ", "The files " + ls_message + " were successfully generated!")
	else 
		messagebox("Information ", "The file " + ls_message + " was successfully generated!")
	end if
end if

// Return
Return(lb_return)

end function

public subroutine documentation ();/********************************************************************
	w_chart_agent_broker_files
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

on w_chart_agent_broker_files.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_start=create cb_start
this.rb_brokers=create rb_brokers
this.rb_agents=create rb_agents
this.rb_charterers=create rb_charterers
this.rb_all=create rb_all
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_start
this.Control[iCurrent+3]=this.rb_brokers
this.Control[iCurrent+4]=this.rb_agents
this.Control[iCurrent+5]=this.rb_charterers
this.Control[iCurrent+6]=this.rb_all
this.Control[iCurrent+7]=this.gb_1
end on

on w_chart_agent_broker_files.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_start)
destroy(this.rb_brokers)
destroy(this.rb_agents)
destroy(this.rb_charterers)
destroy(this.rb_all)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_main`st_hidemenubar within w_chart_agent_broker_files
end type

type cb_close from commandbutton within w_chart_agent_broker_files
integer x = 1010
integer y = 484
integer width = 247
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
boolean default = true
end type

event clicked;Close(Parent)
end event

type cb_start from commandbutton within w_chart_agent_broker_files
integer x = 722
integer y = 484
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Start"
end type

event clicked;/************************************************************************************

 Author  : Teit Aunt 
   
 Date    : 6-1-98

 Description : Calls wf_generate_file 

 Arguments   : None

 Returns     : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
6-1-98	1.0		TA		Initial version
  
************************************************************************************/
// Code

If Not(wf_generate_file()) Then MessageBox("Error","The file(s) could not be generated." + &
										" Contact system programmer for help!",StopSign!,OK!)
end event

type rb_brokers from radiobutton within w_chart_agent_broker_files
integer x = 690
integer y = 144
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Brokers"
boolean lefttext = true
end type

type rb_agents from radiobutton within w_chart_agent_broker_files
integer x = 686
integer y = 248
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Agents"
boolean lefttext = true
end type

type rb_charterers from radiobutton within w_chart_agent_broker_files
integer x = 187
integer y = 248
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Charterers"
boolean lefttext = true
end type

type rb_all from radiobutton within w_chart_agent_broker_files
integer x = 187
integer y = 144
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "All"
boolean checked = true
boolean lefttext = true
end type

type gb_1 from groupbox within w_chart_agent_broker_files
integer x = 73
integer y = 40
integer width = 1189
integer height = 400
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Debitor/Creditor Type"
end type

