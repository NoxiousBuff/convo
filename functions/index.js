const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

admin.initializeApp()

token = 'fBRr6uTWRw-_tieiitLRuE:APA91bEFXmcMhFAG4WNPRmKLJV1hQiCiGfFsylUGpZ44m_6ZshhVhgeYn81c3UXzvFl9O0MOHeh50urU0i-W4wBoxXeKhhntFS5-dHSfchXV8OXK8XDMIfUU-cWLUer0RFzlqBgGpfWs';

// exports.zapAll = admin.firestore().collection('users')

exports.sendZap = functions.https.onCall(async (data, context) => {

  // functions.logger.error('This is the userId ', data.userId, 'from directly writing.');
  // functions.logger.error('This is the userId ', data['userId'], 'from inDirectly writing.');

  const awaitedUser = await admin.firestore().collection('subs').doc(data.userId).get();
  const userTokens = awaitedUser.get('tokens');
  // functions.logger.error('awaitedUser: ', awaitedUser);
  // functions.logger.error('au data: ', awaitedUser.data());
  // functions.logger.error('au get token: ', awaitedUser.get('tokens'));
  // functions.logger.error('awaitedUserToken: ', awaitedUser.data()['tokens']);

  //['fBRr6uTWRw-_tieiitLRuE:APA91bEFXmcMhFAG4WNPRmKLJV1hQiCiGfFsylUGpZ44m_6ZshhVhgeYn81c3UXzvFl9O0MOHeh50urU0i-W4wBoxXeKhhntFS5-dHSfchXV8OXK8XDMIfUU-cWLUer0RFzlqBgGpfWs']

  await admin.messaging().sendToDevice(userTokens, {
    data: {
      'title': data.title,
      'body': data.body,
      'imageUrl': data.imageUrl,
      'channelKey': 'zap4_channel',
    },
  },

    {
      // Required for background/quit data-only messages on iOS
      contentAvailable: true,
      // Required for background/quit data-only messages on Android
      priority: "high",
    })
});

// .collection('letters').doc('{userId}').collection('receivedLetters').doc('{letterId}')
exports.sendLetterNotification = functions.firestore.document('letters/{userId}/receivedLetters/{letterId}').onCreate( async (snap, context) => {
  functions.logger.error('------------- sendLetterNotification function starts -------------');
  // functions.logger.error('userId', context.params.userId);
  // functions.logger.error('letterId', context.params.letterId);
  const letterData = snap.data();
  // functions.logger.error('letterData', letterData);
  // functions.logger.error('letter idFrom', letterData.idFrom);

  const contextUserId = context.params.userId;

  const awaitedUser = await admin.firestore().collection('subs').doc(contextUserId).get();
  const userTokens = awaitedUser.get('tokens');

  await admin.messaging().sendToDevice(userTokens, {
    data: {
      'title': letterData.username,
      'body': letterData.letterText,
      'imageUrl': letterData.photoUrl,
      'channelKey': 'letter1_channel',
    },
  },

    {
      // Required for background/quit data-only messages on iOS
      contentAvailable: true,
      // Required for background/quit data-only messages on Android
      priority: "high",
    })
});