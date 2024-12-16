import 'package:metadata_fetch/metadata_fetch.dart';

Future<Map<String, String>?> fetchMetadata(String url) async {
  try {
    var data = await MetadataFetch.extract(url);
    if (data != null) {
      return {
        'title': data.title ?? 'Untitled',
        'image': data.image ?? 'https://via.placeholder.com/150',
        'url': data.url ?? url,
        'description': data.description ?? '',
      };
    }
  } catch (e) {
    print('Error fetching metadata: $e');
  }

  return null; // Return null if fetching fails
}
