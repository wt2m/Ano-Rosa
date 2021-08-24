<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Informacao extends Model
{
    protected $fillable = [
        'tituloinfo', 'subtituloinfo', 'imageminfo', 'textoinfo', 'url'
    ];
   protected $table = 'informacaos';
}
