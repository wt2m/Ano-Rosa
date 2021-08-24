import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Usuario.dart';
import '../models/Token.dart';
import '../models/Informacao.dart';

class BD {
 static final BD _instance = new BD.internal();

 factory BD() => _instance;

 BD.internal();

 //Esqueleto do banco para facilitar a identificação e alteração;
 //Tabela usuario
 final String tabelaUsuario = "usuario";
 final String colunaIdusuario = "idusuario";
 final String colunaEmailuser = "emailuser";
 final String colunaSenhauser = "senhauser";
 final String colunaFotouser = "fotouser";
 final String colunaNomeuser = "nomeuser";

 //Tabela informacao
 final String tabelaInformacao = "informacao";
 final String colunaIdinformacao = "idinformacao";
 final String colunaTituloinfo = "tituloinfo";
 final String colunaSubtituloinfo = "subtituloinfo";
 final String colunaImageminfo = "imageminfo";
 final String colunaTextoinfo = "textoinfo";

 //Tabela access_token
 final String tabelaToken = "token";
 final String colunaIdtoken = "idtoken";
 final String colunaAccessToken = "accesstoken"; 

 static Database _db;
 
  Future<Database> get db async {
    // se o _db existe na memória
    if(_db != null){
      //caso exista, retorna este _bd existente
      return _db;
    }
    // chamamos agora o initBd que irá iniciar o nosso banco de dados
    _db = await initBd();
    return _db;
  }

  initBd() async {

    Directory documentoDiretorio = await getApplicationDocumentsDirectory();

    String caminho = join(
      documentoDiretorio.path, "bd_principal.db"
    );

    var nossoBD = await openDatabase(caminho, version: 1, onCreate: _onCreate);
    return nossoBD;
 
  }

  void _onCreate(Database db, int version) async {
    //Criação do banco em SQL com os valores definidos no esqueleto anteriormente
    await db.execute(//Tabela usuario
      "CREATE TABLE $tabelaUsuario($colunaIdusuario INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
        "$colunaEmailuser TEXT NOT NULL,"
        "$colunaSenhauser TEXT NOT NULL,"
        "$colunaFotouser TEXT,"
        "$colunaNomeuser TEXT NOT NULL)");
    await db.execute(//Tabela informacao
      "CREATE TABLE $tabelaInformacao($colunaIdinformacao INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
        "$colunaTituloinfo TEXT NOT NULL,"
        "$colunaSubtituloinfo TEXT,"
        "$colunaImageminfo TEXT,"
        "$colunaTextoinfo TEXT NOT NULL)");
    await db.execute(//Tabela token
      "CREATE TABLE $tabelaToken($colunaIdtoken INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT," 
        "$colunaAccessToken TEXT NOT NULL)");
 }
 
/////DAO usuario
//Inserir usuario
Future<int> inserirUsuario(Usuario usuario) async {
  var a = pegarUsuarios();
  if (a !=null){
    apagarUsuario(1);
  }
 var bdInserir = await db;
 int res = await bdInserir.insert("$tabelaUsuario", usuario.toMap()); //usuario é o nome da tabela;
 return res;
 }
//Listar usuarios
 Future<List> pegarUsuarios() async {
    var bdGet = await db;
    var res = await bdGet.rawQuery("SELECT * FROM $tabelaUsuario");
    return res.toList();
 }
  //Pegar usuario por id
  Future<Usuario> pegarUsuario(int idusuario) async {
    var bdCliente = await db;
    var res = await bdCliente.rawQuery("SELECT * FROM $tabelaUsuario"
              " WHERE $colunaIdusuario = $idusuario"); 
    if (res.length == 0) return null;
    return new Usuario.fromMap(res.first);
 }
 //Deletar usuario
 Future<int> apagarUsuario(int idusuario) async {
    var bdCliente = await db;
    return await bdCliente.delete(tabelaUsuario,
      where: "$colunaIdusuario = ?", whereArgs: [idusuario]);
  } 
//Editar usuario
Future<int> editarUsuario(Usuario usuario) async {
    var bdCliente = await db;
    return await bdCliente.update(tabelaUsuario,
      usuario.toMap(), where: "$colunaIdusuario = ?", whereArgs: [usuario.idusuario]
    );
  } 
/////Fim DAO Usuario
/////DAO informacao
//Inserir informacao
Future<int> inserirInformacao(Informacao informacao) async {
 var bdInserir = await db;
 int res = await bdInserir.insert("$tabelaInformacao", informacao.toMap()); 
 return res;
 }
//Listar informacaos
 Future<List> pegarInformacaos() async {
    var bdGet = await db;
    var res = await bdGet.rawQuery("SELECT * FROM $tabelaInformacao");
    return res.toList();
 }
  //Pegar informacao por id
  Future<Informacao> pegarInformacao(int idinformacao) async {
    var bdCliente = await db;
    var res = await bdCliente.rawQuery("SELECT * FROM $tabelaInformacao"
              " WHERE $colunaIdinformacao = $idinformacao"); 
    if (res.length == 0) return null;
    return new Informacao.fromMap(res.first);
 }
 //Deletar informacao
 Future<int> apagarInformacao(int idinformacao) async {
    var bdCliente = await db;
    return await bdCliente.delete(tabelaInformacao,
      where: "$colunaIdinformacao = ?", whereArgs: [idinformacao]);
  } 
//Editar informacao
Future<int> editarInformacao(Informacao informacao) async {
    var bdCliente = await db;
    return await bdCliente.update(tabelaInformacao,
      informacao.toMap(), where: "$colunaIdinformacao = ?", whereArgs: [informacao.idinformacao]
    );
  } 
/////Fim DAO informacao

////DAO accesstoken
Future<int> inserirToken(Token token) async {
  var a = pegarToken();
  if (a !=null){
    resetarTabelaToken();
  }
 var bdInserir = await db;
 int res = await bdInserir.insert("$tabelaToken", token.toMap()); //token é o nome da tabela;
 return res;
 }

 //pegar o token
Future<List> pegarToken() async {
    var bdGet = await db;
    var res = await bdGet.rawQuery("SELECT $colunaAccessToken FROM $tabelaToken");
    return res.toList();
 }
//Editar token
Future<int> editarToken(Token token) async {
    var bdCliente = await db;
    return await bdCliente.update(tabelaToken,
      token.toMap(), where: "$colunaIdtoken = ?", whereArgs: [token.idtoken]
    );
  }

//Refaz a tabela token quando um novo for recebido
resetarTabelaToken() async{
  var bdResetar = await db;
    bdResetar.execute("DROP TABLE $tabelaToken");
    bdResetar.execute("CREATE TABLE $tabelaToken($colunaIdtoken INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT," 
    "$colunaAccessToken TEXT NOT NULL)");
} 
/////Fim DAO Token

////Fim DAO accesstoken
//Fechar banco de dados para não ocupar memória
  Future fechar() async {
    var bdCliente = await db;

    return bdCliente.close();
  } 
}