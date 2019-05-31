const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const stripe = require("stripe")(functions.config().stripe.secret_test_key);

exports.createStripeCustomer = functions.firestore.document('users/{userId}').onCreate(async (snap, context) => {
    const data = snap.data();
    const email = data.email;

    const customer = await stripe.customers.create({email: email});
    return admin.firestore().collection('users').doc(data.id).update({stripeId: customer.id});
});

exports.makeCharge = functions.https.onCall(async (data, context) => {
    const total = data.total;
    const customerId = data.customerId;
    const idempotency = data.idempotency;
    const uid = context.auth.uid;

    if (uid === null) {
        console.log("Illegal access attempt due to unauthenticated user");
        throw new functions.https.HttpsError('permission-denied', 'Illegal access attempt');
    }

    return stripe.charges.create({
        amount: total,
        customer: customerId,
        currency: "sgd"
    }, {
        idempotency_key: idempotency
    }).then(_ => {
        return
    }).catch(error => {
        console.log(error);
        throw new functions.https.HttpsError('internal', 'Unable to create charge');
    })
});

exports.createEphemeralKey = functions.https.onCall(async (data, context) => {
    const customerId = data.customer_id;
    const stripeVersion = data.stripe_version;
    const uid = context.auth.uid;

    if (uid === null) {
        console.log("Illegal access attempt due to unauthenticated user");
        throw new functions.https.HttpsError('permission-denied', 'Illegal access attempt');
    }

    return stripe.ephemeralKeys.create(
        {customer: customerId},
        {stripe_version: stripeVersion}
    ).then((key) => {
        console.log(key);
        return key;
    }).catch((err) => {
        console.log(err);
        throw new functions.https.HttpsError('internal', 'Unable to make ephemeral key')
    })
});

