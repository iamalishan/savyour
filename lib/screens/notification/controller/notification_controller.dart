import '../../../constants/app_imports.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = Utils.userId;

  var notifications = <NotificationModel>[].obs;
  bool isMoreDataAvailable = true;
  bool isLoading = false;

  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    // addDummyNotification();
  }

  Future<void> fetchNotifications({bool loadMore = false}) async {
    if (isLoading || !isMoreDataAvailable) return;

    isLoading = true;
    try {
      final docSnapshot = await _firestore.collection('notifications').doc(userId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        final fullList = List<Map<String, dynamic>>.from(data['notifications'] ?? []);

        if (fullList.isEmpty) {
          notifications.clear();
          isMoreDataAvailable = false;
          isLoading = false;
          return;
        }

        fullList.sort((a, b) {
          final tsA = (a['timestamp'] as Timestamp).toDate();
          final tsB = (b['timestamp'] as Timestamp).toDate();
          return tsB.compareTo(tsA);
        });

        final start = loadMore ? notifications.length : 0;
        final end = (start + limit > fullList.length)
            ? fullList.length
            : start + limit;

        final pageList = fullList.sublist(start, end).map((e) {
          return NotificationModel.fromFireStore(e);
        }).toList();

        if (loadMore) {
          notifications.addAll(pageList);
        } else {
          notifications.assignAll(pageList);
        }

        if (end >= fullList.length) {
          isMoreDataAvailable = false;
        }
      } else {
        notifications.clear();
        isMoreDataAvailable = false;
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }

    isLoading = false;
  }

  Future<void> addDummyNotification() async {
    final dummyNotification = NotificationModel(
      handle: 'product-123',
      brandId: 'brand-xyz',
      title: 'Demo Product 2',
      timestamp: DateTime.now().subtract(Duration(days: 5)),
      oldPrice: 1999.0,
      newPrice: 1499.0,
      image: 'https://via.placeholder.com/150',
      type: 'product history',
    );

    try {
      final docRef = _firestore.collection('notifications').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);

        if (doc.exists) {
          final existingList = List<Map<String, dynamic>>.from(doc['notifications'] ?? []);
          existingList.add(dummyNotification.toFireStore());
          transaction.update(docRef, {'notifications': existingList});
        } else {
          transaction.set(docRef, {
            'notifications': [dummyNotification.toFireStore()],
          });
        }
      });

      print('Dummy notification added successfully.');
    } catch (e) {
      print('Error adding dummy notification: $e');
    }
  }

}
