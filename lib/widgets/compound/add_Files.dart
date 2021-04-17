import '../../utilities/my_image_picker.dart';
import '../../utilities/utilities.dart';
import '../../models/constants.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class AddFiles extends StatefulWidget {
  final List<String> files;
  AddFiles(this.files);

  @override
  _AddFilesState createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...widget.files.map((file) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  //color: AppConstants.primaryColor,
                  image: DecorationImage(
                    image: _isImageFile(file)
                        ? Utilities.getImage(file)
                        : Utilities.getFileImage(file),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Stack(
                  //overflow: Overflow.visible,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.files.remove(file);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          RawMaterialButton(
            constraints: BoxConstraints(),
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              var pickedFile;
              try {
                pickedFile = await MyImagePicker(context).pickAndUploadImageOrFile();
              } finally {
                setState(() {
                  if (pickedFile != null) widget.files.add(pickedFile);
                  _loading = false;
                });
              }
//await MyImagePicker(context).pickImage;
            },
            child: FittedBox(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppConstants.primaryColor,
                  ),
                  child: _loading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        )
                      : FittedBox(
                                              child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 50,
                          ),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isImageFile(String file) {
    var ext = file.split('.').last;
    var imageExt = ['jpg', 'jpeg', 'png'];
    if (imageExt.contains(ext))
      return true;
    else
      return false;
  }
}
