import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev_log;

class PredictionDesc extends StatefulWidget {
  const PredictionDesc(
      {super.key,
      required this.plant,
      required this.status,
      required this.confidence,
      required this.imageFile});

  final String plant;
  final String status;
  final double confidence;
  final File? imageFile;

  @override
  State<PredictionDesc> createState() => _PredictionDescState();
}

class _PredictionDescState extends State<PredictionDesc> {
  late List<dynamic> treatments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("plants").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> filteredDocs = snapshot.data!.docs
                  .where((doc) => doc["status"] == widget.status)
                  .toList();

              // Extract the "treatment" array from the document
              if (filteredDocs[0]["treatment"] != null) {
                treatments = filteredDocs[0]["treatment"];
              } else {
                treatments = [];
                dev_log.log("Treatment is empty");
              }

              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(widget.imageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${widget.plant} Plant",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w600)),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text("${widget.status}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: widget.status != "Healthy"
                                            ? Colors.red
                                            : Colors.green))
                              ],
                            ),
                            SizedBox(height: 25),
                            Text("DESCRIPTION",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 5),
                            Text("${filteredDocs[0]["description"]}"),
                            SizedBox(height: 25),
                            Text("TREATMENT",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 5),
                            // Display each treatment in bullet format
                            if (treatments.isNotEmpty)
                              for (String treatment in treatments)
                                Text("• $treatment"),
                            SizedBox(height: 25),
                            Text("PREVENTION",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(height: 5),
                            Text("${filteredDocs[0]["treatment"]}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error.toString()}"),
              );
            } else {
              return Center(
                child: Text("No data found"),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
