<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Avaliacao extends Model
{
    protected $fillable = [
        'valoravaliacao', 'comentario', 'user_id', 'medico_id'
    ];
    //protected $table = 'avaliacao';
}
