   // StreamBuilder<DocumentSnapshot>(
   //                stream: FirebaseFirestore.instance
   //                    .collection("products")
   //                    .doc(productId)
   //                    .snapshots(),
   //                builder: (context, snapshot) {
   //                  if (snapshot.data == null || !snapshot.data!.exists) {
   //                    Map<String, dynamic> productData = {
   //                      "brandId": widget.brand.id,
   //                      "category": widget.brand.name,
   //                      "images": product.images.map((e) => e.src).toList(),
   //                      "last_updated": DateTime
   //                          .now(), // Automatically set the server timestamp
   //                      "notification_user_list": [],
   //                      "price": widget.product.variants.first.price,
   //                      "price_history_date": [
   //                        DateTime.now()
   //                        // Automatically set the server timestamp for price history
   //                      ],
   //                      "price_history_price": [
   //                        widget.product.variants.first.price,
   //                      ],
   //                      "productId": productId,
   //                      "title": product.title,
   //                      "user_liked_list": []
   //                    };
   //                    fbRef.doc(productId).set(productData);
   //                  } else if (snapshot.hasData) {
   //                    FBProductModel fbProduc = FBProductModel.fromFirestore(
   //                        snapshot.data as DocumentSnapshot<Object?>);
   //                    return Column(
   //                      children: [
   //                        Row(
   //                          children: [
   //                            const SizedBox(
   //                              width: 10,
   //                            ),
   //                            GestureDetector(
   //                              onTap: () async {
   //                                if (fbProduc.userLikedList.contains(uid)) {
   //                                  fbRef.doc(productId).update({
   //                                    "user_liked_list":
   //                                        FieldValue.arrayRemove([uid]),
   //                                  });
   //                                } else {
   //                                  fbRef.doc(productId).update({
   //                                    "user_liked_list":
   //                                        FieldValue.arrayUnion([uid])
   //                                  });
   //                                }
   //                              },
   //                              child: Material(
   //                                elevation: 5,
   //                                shape: const CircleBorder(),
   //                                child: Container(
   //                                  height: 40,
   //                                  width: 40,
   //                                  decoration: BoxDecoration(
   //                                    color: Colors.white,
   //                                    borderRadius: BorderRadius.circular(20),
   //                                  ),
   //                                  child: fbProduc.userLikedList.contains(uid)
   //                                      ? const Icon(
   //                                          Icons.favorite,
   //                                          color: Colors.red,
   //                                        )
   //                                      : const Icon(Icons.favorite_border),
   //                                ),
   //                              ),
   //                            ),
   //                            const SizedBox(
   //                              width: 15,
   //                            ),
   //                            GestureDetector(
   //                              onTap: () async {
   //                                final result = await Share.share(
   //                                    "https://savyour.io/p/${product.handle}/${brand.id}");
   //                                if (result.status ==
   //                                    ShareResultStatus.success) {}
   //                              },
   //                              child: Material(
   //                                elevation: 5,
   //                                shape: const CircleBorder(),
   //                                child: Container(
   //                                  height: 40,
   //                                  width: 40,
   //                                  decoration: BoxDecoration(
   //                                    color: Colors.white,
   //                                    borderRadius: BorderRadius.circular(20),
   //                                  ),
   //                                  child: const Icon(
   //                                    Icons.notifications,
   //                                    color: Colors.red,
   //                                  ),
   //                                ),
   //                              ),
   //                            ),
   //                            const SizedBox(
   //                              width: 15,
   //                            ),
   //                            GestureDetector(
   //                              onTap: () async {
   //                                controller.showHistory.value =
   //                                    !controller.showHistory.value;
   //                              },
   //                              child: Material(
   //                                elevation: 5,
   //                                shape: const CircleBorder(),
   //                                child: Container(
   //                                  height: 40,
   //                                  width: 40,
   //                                  decoration: BoxDecoration(
   //                                    color: Colors.white,
   //                                    borderRadius: BorderRadius.circular(20),
   //                                  ),
   //                                  child: Icon(
   //                                    Icons.history,
   //                                    color:
   //                                        visible ? Colors.red : Colors.black,
   //                                  ),
   //                                ),
   //                              ),
   //                            ),
   //                            const SizedBox(
   //                              width: 15,
   //                            ),
   //                            GestureDetector(
   //                              onTap: () async {
   //                                final result = await Share.share(
   //                                    "https://savyour.io/p/${product.handle}/${brand.id}");
   //                                if (result.status ==
   //                                    ShareResultStatus.success) {}
   //                              },
   //                              child: Material(
   //                                elevation: 5,
   //                                shape: const CircleBorder(),
   //                                child: Container(
   //                                  height: 40,
   //                                  width: 40,
   //                                  decoration: BoxDecoration(
   //                                    color: Colors.white,
   //                                    borderRadius: BorderRadius.circular(20),
   //                                  ),
   //                                  child: const Icon(Icons.ios_share),
   //                                ),
   //                              ),
   //                            ),
   //                          ],
   //                        ),
   //                        Obx(
   //                          () => Visibility(
   //                            visible: controller.showHistory.value,
   //                            child: Column(
   //                              crossAxisAlignment: CrossAxisAlignment.start,
   //                              children: [
   //                                const Padding(
   //                                  padding: EdgeInsets.all(8.0),
   //                                  child: ReuseText(
   //                                    title: "Price Tracker",
   //                                    fontSize: 25,
   //                                  ),
   //                                ),
   //                                Padding(
   //                                  padding: const EdgeInsets.all(20.0),
   //                                  child: SizedBox(
   //                                      height: 200,
   //                                      child: LineChartPrice(
   //                                        product: product,
   //                                        fbProductModel: fbProduc,
   //                                      )),
   //                                ),
   //                              ],
   //                            ),
   //                          ),
   //                        ),
   //                      ],
   //                    );
   //                  }
   //                  return ProductDetailShimmer();
   //                }),