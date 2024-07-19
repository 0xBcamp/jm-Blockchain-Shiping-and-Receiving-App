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

    // enum TransactionRole{
    //     sender,
    //     receiver
    // }

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
    struct Billoflanding {
        address sender;
        address receiver;   
        string currentLocation;
        string material;
        uint256 materialCount;
        uint256 materialCost;
        string specialInstructions;
        string finalDestination;
        Status deliveryStatus;
    }

    // STRUCT CODE ENDS

    //ALL EVENTS 

	//event to broadcast that cargo have been created
	event cargoCreated(address indexed _sender, address _receiver, string _material, uint256 _materialCount);
	//event to broadcast that cargo has been shipped
	event cargoShipped(address indexed _sender, string _specialInstructions, Status _deliveryStatus);
	//event to broadcast that cargo has been received
	event cargoReceived(address indexed _sender, string _specialInstructions, Status _deliveryStatus);
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
    

    Billoflading[] bols;

    //VARIABLE CODE ENDS



    //ALL MAPPINGS

	//A mapping to return the transaction history of a particular company
    mapping(address =>mapping(TransactionRole => uint256[])) private companyTransactionHistory;

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

    modifier onlyTransactionParty(uint256 _cargoId){
        require(ReceiverRole[msg.sender][_cargoId])
        _;
    }

    // MODIFIER CODE BLOCK ENDS

    // CONSTRUCTOR 

    constructor() Ownable(msg.sender){
        status = Status.Pending;
        
    }

    // ALL FUNCTIONS

    // payment related function  

    function payment(uint256 _amount) payable {


    }

    function widthdrawal(uint256 _amount) payable{

    }

    function fallback() payable{

    }

    function receive() payable{

    }


    function addReceiverRole(address roleRecipient, uint256 roleCargoId) internal onlyOwner returns(bool){
        ReceiverRole[roleRecipient][roleCargoId] = true;
        return ReceiverRole[roleRecipient][roleCargoId];
    }

    function addSenderRole(address roleRecipient, uint256 roleCargoId) internal onlyOwner returns(bool){
        SenderRole[roleRecipient][roleCargoId] = true;
        return SenderRole[roleRecipient][roleCargoId];
    }

    function shipCargo(uint256 _bolId) external onlySender(_bolId) returns(Status){
        require(bols[_bolId].deliveryStatus == status, "Delievery status must be in Pending state to ship");
        bols[_bolId].deliveryStatus = Status.Shipping;
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
        return bols[_bolId].deliveryStatus;
    }

    function cancelCargo(uint256 _bolId) external onlyReceiver(_bolId) returns(Status){
        require(bols[_bolId].deliveryStatus != Status.Accepted || bols[_bolId].deliveryStatus != Status.Rejected, "Delievery cannot be accepted or rejected in order to cancel");
        require(keccak256(abi.encodePacked(bols[_bolId].finalDestination)) != keccak256(abi.encodePacked(bols[_bolId].currentLocation)), "Current location of cargo cannot be at final destination to cancel");
        bols[_bolId].deliveryStatus = Status.Canceled;
        return bols[_bolId].deliveryStatus;
    }

    function registerCompany(string _name, 
            string _email, 
            string _phoneNo,
            string _website,
            string _companyaddress
             ) public {

              Company memory company = new Company(_name, _email, _phoneNo, _website, _companyaddress)

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
        Billoflanding memory newBol = Billoflanding({
            sender: _sender,
            receiver: _receiver,
            currentLocation: _currentLocation,
            material: _material,
            materialCount: _materialCount,
            materialCost: _materialCost,
            specialInstructions: _specialInstructions,
            finalDestination: _finalDestination,
            deliveryStatus: Status.Pending
        });

        bols.push(newBol);
        uint256 cargoId = bols.length - 1;

        addSenderRole(newBol.sender, cargoId);
        addReceiverRole(newBol.receiver, cargoId);

        emit cargoCreated(newBol.sender, newBol.receiver, newBol.material, newBol.materialCount);

        return cargoId;
    }

    // function shipmentDetails(uint256 _cargoId) public view returns(string memory _sender, string memory _receiver){
    //     Cargo memory cargo = cargoId[_cargoId];
    //     return (cargo.sender, cargo.receiver);
    // }

    // To check the item's current location
    function updateLocation(string memory _currentLocation, uint256 _cargoId) external onlySender(_cargoId){
        require(bols[_cargoId].deliveryStatus == Status.Shipping, "Delievery status must be in Pending state to ship");
        bols[_cargoId].currentLocation = _currentLocation;
        emit updatedLocation(msg.sender, bols[_cargoId].currentLocation, bols[_cargoId].finalDestination);
    }

    // Checking if item has been shipped
    // function shipItem() public {
    //     require(!isShipped, "Item has been shipped");
    //     isShipped = true;
    //     emit itemShipped(msg.sender);
    // }

    // Checking if the receiver's item has arrived or not
    function confirmReceipt() public {
        // Might need currentLocaton to check if the item's currentLocation 
        // is the same as deliveryDestination

    }

    //Updating Status Enums for cargo structs and BOL


    // function paymentSent() public {
    //     require(isReceived=true, "item has arrived at destination");
    //     require(address(this).balance >= paymentAmount, "Insufficient balance to make the payment"); 
    //     (bool success, ) = seller.call{value: shippingCost}(""); 
    //     require(success, "Payment transfer failed"); 
    //     emit PaymentSent();
        
    // }



    // RETURN FUNCTIONS

    function getBillOfLading(_id) public pure returns (memory   Billoflading){
        return bolId[_id];


    }

    function getLatestLocation(uint256 _id) public pure returns (memory string){
        return location[_id];
    }


}
