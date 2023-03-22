import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semosin/services/firestore_select.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  late FireStoreSelect fireStoreSelect;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireStoreSelect = FireStoreSelect();
    fireStoreSelect.selectFavoriteShoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: fireStoreSelect.selectFavoriteShoes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.network(
                      snapshot.data![index].shoeImageName,
                    ),
                    Positioned(
                      child: IconButton(
                        onPressed: () {
                          //
                        },
                        icon: const Icon(
                          CupertinoIcons.heart_fill,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(snapshot.data![index].shoeBrandName),
                          Text(
                            snapshot.data![index].shoeModelName,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        },
      ),
    );
  }
}
