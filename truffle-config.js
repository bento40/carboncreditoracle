const provider = require('@truffle/hdwallet-provider');
module.exports = {
  networks: {
    rinkedby: {
      provider: () =>
        new provider(
          'https://rinkeby.infura.io/v3/7c6ef22d37684d9fa210bf4ad5cb2fb2',      
        ),
        network_id:4
    },
    development: {
          host: "127.0.0.1",
          port: 7545,
          network_id: "*" // Match any network id
    }
  },

  mocha: {
  },
  compilers: {
    solc: {
      version: "0.8.14",      // Fetch exact version from solc-bin (default: truffle's version)

    }
  },

};
