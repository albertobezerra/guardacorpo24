import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';

class ModernListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Widget? trailing; // ADICIONADO: Para o botão de favorito

  const ModernListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black,
    this.badgeText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Badge Verde
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: badgeText != null
                        ? Text(
                            badgeText!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Icon(icon, color: AppTheme.primaryColor, size: 24),
                  ),
                ),

                const SizedBox(width: 16),

                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize:
                              14, // Ajustei levemente para caber títulos longos
                          color: const Color(0xFF2D3436),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Se não tiver subtítulo relevante, podemos ocultar ou mostrar algo padrão
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ],
                  ),
                ),

                // Ação (Favorito ou Seta)
                if (trailing != null)
                  trailing!
                else
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
