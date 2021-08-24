<?php

namespace App\Http\Requests\Avaliacao;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class AvaliacaoPostRequest extends FormRequest
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
            'valoravaliacao' => 'required|between:0,5',
            'comentario' => 'max:200',
            'user_id' => 'required',
            'medico_id' => 'required'           
        ];
    }

    public function messages()
    {
        return[
            //valoravaliacao
            'valoravaliacao.required' => 'Insira uma nota',
            'valoravaliacao.between' => 'Valor de avaliação inválido',
            //comentario
            'comentario.max' => 'Comentário muito longo!',
            //user_id
            'user_id' => 'Avalie como um usuário válido',
            //medico_id
            'medico_id' => 'Avalie um médico válido'
        ];
    }

    protected function failedValidation(Validator $validator)
{
    throw new HttpResponseException(response()->json($validator->errors()));
}
}
