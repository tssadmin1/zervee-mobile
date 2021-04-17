import '../models/constants.dart';
import '../widgets/compound/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'merchant_list.dart';

class ShowWebView extends StatelessWidget {
  static const String routeName = '/showWebView';

  @override
  Widget build(BuildContext context) {
    String url = ModalRoute.of(context).settings.arguments;
    print('-------------WebView Build method-----------1');
    print('-------------WebView Build method-----------2');
    print('-------------WebView Build method-----------3');
    if (url == null || url.isEmpty)
      return Scaffold(
        body: Center(
          child: Text('Please provide a URL'),
        ),
      );
    return SafeArea(
      child: WebviewScaffold(
        url: url,
        appBar: AppBar(
          backgroundColor: AppConstants.themeColorShade3,
        ),
        bottomNavigationBar: ZerveeBottonNavigationBar(
          selectedIndex: 5,
          onAddPressed: () =>
              Navigator.of(context).pushNamed(MerchantList.routeName),
        ),
        initialChild: null,
      ),
    );
  }
}