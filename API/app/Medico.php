<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class medico extends Model
{
    protected $table = 'medicos';
    protected $fillable = [
        'nomemed','aboutme', 'fotomed', 'cpfmed', 'uf', 'cidade', 'bairro', 'rua', 'latitude', 'longitude', 'empresa_id'
    ];

    protected $hidden = [
        'cpfmed'
    ];
    
    
}
