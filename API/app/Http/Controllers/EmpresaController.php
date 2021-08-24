<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Empresa;

class EmpresaController extends Controller
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
        $empresa = Empresa::all();
        return response()->json(['data'=>$empresa, 'status'=>true]);
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
        $empresa = Empresa::create($dados);
        if($empresa){
            return response()->json(['data'=>$empresa, 'status'=>true]);
        }else{
            return response()->json(['data'=>'Erro ao criar o empresa', 'status'=>false]);
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
        $empresa = Empresa::find($id);
        if($empresa){
            return response()->json(['data'=>$empresa, 'status'=>true]);
        }else{
            return response()->json(['data'=>'empresa não cadastrado', 'status'=>false]);
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
        $empresa = Empresa::find($id);
        $dados = $request->all();
        if($empresa){
            $empresa->update($dados);
         return response()->json(['data'=>$empresa, 'status'=>true]);
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
        DB::table('medicos')
            ->where('empresa_id', '=', $id)
            ->delete();
        $empresa = Empresa::find($id);        
        if($empresa){
            $empresa->delete();
             return response()->json(['data'=>'Empresa removido com sucesso!', 'status'=>true]);
         }else{
             return response()->json(['data'=>'Erro ao remover o empresa', 'status'=>false]);
        }
    }
}
