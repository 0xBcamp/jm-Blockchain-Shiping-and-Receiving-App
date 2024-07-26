// const ethers = require('ethers');
// const {abi} = require('../../contracts/artifacts/Shipping.json');
// console.log("ethers: ", ethers);
// console.log("abi: ", abi);

import contractABI from "../shippingabi.json";

const connectBtn = document.getElementById('connect-btn');
const addressValue = document.getElementById('address-value')
const isConnectedValue = document.getElementById('is-connected-value');

// Add Cargo
const submitCargoBtn = document.getElementById('submit-cargo');
const senderValue = document.getElementById('sender-value');
const receiverValue = document.getElementById('receiver-value');
const currentLocValue = document.getElementById('current-location-value');
const materialValue = document.getElementById('material-value');
const quantityValue = document.getElementById('quantity-value');
const costValue = document.getElementById('cost-value');
const instructValue = document.getElementById('special-instructions-value');
const finalLocValue = document.getElementById('final-location-value');

let isConnected = false;
let provider;
let signer;

// Your contract setup can go here
// Mode contract address
const contractAddress = '0x1e173eB30E9d9B89756F1A6B0ECCb4cD9E36f667';
// Test contract address //0x37f015808b35fCf45D19781E96380E486B75Bc64
// const contractAddressTest = '0x37f015808b35fCf45D19781E96380E486B75Bc64';
// const abi = [];
// const providerContract = new ethers.Contract(contractAddressTest, abi, provider);
// const signerContract = new ethers.Contract(contractAddressTest, abi, signer);

let web3 = new Web3(window.ethereum)

const contract = new web3.eth.Contract(contractABI, contractAddress)






