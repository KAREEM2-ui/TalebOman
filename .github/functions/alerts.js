const admin = require("firebase-admin");

require('dotenv').config();
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp(
    {
        credential: admin.credential.cert(serviceAccount),
    }
);
const db = admin.firestore();




async function runAlertCheck() {
  const userData = await db.collection("users").get();
  userData.forEach(async (userDoc) => {
    console.log(`Processing user: ${userDoc.id}`);
  });


  await db.collection("Alerts logs").add({runAt: new Date(), status: "completed"})
};



runAlertCheck().catch(error((err) => {
  console.error("Error running alert check:", err);
}));

