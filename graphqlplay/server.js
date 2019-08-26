const express = require("express");
const graphqlHTTP = require("express-graphql");
const { buildSchema } = require("graphql");
const fs = require("fs");
const path = require("path");

// Import schema from file. In prod, this would be some external database
let gqlSchema = fs.readFileSync(
  path.resolve(__dirname, "tenants/t1/orgs/org1/schemaConfig.gqls"),
  "utf-8"
);
// Create schema
let schema = buildSchema(gqlSchema);

// Create fake DB
let fakeDb = require("./tenants/t1/orgs/org1/fakeDb.json");

let rootConfig = require("./tenants/t1/orgs/org1/rootConfig.json");
let root = {};
rootConfig.map(element => {
  let entryPoint = element.entryPoint;
  let params = element.params; // Doesn't work as intended
  let body = element.body; // doesn't execute...

  newPair = {
    [entryPoint]: function({ id }) {
      console.log("ran", entryPoint);
      console.log("id is:", id);
      return new Function(id, body); // for some
    }
  };
  console.log("newPair:", newPair[entryPoint]);
  root = { ...root, ...newPair };
});

// let root = {
//   user: ({ id }) => {
//     return fakeDb.user[id];
//   },
//   car: ({ id }) => {
//     return fakeDb.car[id];
//   }
// };

// let root = {
//   user: function({ id }) {
//     return fakeDb.user[id];
//   },
//   car: function({ id }) {
//     return fakeDb.car[id];
//   }
// };

console.log("root as we know it:", root); // looks right, but the function doesn't run
console.log("root car:", root.car);
// Express stuff
let app = express();
app.use(
  "/graphql",
  graphqlHTTP({
    schema: schema,
    rootValue: root,
    context: fakeDb,
    graphiql: true
  })
);

app.listen(4000);
console.log("GraphQL API running at http://localhot:4000/graphql");
