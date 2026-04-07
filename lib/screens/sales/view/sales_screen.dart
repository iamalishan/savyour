import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/sales/controllers/sale_service_controller.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final DetailController detailController = Get.put(DetailController());
  final SalesServiceController controller = Get.put(SalesServiceController(isWeb: true),);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailController.setMobNavbarIndex(3);
      detailController.setNavbarIndex(3);
      controller.loadSales();
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
      drawer: Obx(() => CustomDrawer(selectedIndex: detailController.mobNavbarIndex)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchHeader(),
                          const SizedBox(height: 20),
                          _buildSalesTitle(),
                          Obx(() => _buildSalesList()),
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
            hintText: "Search Sales",
            onChanged: controller.onSearchChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSalesTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReuseText(
          title: "All Sales:",
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
        const SizedBox(height: 10),
        Divider(thickness: 1, color: Colors.grey.shade300, height: 0),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSalesList() {
    if (controller.isLoading.value && controller.salesToDisplay.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.salesToDisplay.isEmpty) {
      return const Center(child: Text("No Sales found"));
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: detailController.isWeb ? 5 : 2,
            mainAxisExtent: detailController.isWeb ? 150 : 110,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: controller.salesToDisplay.length,
          itemBuilder: (context, index) {
            final sale = controller.salesToDisplay[index];
            return SalesBox(sale: sale);
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
