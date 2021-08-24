<?php
 
namespace App;
 
use Illuminate\Database\Eloquent\Model;
 
class Usuario extends Model
{
    protected $fillable = [
        'emailuser', 'senhauser', 'fotouser', 'nomeuser'
    ];
    protected $hidden = [
        'senhauser', 'remember_token',
    ];
    //protected $table = 'usuarios';
}