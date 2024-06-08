import 'package:flutter/material.dart';
import 'package:gibadmin/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:typed_data';

import 'package:video_player/video_player.dart';

class AchievementViewPhotos extends StatelessWidget {
  const AchievementViewPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AchievementGibGallery(),
    );
  }
}

class AchievementGibGallery extends StatefulWidget {
  const AchievementGibGallery({Key? key}) : super(key: key);

  @override
  State<AchievementGibGallery> createState() => _AchievementGibGalleryState();
}

class _AchievementGibGalleryState extends State<AchievementGibGallery> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MyScaffold(
        route: '/gib_achievements_view_images_gallery',
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: TabBar(
                  labelColor: Colors.black,
                  dividerColor: Colors.black,
                  // ignore: prefer_const_literals_to_create_immutables
                  tabs: [
                    Tab(
                      icon: Row(
                        children: [
                          Text(
                            "Images",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.photo_library,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      icon: Row(
                        children: [
                          Text(
                            "Videos",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.video_camera_back,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1100,
                child: Expanded(
                    child: TabBarView(children: [
                  AchievementViewPhotosPage(),
                  AchievementViewVideosPage(),
                ])),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AchievementViewPhotosPage extends StatefulWidget {
  const AchievementViewPhotosPage({Key? key}) : super(key: key);

  @override
  State<AchievementViewPhotosPage> createState() =>
      _AchievementViewPhotosPageState();
}

class _AchievementViewPhotosPageState extends State<AchievementViewPhotosPage> {
  List<Map<String, dynamic>> _imageGroups = [];

  Future<void> _fetchImages() async {
    final url = Uri.parse(
        'http://mybudgetbook.in/GIBADMINAPI/gibachievementimagefetch.php');
    print('123$url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> imageData = jsonDecode(response.body);

      setState(() {
        _imageGroups = imageData.map((data) {
          return {
            'event_name': data['event_name'],
            'selectedDate': data['selectedDate'],
            'imagepaths': data['imagepaths'],
            'id': int.parse(data['id']),
          };
        }).toList();
      });
    } else {
      print('Failed to fetch images.');
    }
  }

  Future<void> deleteImage(int imageId) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/gibachievementimagefetch.php');
      print('Deleting image with URL: $url');

      // Create a JSON object with the image ID
      Map<String, dynamic> jsonData = {'id': imageId};

      // Send the DELETE request to your PHP script
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image deleted successfully'),
          ),
        );
        print('Image deleted successfully');
      } else {
        throw Exception(
            'Failed to delete image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Failed to delete image.'),
        ),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(int imageId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Image"),
          content: Text("Are you sure you want to delete this image?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteImage(imageId).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image deleted successfully'),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: Failed to delete image.'),
                    ),
                  );
                });
                Navigator.of(context).pop(true);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _imageGroups.length,
        itemBuilder: (context, index) {
          final group = _imageGroups[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event Name- ${group['event_name']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Date - ${group['selectedDate']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemCount: group['imagepaths'].length,
                    itemBuilder: (context, imageIndex) {
                      final imagePath = group['imagepaths'][imageIndex];
                      return FutureBuilder(
                        future: http.get(Uri.parse(
                            'http://mybudgetbook.in/GIBADMINAPI/$imagePath')),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final imageResponse =
                                snapshot.data as http.Response;
                            if (imageResponse.statusCode == 200) {
                              return Stack(
                                children: [
                                  Image.memory(
                                    Uint8List.fromList(imageResponse.bodyBytes),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: PopupMenuButton(
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          value: 'details',
                                          child: Text('Details'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'details') {
                                          // Implement details action here
                                        } else if (value == 'delete') {
                                          _showDeleteConfirmationDialog(
                                              group['id'] as int);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Text('Error loading image');
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Text('Error loading image');
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AchievementViewVideosPage extends StatefulWidget {
  const AchievementViewVideosPage({Key? key}) : super(key: key);

  @override
  _AchievementViewVideosPageState createState() =>
      _AchievementViewVideosPageState();
}

class _AchievementViewVideosPageState extends State<AchievementViewVideosPage> {
  List<Map<String, dynamic>> _groupedVideos = [];

  Future<void> _fetchVideos() async {
    final url = Uri.parse(
        'http://mybudgetbook.in/GIBADMINAPI/gibachievementvideosfetch.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _groupedVideos =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      print('Failed to fetch videos');
    }
  }

  Future<void> _deleteVideo(int groupIndex, int videoIndex) async {
    final videoToDelete = _groupedVideos[groupIndex]['videos'][videoIndex];
    final videoId = videoToDelete['id'];

    final confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this video?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      final deleteUrl = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/gibachievementvideosfetch.php');
      final deleteResponse = await http.delete(
        deleteUrl,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': videoId}),
      );

      if (deleteResponse.statusCode == 200) {
        setState(() {
          _groupedVideos[groupIndex]['videos'].removeAt(videoIndex);
          if (_groupedVideos[groupIndex]['videos'].isEmpty) {
            _groupedVideos.removeAt(groupIndex);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete video')),
        );
      }
    }
  }

  void _playVideo(String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementVideoPlayerScreen(videoUrl: videoUrl),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _groupedVideos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _groupedVideos.length,
              itemBuilder: (context, index) {
                final group = _groupedVideos[index];
                final eventName = group['event_name'];
                final selectedDate = group['selectedDate'];
                final videos = group['videos'];

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Event Name: $eventName',
                            ),
                            Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green, // Change the color here
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2.0),
                                child: Text(
                                  'Date: $selectedDate',
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns in the grid
                            childAspectRatio: 16 / 9,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: videos.length,
                          itemBuilder: (context, videoIndex) {
                            final video = videos[videoIndex];
                            return GestureDetector(
                              onTap: () => _playVideo(video['videos_path']),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          video['thumbnail_path'],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.error),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'delete') {
                                                _deleteVideo(index, videoIndex);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    video['videos_name'],
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class AchievementVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const AchievementVideoPlayerScreen({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _AchievementVideoPlayerScreenState createState() =>
      _AchievementVideoPlayerScreenState();
}

class _AchievementVideoPlayerScreenState
    extends State<AchievementVideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
