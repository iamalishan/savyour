import 'package:ecommerce_web/constants/app_imports.dart';
import '../../controllers/navbar_search_controller.dart';
import '../../controllers/share_image_controller.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, this.selectedIndex = 0});

  final int selectedIndex;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<String> _tabs = ['Home', 'Brands', 'Sales'];

  final List<String> _screens = ['/Home', '/brand', '/sale',];

  DetailController detailController = Get.put(DetailController());
  final searchController = Get.put(NavbarSearchController(), permanent: true);
  final shareController = Get.put(ShareImageController());

  final List<bool> _isHovering = [false, false, false,];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (detailController.navbarIndex != widget.selectedIndex) {
        detailController.setNavbarIndex(widget.selectedIndex);
      }
      searchController.updatePageFromRoute(Uri.base.path.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: EcommerceTheme.mainColor,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // InstagramScraper().scrapeUserData('stylopk');
              // Get.to(() => AddBrandScreen());
            },
            child: Image.asset(AppAssets.webFavicon4, height: 50),
          ),
          const SizedBox(width: 25),
          Row(
            children: List.generate(_tabs.length, (index) {


              return Obx(() {
                final bool isHovered = _isHovering[index];
                final bool isSelected = detailController.navbarIndex == index;
                return MouseRegion(
                  onEnter: (_) => setState(() => _isHovering[index] = true),
                  onExit: (_) => setState(() => _isHovering[index] = false),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(_screens[index]);
                      detailController.setNavbarIndex(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: Get.width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected || isHovered
                                  ? EcommerceTheme.primaryColor.withAlpha(10)
                                  : EcommerceTheme.mainColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ReuseText(
                              title: _tabs[index],
                              fontColor: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.width * 0.013,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Visibility(
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainState: true,
                            visible: isHovered,
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            }),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                return Visibility(
                    visible: searchController.isSearchVisible.value,
                    child: SizedBox(
                      width: 300,
                      child: SearchField(
                        hintText: searchController.getHintText(),
                        controller: searchController.searchHomeTEC.value,
                        onSubmit: searchController.onSubmit,
                        onChanged: searchController.onChanged,
                      ),
                    ));
              }),
              IconContainer(
                onLongPress: () {
                  shareController.onShareTap();
                },
                icon: Icons.share,
                onTap: () async {
                  final uri = Uri.base;
                  final sharedInfo = uri.sharedInfo;

                  final shareUrl = uri.toString();

                  final eventName = {
                    'brand': 'brand_view',
                    'collection': 'collection_view',
                    'product': 'product_view',
                  }[sharedInfo['shared_type']];

                  final result = await SharePlus.instance.share(
                    ShareParams(text: shareUrl),
                  );

                  if (result.status == ShareResultStatus.success &&
                      eventName != null) {
                    FirebaseAnalyticsUtil.analyticLogEvent(
                      name: eventName,
                      parameters: sharedInfo,
                    );
                  }
                },
              ),
              IconContainer(
                icon: Icons.favorite_border,
                onTap: () {
                  Get.toNamed('/favorite');
                },
              ),
              IconContainer(
                icon: Icons.feed,
                onTap: () {
                  Get.toNamed('/feed');
                },
              ),

              // IconContainer(
              //   icon: Icons.search,
              //   onTap: () {
              //     FirebaseAnalyticsUtil.analyticLogEvent(name: 'search_view');
              //     Get.toNamed('/search');
              //   },
              // ),
              // const SizedBox(width: 10),
              IconContainer(
                icon: Icons.notifications_active_outlined,
                onTap: () {
                  Get.toNamed('/notification');
                },
              ),
              // const SizedBox(width: 10),
              // IconContainer(
              //   icon: Icons.favorite_border,
              //   onTap: () {
              //     Get.toNamed('/favorite');
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
