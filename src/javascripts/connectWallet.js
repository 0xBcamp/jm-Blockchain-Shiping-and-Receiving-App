// const ethers = require('ethers');
// const {abi} = require('../../contracts/artifacts/Shipping.json');
// console.log("ethers: ", ethers);
// console.log("abi: ", abi);

import contractABI from "../../contracts/artifacts/Shipping.json";

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
const contractAddressTest = '0x37f015808b35fCf45D19781E96380E486B75Bc64';
// const abi = [];
const providerContract = new ethers.Contract(contractAddressTest, abi, provider);
const signerContract = new ethers.Contract(contractAddressTest, abi, signer);


connectBtn.addEventListener('click', async () => {
    if (typeof window.ethereum !== 'null') {
        try {
            isConnectedValue.innerText = 'Loading...';
            // Request account access if needed
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            
            // Create a new Web3 provider
            provider = new ethers.BrowserProvider(window.ethereum);
            console.log(provider);

            signer = await provider.getSigner();
            
            // Get the connected account address
            const address = await signer.getAddress();
            
            addressValue.innerText = `${address.slice(0, 6)}...${address.slice(-4)}`;
            isConnectedValue.innerText = 'Connected';
            isConnected = true;

        } catch (error) {
            console.error(error);
            isConnectedValue.innerText = `Error occurred: ${error.message}`;
            isConnected = false;
        }
    } else {
        alert('MetaMask is not installed. Please install it to use this app.');
    }
})

submitCargoBtn.addEventListener('click', async() => {
    try {
        const contract = new ethers.Contract(contractAddressTest, abi, signer);
        console.log("senderValue: ", senderValue, "receiverValue: ", receiverValue);
        // const shippingContract = await ethers.getContractAt(
        //     "contracts/ShippingReceiving.sol",
        //     contractAddressTest,
        //     signer
        // )

        if(isConnected) {
            try {
                const createTransaction = await contract.addBillofLanding(
                    senderValue.value.trim(),
                    receiverValue.value.trim(),
                    currentLocValue.value.trim(),
                    materialValue.value.trim(),
                    parseInt(quantityValue.value.trim(), 10),
                    costValue.value.trim(),
                    instructValue.value.trim(),
                    finalLocValue.value.trim(),
                )
                const receipt = await createTransaction.wait();
                const id = receipt.events[0].args[0];
                console.log("receipt: ", receipt);
                console.log("id: ", id.toString());
                // const billofLanding = await contract.getBillOfLading();

            } catch(error){
                console.log("error creating bol: ", error);
            }
        } else {
            alert('please reconnect with your wallet');
            return;
        }

    } catch (error) {
        console.error('Error: ', error)
    }
});





