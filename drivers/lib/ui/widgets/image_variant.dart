import 'package:cached_network_image/cached_network_image.dart';
import 'package:drivers/image_variant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImageVariantContainer extends StatelessWidget {
  final ImageVariant image;
  final Widget Function(BuildContext context, String url) placeholder;
  final Widget Function(BuildContext context, String url, Object error)
      errorWidget;

  const AppImageVariantContainer(
    this.image, {
    Key key,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image.match(
      asset: (asset) => Image.asset(asset),
      svg: (svg) => SvgPicture.asset(svg),
      network: (url) => CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder:
            placeholder ?? (context, url) => const CircularProgressIndicator(),
        errorWidget:
            errorWidget ?? (context, url, error) => const Icon(Icons.error),
      ),
      file: (file) => Image.file(file),
    );
  }
}
