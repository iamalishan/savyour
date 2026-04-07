import '../../../constants/app_imports.dart';

class FeedsServiceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var feeds = <FeedModel>[].obs;
  bool isMoreDataAvailable = true;
  var isLoading = false.obs;

  final int limit = 10;
  DocumentSnapshot? lastDocument;

  @override
  void onInit() {
    super.onInit();
    fetchFeeds(isInitial: true);
  }

  Future<void> fetchFeeds({bool isInitial = false}) async {
    if (isLoading.value || !isMoreDataAvailable) return;

    isLoading.value = true;

    try {
      Query query = _firestore
          .collection('feed')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (!isInitial && lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.get();

      if (isInitial) {
        feeds.clear();
      }

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;

        final List<FeedModel> newFeeds = querySnapshot.docs.map((doc) {
          return FeedModel.fromFireStore(doc);
        }).toList();

        feeds.addAll(newFeeds);
      } else {
        isMoreDataAvailable = false;
      }
    } catch (e) {
      debugPrint('Error fetching feeds: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshFeeds() {
    lastDocument = null;
    isMoreDataAvailable = true;
    fetchFeeds(isInitial: true);
  }
}
