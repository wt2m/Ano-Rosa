
import React, { Component } from 'react';
import { Link, useLocation } from 'react-router-dom';
import "./Info.css";



class InfoCreate extends Component {
    constructor(props) {
        super(props);
        this.state = {
            newInfo: {},
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
                newInfo: { ...prevState.newInfo, imageminfo: base64 }
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
            newInfo: { ...prevState.newInfo, [name]: value }
        }))
    }




    handleSubmit = async event => {
        var json = await JSON.stringify(this.state.newInfo);
        const token = localStorage.getItem("JWT_token");
        
        fetch("http://www.anorosa.com.br/api/informacao/add", {
            method: "post",
            body: json,
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            }
        }).then(data => data.json().then(data => {
            if (data.status !== true) {
                if (data.error === 1) {//Input error code
                    alert('Erro ao cadastrar informação.')
                    //this.setState({ inputerror: data.errors })
                } else {
                    alert(data.error)
                }
            } else {
                alert("Informação cadastrada com sucesso!!!");
                window.location.reload();
            }
        }))
        event.preventDefault();
       
    }



    render() {

        const { REACT_APP_MAPBOX_TOKEN } = process.env;
        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Informações</h1>
                    <p className="dashboard-page-title-desc">Cadastre uma informação</p>
                </div>
                <nav aria-label="breadcrumb">
                    <ol className="breadcrumb px-md-5 mb-0">
                        <li className="breadcrumb-item"><Link to="/dashboard/informacoes">Informação</Link></li>
                        <li className="breadcrumb-item active" aria-current="page">Cadastrar</li>
                    </ol>
                </nav>
                <div className="dashboard-page-content p-md-5">
                    <div className="row no-gutters">
                        <div className="col-lg-12">
                            <div className="card border-0 shadow">
                                <div className="card-body p-lg-5">
                                    <h2 className="card-title h4 mb-4">Cadastrar informação</h2>

                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Título</label>
                                        <div className="col-lg-4">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="nome" name="tituloinfo" />

                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="cpf" className="col-lg-2 col-form-label">Subtítulo</label>
                                        <div className="col-lg-4">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="nome" name="subtituloinfo" />
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
                                                <div className="create-info-image-container">
                                                    <input onChange={(e) => this.onChangeImg(e.target.files[0])} type="file" className="d-none" id="foto" />
                                                    {this.state.newInfo.imageminfo !== undefined
                                                        ? <img className="info-image" alt="" src={this.state.newInfo.imageminfo} />
                                                        : <img className="info-image" alt="" src=""/>
                                                    }
                                                </div>

                                            </label>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="descricao" className="col-lg-2 col-form-label">Texto</label>
                                        <div className="col-lg-8">
                                            <textarea name="textoinfo" id="aboutme" onChange={this.handleInputChange} className="form-control" rows="10"></textarea>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Fonte <span className="small text-muted">(Opcional)</span></label>
                                        <div className="col-lg-8">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="cidade" name="url" />

                                        </div>

                                    </div>

                                    <div className="offset-lg-9">
                                    <Link to="/dashboard/informacoes" className="btn btn-outline-secondary mr-2">
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

export default InfoCreate; //Aqui retorna o componente
/*
        "tituloinfo": "Autoexame",
        "subtituloinfo": "Como fazer e benefícios",
        "imageminfo": "outubrorosa.jpg",
        "textoinfo": "A prevenção do câncer de mama não é totalmente possível em função da multiplicidade de fatores relacionados ao surgimento da doença e ao fato de vários deles não serem modificáveis. De modo geral, a prevenção baseia-se no controle dos fatores de risco e no estímulo aos fatores protetores, especificamente aqueles considerados modificáveis.",
        "created_at": "2020-08-18T17:27:29.000000Z",
        "updated_at": "2020-08-18T17:27:29.000000Z",
        "url": ""
*/