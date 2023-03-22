import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:semosin/model/favorites.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/view_model/shoe_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreSelect {
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : firestore 에서 shoes data다 가지고 오기
  Future<List<ShoeViewModel>> selectShoes() async {
    List<ShoeViewModel> shoeViewModelList = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('shoes').get();

    int i = 0;
    for (var document in querySnapshot.docs) {
      ShoeViewModel shoeViewModel =
          ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
      shoeViewModelList.add(shoeViewModel);
      // print(shoeViewModel.shoeImageName.substring(8));
      var url = await FirebaseStorage.instance
          .ref()
          .child('신발 이미지')
          .child(shoeViewModel.shoeImageName.substring(8))
          .getDownloadURL();
      String urlString = url.toString();
      shoeViewModelList[i].shoeImageName = urlString;

      i++;

      if (i > 10) {
        break;
      }
    }
    // print(shoeViewModelList[0].shoeImageName.substring(8));
    return shoeViewModelList;
  }

  Future<String> imageTest(imagePath) async {
    // Points to the root reference
    final storageRef = FirebaseStorage.instance.ref();

    // Points to "images"
    Reference? imagesRef = storageRef.child("신발 이미지");

    // Points to "images/space.jpg"
    final spaceRef = imagesRef.child(imagePath);

    var downloadURL = await spaceRef.getDownloadURL();

    return downloadURL;
  }

/*
  /// 날짜 :2023.03.15
  /// 작성,만든이 :이호식
  /// 내용 : 위에꺼에서 where 만 붙은거 
  /// */
  Future<List<ShoeViewModel>> selectBrandShoes(String brand) async {
    List<ShoeViewModel> shoeViewModelList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('shoes')
        .where('brand', isEqualTo: brand)
        .get();
    for (var document in querySnapshot.docs) {
      ShoeViewModel shoeViewModel =
          ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
      shoeViewModelList.add(shoeViewModel);
    }
    return shoeViewModelList;
  }
  /*
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : firestore 에서 user data다 가지고 오기
  Future<User> selectUser() async {
    // shared preference 에서 사용자 정보값 가져오기
  }

    return doc.docs.isNotEmpty;
  }
  */

//   /// 날짜 :2023.03.15
//   /// 작성자 : 권순형 , 이호식
//   /// 만든이 :
//   /// 내용 : shoes data와 user 관심 모델인 것의 데이터가 합쳐져서 그것에 해당하는 viewmodel을 반환해준다.
//   Future<List<ShoeViewModel>> selectShoesAndLikes() {
//     // 신발 데이터 가져오는 함수 호출 : selectShoes()
//     // user의 관심 모델 가져오는 함수 호출 : selectLikes()
//     // 가져온 신발 데이터들 에서 user가 관심 모델인 것을 isLike를 true 아니면 false
//     // 로 해서 새로운 ShoeViewModel로 만들어서 이걸 리턴해 주면 된다.
//   }

  Future<bool> isRight(String email, String password) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();

    return doc.docs.isNotEmpty;
  }

  Future<User> getUserInfo() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    Map<String, dynamic> data =
        querySnapshot.docs[0].data() as Map<String, dynamic>;

    User userInfo = User.fromJson(data);

    return userInfo;
  }

  Future<List<Favorites>> selectFavoriteShoes() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    List<Favorites> favoritesList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('favorites')
        .get();

    for (var document in querySnapshot.docs) {
      Favorites favorites =
          Favorites.fromJson(document.data() as Map<String, dynamic>);
      favoritesList.add(favorites);
    }
    return favoritesList;
  }
}
