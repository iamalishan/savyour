import '../../../constants/app_imports.dart';
import '../controller/favorite_controller.dart';
import '../widgets/brand_tab.dart';
import '../widgets/collection_tab.dart';
import '../widgets/products_tab.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  final favoriteCon = Get.put(FavoriteController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      favoriteCon.initiate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 500;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: isWeb ? null : MobileNavbar(),
        drawer: CustomDrawer(selectedIndex: 0),
        body: SafeArea(
          child: Column(
            children: [
              if (isWeb) const NavBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: (){
                        Get.back();
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: ReuseText(
                          title: "Favourites",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    padding: const EdgeInsets.all(4),
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.black,
                    dividerColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    indicatorColor: Colors.white,
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Brands'),
                      Tab(text: 'Collections'),
                      Tab(text: 'Products'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    BrandsTab(),
                    CollectionsTab(),
                    ProductsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
