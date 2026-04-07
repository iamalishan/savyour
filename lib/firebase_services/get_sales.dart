import 'package:ecommerce_web/constants/app_imports.dart';

class SalesController extends GetxController {
  var sales = <Sale>[].obs;
  var isLoading = true.obs;
  var isAddLoading = false.obs;
  var isUpdating = false.obs;
  var searchText = ''.obs;
  var filteredSales = <Sale>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSales();
    setupSearchListener();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void setupSearchListener() {
    searchController.addListener(() {
      updateSearchText(searchController.text);
    });
  }

  void updateSearchText(String value) {
    searchText.value = value;
    filterSales();
  }

  void filterSales() {
    filteredSales.value = sales.where((sale) {
      return sale.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<void> fetchSales() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sale')
          .get();

      final allSales = <Sale>[];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final brandId = data['brandId'];
        final brandName = data['brandName'];
        final brandLogo = data['brandLogo'];

        final salesList = List<Map<String, dynamic>>.from(data['sales'] ?? []);

        for (var saleData in salesList) {
          allSales.add(
            Sale.fromNestedSale(
              brandId: brandId,
              brandName: brandName,
              brandLogo : brandLogo,
              data: saleData,
            ),
          );
        }
      }

      allSales.sort((a, b) => b.priority.compareTo(a.priority));
      sales.value = allSales;
      filterSales();
    } catch (e) {
      print("Error fetching sales: $e");
    } finally {
      isLoading(false);
    }
  }


  String removeTrailingSlash(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }
    return url;
  }

  var feedController = Get.put(FeedsController());

  Future<bool> addSale(Brand brand, Collection collection) async {
    try {
      isAddLoading(true);

      final docRef = FirebaseFirestore.instance.collection('sale').doc(brand.id);
      final docSnapshot = await docRef.get();

      final saleUrl = "${removeTrailingSlash(brand.url)}/collections/${collection.handle}";

      final saleData = {
        'name': collection.title,
        'image': collection.image,
        'url': saleUrl,
        'handle': collection.handle,
        'priority': 0,
        'ended': false,
        'disabled': false,
        'addedDate': DateTime.now(),
        'endedDate': null,
      };

      if (docSnapshot.exists) {
        final existingSales = List.from(docSnapshot.data()?['sales'] ?? []);

        // Check if this collection already exists
        final alreadyExists = existingSales.any((sale) => sale['handle'] == collection.handle);
        if (alreadyExists) {
          print("Sale already exists for this collection in brand ${brand.id}");
          return false;
        }

        existingSales.add(saleData);

        await docRef.update({
          'sales': existingSales,
        });
      } else {
        await docRef.set({
          'brandId': brand.id,
          'brandName': brand.name,
          'brandLogo': brand.imageUrl,
          'sales': [saleData],
        });

        feedController.addFeed(
          brandId: brand.id,
          type: 'sale_added',
          userId: Utils.userId!,
          brandLogo: brand.imageUrl ?? '',
          url: saleUrl,
          brandName: brand.name,
          timestamp: DateTime.now(),
          title: collection.title,
          handle: collection.handle,
          image: collection.image ?? '',
        );
      }

      return true;
    } catch (e) {
      print("Error adding sale: $e");
      return false;
    } finally {
      isAddLoading(false);
    }
  }

  Future<bool> deleteSaleByUrl(String url) async {
    try {
      isUpdating(true);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference salesCollection = firestore.collection('sale');

      QuerySnapshot querySnapshot = await salesCollection
          .where('url', isEqualTo: url)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No sale found with the provided URL.");
        isUpdating(false);
        return false;
      }

      // Assuming you only want to delete one document with the given URL
      DocumentSnapshot saleToDelete = querySnapshot.docs.first;
      int deletedPriority = saleToDelete['priority'] as int;

      // Step 2: Delete the sale
      await salesCollection.doc(saleToDelete.id).delete();

      // Step 3: Update priorities of remaining sales
      QuerySnapshot remainingSales = await salesCollection
          .where('priority', isGreaterThan: deletedPriority)
          .get();

      for (QueryDocumentSnapshot doc in remainingSales.docs) {
        int currentPriority = doc['priority'] as int;
        await salesCollection.doc(doc.id).update({
          'priority': currentPriority - 1,
        });
      }

      print("Sale deleted and priorities updated successfully.");
      isUpdating(false);
      return true;
    } catch (e) {
      print("Error deleting sale and updating priorities: $e");
      isUpdating(false);
      return false;
    }
  }

  Future<bool> markSaleAsEnded(String url) async {
    try {
      isUpdating(true);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference salesCollection = firestore.collection('sale');

      QuerySnapshot querySnapshot = await salesCollection
          .where('url', isEqualTo: url)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No sale found with the provided URL.");
        return false;
      }

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await salesCollection.doc(doc.id).update({'ended': true});
      }

      print("Sale(s) marked as ended successfully.");
      isUpdating(false);
      return true;
    } catch (e) {
      print("Error marking sale as ended: $e");
      isUpdating(false);
      return false;
    }
  }

  void updatePriorities(List<Sale> sales) async {
    try {
      isUpdating(true);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (int i = 0; i < sales.length; i++) {
        batch.update(
          FirebaseFirestore.instance.collection('sale').doc(sales[i].url),
          {'priority': i + 1},
        );
      }

      await batch.commit();
      print("Priorities updated successfully.");
    } catch (e) {
      print("Error updating priorities: $e");
    } finally {
      isUpdating(false);
    }
  }
}
