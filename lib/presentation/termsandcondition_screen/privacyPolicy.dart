import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/App_Text/App_Text.dart';
import 'package:html/dom.dart' as html;

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String _description = 'Loading...';

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://dsrummy.whitelabelexchanges.com/v1/user/getPrivacysPolicy'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final description = jsonData['data'][0]['description']; // Extract description from data
      setState(() {
        _description = description; // Update the state with the fetched description.
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget initializes.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          'Privacy Policy',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ColorConstant.white,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: ColorConstant.apptheme,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _description != 'Loading...'
              ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Html(
                data: _description,
                onLinkTap: (String? url, Map<String, String> attrs, html.Element? element) {
                  // Handle tap on anchor link
                  if (url != null && url.isNotEmpty) {
                    launch(url);
                  }
                },
              ),
            ),
          )
              : Center(
            child: CircularProgressIndicator(
              color: ColorConstant.apptheme,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PrivacyPolicy(),
  ));
}