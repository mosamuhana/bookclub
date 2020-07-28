import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home.viewmodel.dart';

class HomeView extends ViewModelBuilderWidget<HomeViewModel> {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel model, Widget child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () async {
              await model.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
