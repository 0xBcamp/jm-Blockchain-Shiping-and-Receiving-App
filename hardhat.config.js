require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    hardhat: {
      forking: {
        url: "https://sepolia.mode.network",
        chainId: 919,
      },
    },
    localhost: {
      timeout: 16000000,
    },
  },
};
