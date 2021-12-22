import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lists and Grids'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    myShoppingList = shoppingList();
  }

  List<String> courses = [
    "Carrots",
    "Tomatoes",
    "Cherries",
    "Mango",
    "Dish washing liquid",
    "Soda",
    "Nutella",
    "Meat",
    "Fish",
    "Paper toilettes",
    "clothes wash",
    "Clorine",
    "Salad Sauce",
    "Olive Oil",
    "Toothbrush",
    "Bread",
    "Eggs",
    "Butter",
  ];

  List<Course> myShoppingList = [];

  List<Course> shoppingList() {
    List<Course> c = [];
    courses.forEach((element) {
      c.add(Course(element));
    });
    return c;
  }

  List<Widget> itemCourses() {
    List<Widget> items = [];
    for (var element in courses) {
      final widget = elementToShow(element);
      items.add(widget);
    }
    return items;
  }

  Widget elementToShow(String element) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(element),
              const Icon(Icons.check_box_outline_blank)
            ]));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    print(orientation);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (orientation == Orientation.portrait) ? simpleList() : grid(),
    );
  }

  Widget grid() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            child: Card(
              color: (myShoppingList[index].bought ? Colors.green : Colors.red),
              child: Center(
                child: Text(myShoppingList[index].element),
              ),
            ),
            onTap: () {
              setState(() => myShoppingList[index].update());
            });
      },
      itemCount: myShoppingList.length,
    );
  }

  Widget simpleList() {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(myShoppingList[index].element),
            child: tile(index),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                myShoppingList.removeAt(index);
              });
            },
            background: Container(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Spacer(),
                    Text("Swipe to delete"),
                  ],
                ),
                color: Colors.red[200]),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(color: Colors.indigoAccent, thickness: 1);
        },
        itemCount: myShoppingList.length);
  }

  Widget listSeparated() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
            key: Key(myShoppingList[index].element),
            child: tile(index),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() => myShoppingList.removeAt(index));
            },
            background: Container(
              padding: EdgeInsets.only(right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [Spacer(), Text("Swipe to delete")],
              ),
              color: Colors.redAccent,
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.indigoAccent,
          thickness: 1,
        );
      },
      itemCount: myShoppingList.length
    );
  }

  ListTile tile(int index) {
    return ListTile(
        title: Text(myShoppingList[index].element),
        leading: Text(index.toString()),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              myShoppingList[index].update();
            });
          },
          icon: Icon((myShoppingList[index].bought)
              ? Icons.check_box
              : Icons.check_box_outline_blank),
        ));
  }
}

class Course {
  String element;
  bool bought = false;

  Course(this.element);

  update() {
    bought = !bought;
  }
}
