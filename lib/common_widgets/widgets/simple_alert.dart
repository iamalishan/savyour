import 'package:ecommerce_web/constants/app_imports.dart';

class SimpleAlert extends StatefulWidget {
  SimpleAlert({
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.isLoading = false,
    this.icon = const Icon(Icons.info_outline, color: Colors.black, size: 50),
    this.buttonText = "Update",
    TextEditingController? controller,
    super.key,
  }) : controller = controller ?? TextEditingController();

  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final bool isLoading;
  final Icon icon;
  final String buttonText;
  final TextEditingController controller;

  @override
  _SimpleAlertState createState() => _SimpleAlertState();
}

class _SimpleAlertState extends State<SimpleAlert> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        content: SizedBox(
          height: 230,
          child: Column(
            children: [
              Stack(
                children: [
                  Center(child: widget.icon),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                            // widget.controller.clear();
                          },
                          child: const ReuseText(
                            title: "Cancel",
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            fontColor: Colors.red,
                          )))
                ],
              ),
              const SizedBox(height: 10),
              ReuseText(
                title: widget.title,
                fontColor: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(height: 11),
              ReuseText(
                title: widget.subTitle,
                fontColor: Colors.black,
                fontSize: 11,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  style: const TextStyle(fontSize: 13),
                  controller: widget.controller,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  EcommerceButton(
                    isLoading: widget.isLoading,
                    text: widget.buttonText,
                    buttonWidth: 120,
                    onTap: widget.onTap,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
