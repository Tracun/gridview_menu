# Gridview Menu

package for creating a menu in grid view.

## Screenshots

GridView             |  ListView
:-------------------------:|:-------------------------:
![GridView](https://github.com/Tracun/gridview_menu/blob/main/images/Grid1.png?raw=true)  |  ![ListView](https://github.com/Tracun/gridview_menu/blob/main/images/listGrid.png?raw=true)

## Example

### HomeWidget.dart

```dart
import 'package:flutter/material.dart';
import 'package:gridview_menu/gridview_menu.dart';

class HomeWidget extends StatefulWidget {
  final List<MenuItem>? menuItem;
  HomeWidget({Key? key, @required this.menuItem}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _showList = false; // False shows a grid view or List view if its true

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(70, 103, 48, 1),
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Bem vindo(a) USERNAME'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(_showList ? Icons.grid_on : Icons.grid_off),
              onPressed: () {
                if (mounted)
                  setState(() {
                    _showList = !_showList;
                  });
              },
            ),
          ],
        ),
        body: MobileSidebar(
          breakPoint: 3000,
          items: widget.menuItem!,
          showList: _showList, 
        ),
      ),
    );
  }
}

```

### MenuHomeScreen.dart

```dart

import 'package:gridview_menu/gridview_menu.dart';

class MenuHomeScreen extends StatefulWidget {
  final Color color = Color.fromRGBO(70, 103, 48, 1);

  @override
  _MenuHomeScreenState createState() => _MenuHomeScreenState();
}

class _MenuHomeScreenState extends State<MenuHomeScreen> {
  @override
  Widget build(BuildContext context) {

    List<MenuItem> menuItem = <MenuItem>[
      MenuItem(
        icon: Icons.event,
        color: widget.color,
        title: 'Administrativo',
        subtitle: 'Administrativo',
        child: AdministrativeScreen(),
      ),
      MenuItem(
        icon: Icons.event,
        color: widget.color,
        title: 'Preventiva',
        subtitle: 'Agendar preventiva',
        child: SchedulingScreen(),
      ),
      MenuItem(
        icon: Icons.schedule,
        color: widget.color,
        title: 'Agendamentos',
        subtitle: 'Meus agendamentos',
        child: ScheduleListScreen(),
      ),
    ];
    return HomeWidget(
      menuItem: menuItem,
    );
  }
}
```

## Based on

Improvements and Null safety based on package <https://pub.dev/packages/mobile_sidebar/versions/1.6.0> from <https://pub.dev/publishers/rodydavis.com>

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
