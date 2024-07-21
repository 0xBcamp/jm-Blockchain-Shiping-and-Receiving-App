// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';

// 0x37f015808b35fCf45D19781E96380E486B75Bc64

contract Shipping is Ownable {

    // ALL ENUMS
    enum Status {
        Pending,
        Shipping,
        Accepted,
        Rejected,
        Canceled
    }

    enum Authorization{
        Sender,
        Receiver
    }

     enum TransactionRole {
        sender,
        receiver
    }

    // ENUM CODE ENDS

    //ALL STRUCTS

    //a customized data structure for bill of lading
    struct Cargo {
        uint256 orderId;
        address senderOfGoods;
        address receiverOfBill;
        Status deliveryStatus; 
        uint256[] bolIDs;
    }
    
    //a customized data structure for company
    struct Company {
        string name;
        string email;
        uint256 phoneNo;
        string website;
        string companyAddress;
    }

    // a customized data structure for cargo
    struct Billoflading {
        address sender;
        address receiver;   
        string currentLocation;
        string material;
        uint256 materialCount;
        uint256 materialCost;
        string specialInstructions;
        string finalDestination;
        Status deliveryStatus;
        Authorization authorizedOwner;
    }

    // STRUCT CODE ENDS

    //ALL EVENTS 

	//event to broadcast that cargo have been created
	event cargoCreated(address indexed _sender, address _receiver, string _material, uint256 _materialCount);
	//event to broadcast that cargo has been shipped
	event cargoShipped(address indexed _sender, string _specialInstructions, Status _deliveryStatus);
	//event to broadcast that cargo has been received
	event cargoReceived(address indexed _sender, string _specialInstructions, Status _deliveryStatus);
    // event to broadcast that cargo has been rejected
    event rejectedCargo(uint256 _cargoId);
    // event to update that the cargo was cancelled
    event cancelledCargo(uint256 _cargoId);
	//event to update that the order location has been updated
	event updatedLocation(address indexed _sender, string _currentLocation, string _finalDestination);
	//event to broadcast that a bill of lading has been created
	event billOfLandingCreated(uint256 _orderId);
	//event to broadcast that a bill of lading has been updated
	event billOfLandingUpdated(uint256 _orderId);
	//event to broadcast that payment has been made
	event payment(address _sender, address _receiver, uint256 _orderId);
    
    //event to braodcast that widthdrawal is made
    event withdrawal(address _owner);


    //EVENT CODE ENDS

    //ALL VARIABLES
    TransactionRole senderRole = TransactionRole.sender;
    TransactionRole receiverRole = TransactionRole.receiver;
    
    //cargo array variable
    Cargo[] cargo;

    Billoflading[] bols;

    //VARIABLE CODE ENDS



    //ALL MAPPINGS

	//A mapping to return the transaction history of a particular company
    mapping(address => mapping(TransactionRole => uint256[])) private companyTransactionHistory;

	//A mapping to return the details of a companyData
	mapping(address => Company) public companyInfo;
	
	//A mapping to return the Cargo and it BillofLading for a particular orderId ??
	mapping(uint256 => Cargo) public orderId;

    // A mapping to return the bill of landing Id
    mapping(uint256 => Billoflading) public bolId;
    
    //A mapping to return the location of the cargo
    mapping(uint256 => string) public location;

    mapping (address => mapping (uint256 => bool)) private SenderRole;
    mapping (address => mapping (uint256 => bool)) private ReceiverRole;

    // A mapping to return the company transporting the goods
    mapping(uint256 => address) public transporter;

    // A mapping for payments in the contract
    mapping(address => uint256) private accounts;

    // MAPPINGS CODE BLOCKS ENDS


    //ALL MODIFIERS
    modifier onlyReceiver(uint256 _bolId) {
        require(ReceiverRole[msg.sender][_bolId], "Address not Authorized Reciever for this Bill of Landing ID");
        _;
    }

    modifier onlySender(uint256 _bolId) {
        require(SenderRole[msg.sender][_bolId], "Address not Authorized Sender for this Bill of Landing ID");
        _;
    }

    modifier onlyTransporter(uint256 _cargoId){
        require(msg.sender == transporter[_cargoId]);
        _;
    }

    // MODIFIER CODE BLOCK ENDS

    // CONSTRUCTOR 

    constructor() Ownable(msg.sender){
        
        
    }

    // ALL FUNCTIONS

    // payment related function  

    function fundMe() public payable{
        require(msg.value > 0, "This fund amount isn't enough");

        accounts[msg.sender] += msg.value;

    }

    function transferAmount(uint256 _bolId) public payable onlyReceiver(_bolId) {
        require(msg.value >= bolId[_bolId].materialCost, "The payment amount isn't enough");

        ( bool callSuccess,) = payable(msg.sender).call{value: bolId[_bolId].materialCost}("");
        require(callSuccess, "Transaction Failed");

        accounts[bolId[_bolId].sender] += bolId[_bolId].materialCost;
        bolId[_bolId].authorizedOwner = Authorization.Receiver;

        confirmReceipt(msg.sender, bolId[_bolId].receiver, _bolId);




    }

    function widthdrawAmount(uint256 _amount) public payable{
        require(address(this).balance >= accounts[msg.sender], "The contract doesn't have enought liquidity");
        require(accounts[msg.sender] >= _amount, "The amount you want to redraw is more than the amount you have");

        accounts[msg.sender] -= _amount;

        ( bool callSuccess,) = payable(address(this)).call{value: _amount}("");

        require(callSuccess, "The withdrawal of amount failed");


    }

    
    // Custom Error functions 
    receive() external payable{
        fundMe();
    }
    fallback() external payable{
        fundMe();

    }

    // Custom Error function ends



    // Shipping Functions Begins
    function addReceiverRole(address roleRecipient, uint256 roleCargoId) internal onlyOwner returns(bool){
        ReceiverRole[roleRecipient][roleCargoId] = true;
        return ReceiverRole[roleRecipient][roleCargoId];
    }

    function addSenderRole(address roleRecipient, uint256 roleCargoId) internal onlyOwner returns(bool){
        SenderRole[roleRecipient][roleCargoId] = true;
        return SenderRole[roleRecipient][roleCargoId];
    }

    function shipCargo(uint256 _bolId, address _transporter) external onlySender(_bolId) returns(Status){
        require(bols[_bolId].deliveryStatus == Status.Pending, "Delievery status must be in Pending state to ship");
        bols[_bolId].deliveryStatus = Status.Shipping;
        transporter[_bolId] = _transporter;

        
        return bols[_bolId].deliveryStatus;
    }

    function acceptCargo(uint256 _bolId) external onlyReceiver(_bolId) returns(Status){
        require(bols[_bolId].deliveryStatus == Status.Shipping, "Delievery status must be in Shipping state to ship");
        require(keccak256(abi.encodePacked(bols[_bolId].finalDestination)) == keccak256(abi.encodePacked(bols[_bolId].currentLocation)), "Current location of cargo must be at final destination to accept");
        bols[_bolId].deliveryStatus = Status.Accepted;

        return bols[_bolId].deliveryStatus;
    }

    function rejectCargo(uint256 _bolId) external onlyReceiver(_bolId) returns(Status){
        require(bols[_bolId].deliveryStatus == Status.Shipping, "Delievery status must be in Shipping state to ship");
        require(keccak256(abi.encodePacked(bols[_bolId].finalDestination)) == keccak256(abi.encodePacked(bols[_bolId].currentLocation)), "Current location of cargo must be at final destination to reject");
        bols[_bolId].deliveryStatus = Status.Rejected;

        emit rejectedCargo(_bolId);
        return bols[_bolId].deliveryStatus;
    }

    function cancelCargo(uint256 _bolId) external onlyReceiver(_bolId) returns(Status){
        require(bols[_bolId].deliveryStatus != Status.Accepted || bols[_bolId].deliveryStatus != Status.Rejected, "Delievery cannot be accepted or rejected in order to cancel");
        require(keccak256(abi.encodePacked(bols[_bolId].finalDestination)) != keccak256(abi.encodePacked(bols[_bolId].currentLocation)), "Current location of cargo cannot be at final destination to cancel");
        bols[_bolId].deliveryStatus = Status.Canceled;

        emit cancelledCargo(_bolId);
        return bols[_bolId].deliveryStatus;
    }

    function registerCompany(string memory _name, 
            string memory _email, 
            uint256 _phoneNo,
            string memory _website,
            string memory _companyaddress
             ) public {

              Company memory company = Company({
                name: _name,
                email: _email,
                phoneNo: _phoneNo,
                website: _website,
                companyAddress: _companyaddress
              });

              companyInfo[msg.sender] = company;


    }

    function addBillofLanding(address _sender, 
                    address _receiver, 
                    string memory _currentLocation,
                    string memory _material, 
                    uint256 _materialCount, 
                    uint256 _materialCost,
                    string memory _specialInstructions,
                    string memory _finalDestination               
    ) external returns(uint256){
        Billoflading memory newBol = Billoflading({
            sender: _sender,
            receiver: _receiver,
            currentLocation: _currentLocation,
            material: _material,
            materialCount: _materialCount,
            materialCost: _materialCost,
            specialInstructions: _specialInstructions,
            finalDestination: _finalDestination,
            deliveryStatus: Status.Pending,
            authorizedOwner: Authorization.Sender
        });

        bols.push(newBol);
        uint256 cargoId = bols.length - 1;

        addSenderRole(newBol.sender, cargoId);
        addReceiverRole(newBol.receiver, cargoId);

        emit cargoCreated(newBol.sender, newBol.receiver, newBol.material, newBol.materialCount);

        return cargoId;
    }

   
    function updateLocation(string memory _currentLocation, uint256 _cargoId) external onlyTransporter(_cargoId){
        require(bols[_cargoId].deliveryStatus == Status.Shipping, "Delievery status must be in Pending state to ship");
        bols[_cargoId].currentLocation = _currentLocation;
        emit updatedLocation(msg.sender, bols[_cargoId].currentLocation, bols[_cargoId].finalDestination);
    }

    
    function confirmReceipt(address _sender, address _receiver, uint256 _bolId) private {
        emit payment( _sender, _receiver, _bolId);
    }

    


    



    // RETURN FUNCTIONS

    function getBillOfLading(uint256 _id) public view returns (Billoflading memory){
        return bolId[_id];


    }

    function getLatestLocation(uint256 _id) public view returns (string memory){
        return location[_id];
    }


}
