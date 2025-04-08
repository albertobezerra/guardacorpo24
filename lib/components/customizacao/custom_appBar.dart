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
  Size get preferredSize {
    // Não podemos usar MediaQuery aqui diretamente porque context não está disponível
    // Vamos definir uma altura base e ajustá-la no build
    return const Size.fromHeight(160); // Altura inicial fixa
  }

  @override
  Widget build(BuildContext context) {
    // Calcula a altura responsiva (20% da altura da tela, entre 120 e 200)
    final double appBarHeight =
        (MediaQuery.of(context).size.height * 0.2).clamp(120.0, 200.0);
    // Calcula o tamanho do texto baseado na largura da tela
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = (screenWidth * 0.04).clamp(14.0, 18.0);

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
        maxLines: 2, // Permite quebra de linha
        overflow: TextOverflow.ellipsis, // Adiciona "..." se cortar
      ),
      //centerTitle: true, // Centraliza o título
      leading: onLeadingPressed != null
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: onLeadingPressed,
            )
          : null,
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
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
