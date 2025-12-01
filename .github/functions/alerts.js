const admin = require("firebase-admin");
const { or, where } = require("firebase-admin/firestore");

require('dotenv').config({path: '.github/.env'});
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp(
    {
        credential: admin.credential.cert(serviceAccount),
    }
);
const db = admin.firestore();




async function runAlertCheck() {
  
  // get all profiles
  let ProfilesCollection =  db.collection("UserProfiles")
  const profilesSnapshot = await ProfilesCollection.get();
  const profiles = profilesSnapshot.docs.map((doc)=> ({...doc.data(), id: doc.id}));
  

  // get all deadlined schloarships 1 ,3,7 days away from deadline
  const today = new Date();
  const sevenDays = addDays(today, 7);


  const scholarshipsCollection = db.collection("Scholarships");
  const scholarshipsQuery = scholarshipsCollection.where("deadline", "<=", sevenDays);
  const snapshot = await scholarshipsQuery.get();
  let Scholarships = snapshot.docs.map(doc => ({ ...doc.data(), id: doc.id }));

  // filter by  1, 3, 7 days alerts
  Scholarships = Scholarships.filter(scholarship => {
    const deadlineDate = scholarship.deadline.toDate();
    const timeDiff = deadlineDate - today;
    const daysDiff = Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
    return daysDiff === 1 || daysDiff === 3 || daysDiff === 7;
  });



    let AlertBatch = db.batch();
    let alertsCreatedCount = 0;


    // for each profile, check for matched scholarships and create alerts
    for (let profile of profiles) 
    {
      let matchedScholarships = getMatchedScholarships(profile, Scholarships);

      matchedScholarships.forEach((scholarship) => {
        const alertRef = db.collection("Alerts").doc(profile["id"]).collection("UserAlerts").doc();

        AlertBatch.set(alertRef, {
          scholarshipName: scholarship["title"],
          university: scholarship["university"],
          country: scholarship["country"],
          remainingDays: Math.ceil((scholarship["deadline"].toDate() - today) / (1000 * 60 * 60 * 24)),
          scholarshipId: scholarship["id"],
          isRead: false,
          createdAt: new Date(),
        });

        alertsCreatedCount += 1;
      });

    }





    // commit batch
    await AlertBatch.commit();



  await db.collection("Alerts logs").add({runAt: new Date(), status: `completed Alert Check - {Already Created Alerts: ${alertsCreatedCount}}`});

  console.log("Alert check completed successfully.");
};


function getMatchedScholarships(profile, scholarships) 
{
  let matched = [];
  let isCgpaMatched = false;
  let isIeltsMatched = false;
  let isFieldOfStudyMatched = false;


  for(let scholarship of scholarships)
  {
      isCgpaMatched = profile["cgpa"] >= scholarship["minCgpa"];
      isIeltsMatched = profile["ieltsScore"] >= scholarship["minIelts"];
      isFieldOfStudyMatched = scholarship["fieldsOfStudy"].includes(profile["fieldOfInterest"]);

      if(isCgpaMatched && isIeltsMatched && isFieldOfStudyMatched)
      {
          matched.push(scholarship);
      }
      
        
  }
  return matched;
}


runAlertCheck().catch((error)=>
{
    console.error("Error running alert check:", error);
});


function addDays(date, days) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

