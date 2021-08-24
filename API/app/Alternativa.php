<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class alternativa extends Model
{
    protected $fillable = [
        'alternativa', 'indicesuspeita', 'formulario_idformulario'
    ];
    //protected $table = 'alternativa';
    
}
