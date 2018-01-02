$PBExportHeader$w_callws.srw
forward
global type w_callws from window
end type
type st_5 from statictext within w_callws
end type
type st_4 from statictext within w_callws
end type
type st_key from statictext within w_callws
end type
type st_type from statictext within w_callws
end type
type st_3 from statictext within w_callws
end type
type st_2 from statictext within w_callws
end type
type cb_close from commandbutton within w_callws
end type
type mle_log from multilineedit within w_callws
end type
type cb_ws from commandbutton within w_callws
end type
type gb_1 from groupbox within w_callws
end type
type gb_2 from groupbox within w_callws
end type
end forward

global type w_callws from window
integer width = 1490
integer height = 1900
boolean titlebar = true
string title = "OCIMF SIRE Web Services"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_5 st_5
st_4 st_4
st_key st_key
st_type st_type
st_3 st_3
st_2 st_2
cb_close cb_close
mle_log mle_log
cb_ws cb_ws
gb_1 gb_1
gb_2 gb_2
end type
global w_callws w_callws

type variables

SoapConnection	isoap_conn 
ws_ocimfservicessoap px_Service
tns__ocimfwsresponse lstr_Response
Blob iblb_Report
Long il_InspID
Boolean ib_Purchase=false
String is_Token=""
DataStore ids_Obs
end variables

forward prototypes
public subroutine wf_log (string as_msg)
public function string wf_gettoken (string as_acc, string as_user, string as_pwd)
public function boolean wf_invoke (string as_token, string as_method, string as_ver, string as_req)
public function string wf_getcdata (string as_xml)
public subroutine wf_save2disk (ref blob ab_data)
public subroutine wf_save2att (ref blob ablob)
public subroutine wf_populate (ref string as_xml)
private function pbdom_element wf_getchildelement (ref pbdom_element aelement, string as_elemname)
public function long wf_getobjid (string as_num)
public subroutine wf_addobs (string as_num, string as_inspcomm, string as_opcomm, string as_followup)
end prototypes

public subroutine wf_log (string as_msg);
mle_log.Text +=  as_Msg + Char(13) + Char(10)

mle_log.scroll(2)
end subroutine

public function string wf_gettoken (string as_acc, string as_user, string as_pwd);// Method to call web service and get token

String ls_T=""

Try
	wf_Log("Getting Token...")
	lstr_Response = px_Service.startwebservicesession(as_Acc, as_User, as_Pwd)
	If LastPos(lstr_Response.dataxml,"<Token>")>0 then
		ls_T = lstr_Response.dataxml
		ls_T = Right(ls_T, Len(ls_T) - 7)
		ls_T = Left(ls_T, Len(ls_T) - 8)
		wf_Log("Token Obtained.")
	Else
		wf_Log("No Token!!")
		ls_T = ""
	End If
Catch (Throwable t1)
	wf_Log(t1.GetMessage())
	ls_T=""
End Try

Return ls_T
end function

public function boolean wf_invoke (string as_token, string as_method, string as_ver, string as_req);Boolean ab_Succ

Try
	lstr_Response = px_Service.invokemethod(as_Token, as_Method, as_Ver, as_Req)
	If lstr_Response.Resultcode=1 Then
		ab_Succ = True
	Else
		ab_Succ = False
		wf_Log(lstr_Response.errormessage + "; " + lstr_Response.errorticketnumber )
	End If
Catch (Throwable t3)
	wf_Log(t3.GetMessage())
	ab_Succ = False
End Try

Return ab_Succ
end function

public function string wf_getcdata (string as_xml);// This function strips out all XML and returns the contents of the <![CDATA[]] tag

Long ll_Pos

ll_Pos = Pos(as_XML, "<![CDATA[")
If ll_Pos = 0 then Return ""

// Strip out preceeding content
as_XML = Right(as_XML, Len(as_XML) - ll_Pos - 8)

ll_Pos = Pos(as_XML, "]]>")
If ll_Pos = 0 then Return ""

// Strip trailing content
as_XML = Left(as_XML, ll_Pos - 1)

Return as_XML
end function

public subroutine wf_save2disk (ref blob ab_data);// Saves blob to disk

String ls_FPath = "Report.pdf", ls_FileName
Integer li_FileNum
Long ll_FSize

ls_FileName = ""

If GetFileSaveName("Select location to save", ls_FPath, ls_FileName) < 1 then 
	wf_Log("Cancelled by user!")
	Return
End If

If FileExists(ls_FPath) then
	If Messagebox("Confirm Overwrite", "The file " + ls_FPath + " already exists.~n~nDo you want to overwrite this file?", Question!, YesNo!) = 2 then 
		wf_Log("Cancelled by user!")
		Return
	End If
End If	
	
li_FileNum = Fileopen(ls_FPath, StreamMode!, Write!, LockReadWrite!, Replace!)
ll_FSize = FileWriteEx(li_FileNum, ab_Data)

If ll_FSize < 1 or IsNull(ll_FSize) then
	FileClose(li_FileNum)	
	wf_Log("Error - Unable to save file")
	Return
End If

FileClose(li_FileNum)

wf_Log("Report Saved!")

If Messagebox("Report Saved", "The report was saved successfully.~n~nFile Name: " + ls_FileName + "~n~nFile Size: " + String(ll_FSize, "#,###,###,##0") + " Bytes~n~nDo you want to open this file with its default application?", Question!, YesNo!) = 2 then Return

ShellExecute( Handle(this), "open", ls_FPath, "", "", 3)
end subroutine

public subroutine wf_save2att (ref blob ablob);// This function attaches the blob as report.pdf in the header attachments
// Any existing report.pdf attachment is DELETED!

Long ll_AttID=0,ll_FSize
n_vimsatt ln_Att
ln_Att = Create n_VimsAtt    // Object to save attachment in FILES database

// First get any existing report.pdf attachment
Select ATT_ID Into :ll_AttID From VETT_ATT Where Upper(FILENAME)='REPORT.PDF' And INSP_ID=:g_Obj.InspID;

Commit;

// Connect to FILES database
If ln_Att.of_Connect("") < 1 then 
	Rollback;
	Destroy ln_Att
	Messagebox ("DB Error", "Unable to connect to the files database.", Exclamation!)
	Return
End If

// Delete original attachment (if present)
If ll_AttID > 0 Then	
	Delete from VETT_ATT where ATT_ID = :ll_AttID;
	If SQLCA.Sqlcode <> 0 then	Messagebox ("DB Error", "Unable to delete original report.~n~n" + SQLCA.Sqlerrtext, Exclamation!)

	If ln_Att.of_DeleteAtt( "VETT_ATT", ll_AttID) < 0 then 
		ln_Att.of_Commit(False)
		Rollback;
		Messagebox ("DB Error", "Unable to delete the attachment.", Exclamation!)
		Destroy ln_Att
		Return	
	End If
End If

// Insert Attachment
ll_FSize = LenA(aBlob)
Insert into VETT_ATT(FILENAME, FILESIZE, INSP_ID, IMPORTED) Values ('Report.pdf', :ll_FSize, :g_obj.InspID, 1);
If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could not create new attachment in database.~n~n" + sqlca.sqlerrtext, Exclamation!)
	Rollback;
	Destroy ln_Att
	wf_Log("Failed to create attachment!")
	Return
End If

// Get ID of attachment
Select Max(ATT_ID) into :ll_AttID from VETT_ATT where INSP_ID=:g_Obj.InspID and FILESIZE=:ll_FSize and FILENAME='Report.pdf';
If SQLCA.Sqlcode <> 0 then
	Messagebox("DB Error", "Could not save file in database.~n~n" + sqlca.sqlerrtext, Exclamation!)
	wf_Log("Failed to get attachment identity!")
	Rollback;
	Destroy ln_Att
	Return
End If

// Add Attachment to FILES database
If ln_Att.of_AddAtt("VETT_ATT", ll_AttID, aBlob, ll_FSize) < 0 then
	ln_Att.of_Commit(False)	
	Rollback;
	Destroy ln_Att	
	Messagebox("DB Error", "Could not save file in database.", Exclamation!)
	wf_Log("Failed to save attachment!")
	Return
End If

ln_Att.of_Commit(True)

Destroy ln_Att    // ln_Att closes connection (for FILES DB) when destroying itself

Commit; 

wf_Log("Report attached successfully")

guo_Global.of_AddInspHist(g_obj.Inspid, 5, "Report.pdf (via OCIMF web service)") // Add to hist

guo_Global.of_UpdateLastEdit(g_Obj.InspID)   // Update LastEdit

If IsValid(w_inspdetail) then 
	w_inspdetail.ib_Modified = True
	w_inspdetail.dw_insp.Retrieve(g_Obj.InspID)  // Retrieve header
End If

end subroutine

public subroutine wf_populate (ref string as_xml);// This function creates a SIRE inspection and populates the observations 
// from the XML obtained from OCIFM

PBDom_Builder PBDom
PBDom_Document PBDoc
String ls_Errors[]
Boolean lb_RetTemp = False
Integer li_Temp, li_Err = 0

wf_Log("Importing XML...")

PBDom = Create PBDOM_Builder
PBDoc = PBdom.BuildFromString(as_XML)
//PBDoc = PBDom.BuildFromFile("C:\reportutf8.xml")  // For Test purposes only
lb_RetTemp = PBdom.GetParseErrors(ls_Errors)
If lb_RetTemp = True Then
   For li_Temp = 1 To UpperBound(ls_Errors)
      wf_Log("Parse Error : " + ls_Errors[li_Temp])
		li_Err += 1
		If li_Err=100 then 
			wf_Log("Too many errors!")
			Return
		End If
   Next
	Return
End if

wf_Log("Processing XML...")

PBDom_Element PBElem, PBQues[]
PBDom_Attribute PBAttr
PBElem = PBDoc.GetrootElement()
String ls_Num, ls_IO, ls_OP, ls_FU

ids_Obs = Create Datastore
ids_Obs.DataObject = "d_sq_tb_items"
ids_Obs.SetTransObject(SQLCA)
If ids_Obs.Retrieve(g_Obj.InspID)<0 Then 
	wf_Log("Unable to retrieve obs")
	Return
End If

PBElem = wf_getchildelement(PBElem,"Document")
PBElem.GetChildelements(PBQues)
li_Err = 0

For li_Temp = 1 to UpperBound(PBQues)  // Loop through all questions
	PBElem = wf_GetChildElement(PBQues[li_Temp],"ResponseDataType")
	If PBElem.GetText() = "SireYesNoNotSeen" Then  // If regular question
		PBElem = wf_GetChildElement(PBQues[li_Temp],"ResponseData")
		PBElem = wf_GetChildElement(PBElem,"ResponseDataYesNoNotSeen")
		If Not IsNull(PBElem) Then
			If PBElem.GetText()="N" Then // If answered 'No'
				PBAttr = PBQues[li_Temp].GetAttribute("questionNum")
				ls_Num = PBAttr.GetText()  // Question Number				
				PBElem = wf_GetChildElement(PBQues[li_Temp], "InspectorObservations")
				ls_IO = PBElem.getText( )  // Inspectors observations
				PBElem = wf_GetChildElement(PBQues[li_Temp], "OperatorCommentsInitial")
				If IsNull(PBElem) then SetNull(ls_OP) Else ls_OP = PBElem.getText( )	// Operators comments
				PBElem = wf_GetChildElement(PBQues[li_Temp], "OperatorCommentsSubsequent")
				If IsNull(PBElem) then SetNull(ls_FU) Else ls_FU = PBElem.getText( )	// Follow up
				wf_AddObs(ls_Num, ls_IO, ls_OP, ls_FU)
				li_Err += 1
			End If
		End If
	End If
Next

wf_Log("Total Obs Found: " + String(li_Err))
guo_Global.of_AddInspHist(g_Obj.InspID, 21, 'Obs Added or Updated: ' + String(li_Err))

Destroy PBDom
end subroutine

private function pbdom_element wf_getchildelement (ref pbdom_element aelement, string as_elemname);
PBDOM_Element lChildren[]

aElement.GetChildElements(lChildren)

Integer li_Loop 
For li_Loop=1 to UpperBound(lChildren)
	If lChildren[li_Loop].GetName() = as_ElemName Then Return lChildren[li_Loop]
Next

Return aElement.GetChildElement(as_ElemName)
end function

public function long wf_getobjid (string as_num);

Return 0
end function

public subroutine wf_addobs (string as_num, string as_inspcomm, string as_opcomm, string as_followup);// This function checks and add a SIRE observation to the inspection
// If the obs already exists, it is updated.

Long ll_ObjID=0
String ls_Temp
Integer li_Num[], li_Count, li_Index,li_Risk, li_RiskRating

ids_Obs.SetFilter("FullNum='" + as_Num + "'")
ids_Obs.Filter()

// Create DS for update/insert
Datastore lds_Item
lds_Item = Create DataStore
lds_Item.DataObject = "d_sq_ff_itemedit"
lds_Item.SetTransObject(SQLCA)

If ids_Obs.RowCount()>0 then  // Obs exists
	wf_Log("Updating Obs " + as_Num)
	If lds_Item.Retrieve(ids_Obs.GetItemNumber(1,"Item_ID"),0)<>1 then
		wf_Log("Failed to Retrieve " + as_Num)
		Return
	End If
Else  // Obs is new
	wf_Log("Adding Obs " + as_Num)
	lds_Item.InsertRow(0)
	lds_Item.SetItem(1, "Ans", 1)	
	lds_Item.SetItem(1, "Insp_ID", g_Obj.InspID)	
		
	// Parse string
	For li_Count = 1 to Len(as_Num)
		If Pos("0123456789", Mid(as_Num, li_Count, 1)) > 0 then
			ls_Temp += Mid(as_Num, li_Count, 1)
		Else
			If ls_Temp>"" then
				li_Index++
				li_Num[li_Index] = Integer(ls_Temp)
				ls_Temp = ""
			End If
		End If
	Next
	If ls_Temp>"" then
		li_Index++
		li_Num[li_Index] = Integer(ls_Temp)
	End If
	
	ls_Temp = ""
	
	If li_Index < 2 then 
		wf_Log("Invalid Question Number")
		Return
	End If

	Declare GetObjID Procedure FOR VETT_GETOBJ @IMID=:g_Obj.InspModel, @N1=:li_Num[1], @N2=:li_Num[2], @N3 = :li_Num[3], @N4=:li_Num[4], @N5=:li_Num[5], @N6=:li_Num[6];

	Execute GetObjID;

	If SQLCA.Sqlcode <>0 then 
		wf_Log("Error getting ObjID")
		Rollback;
	End If
	
	Fetch GetObjID into :ll_ObjID, :li_Index, :li_Risk, :ls_Temp, :li_RiskRating;
	
	Close GetObjID;

	lds_Item.SetItem(1,"Obj_ID",ll_ObjID)
	lds_Item.SetItem(1,"Risk",li_Risk)
	lds_Item.SetItem(1,"Closed",0)
	lds_Item.SetItem(1,"Def",1)	
End If

lds_Item.SetItem(1,"InspComm",as_InspComm)
lds_Item.SetItem(1,"OwnComm",as_OpComm)
If Not IsNull(as_followUp) Then lds_Item.SetItem(1,"FollowUp", as_FollowUp)

If lds_Item.Update()<0 then wf_Log("Unable to save " + as_Num)

If g_Obj.Level=0 then g_Obj.Level=1  // Flag to pass back to calling window to refresh items

Commit;
end subroutine

on w_callws.create
this.st_5=create st_5
this.st_4=create st_4
this.st_key=create st_key
this.st_type=create st_type
this.st_3=create st_3
this.st_2=create st_2
this.cb_close=create cb_close
this.mle_log=create mle_log
this.cb_ws=create cb_ws
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_5,&
this.st_4,&
this.st_key,&
this.st_type,&
this.st_3,&
this.st_2,&
this.cb_close,&
this.mle_log,&
this.cb_ws,&
this.gb_1,&
this.gb_2}
end on

on w_callws.destroy
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_key)
destroy(this.st_type)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_close)
destroy(this.mle_log)
destroy(this.cb_ws)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;
il_InspID=g_Obj.InspID

String ls_Type, ls_Key

Select OCIMFDOCTYPE, OCIMF Into :ls_Type, :ls_Key
From VETT_INSP Inner Join VETT_INSPMODEL On VETT_INSP.IM_ID=VETT_INSPMODEL.IM_ID
Where VETT_INSP.INSP_ID=:il_InspID;

st_Type.Text = ls_Type
st_Key.Text = ls_Key

g_Obj.Level=0  // Flag is set when WS is called

If IsNull(ls_Key) then
	Messagebox("Document Type Required","The Document Type for this inspection is not defined. Please define the Document Type for this inspection type in the Inspection Model section and then try again.", Exclamation!)
Else
	cb_ws.Enabled = True
End If

end event

type st_5 from statictext within w_callws
integer x = 73
integer y = 288
integer width = 1358
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 67108864
string text = "Report.pdf file will be added (or replaced) with latest version. Observations will be added or updated."
boolean focusrectangle = false
end type

type st_4 from statictext within w_callws
integer x = 55
integer y = 256
integer width = 1353
integer height = 4
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_key from statictext within w_callws
integer x = 512
integer y = 176
integer width = 896
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_type from statictext within w_callws
integer x = 512
integer y = 96
integer width = 329
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_3 from statictext within w_callws
integer x = 73
integer y = 176
integer width = 402
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Document Key:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_callws
integer x = 73
integer y = 96
integer width = 407
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Document Type:"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_callws
integer x = 494
integer y = 1680
integer width = 475
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type mle_log from multilineedit within w_callws
integer x = 55
integer y = 656
integer width = 1353
integer height = 944
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_ws from commandbutton within w_callws
integer x = 55
integer y = 416
integer width = 1344
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Call Web Service"
end type

event clicked;Boolean lb_Succ = False
String ls_Req, ls_Acc, ls_User, ls_Pwd
Integer li_RC

wf_Log("Calling Web Service...")

this.enabled=false
parent.enabled=false
cb_Close.enabled=false
Yield()
SetPointer(HourGlass!)

// Instantiate web service
Try 
	isoap_conn = create soapconnection
	px_Service = Create ws_ocimfservicessoap
	li_RC = isoap_conn.SetProxyServerOptions("address='http://10.255.237.14:8887'")  // Proxy server obtained from Rune Tipsmark to enable webservice on Citrix or VDI (CR 3289)
	If li_RC = 0 then li_RC = isoap_conn.CreateInstance(px_Service, "ws_ocimfservicessoap", "https://wsv2.ocimf-sire.com/OcimfServices.asmx")	
Catch (throwable t)
	wf_Log("CreateInstance Failed!")
	Messagebox("Web Service Failed", "Could not instatiate web service object", Exclamation!)
	cb_Close.enabled=true
	parent.enabled=true
	Return
End Try

// Check error
If li_RC>0 then
	CHOOSE CASE li_RC
		CASE 50
			wf_Log("Invalid proxy server")
		CASE 100
			wf_Log("Invalid proxy name")
		CASE 101
			wf_Log("Failed to create proxy")
		CASE ELSE
			wf_Log("Unknown error (" + String(li_rc) + ")")
	END CHOOSE
	lb_Succ = False
Else
	lb_Succ = True
End if
isoap_conn.settimeout(10000)

// Get login credentials from settings
f_Config("OCWA", ls_Acc, 0)
f_Config("OCWU", ls_User, 0)
f_Config("OCWP", ls_Pwd, 0)
If ls_Acc="" or ls_User="" or ls_Pwd="" then
	lb_Succ=False
	wf_Log("Login Credentials Missing!")
End If

// If connected, start session and obtain token (if not already obtained)
If lb_Succ And is_Token = "" Then is_Token = wf_gettoken(ls_Acc, ls_User, ls_Pwd)
//If lb_Succ Then ls_Token = wf_gettoken("10711", "24000178", "33303998")   // For TEST/DEGUB only
If Len(is_Token) = 0 then lb_Succ = False	

// Get system status
If lb_Succ Then lb_Succ = wf_Invoke(is_Token, "Common.GetSystemStatus", "1.0", "<Request/>")
If lb_Succ Then
	If LastPos(lstr_Response.dataxml,"100")>0 then
		wf_Log("Status Okay")
	Else
		wf_Log("Status Not Okay")
		lb_Succ = False
	End If
End If

blob lb_Rep
uo_Global luo_G

// If status is ok
If lb_Succ Then
	
	// Create request XML
	ls_Req = '<Request docType="' + st_Type.Text + '" docKey="' + st_Key.Text + '" includeMetadata="False" includeContents="True" documentFormat='
	ls_Req+='"APPLICATION/PDF" '
	If ib_Purchase=true then ls_Req+=' approvePurchase="True" '   // Add approval flag if necessary
	ls_Req+='/>'
	
	// Invoke WS
	wf_Log("Getting Report Document...")	
	lb_Succ = wf_Invoke(is_Token, "SIRE.GetDocument", "1.4", ls_Req)
	
	If lb_Succ Then
		wf_Log("Response Received")
		ls_Req = wf_GetCData(lstr_Response.Dataxml)   // Get CData from WS
		If ls_Req>"" Then   // If CData exists, decode base64 & save attachment
			lb_Rep = luo_G.of_Decodebase64(ls_Req)
			wf_Save2Att(lb_Rep)
		Else   // No CData received
			If Pos(lstr_Response.Dataxml,"No approval provided")>0 then    // Check if approval is required
				wf_Log("Purchase Approval Required!")
				If g_Obj.Access < 3 or g_Obj.DeptID > 1 Then   // If not VIMS Admin
  					MessageBox("Purchase Is Required", "The report inspection must be purchased from OCIMF. Please contact a VIMS Admin to purchase this report.")
					Destroy isoap_conn
					Destroy px_Service
					cb_Close.enabled = True
					wf_Log("---- Completed ----")
					Return
				End If
				// Confirm purchase, set flag & call click event again
				If MessageBox("Purchase Is Required", "The report inspection must be purchased from OCIMF. Would you like to proceed with the purchase?",Question!,YesNo!)=1 Then
					ib_Purchase=True
					Destroy isoap_conn
					Destroy px_Service
					wf_Log("Attempting to purchase...")
					this.PostEvent(Clicked!)
					Return
				End If
			ElseIf Pos(lstr_Response.Dataxml,"An error occurred attempting to purchase")>0 Then  // If error while purchasing
				wf_Log("Purchase Error!")
			Else
				wf_Log("No data found or permission denied.")    // No CData and no purchase
			End If
		End If
	End If
	If lb_Succ Then   // If document success, prepare request and get XML observations
		ls_Req = '<Request docType="' + st_Type.Text + '" docKey="' + st_Key.Text + '" includeMetadata="False" includeContents="True" documentFormat="TEXT/XML" />'
		wf_Log("Getting XML Data...")	
		lb_Succ = wf_Invoke(is_Token, "SIRE.GetDocument", "1.2", ls_Req)
		If lb_Succ Then
			wf_Log("Response Received")
			ls_Req = wf_GetCData(lstr_Response.Dataxml)  // Get CData and populate Insp
			If ls_Req>"" Then
				wf_Populate(ls_Req)
			Else
				wf_Log("No data found or permission denied")
			End If
		End If		
	End If
End If

Destroy isoap_conn
Destroy px_Service

wf_Log("---- Completed ----")

cb_Close.enabled=true
parent.enabled=true


end event

type gb_1 from groupbox within w_callws
integer x = 18
integer y = 16
integer width = 1426
integer height = 544
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Web Service Action"
end type

type gb_2 from groupbox within w_callws
integer x = 18
integer y = 576
integer width = 1426
integer height = 1072
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Web Service Log"
end type

