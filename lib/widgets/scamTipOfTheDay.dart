// scam_tip_of_the_day.dart
import 'package:flutter/material.dart';

class ScamTipOfTheDay extends StatelessWidget {
  const ScamTipOfTheDay({super.key});

  static const List<Map<String, String>> _tips = [
    {
      'title': 'Macau Scam',
      'tip': 'Scammers pose as police or government officials claiming you\'re involved in a crime. Real authorities will NEVER ask you to transfer money over the phone.',
      'icon': 'badge',
    },
    {
      'title': 'Phishing Links',
      'tip': 'Always check the URL before entering any login details. Scam sites often mimic real ones with slight misspellings like "mayb4nk.com" or "shopee-prize.xyz".',
      'icon': 'link',
    },
    {
      'title': 'OTP / TAC Codes',
      'tip': 'Never share your OTP or TAC code with anyone — including people claiming to be bank staff. Banks will never ask for these codes.',
      'icon': 'pin',
    },
    {
      'title': 'Love Scam',
      'tip': 'Be cautious of strangers online who build deep relationships quickly then ask for money. If someone you\'ve never met asks for financial help, it\'s likely a scam.',
      'icon': 'favorite',
    },
    {
      'title': 'Investment Scam',
      'tip': 'Promises of high returns with zero risk are a red flag. Always verify investment platforms with the Securities Commission Malaysia (SC) before investing.',
      'icon': 'trending_up',
    },
    {
      'title': 'Parcel Scam',
      'tip': 'Scammers claim you have an undelivered parcel with issues. They\'ll ask for personal info or fees. Always check directly with the official courier website.',
      'icon': 'inventory_2',
    },
    {
      'title': 'Job Scam',
      'tip': 'Legitimate employers never ask you to pay upfront fees or buy equipment for a job. If an offer seems too good to be true, verify the company independently.',
      'icon': 'work',
    },
    {
      'title': 'Loan Scam',
      'tip': 'Unlicensed money lenders (Ah Long) may pose as legitimate loan companies online. Always verify with Bank Negara Malaysia\'s registered financial institutions list.',
      'icon': 'account_balance',
    },
    {
      'title': 'Prize / Lottery Scam',
      'tip': 'You can\'t win a contest you never entered. Messages saying "You won RM500!" are almost always scams designed to steal your personal details.',
      'icon': 'emoji_events',
    },
    {
      'title': 'E-Commerce Scam',
      'tip': 'Only pay through official platform payment gateways. Sellers asking for direct bank transfers outside the app have no buyer protection if they disappear.',
      'icon': 'shopping_cart',
    },
    {
      'title': 'Impersonation Scam',
      'tip': 'Scammers clone social media profiles of your friends to ask for money. Always call the real person directly to verify before sending any funds.',
      'icon': 'person_off',
    },
    {
      'title': 'Tech Support Scam',
      'tip': 'Popups claiming your device is infected and asking you to call a number are scams. Microsoft, Apple, and Google never contact you this way.',
      'icon': 'computer',
    },
    {
      'title': 'SMS Phishing (Smishing)',
      'tip': 'Suspicious SMS with links claiming to be from your bank or government agencies? Don\'t click — go directly to the official app or website instead.',
      'icon': 'sms',
    },
    {
      'title': 'Rental Scam',
      'tip': 'Fake landlords post attractive rental listings then request deposits before viewing. Always insist on a physical viewing before any payment.',
      'icon': 'home',
    },
    {
      'title': 'Social Media Scam',
      'tip': 'Be wary of sponsored ads on social media selling branded goods at huge discounts. Many are counterfeit products or outright scams with no delivery.',
      'icon': 'thumb_down',
    },
    {
      'title': 'Charity Scam',
      'tip': 'Verify charities before donating, especially after disasters. Scammers exploit tragedies to collect fake donations. Use official charity registration lookups.',
      'icon': 'volunteer_activism',
    },
    {
      'title': 'QR Code Scam',
      'tip': 'Scammers replace legitimate QR codes with malicious ones in public places. Always verify the destination URL after scanning before proceeding.',
      'icon': 'qr_code',
    },
    {
      'title': 'Voice Cloning Scam',
      'tip': 'AI can now clone voices. If a "family member" calls asking for emergency money, hang up and call them back on their known number to verify.',
      'icon': 'record_voice_over',
    },
    {
      'title': 'Cryptocurrency Scam',
      'tip': 'Fake crypto exchanges and wallet apps can steal your funds instantly. Only use well-known exchanges and never share your seed phrase with anyone.',
      'icon': 'currency_bitcoin',
    },
    {
      'title': 'Government Grant Scam',
      'tip': 'Scammers send messages about fake BRIM, BSH, or other government grants requiring personal details. Always check official government portals only.',
      'icon': 'account_balance_wallet',
    },
    {
      'title': 'Deepfake Scam',
      'tip': 'Video calls showing a "celebrity" or "CEO" endorsing investments are often deepfakes. Don\'t trust any investment promoted solely through video calls or social media.',
      'icon': 'videocam_off',
    },
    {
      'title': 'Overpayment Scam',
      'tip': 'A buyer sends you a cheque for more than the agreed price and asks for the difference back. The original cheque will bounce — never refund before funds clear.',
      'icon': 'money_off',
    },
    {
      'title': 'Ticket Scam',
      'tip': 'Fake concert or event tickets sold through unofficial channels are a common scam. Always buy tickets from official box offices or verified resellers.',
      'icon': 'confirmation_number',
    },
    {
      'title': 'Emergency Scam',
      'tip': 'Scammers call pretending a family member is in an accident and needs money urgently. Stay calm, hang up, and verify directly with your family member first.',
      'icon': 'emergency',
    },
    {
      'title': 'Subscription Trap',
      'tip': '"Free trial" offers that quietly charge your card monthly. Read terms carefully before entering payment details and check your bank statements regularly.',
      'icon': 'repeat',
    },
    {
      'title': 'Romance Investment Scam (Pig Butchering)',
      'tip': 'Scammers build romantic relationships over weeks then introduce a "guaranteed" crypto investment. This is known as pig butchering — report it immediately.',
      'icon': 'heart_broken',
    },
    {
      'title': 'Survey Scam',
      'tip': 'Online surveys offering large cash rewards for personal info are scams. Legitimate surveys never ask for your IC number, bank details, or passwords.',
      'icon': 'poll',
    },
    {
      'title': 'Account Takeover',
      'tip': 'If you receive unexpected 2FA codes you didn\'t request, someone may be trying to access your account. Change your password immediately and enable stronger 2FA.',
      'icon': 'no_accounts',
    },
    {
      'title': 'Mule Account Warning',
      'tip': 'Never let others use your bank account to receive and transfer money for a fee — this makes you a money mule, which is a criminal offence in Malaysia.',
      'icon': 'warning',
    },
    {
      'title': 'Screen Sharing Scam',
      'tip': 'Never share your screen with unsolicited callers claiming to help fix your device or bank account. They will steal your credentials and banking details live.',
      'icon': 'screen_share',
    },
    {
      'title': 'Two-Factor Authentication',
      'tip': 'Enable 2FA on all your important accounts — email, banking, and social media. Even if your password is stolen, 2FA adds a critical second layer of protection.',
      'icon': 'security',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dayIndex = DateTime.now().difference(DateTime(2026, 1, 1)).inDays;
    final tip = _tips[dayIndex % _tips.length];

    final IconData icon = _resolveIcon(tip['icon']!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Scam Tip of the Day",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 90, 117, 80),
                const Color.fromARGB(255, 58, 94, 71),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 143, 142, 142),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tip['title']!,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    tip['tip']!,
                    style: const TextStyle(fontSize: 13.5, color: Colors.white, height: 1.55),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.autorenew_rounded, color: Colors.white70, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        "Updates daily",
                        style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon(String name) {
    const map = {
      'badge': Icons.badge,
      'link': Icons.link,
      'pin': Icons.pin,
      'favorite': Icons.favorite,
      'trending_up': Icons.trending_up,
      'inventory_2': Icons.inventory_2,
      'work': Icons.work,
      'account_balance': Icons.account_balance,
      'emoji_events': Icons.emoji_events,
      'shopping_cart': Icons.shopping_cart,
      'person_off': Icons.person_off,
      'computer': Icons.computer,
      'sms': Icons.sms,
      'home': Icons.home,
      'thumb_down': Icons.thumb_down,
      'volunteer_activism': Icons.volunteer_activism,
      'qr_code': Icons.qr_code,
      'record_voice_over': Icons.record_voice_over,
      'currency_bitcoin': Icons.currency_bitcoin,
      'account_balance_wallet': Icons.account_balance_wallet,
      'videocam_off': Icons.videocam_off,
      'money_off': Icons.money_off,
      'confirmation_number': Icons.confirmation_number,
      'emergency': Icons.emergency,
      'repeat': Icons.repeat,
      'heart_broken': Icons.heart_broken,
      'poll': Icons.poll,
      'no_accounts': Icons.no_accounts,
      'warning': Icons.warning,
      'screen_share': Icons.screen_share,
      'security': Icons.security,
    };
    return map[name] ?? Icons.lightbulb_outline;
  }
}