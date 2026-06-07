import 'dart:async';

import 'package:ScamTap/services/scam_service.dart';
import 'package:ScamTap/pages/free_users/scanning_page.dart';
import 'package:ScamTap/services/premium_service.dart';
import 'package:ScamTap/pages/free_users/premium_purchase_page.dart';
import 'package:flutter/material.dart';

class AnimatedHintTextField extends StatefulWidget {
  final Function(bool, Map<String, dynamic>?)? onResultRecieved;
  final bool isMessage;
  final TextEditingController? controller;
  final VoidCallback? onRefreshRequired;

  const AnimatedHintTextField({
    super.key, 
    this.onResultRecieved, 
    this.isMessage = false,
    this.controller,
    this.onRefreshRequired,
  });

  @override
  State<AnimatedHintTextField> createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<AnimatedHintTextField> {
  final List<String> _hints = [
    "+60113223413",
    "https://google.com/link",
  ];

  late final TextEditingController _internalController;
  bool _isLoading = false;
  bool _hasError = false;
  Map<String, dynamic>? _result;
  int _currentIndex = 0;
  Timer? _timer;

  TextEditingController get _effectiveController => 
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _hints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _internalController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _showPremiumLimitDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Limit Reached'),
        content: const Text('You have used your 5 free scans today. Upgrade to Premium for unlimited scans.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PremiumPurchasePage()),
              );
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit(String value) async {
    final input = _effectiveController.text.trim();
    final isPhone = RegExp(r'^[0-9+\-\s().]+$').hasMatch(input);
    final isUrl   = input.startsWith('http') || input.startsWith('www') || input.contains('.');

    if (widget.isMessage) {
      if (input.isEmpty || isPhone || isUrl) {
        setState(() => _hasError = true);
        return;
      }
    } else {
      if (input.isEmpty || (!isPhone && !isUrl)) {
        setState(() => _hasError = true);
        return;
      }
    }

    final isPremium = await PremiumService.isPremium();
    final remaining = await PremiumService.getRemainingScans();
    
    if (!isPremium && remaining <= 0) {
      _showPremiumLimitDialog();
      return;
    }

    setState(() {
      _hasError  = false;
      _isLoading = true;
      _result    = null;
    });

    widget.onResultRecieved?.call(false, null);

    await PremiumService.incrementScanCount();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanningPage(
          inputText : input,
          inputType : widget.isMessage ? "Message" : (isPhone ? "Call" : "URL"),
          onResult  : (data) {
            setState(() {
              _isLoading = false;
              _result    = data;
            });
            if (data != null && data.isNotEmpty) {
              widget.onResultRecieved?.call(true, data);
            }
          },
        ),
      ),
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
      widget.onRefreshRequired?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _effectiveController,
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
            widget.isMessage
                ? "Enter message here..."
                : _hints[_currentIndex],
            key: ValueKey<String>(
              widget.isMessage
                  ? "message_hint"
                  : _hints[_currentIndex],
            ),
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
                    _onSubmit(_effectiveController.text);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.isMessage ? const Color.fromARGB(255, 76, 87, 175): Colors.green,
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
            width: 3,
            color: _hasError ? Colors.red : Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 1,
            color: _hasError ? Colors.red : widget.isMessage ? const Color.fromARGB(255, 76, 87, 175) : Colors.green,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 2,
            color: _hasError ? Colors.red : widget.isMessage ? const Color.fromARGB(255, 76, 87, 175) : Colors.green,
          ),
        ),
      ),
    );
  }
}