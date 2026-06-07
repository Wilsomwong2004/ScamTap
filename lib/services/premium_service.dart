import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumService {
  static const String _premiumCacheKey = 'is_premium';
  static const String _premiumExpiryKey = 'premium_expiry';
  static const String _dailyScanCountKey = 'daily_scan_count';
  static const String _lastScanDateKey = 'last_scan_date';
  
  static Future<bool> isPremium() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    
    final prefs = await SharedPreferences.getInstance();
    final cachedPremium = prefs.getBool('${_premiumCacheKey}_${user.uid}');
    final cachedExpiry = prefs.getString('${_premiumExpiryKey}_${user.uid}');
    
    if (cachedPremium != null && cachedExpiry != null) {
      final expiryDate = DateTime.parse(cachedExpiry);
      if (DateTime.now().isBefore(expiryDate)) {
        return cachedPremium;
      }
    }
    
    final doc = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(user.uid)
        .get();
    
    final role = doc.data()?['Role'] ?? 'free user';
    final isPremium = role == 'premium user';
    final premiumExpiry = doc.data()?['premiumExpiry'] as Timestamp?;
    
    if (premiumExpiry != null) {
      await prefs.setBool('${_premiumCacheKey}_${user.uid}', isPremium);
      await prefs.setString('${_premiumExpiryKey}_${user.uid}', premiumExpiry.toDate().toIso8601String());
    } else {
      await prefs.setBool('${_premiumCacheKey}_${user.uid}', isPremium);
      await prefs.setString('${_premiumExpiryKey}_${user.uid}', DateTime.now().add(const Duration(days: 365)).toIso8601String());
    }
    
    return isPremium;
  }
  
  static Future<int> getDailyScanLimit() async {
    final isPremiumUser = await isPremium();
    return isPremiumUser ? 999999 : 5;
  }
  
  static Future<DateTime?> getPremiumExpiry() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    
    final doc = await FirebaseFirestore.instance
        .collection('usersData')
        .doc(user.uid)
        .get();
    
    final expiry = doc.data()?['premiumExpiry'] as Timestamp?;
    return expiry?.toDate();
  }
  
  static Future<bool> isPremiumValid() async {
    final isPremiumUser = await isPremium();
    if (!isPremiumUser) return false;
    
    final expiry = await getPremiumExpiry();
    if (expiry == null) return true;
    
    return DateTime.now().isBefore(expiry);
  }
  
  static Future<void> refreshPremiumStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_premiumCacheKey}_${user.uid}');
    await prefs.remove('${_premiumExpiryKey}_${user.uid}');
  }
  
  static Future<int> getRemainingScans() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;
    
    final prefs = await SharedPreferences.getInstance();
    final lastScanDate = prefs.getString('${_lastScanDateKey}_${user.uid}');
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    // Check if we need to reset for a new day
    if (lastScanDate != today) {
      // Reset for new day
      await prefs.setString('${_lastScanDateKey}_${user.uid}', today);
      await prefs.setInt('${_dailyScanCountKey}_${user.uid}', 0);
    }
    
    final scanCount = prefs.getInt('${_dailyScanCountKey}_${user.uid}') ?? 0;
    final limit = await getDailyScanLimit();
    
    final remaining = limit - scanCount;
    return remaining > 0 ? remaining : 0;
  }
  
  static Future<void> incrementScanCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt('${_dailyScanCountKey}_${user.uid}') ?? 0;
    await prefs.setInt('${_dailyScanCountKey}_${user.uid}', currentCount + 1);
  }
  
  static Future<int> getTodayScanCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;
    
    final prefs = await SharedPreferences.getInstance();
    final lastScanDate = prefs.getString('${_lastScanDateKey}_${user.uid}');
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastScanDate != today) {
      return 0;
    }
    
    return prefs.getInt('${_dailyScanCountKey}_${user.uid}') ?? 0;
  }
  
  static Future<void> resetUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_dailyScanCountKey}_${user.uid}');
    await prefs.remove('${_lastScanDateKey}_${user.uid}');
    await prefs.remove('${_premiumCacheKey}_${user.uid}');
    await prefs.remove('${_premiumExpiryKey}_${user.uid}');
  }
}