<?php

namespace App\Http\Requests\Usuario;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class UserUpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function rules()
    {
        return [
            'email' => 'unique:users,email|email',
            'name' => 'between:3,35',
            'password' => 'required|min:6'
        ];
    }

    public function messages()
    {
        return[
            'email.unique' => 'Email já cadastrado',
            'email.email' => 'Insira um email válido',

            'name.required' => 'Insira seu nome',
            'name.between' => 'Nome muito curto ou muito longo',

            'password.required' => 'Insira sua senha',

        ];
    }

    protected function failedValidation(Validator $validator)
{
    throw new HttpResponseException(response()->json($validator->errors()));
}
}
