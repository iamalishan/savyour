import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/coupons/controller/coupon_service_controller.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final DetailController detailController = Get.put(DetailController());
  final CouponServiceController controller = Get.put(
    CouponServiceController(isWeb: true),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailController.setMobNavbarIndex(4);
      detailController.setNavbarIndex(4);
      controller.loadCoupons();
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
      appBar: detailController.isMobWeb ? MobileNavbar() : null,
      drawer: Obx(
        () => CustomDrawer(selectedIndex: detailController.mobNavbarIndex),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.bgColor),
            Column(
              children: [
                Obx(() {
                  return detailController.isWeb
                      ? NavBar(selectedIndex: detailController.navbarIndex)
                      : const SizedBox.shrink();
                }),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchHeader(),
                          const SizedBox(height: 20),
                          _buildCouponsTitle(),
                          Obx(() => _buildCouponsList()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        Expanded(
          child: SearchField(
            hintText: "Search Coupons",
            onChanged: controller.onSearchChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponsTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReuseText(
          title: "All Coupons:",
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
        const SizedBox(height: 10),
        Divider(thickness: 1, color: Colors.grey.shade300, height: 0),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCouponsList() {
    if (controller.isLoading.value && controller.couponsToDisplay.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.couponsToDisplay.isEmpty) {
      return const Center(child: Text("No Coupons found"));
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: detailController.isWeb ? 5 : 2,
            mainAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: controller.couponsToDisplay.length,
          itemBuilder: (context, index) {
            final coupon = controller.couponsToDisplay[index];
            return CouponBox(
              coupon: coupon,
              onTap: () {
                Get.toNamed("/b/${coupon.brandId}", arguments: {"brand": null});
              },
            );
          },
        ),
        if (controller.isLoading.value)
          const Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
