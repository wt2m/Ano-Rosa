<?php

namespace App\Http\Requests\Medico;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;


class MedicoPostRequest extends FormRequest
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
            'nomemed' => 'required|max:45',
            'aboutme' => 'max:200',
            'cpfmed' => 'required|between:11,11|unique:medicos,cpfmed',
            'uf' => 'required|between:2,2',
            'cidade' => 'required',
            'bairro' => 'required',
            'rua' => 'required',
            'latitude' => 'required',
            'longitude' => 'required',
            'empresa_id' => 'required'
        ];
    }

    public function messages()
    {
        return[
            //Nomemed
            'nomemed.required' => 'Insira o nome do profissional',
            'nomemed.max' => 'Nome muito longo, favor abreviar',

            //aboutme
            'aboutme.max' => 'Descrição excede os 200 caracteres.',

            //cpfmed
            'cpfmed.required' => 'Insira o cpf.',
            'cpfmed.between' => 'Cpf inválido.',
            'cpfmed.unique' => 'Médico já cadastrado.',
            
            //uf
            'uf.required' => 'Insira uma UF.',
            'uf.between' => 'UF inválida.',

            //cidade
            'cidade.required'=> 'Insira uma cidade.',

            //bairro
            'bairro.required' => 'Insira um bairro',

            //rua
            'rua.required' => 'Insira uma rua',
            
            //latitude e longitude
            'latitude.required' => 'Insira uma posição no mapa.',
            'longitude.required' => 'Insira uma posição no mapa.',

            //empresa_id
            'empresa_id.required' => 'Desculpe, houve um erro ao inserir o médico. Favor reinicie a sessão e contate o suporte.'
        ];
    }

    protected function failedValidation(Validator $validator)
{
    throw new HttpResponseException(response()->json($validator->errors()));
}
}
