<?php

namespace App\Http\Middleware;

use Closure;
use JWTAuth;

class VerifyUserUpdate
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {     
        try{
            $token = $request->header('Authorization');
            if($token == null){
                return response()->json(['status' => false, 'error' => 'Auth header não encontrado!']);
            }else{
                try {
            
                    $user = JWTAuth::parseToken($token)->authenticate();
                } catch (Exception $e) {
                     if ($e instanceof \Tymon\JWTAuth\Exceptions\TokenInvalidException){
                        return response()->json(['status' => false, 'error' => 'Token inválido']);
                    }else if ($e instanceof \Tymon\JWTAuth\Exceptions\TokenExpiredException){
                        return response()->json(['status' => false, 'error' => 'Token expirado']);
                    }else{
                        return response()->json(['status' => false, 'error' => 'Token de autorização não encontrado']);
                    }
                    
                }
            }
        }catch (Exception $e){
            return response()->json(['status' => false, 'error' => $e]);
        }
        
        if($user['id'] == $request['id']){
            return $next($request);
        }else{
            return response()->json(['status'=>false, 'error'=> 'Usuário não autenticado']);
        }
    
    }
}
