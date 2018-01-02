$PBExportHeader$n_attachment.sru
$PBExportComments$Used by the u_fileattach object, this object is used as an array to hold blob data for any attachments that have been accessed.
forward
global type n_attachment from mt_n_nonvisualobject
end type
end forward

global type n_attachment from mt_n_nonvisualobject autoinstantiate
end type

type variables
blob ibl_image
string is_method
long il_file_id
long il_file_size

end variables

forward prototypes
public function long of_get_file_id ()
end prototypes

public function long of_get_file_id ();return il_file_id
end function

on n_attachment.create
call super::create
end on

on n_attachment.destroy
call super::destroy
end on

