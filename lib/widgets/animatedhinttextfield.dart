import 'dart:async';

import 'package:ScamTap/models/scam_model.dart';
import 'package:ScamTap/pages/scanning_page.dart';
import 'package:flutter/material.dart';

class AnimatedHintTextField extends StatefulWidget {
  final Function(bool, Map<String, dynamic>?)? onResultRecieved;

  const AnimatedHintTextField({super.key, this.onResultRecieved});

  @override
  State<AnimatedHintTextField> createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<AnimatedHintTextField> {
  final List<String> _hints = [
    "+60113223413",
    "https://google.com/link",
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;
  Map<String, dynamic>? _result;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _hints.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onSubmit(String value) async {
    final input = _controller.text.trim();
    final isPhone = RegExp(r'^[0-9+\-\s().]+$').hasMatch(input);
    final isUrl   = input.startsWith('http') || input.startsWith('www') || input.contains('.');

    if (input.isEmpty || (!isPhone && !isUrl)) {
      setState(() => _hasError = true);
      return;
    }

    setState(() {
      _hasError   = false;
      _isLoading  = true;
      _result     = null;
    });

    widget.onResultRecieved?.call(false, null);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanningPage(
          inputText : input,
          inputType : isPhone ? "Call" : "URL",
          onResult  : (data) {
            setState(() {
              _isLoading = false;
              _result    = data;
            });
            if (data!.isNotEmpty) {
              widget.onResultRecieved?.call(true, data);
            }
          },
        ),
      ),
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: _onSubmit,
      onChanged: (val) {
        if (_hasError) setState(() => _hasError = false);
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 233, 247, 235),
        hint: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          layoutBuilder: (currentChild, previousChildren) => Stack(
            alignment: Alignment.centerLeft,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          ),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: Text(
            _hints[_currentIndex],
            key: ValueKey<String>(_hints[_currentIndex]),
            style: const TextStyle(
              color: Color.fromARGB(255, 108, 107, 107),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Icon(Icons.search),
        ),
        suffixIcon:
        _isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Padding(
                padding: const EdgeInsets.all(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    _onSubmit(_controller.text);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 1,
            color: _hasError ? Colors.red : Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 1,
            color: _hasError ? Colors.red : Colors.green,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 2,
            color: _hasError ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }

  void _checkValue(value, dynamic widget) async {
    final result = await fetchData(value);

    if (result != null) {
      widget.onResultReceived?.call(true);
    }
  }
}