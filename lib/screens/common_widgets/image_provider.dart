import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

class CustomImageProvider extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final AlignmentGeometry alignment;
  final double? scale;
  const CustomImageProvider(
      {super.key,
      this.image,
      this.height,
      this.width,
      this.fit = BoxFit.contain,
      this.color,
      this.alignment = Alignment.center,
      this.scale});

  @override
  Widget build(BuildContext context) {
    debugPrint("image $image");
    if (image == null || image!.isEmpty) {
      return Image.asset(
        AppImages.profileImg,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    }
    return image!.startsWith("http")
        ? Image.network(
            image!,
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              AppImages.profileImg,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
            ),
          )
        : image!.endsWith(".svg")
            ? SvgPicture.asset(
                image!,
                width: width,
                height: height,
                fit: fit,
              )
            : Image.asset(
                image!,
                width: width,
                height: height,
                fit: fit,
                color: color,
                alignment: alignment,
                scale: scale,
              );
  }
}
