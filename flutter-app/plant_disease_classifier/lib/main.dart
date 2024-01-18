import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:developer' as dev_log;
import 'package:image/image.dart' as img;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? imageFile;
  final String endpoint =
      'https://us-central1-future-graph-411205.cloudfunctions.net/predict';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageFile != null)
                  Container(
                    width: 640,
                    height: 480,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(image: FileImage(imageFile!)),
                        border: Border.all(width: 8, color: Colors.black12),
                        borderRadius: BorderRadius.circular(12.0)),
                  )
                else
                  Container(
                    width: 640,
                    height: 480,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 8, color: Colors.black12),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: const Text(
                      'Image should appear here',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () => getImage(source: ImageSource.camera),
                          child: const Text('Capture image',
                              style: TextStyle(fontSize: 18))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () =>
                              getImage(source: ImageSource.gallery),
                          child: const Text('Select Image',
                              style: TextStyle(fontSize: 18))),
                    )
                  ],
                )
              ],
            )));
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        // imageFile = File(file!.path);
        sendPredictionRequest(file!.path);
      });
    }
  }

  void sendPredictionRequest(String imagePath) async {
    List<int> imageBytes = await File(imagePath).readAsBytes();
    Future

    String jsonString = json.encode(jsonData);
    dev_log.log(jsonString);

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    if (response.statusCode == 200) {
      dev_log.log(response.body);
    } else {
      dev_log.log('Prediction request failed: ${response.statusCode}');
    }
  }
}
