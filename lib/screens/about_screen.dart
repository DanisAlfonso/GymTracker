import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('about')), // Use localized string
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(appLocalizations.translate('app_version')),
              subtitle: Text('1.0.0'), // Replace with your app version
            ),
            Divider(),
            ListTile(
              title: Text(appLocalizations.translate('privacy_policy')),
              onTap: () {
                _launchURL('https://yourprivacypolicyurl.com'); // Replace with your privacy policy URL
              },
            ),
            ListTile(
              title: Text(appLocalizations.translate('terms_of_service')),
              onTap: () {
                _launchURL('https://yourtermsofserviceurl.com'); // Replace with your terms of service URL
              },
            ),
            Divider(),
            ListTile(
              title: Text(appLocalizations.translate('acknowledgments')),
              subtitle: Text(
                  appLocalizations.translate('acknowledgments_text')),
            ),
            Divider(),
            ListTile(
              title: Text(appLocalizations.translate('open_source')),
              subtitle: Text(appLocalizations.translate('open_source_text')),
              onTap: () {
                _launchURL('https://github.com/DanisAlfonso/gym_tracker'); // Replace with your GitHub repository URL
              },
            ),
            ListTile(
              title: Text(appLocalizations.translate('license')),
              subtitle: Text(appLocalizations.translate('license_text')),
              onTap: () {
                _launchURL('https://opensource.org/licenses/MIT'); // Replace with your license URL if different
              },
            ),
            Divider(),
            ListTile(
              title: Text(appLocalizations.translate('contact_me')),
              subtitle: Text('danis.ramirez.hn@gmail.com'), // Replace with your contact email
              onTap: () {
                _launchURL('mailto:danis.ramirez.hn@gmail.com'); // Replace with your contact email
              },
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
