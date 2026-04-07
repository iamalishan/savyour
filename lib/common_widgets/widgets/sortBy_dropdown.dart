import 'package:ecommerce_web/constants/app_imports.dart';

class SortByDropdown extends StatelessWidget {
  final String selectedOption;
  final ValueChanged<String?> onChanged;

  const SortByDropdown({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: EcommerceTheme.primaryColor,
      ),
      child: DropdownButton<String>(
        value: selectedOption,
        onChanged: onChanged,
        items: <String>[
          'Trending',
          'Newest',
          'Discount',
          'Low to High',
          'High to Low'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                value == selectedOption
                    ? const Icon(Icons.check, size: 16)
                    : const SizedBox.shrink(),
              ],
            ),
          );
        }).toList(),
        underline: const SizedBox(),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset(
            "assets/icons/down_arrow.png",
            width: 12,
          ),
        ),
        isExpanded: false,
        dropdownColor: EcommerceTheme.primaryColor,
        style: const TextStyle(color: Colors.black, fontSize: 12),
        selectedItemBuilder: (BuildContext context) {
          return <String>[
            'Trending',
            'Newest',
            'Discount',
            'Low to High',
            'High to Low'
          ].map<Widget>((String value) {
            return Center(
              child: Row(
                children: [
                  const Text(
                    "Sort by : ",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
