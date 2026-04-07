import 'package:ecommerce_web/constants/app_imports.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {super.key,
      this.hintText = "Store or Products",
      this.controller,
        this.onTap,
      this.onChanged,
      this.onSubmit,
      });

  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        onTap: onTap,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmit,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          fillColor: EcommerceTheme.primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
