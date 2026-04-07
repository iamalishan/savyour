import 'package:ecommerce_web/common_widgets/cards/feed_card.dart';
import 'package:ecommerce_web/constants/app_imports.dart';

import '../controller/feeds_service_controller.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({super.key});

  final controller = Get.put(FeedsServiceController());

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 500;

    return Scaffold(
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
                  // const Expanded(
                  //   child: Center(
                  //     child: ReuseText(
                  //       title: "Feed",
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Expanded(child: FeedsList()),
          ],
        ),
      ),
    );
  }
}

class FeedsList extends StatelessWidget {
  const FeedsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedsServiceController>(); // don't create new

    return Obx(() {
      final data = controller.feeds;

      if (data.isEmpty && !controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ReuseText(
              title: "No feeds available",
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        );
      }

      // Group feeds by date
      final grouped = <String, List<FeedModel>>{};
      for (var feed in data) {
        final dateKey = DateFormat('yyyy-MM-dd').format(feed.timestamp);
        grouped.putIfAbsent(dateKey, () => []).add(feed);
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!controller.isLoading.value &&
              controller.isMoreDataAvailable &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.fetchFeeds(); // load more
          }
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            ...grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...entry.value.map((feed) => Center(child: FeedCard(feed: feed))),
                  const SizedBox(height: 20),
                ],
              );
            }),
            if (controller.isLoading.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );
    });
  }
}
