import 'package:ecommerce_web/constants/app_imports.dart';

import '../../../common_widgets/widgets/notification_card.dart';
import '../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
                  const Expanded(
                    child: Center(
                      child: ReuseText(
                        title: "Notifications",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Expanded(child: NotificationList()),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Obx(() {
      final data = controller.notifications;

      if (data.isEmpty && !controller.isLoading) {
        return const Center(child: Text("No notifications found."));
      }


      final grouped = <String, List<NotificationModel>>{};
      for (var n in data) {
        final dateKey = DateFormat('yyyy-MM-dd').format(n.timestamp);
        grouped.putIfAbsent(dateKey, () => []).add(n);
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!controller.isLoading &&
              scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
            controller.fetchNotifications(loadMore: true);
          }
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            ...grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ReuseText(
                      title: entry.key,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...entry.value.map((n) => NotificationCard(notification: n,)).toList(),
                  const SizedBox(height: 20),
                ],
              );
            }),
            if (controller.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (!controller.isMoreDataAvailable)
              const SizedBox.shrink(),
          ],
        ),
      );
    });
  }
}
