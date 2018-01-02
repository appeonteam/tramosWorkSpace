$PBExportHeader$uo_help.sru
$PBExportComments$Used to contain help texts for the Standard Reports.
forward
global type uo_help from nonvisualobject
end type
end forward

global type uo_help from nonvisualobject
end type
global uo_help uo_help

forward prototypes
public function string of_help_text (string as_report_name)
public subroutine documentation ()
end prototypes

public function string of_help_text (string as_report_name);/********************************************************************
   of_help_text
   <DESC>	Description	</DESC>
   <RETURN>	string:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_report_name
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
		20-02-2001	TAU			
   	22-11-2014 3420         AZX004        First Version
   </HISTORY>
********************************************************************/

String ls_help_text

CHOOSE CASE as_report_name
	CASE "Top Charterer"
		ls_help_text = "The report states the charterer for the specified profit centre and "+ &
							"vessel group in the specified period. The charterers are listed in "+&
							"descending order, so the charterer, who has given the highest amount "+&
							"of businesses and turnover within the specified period, will be listed first."

	CASE "Top Broker"
		ls_help_text = "The report states the broker used for the specified profit centre and "+&
							"vessel group in the specified period. The brokers are listed in descending "+&
							"order, so the broker who has received the highest commission within the "+&
							"specified period will be listed first."

	CASE "Vessel Fleettracking"
		ls_help_text = "The report shows the occupation of the chosen vessels within the specified "+&
							"period. Or states the vessels occupied in the specified commodity. Further, "+&
							"give the report details about the month of the commencement of the voyage and "+&
							"load and discharge area. The report sort by profit centre, vessel and voyage. "
		
	CASE "Grade Fleettracking"
		ls_help_text = "The report shows the commodities the chosen vessel has transported within "+&
							"the specified period. The report is sorted by commodity, and listed by profit "+&
							"centre, vessel, voyage, charterer."

	CASE "Total Freight/Demurrage"
		ls_help_text = "The report states the profit centre, vessel group, charterer and year."

	CASE "COA Liftings/CVS"
		ls_help_text = "The report gives a listing of the COA/CVS liftings done for the chosen vessel "+&
							"and charterer. The report is sorted by profit centre, charterer and commodity, "+&
							"and listed by vessel, voyage, quantity, laycan start and end, and CP description."

	CASE "Liftings"
		ls_help_text = "The report states the amount of liftings for the specified vessels and charterer. "+&
							"The report is sorted by profit centre, charterer and commodity. Each vessel and "+&
							"voyage is stated together with laycan, purpose, port and quantity."

	CASE "Commissions"
		ls_help_text = "The report states if the commission related to the chosen vessel and broker is "+&
							"settled or not. The report is sorted by profit centre, and vessel, and listed by "+&
							"voyage, broker, commission, and if settlement status."
		
	CASE "Vessel Port Visits"
		ls_help_text = "The report gives an overview of the ports a specified vessel or vessels group has "+&
							"visited within the specified period. The report states vessel, voyages, commodity, "+&
							"arrival and departure date as well as purpose. The report is sorted by profit centre, "+&
							"vessel group, and vessel."

	CASE "Country Port Visits"
		ls_help_text = "The report shows the port calls, which are made to the specified country and port. "+&
							"The report is sorted by country, port, and profit centre. (TC Hire not included)"
		
	CASE "Port Rate/Grade/Temp"
		ls_help_text = "The report states the Port rate/grade/temp for each country, port, profit centre, "+&
							"vessel, voyage, commodity, quantity, rate and temperature, arrival and departure date."

	CASE "Vessel Rate/Grade/Temp"
		ls_help_text = "The report shows the specified vessel's port call within the specified period. "+&
							"The report is sorted by profit centre, vessel group, and vessel. The report gives "+&
							"and overview over the"

	CASE "Active/Finished Voyages"
		ls_help_text = "The report shows the status of voyages to the chosen port, if these are active "+&
							"or finished. The report is sorted by profit centre and vessel, and listed by "+&
							"voyages, voyages type, date and voyages status."
		
	CASE "Vessel Disbursement"
		ls_help_text = "The report states the disbursement paid on a voyage. The report sort by profit "+&
							"centre, vessel, voyage and agent."
							
	CASE "Port Disbursement"
		ls_help_text = "The report is sorted by port, and vessel. The report states port, vessel, voyage, "+&
							"agent, and disbursement, and disbursement finish date."
						
	CASE "Employment"
		ls_help_text = "The report gives an overview of the commodities the vessels have transported in "+&
							"the specified period. The report is sorted by profit centre, and vessel. It states "+&
							"the amount of every commodity the vessel has transported in the period, together "+&
							"with the related demurrage and freight. However for TC vessels the related TC hire "+&
							"is not included."

	CASE "Charteres Home Country Support"
		ls_help_text = "The report gives a status on freight and demurrage related to the specified "+&
							"charterer's home country. Since a charterer can have outlets in different countries, "+&
							"this report will not give an overview over the total business with a specific charterer. "+&
							"The report is sorted by county, profit centre, and listed by charter, vessel, and voyage."

	CASE "TC Hire"
		ls_help_text = "The report states the profit centre, vessel, charterer, broker, rate (either per "+&
							"day or month), dates, hire, offhire and total paid hire. The start date and end "+&
							"date is the period stated in the input to the report, which means that the TC can "+&
							"have started before or end after the period stated in the report."

	CASE "Idle Days"
		ls_help_text = "The report shows the amount of idle days for each vessel within the specified period. "+&
							"The report is sorted by profit centre, vessel and voyages, and states the commodity "+&
							"that followed after the idle period."

	CASE "Charterer Demurrage Statistics"
		ls_help_text = "The report shows demurrage earned on each voyage performed for specific Charterers, "+&
							"identifying the number of outstanding days for all claims (settled/unsettled) and Actions "+&
							"input listed in Actions/Transactions. The purpose of the report is to present Charterers with "+&
							"their >track record< and to highlight the number of claims outstanding."
		
	CASE "Broker Demurrage Statistics"
		ls_help_text = "The report shows demurrage earned on each voyage performed with a specific broker, "+&
							"identifying the number of outstanding days for all claims (settled/unsettled). Action "+&
							"input listed in the Actions/Transactions module is shown. The purpose of the report is to "+&
							"present Brokers with a status report and the relevant Charterers' >track record<."
		
	CASE ELSE
		ls_help_text = "There is no help text for this report"
		
END CHOOSE

return ls_help_text
end function

public subroutine documentation ();/********************************************************************
   uo_help
   <OBJECT> </OBJECT>
   <USAGE> </USAGE>
   <ALSO> </ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-11-2014 3420         AZX004        First Version
   </HISTORY>
********************************************************************/


end subroutine

on uo_help.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_help.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

