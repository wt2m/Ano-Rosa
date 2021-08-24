<?php

namespace App\Http\Requests\Usuario;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class UsuarioRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'email' => 'required|unique:users,email|email',
            'name' => 'required|between:3,35',
            'password' => 'required|min:6'
        ];
    }

    public function messages()
    {
        return[
            'email.required' => 'Insira seu email',
            'email.unique' => 'Email já cadastrado',
            'email.email' => 'Insira um email válido',

            'name.required' => 'Insira seu nome',
            'name.between' => 'Nome muito curto ou muito longo',

            'password.required' => 'Insira uma senha',
            'password.min' => 'Senha muito curta',

        ];
    }

    protected function failedValidation(Validator $validator)
{
    throw new HttpResponseException(response()->json($validator->errors()));
}
}

