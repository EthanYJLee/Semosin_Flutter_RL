import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreSelect {
//   /// 날짜 :2023.03.15
//   /// 작성자 : 권순형 , 이호식
//   /// 만든이 :
//   /// 내용 : firestore 에서 shoes data다 가지고 오기
//   Future<List<Shoe>> selectShoes() async {
//     //
//   }

//   /// 날짜 :2023.03.15
//   /// 작성자 : 권순형 , 이호식
//   /// 만든이 :
//   /// 내용 : firestore 에서 user data다 가지고 오기
//   Future<User> selectUser() async {
//     // shared preference 에서 사용자 정보값 가져오기
//   }

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
}
