import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../services/asset_service.dart';

class AssetPlayerScreen extends StatefulWidget {
  final Asset asset;

  const AssetPlayerScreen({super.key, required this.asset});

  @override
  _AssetPlayerScreenState createState() => _AssetPlayerScreenState();
}

class _AssetPlayerScreenState extends State<AssetPlayerScreen> {
  late final AssetService _assetService;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _assetService = AssetService();
  }

  @override
  void dispose() {
    _assetService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asset.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audio_file, size: 100),
            SizedBox(height: 20),
            Text(
              widget.asset.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 48,
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                    if (_isPlaying) {
                      _assetService.playAudio(widget.asset);
                    } else {
                      _assetService.pauseAudio();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  iconSize: 48,
                  onPressed: () {
                    setState(() {
                      _isPlaying = false;
                    });
                    _assetService.stopAudio();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
