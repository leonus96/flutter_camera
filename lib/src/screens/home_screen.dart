import 'dart:io';

import 'package:camara_flutter/src/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PickedFile> images = [];
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cámara con Flutter.'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          File imageFile = File(images[index].path);
          return InkWell(
              child: Image.file(imageFile),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageViewScreen(
                          imageFile: imageFile,
                        )));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _optionsDialogBox,
      ),
    );
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('image_picker: Take picture'),
                    onTap: _openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('image_picker: Select from gallery'),
                    onTap: _openGallery,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('camera: CameraPreview'),
                    onTap: () async {
                      String path = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen()));
                      PickedFile pickedFile = PickedFile(path);
                      images.add(pickedFile);
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openCamera() async {
    PickedFile picture = await imagePicker.getImage(
      source: ImageSource.camera,
    );
    Navigator.pop(context);
    setState(() {
      images.add(picture);
    });
  }

  void _openGallery() async {
    PickedFile picture = await imagePicker.getImage(
      source: ImageSource.gallery,
    );
    Navigator.pop(context);
    setState(() {
      images.add(picture);
    });
  }
}
