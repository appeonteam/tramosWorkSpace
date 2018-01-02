$PBExportHeader$uo_usersetting.sru
forward
global type uo_usersetting from nonvisualobject
end type
end forward

global type uo_usersetting from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer of_deleteallsettings (string as_userid)
public function integer of_deletesetting (string as_userid, string as_setting)
public function integer of_getsetting (string as_userid, string as_setting, ref string as_value, string as_default)
public function integer of_savesetting (string as_userid, string as_setting, string as_value)
end prototypes

public function integer of_deleteallsettings (string as_userid);// This function deletes all settings for a user.
// ONLY TO BE USED WHEN DELETING A USER IN THE USERS TABLE
// Return 1 for success, 0 for not found and -1 for error


Delete from USER_SETTINGS Where USERID = :as_UserID;

If SQLCA.SQLCode < 0 then 
	Rollback;
	Return -1
End If

If SQLCA.SQLCode = 100 then 
	Rollback;
	Return 0
End If

Commit;

Return 1
end function

public function integer of_deletesetting (string as_userid, string as_setting);// This function deletes a setting
// Return 1 for success, 0 for not found and -1 for error

as_Setting = Trim(Lower(as_Setting), True)

Delete from USER_SETTINGS Where USERID = :as_UserID and SETTINGNAME = :as_Setting;

If SQLCA.SQLCode < 0 then 
	Rollback;
	Return -1
End If

If SQLCA.SQLCode = 100 then 
	Rollback;
	Return 0
End If

Commit;

Return 1
end function

public function integer of_getsetting (string as_userid, string as_setting, ref string as_value, string as_default);// This function retrieves a user setting or returns default setting if not found.
// Returns 1 for success, -1 for error or 0 for not found

Integer li_Return

as_Setting = Trim(Lower(as_Setting), True)

Select SETTINGVALUE into :as_Value from USER_SETTINGS Where USERID = :as_UserID and SETTINGNAME = :as_Setting;

If SQLCA.SQLCode < 0 then 
	Commit;
	Return -1
End If

If SQLCA.SQLCode = 100 then 
	Commit;
	as_Value = as_Default
	Return 0 
Else	
	Commit;
	Return 1
End If
end function

public function integer of_savesetting (string as_userid, string as_setting, string as_value);// This function saves as user setting. If it already exists, it is updated. If not, it is inserted.
// Returns 1 for success, -1 for failure, 0 for no action

String ls_Value

as_Setting = Trim(Lower(as_Setting), True)

If Len(as_Setting) > 100 then 
	Messagebox("Setting Name", "Setting name cannot be more than 100 characters", Exclamation!)
	Return -1
End If

Select SETTINGVALUE into :ls_Value from USER_SETTINGS Where USERID = :as_UserID and SETTINGNAME = :as_Setting;

If SQLCA.SQLCode < 0 then 
	Commit;
	Return -1
End If

If SQLCA.SQLCode = 100 then  // Not found
	Insert Into USER_SETTINGS (USERID, SETTINGNAME, SETTINGVALUE) Values(:as_UserID, :as_Setting, :as_Value);
	If SQLCA.SQLCode < 0 then 
		Rollback;
		Return -1
	Else
		Commit;
		Return 1
	End If
Else  // Exists
	Commit;
	If as_Value = ls_Value then Return 0
	Update USER_SETTINGS Set SETTINGVALUE = :as_Value Where USERID = :as_UserID and SETTINGNAME = :as_Setting;
	If SQLCA.SQLCode < 0 then 
		Rollback;
		Return -1
	Else
		Commit;
		Return 1
	End If	
End If
end function

on uo_usersetting.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_usersetting.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

