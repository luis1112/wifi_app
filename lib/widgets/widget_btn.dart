import 'package:flutter/material.dart';
import 'package:wifi/docs.dart';

class BtnC extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? colorTitle;
  final Color? colorBorderSide;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final Function? onTap;
  final double radius;
  final Widget? leftChild;
  final Widget? rightChild;
  final bool isExpanded;
  final bool isActive;

  const BtnC({
    super.key,
    this.title = 'Aceptar',
    this.color,
    this.colorTitle,
    this.height = 30.0,
    this.width = 300.0,
    this.textStyle,
    this.onTap,
    this.radius = 10.0,
    this.colorBorderSide,
    this.leftChild,
    this.rightChild,
    this.isExpanded = true,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    var colorAux = isActive ? UtilTheme.primary : Colors.grey.withOpacity(0.5);
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.all(color ?? colorAux),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: colorBorderSide ?? colorAux,
            ),
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leftChild != null) leftChild!,
            if (isExpanded) ...[Expanded(child: texBtn())] else ...[texBtn()],
            if (rightChild != null) rightChild!,
          ],
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if (onTap != null) onTap!();
        },
      ),
    );
  }

  Widget texBtn() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        style: textStyle ??
            TextStyle(
              color: colorTitle ?? Colors.white,
              fontSize: 12.0
            ),
      ),
    );
  }
}

class BtnCSelect extends StatelessWidget {
  final String title;
  final Function? onTap;
  final bool isSelect;
  final double radius;

  const BtnCSelect({
    super.key,
    this.title = 'Aceptar',
    this.onTap,
    this.isSelect = false,
    this.radius = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return BtnC(
      title: title,
      isExpanded: false,
      width: null,
      height: 30.0,
      radius: radius,
      color: isSelect ? null : Colors.white,
      colorBorderSide: isSelect ? null : Colors.black,
      textStyle: TextStyle(
        fontSize: 14.0,
        color: isSelect ? null : Colors.black,
      ),
      onTap: onTap,
    );
  }
}

class BtnText extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final Color? color;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Function? onTap;
  final bool isExpanded;

  const BtnText(
    this.title, {
    super.key,
    this.fontSize,
    this.textStyle,
    this.textAlign,
    this.color,
    this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpanded) return Expanded(child: itemBtn(context));
    return itemBtn(context);
  }

  Widget itemBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (onTap != null) {
          FocusScope.of(context).requestFocus(FocusNode());
          onTap!();
        }
      },
      child: Text(
        title ?? "",
        textAlign: textAlign,
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 16.0,
              fontWeight: FontWeight.w500,
              color: color,
            ),
      ),
    );
  }
}
