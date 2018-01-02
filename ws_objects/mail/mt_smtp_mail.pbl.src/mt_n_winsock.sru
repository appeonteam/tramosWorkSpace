$PBExportHeader$mt_n_winsock.sru
$PBExportComments$Winsock functions
forward
global type mt_n_winsock from mt_n_nonvisualobject
end type
type hostent from structure within mt_n_winsock
end type
type in_addr from structure within mt_n_winsock
end type
type sockaddr from structure within mt_n_winsock
end type
type wsadata from structure within mt_n_winsock
end type
end forward

type hostent from structure
	unsignedlong		h_name
	unsignedlong		h_aliases
	integer		h_addrtype
	integer		h_length
	unsignedlong		h_addr_list
end type

type in_addr from structure
	unsignedlong		s_addr
end type

type sockaddr from structure
	integer		sin_family
	unsignedinteger		sin_port
	in_addr		sin_addr
	character		sin_zero[8]
end type

type wsadata from structure
	unsignedinteger		wversion
	unsignedinteger		whighversion
	character		szdescription[257]
	character		szsystemstatus[129]
	unsignedinteger		imaxsockets
	unsignedinteger		imaxudpdg
	unsignedlong		lpvenderinfo
end type

global type mt_n_winsock from mt_n_nonvisualobject autoinstantiate
end type

type prototypes
Subroutine CopyMemoryIP ( &
	Ref structure Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine CopyMemoryIP ( &
	Ref blob Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine CopyMemoryIP ( &
	Ref ulong Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Function ulong FormatMessage( &
	ulong dwFlags, &
	ulong lpSource, &
	ulong dwMessageId, &
	ulong dwLanguageId, &
	Ref string lpBuffer, &
	ulong nSize, &
	ulong Arguments &
	) Library "kernel32.dll" Alias For "FormatMessageW"

Function boolean CryptBinaryToString ( &
	Blob pbBinary, &
	ulong cbBinary, &
	ulong dwFlags, &
	Ref string pszString, &
	Ref ulong pcchString &
	) Library "crypt32.dll" Alias For "CryptBinaryToStringW"

Function boolean CryptStringToBinary ( &
	string pszString, &
	ulong cchString, &
	ulong dwFlags, &
	Ref blob pbBinary, &
	Ref ulong pcbBinary, &
	Ref ulong pdwSkip, &
	Ref ulong pdwFlags &
	) Library "crypt32.dll" Alias For "CryptStringToBinaryW"

Function ulong WNetGetUser ( &
	string lpname, &
	Ref string lpusername, &
	Ref ulong buflen &
	) Library "mpr.dll" Alias For "WNetGetUserW"

// Winsock functions in alphabetical order

Function uint accept ( &
	uint socket, &
	Ref sockaddr addr, &
	Ref integer addrlen &
	) Library "ws2_32.dll" alias for "accept;Ansi"

Function integer bind ( &
	uint socket, &
	sockaddr name, &
	integer namelen &
	)  Library "ws2_32.dll" alias for "bind"

Function integer closesocket ( &
	uint socket &
	) Library "ws2_32.dll"

Function integer connect_ws ( &
	uint socket, &
	sockaddr name, &
	integer namelen &
	) Library "ws2_32.dll" Alias For "connect"

Function ulong gethostbyaddr ( &
	Ref ulong addr, &
	integer len, &
	integer htype &
	) Library "ws2_32.dll"

Function integer gethostname ( &
	Ref string name, &
	integer namelen &
	) Library "ws2_32.dll" alias for "gethostname;Ansi"

Function ulong gethostbyname ( &
	string name &
	) Library "ws2_32.dll" alias for "gethostbyname;Ansi"

Function Integer getpeername ( &
	uint socket, &
	Ref sockaddr name, &
	Ref integer namelen &
	) Library "ws2_32.dll" Alias For "getpeername;Ansi"

Function integer getsockopt ( &
	uint socket, &
	integer level, &
	integer optname, &
	ref integer optval, &
	ref integer optlen &
	) Library "ws2_32.dll"  

Function ulong htonl ( &
	ulong hostulong &
	) Library "ws2_32.dll"  

Function uint htons ( &
	uint hostshort &
	) Library "ws2_32.dll"  

Function ulong inet_addr ( &
	string cp &
	) Library "ws2_32.dll" alias for "inet_addr;Ansi"

Function string inet_ntoa ( &
	ulong sin_addr &
	) Library "ws2_32.dll" alias for "inet_ntoa"

Function integer listen ( &
	uint socket, &
	integer backlog &
	) Library "ws2_32.dll"  

Function ulong ntohl ( &
	ulong netlong &
	) Library "ws2_32.dll"

Function integer recv ( &
	uint socket, &
	Ref blob buf, &
	integer len, &
	integer flags &
	) Library "ws2_32.dll"  

Function integer recvfrom ( &
	uint socket, &
	Ref blob buf, &
	integer len, &
	integer flags, &
	Ref sockaddr fromaddr, &
	Ref integer fromlen &
	)  Library "ws2_32.dll" alias for "recvfrom"

Function integer send ( &
	uint socket, &
	Ref blob buf, &
	integer len, &
	integer flags &
	) Library "ws2_32.dll"  

Function integer sendto ( &
	uint socket, &
	blob buf, &
	integer len, &
	integer flags, &
	sockaddr toaddr, &
	integer tolen &
	)  Library "ws2_32.dll" alias for "sendto"

Function uint socket ( &
	integer af, &
	integer ttype, &
	integer protocol &
	) Library "ws2_32.dll"  

Function integer WSACleanup ( &
	) Library "ws2_32.dll"

Function integer WSAGetLastError ( &
	) Library "ws2_32.dll"  

Function integer WSAStartup ( &
	ulong wVersionRequested, &
	Ref wsadata lpWSAData &
	) Library "ws2_32.dll" alias for "WSAStartup"

Function integer WSAAsyncSelect ( &
	uint socket, &
	long hWnd, &
	uint wMsg, &
	long lEvent &
	) Library "ws2_32.dll"  

Function integer WSAAddressToString ( &
	sockaddr lpsaAddress, &
	ulong dwAddressLength, &
	ulong lpProtocolInfo, &
	Ref string lpszAddressString, &
	Ref ulong lpdwAddressStringLength &
	) Library "ws2_32.dll"  Alias For "WSAAddressToStringW"

end prototypes

type variables
Private:
wsadata istr_wsadata
Boolean ib_initialized = False
Boolean ib_send_unicode = True
Boolean ib_recv_unicode = True
Boolean ib_jaguarlog = False
Boolean ib_messagebox = True

Public:
Constant Integer MAXGETSOCKADDRSTRUCT = 16
Constant Integer AF_INET = 2
Constant Integer SOCK_STREAM = 1
Constant Integer SOCK_DGRAM = 2
Constant Integer IPPROTO_UDP = 17
Constant ULong INADDR_ANY = 0
Constant UInt SOCKET_ERROR = -1
Constant UInt INVALID_SOCKET = 0
Constant ULong CRYPT_STRING_BASE64 = 1
Constant Integer MAX_RECV_BUFFER = 32766
Constant Integer MAX_SEND_BUFFER = 8192
Constant Integer iINFO  = 0
Constant Integer iDEBUG = 1
Constant Integer iERROR = 2
String is_msgtext
Integer ii_msglevel

end variables

forward prototypes
public subroutine of_logerror (integer ai_msglevel, string as_msgtext)
public function string of_getlasterror ()
public function string of_geterrormsg (unsignedlong aul_error)
public function integer of_startup ()
public function integer of_cleanup ()
public function unsignedinteger of_connect (string as_hostname, integer ai_port)
public function blob of_decode64 (string as_encoded)
public function string of_encode64 (blob ablob_data)
public function string of_getdescription ()
public subroutine of_setunicode (boolean ab_send, boolean ab_recv)
public function string of_gethostname ()
public function string of_getipaddress (string as_hostname)
public function string of_gethostname (string as_ipaddress)
public function integer of_getsockopt (unsignedinteger aui_socket, string as_optname)
public function string of_getuserid ()
public function unsignedinteger of_listen (integer ai_port, long al_handle, integer ai_event)
public function integer of_recv (unsignedinteger aui_socket, ref blob ablob_data)
public function integer of_recv (unsignedinteger aui_socket, ref string as_data)
public function integer of_send (unsignedinteger aui_socket, string as_data)
public function integer of_send (unsignedinteger aui_socket, blob ablob_data)
public subroutine of_setjaguarlog (boolean ab_jaguarlog)
public function long of_parse (string as_text, string as_sep, ref string as_array[])
public function unsignedinteger of_accept (unsignedinteger aui_socket, ref string as_ipaddress)
public subroutine of_setmessagebox (boolean ab_messagebox)
public function integer of_close (ref unsignedinteger aui_socket)
public function integer of_getpeername (unsignedinteger aui_socket, ref string as_ipaddress, ref integer ai_port)
public function integer of_recvfrom (integer ai_port, ref string as_data, ref string as_ipaddress)
public function integer of_recvfrom (integer ai_port, ref blob ablob_data, ref string as_ipaddress)
public function integer of_sendto (string as_ipaddress, integer ai_port, string as_data)
public function integer of_sendto (string as_ipaddress, integer ai_port, blob ablob_data)
public subroutine documentation ()
end prototypes

public subroutine of_logerror (integer ai_msglevel, string as_msgtext);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_LogError
//
// PURPOSE:    This function writes a string to the Jaguar log file.
//
// ARGUMENTS:  ai_msglevel	- The level of message importance
//					as_msgtext	- The text of the message
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_msg
TransactionServer lts_jag
ErrorLogging lel_jag

// save the error message
is_msgtext  = as_msgtext
ii_msglevel = ai_msglevel

If ib_jaguarlog Then
	// get reference to transaction service
	GetContextService("TransactionServer", lts_jag)
	// get reference to error logging service
	GetContextService("ErrorLogging", lel_jag)
	// build message text
	choose case ai_msglevel
		case iINFO
			ls_msg = this.ClassName() + " (Info!)->" + as_msgtext
		case iDEBUG
			ls_msg = this.ClassName() + " (Debug)->" + as_msgtext
		case iERROR
			ls_msg = this.ClassName() + " (Error)->" + as_msgtext
		case else
			ls_msg = this.ClassName() + &
					" (" + String(ai_msglevel) + ")->" + as_msgtext
	end choose
	// log message to server log
	lel_jag.Log(ls_msg)
Else
	If ib_messagebox Then
		choose case ai_msglevel
			case iINFO
				MessageBox(	"Winsock Info Msg", &
							as_msgtext, Information!)
			case iDEBUG
				MessageBox(	"Winsock Debug Msg", &
							as_msgtext, Information!)
			case iERROR
				MessageBox(	"Winsock Error Msg", &
							as_msgtext, StopSign!)
			case else
				MessageBox(	"Winsock Msg Level " + String(ai_msglevel), &
							as_msgtext, Information!)
		end choose
	End If
End If

end subroutine

public function string of_getlasterror ();// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_GetLastError
//
// PURPOSE:		This function returns the message text for
//					the most recent Winsock error.
//
// RETURN:		Counter value
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

ULong lul_error
String ls_errmsg

lul_error = WSAGetLastError()

If lul_error = 0 Then
	ls_errmsg = "An unknown error has occurred!"
Else
	ls_errmsg = of_GetErrorMsg(lul_error)
End If

Return ls_errmsg

end function

public function string of_geterrormsg (unsignedlong aul_error);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_GetErrorMsg
//
// PURPOSE:    This function returns the error message that goes
//					with the error code from GetLastError.
//
// ARGUMENTS:  aul_error - Error code from GetLastError
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
String ls_buffer
ULong lul_rtn

ls_buffer = Space(200)

lul_rtn = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, &
				aul_error, LANG_NEUTRAL, ls_buffer, 200, 0)

Return Trim(ls_buffer)

end function

public function integer of_startup ();// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Startup
//
// PURPOSE:    This function initiates use of the socket library.
//
// RETURN:      0 = Success
//					-1 = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_errmsg

If Not ib_initialized Then
	If wsastartup(257, istr_wsadata) = 0 Then
		ib_initialized = True
	Else
		ls_errmsg = of_GetLastError()
		this.of_LogError(iERROR, &
			"Winsock Error in of_Startup: " + ls_errmsg)
		Return -1
	End If
End If

Return 0

end function

public function integer of_cleanup ();// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Cleanup
//
// PURPOSE:    This function terminates use of the socket library.
//
// RETURN:      0 = Success
//					-1 = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_errmsg

If ib_initialized Then
	If wsacleanup() = 0 Then
		ib_initialized = False
	Else
		ls_errmsg = of_GetLastError()
		this.of_LogError(iERROR, &
			"Winsock Error in of_Cleanup: " + ls_errmsg)
		Return -1
	End If
End If

Return 0

end function

public function unsignedinteger of_connect (string as_hostname, integer ai_port);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Connect
//
// PURPOSE:    This function opens a socket for SEND and RECV.
//
// ARGUMENTS:  as_hostname - Hostname
//					ai_port		- Port
//
// RETURN:      0 = Error
//					>0 = Success ( a valid socket )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

HOSTENT lstr_hostent
SOCKADDR lstr_sockaddr
String ls_errmsg
UInt lui_socket
ULong lul_ptr, lul_ipaddr

// get information about host
lul_ptr = gethostbyname(as_hostname)

If lul_ptr > 0 Then
	CopyMemoryIp(lstr_hostent, lul_ptr, MAXGETSOCKADDRSTRUCT)
	CopyMemoryIp(lul_ipaddr, lstr_hostent.h_Addr_List, lstr_hostent.h_Length)
	CopyMemoryIp(lstr_sockaddr.sin_addr, lul_ipaddr, lstr_hostent.h_Length)
	lstr_sockaddr.sin_family = AF_INET
	lstr_sockaddr.sin_port = htons(ai_port)
	lui_socket = socket(AF_INET, SOCK_STREAM, 0)
	If connect_ws(lui_socket, lstr_sockaddr, MAXGETSOCKADDRSTRUCT) = -1 Then
		ls_errmsg = of_GetLastError()
		this.of_LogError(iERROR, &
			"Winsock Error in of_Connect: " + ls_errmsg)
		lui_socket = 0
	End if
Else
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Connect: " + ls_errmsg)
	lui_socket = 0
End If

Return lui_socket

end function

public function blob of_decode64 (string as_encoded);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Decode64
//
// PURPOSE:    This function converts a Base64 encoded string to binary.
//
//					Note: Requires Windows XP or Server 2003
//
// ARGUMENTS:  as_encoded - String containing encoded data
//
// RETURN:     Blob containing decoded data
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob lblob_data
ULong lul_len, lul_buflen, lul_skip, lul_pflags
Boolean lb_rtn

lul_len = Len(as_encoded)
lul_buflen = lul_len
lblob_data = Blob(Space(lul_len))

lb_rtn = CryptStringToBinary(as_encoded, &
					lul_len, CRYPT_STRING_BASE64, lblob_data, &
					lul_buflen, lul_skip, lul_pflags)

Return BlobMid(lblob_data, 1, lul_buflen)

end function

public function string of_encode64 (blob ablob_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Encode64
//
// PURPOSE:    This function converts binary data to a Base64 encoded string.
//
//					Note: Requires Windows XP or Server 2003
//
// ARGUMENTS:  ablob_data - Blob containing data
//
// RETURN:     String containing encoded data
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_encoded
ULong lul_len, lul_buflen
Boolean lb_rtn

lul_len = Len(ablob_data)

lul_buflen = lul_len * 2

ls_encoded = Space(lul_buflen)

lb_rtn = CryptBinaryToString(ablob_data, &
				lul_len, CRYPT_STRING_BASE64, &
				ls_encoded, lul_buflen)
If Not lb_rtn Then ls_encoded = ""

Return ls_encoded

end function

public function string of_getdescription ();// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_GetDescription
//
// PURPOSE:    This function returns the winsock description.
//
// RETURN:     String containing a description of the
//					winsock library.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob lblob_desc

lblob_desc = Blob(istr_wsadata.szDescription)

Return String(lblob_desc, EncodingAnsi!)

end function

public subroutine of_setunicode (boolean ab_send, boolean ab_recv);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_SetUnicode
//
// PURPOSE:    This function sets Unicode data option.
//
// ARGUMENTS:  ab_send - of_Send Unicode setting
//					ab_recv - of_Recv Unicode setting
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

ib_send_unicode = ab_send
ib_recv_unicode = ab_recv

end subroutine

public function string of_gethostname ();// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_GetHostName
//
// PURPOSE:		This function retrieves the standard host name
//					for the local computer.
//
// RETURN:		Host name
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_hostname, ls_errmsg
Integer li_rc, li_namelen

li_namelen = 32
ls_hostname = Space(li_namelen)

li_rc = gethostname(ls_hostname, li_namelen)
If li_rc <> 0 Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_GetHostName: " + ls_errmsg)
End If

Return ls_hostname

end function

public function string of_getipaddress (string as_hostname);// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_GetIPAddress
//
// PURPOSE:		This function finds the IP address for the
//					specified host name.
//
// ARGUMENTS:	as_hostname	- host name of a server
//
// RETURN:		IP Address
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_ipaddress, ls_errmsg
Blob lblb_ipaddr
HOSTENT lstr_host
ULong lul_ptr, lul_ipaddr

// get information about host
lul_ptr = gethostbyname(as_hostname)

If lul_ptr > 0 Then
	// copy structure to local structure
	CopyMemoryIP(lstr_host, lul_ptr, 16)
	// get memory address where ipaddress is located
	CopyMemoryIP(lul_ipaddr, lstr_host.h_addr_list, 4)
	// copy ipaddress to local blob
	lblb_ipaddr = Blob(Space(4))
	CopyMemoryIP(lblb_ipaddr, lul_ipaddr, 4)
	// convert blob to string ip address
	ls_ipaddress  = String(AscA(String(BlobMid(lblb_ipaddr,1,1),EncodingAnsi!)),"##0") + "."
	ls_ipaddress += String(AscA(String(BlobMid(lblb_ipaddr,2,1),EncodingAnsi!)),"##0") + "."
	ls_ipaddress += String(AscA(String(BlobMid(lblb_ipaddr,3,1),EncodingAnsi!)),"##0") + "."
	ls_ipaddress += String(AscA(String(BlobMid(lblb_ipaddr,4,1),EncodingAnsi!)),"##0")
Else
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_GetIPAddress: " + ls_errmsg)
End If

Return ls_ipaddress

end function

public function string of_gethostname (string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_GetHostName
//
// PURPOSE:		This function finds the host name that corresponds to the
//					specified IP Address.
//
// ARGUMENTS:	as_ipaddress	- IP Address of a server
//
// RETURN:		IP Address
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_hostname, ls_errmsg
ULong lul_address, lul_ptr
Blob lblb_host
HOSTENT lstr_host

lul_address = inet_addr(as_ipaddress)
If lul_address > 0 Then
	// get information about host
	lul_ptr = gethostbyaddr(lul_address, 4, AF_INET)
	// copy structure to local structure
	CopyMemoryIP(lstr_host, lul_ptr, 16)
	// copy hostname to local blob
	lblb_host = Blob(Space(250))
	CopyMemoryIP(lblb_host, lstr_host.h_name, 250)
	ls_hostname = String(lblb_host, EncodingAnsi!)
Else
	ls_errmsg = "The given IP Address is invalid!"
	this.of_LogError(iERROR, &
		"Winsock Error in of_GetHostName: " + ls_errmsg)
End If

Return ls_hostname

end function

public function integer of_getsockopt (unsignedinteger aui_socket, string as_optname);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_GetSockOpt
//
// PURPOSE:    This function returns options that use long datatype.
//
// ARGUMENTS:  aui_socket	- Open socket
//					as_optname	- Option name
//
// RETURN:		Buffer size
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant Long SOL_SOCKET = 65535
Integer li_rc, li_buflen, li_optname, li_optvalue
String ls_errmsg

li_buflen = 4

choose case Upper(as_optname)
	case "SO_ERROR"
		li_optname = 4103
	case "SO_RCVBUF"
		li_optname = 4098
	case "SO_SNDBUF"
		li_optname = 4097
	case "SO_TYPE"
		li_optname = 4104
	case else
		ls_errmsg = "Invalid Option Provided: " + as_optname
		this.of_LogError(iERROR, &
			"Winsock Error in of_GetSockOpt: " + ls_errmsg)
end choose

// get option value
li_rc = getsockopt(aui_socket, SOL_SOCKET, &
				li_optname, li_optvalue, li_buflen)
If li_rc = -1 Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_GetSockOpt: " + ls_errmsg)
End If

Return li_optvalue

end function

public function string of_getuserid ();// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_GetUserid
//
// PURPOSE:		This function retrieves the userid used to establish
//					the current network connection.
//
// RETURN:		The userid or empty string if error occurred.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_userid, ls_errmsg
ULong lul_result, lul_buflen

lul_buflen = 32
ls_userid = Space(lul_buflen)

lul_result = WNetGetUser("", ls_userid, lul_buflen)
If lul_result <> 0 Then
	ls_errmsg = of_GetErrorMsg(lul_result)
	this.of_LogError(iERROR, &
		"Network Error in of_GetUserid: " + ls_errmsg)
End If

Return ls_userid

end function

public function unsignedinteger of_listen (integer ai_port, long al_handle, integer ai_event);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Listen
//
// PURPOSE:    This function opens a socket and Listens.
//
// ARGUMENTS:  ai_port	 - Port number
//					al_handle - Handle of object to receive messages
//					ai_event  - pbm_customxx event to receive messages
//
// RETURN:      0 = Error
//					>0 = Success
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant Integer WM_USER = 1024
Constant Long FD_ACCEPT = 8
HOSTENT lstr_hostent
SOCKADDR lstr_sockaddr
String ls_errmsg, ls_hostname
UInt lui_socket
ULong lul_ptr, lul_ipaddr

// get information about host
ls_hostname = of_GetHostname()
lul_ptr = gethostbyname(ls_hostname)

If lul_ptr > 0 Then
	CopyMemoryIp(lstr_hostent, lul_ptr, MAXGETSOCKADDRSTRUCT)
	CopyMemoryIp(lul_ipaddr, lstr_hostent.h_Addr_List, lstr_hostent.h_Length)
	CopyMemoryIp(lstr_sockaddr.sin_addr, lul_ipaddr, lstr_hostent.h_Length)
	lstr_sockaddr.sin_family = AF_INET
	lstr_sockaddr.sin_port = htons(ai_port)
	lui_socket = socket(AF_INET, SOCK_STREAM, 0)
	If bind(lui_socket, lstr_sockaddr, MAXGETSOCKADDRSTRUCT) = -1 Then
		ls_errmsg = of_GetLastError()
		this.of_LogError(iERROR, &
			"Winsock Error in of_Listen: " + ls_errmsg)
		lui_socket = 0
	Else
		If WSAASyncSelect(lui_socket, al_handle, WM_USER + (ai_event - 1), FD_ACCEPT) = -1 Then
			ls_errmsg = of_GetLastError()
			this.of_LogError(iERROR, &
				"Winsock Error in of_Listen: " + ls_errmsg)
			lui_socket = 0
		Else
			If listen(lui_socket, 10) = -1 Then
				ls_errmsg = of_GetLastError()
				this.of_LogError(iERROR, &
					"Winsock Error in of_Listen: " + ls_errmsg)
				lui_socket = 0
			End If
		End If
	End If
Else
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Listen: " + ls_errmsg)
	lui_socket = 0
End If

Return lui_socket

end function

public function integer of_recv (unsignedinteger aui_socket, ref blob ablob_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Recv
//
// PURPOSE:    This function receives data from a connected socket.
//
// ARGUMENTS:  aui_socket	- Open socket
//					ablob_data	- By ref blob
//
// RETURN:     Length of the returned data
//					-1 if an error occurred
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Integer li_bytes
String ls_errmsg

ablob_data = Blob(Space(MAX_RECV_BUFFER))

li_bytes = recv(aui_socket, ablob_data, MAX_RECV_BUFFER, 0)
If li_bytes = SOCKET_ERROR Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Recv: " + ls_errmsg)
Else
	ablob_data = BlobMid(ablob_data, 1, li_bytes)
End If

Return li_bytes

end function

public function integer of_recv (unsignedinteger aui_socket, ref string as_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Recv
//
// PURPOSE:    This function receives data from a connected socket.
//
// ARGUMENTS:  aui_socket	- Open socket
//					as_data		- By ref string
//
// RETURN:     Length of the returned data
//					-1 if an error occurred
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob lblob_data
Integer li_bytes

li_bytes = of_Recv(aui_socket, lblob_data)
If li_bytes = SOCKET_ERROR Then
	SetNull(as_data)
Else
	If ib_recv_unicode Then
		as_data = String(lblob_data)
	Else
		as_data = String(lblob_data, EncodingAnsi!)
	End If
End If

Return li_bytes

end function

public function integer of_send (unsignedinteger aui_socket, string as_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Send
//
// PURPOSE:    This function sends data on a connected socket.
//
// ARGUMENTS:  aui_socket	- Open socket
//					as_data		- Data to send
//
// RETURN:     Number of bytes successfully sent
//					-1 if an error occurred
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob lblb_data

If ib_send_unicode Then
	lblb_data = Blob(as_data)
Else
	lblb_data = Blob(as_data, EncodingAnsi!)
	
	if len(lblb_data) <> len(as_data) then
		lblb_data = Blob(as_data, EncodingUTF8!)
	end if
End If

Return of_Send(aui_socket, lblb_data)

end function

public function integer of_send (unsignedinteger aui_socket, blob ablob_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Send
//
// PURPOSE:    This function sends data on a connected socket.
//
// ARGUMENTS:  aui_socket	- Open socket
//					ablob_data	- Data to send
//
// RETURN:     Number of bytes successfully sent
//					-1 if an error occurred
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Integer li_rc, li_datalen
String ls_errmsg

li_datalen = Len(ablob_data)

li_rc = send(aui_socket, ablob_data, li_datalen, 0)
If li_rc = -1 Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Send: " + ls_errmsg)
End If

Return li_rc

end function

public subroutine of_setjaguarlog (boolean ab_jaguarlog);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_SetJaguarlog
//
// PURPOSE:    This function sets the Jaguar logging option.
//
// ARGUMENTS:  ab_jaguarlog - Whether errors get logged to Jaguar log.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

ib_jaguarlog = ab_jaguarlog

end subroutine

public function long of_parse (string as_text, string as_sep, ref string as_array[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Parse
//
// PURPOSE:    This function parses a string into an array.
//
// ARGUMENTS:  as_text	- The string to be separated
//					as_sep	- The separator characters
//					as_array	- By ref output array
//
//	RETURN:		The number of items in the array
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_empty[], ls_work
Long ll_pos, ll_each

as_array = ls_empty

If IsNull(as_text) Or as_text = "" Then Return 0

ll_pos = Pos(as_text, as_sep)
DO WHILE ll_pos > 0
	ls_work = Trim(Left(as_text, ll_pos - 1))
	as_text = Trim(Mid(as_text, ll_pos + 1))
	as_array[UpperBound(as_array) + 1] = ls_work
	ll_pos = Pos(as_text, as_sep)
LOOP
as_array[UpperBound(as_array) + 1] = Trim(as_text)

Return UpperBound(as_array)

end function

public function unsignedinteger of_accept (unsignedinteger aui_socket, ref string as_ipaddress);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Accept
//
// PURPOSE:    This function permits an incoming connection
//					attempt on a socket.
//
// ARGUMENTS:  aui_socket		- Open socket
//					as_ipaddress	- IP Address of remote machine
//
// RETURN:     -1 = Error
//					>0 = Success ( a valid socket )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

SOCKADDR lstr_sockaddr
UInt lui_socket
Integer li_length
ULong lul_ipaddr
String ls_errmsg, ls_ipaddress, ls_part[]

li_length = MAXGETSOCKADDRSTRUCT

lstr_sockaddr.sin_zero[8] = ""

lui_socket = accept(aui_socket, lstr_sockaddr, li_length)
If lui_socket < 1 Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Accept: " + ls_errmsg)
	Return -1
End If

// format incoming IP address
lul_ipaddr = ntohl(lstr_sockaddr.sin_addr.s_addr)
ls_ipaddress = String(Blob(inet_ntoa(lul_ipaddr)), EncodingAnsi!)

// reverse the order of the parts
of_Parse(ls_ipaddress, ".", ls_part)
as_ipaddress = ls_part[4] + "." + ls_part[3] + "." + &
					ls_part[2] + "." + ls_part[1]

Return lui_socket

end function

public subroutine of_setmessagebox (boolean ab_messagebox);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_SetMessageBox
//
// PURPOSE:    This function sets the MessageBox option.
//
// ARGUMENTS:  ab_messagebox - Whether errors are displayed.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

ib_messagebox = ab_messagebox

end subroutine

public function integer of_close (ref unsignedinteger aui_socket);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_Close
//
// PURPOSE:    This function closes an open socket.
//
// ARGUMENTS:  aui_socket - Open socket
//
// RETURN:      0 = Success
//					-1 = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

Integer li_rc
String ls_errmsg

li_rc = closesocket(aui_socket)
If li_rc = 0 Then
	aui_socket = 0
Else
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Close: " + ls_errmsg)
	Return -1
End If

Return 0

end function

public function integer of_getpeername (unsignedinteger aui_socket, ref string as_ipaddress, ref integer ai_port);// -----------------------------------------------------------------------------
// SCRIPT:     n_winsock.of_GetPeerName
//
// PURPOSE:    This function returns the IP Address of the computer on the
//					other end of the socket.
//
// ARGUMENTS:  aui_socket		- Open socket
//					as_ipaddress	- Peer IP Address ( by ref )
//					ai_port			- Peer Port ( by ref )
//
// RETURN:      0 = Error
//					>0 = Success
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/29/2006	RolandS		Initial coding
// -----------------------------------------------------------------------------

SOCKADDR lstr_sockaddr
Integer li_length, li_rtn, li_pos
String ls_errmsg, ls_ipaddress
ULong lul_strlen

li_length = MAXGETSOCKADDRSTRUCT

lstr_sockaddr.sin_zero[8] = ""

li_rtn = getpeername(aui_socket, lstr_sockaddr, li_length)
If li_rtn <> 0 Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Accept: " + ls_errmsg)
	Return li_rtn
End If

// get the ip address in readable format
lul_strlen = 20
ls_ipaddress = Space(lul_strlen)
li_rtn = WSAAddressToString(lstr_sockaddr, &
					li_length, 0, ls_ipaddress, lul_strlen)
If li_rtn <> 0 Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_Accept: " + ls_errmsg)
	Return li_rtn
End If

// separate address & port
li_pos = Pos(ls_ipaddress, ":")
as_ipaddress = Left(ls_ipaddress, li_pos - 1)
ai_port = Integer(Mid(ls_ipaddress, li_pos + 1))

Return 0

end function

public function integer of_recvfrom (integer ai_port, ref string as_data, ref string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_RecvFrom
//
// PURPOSE:		This function receives a UDP packet.
//
// ARGUMENTS:  ai_port			- The port to receive the packet on
//					as_data			- Buffer to hold the data (by ref)
//					as_ipaddress	- Sending IP Address (by ref)
//
// RETURN:		Number of bytes received
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/15/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob lblob_data
Integer li_bytes

lblob_data = Blob(as_data)

li_bytes = of_RecvFrom(ai_port, lblob_data, as_ipaddress)
If li_bytes = SOCKET_ERROR Then
	SetNull(as_data)
Else
	If ib_recv_unicode Then
		as_data = String(lblob_data)
	Else
		as_data = String(lblob_data, EncodingAnsi!)
	End If
End If

Return li_bytes

end function

public function integer of_recvfrom (integer ai_port, ref blob ablob_data, ref string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_RecvFrom
//
// PURPOSE:		This function receives a UDP packet.
//
// ARGUMENTS:  ai_port			- The port to receive the packet on
//					ablob_data		- Buffer to hold the data (by ref)
//					as_ipaddress	- Sending IP Address (by ref)
//
// RETURN:		Number of bytes received
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/15/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

SOCKADDR lstr_RecvAddr, lstr_SenderAddr
UInt lui_RecvSocket
ULong lul_ipaddr
Integer li_bytes, li_BufLen, li_SenderAddrSize
String ls_errmsg, ls_ipaddress, ls_part[]

li_SenderAddrSize = MAXGETSOCKADDRSTRUCT

li_BufLen = Len(ablob_data)

lui_RecvSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)

lstr_RecvAddr.sin_family = AF_INET
lstr_RecvAddr.sin_port = htons(ai_port)
lstr_RecvAddr.sin_addr.s_addr = htonl(INADDR_ANY)

bind(lui_RecvSocket, lstr_RecvAddr, MAXGETSOCKADDRSTRUCT)

li_bytes = recvfrom(lui_RecvSocket, ablob_data, li_BufLen, &
						0, lstr_SenderAddr, li_SenderAddrSize);
If li_bytes = SOCKET_ERROR Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_RecvFrom: " + ls_errmsg)
Else
	// trim off trailing blanks
	ablob_data = BlobMid(ablob_data, 1, li_bytes)
	// format incoming IP address
	lul_ipaddr = ntohl(lstr_SenderAddr.sin_addr.s_addr)
	ls_ipaddress = String(Blob(inet_ntoa(lul_ipaddr)), EncodingAnsi!)
	// reverse the order of the parts
	of_Parse(ls_ipaddress, ".", ls_part)
	as_ipaddress = ls_part[4] + "." + ls_part[3] + "." + &
						ls_part[2] + "." + ls_part[1]
End If

closesocket(lui_RecvSocket)

Return li_bytes

end function

public function integer of_sendto (string as_ipaddress, integer ai_port, string as_data);// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_SendTo
//
// PURPOSE:		This function sends a UDP packet.
//
// ARGUMENTS:  as_ipaddress	- The IP Address to send to
//					ai_port			- The Port to send to
//					as_data			- Data to be sent
//
// RETURN:		Number of bytes sent
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/15/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob lblb_data

If ib_send_unicode Then
	lblb_data = Blob(as_data)
Else
	lblb_data = Blob(as_data, EncodingAnsi!)
End If

Return of_SendTo(as_ipaddress, ai_port, lblb_data)

end function

public function integer of_sendto (string as_ipaddress, integer ai_port, blob ablob_data);// -----------------------------------------------------------------------------
// FUNCTION:	n_winsock.of_SendTo
//
// PURPOSE:		This function sends a UDP packet.
//
// ARGUMENTS:  as_ipaddress	- The IP Address to send to
//					ai_port			- The Port to send to
//					ablob_data		- Data to be sent
//
// RETURN:		Number of bytes sent
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/15/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

SOCKADDR lstr_RecvAddr
UInt lui_SendSocket
Integer li_cnt, li_BufLen, li_RecvAddrSize
String ls_errmsg

li_RecvAddrSize = MAXGETSOCKADDRSTRUCT

li_BufLen = Len(ablob_data)

lui_SendSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)

lstr_RecvAddr.sin_family = AF_INET
lstr_RecvAddr.sin_port = htons(ai_port)
lstr_RecvAddr.sin_addr.s_addr = inet_addr(as_ipaddress)

li_cnt = sendto(lui_SendSocket, ablob_data, li_BufLen, &
				0, lstr_RecvAddr, li_RecvAddrSize)
If li_cnt = SOCKET_ERROR Then
	ls_errmsg = of_GetLastError()
	this.of_LogError(iERROR, &
		"Winsock Error in of_SendTo: " + ls_errmsg)
End If

closesocket(lui_SendSocket)

Return li_cnt

end function

public subroutine documentation ();/********************************************************************
   ObjectName: mt_n_winsock
	
	<OBJECT>
		Ancestor object for mt_n_smtp.  Standard functions to control mail
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
   Date   		Ref    	Author   	Comments
	??/??/?? 	?      	Name Here	First Version
	03/08/12 	CR2892   AGL027   	Moved into MT framework
	21/08/13    CR3312   ZSW001      Email engine stopped working.
********************************************************************/

end subroutine

on mt_n_winsock.create
call super::create
end on

on mt_n_winsock.destroy
call super::destroy
end on

event destructor;// perform cleanup
of_Cleanup()

end event

event constructor;// sockets not initialized
ib_initialized = False

end event

