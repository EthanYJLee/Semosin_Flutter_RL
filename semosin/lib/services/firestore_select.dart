import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:semosin/model/cart.dart';
import 'package:semosin/model/favorites.dart';
import 'package:semosin/model/user.dart';
import 'package:semosin/view_model/shoe_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreSelect {
  // ------------------------------------------------------------------------------------
  // 신발 정보 select 관련
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : firestore 에서 shoes data다 가지고 오기
  Future<List<ShoeViewModel>> selectAllShoes(
      String sortValue, int start, int end) async {
    List<ShoeViewModel> shoeViewModelList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('shoes')
        .orderBy(sortValue)
        .get();

    int i = 0;
    for (var document in querySnapshot.docs.getRange(start, end)) {
      ShoeViewModel shoeViewModel =
          ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
      shoeViewModelList.add(shoeViewModel);
      var url = await FirebaseStorage.instance
          .ref()
          // .child('신발 이미지')
          .child(shoeViewModel.shoeImageName.substring(2))
          .getDownloadURL();
      String urlString = url.toString();
      shoeViewModelList[i].shoeImageName = urlString;
      i++;
    }
    return shoeViewModelList;
  }

  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 :
  /// 내용 : firestore 에서 shoes data다 가지고 오기
  Future<List<ShoeViewModel>> selectAllTextShoes(
      String searchText, String sortValue, int start, int end) async {
    List<ShoeViewModel> shoeViewModelList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('shoes')
        .orderBy(sortValue)
        .get();

    int i = 0;
    int j = 0;
    for (var document in querySnapshot.docs) {
      if (document.get("model").toString().contains(searchText)) {
        i++;
        if (i >= start && i < end) {
          ShoeViewModel shoeViewModel =
              ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
          shoeViewModelList.add(shoeViewModel);

          var url = await FirebaseStorage.instance
              .ref()
              // .child('신발 이미지')
              .child(shoeViewModel.shoeImageName.substring(2))
              .getDownloadURL();
          String urlString = url.toString();
          shoeViewModelList[j].shoeImageName = urlString;
          j++;
        }
      }
    }
    return shoeViewModelList;
  }

  /// 날짜 :2023.03.15
  /// 작성,만든이 :이호식
  /// 내용 : 위에꺼에서 where 만 붙은거
  Future<List<ShoeViewModel>> selectBrandShoes(
      String brand, String sortValue, int start, int end) async {
    List<ShoeViewModel> shoeViewModelList = [];
    late QuerySnapshot querySnapshot;
    if (sortValue == 'brand') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .where("brand", isEqualTo: brand)
          .get();
    } else {
      // 복합 쿼리 해야됨
      querySnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .orderBy(sortValue)
          .where("brand", isEqualTo: brand)
          .get();
    }

    int i = 0;
    for (var document in querySnapshot.docs.getRange(start, end)) {
      ShoeViewModel shoeViewModel =
          ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
      shoeViewModelList.add(shoeViewModel);
      // print(shoeViewModel.shoeImageName.substring(8));
      var url = await FirebaseStorage.instance
          .ref()
          // .child('신발 이미지')
          .child(shoeViewModel.shoeImageName.substring(2))
          .getDownloadURL();
      String urlString = url.toString();
      shoeViewModelList[i].shoeImageName = urlString;
      i++;
    }
    return shoeViewModelList;
  }

  /// 날짜 :2023.03.22
  /// 작성,만든이 : 권순형
  /// 내용 : 특정 단어가 들어간 모델만 가져오기
  Future<List<ShoeViewModel>> selectBrandTextShoes(String brand,
      String searchText, String sortValue, int start, int end) async {
    List<ShoeViewModel> shoeViewModelList = [];

    late QuerySnapshot querySnapshot;
    if (sortValue == 'brand') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .where("brand", isEqualTo: brand)
          .get();
    } else {
      // 복합 쿼리 해야됨
      querySnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .orderBy(sortValue)
          .where("brand", isEqualTo: brand)
          .get();
    }

    int i = 0;
    int j = 0;

    for (var document in querySnapshot.docs) {
      if (document.get("model").toString().contains(searchText)) {
        i++;
        if (i >= start && i < end) {
          ShoeViewModel shoeViewModel =
              ShoeViewModel.fromJson(document.data() as Map<String, dynamic>);
          shoeViewModelList.add(shoeViewModel);

          var url = await FirebaseStorage.instance
              .ref()
              // .child('신발 이미지')
              .child(shoeViewModel.shoeImageName.substring(2))
              .getDownloadURL();
          String urlString = url.toString();
          shoeViewModelList[j].shoeImageName = urlString;
          j++;
        }
      }
    }
    return shoeViewModelList;
  }

  /// 날짜 :2023.03.22
  /// 작성,만든이 : 권순형
  /// 내용 : tf 값과 버튼 누른 상태에 맞는 데이터 가져오기
  Future<List<ShoeViewModel>> selectSpecificBrandShoes(String brand,
      String searchText, String sortValue, int start, int end) async {
    List<ShoeViewModel> shoeViewModelList = [];

    if (searchText == "") {
      shoeViewModelList = await selectBrandShoes(brand, sortValue, start, end);
    } else {
      shoeViewModelList =
          await selectBrandTextShoes(brand, searchText, sortValue, start, end);
    }

    return shoeViewModelList;
  }

  /// 날짜 :2023.03.22
  /// 작성,만든이 : 권순형
  /// 내용 : 전체 데이터 중에 tf 값에 맞는 데이터 가져오기
  Future<List<ShoeViewModel>> selectSpecificAllShoes(
      String searchText, String sortValue, int start, int end) async {
    List<ShoeViewModel> shoeViewModelList = [];

    if (searchText == "") {
      shoeViewModelList = await selectAllShoes(sortValue, start, end);
    } else {
      shoeViewModelList =
          await selectAllTextShoes(searchText, sortValue, start, end);
    }

    return shoeViewModelList;
  }
  // ------------------------------------------------------------------------------------

  // ------------------------------------------------------------------------------------
  // 신발 데이터 길이 관련
  /// 날짜 : 2023.03.21
  /// 수정날짜 : 2023.03.22
  /// 작성자 : 권순형
  /// 설명 : 데이터 길이 가져오기
  /// 수정 : 버튼 눌렀을 때, 텍스트 입력했을 때로 경우의 수 다 나눔
  Future<int> getBrandDataLength(String brandName, String searchText) async {
    late QuerySnapshot querySnapshot;
    int result = 0;

    if (searchText == "") {
      if (brandName == 'all') {
        querySnapshot =
            await FirebaseFirestore.instance.collection('shoes').get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('shoes')
            .where('brand', isEqualTo: brandName)
            .get();
      }

      result = querySnapshot.docs.length;
    } else {
      if (brandName == 'all') {
        result = await getTextLength(searchText);
      } else {
        result = await getBrandTextLength(brandName, searchText);
      }
    }

    return result;
  }

  /// 날짜 : 2023.03.22
  /// 작성자 : 권순형
  /// 설명 : 브랜드 선택하고 text 선택했을 때의 길이
  Future<int> getBrandTextLength(String brandName, String searchText) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('shoes')
        .where("brand", isEqualTo: brandName)
        .get();

    int i = 0;

    for (var document in querySnapshot.docs) {
      if (document.get("model").toString().contains(searchText)) {
        i++;
      }
    }

    return i;
  }

  /// 날짜 : 2023.03.22
  /// 작성자 : 권순형
  /// 설명 : text 입력했을 때의 길이
  Future<int> getTextLength(String searchText) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('shoes').get();

    int i = 0;

    for (var document in querySnapshot.docs) {
      if (document.get("model").toString().contains(searchText)) {
        i++;
      }
    }

    return i;
  }
  // ------------------------------------------------------------------------------------

  /// 날짜 : 2023.03.18
  /// 작성자 : 권순형
  /// 설명 : 로그인 체크
  Future<bool> isRight(String email, String password) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();

    return doc.docs.isNotEmpty;
  }
  /*
  /// 날짜 :2023.03.15
  /// 작성자 : 권순형 , 이호식
  /// 만든이 : 호식
  /// 내용 : firestore 에서 user data다 가지고 오기
  Future<User> selectUser() async {
    // shared preference 에서 사용자 정보값 가져오기
  }

    return doc.docs.isNotEmpty;
  }
  */

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
    User _user = User(
        name: userInfo.name,
        password: userInfo.password,
        uid: userInfo.uid,
        email: userInfo.email,
        nickname: userInfo.nickname,
        sex: userInfo.sex,
        phone: userInfo.phone,
        address: userInfo.address,
        addressDetail: userInfo.addressDetail,
        postcode: userInfo.postcode);
    return _user;
  }
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

  Future<List<Favorites>> selectFavoriteShoes(
      brand, sortValue, isDescending) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    List<Favorites> favoritesList = [];
    QuerySnapshot querySnapshot;

    if (brand == '전체') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('favorites')
          .orderBy(sortValue, descending: isDescending)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('favorites')
          .where('brand', isEqualTo: brand)
          .orderBy(sortValue, descending: isDescending)
          .get();
    }

    for (var document in querySnapshot.docs) {
      Favorites favorites =
          Favorites.fromJson(document.data() as Map<String, dynamic>);
      favoritesList.add(favorites);
    }
    return favoritesList;
  }

  /// 날짜 :2023.03.22
  /// 작성자 : 이호식
  /// 내용 : users의 cart 불러오기
  Future<List<Cart>> selectCart() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    List<Cart> cartList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('carts')
        .get();
    for (var document in querySnapshot.docs) {
      Map<String, dynamic> map = document.data() as Map<String, dynamic>;
      map['documentId'] = document.id;
      Cart cart = Cart.fromJson(map);
      cartList.add(cart);
    }
    return cartList;
  } //select cart end

}//FireStoreSelect End
