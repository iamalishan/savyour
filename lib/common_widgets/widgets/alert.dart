import 'package:ecommerce_web/constants/app_imports.dart';

class ConfirmationAlert extends StatefulWidget {
  ConfirmationAlert({
    required this.title,
    required this.subTitle,
    required this.onSecondTap,
    this.onFirstTap = _defaultNoOp,
    this.isLoading = false,
    this.isLoadingFirst = false,
    this.icon = const Icon(Icons.info_outline, color: Colors.black, size: 50),
    this.isNoButton = false,
    this.buttonText = "Yes",
    this.isNoButtonText = "No",
    this.isTextField = false,
    TextEditingController? controller,
    super.key,
  })  : assert(
          isTextField == false || controller != null,
          'Controller is required when isTextField is true',
        ),
        assert(
          isNoButton == false || onFirstTap != _defaultNoOp,
          'onFirstTap must be provided when isNoButton is true',
        ),
        controller = controller ?? TextEditingController();

  final String title;
  final String subTitle;
  final VoidCallback onSecondTap;
  final VoidCallback onFirstTap;
  final bool isLoading;
  final bool isLoadingFirst;
  final Icon icon;
  final bool isNoButton;
  final String isNoButtonText;
  final String buttonText;
  final bool isTextField;
  final TextEditingController controller;

  static void _defaultNoOp() {}

  @override
  _ConfirmationAlertState createState() => _ConfirmationAlertState();
}

class _ConfirmationAlertState extends State<ConfirmationAlert> {
  bool _isButtonEnabled = false;
  Timer? _debounce;
  String _imageUrl = '';

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _imageUrl = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        content: SizedBox(
          height: widget.isTextField ? 320 : 190,
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
                            widget.controller.clear();
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
              if (widget.isTextField)
                Column(
                  children: [
                    if (_imageUrl.isNotEmpty)
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CachedNetworkImage(
                          imageUrl: _imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageBuilder: (context, imageProvider) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!_isButtonEnabled) {
                                setState(() {
                                  _isButtonEnabled = true;
                                });
                              }
                            });
                            return Image(image: imageProvider);
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        style: const TextStyle(fontSize: 13),
                        controller: widget.controller,
                        onChanged: _onTextChanged,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
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
                  ],
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.isNoButton)
                    EcommerceButton(
                      isLoading: widget.isLoadingFirst,
                      text: widget.isNoButtonText,
                      buttonWidth: widget.isNoButtonText == "No" ? 80 : 110,
                      fontSize: widget.isNoButtonText == "No" ? 12 : 9,
                      onTap: widget.onFirstTap,
                    ),
                  // if(widget.buttonText == "Yes" || widget.isNoButtonText == "No")
                  // SizedBox(width: 30),
                  EcommerceButton(
                    isLoading: widget.isLoading,
                    text: widget.buttonText,
                    buttonWidth: widget.buttonText == "Yes" ? 80 : 110,
                    fontSize: widget.buttonText == "Yes" ? 12 : 9,
                    onTap: widget.isTextField
                        ? _isButtonEnabled
                            ? widget.onSecondTap
                            : null
                        : widget.onSecondTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
