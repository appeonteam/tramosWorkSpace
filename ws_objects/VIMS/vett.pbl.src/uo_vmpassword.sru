$PBExportHeader$uo_vmpassword.sru
forward
global type uo_vmpassword from nonvisualobject
end type
end forward

global type uo_vmpassword from nonvisualobject autoinstantiate
end type

forward prototypes
public function string of_createvmpassword (string as_userid, long al_year)
end prototypes

public function string of_createvmpassword (string as_userid, long al_year);// This function creates a password for a user for VIMS Mobile for a particular year

// Parameter: as_UserID, al_Year
// Returns the password

Long ll_Value
Integer li_Loop
String ls_PW

al_Year *= al_Year   // Square Year

ll_Value = Mod(1073741824, al_Year)    // Get remainder when 2^30 is divided by value

For li_Loop = 1 to Len(as_userid)  // Add cube of ASCII of each character in userid
	ll_Value += AscA(Mid(as_UserID, li_Loop, 1)) * AscA(Mid(as_UserID, li_Loop, 1)) * AscA(Mid(as_UserID, li_Loop, 1))
Next 

ls_PW = String(ll_Value)      // Convert to string

Do While Len(ls_PW) < 6       // If less than 6 digits, add zeros to beginning
	ls_PW = '0' + ls_PW
Loop

li_Loop = Integer(Left(ls_PW, 1)) * 2   // Get value of first char and multiply by 2

ls_PW = CharA(66 + li_Loop) + Right(ls_PW, Len(ls_PW) - 1)   // Convert first char into alphabet

Return ls_PW
end function

on uo_vmpassword.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_vmpassword.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

