import 'package:ecommerce_web/screens/add_brand/controller/add_coupon_controller.dart';

import '../../../constants/app_imports.dart';

class AddCouponScreen extends StatefulWidget {
  const AddCouponScreen({super.key, required this.brand});

  final Brand brand;

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final AddCouponController controller = Get.put(AddCouponController());

  @override
  void initState() {
    super.initState();
    controller.initialize(widget.brand);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text("Add Coupon"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(controller.brandIdTEC, "Brand Id", Icons.title,readOnly: true),
                const SizedBox(height: 15),
                _buildTextField(controller.brandLogoTEC, "Logo URL", Icons.image,readOnly: true),
                const SizedBox(height: 15),
                _buildTextField(controller.brandNameTEC, "Brand Name", Icons.description,readOnly: true),
                const SizedBox(height: 15),
                _buildTextField(controller.couponCodeTEC, "Coupon Code", Icons.link),
                const SizedBox(height: 15),
                _buildTextField(controller.percentageTEC, "Percentage", Icons.percent),
                const SizedBox(height: 25),
                Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : controller.addCoupon,
                  icon: const Icon(Icons.add),
                  label: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text("Add Coupon"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1, bool readOnly = false}) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
