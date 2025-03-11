import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/core/constants/app_colors.dart';

class SpotifyDebugView extends StatelessWidget {
  final String clientId;
  final String clientSecret;

  const SpotifyDebugView({
    Key? key,
    required this.clientId,
    required this.clientSecret,
  }) : super(key: key);

  Future<Map<String, dynamic>> testSpotifyConnection() async {
    try {
      // Test token acquisition
      final tokenResponse = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
        },
      );

      if (tokenResponse.statusCode != 200) {
        return {
          'success': false,
          'stage': 'token',
          'status': tokenResponse.statusCode,
          'body': tokenResponse.body,
        };
      }

      final token = json.decode(tokenResponse.body)['access_token'];

      // Test API access
      final playlistsResponse = await http.get(
        Uri.parse('https://api.spotify.com/v1/search?q=sleep&type=playlist&limit=1'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return {
        'success': playlistsResponse.statusCode == 200,
        'stage': 'api',
        'status': playlistsResponse.statusCode,
        'body': playlistsResponse.body,
      };
    } catch (e) {
      return {
        'success': false,
        'stage': 'error',
        'error': e.toString(),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Debug'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spotify Credentials:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Client ID: ${clientId.substring(0, 5)}...'),
            Text('Client Secret: ${clientSecret.substring(0, 5)}...'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await testSpotifyConnection();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(result['success'] ? 'Success' : 'Error'),
                    content: SingleChildScrollView(
                      child: Text(
                        json.encode(result),
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Test Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
