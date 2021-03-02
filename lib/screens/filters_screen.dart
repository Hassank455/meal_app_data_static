import 'package:flutter/material.dart';
import 'package:hf_meal_app/providers/language_provider.dart';
import 'package:hf_meal_app/providers/theme_provider.dart';
import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:hf_meal_app/providers/meal_provider.dart';

class FiltersScreen extends StatelessWidget {
  static const routeName = '/filters';

  bool fromOnBoarding;

  FiltersScreen({this.fromOnBoarding = false});

  Widget buildSwitchListTile(String title, String descreption,
      bool currentValue, Function updateValue, BuildContext ctx) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(descreption),
      onChanged: updateValue,
      inactiveTrackColor:
          Provider.of<ThemeProvider>(ctx, listen: true).tm == ThemeMode.light
              ? null
              : Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    final Map<String, bool> currentFilters =
        Provider.of<MealProvider>(context, listen: true).filters;
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              title: fromOnBoarding
                  ? null
                  : Text(lan.getTexts('filters_appBar_title')),
              backgroundColor: fromOnBoarding
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
              elevation: fromOnBoarding ? 0 : 5,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      lan.getTexts('filters_screen_title'),
                      style: Theme.of(context).textTheme.headline6,textAlign: TextAlign.center,
                    ),
                  ),

                        buildSwitchListTile(
                            lan.getTexts('Gluten-free'),
                            lan.getTexts('Gluten-free-sub'),
                            currentFilters['gluten'],
                                (newValue) {
                          currentFilters['gluten'] = newValue;
                          Provider.of<MealProvider>(context, listen: false)
                              .setFilters();
                        }, context),
                        buildSwitchListTile(
                            lan.getTexts('Lactose-free'),
                            lan.getTexts('Lactose-free_sub'),
                            currentFilters['lactose'], (newValue) {
                          currentFilters['lactose'] = newValue;

                          Provider.of<MealProvider>(context, listen: false)
                              .setFilters();
                        }, context),
                        buildSwitchListTile(
                            lan.getTexts('Vegetarian'),
                            lan.getTexts('Vegetarian-sub'),
                            currentFilters['vegetarian'], (newValue) {
                          currentFilters['vegetarian'] = newValue;

                          Provider.of<MealProvider>(context, listen: false)
                              .setFilters();
                        }, context),
                        buildSwitchListTile(
                            lan.getTexts('Vegan'),
                            lan.getTexts('Vegan-sub'),
                            currentFilters['vegan'], (newValue) {
                          currentFilters['vegan'] = newValue;

                          Provider.of<MealProvider>(context, listen: false)
                              .setFilters();
                        }, context),

                  SizedBox(
                    height: fromOnBoarding ? 80 : 0,
                  )
                ],
              ),
            ),
          ],
        ),
        drawer: fromOnBoarding ? null : MainDrawer(),
      ),
    );
  }
}
