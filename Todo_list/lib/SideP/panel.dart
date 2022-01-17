import 'package:flutter/material.dart';
import 'package:fluttertodolistsqfliteapp/screens/categories.dart';
import 'package:fluttertodolistsqfliteapp/screens/home.dart';
import 'package:fluttertodolistsqfliteapp/screens/search.dart';
import 'package:fluttertodolistsqfliteapp/screens/tdbycat.dart';
import 'package:fluttertodolistsqfliteapp/services/cat_S.dart';

class DrawerNavigaton extends StatefulWidget {
  @override
  _DrawerNavigatonState createState() => _DrawerNavigatonState();
}

class _DrawerNavigatonState extends State<DrawerNavigaton> {
  List<Widget> _categoryList = List<Widget>();

  CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TodosByCategory(category: category['name'],))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(

              accountName: Text('Flutter - Todo App'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Search())),
            ),
            ListTile(
              leading: Icon(Icons.done_outline_sharp),
              title: Text('Completed'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            ListTile(
              leading: Icon(Icons.pending),
              title: Text('Pending'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Expired'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Divider(),

          ],
        ),
      ),
    );
  }
}
