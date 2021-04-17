import '../widgets/compound/add_Files.dart';

import '../screens/merchant_list.dart';
import '../providers/item_provider.dart';
import '../providers/user_info_provider.dart';
import '../screens/item_details.dart';
import '../widgets/compound/dialogs.dart';

import '../models/card_item.dart';
import 'package:provider/provider.dart';
import '../widgets/simple/dropdown.dart';
import '../providers/loyalty_card_provider.dart';
import '../utilities/utilities.dart';
import '../widgets/compound/add_images.dart';
import '../widgets/simple/settings_button.dart';
import '../widgets/simple/button.dart';
import '../models/constants.dart';
import '../widgets/simple/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddItem extends StatefulWidget {
  static const routeName = '/AddItem';
  @override
  State<StatefulWidget> createState() {
    return _AddItemState();
  }
}

class _AddItemState extends State<AddItem> {
  //CardItem item;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<String> _images = [];
  List<String> _proofsImages = [];
  bool _isAddNewItem = true;
  String _pageTitle = 'New Item';
  var _productNameController = TextEditingController();
  var _purchaseDateController = TextEditingController();
  var _serialNumberController = TextEditingController();
  var _brandNameController = TextEditingController();
  var _warrantyEndDateController = TextEditingController();
  var _priceController = TextEditingController();
  var _productNameError = '';
  var _serialNumberError = '';
  CardItem oldItem;

  @override
  void initState() {
    if (Provider.of<LoyaltyCardProvider>(context, listen: false)
        .loyaltyCards
        .isEmpty) {
      Utilities.showToastMessage('Please add a Card first');
      Future.delayed(Duration.zero).then((value) =>
          Navigator.of(context).pushReplacementNamed(MerchantList.routeName));
    }

    super.initState();
  }

  @override
  void dispose() {
    print('Add item dispose...');
    _productNameController.dispose();
    _purchaseDateController.dispose();
    _serialNumberController.dispose();
    _brandNameController.dispose();
    _warrantyEndDateController.dispose();
    _images = [];
    _proofsImages = [];
    super.dispose();
  }

  _selectDate(
    TextEditingController controller, {
    DateTime initialDate,
    DateTime endDate,
  }) {
    Utilities.datePicker(
      context,
      endDate: endDate != null
          ? endDate
          : DateTime.now().add(Duration(days: 365 * 99)),
      initialDate: initialDate != null
          ? initialDate
          : DateTime.now().subtract(Duration(days: 365 * 99)),
    ).then((value) {
      if (value != null) {
        setState(() {
          controller.text = DateFormat(AppConstants.dateFormat).format(value);
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context).settings.arguments != null) {
      var args = ModalRoute.of(context).settings.arguments;
      if (args is CardItem) {
        _isAddNewItem = false;
        _pageTitle = 'Edit Item';
        CardItem item = args;
        oldItem = item;
        _serialNumberController.text = item.serialNumber.toString();
        _images = [...item.itemImages];
        _productNameController.text = item.itemName.toString();
        _purchaseDateController.text = item.purchaseDate.toString();
        _warrantyEndDateController.text = item.warrantyEndDate.toString();
        _priceController.text = item.price.toString();
        _brandNameController.text = Provider.of<LoyaltyCardProvider>(context)
            .getBrandNameForCardId(item.cardId);
        _proofsImages = [...item.proofOfPurchaseFiles];
      }
      if (args is String) {
        print('Argument : $args');
        _brandNameController.text = Provider.of<LoyaltyCardProvider>(context)
            .getBrandNameForCardId(args);
      }
    }

    super.didChangeDependencies();
  }

  void addNewItem(BuildContext context) async {
    //var item = CardItem();
    Dialogs.showLoadingDialog(context, _keyLoader);
    var cardId = Provider.of<LoyaltyCardProvider>(context, listen: false)
        .getCardIdForStoreName(_brandNameController.text.trim());
    var itemName = _productNameController.text.trim();
    var purchaseDate = _purchaseDateController.text.trim();
    var price = _priceController.text.trim();
    String serialNumber = _serialNumberController.text.trim();
    String userName = UserInfoProvider.userInfo.username;
    List<String> itemImages = [..._images];
    //_images.map((e) => Utilities.imageToBase64String(e)).toList();
    List<String> proofOfPurchaseFiles = [..._proofsImages];
    //_proofsImages.map((e) => Utilities.imageToBase64String(e)).toList();
    //String itemId;
    String status = 'InWarranty';
    String warrantyStartDate = _purchaseDateController.text.trim();
    String warrantyEndDate = _warrantyEndDateController.text.trim();

    var item = CardItem(
      cardId: cardId,
      itemId: oldItem != null ? oldItem.itemId : null,
      itemImages: itemImages,
      itemName: itemName,
      price: price,
      proofOfPurchaseFiles: proofOfPurchaseFiles,
      purchaseDate: purchaseDate,
      serialNumber: serialNumber,
      status: status,
      userName: userName,
      warrantyEndDate: warrantyEndDate,
      warrantyStartDate: warrantyStartDate,
    );
    debugPrint('----------------------');
    debugPrint(cardItemToJson(item));
    debugPrint('-----------------------');

    var itemController = Provider.of<ItemProvider>(context, listen: false);
    var res = _isAddNewItem
        ? await itemController.addNewItemOnRemote(item)
        : await itemController.editItemOnRemote(item);
    if (res != null) {
      print('Item Added successfully');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.of(context)
          .popAndPushNamed(ItemDetails.routeName, arguments: res);
    } else {
      print('Something went wrong while adding new item');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ShowValidationMessage.showMessage(
          context, 'Something went wrong while adding new item');
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    var cardController =
        Provider.of<LoyaltyCardProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () => showDialog(
          context: context,
          builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('You will loose your changes?'),
                actions: [
                  TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(c, false);
                        Navigator.pop(context);
                      }),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              )),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstants.primaryColor),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            _pageTitle,
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            SettingsButton(),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () =>
                  FocusScope.of(context).requestFocus(new FocusNode()),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      myLabel('Brand*'),
                      _isAddNewItem
                          ? DropDown(
                              controller: _brandNameController,
                              hint: Text(
                                'Select Brand',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              options:
                                  cardController.allBrandsForAddedCards,
                              selectedValue: _brandNameController.text,
                            )
                          : CustomTextField(
                              controller: _brandNameController,
                              //hintText: 'Select Brand',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              disabled: true,
                            ),
                      myLabel('Product/Service Name*'),
                      CustomTextField(
                        controller: _productNameController,
                        hintText: 'Enter Product Name',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        errorText: _productNameError,
                        onChanged: (value) {
                          setState(() {
                            if (value.length < 4 && value.isNotEmpty)
                              _productNameError =
                                  'Product name can not have less than 4 characters';
                            else
                              _productNameError = '';
                          });
                        },
                      ),
                      myLabel('Upload Image'),
                      AddImages(_images),
                      myLabel('Date of Purchase/Service*'),
                      CustomTextField(
                        hintText: 'Select date of purchase',
                        controller: _purchaseDateController,
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        disabled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.date_range,
                            color: AppConstants.primaryMaterialColor,
                          ),
                          onPressed: () => _selectDate(
                              _purchaseDateController,
                              endDate: DateTime.now()),
                        ),
                      ),
                      myLabel('Serial Number'),
                      CustomTextField(
                        controller: _serialNumberController,
                        hintText: 'Please fill in the serial number here',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        errorText: _serialNumberError,
                        onChanged: (value) {
                          setState(() {
                            if (value.length < 4 && value.isNotEmpty)
                              _serialNumberError =
                                  'Serial Number can not have less than 4 characters';
                            else
                              _serialNumberError = '';
                          });
                        },
                      ),
                      myLabel('Price'),
                      CustomTextField(
                        hintText: 'Enter Price',
                        controller: _priceController,
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        disabled: false,
                      ),
                      myLabel('Warranty - Expiry Date'),
                      CustomTextField(
                        hintText: 'select warranty end date',
                        controller: _warrantyEndDateController,
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        disabled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.date_range,
                            color: AppConstants.primaryMaterialColor,
                          ),
                          onPressed: () =>
                              _selectDate(_warrantyEndDateController),
                        ),
                      ),
                      myLabel('Upload Invoice and Proof of Purchase'),
                      AddFiles(_proofsImages),
                      SizedBox(
                        height: 30,
                      ),
                      Button(
                        'Submit',
                        width: 200,
                        onPressed: () {
                          print(_images);
                          print(_proofsImages);
                          _submitForm(context);
                        },
                      ),
                      SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myLabel(String label) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 5,
        top: 5,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          color: AppConstants.themeColorShade1,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    //Show validation message when any of the fields is empty
    if (!_showValidationMessageOnSubmit(context)) return;

    _isAddNewItem ? print('New item being added...') : print('Editing item...');
    addNewItem(context);
  }

  bool _showValidationMessageOnSubmit(BuildContext context) {
    if (_brandNameController.text.trim().isEmpty) {
      ShowValidationMessage.showMessage(context, 'Please select a brand');
      return false;
    }

    if (_productNameController.text.trim().isEmpty) {
      ShowValidationMessage.showMessage(context, 'Product Name field is empty');
      return false;
    }
    if (_purchaseDateController.text.trim().isEmpty) {
      ShowValidationMessage.showMessage(
          context, 'Purchase Date field is empty');
      return false;
    }

    if (_productNameError.isNotEmpty || _serialNumberError.isNotEmpty) {
      ShowValidationMessage.showMessage(context, 'Please check above errors');
      return false;
    }

    return true;
  }
}
