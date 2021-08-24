<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
Route::group([

    'middleware' => 'api',
    //'namespace' => 'App\Http\Controllers',
    //'prefix' => 'auth'

], function ($router) {

    Route::post('usuario/login', 'UserAuthController@login');
    Route::post('usuario/logout', 'UserAuthController@logout');
    Route::post('usuario/refresh', 'UserAuthController@refresh');
    Route::post('usuario/logado', 'UserAuthController@me');

});

Route::get('storage/{filename}', function ($filename)
{
    $path = storage_path('public/' . $filename);

    if (!File::exists($path)) {
        abort(404);
    }

    $file = File::get($path);
    $type = File::mimeType($path);

    $response = Response::make($file, 200);
    $response->header("Content-Type", $type);

    return $response;
});

//Usuarios
Route::post('usuario/add', 'UsuarioController@store')/*->middleware('authcheck')*/; //Adicionar usuario
Route::get('usuario/showall', 'UsuarioController@index');//Listar usuarios
Route::put('usuario/update/{id}', 'UsuarioController@update')->middleware('verifyuserupdate');//Editar usuario
Route::get('usuario/admincreate', 'UsuarioController@createAdmin');

//Formulários
Route::post('formulario/add', 'FormularioController@store'); //Adicionar formulario
Route::get('formulario/showall', 'FormularioController@index');//Listar formulários
Route::get('formulario/{id}', 'FormularioController@show');
Route::put('formulario/update/{id}', 'FormularioController@update');
Route::delete('formulario/delete/{id}', 'FormularioController@destroy');

//Informações
Route::post('informacao/add', 'InformacaoController@store'); //Adicionar informação
Route::get('informacao/showall', 'InformacaoController@index');//Listar informações
//Route::get('informacao/alt', 'InformacaoController@alter');
Route::get('informacao/{id}', 'InformacaoController@show');
Route::put('informacao/update/{id}', 'InformacaoController@update');
Route::delete('informacao/delete/{id}', 'InformacaoController@destroy');

//Medicos
Route::post('medico/add', 'MedicoController@store');
Route::get('medico/list', 'MedicoController@index');
Route::get('empresa/medico/list/{id}', 'MedicoController@empresamedico');
Route::delete('medico/delete/{id}', 'MedicoController@destroy');
Route::get('medico/{id}', 'MedicoController@show');
Route::put('medico/update/{id}','MedicoController@update');


//Empresas
Route::post('empresa/add', 'EmpresaController@store');
Route::get('empresa/list', 'EmpresaController@index');
Route::delete('empresa/delete/{id}', 'EmpresaController@destroy');
Route::put('empresa/update/{id}', 'EmpresaController@update');

//Avaliação de médico
Route::post('avaliacao/add', 'AvaliacaoController@store')->middleware('authavaliacao');
Route::put('avaliacao/update/{id}', 'AvaliacaoController@update')->middleware('updateavaliacao');
Route::get('avaliacao/showall', 'AvaliacaoController@index');//Listar avaliações


Route::resource('empresa', 'EmpresaController');

Route::get('usuario/altertable', 'UsuarioController@altertable');