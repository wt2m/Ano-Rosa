<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\Avaliacao\AvaliacaoPostRequest;
use App\Avaliacao;
use DB;

class AvaliacaoController extends Controller
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
        $avaliacao = Avaliacao::all();
        return response()->json(['data'=>$avaliacao, 'status'=>true]);
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
    public function store(AvaliacaoPostRequest $request)
    {
        $dados = $request->all();
        $itens = DB::table('avaliacaos')
                            ->select(DB::raw('*'))
                            ->where('user_id', '=', $dados['user_id'])
                            ->where('medico_id', '=', $dados['medico_id'])
                            ->get();
        if(sizeOf($itens) == 0){
                $avaliacao = Avaliacao::create($dados);
            if($avaliacao){
                DB::table('medicos')
                                ->where('id', '=', $dados['medico_id'])
                                ->increment('avaliacaototal', $dados['valoravaliacao']);
                DB::table('medicos')
                                ->where('id', '=', $dados['medico_id'])
                                ->increment('quantavaliacao', 1);
                return response()->json(['data'=>$avaliacao, 'status'=>true]);
            } else{
                return response()->json(['data'=>'Erro ao criar o avaliacao', 'status'=>false]);
            }
        }else{
            return response()->json(['data'=>'Médico já avaliado.', 'status'=>false]);
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
        $avaliacao = Avaliacao::find($id);
        if($avaliacao){
            return response()->json(['data'=>$avaliacao, 'status'=>true]);
        }else{
            return response()->json(['data'=>'avaliacao não cadastrado', 'status'=>false]);
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
        $avaliacao = Avaliacao::find($id);
        $dados = $request->all();
        if($avaliacao){
            $avaliacao->update($dados);
         return response()->json(['data'=>$avaliacao, 'status'=>true]);
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
        $avaliacao = Avaliacao::find($id);        
        if($avaliacao){
            $avaliacao->delete();
             return response()->json(['data'=>'Avaliacao removido com sucesso!', 'status'=>true]);
         }else{
             return response()->json(['data'=>'Erro ao remover o avaliacao', 'status'=>false]);
        }
    }
}
