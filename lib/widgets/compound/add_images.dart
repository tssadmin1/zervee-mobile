import '../../utilities/utilities.dart';

import '../../utilities/my_image_picker.dart';
import '../../models/constants.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class AddImages extends StatefulWidget {
  final List<String> images;
  AddImages(this.images);

  @override
  _AddImagesState createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...widget.images.map((image) {
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
                    image: Utilities.getImage(image),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Stack(
                  overflow: Overflow.visible,
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
                            widget.images.remove(image);
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
              var pickedImage;
              try {
                pickedImage = await MyImagePicker(context).pickAndUploadImage();
              } on Exception catch (e) {} finally {
                setState(() {
                  if (pickedImage != null) widget.images.add(pickedImage);
                  _loading = false;
                });
              }
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
}
