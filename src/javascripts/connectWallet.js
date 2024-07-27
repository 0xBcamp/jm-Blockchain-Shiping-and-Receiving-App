// const ethers = require('ethers');
// const {abi} = require('../../contracts/artifacts/Shipping.json');
// console.log("ethers: ", ethers);
// console.log("abi: ", abi);
const contractABI = require("../shippingabi.json")


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

async function connectWallet() {
    if (window.ethereum) {
        const accounts = await window.ethereum.request({ method: "eth_requestAccounts" })
            .then((result) => {
                if (wallet.code == "4001") {
                    console.log("Please connect your wallet")
                } else {
                    console.log(wallet)
                    setConnected(wallet[0])

                }
            })
        
    } else {
    console.error("No web3 provider detected");
    document.getElementById("connectMessage").innerText =
      "No web3 provider detected. Please install MetaMask.";
  }
}


// function to transfer amount to pay for goods
async function transferAmount(amount) {
    
}


// function to withdraw money paid from a successful delivery
async function widthrawAmount(amount) {
    
}


/*A function to ship your cargo by allowing the transporting company to have authority to update the cargo location */
async function shipCargo(boldId, transportCompanyAddress) {
    
}


// Function to register your company on the blockchain
async function registerCompany(name, email, phoneNo, website, companyAddress) {
    
}


// Function to generate BillofLading for the transaction on blockchain
async function addBillofLading(sender, receiver, currentLocation, material, 
    materialCount, materialCost, specialInstruction, finalDestination) {
    
    }





// FUNCTIONS TO RETURN SHIPPING DATA IN BLOCKCHAIN
    

// Function to return the billofLading for a particular cargo
async function getBillofLading(shippingId) {
    
}

// Function to get the loationId for a cargo
async function getLatestLocation(locationId) {
    
}



// FUNCTIONS TO CHANGE COMPONENTS

function shortAddress(address, startLength = 6, endLength = 4) {
    return `${address.slice(0, startLength)}...${address.slice(-endLength)}}`;
    
}

function setConnected(address) {
    document.getElementById("connect-btn").innerText = 
        "Connected:" + shortAddress(address)
}





// IMPLEMENTATION CODE

document.querySelector(".connect-btn").addEventListener('click', function () {
    console.log("button clicked")
})





