
import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import "./Medicos.css";
import { MapContainer, Marker, TileLayer, Popup, useMapEvents } from 'react-leaflet';
import mapIcon from "./mapIcon.ts";

var click = null;

class ProdutoUpdate extends Component {
    constructor(props) {
        super(props);
        this.state = {
            medselected: {
                "nomemed": "",
                "fotomed": "",
                "aboutme": "",
                "cpfmed": "",
                "uf": "",
                "cidade": "",
                "bairro": "",
                "rua": "",
                "latitude": 0,
                "longitude": 0,
                "empresa_id": 0,
                "created_at": "",
                "updated_at": ""
            },

            empresa: {

            },

            isApiRequested: false,

            mededit: {

            },

            categoria: {
                "id": 0,
                "nomecategoria": ""
            },

            inputerror: {
                'nomeprod': null,
                'foto': null,
                'preco': null,
                'teor': null,
                'ml': null,
                'quantidade': null,
                'categoria_id': null,
                'desconto': null
            },

            status: false
        }


    }
    componentDidMount() {
        const id = this.props.location.state.id;
        console.log(id);
        var empresas = this.props.location.state.company
        const empresaid = this.props.location.state.selectedCompanyId;


        if (empresas !== null && empresas !== undefined) {
            this.setState({ empresa: empresas, status: true });
        } else {
            const requestOptions = {
                method: 'get',
            };
            fetch("http://anorosa.com.br/api/empresa/list", requestOptions)
                .then(data => data.json().then(data => {
                    console.log(data);
                    this.setState({ status: data.status })
                    if (data.status) {
                        this.setState({ empresa: data.data });

                    }
                }))
                .catch(erro => this.setState(erro))
        }
            fetch("https://anorosa.com.br/api/medico/" + id)
            .then(data => data.json().then(data => {
                
                this.setState({ medselected: data.data, isApiRequested: true })
                this.setState({ status: data.status })
            }))
            .catch(erro => this.setState(erro));
        
        
    }
    empresaMap = () => {
        const status = this.state.status;

        const empresa = this.state.empresa;

        const id = this.state.medselected.empresa_id;

        if (status) {
            if (id !== undefined && id !== null && id !== 0) {

                const Option = empresa.map((item, indice) => (
                    item.id != id
                        ? <option key={indice} value={item.id}>{item.nomeempresa}</option>

                        : <option key={indice} value={item.id} selected>{item.nomeempresa}</option>


                ))
                return Option
            } else {
                const Option = empresa.map((item, indice) => (
                    <option key={indice} value={item.id}>{item.nomeempresa}</option>
                ))
                Option[300] = <option disabled selected value>Selecione uma empresa</option>;
                return Option
            }
        }
    }
    async onChangeImg(file) {
        var base64 = null;
        var reader = new FileReader();
        await reader.readAsDataURL(file);
        reader.onload = await function () {
            base64 = reader.result;

            this.setState(prevState => ({
                mededit: { ...prevState.mededit, fotomed: base64 }
            }))

        }.bind(this);
        reader.onerror = function (error) {

        };


    }
    handlePosition = position => {
        if (click !== null) {
            this.setState(prevState => ({
                mededit: { ...prevState.mededit,  latitude: click.lat, longitude: click.lng},
                medselected: {...prevState.medselected, latitude: click.lat, longitude: click.lng}
            }))
        }

    }

    handleMapClick = e => {
        var pos = null;
        const map = useMapEvents({
            click(event) {

                click = event.latlng;

            }
        });
        return null;
    }

    handleInputChange = event => {
        const target = event.target;
        const name = target.name;
        const value = target.value;
        this.setState(prevState => ({
            mededit: { ...prevState.mededit, [name]: value }
        }))
    }

    handleSelect = event => {
        const target = event.target;
        const value = target.value;
        this.setState(prevState => ({
            mededit: { ...prevState.mededit, empresa_id: value }
        }))
    }
    handleSelectUf = event => {
        const target = event.target;
        const value = target.value;
        this.setState(prevState => ({
            mededit: { ...prevState.mededit, uf: value }
        }))
    }
    handleSubmit = event => {
        
       
        const id = this.props.location.state.id;
        const token = localStorage.getItem("JWT_token");
        fetch("https://anorosa.com.br/api/medico/update/" + id, {
            method: "put",
            body: JSON.stringify(this.state.mededit),
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token
            }
        }).then(data => data.json().then(data => {
            console.log(data);
            if (data.status !== true) {
                if (data.error === 1) {//Input error code
                    alert('Erro ao salvar alterações.')
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
        
        var position = {lat: 0, lng: 0}
        var iniposition = null;
        if(this.state.medselected.latitude){
            position = {lat: this.state.medselected.latitude, lng: this.state.medselected.longitude};
            iniposition = [this.state.medselected.latitude, this.state.medselected.longitude];
        }
        console.log(position, "      ", iniposition)
        

        const { REACT_APP_MAPBOX_TOKEN } = process.env;
        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Medicos</h1>
                    <p className="dashboard-page-title-desc">Edite um médico</p>
                </div>
                <nav aria-label="breadcrumb">
                    <ol className="breadcrumb px-md-5 mb-0">
                        <li className="breadcrumb-item"><Link to="/dashboard/medicos">Medicos</Link></li>
                        <li className="breadcrumb-item active" aria-current="page">Editar</li>
                    </ol>
                </nav>
                <div className="dashboard-page-content p-md-5">
                    <div className="row no-gutters">
                        <div className="col-lg-12">
                            <div className="card border-0 shadow">
                                <div className="card-body p-lg-5">
                                    <h2 className="card-title h4 mb-4">Editar medico</h2>

                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Nome</label>
                                        <div className="col-lg-8">
                                            {this.state.isApiRequested
                                                ?<input onChange={this.handleInputChange} type="text" className="form-control" id="nome" name="nomemed" placeholder={this.state.medselected.nomemed} />
                                                :<input type="text" className="form-control" id="nome" name="nomemed" readonly disabled/>
                                            }
                                            
                                            {/*this.state.inputerror.nomeprod !== null
                                                ? <span className="error">{this.state.inputerror.nomeprod}</span>
                                            : <span className="small text-muted">Esse será o nome de exibição do produto na loja.</span>*/}
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="cpf" className="col-lg-2 col-form-label">CPF</label>
                                        <div className="col-lg-4">
                                                <input onChange={(e) => {
                                                    this.CpfMask(e)
                                                }} type="text" className="form-control" id="cpf" name="cpfmed" placeholder={this.state.medselected.cpfmed}/>
                                                
                                            
                                            


                                            <span className="error">{this.state.inputerror.ml}</span>
                                        </div>

                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="preco" className="col-lg-2 col-form-label">Empresa</label>
                                        <div className="col-lg-4">
                                            <select onChange={this.handleSelect} id="inputState" class="form-control">
                                                {this.empresaMap()}
                                            </select>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="descricao" className="col-lg-2 col-form-label">Descrição<span className="small text-muted">(Opcional)</span></label>
                                        <div className="col-lg-8">
                                            <textarea name="aboutme" id="aboutme" onChange={this.handleInputChange} className="form-control" rows="10" placeholder={this.state.medselected.aboutme}></textarea>
                                        </div>
                                    </div>
                                    <div className="form-row">
                                        <div className="col-sm-8 offset-lg-2">
                                            <div className="alert callout callout-info alert-dismissible fade show" role="alert">
                                                <h4>Dica</h4>
                                                <p className="small">Para obter uma boa exibição no app, garanta que a foto atenda aos requisitos abaixo:</p>
                                                <ul className="small mb-0">
                                                    <li>Proporção de 1/1 entre a largura e altura</li>
                                                    <li className="text-muted" style={{ listStyleType: 'none' }}>Tamanho recomendado: 480x480</li>
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
                                                <div className="create-product-image-container">
                                                    <input onChange={(e) => this.onChangeImg(e.target.files[0])} type="file" className="d-none" id="foto" />
                                                    {this.state.mededit.fotomed !== undefined
                                                        ? <img className="product-image" alt="" src={this.state.mededit.fotomed} />
                                                        : this.state.medselected.fotomed !== null
                                                            ? <img className="product-image" alt="" src={"http://www.anorosa.com.br/storage/"+this.state.medselected.fotomed} />
                                                            :  <img className="product-image" alt=""/>
                                                    }
                                                </div>
                                                <span className="error">{this.state.inputerror.foto}</span>
                                            </label>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="UF" className="col-lg-2 col-form-label">Estado</label>
                                        <div className="col-lg-4">
                                            <select onChange={this.handleSelectUf} id="inputUF" class="form-control">
                                                <option disabled selected value>{this.state.medselected.uf}</option>
                                                <option value="AC">Acre</option>
                                                <option value="AL">Alagoas</option>
                                                <option value="AP">Amapá</option>
                                                <option value="AM">Amazonas</option>
                                                <option value="BA">Bahia</option>
                                                <option value="CE">Ceará</option>
                                                <option value="DF">Distrito Federal</option>
                                                <option value="ES">Espírito Santo</option>
                                                <option value="GO">Goiás</option>
                                                <option value="MA">Maranhão</option>
                                                <option value="MT">Mato Grosso</option>
                                                <option value="MS">Mato Grosso do Sul</option>
                                                <option value="MG">Minas Gerais</option>
                                                <option value="PA">Pará</option>
                                                <option value="PB">Paraíba</option>
                                                <option value="PR">Paraná</option>
                                                <option value="PE">Pernambuco</option>
                                                <option value="PI">Piauí</option>
                                                <option value="RJ">Rio de Janeiro</option>
                                                <option value="RN">Rio Grande do Norte</option>
                                                <option value="RS">Rio Grande do Sul</option>
                                                <option value="RO">Rondônia</option>
                                                <option value="RR">Roraima</option>
                                                <option value="SC">Santa Catarina</option>
                                                <option value="SP">São Paulo</option>
                                                <option value="SE">Sergipe</option>
                                                <option value="TO">Tocantins</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Cidade</label>
                                        <div className="col-lg-4">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="cidade" name="cidade" placeholder={this.state.medselected.cidade} />
                                            {/*this.state.inputerror.nomeprod !== null
                                                ? <span className="error">{this.state.inputerror.nomeprod}</span>
                                            : <span className="small text-muted">Esse será o nome de exibição do produto na loja.</span>*/}
                                        </div>
                                        <label htmlFor="nome" className="col-lg-1 col-form-label" >Bairro</label>
                                        <div className="col-lg-3">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="bairro" name="bairro" placeholder= {this.state.medselected.bairro}/>
                                            {/*this.state.inputerror.nomeprod !== null
                                                ? <span className="error">{this.state.inputerror.nomeprod}</span>
                                            : <span className="small text-muted">Esse será o nome de exibição do produto na loja.</span>*/}
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Rua</label>
                                        <div className="col-lg-5">
                                            <input onChange={this.handleInputChange} type="text" className="form-control" id="rua" name="rua" placeholder= {this.state.medselected.rua}/>
                                            {/*this.state.inputerror.nomeprod !== null
                                                ? <span className="error">{this.state.inputerror.nomeprod}</span>
                                            : <span className="small text-muted">Esse será o nome de exibição do produto na loja.</span>*/}
                                        </div>
                                        <div className="col-lg-2">
                                            <div className="input-group">
                                                <div className="input-group-append">
                                                    <span className="input-group-text">Nº</span>
                                                </div>
                                                <input onChange={(e) => this.setState({ numero: e.target.value })} type="number" className="form-control" id="numero" name="numero" />
                                            </div>
                                        </div>
                                    </div>
                                    <div className="form-group row">
                                        <label htmlFor="nome" className="col-lg-2 col-form-label">Mapa</label>
                                        <div className="col-lg-8">
                                            {iniposition !== null
                                                ? <MapContainer
                                                    style={{ width: '100%', height: 500 }}
                                                    center={[iniposition[0], iniposition[1]]}
                                                    zoom={14}


                                                >
                                                    <this.handleMapClick />
                                                    {position.lat !== 0 && (
                                                        <Marker
                                                            interactive={false}
                                                            icon={mapIcon}
                                                            position={[position.lat, position.lng]}
                                                        />
                                                    )}
                                                    <TileLayer
                                                        url={`https://api.mapbox.com/styles/v1/mapbox/light-v10/tiles/256/{z}/{x}/{y}@2x?access_token=${REACT_APP_MAPBOX_TOKEN}`}
                                                    />

                                                </MapContainer>
                                                : <div />}
                                        </div>
                                        <div className="col-lg-2">

                                            <button onClick={this.handlePosition} className="btn btn-secondary">
                                                Marcar
                                            </button>
                                        </div>
                                    </div>
                                    <div className="offset-lg-9">
                                        <Link to="/dashboard/produtos" className="btn btn-outline-secondary mr-2">
                                            Cancelar
                                            </Link>
                                        <button onClick={this.handleSubmit} className="btn btn-primary">
                                            Salvar
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
    CpfMask = (e) => {

        let cpf = e.target.value;
        let cpfMask = cpf;
        e.target.value = cpfMask.replace(/[.,\/#!$%\^&\*;:{}=\-_`~()]/g, "").replace(/\(|\)|-/g, '').replace(/^(\d{3})(\d{3})(\d{3})(\d{2}).*/, '$1.$2.$3-$4');
        if (cpf.length === 11) {
            this.setState(prevState => ({
                newmed: { ...prevState.newmed, cpfmed: cpf.replace(/[.,\/#!$%\^&\*;:{}=\-_`~()]/g, "").replace(/\(|\)|-/g, '') }
            }));
        }
        if (cpf.length < 11) {
            this.setState(prevState => ({
                newmed: { ...prevState.newmed, cpfmed: "" }
            }));
        }
    }
}
export default ProdutoUpdate; //Aqui retorna o componente