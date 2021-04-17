import 'package:flutter/material.dart';

class CountryProvider with ChangeNotifier {
  List<Country> _countries = [
    Country(image: 'Australia.png', name: 'Australia', isSelected: false),
    Country(image: 'Austria.png', name: 'Austria', isSelected: false),
    Country(image: 'Belgium.png', name: 'Belgium', isSelected: false),
    Country(image: 'Brazil.png', name: 'Brazil', isSelected: false),
    Country(image: 'Bulgaria.png', name: 'Bulgaria', isSelected: false),
    Country(image: 'Canada.png', name: 'Canada', isSelected: false),
    Country(image: 'China.png', name: 'China', isSelected: false),
    Country(image: 'Croatia.png', name: 'Croatia', isSelected: false),
    Country(image: 'CzechRepublic.png', name: 'Czech Republic', isSelected: false),
    Country(image: 'Denmark.png', name: 'Denmark', isSelected: false),
    Country(image: 'Finland.png', name: 'Finland', isSelected: false),
    Country(image: 'France.png', name: 'France', isSelected: false),
    Country(image: 'Germany.png', name: 'Germany', isSelected: false),
    Country(image: 'Greece.png', name: 'Greece', isSelected: false),
    Country(image: 'HongKong.png', name: 'Hong Kong', isSelected: false),
    Country(image: 'Hungary.png', name: 'Hungary', isSelected: false),
    Country(image: 'India.png', name: 'India', isSelected: false),
    Country(image: 'Indonesia.png', name: 'Indonesia', isSelected: false),
    Country(image: 'Ireland.png', name: 'Ireland', isSelected: false),
    Country(image: 'Israel.png', name: 'Israel', isSelected: false),
    Country(image: 'Italy.png', name: 'Italy', isSelected: false),
    Country(image: 'Japan.png', name: 'Japan', isSelected: false),
    Country(image: 'Korea.png', name: 'Korea', isSelected: false),
    Country(image: 'Luxembourg.png', name: 'Luxembourg', isSelected: false),
    Country(image: 'Mexico.png', name: 'Mexico', isSelected: false),
    Country(image: 'Netherlands.png', name: 'Netherlands', isSelected: false),
    Country(image: 'NewZealand.png', name: 'New Zealand', isSelected: false),
    Country(image: 'Norway.png', name: 'Norway', isSelected: false),
    Country(image: 'Poland.png', name: 'Poland', isSelected: false),
    Country(image: 'Portugal.png', name: 'Portugal', isSelected: false),
    Country(image: 'Romania.png', name: 'Romania', isSelected: false),
    Country(image: 'Russia.png', name: 'Russia', isSelected: false),
    Country(image: 'Singapore.png', name: 'Singapore', isSelected: false),
    Country(image: 'Slovakia.png', name: 'Slovakia', isSelected: false),
    Country(image: 'Slovenia.png', name: 'Slovenia', isSelected: false),
    Country(image: 'SouthAfrica.png', name: 'South Africa', isSelected: false),
    Country(image: 'Spain.png', name: 'Spain', isSelected: false),
    Country(image: 'Sweden.png', name: 'Sweden', isSelected: false),
    Country(image: 'Switzerland.png', name: 'Switzerland', isSelected: false),
    Country(image: 'Taiwan.png', name: 'Taiwan', isSelected: false),
    Country(image: 'Thailand.png', name: 'Thailand', isSelected: false),
    Country(image: 'Turkey.png', name: 'Turkey', isSelected: false),
    Country(image: 'Ukraine.png', name: 'Ukraine', isSelected: false),
    Country(image: 'uk.png', name: 'United Kingdom', isSelected: false),
    Country(image: 'USA.png', name: 'United States', isSelected: false),
  ];

  //List<Country> _countries = countriesList.toList();

  List<Country> get countries {
    var temp = [..._countries];
    //temp.sort((c1, c2) => c1.isSelected==c2.isSelected);

    var temp2 = temp.where((element) => element.isSelected).toList();
    temp2.addAll(temp.where((element) => !element.isSelected).toList());
    Set<Country> t = new Set();
    t.addAll(temp2);
    return t.toList();
  }

  void selectCountry(String countryName) {
    Country c = _countries.firstWhere((element) => element.name == countryName);
    int index = _countries.indexOf(c);
    //_countries.remove(c);
    c.isSelected = true;
    _countries.replaceRange(index, index, [c]);
    notifyListeners();
  }

  void untickCountry(String countryName) {
    Country c = _countries.firstWhere((element) => element.name == countryName);
    int index = _countries.indexOf(c);
    //_countries.remove(c);
    c.isSelected = false;
    _countries.replaceRange(index, index, [c]);
    notifyListeners();
  }
  

  List<String> get selectedCountries {
    var temp = _countries.where((element) => element.isSelected).toList();
    var temp2 = new Set<Country>();
    temp2.addAll(temp);
    return temp2.toList().map((e) => e.name).toList();
  }
}

class Country {
  String image;
  String name;
  bool isSelected;

  Country({this.image, this.name, this.isSelected});
}
