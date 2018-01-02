$PBExportHeader$n_ds_spy_parameters.sru
forward
global type n_ds_spy_parameters from mt_n_nonvisualobject
end type
end forward

global type n_ds_spy_parameters from mt_n_nonvisualobject autoinstantiate
end type

type variables
blob	ibl_data
string is_dataobject

end variables

on n_ds_spy_parameters.create
call super::create
end on

on n_ds_spy_parameters.destroy
call super::destroy
end on

