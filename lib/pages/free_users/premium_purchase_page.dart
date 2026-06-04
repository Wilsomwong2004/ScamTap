import 'package:flutter/material.dart';

class PremiumPurchasePage extends StatefulWidget {
  const PremiumPurchasePage({super.key});

  @override
  State<PremiumPurchasePage> createState() => _PremiumPurchasePageState();
}

class _PremiumPurchasePageState extends State<PremiumPurchasePage> {
  int _selectedPlanIndex = 1;

  final List<_PlanOption> _plans = [
    _PlanOption(
      label: 'Monthly',
      price: 'RM 9.90',
      period: '/ month',
      subtext: 'Billed monthly',
      badge: null,
    ),
    _PlanOption(
      label: 'Yearly',
      price: 'RM 4.90',
      period: '/ month',
      subtext: 'Billed RM 58.80/year',
      badge: 'BEST VALUE',
    ),
    _PlanOption(
      label: 'Lifetime',
      price: 'RM 99.00',
      period: 'once',
      subtext: 'Pay once, own forever',
      badge: null,
    ),
  ];

  // ─── Colours ────────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFF5F5EE);
  static const _cardBg = Color(0xFFFFFFFF);
  static const _green = Color(0xFF3CB873);
  static const _greenLight = Color(0xFFE8F7EE);
  static const _greenDark = Color(0xFF2A9057);
  static const _accent = Color(0xFFFFC940);
  static const _textPrimary = Color(0xFF1A1A1A);
  static const _textSecondary = Color(0xFF7A7A7A);
  static const _border = Color(0xFFE0E0D8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildHeroCard(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Choose your plan'),
                    const SizedBox(height: 12),
                    ..._buildPlanCards(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('Everything included'),
                    const SizedBox(height: 12),
                    _buildFeaturesCard(),
                    const SizedBox(height: 24),
                    _buildTrustRow(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ─── App bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: _textPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'ScamTap Premium',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // ─── Hero card ──────────────────────────────────────────────────────────────
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2DB868), Color(0xFF1A9050)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _green.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Full Scam Protection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Real-time alerts, unlimited lookups, and AI-powered detection — all in one.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Trusted by 50,000+ Malaysians',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Section label ──────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }

  // ─── Plan cards ─────────────────────────────────────────────────────────────
  List<Widget> _buildPlanCards() {
    return List.generate(_plans.length, (i) {
      final plan = _plans[i];
      final selected = _selectedPlanIndex == i;
      return GestureDetector(
        onTap: () => setState(() => _selectedPlanIndex = i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? _greenLight : _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? _green : _border,
              width: selected ? 2 : 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _green.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? _green : Colors.transparent,
                  border: Border.all(
                    color: selected ? _green : _border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 13)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: selected ? _greenDark : _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plan.subtext,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        plan.price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: selected ? _greenDark : _textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          plan.period,
                          style: const TextStyle(
                            fontSize: 11,
                            color: _textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (plan.badge != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        plan.badge!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7A5200),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── Features card ──────────────────────────────────────────────────────────
  Widget _buildFeaturesCard() {
    final features = [
      (Icons.notifications_active_rounded, 'Real-time scam alerts',
          'Get notified instantly for your area'),
      (Icons.search_rounded, 'Unlimited number lookups',
          'Check any number anytime'),
      (Icons.smart_toy_rounded, 'AI message analysis',
          'Paste any message for instant verdict'),
      (Icons.bar_chart_rounded, 'Scam activity monitor',
          'Live heatmap of scam activity near you'),
      (Icons.block_rounded, 'Auto-block known scammers',
          'Over 200,000 numbers flagged'),
      (Icons.support_agent_rounded, 'Priority support',
          'Get help when you need it most'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border, width: 1.5),
      ),
      child: Column(
        children: features.asMap().entries.map((entry) {
          final i = entry.key;
          final f = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < features.length - 1 ? 14 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _greenLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(f.$1, color: _green, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.$2,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f.$3,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: _textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Trust row ──────────────────────────────────────────────────────────────
  Widget _buildTrustRow() {
    final items = [
      (Icons.lock_outline_rounded, 'Secure\nPayment'),
      (Icons.replay_rounded, 'Cancel\nAnytime'),
      (Icons.verified_user_outlined, '7-Day\nRefund'),
    ];
    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Column(
                children: [
                  Icon(item.$1, color: _green, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: _textSecondary,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ─── Success dialog ─────────────────────────────────────────────────────────
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: _greenLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: _green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Purchase Successful!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to becoming a Premium user.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: _textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // go back to home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Bottom bar ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    final plan = _plans[_selectedPlanIndex];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: _cardBg,
        border: const Border(top: BorderSide(color: _border, width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _showSuccessDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Get ${plan.label} — ${plan.price}',
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${plan.subtext} · Cancel anytime',
            style: const TextStyle(
              fontSize: 11.5,
              color: _textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Data class ─────────────────────────────────────────────────────────────
class _PlanOption {
  final String label;
  final String price;
  final String period;
  final String subtext;
  final String? badge;

  const _PlanOption({
    required this.label,
    required this.price,
    required this.period,
    required this.subtext,
    required this.badge,
  });
}