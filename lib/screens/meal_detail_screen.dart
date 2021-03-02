import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hf_meal_app/dummy_data.dart';
import 'package:hf_meal_app/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:hf_meal_app/providers/meal_provider.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = 'meal_detail';

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mealId = ModalRoute.of(context).settings.arguments
        as String; //استقبال ال id من شاشة meal item
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    var accentColor = Theme.of(context).accentColor;

    List<String> stepsLi = lan.getTexts('steps-$mealId') as List<String>;
    var liSteps = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('# ${index + 1}'),
            ),
            title: Text(stepsLi[index], style: TextStyle(color: Colors.black)),
          ),
          Divider(),
        ],
      ),
      itemCount: stepsLi.length,
    );
    List<String> liIngredientLi =
        lan.getTexts('ingredients-$mealId') as List<String>;
    var liIngredients = ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Card(
        color: accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            //selectedMeal.ingredients[index],
            liIngredientLi[index],
            style: TextStyle(
                color: useWhiteForeground(accentColor)
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
      itemCount: liIngredientLi.length,
    );

    Widget buildContainer(Widget child) {
      bool isLandscape =
          MediaQuery.of(context).orientation == Orientation.landscape;
      var dw = MediaQuery.of(context).size.width;
      var dh = MediaQuery.of(context).size.height;
      return Container(
        decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        height: isLandscape ? dh * 0.5 : dh * 0.25,
        width: isLandscape ? (dw * 0.5 - 30) : dw,
        child: child,
      );
    }

    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            //يدعم السكرول تلقائيا
            SliverAppBar(
              expandedHeight: 300,
              pinned: true, // اذا وضعت false  يختفي الاب بار عند السكرول
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(lan.getTexts('meal-$mealId')),
                background: Hero(
                  tag: mealId,
                  child: InteractiveViewer(
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/a2.png'),
                      fit: BoxFit.cover,
                      image: NetworkImage(selectedMeal.imageUrl),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (isLandscape) Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            buildSectionTitle(context, "Ingredients"),
                            buildContainer(liIngredients),
                          ],
                        ),
                        Column(
                          children: [
                            buildSectionTitle(context, 'Steps'),
                            buildContainer(liSteps),
                          ],
                        ),
                      ],
                    ),
                  if (!isLandscape) buildSectionTitle(context, "Ingredients"),
                  if (!isLandscape) buildContainer(liIngredients),
                  if (!isLandscape) buildSectionTitle(context, 'Steps'),
                  if (!isLandscape) buildContainer(liSteps),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Provider.of<MealProvider>(context, listen: false)
              .toggleFavorite(mealId),
          child: Icon(Provider.of<MealProvider>(context, listen: true)
                  .isMealFavortie(mealId)
              ? Icons.star
              : Icons.star_border),
        ),
      ),
    );
  }
}
