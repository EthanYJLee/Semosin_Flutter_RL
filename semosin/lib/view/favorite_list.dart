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
                crossAxisSpacing: 0,
                mainAxisSpacing: 20,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Stack(
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
                            top: 3,
                            right: 3,
                            child: Image.asset(
                              snapshot.data![index].shoeBrandName == '아디다스'
                                  ? './images/converted_adidas.png'
                                  : snapshot.data![index].shoeBrandName == '나이키'
                                      ? './images/converted_nike.png'
                                      : snapshot.data![index].shoeBrandName ==
                                              '컨버스'
                                          ? './images/converted_converse.png'
                                          : './images/googlelogo.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        snapshot.data![index].shoeModelName,
                      ),
                    ],
                  ),
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
