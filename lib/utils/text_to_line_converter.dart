import 'logger.dart';

class PestControlService {
  final String icon;
  final String title;
  final List<String> description;

  PestControlService({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  String toString() => '$icon $title: ${description.join(' ')}';
}

List<PestControlService> parseServices(String rawData) {
  final lines = rawData.split('\n');
  final services = <PestControlService>[];

  String? currentIcon;
  String? currentTitle;
  List<String> currentDescription = [];

  final sectionHeader = RegExp(
    r'^(\p{Emoji_Presentation}|\p{Extended_Pictographic})\s(.+)$',
    unicode: true,
  );

  for (final line in lines) {
    if (line.trim().isEmpty) continue;

    final match = sectionHeader.firstMatch(line);
    if (match != null) {
      if (currentIcon != null &&
          currentTitle != null &&
          currentDescription.isNotEmpty) {
        services.add(
          PestControlService(
            icon: currentIcon,
            title: currentTitle,
            description: List.from(currentDescription),
          ),
        );
      }

      currentIcon = match.group(1)!;
      currentTitle = match.group(2)!;
      currentDescription = [];
    } else {
      currentDescription.add(line.trim());
    }
  }

  // Add last entry
  if (currentIcon != null &&
      currentTitle != null &&
      currentDescription.isNotEmpty) {
    services.add(
      PestControlService(
        icon: currentIcon,
        title: currentTitle,
        description: currentDescription,
      ),
    );
  }

  return services;
}
