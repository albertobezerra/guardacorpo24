import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/screens/home/components/home_header.dart';
import 'package:guarda_corpo_2024/screens/home/components/quick_access_section.dart';
import 'package:guarda_corpo_2024/screens/home/components/safety_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  // Função para limpar a busca
  void _clearSearch() {
    _searchController.clear();
    _unfocus(); // Garante que o teclado feche também
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            HomeHeader(
              searchController: _searchController,
              focusNode: _searchFocusNode,
            ),
            if (_searchQuery.isEmpty) const QuickAccessSection(),
            SafetyList(
              searchQuery: _searchQuery,
              onItemTap: _unfocus,
              onSearchClear: _clearSearch, // AQUI: Passamos a função de limpeza
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
