import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class DdsBase extends StatefulWidget {
  final String title;
  final String content;
  const DdsBase({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  DdsBaseState createState() => DdsBaseState();
}

class DdsBaseState extends State<DdsBase> {
  final Color primaryColor = const Color(0xFF006837);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Detalhes DDS".toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.content,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
