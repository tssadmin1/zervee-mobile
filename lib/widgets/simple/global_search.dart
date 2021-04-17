import '../../models/auth_provider.dart';
import '../../models/constants.dart';
import '../../screens/item_details.dart';

import '../../providers/item_provider.dart';
import '../../providers/loyalty_card_provider.dart';
import '../../screens/brand_details.dart';
import '../../utilities/utilities.dart';
import 'package:flutter/material.dart';

class GlobalSearch extends SearchDelegate<String> {
  String searchQuery = '';
  final LoyaltyCardProvider cardController;
  final ItemProvider itemController;
  GlobalSearch({this.cardController, this.itemController});
  bool isSearchResultEmpty = true;
  @override
  String get searchFieldLabel => 'Search any...';

  @override
  TextStyle get searchFieldStyle => TextStyle(fontSize: 15);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResult(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResult(context);
  }

  List<Widget> showMatchingCards(BuildContext context, String search) {
    var matchingCards = cardController.search(search);
    if (matchingCards.isNotEmpty)
      return cardController
          .search(search)
          .map(
            (e) => Container(
              margin: EdgeInsets.all(5.0),
              child: ListTile(
                leading: Image(
                  image: Utilities.getImage(e.cardImage),
                  height: 50,
                  width: 50,
                ),
                title: Text(
                  e.brandId,
                ),
                onTap: () => {
                  Navigator.of(context)
                      .pushNamed(BrandDetails.routeName, arguments: e),
                },
              ),
            ),
          )
          .toList();
    else
      return [Container()];
  }

  Widget _buildResult(BuildContext context) {
    return SingleChildScrollView(
        child: AuthProvider.isLoggedIn
            ? Column(
                children: [
                  Container(),
                  if (query.isNotEmpty && query.length > 1 )
                    Column(
                      children: [
                        if (cardController.search(query).isNotEmpty)
                          ...cardController.search(query).map(
                                (e) => Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: ListTile(
                                    leading: Image(
                                      image: Utilities.getImage(e.cardImage),
                                      height: 50,
                                      width: 50,
                                    ),
                                    title: Text(
                                      e.cardName,
                                    ),
                                    trailing: Card(
                                      color: AppConstants.themeColorShade1,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          'Card',
                                        ),
                                      ),
                                    ),
                                    onTap: () => {
                                      Navigator.of(context).pushNamed(
                                          BrandDetails.routeName,
                                          arguments: e),
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  if (query.isNotEmpty && query.length > 1 )
                    Column(
                      children: [
                        if (itemController.search(query).isNotEmpty)
                          ...itemController.search(query).map(
                                (e) => Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: ListTile(
                                    leading: Image(
                                      image: Utilities.getImage(
                                          e.itemImages.first),
                                      height: 50,
                                      width: 50,
                                    ),
                                    title: Text(
                                      e.itemName,
                                    ),
                                    trailing: Card(
                                      color: AppConstants.themeColorShade3,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          'Item',
                                        ),
                                      ),
                                    ),
                                    onTap: () => {
                                      Navigator.of(context).pushNamed(
                                          ItemDetails.routeName,
                                          arguments: e),
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  if(query.isNotEmpty && query.length > 1)
                    if(itemController.search(query).isEmpty && cardController.search(query).isEmpty)
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(18.0),
                        child: Text('No match found'),
                      ),
                ],
              )
            : Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text('User is not logged in'),
              ));
  }
}
