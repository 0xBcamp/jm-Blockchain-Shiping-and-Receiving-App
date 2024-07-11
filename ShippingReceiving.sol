// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Shipping {
    //Structs

	//a customized data structure for bill of lading
	// @orderId::uint256
	// @senderofgoods::address1
	// @destinationofgoods 
	// @receiverofbill::address2
	// @contractStatus        
	// Struct bol{}
    struct Bol {
        uint256 orderId;
        address senderOfGoods;
        string destinationOfGoods;
        address receiverOfBill;
        bool contractStatus;
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

    //a customized data structure for order
    // @typesofgoods::string
    // @quantityofgoods::uint256
    // @specialInstructions::string
    // @liftgatefees::boolean
    // @paymentStatus::boolean
    // Struct order{}
    struct Order {
        string typeOfGoods;
        uint256 quantityOfGoods;
        string specialInstructions;
        bool liftGateFees;
        bool paymentStatus;
    }

    // a customized data structure for cargo
    // @sender::string
    // @receiver::string
    // @material::string
    // @materialCount::uint256
    // @materialCost::uint256
    struct Cargo {
        string sender;
        string receiver;
        string material;
        uint256 materialCount;
        uint256 materialCost;

    }

    //Events
	//event to broadcast that order have been created
	event orderCreated();
	//event to broadcast that order has been shipped
    event orderShipped();
    //event to broadcast that order has been received
    event orderReceived();
    //event to update that the order location has been updated
    event updatedLocation();
    //event to broadcast that a bill of lading has been created
    event billOfLadingCreated();
    //event to broadcast that a bill of lading has been updated
    event billOfLadingUpdated();
    //event to broadcast that payment has been made
    event payment();
    // 
    event itemShipped(address indexed sender);

    //Variables
    address sender; //the msg.sender
    address receiver; //the receiver address
	string deliveryDestination; //the delivery destination of the order
	uint256 shippingCost; //the cost of shipping
	bool isShipped; //A boolean to check if the order has been shipped
	bool isReceived; //A boolean to check if the order has been received
    string currentLocation; //A boolean to get the currentLocation of the order

    //Mappings

	//A mapping to return the past orderId of a company
	mapping(address  => uint256[]) private companyHistory;

	//A mapping to return the details of a companyData
	// mapping(address => Company) public companyInfo;
	
	//A mapping to return the order of a particular orderId ??
	mapping(uint256 => Order) public orderId;
    mapping (uint256 => Bol) public bolId;
    mapping (uint256 => Cargo) public cargoId;

    //Modifiers
	modifier onlySender() {
        require(msg.sender === sender, "Only the sender can perform this action.");
        _;
    }

    modifier onlyReceiver() {
        require(msg.sender === receiver, "Only the receiver can perform this action.");
        _;
    }

    // Functions
    function registerCompany() public {}

    function addCargo() public {}

    function shipmentDetails(uint256 _cargoId) public view returns(string memory _sender, string memory _receiver){
        Cargo memory cargo = cargoId[_cargoId];
        return (cargo.sender, cargo.receiver);
    }

    // To check the item's current location
    function updateLocation(string memory _currentLocation) private {
        // call confirmReceipt function to see if the item has arrived or not
    
    }

    // Checking if item has been shipped
    function shipItem() public {
        require(!isShipped, "Item has been shipped");
        isShipped = true;
        emit itemShipped(msg.sender);
    }

    // Checking if the receiver's item has arrived or not
    function confirmReceipt() public {
        // Might need currentLocaton to check if the item's currentLocation 
        // is the same as deliveryDestination

    }
}