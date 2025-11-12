import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Global instance biar tidak re-init terus
final YoutubeExplode ytInstance = YoutubeExplode();

/// Cache manifest biar video yang sama tidak perlu dimuat ulang
final Map<String, StreamManifest> manifestCache = {};

/// Ambil direct video URL dari YouTube
Future<String?> getYoutubeDirectUrl(String youtubeUrl) async {
  try {
    final uri = Uri.parse(youtubeUrl);
    final videoId = uri.queryParameters['v'] ?? uri.pathSegments.last;

    // ✅ Gunakan cache jika sudah pernah diambil
    if (manifestCache.containsKey(videoId)) {
      final manifest = manifestCache[videoId]!;
      final stream = manifest.muxed.firstWhere(
        (s) => s.videoQualityLabel == '360p',
        orElse: () => manifest.muxed.bestQuality,
      );
      return stream.url.toString();
    }

    // Ambil manifest dari YouTube
    final manifest = await ytInstance.videos.streamsClient.getManifest(videoId);
    manifestCache[videoId] = manifest;

    final stream = manifest.muxed.firstWhere(
      (s) => s.videoQualityLabel == '360p',
      orElse: () => manifest.muxed.bestQuality,
    );

    return stream.url.toString();
  } catch (e) {
    print("❌ Gagal ambil manifest: $e");
    return null;
  }
}
