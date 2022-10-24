require("@nomicfoundation/hardhat-toolbox");
require('hardhat-abi-exporter');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    test: {
      url: "http://127.0.0.1:7545",
      accounts: ['4b481a2a63c31e6865b872bc3cad9b7f31835663b27ec34a446ec8d912604ef9']
    }
  },
  abiExporter: {
    path: './app/abi',
    runOnCompile: true,
    clear: true,
    flat: true,
    spacing: 2,
  }
};
