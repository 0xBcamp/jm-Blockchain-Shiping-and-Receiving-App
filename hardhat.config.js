require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

const INFURA = `https://mainnet.infura.io/v3/${process.env.INFURA_RPC}`;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    hardhat: {
      forking: {
        url: INFURA,
        chainId: 919,
      },
    },
    localhost: {
      timeout: 16000000,
    },
  },
};
