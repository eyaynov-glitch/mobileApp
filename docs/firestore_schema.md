# Firestore Structure - ynov Campus League

## Collections

### users/{userId}
```json
{
  "displayName": "Amina Benali",
  "email": "user@arabaskenov.com",
  "role": "student",
  "phone": "+212600000000",
  "address": "Ynov Campus",
  "bio": "UI/UX enthusiast",
  "photoUrl": "...",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### courses/{courseId}
```json
{
  "title": "Mobile Development",
  "description": "Flutter & Firebase",
  "teacherId": "users/teacherId",
  "credits": 4,
  "createdAt": "timestamp"
}
```

### courses/{courseId}/lessons/{lessonId}
```json
{
  "title": "State Management",
  "content": "...",
  "resources": ["storage://.../notes.pdf"],
  "createdAt": "timestamp"
}
```

### enrollments/{enrollmentId}
```json
{
  "studentId": "users/studentId",
  "courseId": "courses/courseId",
  "createdAt": "timestamp"
}
```

### grades/{gradeId}
```json
{
  "studentId": "users/studentId",
  "courseId": "courses/courseId",
  "value": 17.5,
  "max": 20,
  "examDate": "timestamp",
  "createdAt": "timestamp"
}
```

### timetables/{timetableId}
```json
{
  "studentId": "users/studentId",
  "weekOf": "2024-09-02",
  "days": {
    "monday": [{"courseId": "courses/id", "start": "09:00", "end": "11:00"}],
    "tuesday": []
  }
}
```

### clubs/{clubId}
```json
{
  "name": "Photography",
  "description": "Capture campus life",
  "memberCount": 42,
  "createdAt": "timestamp"
}
```

### clubs/{clubId}/members/{userId}
```json
{
  "joinedAt": "timestamp"
}
```

### events/{eventId}
```json
{
  "title": "Trip to Marrakech",
  "description": "Weekend adventure",
  "location": {"name": "Marrakech", "lat": 31.63, "lng": -8.0},
  "startAt": "timestamp",
  "endAt": "timestamp",
  "likeCount": 14,
  "dislikeCount": 2,
  "createdAt": "timestamp"
}
```

### events/{eventId}/participants/{userId}
```json
{
  "joinedAt": "timestamp"
}
```

### events/{eventId}/comments/{commentId}
```json
{
  "userId": "users/userId",
  "message": "Can't wait!",
  "createdAt": "timestamp"
}
```

### chats/{chatId}
```json
{
  "type": "group",
  "memberIds": ["users/a", "users/b"],
  "lastMessage": "Hello",
  "updatedAt": "timestamp"
}
```

### chats/{chatId}/messages/{messageId}
```json
{
  "senderId": "users/a",
  "type": "text",
  "content": "Hey",
  "mediaUrl": "storage://...",
  "createdAt": "timestamp"
}
```

## Indexing Suggestions
- Composite indexes for `events` by `startAt` and `location.name`.
- Composite indexes for `grades` by `studentId` + `courseId`.
- Index `messages` by `createdAt` for fast chat scroll.
