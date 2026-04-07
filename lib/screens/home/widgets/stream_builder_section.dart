import 'package:ecommerce_web/constants/app_imports.dart';

import '../../web_home/widgets/section_header.dart';

class HomePageStreamBuilderSection extends StatelessWidget {
  final HomeController homeController;

  const HomePageStreamBuilderSection({
    super.key,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('home_page').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(15),
            child: ProductShimmer(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        // Sort documents by priority
        var docs = snapshot.data!.docs;
        docs.sort(
                (a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var doc = docs[index];
            var type = doc['type'];
            var brandId = doc['brandId'];
            var url = doc['url'];
            String brandUrl = Utils.extractCollectionInfo(url);

            if (type == "banner") {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: BannerBox(
                  netImage: doc['image'],
                  title: doc['brandName'] ?? 'Banner',
                  subTitle: '',
                  isFillImage: false,
                  visitStore: true,
                  storeUrl: url,
                  visitTap: () {
                    homeController.handleOnTap(() {
                      if (url.isNotEmpty) {
                        Utils.navigateBasedOnUrl(brandId, url,null);
                      }
                    });
                  },
                ),
              );
            } else if (type == "products") {
              return FutureBuilder<List<Product>>(
                future: homeController.fetchData(brandId, url),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child: ProductShimmer(),
                    );
                  }
                  if (!productSnapshot.hasData ||
                      productSnapshot.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  var products = productSnapshot.data!;
                  return Column(
                    children: [
                      SectionHeader(
                        title: doc['brandName'],
                        onViewAll: () {
                          Utils.handleOnTap(() {
                            Utils.navigateBasedOnUrl(doc['brandId'], doc['url'],null);
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: SizedBox(
                          height: 295,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            products.length > 10 ? 10 : products.length,
                            itemBuilder: (context, index) {
                              var product = products[index];
                              return SizedBox(
                                width: 180,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () => homeController.handleOnTap(() {
                                      Utils.navigateBasedOnUrl(doc['brandId'],
                                          "$brandUrl/products/${product.handle}",product);
                                    }),
                                    child: ProductBox(
                                      title: product.title,
                                      newPrice: product.variants.first.price,
                                      oldPrice: product.variants.first.compareAtPrice,
                                      discount: product.variants.first.discount ?? 0,
                                      netImg: product.images.first.src,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
