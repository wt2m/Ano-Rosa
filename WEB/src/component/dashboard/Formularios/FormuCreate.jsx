
import React, { Component } from 'react';
import { Link, useLocation } from 'react-router-dom';
import "./Formu.css";



class FormuCreate extends Component {
    constructor(props) {
        super(props);
        this.state = {
            newFormu: {},
            inputerror: {

            },
            status: false

        }


    }
    componentDidMount() {
    }

    async onChangeImg(file) {
        var base64 = null;
        var reader = new FileReader();
        await reader.readAsDataURL(file);
        reader.onload = await function () {
            base64 = reader.result;

            this.setState(prevState => ({
                newFormu: { ...prevState.newFormu, imagemexplicativa: base64 }
            }))

        }.bind(this);
        reader.onerror = function (error) {

            console.log('Error: ', error);
        };


    }


    handleInputChange = event => {
        const target = event.target;
        const name = target.name;
        const value = target.value;
        this.setState(prevState => ({
            newFormu: { ...prevState.newFormu, [name]: value }
        }))
    }




    handleSubmit = async event => {
        var json = await JSON.stringify(this.state.newFormu);
        console.log(json);
        const token = localStorage.getItem("JWT_token");

        fetch("http://www.anorosa.com.br/api/formulario/add", {
            method: "post",
            body: json,
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            }
        }).then(data => data.json().then(data => {
            if (data.status !== true) {
                if (data.error === 1) {//Input error code
                    alert('Erro ao cadastrar item no formulário.')
                    //this.setState({ inputerror: data.errors })
                } else {
                    alert(data.error)
                }
            } else {
                alert("Item cadastrado com sucesso!!!");
                window.location.reload();
            }
        }))
        event.preventDefault();

    }



    render() {

        const newFormu = this.state.newFormu;
        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Formulário</h1>
                    <p className="dashboard-page-title-desc">Cadastre um item ao formulário</p>
                </div>
                <nav aria-label="breadcrumb">
                    <ol className="breadcrumb px-md-5 mb-0">
                        <li className="breadcrumb-item"><Link to="/dashboard/formularios">Formulário</Link></li>
                        <li className="breadcrumb-item active" aria-current="page">Cadastrar item</li>
                    </ol>
                </nav>
                <div className="dashboard-page-content p-md-5">
                    <div className="row no-gutters">
                        <div className="col-lg-12">
                            <div className="card border-0 shadow">
                                <div className="card-body p-lg-5">
                                    <h2 className="card-title h4 mb-4">Cadastrar item</h2>
                                    <div className="form-group row">
                                        <label htmlFor="descricao" className="col-lg-2 col-form-label">Protocolo</label>
                                        <div className="col-lg-8">
                                            <textarea name="explicacaoprotocolo" id="aboutme" onChange={this.handleInputChange} className="form-control" rows="5"></textarea>
                                        </div>
                                    </div>
                                    <div className="form-row">
                                        <div className="col-sm-8 offset-lg-2">
                                            <div className="alert callout callout-info alert-dismissible fade show" role="alert">
                                                <h4>Dica</h4>
                                                <p className="small">Para obter uma boa exibição no app, garanta que a foto atenda aos requisitos abaixo:</p>
                                                <ul className="small mb-0">
                                                    <li>Proporção de 2/1 entre a largura e altura</li>
                                                    <li className="text-muted" style={{ listStyleType: 'none' }}>Tamanho recomendado: 960x480</li>
                                                </ul>
                                                <button type="button" className="close" data-dismiss="alert" aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="row mb-5">
                                        <label htmlFor="foto" className="col-lg-2 col-form-label">Foto de exibição</label>
                                        <div className="col-lg-8">
                                            <label>
                                                <div className="create-formu-image-container">
                                                    <input onChange={(e) => this.onChangeImg(e.target.files[0])} type="file" className="d-none" id="foto" />
                                                    {this.state.newFormu.imagemexplicativa !== undefined
                                                        ? <img className="formu-image" alt="" src={this.state.newFormu.imagemexplicativa} />
                                                        : <img className="formu-image" alt="" src="" />
                                                    }
                                                </div>

                                            </label>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Pergunta</label>
                                        <div className="col-lg-8">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="nome" name="pergunta" />

                                        </div>
                                    </div>
                                    <div className="form-row">
                                        <div className="col-sm-8 offset-lg-2">
                                            <div className="alert callout callout2 callout-primary alert-dismissible fade show" >
                                                <h4>Atenção</h4>
                                                <p className="small">Nesta seção deve-se preencher a alternativa e seu coeficiente de suspeita.</p>
                                                <ul className="small mb-0">
                                                    <li>O quoeficiente deve estar entre 0 e 1.</li>
                                                    <li>0 significa que não se enquadra como caso suspeito.</li>
                                                    <li>1 significa que se enquadra como caso suspeito.</li>
                                                    <li>São admitidos números não inteiros.</li>
                                                    <li>O mínimo de alternativas é 2 e o máximo 4.</li>
                                                </ul>
                                                <button type="button" className="close" data-dismiss="alert" aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="cpf" className="col-lg-2 col-form-label">Alternativa 1</label>
                                        <div className="col-lg-6">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="nome" name="alternativa1" />
                                        </div>
                                        <div className="col-lg-2">
                                            <div className="input-group">
                                                <div className="input-group-append">
                                                    <span className="input-group-text">Indice</span>
                                                </div>
                                                <input onChange={this.handleInputChange} type="number" className="form-control input-number" id="numero" name="indicea1" />
                                            </div>
                                        </div>

                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="cpf" className="col-lg-2 col-form-label">Alternativa 2</label>
                                        <div className="col-lg-6">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="alt2" name="alternativa2" />
                                        </div>
                                        <div className="col-lg-2">
                                            <div className="input-group">
                                                <div className="input-group-append">
                                                    <span className="input-group-text">Indice</span>
                                                </div>
                                                <input onChange={this.handleInputChange} type="number" className="form-control input-number" id="ind2" name="indicea2" />
                                            </div>
                                        </div>

                                    </div>
                                    {newFormu.alternativa1 !== undefined && newFormu.alternativa2 !== undefined
                                        ? newFormu.alternativa1 !== "" && newFormu.alternativa2 !== ""
                                            ? <div className="form-group row">
                                                <label htmlFor="cpf" className="col-lg-2 col-form-label">Alternativa 3 <span className="small text-muted">(Opcional)</span></label>
                                                <div className="col-lg-6">
                                                    <input onChange={this.handleInputChange} type="text" className="form-control" id="alt3" name="alternativa3" />
                                                </div>
                                                <div className="col-lg-2">
                                                    <div className="input-group">
                                                        <div className="input-group-append">
                                                            <span className="input-group-text">Indice</span>
                                                        </div>
                                                        <input onChange={this.handleInputChange} type="number" className="form-control input-number" id="ind3" name="indicea3" />
                                                    </div>
                                                </div>

                                            </div>
                                            : null
                                        : null
                                    }
                                    {newFormu.alternativa3 !== undefined 
                                        ? newFormu.alternativa3 !== ""
                                            ? <div className="form-group row">
                                                <label htmlFor="cpf" className="col-lg-2 col-form-label">Alternativa 4 <span className="small text-muted">(Opcional)</span></label>
                                                <div className="col-lg-6">
                                                    <input onChange={this.handleInputChange} type="text" className="form-control" id="alt4" name="alternativa4" />
                                                </div>
                                                <div className="col-lg-2">
                                                    <div className="input-group">
                                                        <div className="input-group-append">
                                                            <span className="input-group-text">Indice</span>
                                                        </div>
                                                        <input onChange={this.handleInputChange} type="number" className="form-control input-number" id="ind4" name="indicea4" />
                                                    </div>
                                                </div>

                                            </div>
                                            : null
                                        : null
                                    }


                                    <div className="offset-lg-9">
                                        <Link to="/dashboard/formularios" className="btn btn-outline-secondary mr-2">
                                            Cancelar
                                            </Link>
                                        <button onClick={this.handleSubmit} className="btn btn-primary">
                                            Cadastrar
                                            </button>

                                    </div>

                                </div>

                            </div>


                        </div>


                    </div>
                </div>
            </div>

        );
    }


}

export default FormuCreate; //Aqui retorna o componente
/*
            "explicacaoprotocolo": "Em uma escala de 0 a 3 defina o quanto os seus seios doeram nos ultimos dias",
            "imagemexplicativa": "autoexame.jpg",
            "pergunta": null,
            "alternativa1": "3",
            "indicea1": 1,
            "alternativa2": "2",
            "indicea2": 0.59999999999999997779553950749686919152736663818359375,
            "alternativa3": "1",
            "indicea3": 0.299999999999999988897769753748434595763683319091796875,
            "alternativa4": "0",
            "indicea4": 0,
            "created_at": "2020-08-18T17:28:00.000000Z",
            "updated_at": "2020-08-18T17:28:00.000000Z"
*/