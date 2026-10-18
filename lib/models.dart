enum StayType {
  hotel('Hotel'),
  hostel('Hostel'),
  guestHouse('Guest House');

  final String label;
  const StayType(this.label);
}

class Review {
  final String name, date, text;
  final double rating;
  const Review(this.name, this.date, this.text, this.rating);
}

class Room {
  final String name, info;
  final int price;
  const Room(this.name, this.info, this.price);
}

class Stay {
  final String id, name, area, address, description, foodInfo, nearby;
  final StayType type;
  final int price, reviewCount, tint, discountPct;
  final double rating, food;
  final List<String> amenities, perks;
  final bool meals, family, cctv;
  final String? offer, badge;

  Stay({
    required this.id, required this.name, required this.type, required this.area,
    required this.address, required this.price, required this.rating,
    required this.reviewCount, required this.tint, required this.description,
    required this.amenities, required this.food, required this.foodInfo,
    required this.perks, required this.nearby, this.meals = false,
    this.family = true, this.cctv = true, this.offer, this.badge, this.discountPct = 0,
  });

  bool hasPerk(String p) {
    switch (p) {
      case 'Meals included': return meals;
      case 'CCTV': return cctv;
      case 'Family friendly': return family;
      case 'Wi-Fi': return amenities.any((a) => a.contains('Wi-Fi'));
      case 'Study desk': return amenities.any((a) => a.contains('Study'));
    }
    return true;
  }

  List<Room> get rooms => type == StayType.hostel
      ? [
          Room('Dorm bed, 4 beds', 'Fan and AC, locker included', price),
          Room('Dorm bed, 6 beds', 'Lockers, shared bathroom', (price * 0.8).round()),
          Room('Private room', 'Double bed, attached bathroom', (price * 2.1).round()),
        ]
      : [
          Room('Standard room', 'Queen bed, Wi-Fi, AC', price),
          Room('Deluxe room', 'King bed, extra space, AC', (price * 1.4).round()),
          Room('Family room', 'Two beds, sleeps 4', (price * 1.8).round()),
        ];
}

class Booking {
  final String id;
  final Stay stay;
  final Room room;
  DateTime checkIn, checkOut;
  final int guests;
  final String payment;
  String status; // Confirmed, Pending, Completed, Cancelled

  Booking(this.id, this.stay, this.room, this.checkIn, this.checkOut, this.guests, this.payment, this.status);

  int get nights => checkOut.difference(checkIn).inDays;
  int get subtotal => room.price * nights * (room.name.startsWith('Dorm') ? guests : 1);
  int get discount => subtotal * stay.discountPct ~/ 100;
  int get total => subtotal - discount;
  bool get upcoming => status == 'Confirmed' || status == 'Pending';
}

const _mon = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const kMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
String dShort(DateTime d) => '${_wd[d.weekday - 1]}, ${d.day} ${_mon[d.month - 1]}';
String dRange(DateTime a, DateTime b) => a.month == b.month
    ? '${a.day} - ${b.day} ${_mon[b.month - 1]} ${b.year}'
    : '${a.day} ${_mon[a.month - 1]} - ${b.day} ${_mon[b.month - 1]} ${b.year}';

String rs(int n) {
  final s = n.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return 'Rs ${n < 0 ? '-' : ''}$b';
}

const sampleReviews = [
  Review('Ali Raza', '2 weeks ago', 'Clean rooms, friendly staff and the food was great.', 5),
  Review('Hamza Khan', '1 month ago', 'Good value for the price. Location is very convenient.', 4),
  Review('Sara Ahmed', '2 months ago', 'Felt safe and comfortable. Would stay again.', 4.5),
];

// All names, prices and reviews are FICTIONAL sample data.
Stay _s(int n, String name, StayType t, String area, String address, int price, double rating, int count,
    {required String desc, required List<String> am, required double food, required String foodInfo,
    required List<String> perks, required String nearby, bool meals = false, String? offer,
    String? badge, int disc = 0, bool family = true}) {
  return Stay(
    id: 'stay_$n', name: name, type: t, area: area, address: address, price: price, rating: rating,
    reviewCount: count, tint: n, description: desc, amenities: am, food: food, foodInfo: foodInfo,
    perks: perks, nearby: nearby, meals: meals, family: family, offer: offer, badge: badge, discountPct: disc,
  );
}

final List<Stay> kStays = [
  _s(1, 'Student Nest Hostel', StayType.hostel, 'I-14', 'Sector I-14, Islamabad', 1500, 4.1, 96,
      desc: 'Budget-friendly hostel for students, with study desks and quiet hours. Close to universities.',
      am: ['Wi-Fi', 'Study desk', 'Laundry', 'Hot water', 'Common room'], food: 3.8,
      foodInfo: 'Home-style breakfast and dinner available at the hostel.',
      perks: ['Student ID: 10% off', 'Monthly package available'], nearby: 'Near Riphah University',
      offer: '10% off with student ID. Monthly package available.', badge: '10% OFF', disc: 10, family: false),
  _s(2, 'NUST Nomads Hostel', StayType.hostel, 'H-12', 'Sector H-12, Islamabad', 1800, 4.3, 134,
      desc: 'Popular with test-takers and visiting students. Clean dorms and fast internet.',
      am: ['Fast Wi-Fi', 'AC dorms', 'Lockers', 'Laundry', 'Hot water'], food: 4.0,
      foodInfo: 'Mess with 3 meals a day.', perks: ['Lockers included', 'Free tea at night'],
      nearby: 'Near NUST, 3 min walk', meals: true, family: false),
  _s(3, 'Campus Corner Hostel', StayType.hostel, 'Near QAU', 'Near Quaid-i-Azam University, Islamabad', 1400, 4.0, 88,
      desc: 'Calm hostel near the university, good for exam weeks.',
      am: ['Wi-Fi', 'Study room', 'Laundry', 'Hot water'], food: 3.9,
      foodInfo: 'Breakfast included, dinner optional.', perks: ['Study room open 24/7', 'Weekly cleaning'],
      nearby: 'Near Quaid-i-Azam University', meals: true, family: false),
  _s(4, 'Backpackers Base', StayType.hostel, 'G-11', 'Markaz, G-11, Islamabad', 1300, 3.9, 71,
      desc: 'Simple, affordable beds for solo travelers and job seekers.',
      am: ['Wi-Fi', 'Fan/AC', 'Shared kitchen', 'Hot water'], food: 3.6,
      foodInfo: 'Shared kitchen plus many cheap restaurants nearby.', perks: ['Shared kitchen', '24/7 check-in'],
      nearby: 'G-11 Markaz, 2 min', family: false),
  _s(5, 'Margalla View Hotel', StayType.hotel, 'F-6', 'Street 12, F-6 Markaz, Islamabad', 14500, 4.5, 212,
      desc: 'A comfortable 4-star hotel with Margalla Hills views, close to Jinnah Super Market.',
      am: ['Free Wi-Fi', 'AC', 'Parking', 'Restaurant', 'Room service', 'Gym'], food: 4.4,
      foodInfo: 'Buffet breakfast, Pakistani and Continental menu.',
      perks: ['Free airport pickup on 3+ nights', 'Late check-out on request'],
      nearby: 'Jinnah Super Market, 5 min', meals: true, offer: '15% off on 3+ nights', badge: '15% OFF'),
  _s(6, 'Capital Inn Hotel', StayType.hotel, 'Blue Area', 'Jinnah Avenue, Blue Area, Islamabad', 11800, 4.2, 168,
      desc: 'Business-friendly hotel in the heart of Blue Area. Ideal for interviews and office visits.',
      am: ['Free Wi-Fi', 'AC', 'Parking', 'Restaurant', 'Laundry'], food: 4.0,
      foodInfo: 'Breakfast included, 24/7 room service.', perks: ['Walking distance to offices', 'Free tea and coffee in lobby'],
      nearby: 'Centaurus Mall, 8 min', meals: true),
  _s(7, 'Pearl Residency', StayType.hotel, 'F-7', 'Street 5, F-7 Markaz, Islamabad', 18500, 4.6, 305,
      desc: 'Premium stay with spacious rooms, rooftop dining and excellent service.',
      am: ['Free Wi-Fi', 'AC', 'Parking', 'Rooftop cafe', 'Gym', 'Laundry'], food: 4.7,
      foodInfo: 'Rooftop cafe, fresh breakfast and BBQ nights.', perks: ['Free breakfast', 'Complimentary airport drop'],
      nearby: 'Melody Food Park, 10 min', meals: true, offer: 'Weekend special: 10% off', badge: 'WEEKEND'),
  _s(8, 'Green Valley Guest House', StayType.guestHouse, 'G-9', 'Street 8, G-9/1, Islamabad', 4500, 4.3, 120,
      desc: 'Cozy guest house with private rooms and a lawn. Peaceful and secure.',
      am: ['Wi-Fi', 'AC', 'Parking', 'Lawn', 'TV'], food: 4.2,
      foodInfo: 'Desi breakfast and home-cooked lunch or dinner on order.', perks: ['Free breakfast', 'Tea and coffee all day'],
      nearby: 'PIMS Hospital, 10 min', meals: true, offer: 'Stay 3 nights, get a breakfast upgrade'),
  _s(9, 'Family Comfort Guest House', StayType.guestHouse, 'F-8', 'Street 20, F-8/3, Islamabad', 5500, 4.4, 150,
      desc: 'Family-friendly rooms with a shared lounge in a quiet neighborhood.',
      am: ['Wi-Fi', 'AC', 'Parking', 'Kitchenette', 'Lounge'], food: 4.3,
      foodInfo: 'Breakfast included, lunch and dinner on request.', perks: ['Family rooms', 'Free parking'],
      nearby: 'F-8 Markaz, 5 min', meals: true),
  _s(10, 'Peace Villa Guest House', StayType.guestHouse, 'E-11', 'Street 3, E-11/2, Islamabad', 4000, 4.0, 82,
      desc: 'Budget guest house with clean rooms and friendly hosts.',
      am: ['Wi-Fi', 'AC', 'Parking', 'Hot water'], food: 3.9,
      foodInfo: 'Basic breakfast included, many eateries nearby.', perks: ['Monthly rates available', 'Free laundry once a week'],
      nearby: 'Giga Mall road, 10 min', meals: true),
  _s(11, 'Bahria Heights Guest House', StayType.guestHouse, 'Bahria Town', 'Phase 4, Bahria Town, Islamabad', 6500, 4.5, 99,
      desc: 'Modern guest house in a gated community with 24/7 security.',
      am: ['Wi-Fi', 'AC', 'Parking', 'Generator backup', 'Lounge'], food: 4.4,
      foodInfo: 'Restaurant inside the community, free breakfast.', perks: ['Gated security', 'Free breakfast'],
      nearby: 'Bahria Town food street, 5 min', meals: true, offer: '12% off for stays of 5+ nights', badge: '12% OFF'),
  _s(12, 'Airport Transit Lodge', StayType.guestHouse, 'Airport Road', 'Airport Road, Islamabad', 3800, 3.9, 64,
      desc: 'Convenient for early flights and late arrivals.',
      am: ['Wi-Fi', 'AC', 'Parking', '24/7 reception'], food: 3.7,
      foodInfo: 'Light breakfast and snacks available.', perks: ['Free airport pickup', '24/7 reception'],
      nearby: 'Airport, 10 min'),
];

Stay stayById(String id) => kStays.firstWhere((s) => s.id == id, orElse: () => kStays.first);
