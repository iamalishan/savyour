import 'package:ecommerce_web/constants/app_imports.dart';

class CustomDrawer extends StatefulWidget {
  final int selectedIndex;

  const CustomDrawer({super.key, required this.selectedIndex});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  late int _selectedIndex;

  final List<String> _drawerItems = [
    'Home',
    'Brands',
    'Categories',
    'Sales',
    'Coupons'
  ];

  final List<String> _screens = ['/main', '/brand', '/category', '/sale', '/coupon'];


  DetailController detailController = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTap(int index) async {
    setState(() {
      _selectedIndex = index;
      detailController.setMobNavbarIndex(index);
    });

    Navigator.of(context).pop();
    Get.toNamed(_screens[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      child: Container(
        color: EcommerceTheme.mainColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // E-Commerce Title at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(child: Image.asset(AppAssets.webFavicon4, height: 50)),
                  const SizedBox(
                      height: 10), // Add spacing between text and divider
                  const Divider(
                    color: Colors.white, // White horizontal divider
                    thickness: 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _drawerItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  String title = entry.value;
                  bool isSelected = _selectedIndex == index;

                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : null,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        _getIconForIndex(index),
                        color: isSelected
                            ? EcommerceTheme.mainColor
                            : Colors.white,
                      ),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: Colors.white,
                    // Background color when selected
                    onTap: () => _onItemTap(index),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.branding_watermark;
      case 2:
        return Icons.category;
      case 3:
        return Icons.local_offer;
      default:
        return Icons.home;
    }
  }
}
