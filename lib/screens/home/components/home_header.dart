import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../services/provider/userProvider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SliverAppBar(
      pinned: true,
      expandedHeight: 180.0,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, Color(0xFF4CA078)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olá, ${userProvider.userName?.split(' ')[0] ?? 'Prevencionista'}",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Segurança em primeiro lugar.",
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    backgroundImage: userProvider.userPhotoUrl != null
                        ? NetworkImage(userProvider.userPhotoUrl!)
                        : null,
                    child: userProvider.userPhotoUrl == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          height: 45,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 10),
              Text("Buscar conteúdo...",
                  style: TextStyle(color: Colors.grey[400])),
            ],
          ),
        ),
      ),
    );
  }
}
