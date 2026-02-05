/* eslint-disable no-console */
const admin = require('firebase-admin');
const fs = require('fs');

if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  throw new Error('Set GOOGLE_APPLICATION_CREDENTIALS to your service account json path.');
}

const key = JSON.parse(fs.readFileSync(process.env.GOOGLE_APPLICATION_CREDENTIALS, 'utf8'));
admin.initializeApp({ credential: admin.credential.cert(key) });
const db = admin.firestore();

const clubs = [
  { id: 'tech', name: 'YCL Tech Club', description: 'Flutter, AI, and web dev community in Casablanca.', logoUrl: 'https://images.unsplash.com/photo-1518773553398-650c184e0bb3' },
  { id: 'esports', name: 'YCL Esports', description: 'Competitive gaming and tournaments.', logoUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e' },
  { id: 'culture', name: 'YCL Culture', description: 'Moroccan culture, debates, and student life.', logoUrl: 'https://images.unsplash.com/photo-1591604466107-ec97de577aff' },
];

const events = [
  {
    id: 'event1',
    title: 'Hackathon Casablanca 2026',
    description: '48h innovation challenge at Ynov Campus Maroc.',
    imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
    clubId: 'tech',
    city: 'Casablanca',
    date: '2026-03-14T09:00:00.000Z',
    latitude: 33.5731,
    longitude: -7.5898,
  },
  {
    id: 'event2',
    title: 'Esports League Qualifier',
    description: 'Campus tournament for FIFA and Valorant.',
    imageUrl: 'https://images.unsplash.com/photo-1542751110-97427bbecf20',
    clubId: 'esports',
    city: 'Casablanca',
    date: '2026-04-02T15:00:00.000Z',
    latitude: 33.5899,
    longitude: -7.6039,
  },
  {
    id: 'event3',
    title: 'Moroccan Entrepreneurship Talk',
    description: 'Meet founders and alumni from Casablanca startups.',
    imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978',
    clubId: 'culture',
    city: 'Casablanca',
    date: '2026-04-20T17:00:00.000Z',
    latitude: 33.5731,
    longitude: -7.5898,
  },
];

(async () => {
  for (const club of clubs) await db.collection('clubs').doc(club.id).set(club);
  for (const event of events) await db.collection('events').doc(event.id).set(event);
  await db.collection('chatRooms').doc('global').set({ title: 'Global YCL Chat' }, { merge: true });
  console.log('Firestore seeded with Moroccan YCL data.');
})();
