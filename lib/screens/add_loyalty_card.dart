import 'dart:io';

import '../webservices/CustomerServices.dart';

import '../widgets/compound/dialogs.dart';

import '../providers/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../utilities/utilities.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../providers/loyalty_card_provider.dart';
import '../models/loyalty_card_model.dart';
import '../models/constants.dart';
import '../models/merchant_model.dart';
import '../widgets/simple/button.dart';
import 'brand_details.dart';

class AddLoyaltyCard extends StatefulWidget {
  static const routeName = '/AddLoyaltyCard';

  @override
  _AddLoyaltyCardState createState() => _AddLoyaltyCardState();
}

class _AddLoyaltyCardState extends State<AddLoyaltyCard> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  PickedFile _pickedImageFile;
  bool _loading = false;
  String _scanBarcode = 'Unknown';
  //var _industryController = TextEditingController();
  var _storeNameController = TextEditingController();
  var _cardNumberController = TextEditingController();
  bool _doNotCall = false;
  bool _doNotMsg = false;
  var _storeNameError = '';
  var _cardNumberError = '';
  var _pickedImageUrl;
  List<String> stores;
  String cardId;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _scanBarcodeNormal() async {
    String barcodeScanRes;
    //   // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff0000", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    } catch (err) {
      print(err.toString());
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print('Scanned Barcode value : $_scanBarcode');
      _cardNumberController.text =
          _scanBarcode.toString() == '-1' ? '' : _scanBarcode;
    });
  }

  void _addNewLoyaltyCard(BuildContext context) async {
    print('Adding new card...');
    if (_pickedImageFile == null) {
      ShowValidationMessage.showMessage(
          context, 'Please upload an image of the card');
      return;
    }
    if (_storeNameController.text.isEmpty || _pickedImageFile == null) {
      ShowValidationMessage.showMessage(
          context, 'At least one of the fields is empty.');
      return;
    } else if (_storeNameController.text.length < 2) {
      ShowValidationMessage.showMessage(
          context, 'Store name can not have less than 2 characters.');
      return;
    } 
    if (Utilities.listContainsValueIgnoreCase(
        stores, _storeNameController.text.trim())) {
          print('Card already exists');
      ShowValidationMessage.showMessage(
          context, 'Card for this store already added');
      return;
    }
    Dialogs.showLoadingDialog(context, _keyLoader);

    LoyaltyCard newCard = new LoyaltyCard();
    newCard.brandId = _storeNameController.text.trim();
    newCard.storeName = _storeNameController.text;
    newCard.cardImage =
        _pickedImageUrl; //Utilities.imageToBase64String(_pickedImageFile.path);
    newCard.cardNumber =
        _cardNumberController == null ? '' : _cardNumberController.text;
    newCard.cardName = _storeNameController.text.trim();
    newCard.userName = UserInfoProvider.userInfo.username;
    newCard.doNotCall = _doNotCall ? 'Yes' : 'No';
    newCard.doNotMessage = _doNotMsg ? 'Yes' : 'No';

    print('New Card details : $newCard');
    String flag;
    try {
      flag = await Provider.of<LoyaltyCardProvider>(context, listen: false)
          .saveLoyaltyCard(newCard);
    } on Exception catch (e) {
      print('error!!! : $e');
    }
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    if (!flag.contains('already exist')) {
      print('Card added successfully');
      ShowValidationMessage.showMessage(context, 'Card added successfully');
      Navigator.of(context)
          .pushReplacementNamed(BrandDetails.routeName, arguments: newCard);
    } else {
      ShowValidationMessage.showMessage(context, flag);
    }
  }

  void _addLoyaltyCard(BuildContext context, Merchant merchant) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    LoyaltyCard newCard = new LoyaltyCard();
    newCard.brandId = merchant.id;
    newCard.storeName = merchant.brandName;
    //newCard.brandCategory = merchant.industryCategory;
    newCard.cardImage = merchant.brandCardImage;
    newCard.cardNumber =
        _cardNumberController == null ? '' : _cardNumberController.text;
    newCard.userName = UserInfoProvider.userInfo.username;
    newCard.cardName = merchant.brandName;
    newCard.doNotCall = _doNotCall ? 'Yes' : 'No';
    newCard.doNotMessage = _doNotMsg ? 'Yes' : 'No';
    newCard.cardId = cardId;
    print('New Card details : $newCard');
    //LoyaltyCardController.addLoyaltyCard(newCard);
    try {
      var value = await Provider.of<LoyaltyCardProvider>(context, listen: false)
          .saveLoyaltyCard(newCard);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (!value.contains('already exist')) {
        print('Card added successfully');
        ShowValidationMessage.showMessage(context, 'Card added successfully');
        Navigator.of(context)
            .pushReplacementNamed(BrandDetails.routeName, arguments: newCard);
      } else {
        print('Something went wrong while adding new card');
        ShowValidationMessage.showMessage(
            context, value);
      }
    } on Exception catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
  }

  Future<PickedFile> _croppedImage(PickedFile image) async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 0.5),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: AppConstants.primaryMaterialColor,
          toolbarTitle: 'Zervee',
          statusBarColor: AppConstants.primaryMaterialColor,
          backgroundColor: Colors.white,
          cropGridRowCount: 1,
          cropGridColumnCount: 1,
        ));

    return PickedFile(cropped.path);
  }

  Future<void> _selectImage(ImageSource source) async {
    PickedFile picture;
    var image = await ImagePicker().getImage(source: source);
    if (image != null) picture = await _croppedImage(image);
    {
      setState(() {
        _loading = true;
      });
      var url = await CustomerService.uploadFile(picture.path);
      print('$url');
      setState(() {
        _loading = false;
        if (picture != null) {
          _pickedImageFile = picture;
          _pickedImageUrl = url;
        }
      });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make a choice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    //Open gallary
                    _selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text('Open Camera'),
                  onTap: () {
                    //Open Camera
                    _selectImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    print('Add Loyalty card dispose...');
    _storeNameController.dispose();
    _cardNumberController.dispose();
    _pickedImageFile = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    final Merchant merchant = ModalRoute.of(context).settings.arguments;
    stores = Provider.of<LoyaltyCardProvider>(context).allBrandsForAddedCards;
    cardId = Provider.of<LoyaltyCardProvider>(context)
        .getCardIdForStoreName(merchant.brandName);

    return Scaffold(
      body: Builder(
        builder: (context) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height*0.95,
                child: Column(
                  children: [
                    //top content with Cancel and Done buttons
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Cancel button
                            Flexible(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: FittedBox(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Image Area
                            Flexible(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    if (_pickedImageFile == null &&
                                        merchant.brandName
                                            .toLowerCase()
                                            .contains('other'))
                                      Container(
                                        //width: MediaQuery.of(context).size.width * 0.35,
                                        color: Colors.black,
                                      )
                                    else
                                      Container(
                                        //width: MediaQuery.of(context).size.width * 0.35,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: (_pickedImageFile == null)
                                                ? Utilities.getImage(merchant.brandCardImage)// _getImage(merchant)
                                                : Image.network(_pickedImageUrl)
                                                    .image,
                                          ),
                                        ),
                                      ),
                                    if (_loading)
                                      Center(
                                          child: CircularProgressIndicator(
                                        backgroundColor: Colors.black,
                                      )),
                                  ],
                                )),
                            //Done button
                            Flexible(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: FittedBox(
                                  child: TextButton(
                                    onPressed: () => merchant.brandName
                                            .toLowerCase()
                                            .contains('other')
                                        ? _addNewLoyaltyCard(context)
                                        : _addLoyaltyCard(context, merchant),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'DONE',
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 4,
                      child: Column(
                        children: [
                          !merchant.brandName.toLowerCase().contains('other')
                              ? SizedBox(
                                  height: 10,
                                )
                              : _otherContent(context, stores),

                          //Enter Card Number
                          Container(
                            //margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                TextField(
                                  controller: _cardNumberController,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  //keyboardType: TextInputType.,
                                  decoration: InputDecoration(
                                    hintText: 'Enter card number',
                                    labelText: 'Card number',
                                    labelStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: _scanBarcodeNormal,
                                      icon: Image.asset(
                                          AppConstants.iconsFolder +
                                              'barcode.png'),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                _showError(_cardNumberError),
                              ],
                            ),
                          ),

                          //Label
                          Container(
                            padding: EdgeInsets.only(left: 40, right: 50),
                            alignment: Alignment.center,
                            child: Text(
                              'Enter the customer number printed on your card',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),

                    Expanded(
                      //Do not call and Do not mesage checkboxes
                      child: FittedBox(
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          //height: 100,
                          alignment: Alignment.topLeft,
                          //color: Colors.amberAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: _doNotCall,
                                      onChanged: (value) {
                                        setState(() {
                                          _doNotCall = !_doNotCall;
                                        });
                                      }),
                                  Text('Do not call'),
                                ],
                              ),
                              SizedBox(width: 50),
                              Row(
                                children: [
                                  Checkbox(
                                      value: _doNotMsg,
                                      onChanged: (value) {
                                        setState(() {
                                          _doNotMsg = !_doNotMsg;
                                          print(_doNotMsg);
                                        });
                                      }),
                                  Text('Do not Message'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  } //Build method

  _otherContent(BuildContext context, List<String> stores) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_pickedImageFile == null)
                  ? Container(
                      height: 50,
                      width: 70,
                      //color: Colors.black,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    )
                  : Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: Image.network(_pickedImageUrl).image,
                          //Image.file(File(_pickedImageFile.path)).image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              SizedBox(
                width: 20,
              ),
              Button(
                'ADD CARD',
                width: MediaQuery.of(context).size.width * 0.7,
                onPressed: () {
                  _showChoiceDialog(context);
                },
              ),
            ],
          ),
        ),

        //Enter Store Name
        Container(
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              TextField(
                controller: _storeNameController,
                style: TextStyle(
                  fontSize: 20,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Enter Store Name',
                  labelText: 'Store Name',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onChanged: (value) {
                  if (value.length < 4 && value.isNotEmpty) {
                    setState(() {
                      _storeNameError =
                          'Store name can not have less than 2 characters';
                    });
                  } else if (Utilities.listContainsValueIgnoreCase(
                      stores, value.trim())) {
                    setState(() {
                      _storeNameError = 'Store already added';
                    });
                  } else {
                    setState(() {
                      _storeNameError = '';
                    });
                  }
                },
              ),
              _showError(_storeNameError),
            ],
          ),
        ),
      ],
    );
  }

  Widget _showError(String errorText) {
    if (errorText != null && errorText.length > 0)
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerRight,
        child: Text(
          errorText,
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    else
      return Container(
        margin: EdgeInsets.only(bottom: 10),
      );
  }
}
