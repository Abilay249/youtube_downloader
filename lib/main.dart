import 'package:flutter/material.dart';

void main() {
  runApp(DownloadApp());
}

class DownloadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DownloadScreen(),
    );
  }
}

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String videoUrl = '';
  bool isDownloading = false;
  int downloadProgress = 0;
  List<String> downloadQueue = [];
  List<String> downloadHistory = [];

  void startDownload() {
    if (videoUrl.isEmpty) {
      showSnackBar('Please enter a video URL.');
      return;
    }

    if (downloadQueue.contains(videoUrl)) {
      showSnackBar('This video is already in the download queue.');
      return;
    }

    downloadQueue.add(videoUrl);
    showSnackBar('Video added to download queue.');

    if (!isDownloading) {
      downloadNextVideo();
    }
  }

  void downloadNextVideo() {
    if (downloadQueue.isNotEmpty) {
      setState(() {
        isDownloading = true;
        videoUrl = downloadQueue.removeAt(0);
        downloadProgress = 0;
      });

      // Simulating download progress for demonstration purposes
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          downloadProgress = 30;
        });
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          downloadProgress = 60;
        });
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          downloadProgress = 100;
          isDownloading = false;
          downloadHistory.add(videoUrl);
        });
        showSnackBar('Download complete for $videoUrl');
        downloadNextVideo();
      });
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Downloader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Download YouTube Videos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Enter the YouTube video URL:',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  videoUrl = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Video URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: startDownload,
              child: Text('Start Download'),
            ),
            SizedBox(height: 16),
            if (isDownloading) ...[
              LinearProgressIndicator(value: downloadProgress / 100),
              SizedBox(height: 8),
              Text(
                'Downloading $videoUrl... $downloadProgress%',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
            SizedBox(height: 16),
            Text(
              'Download History:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: downloadHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.check),
                    title: Text(downloadHistory[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

