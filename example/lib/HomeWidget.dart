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
    return Scaffold(
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
    );
  }
}