/// Builds a safe network URL for janitor/supervisor profile photos.
class ProfileImageUrl {
  ProfileImageUrl._();

  static String? resolve({
    String? baseUrl,
    String? profileImage,
    int? cacheToken,
  }) {
    final image = (profileImage ?? '').trim();
    if (image.isEmpty) return null;

    final cleaned = image
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .trim();
    if (cleaned.isEmpty) return null;

    final String url;
    if (cleaned.startsWith('http://') || cleaned.startsWith('https://')) {
      url = cleaned;
    } else {
      final base = (baseUrl ?? '').trim();
      if (base.isEmpty) return null;
      final normalizedBase = base.endsWith('/')
          ? base.substring(0, base.length - 1)
          : base;
      final normalizedPath =
          cleaned.startsWith('/') ? cleaned.substring(1) : cleaned;
      url = '$normalizedBase/$normalizedPath';
    }

    final uri = Uri.tryParse(url);
    if (uri == null ||
        !(uri.isScheme('http') || uri.isScheme('https')) ||
        uri.host.isEmpty) {
      return null;
    }

    if (cacheToken == null || cacheToken <= 0) return url;
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}t=$cacheToken';
  }
}