FROM node:20.15.0-alpine3.20 AS install

WORKDIR .

COPY ./package.json ./

RUN npm cache clean --force && rm -rf node_modules && npm install
RUN npm install

COPY . .

CMD node node_modules/postgrator-cli/index.js -c /example.postgratorrc.json | node index.js
