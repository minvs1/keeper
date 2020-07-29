import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeper/blocs/blocs.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  MainLayout({@required this.child});

  @override
  _MainLayout createState() => _MainLayout();
}

class _MainLayout extends State<MainLayout> {
  int _pathToIndex(String path) {
    // print(path);
    switch (path) {
      case '/':
        return 0;
      case '/secrets':
        return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    var selectedColor = Theme.of(context).primaryColor;

    return Scaffold(
      // drawer: DrawerMenu(),
      // appBar: MainAppBar(),
      body: BlocBuilder<RouterBloc, RouterState>(
        buildWhen: (previous, current) => previous.path != current.path,
        builder: (context, state) {
          return Row(
            children: [
              NavigationRail(
                selectedIndex: _pathToIndex(state.path),
                onDestinationSelected: (int index) {
                  switch (index) {
                    case 0:
                      context
                          .bloc<RouterBloc>()
                          .add(RouterNavigated(context, '/'));
                      break;
                    case 1:
                      context
                          .bloc<RouterBloc>()
                          .add(RouterNavigated(context, '/secrets'));
                      break;
                  }
                },
                labelType: NavigationRailLabelType.selected,
                selectedIconTheme: IconThemeData(color: selectedColor),
                selectedLabelTextStyle: TextStyle(color: selectedColor),
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.add),
                    selectedIcon: Icon(Icons.add_box),
                    label: Text('New'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    selectedIcon: Icon(Icons.find_in_page),
                    label: Text('Find'),
                  ),
                ],
              ),
              VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Center(
                  child: widget.child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
