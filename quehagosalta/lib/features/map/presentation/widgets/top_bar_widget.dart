import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/core/utils/icon_mapper.dart';
import 'package:quehagosalta/features/map/data/providers/category_provider.dart';
import 'package:quehagosalta/features/users/widgets/userAvatarWidget.dart';
import 'category_button.dart';
import 'package:quehagosalta/features/map/data/providers/business_provider.dart';

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
    final categoryProvider = context.watch<CategoryProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final selectedCategoryId = businessProvider.selectedCategoryId;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (categoryProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (categoryProvider.categories.isEmpty)
              const SizedBox.shrink() // No dibuja nada si está vacío
            else
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CategoryButton(
                        name: 'Todos',
                        icon: Icons.category,
                        isSelected: selectedCategoryId == null,
                        onTap: () => businessProvider.setCategoryFilter(null),
                      );
                    }

                    final category = categoryProvider.categories[index - 1];
                    return CategoryButton(
                      name: category.name,
                      icon: category.icon_key.toIcon(),
                      isSelected: category.id == selectedCategoryId,
                      onTap: () =>
                          businessProvider.setCategoryFilter(category.id),
                    );
                  },
                ),
              ),
            const UserAvatarButton(),
          ],
        ),
      ),
    );
  }
}

/*
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

                      //},
                    );
                  },
                ),
              ),
            const UserAvatarButton(),
          ],
        ),
      ),
    );
  }
}
*/
