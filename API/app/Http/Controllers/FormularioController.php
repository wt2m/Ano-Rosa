<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Formulario;
use DB;
use Carbon\Carbon;
use Str;
use Storage;
class FormularioController extends Controller
{
   /* public function __construct(){
        header('Access-Control-Allow-Origin: *');
    }*/
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $formulario = Formulario::all();
        return response()->json(['data'=>$formulario, 'status'=>true]);
    }

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
    public function store(Request $request)
    {
        $dados = $request->all();
        if($request['imagemexplicativa']!=null){
            $image_64 = $request['imagemexplicativa'];
            $extension = explode('/', explode(':', substr($image_64, 0, strpos($image_64, ';')))[1])[1];
            $replace = substr($image_64, 0, strpos($image_64, ',')+1); 
            $image = str_replace($replace, '', $image_64); 
            $image = str_replace(' ', '+', $image); 
            $imageName = Str::random(11).'.'.$extension;
            Storage::disk('public')->put($imageName, base64_decode($image));
            $dados['imagemexplicativa'] = $imageName;
        }
        $formulario = Formulario::create($dados);
        if($formulario){
            return response()->json(['data'=>$formulario, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao criar o formulario', 'status'=>false]);
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
        $formulario = Formulario::find($id);
        if($formulario){
            return response()->json(['data'=>$formulario, 'status'=>true]);
        }else{
            return response()->json(['data'=>'formulario não cadastrado', 'status'=>false]);
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
    public function update(Request $request, $id)
    {
        $formulario = Formulario::find($id);
        $dados = $request->all();
        if($request['imagemexplicativa']!=null){
            $image_64 = $request['imagemexplicativa']; //your base64 encoded data
            $extension = explode('/', explode(':', substr($image_64, 0, strpos($image_64, ';')))[1])[1];   // .jpg .png .pdf
            $replace = substr($image_64, 0, strpos($image_64, ',')+1); 
            $image = str_replace($replace, '', $image_64); 
            $image = str_replace(' ', '+', $image); 
            $imageName = Str::random(9).'.'.$extension;
            Storage::disk('public')->put($imageName, base64_decode($image));
            $dados['imagemexplicativa'] = $imageName;
            if($formulario->imagemexplicativa!= null){
              Storage::delete(['public', $formulario->imagemexplicativa]);
          }
        }
        if($formulario){
            $formulario->update($dados);
         return response()->json(['data'=>$formulario, 'status'=>true]);
        }else{
        return response()->json(['data'=>'Erro ao editar o usuário', 'status'=>false]);
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
        $formulario = Formulario::find($id);        
        if($formulario){
            $formulario->delete();
             return response()->json(['data'=>'formulario removido com sucesso!', 'status'=>true]);
         }else{
             return response()->json(['data'=>'Erro ao remover o formulario', 'status'=>false]);
        }
    }
    }
