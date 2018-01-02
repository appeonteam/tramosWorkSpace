$PBExportHeader$w_progress_no_cancel.srw
$PBExportComments$This is the progress window taken from PB's utils but modified so that it does not give a cancel button.
forward
global type w_progress_no_cancel from w_progress
end type
end forward

global type w_progress_no_cancel from w_progress
end type
global w_progress_no_cancel w_progress_no_cancel

on open;call w_progress::open;cb_cancel.enabled = false
end on

on w_progress_no_cancel.create
call w_progress::create
end on

on w_progress_no_cancel.destroy
call w_progress::destroy
end on

