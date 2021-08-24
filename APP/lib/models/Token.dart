class Token{
  int _idtoken;
  String _accesstoken;
  
  Token(this._accesstoken);
  
  Token.map(dynamic obj){
    this._idtoken = obj['idtoken'];
    this._accesstoken = obj['accesstoken'];
  }

  int get idtoken => _idtoken;
  String get accesstoken => _accesstoken;

  Map<String, dynamic> toMap() {
    var mapa = new Map<String, dynamic>(); 
    // set em formato json
    if (idtoken != null){mapa["idtoken"] = _idtoken;} //verificando se id é nulo
    mapa["accesstoken"] = _accesstoken;
    return mapa;
  }
  Token.fromMap(Map<String, dynamic> mapa) {
    this._accesstoken = mapa['accesstoken'];
  }

}