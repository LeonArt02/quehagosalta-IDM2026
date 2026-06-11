import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/core/utils/icon_mapper.dart';
import 'package:quehagosalta/features/map/data/providers/category_provider.dart';
import 'category_button.dart';

class TopBarWidget extends StatefulWidget {
  const TopBarWidget({super.key});

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CategoryProvider>().loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.categories.isEmpty)
              const SizedBox.shrink() // No dibuja nada si está vacío
            else
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];

                    // Instanciamos tu componente atómico pasándole la info mapeada
                    return CategoryButton(
                      name: category.name,
                      icon: category.icon_key.toIcon(),
                      //onTap: () {
                      //debugPrint('Filtro activo: ${category.name}');
                      // Hito 2: Acá llamarás al provider de locales para filtrar en el mapa

                      //},
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
