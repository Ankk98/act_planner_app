import 'package:audioplayers/audioplayers.dart';
import '../models/asset.dart';

class AssetService {
  final AudioPlayer audioPlayer = AudioPlayer();
  
  Future<void> playAudio(Asset asset) async {
    if (asset.type != AssetType.Audio) return;
    final fileUri = Uri.file(asset.path);
    final source = UrlSource(fileUri.toString());
    await audioPlayer.play(source);
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }

  Future<void> seekAudio(Duration position) async {
    await audioPlayer.seek(position);
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
