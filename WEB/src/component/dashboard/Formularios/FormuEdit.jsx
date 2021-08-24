
import React, { Component } from 'react';
import { Link, useLocation } from 'react-router-dom';
import "./Formu.css";



class FormuEdit extends Component {
    constructor(props) {
        super(props);
        this.state = {
            selectedFormu: {
                "id": 0,
                "explicacaoprotocolo": "",
                "imagemexplicativa": "",
                "pergunta": "",
                "alternativa1": "",
                "indicea1": 0,
                "alternativa2": "",
                "indicea2": 0,
                "alternativa3": "",
                "indicea3": 0,
                "alternativa4": "",
                "indicea4": 0,
                "created_at": "",
                "updated_at": ""
            },
            editFormu: {},
            inputerror: {

            },
            status: false

        }


    }
    componentDidMount() {
        const id = this.props.location.state.id;
        fetch("https://anorosa.com.br/api/formulario/" + id)
            .then(data => data.json().then(data => {
                
                this.setState({ selectedFormu: data.data, isApiRequested: true })
                this.setState({ status: data.status })
            }))
            .catch(erro => this.setState(erro));
    }

    async onChangeImg(file) {
        var base64 = null;
        var reader = new FileReader();
        await reader.readAsDataURL(file);
        reader.onload = await function () {
            base64 = reader.result;

            this.setState(prevState => ({
                editFormu: { ...prevState.editFormu, imagemexplicativa: base64 }
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
            editFormu: { ...prevState.editFormu, [name]: value }
        }))
    }




    handleSubmit = async event => {
        var json = await JSON.stringify(this.state.editFormu);
        const token = localStorage.getItem("JWT_token");
        const id = this.props.location.state.id;

        fetch("http://www.anorosa.com.br/api/formulario/update/" + id, {
            method: "put",
            body: json,
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            }
        }).then(data => data.json().then(data => {
            if (data.status !== true) {
                if (data.error === 1) {//Input error code
                    alert('Erro ao editar item.')
                    //this.setState({ inputerror: data.errors })
                } else {
                    alert(data.error)
                }
            } else {
                this.props.history.goBack();
            }
        }))
        event.preventDefault();

    }



    render() {
        const sltdFormu = this.state.selectedFormu;
        const editFormu = this.state.editFormu;
        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Formulário</h1>
                    <p className="dashboard-page-title-desc">Cadastre um item ao formulário</p>
                </div>
                <nav aria-label="breadcrumb">
                    <ol className="breadcrumb px-md-5 mb-0">
                        <li className="breadcrumb-item"><Link to="/dashboard/formularios">Formulário</Link></li>
                        <li className="breadcrumb-item active" aria-current="page">Editar item</li>
                    </ol>
                </nav>
                <div className="dashboard-page-content p-md-5">
                    <div className="row no-gutters">
                        <div className="col-lg-12">
                            <div className="card border-0 shadow">
                                <div className="card-body p-lg-5">
                                    <h2 className="card-title h4 mb-4">Editar item</h2>
                                    <div className="form-group row">
                                        <label htmlFor="descricao" className="col-lg-2 col-form-label">Protocolo</label>
                                        <div className="col-lg-8">
                                            <textarea name="explicacaoprotocolo" id="aboutme" onChange={this.handleInputChange} placeholder={sltdFormu.explicacaoprotocolo} className="form-control" rows="5"></textarea>
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
                                                    {editFormu.imagemexplicativa !== undefined
                                                        ? <img className="formu-image" alt="" src={editFormu.imagemexplicativa} />
                                                        :sltdFormu.imagemexplicativa !== ""
                                                        ? <img className="formu-image" alt="" src={"http://www.anorosa.com.br/storage/"+sltdFormu.imagemexplicativa} />
                                                        :<img className="formu-image" alt="" src="" />
                                                    }
                                                </div>

                                            </label>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Pergunta</label>
                                        <div className="col-lg-8">
                                            <input onChange={this.handleInputChange} placeholder={sltdFormu.pergunta} type="text" className="form-control" id="nome" name="pergunta" />

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
                                            <input onChange={this.handleInputChange} placeholder={sltdFormu.alternativa1} type="text" className="form-control" id="nome" name="alternativa1" />
                                        </div>
                                        <div className="col-lg-2">
                                            <div className="input-group">
                                                <div className="input-group-append">
                                                    <span className="input-group-text">Indice</span>
                                                </div>
                                                <input onChange={this.handleInputChange} type="number" placeholder={sltdFormu.indicea1} className="form-control input-number" id="numero" name="indicea1" />
                                            </div>
                                        </div>

                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="cpf" className="col-lg-2 col-form-label">Alternativa 2</label>
                                        <div className="col-lg-6">
                                            <input onChange={this.handleInputChange} type="text" placeholder={sltdFormu.alternativa2} className="form-control" id="alt2" name="alternativa2" />
                                        </div>
                                        <div className="col-lg-2">
                                            <div className="input-group">
                                                <div className="input-group-append">
                                                    <span className="input-group-text">Indice</span>
                                                </div>
                                                <input onChange={this.handleInputChange} type="number" placeholder={sltdFormu.indicea2} className="form-control input-number" id="ind2" name="indicea2" />
                                            </div>
                                        </div>

                                    </div>
                                    <div className="form-group row">
                                                <label htmlFor="cpf" className="col-lg-2 col-form-label">Alternativa 3 <span className="small text-muted">(Opcional)</span></label>
                                                <div className="col-lg-6">
                                                    <input onChange={this.handleInputChange} placeholder={sltdFormu.alternativa3} type="text" className="form-control" id="alt3" name="alternativa3" />
                                                </div>
                                                <div className="col-lg-2">
                                                    <div className="input-group">
                                                        <div className="input-group-append">
                                                            <span className="input-group-text">Indice</span>
                                                        </div>
                                                        <input onChange={this.handleInputChange} placeholder={sltdFormu.indicea3} type="number" className="form-control input-number" id="ind3" name="indicea3" />
                                                    </div>
                                                </div>

                                            </div>
                                           
                                    
                                            ? <div className="form-group row">
                                                <label htmlFor="cpf" className="col-lg-2 col-form-label">Alternativa 4 <span className="small text-muted">(Opcional)</span></label>
                                                <div className="col-lg-6">
                                                    <input onChange={this.handleInputChange} placeholder={sltdFormu.alternativa4} type="text" className="form-control" id="alt4" name="alternativa4" />
                                                </div>
                                                <div className="col-lg-2">
                                                    <div className="input-group">
                                                        <div className="input-group-append">
                                                            <span className="input-group-text">Indice</span>
                                                        </div>
                                                        <input onChange={this.handleInputChange} placeholder={sltdFormu.indicea4} type="number" className="form-control input-number" id="ind4" name="indicea4" />
                                                    </div>
                                                </div>

                                            </div>
                                         


                                    <div className="offset-lg-9">
                                        <Link to="/dashboard/formularios" className="btn btn-outline-secondary mr-2">
                                            Cancelar
                                            </Link>
                                        <button onClick={this.handleSubmit} className="btn btn-primary">
                                            Editar
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

export default FormuEdit; 