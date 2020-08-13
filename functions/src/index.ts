import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { nanoid } from "nanoid";

if (process.env.DOTENV) {
  require("dotenv").config();
}

const { SERVICE_ACCOUNT, DATABASE_URL } = process.env;

if (!SERVICE_ACCOUNT || !DATABASE_URL) {
  throw new Error("Required env keys are missing");
}

const serviceAccount = JSON.parse(
  Buffer.from(SERVICE_ACCOUNT, "base64").toString("utf-8")
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: DATABASE_URL,
});

export const add = functions.https.onRequest(async (request, response) => {
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Headers", "*");
  response.set("Access-Control-Allow-Methods", "POST, OPTIONS");

  if (request.method === "OPTIONS") {
    response.end();

    return;
  }

  const id = nanoid(21);

  const { encrypted_secret } = request.body;

  // TODO: test if valid AES?
  if (!encrypted_secret) {
    response.status(422).send("Missing 'encrypted_secret' parameter");

    return;
  }

  await admin.database().ref(`/secrets/${id}`).set(encrypted_secret);

  response.status(200).send({ id });
});

export const get = functions.https.onRequest(async (request, response) => {
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Headers", "*");
  response.set("Access-Control-Allow-Methods", "POST, OPTIONS");

  if (request.method === "OPTIONS") {
    response.end();

    return;
  }

  const { id } = request.body;

  if (!id) {
    response.status(422).send("Missing 'id' parameter");

    return;
  }

  const secretRef = admin.database().ref(`/secrets/${id}`);

  const data = await secretRef.once("value");

  const encryptedSecret = data.val();

  if (encryptedSecret === null) {
    response.status(404).send("Not Found");

    return;
  }

  await secretRef.set(null);

  response.status(200).send({ encrypted_secret: encryptedSecret });
});
