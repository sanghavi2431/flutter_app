import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A safe Text widget for localized strings that automatically handles overflow
/// to prevent UI breaking on different devices and languages.
class SafeLocalizedText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? textScaleFactor;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Locale? locale;
  final int? maxLength;
  final String? semanticsLabel;

  const SafeLocalizedText(
    this.textKey, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
    this.textScaleFactor,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.locale,
    this.maxLength,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    String localizedText = textKey.tr();
    
    // Optionally limit text length if maxLength is provided
    if (maxLength != null && localizedText.length > maxLength!) {
      localizedText = '${localizedText.substring(0, maxLength!)}...';
    }

    return Text(
      localizedText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaleFactor: textScaleFactor,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      locale: locale,
      semanticsLabel: semanticsLabel ?? localizedText,
    );
  }
}

/// A safe Text.rich widget for localized strings with multiple spans
class SafeLocalizedTextRich extends StatelessWidget {
  final List<TextSpan> textSpans;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final String? semanticsLabel;

  const SafeLocalizedTextRich({
    super.key,
    required this.textSpans,
    this.style,
    this.textAlign,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
    this.textScaleFactor,
    this.maxLines = 2,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: textSpans),
      style: style,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      semanticsLabel: semanticsLabel,
    );
  }
}
