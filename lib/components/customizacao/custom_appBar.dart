import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed; // Ação do botão "Voltar"
  final String? backgroundImageAsset; // Imagem de fundo (opcional)

  const CustomAppBar({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.backgroundImageAsset,
  });

  @override
  Size get preferredSize => const Size.fromHeight(200);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        toolbarHeight: 200,
        title: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Segoe Bold',
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        leading: onLeadingPressed != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onLeadingPressed,
              )
            : null,
        flexibleSpace: backgroundImageAsset != null
            ? Image(
                image: AssetImage(backgroundImageAsset!),
                fit: BoxFit.cover,
              )
            : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
