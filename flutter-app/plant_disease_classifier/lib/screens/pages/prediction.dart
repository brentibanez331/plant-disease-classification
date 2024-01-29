import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:developer' as dev_log;
import 'package:plant_disease_classifier/components/custom_navbar.dart';
import 'package:plant_disease_classifier/screens/pages/prediction_desc.dart';
import 'package:plant_disease_classifier/utils/glassmorphism.dart';

class Prediction extends StatefulWidget {
  const Prediction({super.key});

  @override
  State<Prediction> createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  File? imageFile;
  bool isLoading = false;
  String plant = '';
  String status = '';
  double confidence = 0.0;

  Future<void> makePostRequest() async {
    try {
      const String endpoint =
          'https://us-central1-future-graph-411205.cloudfunctions.net/predict';
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));
      request.files
          .add(await http.MultipartFile.fromPath("file", imageFile!.path));

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        setState(() {
          plant = jsonResponse['plant'];
          status = jsonResponse['status'];
          confidence = jsonResponse['confidence'];
          isLoading = false;
        });
      } else {
        dev_log.log('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      dev_log.log('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingTop = screenHeight * 0.04;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 28, 26),
      body: Container(
          child: Stack(
        fit: StackFit.expand,
        children: [
          //Outside should be stack
          if (imageFile != null)
            Container(
              width: screenWidth,
              height: screenHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              color: Color.fromARGB(255, 27, 28, 26),
            ),
          Padding(
            padding: EdgeInsets.only(
                top: paddingTop, left: 30, right: 30, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth,
                  height: screenWidth - 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: imageFile == null
                          ? AssetImage('assets/predict/scanner-border.png')
                          : AssetImage('assets/predict/scanner-frame.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: imageFile == null
                      ? Center(
                          child: Text(
                            'Upload an image to start',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        )
                      : SizedBox(), // An empty SizedBox when imageFile is null
                ),
                SizedBox(height: 0),
                if (imageFile == null && !isLoading && status == '')
                  Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () =>
                                    getImage(source: ImageSource.camera),
                                child: const Text('Capture Image',
                                    style: TextStyle(fontSize: 17))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () =>
                                    getImage(source: ImageSource.gallery),
                                child: const Text('Select Image',
                                    style: TextStyle(fontSize: 17))),
                          )
                        ],
                      )
                    ],
                  )
                else if (imageFile != null && isLoading && status == '')
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 5),
                          Text('Processing...',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white))
                        ],
                      ))
                else
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: Stack(
                          children: [
                            GlassMorphism(
                              blur: 10,
                              opacity: 0.2,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(150, 220, 220, 220),
                                      Color.fromARGB(130, 200, 200, 200),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 36,
                                      offset: Offset(0, 15),
                                      color: Color.fromARGB(0, 0, 0, 50),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$plant Plant",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        // SizedBox(height: 2),
                                        Text(
                                          "Status:",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text("$status",
                                            style: TextStyle(fontSize: 18)),
                                        ElevatedButton(
                                          child: Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PredictionDesc(
                                                        plant: plant,
                                                        status: status,
                                                        confidence: confidence,
                                                        imageFile: imageFile,
                                                      )),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(30, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            backgroundColor: Color.fromARGB(
                                                255, 122, 192, 79),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          )
        ],
      )),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(220, 161, 241, 109),
                    offset: Offset(0, 22),
                    blurRadius: 50)
              ],
              color: Color.fromARGB(255, 68, 241, 166),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 159, 241, 109),
                  Color.fromARGB(255, 85, 142, 50),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Prediction()),
              );
            },
            child: ImageIcon(AssetImage('assets/nav/scan-default.png'),
                size: 35, color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(50), // Adjust the radius as needed
            ),
          )),
    );
  }

  void getImage({required ImageSource source}) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        isLoading = true;
        makePostRequest();
      });
    }
  }
}
