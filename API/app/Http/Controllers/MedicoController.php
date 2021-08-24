<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\Medico\MedicoPostRequest;
use App\Medico;
use DB;
use Carbon\Carbon;
use Str;
use Storage;

class MedicoController extends Controller
{
    /*public function __construct(){
        header('Access-Control-Allow-Origin: *');
    }*/
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $medico = medico::all();
        return response()->json(['data'=>$medico, 'status'=>true]);
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
    public function store(MedicoPostRequest $request)
    {
        $dados = $request->all();
        if($request['fotomed']!=null){
            $image_64 = $request['fotomed'];
            $extension = explode('/', explode(':', substr($image_64, 0, strpos($image_64, ';')))[1])[1];
            $replace = substr($image_64, 0, strpos($image_64, ',')+1); 
            $image = str_replace($replace, '', $image_64); 
            $image = str_replace(' ', '+', $image); 
            $imageName = Str::random(11).'.'.$extension;
            Storage::disk('public')->put($imageName, base64_decode($image));
            $dados['fotomed'] = $imageName;
        }
        $medico = medico::create($dados);
        if($medico){
            return response()->json(['data'=>$medico, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao criar o medico', 'status'=>false]);
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
        $medico = Medico::find($id);
        if($medico){
            return response()->json(['data'=>$medico, 'status'=>true]);
        }else{
            return response()->json(['data'=>'medico não cadastrado', 'status'=>false]);
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
        $medico = Medico::find($id);
        $dados = $request->all();
        if($request['fotomed']!=null){
            $image_64 = $request['fotomed']; //your base64 encoded data
            $extension = explode('/', explode(':', substr($image_64, 0, strpos($image_64, ';')))[1])[1];   // .jpg .png .pdf
            $replace = substr($image_64, 0, strpos($image_64, ',')+1); 
            $image = str_replace($replace, '', $image_64); 
            $image = str_replace(' ', '+', $image); 
            $imageName = Str::random(9).'.'.$extension;
            Storage::disk('public')->put($imageName, base64_decode($image));
            $dados['fotomed'] = $imageName;
            if($medico->fotomed!= null){
              Storage::delete(['public', $medico->fotomed]);
          }
        }
        if($medico){
            $medico->update($dados);
         return response()->json(['data'=>$medico, 'status'=>true]);
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
        $medico = Medico::find($id);        
        if($medico){
            $medico->delete();
             return response()->json(['data'=>'medico removido com sucesso!', 'status'=>true]);
         }else{
             return response()->json(['data'=>'Erro ao remover o medico', 'status'=>false]);
        }
    }
    public function empresamedico($id){
        $itens = DB::table('medicos')
                    ->select(DB::RAW('*'))
                    ->where('empresa_id', '=', $id)
                    ->get();
        if($itens){
            return response()->json(['data'=>$itens, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao listar médicos', 'status'=>false]);
        }
    }
}