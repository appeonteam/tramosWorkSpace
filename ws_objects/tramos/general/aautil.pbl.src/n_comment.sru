$PBExportHeader$n_comment.sru
$PBExportComments$Used to maintain comments marked as "comments" in datawindows
forward
global type n_comment from nonvisualobject
end type
end forward

global type n_comment from nonvisualobject
end type
global n_comment n_comment

type variables
long il_returnCode
string is_comment
integer xpos, ypos
end variables

forward prototypes
public subroutine setcomment (string arg_comment)
public function string getcomment ()
public subroutine setx (integer arg_x)
public subroutine sety (integer arg_y)
public function integer getx ()
public function integer gety ()
public subroutine setreturncode (long arg_return)
public function long getreturncode ()
end prototypes

public subroutine setcomment (string arg_comment);is_comment = arg_comment
end subroutine

public function string getcomment ();RETURN is_comment
end function

public subroutine setx (integer arg_x);xpos = arg_x
end subroutine

public subroutine sety (integer arg_y);ypos = arg_y
end subroutine

public function integer getx ();RETURN xpos
end function

public function integer gety ();return ypos
end function

public subroutine setreturncode (long arg_return);il_returnCode = arg_return
end subroutine

public function long getreturncode ();RETURN il_returnCode
end function

on n_comment.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_comment.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

