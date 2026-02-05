import json, os
from datetime import datetime
import firebase_admin
from firebase_admin import credentials, firestore

raw = os.environ.get('FIREBASE_SERVICE_ACCOUNT_JSON')
if not raw:
    raise SystemExit('Set FIREBASE_SERVICE_ACCOUNT_JSON env var.')
cred = credentials.Certificate(json.loads(raw))
firebase_admin.initialize_app(cred)
db = firestore.client()

clubs = {
    'tech': {
        'Name': 'Tech & AI Club',
        'Description': 'Workshops on Flutter, AI and software engineering for Ynov Maroc students.',
        'Members': []
    },
    'esports': {
        'Name': 'Esports League',
        'Description': 'Competitive gaming club with internal tournaments and bootcamps.',
        'Members': []
    },
    'media': {
        'Name': 'Media & Design Club',
        'Description': 'Video, design and storytelling projects for campus communication.',
        'Members': []
    },
}

for cid, data in clubs.items():
    db.collection('Clubs').document(cid).set(data, merge=True)

events = [
    {
        'id': 'event1',
        'Title': 'Flutter Hack Night Casablanca',
        'Description': 'Night coding session focused on Flutter project building at Ynov Campus Maroc.',
        'Date': datetime(2026, 3, 12, 18, 0),
        'ClubId': 'tech',
        'Place': '8 Ibnou Katima, Casablanca 20000',
        'Lat': 33.5731,
        'Lng': -7.5898,
        'urlEvent': 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=900'
    },
    {
        'id': 'event2',
        'Title': 'YCL Esports Qualifier',
        'Description': 'Campus qualifier tournament with team registration and live commentary.',
        'Date': datetime(2026, 4, 5, 14, 0),
        'ClubId': 'esports',
        'Place': 'Ynov Campus Maroc - Gaming Room',
        'Lat': 33.5731,
        'Lng': -7.5898,
        'urlEvent': 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=900'
    },
    {
        'id': 'event3',
        'Title': 'Creative Content Day',
        'Description': 'Photography and branding workshop for Moroccan campus events.',
        'Date': datetime(2026, 4, 19, 10, 0),
        'ClubId': 'media',
        'Place': 'Ynov Campus Maroc Studio',
        'Lat': 33.5731,
        'Lng': -7.5898,
        'urlEvent': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900'
    },
]

for e in events:
    db.collection('Events').document(e['id']).set(e, merge=True)

print('Seeded Clubs and Events successfully.')
