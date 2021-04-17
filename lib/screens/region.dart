import '../utilities/utilities.dart';

import '../providers/country_provider.dart';
import '../models/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Region extends StatefulWidget {
  static const routeName = '/Region';
  @override
  _RegionState createState() => _RegionState();
}

class _RegionState extends State<Region> {
  @override
  void initState() {
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    if (countryProvider.selectedCountries.isEmpty)
      Utilities.getCurrentCountry().then((value) {
        countryProvider.selectCountry(value);
      });
    super.initState();
  }

  Future<bool> showErrorMessage() async {
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    if (countryProvider.selectedCountries.isEmpty) {
      await Utilities.showToastMessage('Please select at least one region');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showErrorMessage,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppConstants.primaryColor),
          title: Text(
            'Choose a Region',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        body: SafeArea(
          child: Consumer<CountryProvider>(
            builder: (context, countryProvider, child) => ListView.builder(
              itemCount: countryProvider.countries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: countryProvider.countries[index].image.isEmpty
                        ? null
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.asset(
                                    AppConstants.iconsFolder +
                                        'flags/' +
                                        countryProvider.countries[index].image,
                                  ).image),
                            ),
                          ),
                  ),
                  title: Text(
                    countryProvider.countries[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Checkbox(
                    value: countryProvider.countries[index].isSelected,
                    onChanged: (value) {
                      value
                          ? countryProvider.selectCountry(
                              countryProvider.countries[index].name)
                          : countryProvider.untickCountry(
                              countryProvider.countries[index].name);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}