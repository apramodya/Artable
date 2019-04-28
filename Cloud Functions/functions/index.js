const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const stripe = require("stripe")(functions.config().stripe.secret_test_key);

exports.createStripeCustomer = functions.firestore.document('users/{userId}').onCreate(async (snap, context) => {
   const data = snap.data();
   const email = data.email;

   const customer = await stripe.customers.create({ email: email});
   return admin.firestore().collection('users').doc(data.id).update({ stripeId: customer.id});
});
