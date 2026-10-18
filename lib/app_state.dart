import 'package:flutter/material.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  static final AppState i = AppState();

  ThemeMode theme = ThemeMode.light;
  bool urdu = false, loggedIn = false, push = true, emailOffers = false;
  int tab = 0;
  String name = 'Ali Raza', email = 'ali.raza@email.com', phone = '', role = 'Student';
  String? card;
  String payment = 'Pay at arrival';
  final Set<String> saved = {'stay_5', 'stay_2', 'stay_1'};
  late final List<Booking> bookings = [
    Booking('BM-20418', kStays[0], kStays[0].rooms[0], DateTime(2026, 10, 18), DateTime(2026, 10, 21), 1, 'Pay at arrival', 'Confirmed'),
    Booking('BM-20533', kStays[4], kStays[4].rooms[0], DateTime(2026, 11, 2), DateTime(2026, 11, 4), 1, 'Pay at arrival', 'Pending'),
    Booking('BM-19877', kStays[7], kStays[7].rooms[0], DateTime(2026, 9, 3), DateTime(2026, 9, 5), 1, 'Pay at arrival', 'Completed'),
  ];
  Stay? dStay;
  Room? dRoom;
  DateTime? dIn, dOut;
  int dGuests = 1;
  Booking? last;
  int _n = 20600;

  void update(void Function() f) {
    f();
    notifyListeners();
  }

  void toggleSaved(String id) {
    if (saved.contains(id)) {
      saved.remove(id);
    } else {
      saved.add(id);
    }
    notifyListeners();
  }

  void startDraft(Stay s) {
    final t = DateTime.now();
    dStay = s;
    dRoom = s.rooms.first;
    dIn = DateTime(t.year, t.month, t.day).add(const Duration(days: 7));
    dOut = dIn!.add(const Duration(days: 3));
    dGuests = 1;
    notifyListeners();
  }

  Booking confirm() {
    final b = Booking('BM-${_n++}', dStay!, dRoom!, dIn!, dOut!, dGuests, payment, 'Confirmed');
    bookings.insert(0, b);
    last = b;
    notifyListeners();
    return b;
  }
}

const _ur = {
  'Assalam o Alaikum': 'السلام علیکم',
  'Where will you\nstay in Islamabad?': 'اسلام آباد میں\nکہاں ٹھہریں گے؟',
  'Hostel, area or university': 'ہاسٹل، علاقہ یا یونیورسٹی',
  'All': 'سب', 'Hotels': 'ہوٹل', 'Hostels': 'ہاسٹل', 'Guest Houses': 'گیسٹ ہاؤس',
  'Hotel': 'ہوٹل', 'Hostel': 'ہاسٹل', 'Guest House': 'گیسٹ ہاؤس',
  'Student and job-seeker deals': 'طلبہ اور ملازمت کے متلاشیوں کے لیے آفرز',
  'Up to 15% off near universities and offices': 'یونیورسٹیوں اور دفاتر کے قریب 15 فیصد تک رعایت',
  'Featured stays': 'نمایاں قیام', 'See all': 'سب دیکھیں', 'Browse by area': 'علاقے کے مطابق دیکھیں',
  'Explore': 'ایکسپلور', 'Saved': 'محفوظ', 'Trips': 'سفر', 'Profile': 'پروفائل',
  'Welcome back': 'خوش آمدید',
  'Log in to see your trips and saved stays.': 'اپنے سفر اور محفوظ قیام دیکھنے کے لیے لاگ ان کریں۔',
  'Email': 'ای میل', 'Password': 'پاس ورڈ', 'Enter password': 'پاس ورڈ لکھیں',
  'Forgot password?': 'پاس ورڈ بھول گئے؟', 'Log in': 'لاگ ان', 'or': 'یا',
  'Continue with Google': 'گوگل کے ساتھ جاری رکھیں', 'New to BookMe?': 'بک می پر نئے ہیں؟',
  'Create account': 'اکاؤنٹ بنائیں', 'Settings': 'سیٹنگز', 'Language': 'زبان',
  'My trips': 'میرے سفر', 'Upcoming': 'آنے والے', 'Past': 'گزشتہ', 'Book now': 'ابھی بک کریں',
};

String tr(String s) => AppState.i.urdu ? (_ur[s] ?? s) : s;
