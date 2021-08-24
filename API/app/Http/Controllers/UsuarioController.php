<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\User;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Support\Facades\Input;
use App\Http\Requests\Usuario\UsuarioRequest;
use App\Http\Requests\Usuario\UserUpdateRequest;
use Illuminate\Http\File;
use Storage;
use Auth;
use DB;
use Str;
use JWTAuth;
use Hash;

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
class UsuarioController extends Controller
{
    public function __construct(){
        header('Access-Control-Allow-Origin: *');
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $usuario = User::all();
        return response()->json(['data'=>$usuario, 'status'=>true]);
    }
   /* public function altertable(){
        Schema::table('empresas', function (Blueprint $table) {
            $table->dropColumn('senhaempresa');
        });
    }*/

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

    //Cadastrar usuario
    public function store(UsuarioRequest $request)
    {
        $dados = $request->all();
        $dados['password'] = Hash::make($request['password']);
        $usuario = User::create($dados);
        if($usuario){
            return response()->json(['data'=>$usuario, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao criar o usuario', 'status'=>false]);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $usuario = User::find($id);
        if($usuario){
            return response()->json(['data'=>$usuario, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Usuario não cadastrado', 'status'=>false]);
        }
    }
    

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(UserUpdateRequest $request, $id)
    {
        $usuario = User::find($id);
        if($request['name']!=null){
            $dados['name'] = $request['name'];
        }
        if($request['fotouser']!=null){
            $image = $request->fotouser;  // your base64 encoded
            $image = str_replace('data:image/png;base64,', '', $image);
            $image = str_replace(' ', '+', $image);
            $imageName = Str::random(10) . '.jpg';
            Storage::disk('local')->put($imageName, base64_decode($image));
            $dados['fotouser'] = $imageName;
            if($usuario->fotouser!= null){
                Storage::delete(['local', $usuario->fotouser]);
            }
        }
        if($request['email']!=null){
            $dados['email'] = $request['email'];
        }
        
        
        
        
        if(!Hash::check($request['password'], $usuario->password)) {
            return response()->json(['error' => 'Senha inválida','status' => false]);
        }
        if($usuario){
        $usuario->update($dados);
         return response()->json(['status'=>true]);
        }else{
        return response()->json(['error'=>'Erro ao editar o usuário', 'status'=>false]);
         }
    }
    public function createAdmin(){
        DB::table('users')
            ->where('email', '=', 'admin@email.com')
            ->delete();
        $dados['name'] = 'Admin';
        $dados['email'] = 'admin@email.com';
        $dados['password'] = Hash::make('password');
        $dados['type'] = 1;
        $usuario = User::create($dados);
        if($usuario){
            return response()->json(['data'=>$usuario, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao criar o usuario', 'status'=>false]);
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {      
        $usuario = User::find($id);        
        if($usuario){
            $usuario->delete();
             return response()->json(['data'=>'Usuario removido com sucesso!', 'status'=>true]);
         }else{
             return response()->json(['data'=>'Erro ao remover o usuario', 'status'=>false]);
        }
    }
    
}
