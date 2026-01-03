import 'package:mandalart/features/mandalart/mandalart.dart';

class MandalartStore {
  const MandalartStore();

  List<Mandalart> loadMandalarts() {
    return const [
      Mandalart(
        id: '2025',
        title: '2025 Mandalart',
        dateRangeLabel: '2025.01.01 - 2025.12.31',
      ),
      Mandalart(
        id: '2024',
        title: '2024 Mandalart',
        dateRangeLabel: '2024.01.01 - 2024.12.31',
      ),
    ];
  }
}
