// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';

contract Shipping is Ownable {

    enum Status {
        Pending,
        Shipping,
        Accepted,
        Rejected,
        Canceled
    }

    //Structs
    //a customized data structure for bill of lading
    struct Billoflanding {
        uint256 orderId;
        address senderOfGoods;
        address receiverOfBill;
        Status deliveryStatus; 
        Cargo[] cargoIds;
    }
    
    //a customized data structure for company
    // @name::string
    // @email::string      
    // @phoneno::uint256  
    // @website::string
    // @address::string  
    // Struct company{}
    // struct Company {
    //     string name;
    //     string email;
    //     uint256 phoneNo;
    //     string website;
    //     string companyAddress;
    // }

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

    //Events	
	//event to broadcast that cargo have been created
	event cargoCreated(address indexed _sender, address _receiver, string _material, uint256 _materialCount);
	//event to broadcast that cargo has been shipped
	event cargoShipped(address indexed _sender, string _specialInstructions, Status _deliveryStatus);
	//event to broadcast that cargo has been received
	event cargoReceived(address indexed _sender, string _specialInstructions, Status _deliveryStatus);
	//event to update that the order location has been updated
	event updatedLocation();
	//event to broadcast that a bill of lading has been created
	event billOfLandingCreated();
	//event to broadcast that a bill of lading has been updated
	event billOfLandingUpdated();
	//event to broadcast that payment has been made
	event payment();
	// 
	event itemShipped(address indexed _sender);

    //Variables
    /* address sender; //the msg.sender
    address receiver; //the receiver address
	string deliveryDestination; //the delivery destination of the order
	uint256 shippingCost; //the cost of shipping
	bool isShipped; //A boolean to check if the order has been shipped
	bool isReceived; //A boolean to check if the order has been received
    string currentLocation; //A boolean to get the currentLocation of the order */
    Cargo[] cargos;

    //Mappings

	//A mapping to return the past orderId of a company
	mapping(address  => uint256[]) private companyHistory;

	//A mapping to return the details of a companyData
	// mapping(address => Company) public companyInfo;
	
	//A mapping to return the order of a particular orderId ??
	// mapping(uint256 => Order) public orderId;
    mapping (uint256 => Billoflanding) public bolId;
    // mapping (uint256 => Cargo) public cargoId;
    mapping (address => mapping (uint256 => bool)) private SenderRole;
    mapping (address => mapping (uint256 => bool)) private ReceiverRole;

    //Modifiers
    modifier onlyReceiver(uint256 _cargoId) {
        require(ReceiverRole[msg.sender][_cargoId], "Address not Authorized Reciever for this CargoID");
        _;
    }

    modifier onlySender(uint256 _cargoId) {
        require(SenderRole[msg.sender][_cargoId], "Address not Authorized Sender for this CargoID");
        _;
    }

    // Constructor
    constructor() Ownable(msg.sender){
        
    }

    // Functions
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
        // Cargo memory newCargo = Cargo(_sender, _receiver, _material, materialCount, materialCost, _specialInstructions);
        // // emit cargoCreated(msg.sender);
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
    function updateLocation(string memory _currentLocation, uint256 _cargoId) external onlySender(_cargoId) {
        // call confirmReceipt function to see if the item has arrived or not

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
