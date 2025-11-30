const admin = require("firebase-admin");
const { cert } = require("firebase-admin/app");
const { error } = require("firebase-functions/logger");

require('dotenv').config();
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp(
    {
        credential: admin.credential.cert(serviceAccount),
    }
);
const db = admin.firestore();


exports.myCronJob = functions.pubsub.schedule("every 24 hours").onRun(job);


async function runAlertCheck() {
  const userData = await db.collection("users").get();
  userData.forEach(async (userDoc) => {
    console.log(`Processing user: ${userDoc.id}`);
  });
};



runAlertCheck().catch(error((err) => {
  console.error("Error running alert check:", err);
}));

