import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/utils/web_url_strategy.dart'
    if (dart.library.io) 'package:ecommerce_web/utils/mobile_url_strategy.dart'
    as url_strategy;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final userController = Get.put(UserController());
  await userController.initUser();

  runApp(const MyApp());
  unawaited(_postAppStartInit());
}

Future<void> _postAppStartInit() async {
  url_strategy.urlStrategy();
  LinksServices.init();
  Utils.setUserParameters();
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final detailController = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateBasedOnScreenSize();
      if (kIsWeb) _initializeSEO();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailController.determinePlatform(context);
  }

  void _navigateBasedOnScreenSize() {
    DetailController detailController = Get.put(DetailController());
    if (MediaQuery.of(context).size.width > 500) {
      detailController.setIsWeb(true);
    } else if (MediaQuery.of(context).size.width <= 500 && kIsWeb) {
      detailController.setIsMobWeb(true);
    }
  }

  void _initializeSEO() {
    MetaSEO meta = MetaSEO()..config();
    meta
      ..author(
        author: 'Savyour - Best Deals, Discounts, Sales & Coupons from Top Brands',
      )
      ..description(
        description:
            'Discover unbeatable deals, exclusive discounts, trending sales, and verified coupons from 1200+ top brands. Save big every time you shop with Savyour!',
      )
      ..keywords(
        keywords: '''
    big sales today, bonanza satrangi sale pakistan, brand clothing in pakistan, 
    brand in pakistan clothes, brand of clothes in pakistan, brand of pakistan, 
    branded clothes in pakistan, branded clothes pakistan, branded clothing pakistan, 
    brands clothes in pakistan, brands clothes pakistan, brands clothing in pakistan, 
    brands clothing pakistan, brands in pakistan clothing, brands in pakistan for clothing, 
    brands in sale, brands of clothing in pakistan, brands on sales, chinyere pk, 
    clothes brand in pakistan, clothes brands in pakistan, clothing brands in pakistan, 
    designer brands in pakistan, discount on brands, ethnics pk, garments brand in pakistan, 
    generation clothes in pakistan, generation clothing in pakistan, generation pk sale, 
    generation sale, howdy lahore menu, howdy menu lahore, insignia promotions, kayseria pk, 
    levi's pk, mini minor pk, minnie minors, minnie minors pakistan, minnie minors pk, 
    nike islamabad, oaks pk, on sale brands, online sale in pakistan, online sales in pakistan, 
    pakistan clothes brands, pakistan clothing brands names, pakistan garments brands, 
    pakistan sales, pakistani apparel brands, pakistani brands of clothes, 
    pakistani clothing brands name, pakistani garments brands, popularstyle, sale board, 
    sale for brands, sale in which brands, sale on brands in pakistan, sale on generation, 
    sale on today, sales for brands, sales in brands, sales in pakistan, sales in pakistan brands, 
    sales nowadays, sales on brand, sales on brands, sales on which brands, season end sales, 
    shoebox shoes online, squad on sale, submit a guest post fashion, today big sale, 
    today's biggest sales, what on sale, what on.sale, what's on sale, whats on sale, whatson sale, 
    Khaadi clothing Pakistan, Khaadi home textiles, Bonanza Satrangi sale, Bonanza Satrangi Pakistan, 
    Sapphire fashion Pakistan, Sapphire lifestyle products, Gul Ahmed clothes Pakistan, Gul Ahmed sale, 
    Junaid Jamshed clothing, J. perfumes Pakistan, Alkaram Studio unstitched collection, Alkaram Studio sale, 
    Maria B. bridal wear, Maria B. formal collection, Nishat Linen home textiles, Nishat Linen sale, 
    Sana Safinaz luxury pret, Sana Safinaz formal wear, ChenOne home furnishings, ChenOne lifestyle products, 
    Limelight trendy clothing, Limelight accessories Pakistan, Outfitters casual wear Pakistan, Outfitters youth fashion, 
    EGO modern wear, EGO casual clothing, Kayseria unstitched collection, Kayseria traditional wear, Khaas luxury pret, 
    Khaas bridal collection, Zellbury affordable fashion, Zellbury ready-to-wear Pakistan, Generation traditional clothing, 
    Generation women’s wear, Charcoal menswear Pakistan, Charcoal formal suits, Levi’s jeans Pakistan, Levi’s casual wear, 
    Breakout Western wear, Breakout Pakistan fashion, Ethnic by Outfitters traditional wear, Ethnic by Outfitters modern clothing, 
    Threads & Motifs embroidered fabrics, Threads & Motifs formal collection, Minnie Minors kids fashion, Minnie Minors casual clothing, 
    Bareeze luxury fabric, Bareeze unstitched collection, Cross Stitch embroidered outfits, Cross Stitch fashion, 
    Ideas by Gul Ahmed clothing, Ideas by Gul Ahmed home accessories, Royal Tag menswear Pakistan, Royal Tag formal clothing, 
    Satrangi stitched collection, Satrangi Pakistan clothing, BeechTree women’s fashion, BeechTree vibrant wear, 
    Servis Shoes casual footwear, Servis Shoes formal footwear
    ''',
      );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: ContextUtility.navigatorkey,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      title: 'Savyour - Best Deals, Discounts, Sales & Coupons from Top Brands',
      theme: EcommerceTheme.lightThemeData(context),
      debugShowCheckedModeBanner: false,
      // initialRoute: detailController.isWeb? AppRoutes.webHome : AppRoutes.home,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
