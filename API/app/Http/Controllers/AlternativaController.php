<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Alternativa;

class AlternativaController extends Controller
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
        $alternativa = Alternativa::all();
        return response()->json(['data'=>$alternativa, 'status'=>true]);
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
        $alternativa = Alternativa::create($dados);
        if($alternativa){
            return response()->json(['data'=>$alternativa, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao criar o alternativa', 'status'=>false]);
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
        $alternativa = Alternativa::find($id);
        if($alternativa){
            return response()->json(['data'=>$alternativa, 'status'=>true]);
        }else{
            return response()->json(['data'=>'alternativa não cadastrado', 'status'=>false]);
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
        $alternativa = Alternativa::find($id);
        $dados = $request->all();
        if($alternativa){
            $alternativa->update($dados);
         return response()->json(['data'=>$alternativa, 'status'=>true]);
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
        $alternativa = Alternativa::find($id);        
        if($alternativa){
            $alternativa->delete();
             return response()->json(['data'=>'Alternativa removida com sucesso!', 'status'=>true]);
         }else{
             return response()->json(['data'=>'Erro ao remover o alternativa', 'status'=>false]);
        }
    }
}
