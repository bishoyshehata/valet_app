
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:googleapis_auth/auth_io.dart';
import '../models/notification_model.dart';


class NotificationRemoteDataSource {

  Stream<NotificationModel> getNotifications() {
    return FirebaseMessaging.onMessage.map((message) {
      return NotificationModel.fromRemoteMessage(message);
    });
  }

  //
  // Future<void> sendPushNotification({
  //    String? topic,
  //    String? token,
  //   required String title,
  //   required String body,
  // }) async {
  //
  //   // final accessToken = await getAccessToken();
  //
  //   final url = Uri.parse('https://fcm.googleapis.com/v1/projects/low-calories-5b369/messages:send');
  //
  //   // final headers = {
  //   //   'Content-Type': 'application/json',
  //   //   'Authorization': 'Bearer $accessToken',
  //   // };
  //
  //   final bodyData = jsonEncode({
  //     'message': {
  //       if(token != null) "token": token,
  //       if(topic != null) 'topic': topic,
  //       'notification': {
  //         'title': title,
  //         'body': body,
  //       },
  //       'data': {
  //         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //         'sound': 'default',
  //         'id': '1',
  //         'status': 'done'
  //       },
  //       'android': {
  //         'notification': {
  //           'click_action': 'FLUTTER_NOTIFICATION_CLICK'
  //         }
  //       },
  //       'apns': {
  //         'payload': {
  //           'aps': {
  //             'category': 'NEW_MESSAGE_CATEGORY'
  //           }
  //         }
  //       }
  //     }
  //   });
  //
  //   final response = await http.post(url, headers: headers, body: bodyData);
  //
  //   if (response.statusCode == 200) {
  //     print('success');
  //   } else {
  //     print('error : ${response.body}');
  //   }
  // }

  void subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('topic$topic');
  }

  // Future<String> getAccessToken() async {
  //   var accountCredentials = ServiceAccountCredentials.fromJson(
  //       {
  //         "type": "service_account",
  //         "project_id": "low-calories-5b369",
  //         "private_key_id": "56a4abf5d91ac42b20b02df8ef7dddbaca7fddd2",
  //         "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0e+Hn6Wc6eOLK\nV+h3hrCQVMGOT/XRmAsU9myB4Jo5vZNaavjJ0KHDEuDkswpS7cGUGTNCPf8o5JHq\nNhN3PYlerHmyrv0mr6PAODQbr3PEbJ6+IqWdilPFkLox9qyB3DefycuZUWaHuKHI\nxgSntxkOGOG9Bvz1chbw44As/fzjfmBsV7lQdP9fW0Cx8lLOUVfmj/S/w4QBt5+Z\nFwW01jJ7mBojRWkNwJbpeBvYgh7nyw+i6EiiJ5t9xqtGT2NPipW/54DcoCgo50dN\n34MMSl+4AzEM2l5hBbR2xvLkQuMk56e6qnjjR6SCEOoOt9sXNOvuPGPgGlQYjI5r\niJ5ZVmxlAgMBAAECggEAO9Cy1gFszNwzjYwE51gkPDFa1Kd7eLNDOPdSjti5RFmn\n9FdvjLMwaU5gamtMCJ/zf/m6G0IgxpS6Jz00xlgGpvHSg32rOJ8NTi9SVbqYS4kU\nMz+YU9X8XYXRr61pDsDFTpe6el2X9XMjaz71XAA6tYlZhyRBwbbGE5/SYxbqMRqq\nYUnWBr5nQcE4mUGuaaPxREo/URKMMf6+cBoWX6BlQOs7+f9zpTi/dRZFIP/13l7U\nRQ2hfHxUCfVwrSmtqlPL4TEm27HYga6fQybdsUEfGCUYKB0IbVK+LOt6twYxvDcO\njH5Sos28H3Ic1kVdOZOXw5BQSvzKofN8si7f4rDpIQKBgQDJTjnWxPJ/RNrI1Zeh\nfujWboSR6/y34L6Cxh9Ly0kJnr8dNIPbfJpNRDVDaJJyNbF36Hs1IL8/R/2Fim0j\nPOOa6QyP4e7yG8JsqFHnf8K3lw9aedTrrdYhWQX08M7yVkrH2u7kk/IeN5YsxORF\nC2l2fhg7Ven77Y11SlKMZVEREwKBgQDlhWjy2bgUzGxbQup9gVrMnbgty+2tbkHO\nSxaTzG4Ukxs3hRwZoNgo25l5BfzLXCVA700I019NVRKpzg3fqQd17KvjuK4k8W7E\nX4Rbbf5db3KPy3C+q7MRwMNyp1lvmZynQe0vyE4WluA9hQPqixPz5GaurUyo5VZt\ndA0Hd+yzpwKBgB6Zf31ADsR9yOwCW7w2uFnwDsLHpnCk/xCN4S/6RK3rrY1Y8Doq\n5KGeHqKSgMBPnRxnAGOBCNErtkPYWOKkXMytZDVy2ImA4rr1kw2nhAe4NKNCJbV1\nhTkoeRlUiYCY0WEzzGB+hK1HMdK4UyKTq4JRhIlwc9LRt1D+7TFeLUZ1AoGBAM/m\n/J2eIWSVl0FDZ+yvk3PtGbxCENUcHnejBJx0fPIeHnU4GbANRkAcSvSZO9dpbEVZ\nfkoUTStbeEBf6alDDwL+kuT/kJ7eIxu1+cpn5BT2sqsV+NZ96QKXvXLJq/WvC3tl\n+Fdj9Xf4yr5vEpEN0dEGfwyS5fHHa3ZRvMubEcnZAoGAU/r5pnSyZKi/0kNn74Xq\nJ2GIoh4Of9BkOLC5W2P6BexKicF5W5ibmNeMBBclaUJnxmiKmlNE2UwQQ8hOAnW+\nBiDoM4pmcajzhXSO2QM4xkl2iPOeDYETtiumWmS/hDaa7KHnVFAcZesJ5OQZxlve\nI/nw8nYSjDI4pibMH+AX1WA=\n-----END PRIVATE KEY-----\n",
  //         "client_email": "web-key-with-all-permission@low-calories-5b369.iam.gserviceaccount.com",
  //         "client_id": "110998670214363877459",
  //         "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //         "token_uri": "https://oauth2.googleapis.com/token",
  //         "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  //         "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/web-key-with-all-permission%40low-calories-5b369.iam.gserviceaccount.com",
  //         "universe_domain": "googleapis.com"
  //       }
  //   );
  //
  //   var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  //
  //   var client = await clientViaServiceAccount(accountCredentials, scopes);
  //
  //   return client.credentials.accessToken.data;
  // }

}
