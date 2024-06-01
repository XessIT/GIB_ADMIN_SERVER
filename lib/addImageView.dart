import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddImageView extends StatefulWidget {
  final String membername;
  final String memberId;
  const AddImageView(
      {super.key, required this.membername, required this.memberId});

  @override
  State<AddImageView> createState() => _AddImageViewState();
}

class _AddImageViewState extends State<AddImageView> {
  List<Map<String, dynamic>> _imageGroups = [];

  Future<void> _fetchImages(String memberId) async {
    final url = Uri.parse(
        'http://mybudgetbook.in/GIBADMINAPI/addimageview.php?memberId=$memberId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> imageData = jsonDecode(response.body);

      setState(() {
        _imageGroups = imageData.map((data) {
          return {
            'imagepaths': List<String>.from(data['imagepaths']),
          };
        }).toList();
      });
    } else {
      print('Failed to fetch images.');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchImages(widget.memberId);
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
                        'Member Name - ${widget.membername}',
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
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 10.0, // Space between rows
                    ),
                    itemCount: group['imagepaths'].length,
                    itemBuilder: (context, imageIndex) {
                      final imagePath = group['imagepaths'][imageIndex];
                      final imageName = imagePath
                          .split('/')
                          .last; // Extract image name from the path

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
                              return Column(
                                children: [
                                  Expanded(
                                    child: Image.memory(
                                      Uint8List.fromList(
                                          imageResponse.bodyBytes),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
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
