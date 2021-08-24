import React, { Component } from 'react'; //Importa o método componente e react
import './Imagens.css';
import { Link } from 'react-router-dom';


class ImagensCreate extends Component {

    render() {//Aqui acontece a renderização da página
       
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
                                <h2 className="card-title h5 mb-3">Cadastrar imagem</h2>
                                <div className="form-group overflow-auto">
                                    <label hmtlFor="img-desktop">Desktop</label><br/>
                                    <label className="hightlight-image-container desktop">
                                        <input type="file" className="d-none input-img" name="img-desktop" id="img-desktop" />
                                        <img src="" alt="" className="img-preview" />
                                        <div className="img-default">
                                            <img src="imagens/images.png" />
                                            <span className="text-muted">Clique para selecionar</span>
                                            <span className="text-muted small">Tamanho recomendado: 1600x350</span>
                                        </div>
                                    </label>
                                </div>
                                <div className="form-group mb-5 overflow-auto">
                                    <label hmtlFor="img-mobile">Mobile</label><br/>
                                    <label className="hightlight-image-container mobile">
                                        <input type="file" className="d-none input-img" name="img-desktop" id="img-mobile" />
                                        <img src="" alt="" className="img-preview" />
                                        <div className="img-default">
                                            <img src="imagens/images.png" />
                                            <span className="text-muted">Clique para selecionar</span>
                                            <span className="text-muted small">Tamanho recomendado: 400x200 </span>
                                        </div>
                                    </label>
                                </div>
                                <Link to="/dashboard/imagensDestaque" className="btn btn-outline-secondary btn-lg mr-3">Cancelar</Link>
                                <button type="button" className="btn btn-primary btn-lg">Cadastrar</button> 
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}
export default ImagensCreate; //Aqui retorna o componente