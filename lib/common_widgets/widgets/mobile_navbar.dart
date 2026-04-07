import '../../constants/app_imports.dart';
import '../../controllers/navbar_search_controller.dart';
import '../../controllers/share_image_controller.dart';

class MobileNavbar extends StatelessWidget implements PreferredSizeWidget {
  MobileNavbar({super.key});

  final searchController = Get.put(NavbarSearchController(), permanent: true);
  final shareController = Get.put(ShareImageController());


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.updatePageFromRoute(Uri.base.path.toString());
    });
    return Obx(() {
      final showSearch = searchController.isSearchVisible.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: EcommerceTheme.mainColor,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.webFavicon4, height: 35),
                const SizedBox(width: 10),
                ReuseText(
                  title: 'Savyour',
                  fontColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            actions: [
              // IconContainer(
              //   icon: Icons.search,
              //   onTap: () {
              //     searchController.toggleSearchVisibility();
              //   },
              // ),
              IconContainer(
                size: 20,
                icon: Icons.share,
                onLongPress: (){
                  shareController.onShareTap();
                },
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

                  if (result.status == ShareResultStatus.success && eventName != null) {
                    FirebaseAnalyticsUtil.analyticLogEvent(
                      name: eventName,
                      parameters: sharedInfo,
                    );
                  }
                },
              ),
              IconContainer(
                size: 20,
                icon: Icons.favorite_border,
                onTap: () {
                  Get.toNamed('/favorite');
                },
              ),
              IconContainer(
                size: 20,
                icon: Icons.feed,
                onTap: () {
                  Get.toNamed('/feed');
                },
              ),
              IconContainer(
                size: 20,
                icon: Icons.notifications_active_outlined,
                onTap: () {
                  Get.toNamed('/notification');
                },
              ),
            ],
          ),
          if (showSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: SizedBox(
                width: Get.width,
                child: SearchField(
                  hintText: searchController.getHintText(),
                  controller: searchController.searchHomeTEC.value,
                  onSubmit: searchController.onSubmit,
                  onChanged: searchController.onChanged,
                ),
              ),
            ),
        ],
      );
    });
  }

  /// This is a workaround since [preferredSize] must return a fixed height,
  /// but we'll return the maximum possible height.
  @override
  Size get preferredSize => const Size.fromHeight(125);
}
