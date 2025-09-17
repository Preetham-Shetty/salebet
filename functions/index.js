const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendFollowNotification = functions.https.onCall(async (data, context) => {
  const { teamName, action, actorToken, teamId } = data;

  const teamDoc = await admin.firestore().collection("teams").doc(teamId).get();
  const followers = teamDoc.data().followers || [];

  // Get all tokens of followers
  const usersSnap = await admin.firestore()
    .collection("users")
    .where(admin.firestore.FieldPath.documentId(), "in", followers)
    .get();

  const tokens = [];
  usersSnap.forEach(doc => {
    const t = doc.data().fcmToken;
    if (t && t !== actorToken) tokens.push(t); // exclude self
  });

  if (tokens.length === 0) return { success: false, msg: "No tokens" };

  const payload = {
    notification: {
      title: action === "follow" ? "New Follower 🎉" : "Unfollowed 👋",
      body: `Someone just ${action}ed ${teamName}`,
    },
  };

  await admin.messaging().sendToDevice(tokens, payload);
  return { success: true, sent: tokens.length };
});
