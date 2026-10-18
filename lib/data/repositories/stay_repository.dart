import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_stays.dart';
import '../models/stay.dart';

/// UI never touches mock data directly: it talks to this repository.
/// When the backend is ready, only THIS file changes (swap mock -> API).
class StayRepository {
  Future<List<Stay>> getStays() async {
    await Future.delayed(const Duration(milliseconds: 500)); // fake network
    return mockStays;
  }

  Future<Stay?> getStayById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final s in mockStays) {
      if (s.id == id) return s;
    }
    return null;
  }

  Future<List<Stay>> search({
    String? query,
    StayType? type,
    int? maxPrice,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockStays.where((s) {
      final q = query?.trim().toLowerCase() ?? '';
      final matchesQuery = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.area.toLowerCase().contains(q) ||
          s.nearby.toLowerCase().contains(q);
      final matchesType = type == null || s.type == type;
      final matchesPrice = maxPrice == null || s.pricePerNight <= maxPrice;
      return matchesQuery && matchesType && matchesPrice;
    }).toList();
  }
}

// ---------- Riverpod providers ----------
final stayRepositoryProvider = Provider<StayRepository>((ref) {
  return StayRepository();
});

final staysProvider = FutureProvider<List<Stay>>((ref) {
  return ref.watch(stayRepositoryProvider).getStays();
});

final stayByIdProvider = FutureProvider.family<Stay?, String>((ref, id) {
  return ref.watch(stayRepositoryProvider).getStayById(id);
});
