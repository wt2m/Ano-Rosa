<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Formulario extends Model
{
    protected $fillable = [
        'explicacaoprotocolo', 'imagemexplicativa', 'pergunta', 'alternativa1','indicea1', 'alternativa2','indicea2' ,'alternativa3','indicea3', 'alternativa4', 'indicea4'
    ];
    //protected $table = 'formulario';
}
