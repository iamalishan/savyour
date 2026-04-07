import '../../../constants/app_imports.dart';
import '../controller/add_brand_controller.dart';

class AddBrandScreen extends StatelessWidget {
  AddBrandScreen({super.key});

  final AddBrandController controller = Get.put(AddBrandController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text("Add Brand"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(controller.nameTEC, "Brand Name", Icons.title),
                const SizedBox(height: 15),
                _buildTextField(controller.imageTEC, "Image URL", Icons.image),
                const SizedBox(height: 15),
                _buildTextField(controller.descriptionTEC, "Description", Icons.description, maxLines: 4),
                const SizedBox(height: 15),
                _buildTextField(controller.urlTEC, "Brand URL", Icons.link),
                const SizedBox(height: 15),
                _buildTextField(controller.priorityTEC, "Priority (Integer)", Icons.format_list_numbered),
                const SizedBox(height: 25),
                Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : controller.addBrand,
                  icon: const Icon(Icons.add),
                  label: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text("Add Brand"),
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
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
