import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Uint8List? bytesData;
  List<int>? selectFile;

  startPackingImageFile () async {
    html.FileUploadInputElement uploadImage = html.FileUploadInputElement();
    uploadImage.multiple=true;
    uploadImage.draggable=true;
    uploadImage.click();

    uploadImage.onChange.listen((event) {
      final files = uploadImage.files;
      final file =files![0];
      final reader = html.FileReader();
      print("files");
      print(files![0]);
      print("file");
      print(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          bytesData = Base64Decoder().convert(reader.result.toString().split(',').last);
          selectFile = bytesData;
        });
      });
      reader.readAsDataUrl(file);
    });
  }
  
  Future uploadImage() async {
    var url = Uri.parse("http://192.168.64.1:3000/api/blog/add-blog");
    var request = http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromBytes('blog_images', selectFile!,
    contentType: MediaType('application', 'json'), filename: 'blog_images'));
    request.fields['ahsan']='888';
    request.fields[{'ahsan2':'datawsa'}];
    request.fields.addAll({'ahsan24':'44'});
    var response = await request.send();
    if(response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var responseToString = String.fromCharCodes(responseData);
      var jsonBody = jsonDecode(responseToString);
      setState(() {
        print(jsonBody);
      });
    }

    ///8jjbhvn
    /// nvj

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        bytesData!=null? Image.memory(bytesData!,width: 200,height: 200,)
            :
        Image.network("http://localhost:3000/blog/blog_images_1668429576915",width: 100,height: 100,),
        ElevatedButton(onPressed: (){
          startPackingImageFile();
        }, child: Text("select")),
        ElevatedButton(onPressed: (){
          uploadImage();
        }, child: Text("upload"))
      ],),
    );
  }
}

