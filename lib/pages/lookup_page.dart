import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ScamTap/models/search_record_model.dart';
import 'package:ScamTap/pages/scamreport_page.dart';
import 'package:ScamTap/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/widgets/animatedhinttextfield.dart';
import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:ScamTap/pages/scanning_page.dart';

import '../widgets/scamdetectedcolorcontainer.dart';

class LookupPage extends StatefulWidget {
  const LookupPage({super.key});

  @override
  State<LookupPage> createState() => _LookupPageState();
}

class _LookupPageState extends State<LookupPage> {
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
    final String? saved = prefs.getString('last_result_lookup');
    if (saved != null) {
      setState(() {
        _resultData = jsonDecode(saved);
        _showResult = true;
      });

      _isInitialized = true;
    }
  }

  Future<void> _saveResult(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_result_lookup', jsonEncode(data));
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
            "Lookup",
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
                backgroundColor: const Color.fromARGB(255, 44, 106, 46),
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
            colors: [Colors.green, const Color.fromARGB(255, 199, 199, 199)],
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
                      "Verify Number / Link",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedHintTextField(
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
                    "Recent Lookup",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: FilterSelection(),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: _showResult ? 100 : 160,
                      ),
                      child: Column (
                        children: [
                          Icon(Icons.warning_rounded, color: Colors.red, size: 30,),
                          SizedBox(height: 5),
                          Text(
                            "No record found!",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    );
                  }

                  final records = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: SizedBox(
                          width: double.infinity,
                          height: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScamreportPage(
                                    result    : record.rawData ?? {},
                                    inputText : record.value,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                233,
                                247,
                                235,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        44,
                                        106,
                                        46,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),

                                    SizedBox(width: 12),

                                    Text(
                                      record.value,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),

                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            78,
                                            114,
                                            84,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                255,
                                                41,
                                                92,
                                                42,
                                              ),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),

                                        child: Text(
                                          record.riskLevel,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10),

                                      Container(
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          weight: 800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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

class FilterSelection extends StatefulWidget {
  const FilterSelection({super.key});

  @override
  State<FilterSelection> createState() => _FilterSelectionState();
}

class _FilterSelectionState extends State<FilterSelection> {
  String _selected = "Call";

  @override
  Widget build(BuildContext context) {
    final icons = {"Call": Icons.phone, "Link": Icons.link};

    return Row(
      children: ["Call", "Link"].map((label) {
        final isActive = _selected == label;
        return Padding(
          padding: EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selected = label),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? Color.fromARGB(255, 44, 106, 46)
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[label],
                    size: 16,
                    color: isActive
                        ? Colors.white
                        : Color.fromARGB(255, 44, 106, 46),
                  ),
                  SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : Color.fromARGB(255, 44, 106, 46),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


// class ScamDetectedColorContainer extends StatefulWidget {
//   const ScamDetectedColorContainer({super.key});

//   @override
//   State<ScamDetectedColorContainer> createState() => _ScamDetectedColorContainerState();
// }

// class _ScamDetectedColorContainerState extends State<ScamDetectedColorContainer> {
//   final IndicatorColor = {
//     "Dangerous": Colors.redAccent,
//     "Warning": Color.fromRGBO(252, 220, 114, 1),
//     "Safe": Colors.greenAccent,
//   };
  
//   String _currentStatus = "Warning";
  
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         width: double.infinity,
//         height: 170,
//         decoration: BoxDecoration(
//           color: IndicatorColor[_currentStatus],
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Color.fromARGB(255, 248, 195, 72), width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Row(
//                     children: [

//                       Icon(
//                         Icons.warning,
//                         color: const Color.fromARGB(255, 0, 0, 0),
//                         size: 20.0,
//                         semanticLabel: 'Text to announce in acce',
//                         ),
                      
//                       SizedBox(width: 10),

//                       Text(
//                         "Scam Detected",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 10),

//                   Text(
//                     "Avoid interaction immediately",
//                     style: TextStyle(fontSize: 13),
//                   ),

//                   SizedBox(height: 5),

//                   Row(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 0,
//                           vertical: 10,
//                         ),
//                         child: SizedBox(
//                           width: 130,
//                           height: 35,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => const ScamreportPage()),
//                               );
//                             },
//                             child: Text(
//                               "Check Report",
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(width: 8),
                      
//                       SizedBox(
//                         width: 35,
//                         height: 35,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             print("clicked!");
//                           },
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: Icon(Icons.report, size: 18),
//                         ),
//                       ),
//                     ],
//                   ),

//                   // SizedBox(width: 10),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
//               child: SizedBox(
//               width: 120,
//               height: 120,
//               child: Scoregauge(score: 85),
//             ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }