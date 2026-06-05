import 'dart:convert';
import 'package:ScamTap/pages/free_users/premium_purchase_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ScamTap/models/search_record_model.dart';
import 'package:ScamTap/pages/free_users/scamreport_page.dart';
import 'package:ScamTap/services/firestore_service.dart';
import 'package:ScamTap/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/widgets/animatedhinttextfield.dart';
import 'package:ScamTap/widgets/miniprofile.dart';
import 'package:ScamTap/widgets/scoregauge.dart';
import 'package:ScamTap/pages/free_users/scanning_page.dart';

import '../../widgets/scamdetectedcolorcontainer.dart';

class LookupPage extends StatefulWidget {
  const LookupPage({super.key});

  @override
  State<LookupPage> createState() => _LookupPageState();
}

class _LookupPageState extends State<LookupPage> {
  bool _showResult = false;
  Map<String, dynamic>? _resultData;
  bool _isInitialized = false;
  String _selectedFilter = 'Call';
  final _cacheService = CacheService();

  @override
  void initState() {
    super.initState();
    _loadLastResult();
  }

  Future<void> _loadLastResult() async {
    final resultData = await _cacheService.getResult('last_result_lookup');
    if (resultData != null) {
      setState(() {
        _resultData = resultData;
        _showResult = true;
      });
    }

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _saveResult(Map<String, dynamic> data) async {
    await _cacheService.saveResult('last_result_lookup', data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text("Lookup", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumPurchasePage())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFC940), Color(0xFFFF9500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFFFFC940).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 15),
                    SizedBox(width: 4),
                    Text('PRO', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Miniprofile())),
              child: const CircleAvatar(backgroundColor: Color.fromARGB(255, 55, 126, 57), child: Icon(Icons.person, color: Colors.white)),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                child: FilterSelection(
                  selected: _selectedFilter,
                  onChanged: (val) => setState(() => _selectedFilter = val),
                ),
              ),

              SizedBox(height: 10),

              StreamBuilder<List<SearchRecordModel>>(
                stream: FirestoreService().getSearchHistory(),
                builder: (context, snapshot) {
                  final allRecords = snapshot.data ?? [];
                  final records = allRecords.where((r) {
                    if (_selectedFilter == 'Call') return r.type == 'phone';
                    if (_selectedFilter == 'Link') return r.type == 'link';
                    return true;
                  }).toList();

                  if (snapshot.connectionState == ConnectionState.waiting && allRecords.isEmpty) {
                    return const SizedBox(
                      height: 60,
                      child: Center(child: CircularProgressIndicator(color: Colors.white)),
                    );
                  }

                  if (records.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off_rounded, color: Colors.white70, size: 30),
                          const SizedBox(height: 5),
                          Text(
                            allRecords.isEmpty
                                ? "No record found!"
                                : "No ${_selectedFilter == 'Call' ? 'phone' : 'link'} records found!",
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
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
                                      CircleAvatar(
                                        backgroundColor: const Color.fromARGB(255, 44, 106, 46),
                                        child: Icon(
                                          record.type == 'phone' ? Icons.phone : Icons.link,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(record.value, style: const TextStyle(fontSize: 14)),
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

              // StreamBuilder<List<SearchRecordModel>>(
              //   stream: FirestoreService().getSearchHistory(),
              //   builder: (context, snapshot) {
              //     // USE LAST DATA while loading — no blink
              //     final allRecords = snapshot.data ?? [];

              //     final records = allRecords.where((r) {
              //       if (_selectedFilter == 'Call') return r.type == 'phone';
              //       if (_selectedFilter == 'Link') return r.type == 'link';
              //       return true;
              //     }).toList();

              //     if (snapshot.connectionState == ConnectionState.waiting && allRecords.isEmpty) {
              //       return const SizedBox(
              //         height: 60,
              //         child: Center(child: CircularProgressIndicator(color: Colors.white)),
              //       );
              //     }

              //     if (records.isEmpty) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const Icon(Icons.search_off_rounded, color: Colors.white70, size: 30),
              //             const SizedBox(height: 5),
              //             Text(
              //               allRecords.isEmpty
              //                   ? "No record found!"
              //                   : "No ${_selectedFilter == 'Call' ? 'phone' : 'link'} records found!",
              //               style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
              //             ),
              //           ],
              //         ),
              //       );
              //     }

              //     return ListView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemCount: records.length,
              //       itemBuilder: (context, index) {
              //         final record = records[index];
              //         return Padding(
              //           padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              //           child: SizedBox(
              //             height: 90,
              //             child: ElevatedButton(
              //               onPressed: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => ScamreportPage(
              //                       result: record.rawData ?? {},
              //                       inputText: record.value,
              //                     ),
              //                   ),
              //                 );
              //               },
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: const Color.fromARGB(255, 233, 247, 235),
              //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              //               ),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Row(
              //                     children: [
              //                       CircleAvatar(
              //                         backgroundColor: const Color.fromARGB(255, 44, 106, 46),
              //                         child: Icon(
              //                           record.type == 'phone' ? Icons.phone : Icons.link,
              //                           color: Colors.white,
              //                         ),
              //                       ),
              //                       const SizedBox(width: 12),
              //                       Text(record.value, style: const TextStyle(fontSize: 14)),
              //                     ],
              //                   ),
              //                   Row(
              //                     children: [
              //                       Container(
              //                         width: 80,
              //                         height: 30,
              //                         alignment: Alignment.center,
              //                         decoration: BoxDecoration(
              //                           color: record.riskLevel == 'Dangerous'
              //                               ? Colors.red.shade700
              //                               : record.riskLevel == 'Warning'
              //                                   ? Colors.orange.shade700
              //                                   : const Color.fromARGB(255, 78, 114, 84),
              //                           borderRadius: BorderRadius.circular(30),
              //                         ),
              //                         child: Text(
              //                           record.riskLevel,
              //                           style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              //                         ),
              //                       ),
              //                       const SizedBox(width: 10),
              //                       const Icon(Icons.arrow_forward_ios_rounded),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterSelection extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const FilterSelection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final icons = {"Call": Icons.phone, "Link": Icons.link};

    return Row(
      children: ["Call", "Link"].map((label) {
        final isActive = selected == label;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color.fromARGB(255, 44, 106, 46) : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[label],
                    size: 16,
                    color: isActive ? Colors.white : const Color.fromARGB(255, 44, 106, 46),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color.fromARGB(255, 44, 106, 46),
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