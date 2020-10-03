import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPage extends StatefulWidget {

  @override
  _PhotoPage createState() => _PhotoPage();
}

class _PhotoPage extends State<PhotoPage> {
  File _image;
  int _compressQuality = 0;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidBottomSheet();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Add Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidChooseBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: OrientationBuilder(
                  builder: (context, orientation) {
                    //height: orientation == Orientation.portrait ? 320 : 220,
                    return Container(
                      height: 350,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0, 12.0, 16.0, 12.0,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text('Compress Quality', style: TextStyle(
                                    fontFamily: 'ProductSans',
                                    fontSize: 18.0),),
                                MaterialButton(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.cancel, color: Colors.red,),
                                      SizedBox(width: 4,),
                                      Text('Cancel', style: TextStyle(fontFamily: 'ProductSans', color: Colors.red),),
                                    ],
                                  ),
                                  onPressed: ()=> Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.mood_bad),
                            title: Text('5%', style: TextStyle(
                                fontFamily: 'ProductSans'),),
                            subtitle: Text('bad', style: TextStyle(
                                fontFamily: 'ProductSans'),),
                            onTap: () {
                              _compressQuality = 5;
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.mood_bad),
                            title: Text('10%', style: TextStyle(
                                fontFamily: 'ProductSans'),),
                            subtitle: Text('not bad',
                              style: TextStyle(fontFamily: 'ProductSans'),),
                            onTap: () {
                              _compressQuality = 10;
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.insert_emoticon),
                            title: Text('50%', style: TextStyle(
                                fontFamily: 'ProductSans'),),
                            subtitle: Text(
                              'normal',
                              style: TextStyle(fontFamily: 'ProductSans'),),
                            onTap: () {
                              _compressQuality = 50;
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.mood),
                            title: Text('70%', style: TextStyle(
                                fontFamily: 'ProductSans'),),
                            subtitle: Text(
                              'good',
                              style: TextStyle(fontFamily: 'ProductSans'),),
                            onTap: () {
                              _compressQuality = 70;
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        }
    );
  }

  _androidBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              //color: Colors.white,
              child: Container(
                //color: Colors.transparent,
                child: new Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0,),
                      child: new Text('Add photo', style: TextStyle(
                          fontFamily: 'ProductSans',
                          fontSize: 18.0),),
                    ),
                    new ListTile(
                        leading: new Icon(Icons.camera),
                        title: new Text('Take Photo', style: TextStyle(fontFamily: 'ProductSans'),),
                        onTap: () => {
                          _handleImage(ImageSource.camera),
                        }
                    ),
                    new ListTile(
                      leading: new Icon(Icons.photo),
                      title: new Text('Choose from Gallery', style: TextStyle(fontFamily: 'ProductSans'),),
                      onTap: () => {
                        _handleImage(ImageSource.gallery),
                      },
                    ),
                    new ListTile(
                      leading: new Icon(Icons.cancel, color: Colors.redAccent,),
                      title: new Text('Cancel', style: TextStyle(fontFamily: 'ProductSans', color: Colors.redAccent),),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      compressQuality: _compressQuality,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Flutter crop',
        activeControlsWidgetColor: Colors.red,
        //activeWidgetColor: Colors.greenAccent,
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.black87,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0,
      ),
    );
    return croppedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                //height: height,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _showSelectImageDialog,
                      child: Column(
                        children: [
                          OrientationBuilder(
                              builder: (context, orentation) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 520,
                                  width: 520,
                                  color: Colors.black12,
                                  child: _image == null
                                      ? Icon(Icons.add_a_photo, size: 62,)
                                      : Image(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 5.0,
            ),
            child: GestureDetector(
              //onTap: ()=> selectDate(context, DateTime.now(),),
              onTap: () async {_androidChooseBottomSheet();},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.fromLTRB(10,20,20,20,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Compress quality = ",
                      style: TextStyle(fontSize: 16, fontFamily: 'ProductSans', color: Colors.grey[600]),),
                    Text("$_compressQuality",
                      style: TextStyle(fontFamily: 'ProductSans'),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
