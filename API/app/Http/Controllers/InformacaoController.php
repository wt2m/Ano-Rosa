<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Informacao;
use Schema;
use DB;
use Carbon\Carbon;
use Str;
use Storage;
class InformacaoController extends Controller
{
    /*public function __construct(){
        header('Access-Control-Allow-Origin: *');
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $informacao = Informacao::all();
        return response()->json(['data'=>$informacao, 'status'=>true]);
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
        if($request['imageminfo']!=null){
            $image_64 = $request['imageminfo'];
            $extension = explode('/', explode(':', substr($image_64, 0, strpos($image_64, ';')))[1])[1];
            $replace = substr($image_64, 0, strpos($image_64, ',')+1); 
            $image = str_replace($replace, '', $image_64); 
            $image = str_replace(' ', '+', $image); 
            $imageName = Str::random(11).'.'.$extension;
            Storage::disk('public')->put($imageName, base64_decode($image));
            $dados['imageminfo'] = $imageName;
        }
        $informacao = Informacao::create($dados);
        if($informacao){
            return response()->json(['data'=>$informacao, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao criar o informacao', 'status'=>false]);
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
        $informacao = Informacao::find($id);
        if($informacao){
            return response()->json(['data'=>$informacao, 'status'=>true]);
        }else{
            return response()->json(['data'=>'informacao não cadastrado', 'status'=>false]);
        }
    }
    public function alter()
    {
        Schema::table('informacaos', function($table) {
            $table->string('url')->nullable()->change();
        });
        $informacao = Informacao::find(1);
        if($informacao){
            return response()->json(['data'=>$informacao, 'status'=>true]);
        }else{
            return response()->json(['data'=>'informacao não cadastrado', 'status'=>false]);
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
        $informacao = Informacao::find($id);
        $dados = $request->all();
        if($informacao){
            $informacao->update($dados);
         return response()->json(['data'=>$informacao, 'status'=>true]);
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
        $informacao = Informacao::find($id);        
        if($informacao){
            $informacao->delete();
             return response()->json(['data'=>'informacao removida com sucesso!', 'status'=>true]);
         }else{
             return response()->json(['data'=>'Erro ao remover o infomacao', 'status'=>false]);
        }
    }
}
