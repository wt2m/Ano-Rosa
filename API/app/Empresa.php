<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Empresa extends Model
{
    protected $fillable = [
        'nomeempresa', 'cnpj'
    ];
    //protected $table = 'empresa';
}
