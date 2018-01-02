$PBExportHeader$mt_n_baseservice.sru
$PBExportComments$Ancestor for all Services
forward
global type mt_n_baseservice from mt_n_nonvisualobject
end type
end forward

global type mt_n_baseservice from mt_n_nonvisualobject
end type
global mt_n_baseservice mt_n_baseservice

type variables
public:
protectedwrite boolean #Pooled
end variables

on mt_n_baseservice.create
call super::create
end on

on mt_n_baseservice.destroy
call super::destroy
end on

