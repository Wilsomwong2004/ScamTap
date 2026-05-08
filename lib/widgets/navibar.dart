import 'package:flutter/material.dart';
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
    Center(child: Text('Message')),
    Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            _pages[selectionIndex],

            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                _navItem(Icons.settings, 'Settings', 3, itemWidth),
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
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey),
              Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

