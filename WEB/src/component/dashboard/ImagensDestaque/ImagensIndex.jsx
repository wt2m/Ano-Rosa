import React, { Component } from 'react'; //Importa o método componente e react
import './Imagens.css';
import destaque1 from '../../../imagens/destaque1.webp';
import destaque2 from '../../../imagens/destaque2.webp';
import mobile1 from '../../../imagens/1-mobile.png';
import { Link } from 'react-router-dom';


class ImagensIndex extends Component {
    constructor(props) {
        super(props);
        this.state = {
            toggleScreen: 0,
        }
    }
    render() {//Aqui acontece a renderização da página
        console.log(this.state.toggleScreen);
        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Destaques</h1>
                    <p className="dashboard-page-title-desc">Essas imagens irão aparecer no carousel da tela inicial.</p>
                </div>
                <div className="dashboard-page-content p-md-5">
                    <div className="row no-gutters">
                        <div className="col-lg-12">
                            <div className="card border-0 shadow">
                                <div className="card-body">
                                    <div className="flex-between mb-3">
                                        <h2 className="card-title h5 mb-0">Imagens cadastradas</h2>
                                        <Link to="/dashboard/imagensDestaque/create" className="btn btn-primary">
                                            <i className="fas fa-plus mr-2"></i>
                                        Novo
                                    </Link>
                                    </div>
                                    <div id="hightlight-images-preview">
                                        <div className="center-flex">
                                            <div className="btn-group mb-4 d-none d-md-inline-flex" role="group" aria-label="Basic example">
                                                <button onClick={() => this.setState({ toggleScreen: 0 })} className={this.state.toggleScreen === 0
                                                    ? "btn btn-outline-primary active toggle-button btn-sm"
                                                    : "btn btn-outline-primary toggle-button btn-sm"} type="button" id="toggleDesktop"><i data-toggle="tooltip" data-placement="top" title="Imagens versão desktop" className="fas fa-desktop"></i></button>
                                                <button onClick={() => this.setState({ toggleScreen: 1 })} className={this.state.toggleScreen === 1
                                                    ? "btn btn-outline-primary active toggle-button btn-sm"
                                                    : "btn btn-outline-primary toggle-button btn-sm"} type="button" id="toggleMobile"><i data-toggle="tooltip" data-placement="top" title="Imagens versão mobile" className="fas fa-mobile-alt mx-1"></i></button>
                                            </div>
                                        </div>

                                        <div className={this.state.toggleScreen === 0
                                            ? "collapse show"
                                            : "collapse"} id="collapseDesktop">
                                            <div className="desktop-images">
                                                <div className="show-preview">
                                                    <img src={destaque1} className="desktop-image-preview" alt="" />
                                                    <div className="delete-button-container">
                                                        <button type="button" className="button-delete" data-toggle="modal" data-target="#delete_img_formç.">
                                                            <i className="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div className="show-preview">
                                                    <img src={destaque2} className="desktop-image-preview" alt="" />
                                                    <div className="delete-button-container">
                                                        <button type="button" className="button-delete" data-toggle="modal" data-target="#delete_img_formç.">
                                                            <i className="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div className={this.state.toggleScreen === 0
                                            ? "collapse"
                                            : "collapse show"} id="collapseMobile">
                                            <div className="mobile-images">
                                                <div className="row justify-content-center">
                                                    <div className="col-md-auto">
                                                        <div className="show-preview">
                                                            <img src={mobile1} className="mobile-image-preview" alt="" />
                                                            <div className="delete-button-container">
                                                                <button type="button" className="button-delete" data-toggle="modal" data-target="delete_img_form">
                                                                    <i className="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div className="col-md-auto">
                                                        <div className="show-preview">
                                                            <img src={mobile1} className="mobile-image-preview" alt="" />
                                                            <div className="delete-button-container">
                                                                <button type="button" className="button-delete" data-toggle="modal" data-target="#delete_img_formç.">
                                                                    <i className="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="modal fade" id="delete_img_form" tabIndex="-1">
                    <div className="modal-dialog">
                        <div className="modal-content">
                            <div className="modal-body  p-5">
                                <div className="d-flex align-items-center flex-column">
                                    <div className="row mb-4 mb-sm-5">
                                        <div className="col-sm-auto">
                                            <div className="modal-icon mb-3 mb-sm-0">
                                                <i className="fas fa-exclamation"></i>
                                            </div>
                                        </div>
                                        <div className="col">
                                            <h5 className="modal-title mb-2">Atenção</h5>
                                            <p className="mb-2">Tem certeza que deseja <strong>deletar</strong> a imagem em destaque? Essa operação é irreversível.</p>
                                            <span className="small text-muted">Isso provocará a exclusão de imagens correspondentes em outros tamanhos de tela.</span>
                                        </div>
                                    </div>
                                </div>
                                <div className="form-row justify-content-center ">
                                    <div className="col-sm-4 mb-3 mb-sm-0">
                                        <button type="button" className="btn btn-block btn-outline-secondary btn-lg" data-dismiss="modal">Cancelar</button>

                                    </div>
                                    <div className="col-sm-4">
                                        <button type="button" className="btn btn-block btn-danger btn-lg">Deletar</button>
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
export default ImagensIndex; //Aqui retorna o componente