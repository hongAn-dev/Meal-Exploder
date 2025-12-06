import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filters { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filters, bool>> {
  FiltersNotifier()
    : super({
        Filters.glutenFree: false,
        Filters.lactoseFree: false,
        Filters.vegetarian: false,
        Filters.vegan: false,
      });

  void setFilter(Filters filters, bool isActive) {
    state = {...state, filters: isActive};
  }

  void setFilters(Map<Filters, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filters, bool>>(
      (ref) => FiltersNotifier(),
    );

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFitler = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFitler[Filters.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFitler[Filters.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFitler[Filters.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFitler[Filters.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
