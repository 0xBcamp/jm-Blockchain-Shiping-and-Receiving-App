const ethers = require('ethers');
// import {ethers} from "ethers";
// import {abi} from '../..Shipping.json'
console.log("ethers: ", ethers);

console.log("step -1")
const connectBtn = document.getElementById('connect-btn');
const addressValue = document.getElementById('address-value')
const isConnectedValue = document.getElementById('is-connected-value');

console.log("step 0")
let isConnected = false;
let provider;

connectBtn.addEventListener('click', async () => {
    if (typeof window.ethereum !== 'undefined') {
        try {
            isConnectedValue.innerText = 'Loading...';
            // Request account access if needed
            console.log("step 1")
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            
            // Create a new Web3 provider
            console.log("step 2")
            provider = new ethers.BrowserProvider(window.ethereum);
            console.log(provider);
            
            console.log("step 3")
            const signer = await provider.getSigner();
            
            
            // Get the connected account address
            console.log("step 4")
            const address = await signer.getAddress();
            
            addressValue.innerText = `Address: ${address}`;
            isConnectedValue.innerText = 'Connected';
            isConnected = true;

            // Set the address value to local storage
            localStorage.setItem('userAddress', address);
            console.log("localStorage updated")

            console.log("step 5")
            // Your contract setup can go here
            const contractAddress = '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0';
            const abi = [ /* Your contract ABI here */ ];
            const providerContract = new ethers.Contract(contractAddress, abi, provider);
            const signerContract = new ethers.Contract(contractAddress, abi, signer);
            console.log("step 6")

        } catch (error) {
            console.error(error);
            isConnectedValue.innerText = `Error occurred: ${error.message}`;
            isConnected = false;
        }
    } else {
        alert('MetaMask is not installed. Please install it to use this app.');
    }
})



