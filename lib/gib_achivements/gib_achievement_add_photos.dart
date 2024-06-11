import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart'as http;
import '../main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'gib_achivements_view_photos.dart';




class AchievementAddPhotos extends StatelessWidget {
  const AchievementAddPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AchievementPhotosPage(),
    );
  }
}


class AchievementPhotosPage extends StatefulWidget {
  const AchievementPhotosPage({Key? key}) : super(key: key);

  @override
  State<AchievementPhotosPage> createState() => _AchievementPhotosPageState();
}


class _AchievementPhotosPageState extends State<AchievementPhotosPage> {


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MyScaffold(
        route: '/gib_achieve_add_photos',
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                child: TabBar(

                  labelColor: Colors.black,
                  dividerColor: Colors.black,
                  // ignore: prefer_const_literals_to_create_immutables
                  tabs: [
                    Tab(
                      icon: Row(
                        children: [
                          Text("Add Images",),
                          SizedBox(width: 10,),

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
                          Text("View Images",),
                          SizedBox(width: 10,),
                          Icon(
                            Icons.photo_library,
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
                      AchievementImageAdd(),
                      AchievementViewPhotosPage(),




                    ]
                    )),
              )

            ],
          ),
        ),
      ),
    );
  }
}



/// image Addd
class AchievementImageAdd extends StatefulWidget {
  const AchievementImageAdd({super.key});

  @override
  State<AchievementImageAdd> createState() => _AchievementImageAddState();
}
class _AchievementImageAddState extends State<AchievementImageAdd> {
  final _formKey = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final dateController = TextEditingController();

  List<XFile> selectedImages = [];
  final picker = ImagePicker();
  DateTime? selectedDate;
  bool isLoading = false;

  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }


  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles;
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_formKey.currentState!.validate() && selectedImages.isNotEmpty) {
      for (var image in selectedImages) {
        try {
          final bytes = await image.readAsBytes();
          final base64Image = base64Encode(bytes);
          final fileName = image.name;
          final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/gibachievementimage.php');
          final response = await http.post(url,
            body: {
              'event_name': eventNameController.text,
              'image_name': fileName,
              'image_data': base64Image,
              'selected_date': dateController.text,

            },
          );

          if (response.statusCode == 200) {


            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success!'),
                content: Text('Your Image(s) have been uploaded successfully.'),
                actions: [
                  TextButton(
                    onPressed: () =>  Navigator.pushNamed(context, '/gib_achieve_add_photos'), // Close dialog
                    child: Text('OK'),
                  ),
                ],
              );});
            setState(() {
              isLoading = false;
            });

          } else {
            print('Failed to upload image. Status code: ${response.statusCode}');
          }
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate:  DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = _formatDate(pickedDate); // Update the controller's text
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('dd-MM-yyyy').format(date);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Images'),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SizedBox(
                  //height: 50,
                  child:  TextFormField(
                    controller: dateController,
                    readOnly: true, // Make it read-only to prevent manual input
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Event date';
                      }
                      return null;
                    },
                      onChanged: (value) {
                        setState(() {
                          // This will re-validate the form and hide the error message
                          _formKey.currentState?.validate();
                        });}
                  ),

                )),
                SizedBox(width: 20,),
                Expanded(child: SizedBox(//height: 50,
                  child: TextFormField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      hintText: 'Enter your event name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter a Event Name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        // This will re-validate the form and hide the error message
                        //_formKey.currentState?.validate();
                      });
                      String capitalizedValue = capitalizeFirstLetter(value);
                      eventNameController.value = eventNameController.value.copyWith(
                        text: capitalizedValue,
                      );
                    },
                  ),
                )),

              ],
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text('Select Images from Gallery'),
                  onPressed: _pickImages,
                ),
                isLoading ? CircularProgressIndicator() :ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(selectedImages.isNotEmpty ? Colors.blue : Colors.grey), // Change color based on images selection
                  ),
                  onPressed: _uploadImages,
                  child: Text('        Submit       '),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                width: 300.0,
                child: selectedImages.isEmpty
                    ?
                Center(child: Text('Nothing Image is selected!!', ))
                    : GridView.builder(
                  itemCount: selectedImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Center(
                          child: kIsWeb
                              ? Image.network(selectedImages[index].path)
                              : Image.file(File(selectedImages[index].path)),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// Video Add
class AchievementVideoAdd extends StatefulWidget {
  const AchievementVideoAdd({Key? key}) : super(key: key);

  @override
  _AchievementVideoAddState createState() => _AchievementVideoAddState();
}
class _AchievementVideoAddState extends State<AchievementVideoAdd> {
  final _formKey = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final dateController = TextEditingController();
  List<XFile> selectedVideos = [];
  final picker = ImagePicker();
  DateTime? selectedDate;
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  bool isLoading = false;




  Future<void> _pickVideo() async {

    final XFile? pickedVideo = await picker.pickVideo(source: ImageSource.gallery, maxDuration: Duration(seconds: 120),);
    if (pickedVideo != null) {
      final Uint8List videoBytes = await pickedVideo.readAsBytes();
      if (videoBytes.length > 10 * 1024 * 1024) {
        // File size exceeds the limit, show an alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('File Too Large'),
              content: Text('The selected file exceeds the maximum size limit of 10MB.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      setState(() {
        selectedVideos.add(pickedVideo);
      });
    }
  }

  Future<void> _uploadVideos() async {
    setState(() {
      isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String eventName = eventNameController.text;
    String selectedDate = dateController.text;
    print('eventName: $eventName');
    print('selectedDate: $selectedDate');
    for (XFile video in selectedVideos) {
      Uint8List videoBytes = await video.readAsBytes();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://mybudgetbook.in/GIBADMINAPI/gibachievementvideos.php'),
      );
      // 'selected_date': dateController.text,
      request.fields['video_name'] = video.name;
      request.fields['event_name'] = eventName;
      request.fields['selected_date'] = selectedDate;
      request.files.add(
        http.MultipartFile.fromBytes(
          'video',
          videoBytes,
          filename: video.name,
          contentType: MediaType('video', 'mp4'),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        Navigator.pushNamed(context, '/gib_achieve_add_photos');
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success!'),
            content: Text('Your video(s) have been uploaded successfully.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                child: Text('OK'),
              ),
            ],
          );});
        setState(() {
          isLoading = false;
        });
      } else {
        print('Upload failed: ${response.reasonPhrase}');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = _formatDate(pickedDate); // Update the controller's text
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('dd-MM-yyyy').format(date);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Videos',),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SizedBox(
                  height: 50,
                  child:  TextFormField(
                    controller: dateController,
                    readOnly: true, // Make it read-only to prevent manual input
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Event date';
                      }
                      return null;
                    },
                      onChanged: (value) {
                        setState(() {
                          // This will re-validate the form and hide the error message
                          _formKey.currentState?.validate();
                        });}
                  ),

                )),
                SizedBox(width: 20,),
                Expanded(child: SizedBox(height: 50,
                  child: TextFormField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      hintText: 'Enter your event name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        // This will re-validate the form and hide the error message
                        _formKey.currentState?.validate();
                      });
                      String capitalizedValue = capitalizeFirstLetter(value);
                      eventNameController.value = eventNameController.value.copyWith(
                        text: capitalizedValue,
                      );
                    },

                  ),
                )),

              ],
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text('Select Videos from Gallery'),
                  onPressed: _pickVideo,
                ),
                isLoading ? CircularProgressIndicator() : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(selectedVideos.isNotEmpty ? Colors.blue : Colors.grey), // Change color based on video selection
                  ),
                  onPressed: _uploadVideos,
                  child: Text('       Submit      '),
                ),

              ],
            ),
            Expanded(
              child: SizedBox(
                width: 300.0,
                child: selectedVideos.isEmpty
                    ? const Center(child: Text('No videos selected'))
                    : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: selectedVideos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Center(
                          child: Icon(Icons.video_collection),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                selectedVideos.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


















