// web/firebase-messaging-sw.js

// Firebase 앱을 가져옵니다. (CDN 방식 사용)
importScripts(
  "https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js"
);

// Firebase 프로젝트 설정 (web/index.html 또는 firebase_options.dart에서 가져온 값)
// 여러분의 home-scouter 프로젝트의 웹 앱 설정을 여기에 넣어주세요.
// Firebase Console > 프로젝트 설정 > 내 앱 > 웹 앱 > 앱 설정(톱니바퀴) > 구성(Config)
// 예시: const firebaseConfig = { ... };
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "home-scouter-50835.firebaseapp.com",
  projectId: "home-scouter-50835",
  storageBucket: "home-scouter-50835.appspot.com",
  messagingSenderId: "385013935634", // 여러분의 프로젝트 번호와 일치해야 합니다!
  appId: "YOUR_WEB_APP_ID",
  measurementId: "G-499208661", // Google Analytics ID
};

// Firebase 앱 초기화
firebase.initializeApp(firebaseConfig);

// FCM 인스턴스 가져오기
const messaging = firebase.messaging();

// 백그라운드 메시지 처리 핸들러 (서비스 워커에서)
messaging.onBackgroundMessage(function (payload) {
  console.log(
    "[firebase-messaging-sw.js] Received background message ",
    payload
  );

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/firebase-logo.png", // 알림에 표시될 아이콘 (web 폴더에 있는 이미지)
    // 여기에 더 많은 옵션을 추가할 수 있습니다 (예: actions, data 등)
  };

  // 브라우저에 알림을 띄웁니다.
  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});

// ⭐️ 중요: 알림 클릭 시 동작 정의
self.addEventListener("notificationclick", function (event) {
  event.notification.close(); // 알림 닫기

  // 클릭 시 앱이 열리도록 클라이언트 포커스
  event.waitUntil(
    clients
      .matchAll({ type: "window", includeUncontrolled: true })
      .then(function (clientList) {
        if (clientList.length > 0) {
          let client = clientList[0];
          for (let i = 0; i < clientList.length; i++) {
            if (clientList[i].focused) {
              client = clientList[i];
            }
          }
          return client.focus(); // 기존 탭이 있다면 포커스
        } else {
          // 앱이 열려있지 않다면 새로운 탭으로 앱 열기 (여러분의 앱 URL로 변경)
          return clients.openWindow("/");
        }
      })
  );
});
