// about_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('App Version'),
              subtitle: Text('1.0.0'), // Replace with your app version
            ),
            Divider(),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {
                _launchURL('https://yourprivacypolicyurl.com'); // Replace with your privacy policy URL
              },
            ),
            ListTile(
              title: Text('Terms of Service'),
              onTap: () {
                _launchURL('https://yourtermsofserviceurl.com'); // Replace with your terms of service URL
              },
            ),
            Divider(),
            ListTile(
              title: Text('Acknowledgments'),
              subtitle: Text(
                  'I would like to express our sincere gratitude to all the users of this application. Your support and feedback are invaluable to me.'),
            ),
            Divider(),
            ListTile(
              title: Text('Open Source'),
              subtitle: Text('This application is open source. You can view the source code and contribute to the project on GitHub.'),
              onTap: () {
                _launchURL('https://github.com/DanisAlfonso/gym_tracker'); // Replace with your GitHub repository URL
              },
            ),
            ListTile(
              title: Text('License'),
              subtitle: Text('This application is licensed under the MIT License.'),
              onTap: () {
                _launchURL('https://opensource.org/licenses/MIT'); // Replace with your license URL if different
              },
            ),
            Divider(),
            ListTile(
              title: Text('Contact Me'),
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
