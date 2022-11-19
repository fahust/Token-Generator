# Token Generator

<!--<p align="center" width="100%"><img align="center" src="./doc/My%20starter%20kit.png?raw=true" /></p>-->

# Description

In Progress

## Prerequisites

1. Latest version of Node to be installed(i recommend NVM, easier to install and possible to work with multiple node versions).
2. Install MongoDB and make sure it is running on default port 27017 (if not then please configure constants.ts and change the connection for mongoDB).

Then, install all packages in project.

```bash
yarn
```

```bash
npm i
```


## Library

- [Node.js](https://nodejs.org/dist/latest-v18.x/docs/api/) v18.12.1
- [Typescript](https://www.typescriptlang.org/docs/handbook/typescript-from-scratch.html) v4.9.3
- [Express](https://expressjs.com/en/starter/installing.html) v4.18.1
- [Mongoose](https://mongoosejs.com/docs/guide.html) v6.5.0
- [Jest]() v28.1.1
- [multer]() v1.4.5-lts.1
- [swagger]() v6.2.1

## Running the app

```bash
# development
$ npm run start

# watch mode
$ npm run dev

# build mode
$ npm run build

# lint code
$ npm run lint
$ npm run lint:fix

# deploy in production
$ npm run deploy:prod
```

## Test

The **test** system use [jest](https://jestjs.io/docs/getting-started) run with --coverage parameter

```bash
# unit tests with jest --coverage
$ npm run test
```

<p align="center" width="100%"><img align="center" src="./doc/coverage.png?raw=true" /></p>

## Documentation

The **documentation** is generated using [swagger](https://swagger.io/docs/specification/basic-structure/) on the url http://localhost:3000/api-docs/
![Documentation](./doc/Swagger.png?raw=true 'Documentation')

  </p>
</details>

## Logs

All routes and errors messages are logged with library [Winston](https://github.com/winstonjs/winston)

<p align="center" width="100%"><img align="center" src="./doc/logs.png?raw=true" /></p>
