import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../services/provider/userProvider.dart';

class HomeHeader extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode? focusNode; // Adicionado para controlar o foco

  const HomeHeader({
    super.key,
    required this.searchController,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SliverAppBar(
      pinned: true,
      expandedHeight: 180.0,
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                Color(0xFF4CA078)
              ], // Verde Gradiente Clean
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
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: userProvider.userPhotoUrl != null
                          ? NetworkImage(userProvider.userPhotoUrl!)
                          : null,
                      child: userProvider.userPhotoUrl == null
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize:
            const Size.fromHeight(70), // Altura aumentada para estética
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08), // Sombra suave
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            focusNode: focusNode, // Conectando o foco
            style: const TextStyle(color: Color(0xFF2D3436)),
            decoration: InputDecoration(
              hintText: "Buscar conteúdo...",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon:
                  const Icon(Icons.search, color: AppTheme.primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => searchController.clear(),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
