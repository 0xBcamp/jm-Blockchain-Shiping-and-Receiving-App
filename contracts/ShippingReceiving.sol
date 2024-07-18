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

    enum TransactionRole{
        sender,
        receiver
    }

    // ENUM CODE ENDS

    //ALL STRUCTS

    //a customized data structure for bill of lading
    struct Billoflanding {
        uint256 orderId;
        address senderOfGoods;
        address receiverOfBill;
        Status deliveryStatus; 
        Cargo[] cargoIds;
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
    struct Cargo {
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
    /* address sender; //the msg.sender
    address receiver; //the receiver address
	string deliveryDestination; //the delivery destination of the order
	uint256 shippingCost; //the cost of shipping
	bool isShipped; //A boolean to check if the order has been shipped
	bool isReceived; //A boolean to check if the order has been received
    string currentLocation; //A boolean to get the currentLocation of the order */
    Status status;
    Cargo[] cargos;

    //VARIABLE CODE ENDS



    //ALL MAPPINGS

	//A mapping to return the transaction history of a particular company
	mapping(address  =>(mapping(TransactionRole senderRole => uint256[]),
    mapping(TransactionRole receiver => uint256[]))) private companyTransactionHistory;

	//A mapping to return the details of a companyData
	mapping(address => Company) public companyInfo;
	
	//A mapping to return the Cargo and it BillofLading for a particular orderId ??
	mapping(uint256 => (Cargo, Billoflading)) public orderId;

    // A mapping to return the bill of landing Id
    mapping (uint256 => Billoflanding) public bolId;

    mapping (address => mapping (uint256 => bool)) private SenderRole;
    mapping (address => mapping (uint256 => bool)) private ReceiverRole;

    // MAPPINGS CODE BLOCKS ENDS

    //ALL MODIFIERS
    modifier onlyReceiver(uint256 _cargoId) {
        require(ReceiverRole[msg.sender][_cargoId], "Address not Authorized Reciever for this CargoID");
        _;
    }

    modifier onlySender(uint256 _cargoId) {
        require(SenderRole[msg.sender][_cargoId], "Address not Authorized Sender for this CargoID");
        _;
    }

    // MODIFIER CODE BLOCK ENDS

    // CONSTRUCTOR 

    constructor() Ownable(msg.sender){
        status = Status.Pending;
        
    }

    // ALL FUNCTIONS 

    function payment() payable {

    }

    function widthdrawal() payable{

    }


    function addReceiverRole(address roleRecipient, uint256 roleCargoId) internal onlyOwner returns(bool){
        ReceiverRole[roleRecipient][roleCargoId] = true;
        return ReceiverRole[roleRecipient][roleCargoId];
    }

    function addSenderRole(address roleRecipient, uint256 roleCargoId) internal onlyOwner returns(bool){
        SenderRole[roleRecipient][roleCargoId] = true;
        return SenderRole[roleRecipient][roleCargoId];
    }

    function shipCargo(uint256 _cargoId) external onlySender(_cargoId) returns(Status){
        require(cargos[_cargoId].deliveryStatus == Status.Pending, "Delievery status must be in Pending state to ship");
        cargos[_cargoId].deliveryStatus = Status.Shipping;
        return cargos[_cargoId].deliveryStatus;
    }

    function acceptCargo(uint256 _cargoId) external onlyReceiver(_cargoId) returns(Status){
        require(cargos[_cargoId].deliveryStatus == Status.Shipping, "Delievery status must be in Shipping state to ship");
        require(keccak256(abi.encodePacked(cargos[_cargoId].finalDestination)) == keccak256(abi.encodePacked(cargos[_cargoId].currentLocation)), "Current location of cargo must be at final destination to accept");
        cargos[_cargoId].deliveryStatus = Status.Accepted;
        return cargos[_cargoId].deliveryStatus;
    }

    function rejectCargo(uint256 _cargoId) external onlyReceiver(_cargoId) returns(Status){
        require(cargos[_cargoId].deliveryStatus == Status.Shipping, "Delievery status must be in Shipping state to ship");
        require(keccak256(abi.encodePacked(cargos[_cargoId].finalDestination)) == keccak256(abi.encodePacked(cargos[_cargoId].currentLocation)), "Current location of cargo must be at final destination to reject");
        cargos[_cargoId].deliveryStatus = Status.Rejected;
        return cargos[_cargoId].deliveryStatus;
    }

    function cancelCargo(uint256 _cargoId) external onlyReceiver(_cargoId) returns(Status){
        require(cargos[_cargoId].deliveryStatus != Status.Accepted || cargos[_cargoId].deliveryStatus != Status.Rejected, "Delievery cannot be accepted or rejected in order to cancel");
        require(keccak256(abi.encodePacked(cargos[_cargoId].finalDestination)) != keccak256(abi.encodePacked(cargos[_cargoId].currentLocation)), "Current location of cargo cannot be at final destination to cancel");
        cargos[_cargoId].deliveryStatus = Status.Canceled;
        return cargos[_cargoId].deliveryStatus;
    }

    function registerCompany() public {}

    function addCargo(address _sender, 
                    address _receiver, 
                    string memory _currentLocation,
                    string memory _material, 
                    uint256 _materialCount, 
                    uint256 _materialCost,
                    string memory _specialInstructions,
                    string memory _finalDestination               
    ) external returns(uint256){
        Cargo memory newCargo = Cargo({
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

        cargos.push(newCargo);
        uint256 cargoId = cargos.length - 1;

        addSenderRole(newCargo.sender, cargoId);
        addReceiverRole(newCargo.receiver, cargoId);

        emit cargoCreated(newCargo.sender, newCargo.receiver, newCargo.material, newCargo.materialCount);

        return cargoId;
    }

    // function shipmentDetails(uint256 _cargoId) public view returns(string memory _sender, string memory _receiver){
    //     Cargo memory cargo = cargoId[_cargoId];
    //     return (cargo.sender, cargo.receiver);
    // }

    // To check the item's current location
    function updateLocation(string memory _currentLocation, uint256 _cargoId) external onlySender(_cargoId){
        require(cargos[_cargoId].deliveryStatus == Status.Shipping, "Delievery status must be in Pending state to ship");
        cargos[_cargoId].currentLocation = _currentLocation;
        emit updatedLocation(msg.sender, cargos[_cargoId].currentLocation, cargos[_cargoId].finalDestination);
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
}
