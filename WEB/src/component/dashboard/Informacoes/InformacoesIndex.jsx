import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import DataTable from 'react-data-table-component';
import './Info.css'


class InformacoesIndex extends Component {
    constructor(props) {
        super(props);
        this.state = {
            informacao: [],
            med: [],
            isApiRequested: false,
            selectedItemId: null,
            selectedItem: {},
            status: false,
            loading: false,
            selectedCompanyId: 0,
            title: 0,
        }
    }
    componentDidMount() {

        const requestOptions = {
            method: 'get',
        };
        fetch("http://anorosa.com.br/api/informacao/showall", requestOptions)
            .then(data => data.json().then(data => {
                console.log(data);
                this.setState({ status: data.status })
                if (data.status) {
                    this.setState({ informacao: data.data, isApiRequested: true });
                }
            }))
            .catch(erro => this.setState(erro))
    }

    //BOTÕES DE AÇÕES DA LINHA
    actionsButtons(id, object) {
        return <div className="btn-group dropleft">
            <button type="button" className="btn dropdown-toggle no-arrow" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i className="fas fa-ellipsis-v"></i>
            </button>
            <div className="dropdown-menu shadow-sm">
            <Link  to={
                     {     
                       pathname: "/dashboard/info/edit",
                       state: {
                           id: id
                        }
                      }
                    }
                    ><button onClick="" type="button" className="dropdown-item" >Edit</button></Link>
                <button onClick={() => this.setState({ selectedItemId: id, selectedItem: object })} type="button" className="dropdown-item" data-toggle="modal" data-target="#delete_product_form">Deletar</button>
            </div>
        </div>
    }
    
   dataTable() {

        var data = [];

        var info = this.state.informacao;
        
        console.log(info);
        if (info.length !== 0) {
            for (var i = 0; i < info.length; i++) {
                var url =  info[i]['url'];
                info[i]['created_at'] = info[i]['created_at'].substring(0, 10);
                info[i]['acoes'] = this.actionsButtons(info[i].id, info[i]);
                if(info[i]['url']!== "" && info[i]['url'] !== null){
                    
                    var substring = info[i]['url'];
                info[i]['url'] = <a href={info[i]['url']} className="link">{url}</a>;
                }
                
            }
            //.replace(/[.,\/#!$%\^&\*;:{}=\-_`~()]/g, "").replace(/\(|\)|-/g, '').replace(/^(\d{3})(\d{3})(\d{3})(\d{2}).*/, '$1.$2.$3-$4');
            data = info;
        }



        //BOTÕES DE CADASTRP
        const actions = [
            
            <Link  to={
                     {     
                       pathname: "/dashboard/info/create",
                       
                      }
                    }className="btn btn-primary table-action"><i className="fas fa-plus mr-2"></i> Novo</Link>];

        //COLUNAS DA TABELA
        const columns = [
            {
                name: 'Título',
                selector: 'tituloinfo',
                sortable: true,
            },
            {
                name: 'Subtítulo',
                selector: 'subtituloinfo',
                sortable: true,
            },
            {
                name: 'Fonte',
                selector: 'url',
                sortable: true,
            },
            
            {
                name: 'Ações',
                selector: 'acoes',
                sortable: false,
            },

        ];

        //ELEMENTO DE EXPANSÃO DA LINHA
        const ExpandableComponent = ({ data }) =>
            <div className="row no-gutters p-3 bg-light">
                <div className="col-sm-auto mr-3">

                </div>
                <div className="col-lg-3">

                    <div className="product-image-container img-thumbnail">
                        <img className="product-image" src={"http://anorosa.com.br/storage/" + data.imageminfo} />
                    </div>
                    
                </div>
                <div className="col-lg-8">
                                            <div className="input-group">
                                            <textarea readonly disabled value={data.textoinfo.substring(0, 400)+"..."} rows="5" class="form-control"></textarea>
                                            </div>
                                        </div>
                
            </div>;
        var title = "Genciar informações";
       
        //DATATABLE
        return <DataTable
            title={title}
            pagination={true}
            actions={actions}
            columns={columns}
            data={data}
            expandableRows
            expandableRowsComponent={<ExpandableComponent />} />
    }
    render() {//Aqui acontece a renderização da página
        return (
            <div>
                <div className="dashboard-page-title p-md-5">
                    <h1 className="dashboard-page-title-header">Informações</h1>
                    <p className="dashboard-page-title-desc">Cadastre, atualize ou remova informações exibidas no app.</p>
                </div>
                <div className="dashboard-page-content p-md-5">
                    <div className="row no-gutters">
                        <div className="col-lg-12">
                            <div className="card border-0 shadow">
                                <div className="card-body">
                                    {this.dataTable()}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {/*   MODAL DELETE */}
                <div className="modal fade" id="delete_product_form" tabIndex="-1">
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
                                            <p className="mb-0">Tem certeza que deseja <strong>deletar o artigo {this.state.selectedItem.tituloinfo}</strong>? Essa operação é irreversível.</p>
                                        </div>
                                    </div>
                                </div>
                                <div className="form-row justify-content-center ">
                                    <div className="col-sm-4 mb-3 mb-sm-0">
                                        <button onClick={() => this.setState({ selectedItemId: null, selectedItem: { nomemed: null } })} type="button" className="btn btn-block btn-outline-secondary btn-lg" data-dismiss="modal">Cancelar</button>

                                    </div>
                                    <div className="col-sm-4">
                                        <button onClick={() => {
                                            const token = localStorage.getItem("JWT_token");
                                            fetch("https://anorosa.com.br/api/informacao/delete/" + this.state.selectedItemId, {
                                                method: "delete",
                                                headers: {
                                                    "Content-Type": "application/json",
                                                    "Authorization": "Bearer " + token
                                                }
                                            })
                                                .then(data => data.json().then(data => {
                                                    console.log(data);
                                                    window.location.reload();
                                                }))
                                                .catch(erro => this.setState(erro));
                                        }} type="button" className="btn btn-block btn-danger btn-lg">Deletar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    empresaMap = () => {
        const status = this.state.status;

        const empresa = this.state.empresa;

        if (status) {

            const Option = empresa.map((item, indice) => (
                <option key={indice} value={item.id}>{item.nomeempresa}</option>
            ))
            return Option
        }
    }

    handleSelect = event => {
        const target = event.target;
        const value = target.value;
        

        console.log(value)
        this.setState({ loading: true });
        const requestOptions = {
            method: 'get',
        };

        fetch("https://anorosa.com.br/api/empresa/medico/list/" + value, requestOptions)
            .then(data => data.json().then(data => {
                console.log(data);
                this.setState({ status: data.status })
                if (data.status) {
                    this.setState({ med: data.data, loading: false, selectedCompanyId: value });
                }
            }))
            .catch(erro => this.setState(erro))
        if (value !== 0) {
            this.setState({ title: 1 });
        } else {
            this.setState({ title: 0 });
        }

    }
}
export default InformacoesIndex; //Aqui retorna o componente