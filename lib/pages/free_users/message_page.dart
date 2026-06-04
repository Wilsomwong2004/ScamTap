import 'dart:convert';
import 'package:ScamTap/widgets/scamdetectedcolorcontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ScamTap/models/search_record_model.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';
import 'package:ScamTap/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/widgets/animatedhinttextfield.dart';
import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:ScamTap/pages/free_users/scanning_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool _showResult = false;
  Map<String, dynamic>? _resultData;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadLastResult();
  }

  Future<void> _loadLastResult() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('last_result_message');
    if (saved != null) {
      setState(() {
        _resultData = jsonDecode(saved);
        _showResult = true;
      });
    }
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _saveResult(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_result_message', jsonEncode(data));
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(
            "Messages",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Miniprofile()),
                );
              },
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 44, 51, 106),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 76, 102, 175), const Color.fromARGB(255, 199, 199, 199)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: kToolbarHeight + 55, bottom: 100),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify Message",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedHintTextField(
                      isMessage: true,
                      onResultRecieved:
                          (bool hasResult, Map<String, dynamic>? data) async {
                            if (hasResult && data != null) {
                              await _saveResult(data);
                            }
                            setState(() {
                              _showResult = hasResult;
                              _resultData = data;
                            });
                          },
                    ),
                  ],
                ),
              ),


              SizedBox(height: 15),

              AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: !_isInitialized
                    ? SizedBox.shrink(key: ValueKey('loading'))
                    : _showResult
                        ? ScamDetectedColorContainer(
                            key: ValueKey('result'),
                            result: _resultData,
                          )
                        : SizedBox.shrink(key: ValueKey('empty')),
              ),

              SizedBox( height: _showResult ? 25 : 10,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Recent Message",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),

              // Row(
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.fromLTRB(20, 5, 15, 5),
              //       child: SizedBox(
              //         width: 110,
              //         height: 40,
              //         child: ElevatedButton.icon(
              //           onPressed: () {
              //             print("clicked!");
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.white
              //           ),
              //           icon: Icon(Icons.call_sharp),
              //           label: Text("Call"),
              //         ),
              //       ),
              //     ),

              //     // SizedBox(width: 15),

              //     Padding(
              //       padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
              //       child: SizedBox(
              //         width: 110,
              //         height: 40,
              //         child: ElevatedButton.icon(
              //           onPressed: () {
              //             print("clicked!");
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.white
              //           ),
              //           icon: Icon(Icons.link),
              //           label: Text("Link"),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 10),

              StreamBuilder<List<SearchRecordModel>>(
                stream: FirestoreService().getSearchHistory(),
                builder: (context, snapshot) {
                  final allRecords = snapshot.data ?? [];
                  final records = allRecords.where((r) => r.type == 'message').toList();

                  if (snapshot.connectionState == ConnectionState.waiting && allRecords.isEmpty) {
                    return const SizedBox(
                      height: 60,
                      child: Center(child: CircularProgressIndicator(color: Colors.white)),
                    );
                  }

                  if (allRecords.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_rounded, color: Colors.red, size: 30),
                          SizedBox(height: 5),
                          Text(
                            "No record found!",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }

                  if (records.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded, color: Colors.white70, size: 30),
                          SizedBox(height: 5),
                          Text(
                            "No message records found!",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: records.map((record) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Material(
                          color: const Color.fromARGB(255, 233, 247, 235),
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScamreportPage(
                                    result: record.rawData ?? {},
                                    inputText: record.value,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Color.fromARGB(255, 44, 51, 106),
                                        child: Icon(Icons.message, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: 160,
                                        child: Text(
                                          record.value,
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: record.riskLevel == 'Dangerous'
                                              ? Colors.red.shade700
                                              : record.riskLevel == 'Warning'
                                                  ? Colors.orange.shade700
                                                  : const Color.fromARGB(255, 78, 114, 84),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          record.riskLevel,
                                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              // Column(
              //   children: [

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              //     child: Container(
              //       width: double.infinity,
              //       height: 100,
              //       decoration: BoxDecoration(
              //         color: const Color.fromARGB(255, 233, 247, 235),
              //         borderRadius: BorderRadius.circular(20),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 10,
              //             offset: Offset(0, 4),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 25),
              //     child: Container(
              //       width: double.infinity,
              //       height: 120,
              //       decoration: BoxDecoration(
              //         color: Colors.grey[400],
              //         borderRadius: BorderRadius.circular(20),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 10,
              //             offset: Offset(0, 4),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 25),
              //     child: Container(
              //       width: double.infinity,
              //       height: 120,
              //       decoration: BoxDecoration(
              //         color: Colors.grey[400],
              //         borderRadius: BorderRadius.circular(20),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 10,
              //             offset: Offset(0, 4),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}