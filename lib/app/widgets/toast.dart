import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Toast extends StatefulWidget {
  const Toast(
      {Key? key,
      this.title,
      this.subTitle,
      this.titleText,
      this.subTitleText,
      this.isClosable = true})
      : super(key: key);
  final String? titleText;
  final String? subTitleText;
  final Widget? title;
  final Widget? subTitle;
  final bool isClosable;

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  late bool _isVisible;

  @override
  void initState() {
    _isVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_isVisible
        ? Container()
        : Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 10,
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    CupertinoIcons.exclamationmark_circle_fill,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.title ??
                          Text(
                            widget.titleText ?? "Did you know?",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                      widget.subTitle ??
                          Text(
                            widget.subTitleText ?? "You can add a subtitle",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                    ],
                  ),
                ),
                if (widget.isClosable)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isVisible = false;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.clear,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          );
  }
}
