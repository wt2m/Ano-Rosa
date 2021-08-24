<?php

namespace App\Http\Middleware;

use Closure;
use JWTAuth;
class CheckAuth
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
        
        try {
            $token = $request->header('Authorization');
            $user = JWTAuth::parseToken($token)->authenticate();
            if ($token && $user) {
                return $next($request);
            } else {
                return response()->json($response);
            }
        } catch (Exception $ex) {
            $response = array('success' => false, 'data' => null, 'detail' => array('message' => 'Messages::MSG_ERROR_500', 'error' => array($ex)));
        }
    }}
