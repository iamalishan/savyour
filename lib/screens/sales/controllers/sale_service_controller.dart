import 'dart:async';
import 'package:ecommerce_web/constants/app_imports.dart';

class SalesServiceController extends GetxController {
  final ScrollController scrollController = ScrollController();

  RxList<Sale> loadedSales = <Sale>[].obs;
  RxList<Sale> searchedSales = <Sale>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxString searchText = ''.obs;
  RxInt limit = 20.obs;

  final bool isWeb;
  Timer? _debounce;
  DocumentSnapshot? _lastDocument;

  SalesServiceController({this.isWeb = false}) {
    limit.value = isWeb ? 40 : 20;
    _initScrollListener();
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange &&
          !isLoading.value &&
          hasMore.value) {
        loadMoreSales();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> loadSales({bool isInitialLoad = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance.collection('sale');

      if (_lastDocument != null && !isInitialLoad) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.limit(limit.value).get();

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;

        final allSales = <Sale>[];

        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          final brandId = data['brandId'];
          final brandName = data['brandName'];
          final brandLogo = data['brandLogo'];

          final salesList = List<Map<String, dynamic>>.from(data['sales'] ?? []);

          for (var saleData in salesList) {
            final sale = Sale.fromNestedSale(
              brandId: brandId,
              brandName: brandName,
              brandLogo: brandLogo,
              data: saleData,
            );

            // If searching, filter by name
            if (searchText.value.length > 2) {
              final search = searchText.value.toLowerCase();
              if (sale.name.toLowerCase().contains(search)) {
                allSales.add(sale);
              }
            } else {
              allSales.add(sale);
            }
          }
        }

        // Sort by priority descending
        allSales.sort((a, b) => b.priority.compareTo(a.priority));

        if (searchText.value.length > 2) {
          searchedSales.addAll(allSales);
        } else {
          loadedSales.addAll(allSales);
        }

        if (allSales.length < limit.value) hasMore.value = false;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      print("Error loading nested sales: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreSales() {
    loadSales();
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _lastDocument = null;
      loadedSales.clear();
      searchedSales.clear();
      limit.value = isWeb ? 40 : 20;
      hasMore.value = true;
      loadSales(isInitialLoad: true);
    });
  }

  List<Sale> get salesToDisplay =>
      searchText.value.length > 2 ? searchedSales : loadedSales;
}
