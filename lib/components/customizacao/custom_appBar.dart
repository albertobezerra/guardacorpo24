import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed; // Ação do botão "Voltar"
  final String? backgroundImageAsset; // Imagem de fundo (opcional)
  final Color textColor; // Cor do texto (personalizável)
  final bool enableShadow; // Ativar sombra no texto para legibilidade

  const CustomAppBar({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.backgroundImageAsset,
    this.textColor = Colors.white,
    this.enableShadow = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(160); // Altura base

  @override
  Widget build(BuildContext context) {
    final double appBarHeight =
        (MediaQuery.of(context).size.height * 0.2).clamp(120.0, 200.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = (screenWidth * 0.12).clamp(14.0, 20.0);

    return AppBar(
      toolbarHeight: appBarHeight,
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Segoe Bold',
          color: textColor,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      flexibleSpace: backgroundImageAsset != null
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImageAsset!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : null,
      elevation: 0,
    );
  }
}
