import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class _CameraScreenState extends State<CameraScreen> {
  WidgetState _widgetState = WidgetState.NONE;
  List<CameraDescription> _cameras = List<CameraDescription>();
  CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return _buildScaffold(
            context, Center(child: CircularProgressIndicator()));
      case WidgetState.LOADED:
        return _buildScaffold(context, CameraPreview(_cameraController));
      case WidgetState.ERROR:
        return _buildScaffold(
            context,
            Center(
                child: Text(
                    "La cámara no se pudo inicializar 😩. Reinicia la aplicación.")));
    }
  }

  Widget _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cámara Flutter"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            XFile xfile = await _cameraController.takePicture();
            Navigator.pop(context, xfile.path);
          },
          child: Icon(Icons.camera)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future initializeCamera() async {
    _widgetState = WidgetState.LOADING;
    if (mounted) setState(() {});

    _cameras = await availableCameras();

    _cameraController =
        new CameraController(_cameras[0], ResolutionPreset.high);

    await _cameraController.initialize();

    if (_cameraController.value.hasError) {
      _widgetState = WidgetState.ERROR;
      if (mounted) setState(() {});
    } else {
      _widgetState = WidgetState.LOADED;
      if (mounted) setState(() {});
    }
  }
}
