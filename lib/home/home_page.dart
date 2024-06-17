// home_page.dart
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import '../custom/custom_app_bar.dart';
import '../custom/custom_home_page_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../folders/folder_select/select_item_folder/stages.dart';
//import '../folders/row_folders.dart';
import '../folders/permission_manager.dart';
import 'package:provider/provider.dart';

import '../right_drawer.dart';

class AlbumProvider with ChangeNotifier {
  late List<AssetPathEntity> _albums = [];

  List<AssetPathEntity> get albums => _albums;

  void setAlbums(List<AssetPathEntity> albums) {
    _albums = albums;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final selectedIndex = ValueNotifier<int>(0);
  PermissionManager permission = PermissionManager();
  late Widget stagesWidget;

  @override
  void initState() {
    super.initState();
    permission.requestPermissions().then((isGranted) {
      if (!isGranted) {
        permission.showPermissionMessage(context);
        SystemNavigator.pop();
      } else {
        _getAlbums();
      }
    });
  }

  Future<void> _getAlbums() async {
    var albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    var albums = await permission.fetchAssets();
    albumProvider.setAlbums(albums);
    if (albums.isNotEmpty) {
      stagesWidget = Stages(album: albums[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var albumProvider = Provider.of<AlbumProvider>(context);
    var imageAssets = albumProvider.albums;

    return Scaffold(
//      endDrawer: const RightDrawer(),
//      appBar: const CustomAppBar(title: '휴대폰 사진 앨범', isHomeScreen: true),
      body: SafeArea(
        child: imageAssets.isNotEmpty
            ? stagesWidget
            : const CircularProgressIndicator(),
      ),
      bottomNavigationBar:
          CustomHomePageNavigationBar(selectedIndex: selectedIndex),
    );
  }
}
