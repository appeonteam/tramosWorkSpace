$PBExportHeader$u_log.sru
$PBExportComments$Log object. Writes logdata to a file with timestamp
forward
global type u_log from mt_n_nonvisualobject
end type
end forward

global type u_log from mt_n_nonvisualobject
end type
global u_log u_log

type variables
Integer ii_filehandle
String is_timers[100]
Long il_cputime[100]
end variables

forward prototypes
public subroutine uf_writelog (string as_text)
public function integer uf_timebegin (string as_text)
public subroutine uf_timeend (integer ai_timer)
end prototypes

public subroutine uf_writelog (string as_text);FileWrite(ii_fileHandle, "["+String(Now(), "hh:mm:ss:ff")+"]  "+as_text)
end subroutine

public function integer uf_timebegin (string as_text);Integer li_result, li_max, li_count
	
li_max = UpperBound(is_timers)
For li_count = 1 To li_max
	If is_timers[li_count]="" Then
		li_result = li_count
		is_timers[li_count] = as_text
		il_cputime[li_count] = Cpu()
		
		uf_writelog("TM begin "+as_text)
		
		Exit
	End if
Next			
	
Return li_result
end function

public subroutine uf_timeend (integer ai_timer);Long ll_time

If ai_timer > 0 Then
	ll_time = Cpu() - il_cputime[ai_timer]
	uf_writelog("TM end "+ is_timers[ai_timer]+" time: "+String(ll_time)+" ms")

	is_timers[ai_timer] = ""
End if
end subroutine

on constructor;call mt_n_nonvisualobject::constructor;ii_filehandle = FileOpen('C:\TRAMOS.LOG', LineMode!, Write!, LockWrite!, Replace!)

uf_writelog("TRAMOS log file created")

end on

on destructor;call mt_n_nonvisualobject::destructor;FileClose(ii_filehandle)
end on

on u_log.create
TriggerEvent( this, "constructor" )
end on

on u_log.destroy
TriggerEvent( this, "destructor" )
end on

