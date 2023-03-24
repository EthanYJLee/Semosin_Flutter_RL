import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreUpdate {
  /// Desc : 관심상품 추가 (북마크) 시 Shoes의 Like 수 +/- 해주기
  /// Date : 2023.03.22
  /// Author : youngjin
  incrementLikes(String modelName) async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("shoes").doc(modelName);
    late int likesCount;
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        likesCount = data.entries
            .where((element) => element.key == 'like')
            .map((e) => e.value)
            .first;

        likesCount++;
        docRef.update({'like': likesCount});
      },
    );
  }

  decrementLikes(String modelName) async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("shoes").doc(modelName);
    late int likesCount;
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        likesCount = data.entries
            .where((element) => element.key == 'like')
            .map((e) => e.value)
            .first;

        likesCount--;
        docRef.update({'like': likesCount});
      },
    );
  }

  /// 날짜 : 2023.03.23
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : 암호 변경을 위해서 Firestore의 암호를 수정하는 매소드
  /// 비고 : 암호를 변경하는 메소드
  /// 수정 : userinfopage의 메소드를 서비스로 옮김.
  changePassword(String password) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(email);
    // print(email);
    // print(password);
    docRef.update({"password": password});
    docRef.get().then(
          (value) => {print('바뀐패스워드:' + value['password'])},
        );
  }

  /// 날짜 : 2023.03.23
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : 주소 변경을 위해서 Firestore의 주소를 수정하는 매소드
  /// 비고 : 주소와 상세 주소, 우편번호를 변경하는 메소드
  /// 수정 : userinfopage의 메소드를 서비스로 옮김.
  changeAddress(String address, String detailAddress, String postCode) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(email);
    // print(email);
    // print(address);
    // print(detailAddress);
    // print(postCode);
    docRef.update({
      "address": address,
      "addressDetail": detailAddress,
      "postcode": postCode
    });
    // docRef.get().then(
    //       (value) => {
    //         print('바뀐주소:' + value['address']),
    //         print('바뀐상세주소:' + value['detailaddress']),
    //         print('바뀐우편번호:' + value['postcode']),
    //       },
    //     );
  }

  /// 날짜 : 2023.03.23
  /// 작성자 : 이상혁
  /// 만든이 : 이상혁
  /// 내용 : 주소 변경을 위해서 Firestore의 주소를 수정하는 매소드
  /// 비고 : 주소와 상세 주소, 우편번호를 변경하는 메소드
  /// 수정 : userinfopage의 메소드를 서비스로 옮김.
  updateDeletedate() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(email);
    print(email);
    String deleteDate = DateFormat('yy/MM/dd').format(DateTime.now());
    print('deleteDate' + deleteDate);
    docRef.update({"deletedate": deleteDate});
    docRef.get().then(
          (value) => {print('입력된 deleteDate:' + value['deletedate'])},
        );
  }
}
