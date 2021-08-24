import 'dart:io';
import 'dart:convert';

class Imgconversor{
  
  Future<String> tobase64(File image) async{
    //print("caminho: " + image.path.split('.').last);
    String imgextension = image.path.split('.').last;
    List<int> imageBytes = await image.readAsBytesSync();
    //print(imageBytes);
    String base64Image = await base64Encode(imageBytes);
    //print("base64: $base64Image");
    String resul = "url('data:image/$imgextension;base64,$base64Image)";
    return resul;
  }

  
}
