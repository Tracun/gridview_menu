import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../gridview_menu.dart';

class MobileSidebar extends StatefulWidget {
  MobileSidebar({
    required this.items,
    this.showList = true,
    this.floatingActionButton,
    this.persistIndex = false,
    this.floatingActionButtonLocation,
    this.breakPoint = 800,
    this.mobileBottomNavigation = false,
    this.sideViewNavigation = false,
    this.tag = 'index',
    this.nestedNavigation = false,
    this.maxTabs = 4,
    this.shadowColor = const Color(0x802196F3),
    this.appBar,
  });
  final List<MenuItem> items;
  final bool showList;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final double breakPoint;
  final bool persistIndex;
  final bool mobileBottomNavigation;
  final bool sideViewNavigation;
  final String tag;
  final int maxTabs;
  // Navigation is Saved Per Tab
  final bool nestedNavigation;
  final shadowColor;
  final AppBar? appBar;

  @override
  _MobileSidebarState createState() => _MobileSidebarState();
}

class _MobileSidebarState extends State<MobileSidebar> {
  final LocalStorage _storage = LocalStorage('mobile_side_bar_settings');
  int _index = 0;
  String get key => '${widget.tag}';
  List<GlobalKey<NavigatorState>> _keys = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(MobileSidebar oldWidget) {
    if (oldWidget.items != widget.items) {
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void init() async {
    if (widget.nestedNavigation) {
      for (var item in widget.items) {
        final navigatorKey = GlobalKey<NavigatorState>(debugLabel: item.title);
        _keys.add(navigatorKey);
      }
    }
    if (widget.persistIndex) {
      await _storage.ready;

      final int? _data = _storage.getItem(key);
      if (_data != null && _data != _index && _data <= widget.items.length) {
        _changeIndex(_data);
      }
    }
  }

  void _updateIndex(BuildContext context, int value) async {
    final _maxTabs = widget.maxTabs;
    if (value == _maxTabs) {
      // Show more itens
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (int i = _maxTabs; i < widget.items.length; i++) ...[
                      ListTile(
                        selected: _index == i,
                        leading: Icon(widget.items[i].icon),
                        title: Text(widget.items[i].title),
                        // trailing: Icon(widget.items[i].icon),
                        onTap: () async {
                          if (i == _index) {
                            _keys[_index]
                                .currentState!
                                .popUntil((route) => route.isFirst);
                            Navigator.pop(context);
                          } else {
                            _changeIndex(i);
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (_index == value) {
      _keys[_index].currentState!.popUntil((route) => route.isFirst);
    } else {
      _changeIndex(value);
    }
  }

  void _changeIndex(int value) async {
    if (mounted)
      setState(() {
        _index = value;
      });

    if (widget.persistIndex) {
      await _storage.setItem(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    log("MediaQuery.of(context).size.width: ${MediaQuery.of(context).size.width}");
    // Crio uma com menu no bottom
    if (MediaQuery.of(context).size.width < widget.breakPoint) {
      if (widget.mobileBottomNavigation) {
        // Return a bottom layout
        return bottomNavigation();
      } else if (widget.sideViewNavigation) {
        // Return a sideView layout
        return leftSideView();
      }
      //Return a gridView layout
      return gridviewMenu();
    }

    // Return a sideView layout
    return leftSideView();
  }

  bottomNavigation() {
    return Scaffold(
      appBar: widget.appBar,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: _NestedWidget(
        index: _index,
        keys: _keys,
        items: widget.items,
        nestedNavigation: widget.nestedNavigation,
      ),
      bottomNavigationBar: Builder(
        builder: (_) {
          int tabIndex = _index;
          final _max = widget.maxTabs;
          if (tabIndex > _max) {
            tabIndex = _max;
          }
          return BottomNavigationBar(
            currentIndex: tabIndex,
            onTap: (index) => _updateIndex(context, index),
            type: BottomNavigationBarType.fixed,
            items: [
              for (int i = 0; i < _max && i < widget.items.length; i++) ...[
                BottomNavigationBarItem(
                  icon: Icon(widget.items[i].icon),
                  label: widget.items[i].title,
                )
              ],
              if (widget.items.length > widget.maxTabs)
                BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz), label: 'More'),
            ],
          );
        },
      ),
    );
  }

  gridviewMenu() {
    return Scaffold(
      appBar: widget.appBar,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            // Exibe os itens em linhas
            if (widget.showList) {
              return ListView(
                children: <Widget>[
                  for (var item in widget.items) ...[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.color,
                        child: Icon(item.icon, color: Colors.white),
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.subtitle),
                      onTap: () {
                        item.push(context);
                      },
                    ),
                  ],
                ],
              );
            }
            // Exibe em forma de menu (Grid)
            final _children = <Widget>[
              for (var item in widget.items) ...[
                RaisedChild(
                  Container(
                    padding: EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: () => item.push(context),
                      child: new GridActionItem(item: item),
                    ),
                  ),
                  widget.shadowColor,
                ),
              ],
            ];
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
                child: GridView.count(
                  crossAxisCount: getCrossAxisCount(context, itemWidth: 180),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: _children,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  leftSideView() {
    return Scaffold(
      appBar: widget.appBar,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: SliverFillRemaining(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Container(
                      width: 250,
                      padding: EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            if (widget.floatingActionButton != null) ...[
                              Container(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: widget.floatingActionButton,
                              ),
                            ],
                            for (var item in widget.items) ...[
                              ListTile(
                                selected: widget.items.indexOf(item) == _index,
                                leading: Icon(item.icon),
                                title: Text(item.title),
                                subtitle: Text(item.subtitle),
                                // onLongPress: () {
                                //   item.push(context);
                                // },
                                onTap: () => _updateIndex(
                                    context, widget.items.indexOf(item)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      elevation: 0.0,
                      child: _NestedWidget(
                        index: _index,
                        keys: _keys,
                        items: widget.items,
                        nestedNavigation: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NestedWidget extends StatelessWidget {
  const _NestedWidget({
    Key? key,
    required this.items,
    required int index,
    this.nestedNavigation = false,
    required List<GlobalKey<NavigatorState>> keys,
  })  : _index = index,
        _keys = keys,
        super(key: key);

  final List<MenuItem> items;
  final int _index;
  final List<GlobalKey<NavigatorState>> _keys;
  final bool nestedNavigation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (var item in items) ...[
          Offstage(
            offstage: items.indexOf(item) != _index,
            child: Builder(
              builder: (_) {
                if (nestedNavigation) {
                  MaterialApp(
                    navigatorKey: _keys[items.indexOf(item)],
                    debugShowCheckedModeBanner: false,
                    theme: Theme.of(context),
                    home: item.child,
                  );
                }
                return item.child;
              },
            ),
          ),
        ],
      ],
    );
  }
}
