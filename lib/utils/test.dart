// import 'package:ecommerce/constants/app_imports.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as html;
//
// class Test {
//   // static Future<String?> fetchBrandLogo(String url) async {
//   //   try {
//   //     final response = await http.get(Uri.parse(url));
//   //     if (response.statusCode == 200) {
//   //       var document = html.parse(response.body);
//   //       // Assume the logo is in an <img> tag with class "logo" (this varies based on the website)
//   //       var logoElement = document.querySelector('img.logo');
//   //       if (logoElement != null) {
//   //         String? logoUrl = logoElement.attributes['src'];
//   //         print("Fetched $logoUrl");
//   //         return logoUrl;
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Failed to fetch logo: $e');
//   //   }
//   //   return null;
//   // }
//
// // Function to fetch the brand logo URL from the website
//   static Future<String?> fetchBrandLogo(String url) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         var document = html.parse(response.body);
//
//         // 1. Search for <img> tags with class names containing "logo"
//         Element? logoElement = document.querySelector('img[class*="logo"]');
//
//         // 2. If not found, search for <img> tags with alt text containing "logo"
//         logoElement ??= document.querySelector('img[alt*="logo"]');
//
//         // 3. If still not found, search for <img> tags inside common containers like <header> or <nav>
//         logoElement ??= document.querySelector('header img') ??
//             document.querySelector('nav img');
//
//         // Extract and return the logo URL if a logo <img> element is found
//         if (logoElement != null) {
//           String? logoUrl = logoElement.attributes['src'];
//           print("Fetched $logoUrl");
//           return logoUrl;
//         } else {
//           print('No logo element found on $url');
//         }
//       } else {
//         print('Failed to load webpage: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching logo from $url: $e');
//     }
//     return null;
//   }
//
//   static Future<void> updateBrandLogoInFirestore(
//       String brandId, String? logoUrl) async {
//     try {
//       if (logoUrl == null) {
//         print("LogoUrl is null");
//         return;
//       }
//
//       // Query the Firestore collection where brand.id matches the provided brandId
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('brands')
//           .where('id',
//               isEqualTo: brandId) // Check where 'id' field matches brandId
//           .get();
//
//       // Loop through the documents returned by the query and update the 'imageUrl' field
//       for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//         await doc.reference.update({'imageUrl': logoUrl});
//         print("Updated logo for brand with id: $brandId");
//       }
//
//       if (querySnapshot.docs.isEmpty) {
//         print("No brand found with id: $brandId");
//       }
//     } catch (e) {
//       print("Error updating logo for brand with id $brandId: $e");
//     }
//   }
// }
