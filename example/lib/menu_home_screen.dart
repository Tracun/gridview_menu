
import 'package:flutter/material.dart';
import 'package:gridview_menu/gridview_menu.dart';

import '../screens/screens.dart';
import 'home_widget.dart';

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
        child: AdministrativeScreen(), // Create your own screen
      ),
      MenuItem(
        icon: Icons.event,
        color: widget.color,
        title: 'Preventiva',
        subtitle: 'Agendar preventiva',
        child: SchedulingScreen(), // Create your own screen
      ),
      MenuItem(
        icon: Icons.schedule,
        color: widget.color,
        title: 'Agendamentos',
        subtitle: 'Meus agendamentos',
        child: ScheduleListScreen(), // Create your own screen
      ),
    ];
    return HomeWidget(
      menuItem: menuItem,
    );
  }
}