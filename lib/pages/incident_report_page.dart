import 'dart:io';

import 'package:camera/camera.dart';
import 'package:city_care/pages/take_picture_page.dart';
import 'package:city_care/view_models/report_incident_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class IncidentReportPage extends StatefulWidget {
  @override 
  _IncidentReportPageState createState() => _IncidentReportPageState(); 
}

class _IncidentReportPageState extends State<IncidentReportPage> {

  ReportIncidentViewModel _reportIncidentViewModel; 

  @override
  void initState() {
    super.initState();
    _reportIncidentViewModel = Provider.of<ReportIncidentViewModel>(context, listen: false);
  }

  void _showPhotoAlbum() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _reportIncidentViewModel.imagePath = image.path;
    });
    
  }


  void _showPhotoSelectionOptions(BuildContext context) {

    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          height: 150, 
          child: Column(children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.of(context).pop(); 
                _showCamera();
              },
              leading: Icon(Icons.photo_camera),
              title: Text("Take a picture")
            ), 
            ListTile(
              onTap: () {
                Navigator.of(context).pop(); 
                _showPhotoAlbum();
              },
              leading: Icon(Icons.photo_album),
              title: Text("Select from photo library")
            )
          ])
        );
      }
    );

  }

  void _showCamera() async {

    final cameras = await availableCameras(); 
    final camera = cameras.first;

    final result = await Navigator.push(context,
    MaterialPageRoute(
      builder: (context) => TakePicturePage(camera: camera)));

    setState(() {
      _reportIncidentViewModel.imagePath = result; 
    });

  }

  void _saveIncident(BuildContext context) async {
    await _reportIncidentViewModel.saveIncident(); 
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<ReportIncidentViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Report an incident")
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          
          vm.imagePath == null ? Image.asset("images/houston.jpg") : 
          Image.file(File(vm.imagePath)),
        
          FlatButton(
            color: Colors.grey,
            onPressed: () {
              _showPhotoSelectionOptions(context);
            },
            child: Text("Take Picture",style: TextStyle(color: Colors.white))
          ),
          
          TextField(
            onChanged: (value) => vm.title = value,
            decoration: InputDecoration(
              labelText: "Enter title", 
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ), 

          TextField(
            onChanged: (value) => vm.description = value,
            textInputAction: TextInputAction.done,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: "Enter desciption"
            ),

          ), 

          FlatButton(
            child: Text("Save",style: TextStyle(color: Colors.white)), 
            color: Colors.green,
            onPressed: () {
                _saveIncident(context);
            },
          )


        ]),
      )
    );
    
  }

}