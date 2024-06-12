import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:flutter/material.dart';

class buttonRummy extends StatefulWidget {
  final Widget? child;
  final Color? color;
  final BoxBorder? border;
  double? width;
  double? height;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxShape? shape;
  final DecorationImage? image;
  void Function()? onPressed;

  buttonRummy(
      {Key? key,
      this.shape,
      this.child,
      this.border,
      this.color,
      this.width,
      this.borderRadius,
      this.height,
      this.boxShadow,
      this.image,
      this.onPressed})
      : super(key: key);

  @override
  State<buttonRummy> createState() => _buttonRummyState();
}

class _buttonRummyState extends State<buttonRummy> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height ?? AppSize.height(context, 6),
        width: widget.width ?? AppSize.width(context, 100),
        decoration: BoxDecoration(
            color: widget.color ?? ColorConstant.apptheme.withOpacity(0.7),
            border: widget.border,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            boxShadow: widget.boxShadow,
            image: widget.image),
        child: Center(child: widget.child),
      ),
    );
  }
}
