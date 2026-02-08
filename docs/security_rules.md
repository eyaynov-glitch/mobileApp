# Firebase Security Rules (Draft)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() {
      return request.auth != null;
    }

    function userRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }

    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if request.auth.uid == userId;
    }

    match /courses/{courseId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && userRole() in ['teacher', 'admin'];

      match /lessons/{lessonId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn() && userRole() in ['teacher', 'admin'];
      }
    }

    match /grades/{gradeId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && userRole() in ['teacher', 'admin'];
    }

    match /timetables/{timetableId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && userRole() in ['teacher', 'admin'];
    }

    match /clubs/{clubId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && userRole() == 'admin';

      match /members/{memberId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn() && request.auth.uid == memberId;
      }
    }

    match /events/{eventId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && userRole() in ['teacher', 'admin'];

      match /participants/{participantId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn() && request.auth.uid == participantId;
      }

      match /comments/{commentId} {
        allow read: if isSignedIn();
        allow create: if isSignedIn();
        allow update, delete: if isSignedIn() && request.auth.uid == resource.data.userId;
      }
    }

    match /chats/{chatId} {
      allow read: if isSignedIn();
      allow write: if isSignedIn();

      match /messages/{messageId} {
        allow read: if isSignedIn();
        allow create: if isSignedIn();
      }
    }
  }
}
```
