import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestorePay {
  /// Desc : Pay View -> Delivery Request Card에서 '배송시 요청사항' 추가하는 query
  /// Date : 2023.03.24
  /// Author : youngjin
  addDeliveryRequest(String request) async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');

    FirebaseFirestore.instance.collection('users').doc(email).update({
      'deliveryRequest': request,
    });
  }

  /// Desc : Pay View에 배송시 요청사항 보여주기
  /// Date : 2023.03.24
  /// Author : youngjin
  Future<String> getDeliveryRequest() async {
    final pref = await SharedPreferences.getInstance();
    String? email = pref.getString('saemosinemail');
    String result = '';

    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    if (querySnapshot.data()!.containsKey('deliveryRequest')) {
      result = querySnapshot.data()!['deliveryRequest'];
    }
    return result;
  }
}
