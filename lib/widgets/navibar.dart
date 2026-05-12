import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ScamTap/pages/message_page.dart';
import '../pages/lookup_page.dart';

class Navibar extends StatefulWidget {
  const Navibar({super.key});

  @override
  State<Navibar> createState() => _NavibarState();
}

class _NavibarState extends State<Navibar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int selectionIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home')),
    LookupPage(),
    MessagePage(),
    Center(child: Text('Monitor')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Positioned.fill(
              child: _pages[selectionIndex],
            ),

            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double itemWidth = constraints.maxWidth / 4;

                        return Stack(
                          children: [

                            AnimatedPositioned(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              left: itemWidth * selectionIndex,
                              top: 3,
                              bottom: 3,
                              width: itemWidth,


                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                            


                            Row(
                              children: [
                                _navItem(Icons.home, 'Home', 0, itemWidth),
                                _navItem(Icons.call, 'Lookup', 1, itemWidth),
                                _navItem(Icons.message, 'Message', 2, itemWidth),
                                _navItem(Icons.bar_chart_outlined, 'Monitor', 3, itemWidth),
                              ],
                            ),

                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, double width) {
    final isSelected = selectionIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectionIndex = index),
      child: SizedBox(
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : const Color.fromARGB(255, 125, 125, 125)),
              Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : const Color.fromARGB(255, 125, 125, 125))),
            ],
          ),
        ),
      ),
    );
  }
}

