import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactHelper {
  static Future<void> sendViaWhatsAppOrEmail({
    required BuildContext context,
    required String whatsappNumber,
    required String emailId,
    String? hostName,
    String? hostId,
  }) async {
    // Show dialog to choose between WhatsApp and Email
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Text('Choose how you would like to contact support:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openWhatsApp(whatsappNumber, hostName: hostName, hostId: hostId);
              },
              child: const Text('WhatsApp'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _openEmail(emailId, hostName: hostName, hostId: hostId);
              },
              child: const Text('Email'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> openWhatsApp(String phoneNumber, {String? hostName, String? hostId}) async {
    String message = 'Hello, I need support';
    if (hostName != null && hostId != null) {
      message = 'Hello, I need support for Host: $hostName (ID: $hostId)';
    }
    
    final whatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    final uri = Uri.parse(whatsappUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  static Future<void> _openEmail(String email, {String? hostName, String? hostId}) async {
    String subject = 'Support Request';
    String body = 'Hello,\n\nI need support.';
    
    if (hostName != null && hostId != null) {
      subject = 'Support Request for Host: $hostName';
      body = 'Hello,\n\nI need support for Host: $hostName (ID: $hostId).\n\n';
    }
    
    final emailUrl = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    final uri = Uri.parse(emailUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch email';
    }
  }
}
