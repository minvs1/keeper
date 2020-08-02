// TODO
import { describe, it, after } from "mocha";
import { assert } from "chai";
import * as admin from "firebase-admin";
import * as firebaseFunctionsTest from "firebase-functions-test";

const test = firebaseFunctionsTest(
  {
    projectId: process.env.PROJECT_ID,
    databaseURL: process.env.DATABASE_URL,
  },
  "../service-account.json"
);

import * as myFunctions from "../src/index";

describe("SecretRepository", () => {
  describe("add", () => {
    after(() => {
      test.cleanup();
      admin.database().ref("secrets").remove();
    });

    it("should successfully add secret", (done) => {
      const encryptedSecret = "testsecret";
      const req: any = {
        body: { encrypted_secret: encryptedSecret },
      };
      const res: any = {
        status: (status: number) => {
          assert.equal(status, 200);

          return {
            send: (body: { id: string }) => {
              const { id } = body;
              assert.equal(id.length, 21);

              admin
                .database()
                .ref(`secrets/${id}`)
                .once("value", (data) => {
                  assert.equal(data.val(), encryptedSecret);

                  done();
                });
            },
          };
        },
      };

      myFunctions.add(req, res);
    });
  });
});
