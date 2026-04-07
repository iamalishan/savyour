import 'package:ecommerce_web/constants/app_imports.dart';

import '../../../common_widgets/widgets/hover_scale_wrapper.dart';
import 'section_header.dart';

class StreamBuilderSection extends StatelessWidget {
  const StreamBuilderSection({Key? key}) : super(key: key);

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
                child: GestureDetector(
                  onTap: () {
                    if (url.isNotEmpty) {
                      Utils.navigateBasedOnUrl(brandId, url,null);
                    }
                  },
                  child: BannerBox(
                    netImage: doc['image'],
                    title: doc['brandName'] ?? "Banner",
                    subTitle: " ",
                    visitStore: true,
                    storeUrl: url,
                    isSingle: true,
                    isFillImage: false,
                    visitTap: () {
                      if (url.isNotEmpty) {
                        Utils.navigateBasedOnUrl(brandId, url,null);
                      }
                    },
                  ),
                ),
              );
            } else if (type == "products") {
              return FutureBuilder<List<Product>>(
                future: fetchData(brandId, url),
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
                    return SizedBox.shrink();
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
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 360,
                          minHeight: 340
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                          products.length > 10 ? 10 : products.length,
                          itemBuilder: (context, index) {
                            var product = products[index];
                            return Center(
                              child: HoverScaleWrapper(
                                scaleValue: 1.05,
                                child: SizedBox(
                                  width: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () => Utils.handleOnTap(() {
                                        Utils.navigateBasedOnUrl(
                                            doc['brandId'], "$brandUrl/products/${product.handle}",product);
                                      }),
                                      child: ProductBox(
                                        title: product.title,
                                        description: product.description.trim().isEmpty
                                            ? null
                                            : product.description.trim(),
                                        newPrice: product.variants.first.price,
                                        oldPrice: product.variants.first.compareAtPrice,
                                        discount: product.variants.first.discount ?? 0,
                                        netImg: product.images.first.src,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
  Future<List<Product>> fetchData(String brandId, String url) async {
    List<Product> fetchedProducts = [];

    String brandUrl = Utils.extractCollectionInfo(url);
    String collectionHandle = Utils.getCollectionHandle(url);
    fetchedProducts = await ProductsController().fetchMultipleProducts(
      brandUrl,
      collectionHandle,
    );
    return fetchedProducts;
  }
}