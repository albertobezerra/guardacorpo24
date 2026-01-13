import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../services/provider/userProvider.dart';

class HomeHeader extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode? focusNode;

  const HomeHeader({
    super.key,
    required this.searchController,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Determina qual ícone/cor mostrar
    final bool hasPremium = userProvider.canAccessPremiumScreen();
    final bool hasAdFreeOnly = userProvider.isAdFree() && !hasPremium;
    final bool hasAnyBenefit = hasPremium || hasAdFreeOnly;

    // Define a cor do badge
    Color badgeColor;
    IconData badgeIcon;

    if (hasPremium) {
      badgeColor = const Color(0xFFFFC107); // Dourado para Premium
      badgeIcon = Icons.workspace_premium;
    } else if (hasAdFreeOnly) {
      badgeColor = const Color(0xFF4CAF50); // Verde para Ad-Free
      badgeIcon = Icons.remove_circle_outline;
    } else {
      badgeColor = Colors.transparent;
      badgeIcon = Icons.star; // Não será mostrado
    }

    return SliverAppBar(
      pinned: true,
      expandedHeight: 180.0,
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Segurança em primeiro lugar.",
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  // ✅ AVATAR COM BADGE E NAVEGAÇÃO PARA PERFIL
                  GestureDetector(
                    onTap: () {
                      // Navega para a tela de perfil (índice 2 do NavStation)
                      DefaultTabController.of(context).animateTo(2);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: userProvider.userPhotoUrl != null
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: userProvider.userPhotoUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppTheme.primaryColor,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 24,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.person,
                                    color: Colors.grey, size: 24),
                          ),
                        ),

                        // ✅ BADGE INDICADOR DE BENEFÍCIO ATIVO
                        if (hasAnyBenefit)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                badgeIcon,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            focusNode: focusNode,
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
