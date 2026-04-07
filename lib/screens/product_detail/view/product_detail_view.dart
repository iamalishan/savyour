import '../../../constants/app_imports.dart';
import '../controller/product_detail_controller.dart';
import '../mob_detail_widgets/product_detail_content.dart';
import '../web_detail_widgets/web_product_detail_content.dart';

class MobProductDetailView extends StatefulWidget {
  MobProductDetailView({super.key});

  final String productHandle = Get.parameters["productHandle"]!;
  final String brandId = Get.parameters['brandId']!;
  final Brand? brand = Get.arguments.toString().contains("brand")
      ? Get.arguments['brand']
      : null;

  final Collection? collection = Get.arguments.toString().contains("collection")
      ? Get.arguments['collection']
      : null;
  final Product? product = Get.arguments.toString().contains("product")
      ? Get.arguments['product']
      : null;

  @override
  State<MobProductDetailView> createState() => _MobProductDetailViewState();
}

class _MobProductDetailViewState extends State<MobProductDetailView> {
  final ProductDetailController controller = Get.put(ProductDetailController());
  final detailController = Get.find<DetailController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchData(
        widget.brandId,
        widget.productHandle,
        widget.product,
        widget.brand,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
      detailController.determinePlatform(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controller.controller.isMobWeb ? MobileNavbar() : null,
      drawer: CustomDrawer(selectedIndex: controller.controller.mobNavbarIndex),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              if (kIsWeb && Get.width > 500)
                NavBar(selectedIndex: controller.controller.navbarIndex),
              controller.isLoading.value
                  ? kIsWeb && Get.width > 500
                        ? Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Expanded(child: ProductDetailShimmer())
                  : kIsWeb && Get.width > 500
                  ? WebProductDetailContent()
                  : Expanded(child: MobProductDetailContent()),
            ],
          );
        }),
      ),
    );
  }
}
