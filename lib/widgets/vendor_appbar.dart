import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it/provider/store_provider.dart';
import 'package:fuel_it/screens/main_screen.dart';

class vendor_appbar extends StatelessWidget implements PreferredSizeWidget {
  const vendor_appbar({
    Key? key,
    required storeProvider storeData,
  })  : _storeData = storeData,
        super(key: key);

  final storeProvider _storeData;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.green,
      leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, MainScreen.id);
          },
          icon: const Icon(CupertinoIcons.back)),
      title: Text(
        _storeData.selectedStore,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
