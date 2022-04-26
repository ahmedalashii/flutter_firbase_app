import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

import '../../../get/images_getx_controller.dart';
import '../../../utils/helpers.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> with Helpers {
  ImagesGetxController controller = Get.put(ImagesGetxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Images", style: TextStyle(color: Colors.grey.shade800)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        actions: <Widget>[
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/upload_image_screen"),
              icon: const Icon(Icons.upload)),
        ],
      ),
      body: GetX<ImagesGetxController>(
        builder: (ImagesGetxController controller) {
          if (controller.references.isNotEmpty) {
            return GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: controller.references.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FutureBuilder<String>(
                      future: controller.references[index].getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          // return Image.network(snapshot.data!,fit: BoxFit.cover);
                          return Stack(
                            // fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                // its feature is stored in a cache
                                cacheKey:
                                    "fb_storage_${controller.references[index].name}",
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                imageUrl: snapshot.data!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Align(
                                // AlignmentDirectional is just like Alignment but is aware of TextDirection
                                alignment: AlignmentDirectional.bottomCenter,
                                child: Container(
                                  height: 60,
                                  color: Colors.black38,
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: IconButton(
                                    onPressed: () async => await deleteImage(path: controller.references[index].fullPath),
                                    color: Colors.red.shade800,
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const FlutterLogo(size: 60);
                        }
                      },
                    ),
                  );
                });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.warning, size: 80),
                  Text(
                    "NO DATA!",
                    style: TextStyle(fontSize: 22, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> deleteImage({required String path}) async {
    bool isDeleted = await ImagesGetxController.to.deleteImage(path: path);
    String message = (isDeleted) ? "Deleted Successfully" : "Deleted Failed!";
    showSnackBar(context: context, message: message, error: !isDeleted);
  }
}
