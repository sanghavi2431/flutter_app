




import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';


class CustomImageProvider extends StatelessWidget {
 final String? image;
 final double? width;
 final double? height;
 final BoxFit fit;
 final Color? color;
 final AlignmentGeometry alignment;
 final double? scale;
  const CustomImageProvider({
    super.key , 
    this.image, 
    this.height, 
    this.width,
    this.fit  = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.scale
  });

  @override
  Widget build(BuildContext context) {
     debugPrint("image $image");
    return image!.startsWith("https:") ?
           Image.network(image!,
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
           )   :
          image!.endsWith(".svg")
          ?
          SvgPicture.asset(image!,
            width: width,
            height: height,
            fit: fit,
           )
         : Image.asset(image!,
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
            scale: scale,
         )
    ;
  }
}