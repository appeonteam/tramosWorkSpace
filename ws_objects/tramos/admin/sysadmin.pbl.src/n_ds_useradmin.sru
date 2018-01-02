$PBExportHeader$n_ds_useradmin.sru
forward
global type n_ds_useradmin from mt_n_datastore
end type
end forward

global type n_ds_useradmin from mt_n_datastore
end type
global n_ds_useradmin n_ds_useradmin

on n_ds_useradmin.create
call super::create
end on

on n_ds_useradmin.destroy
call super::destroy
end on

event dberror;call super::dberror;if sqldbcode = 17509 then
	messagebox("Database Issue","Important. Due to an unknown restriction,~n~rthe original user login must be manually dropped from server~n~rusing either Sybase Central or iSQL client.~n~r~n~rPlease send an email including the following:~n~r  original user id~n~r  new user id~n~r  action:changing user id~n~r  reference number:17509~n~r~n~rto the Tramos development team where they will analyse this issue.")
	/* 
	ignore the standard db error
	
	A database error has occurred.  Database error code: 17509.
	Database error message: Select Error:  User exists or is an alias or is a database owner in at least one database.
	Drop the user or the alias, or change  database ownership before dropping the login.
	*/
	return 2
end if
end event

