// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Shipping {

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
        string destinationOfGoods;
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
        string sender;
        string receiver;
        string material;
        uint256 materialCount;
        uint256 materialCost;
        string specialInstructions;
        Status deliveryStatus;
    }

    //Events	
	//event to broadcast that cargo have been created
	event cargoCreated(address indexed _sender, string _receiver, string _material, uint256 _materialCount);
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
    address sender; //the msg.sender
    address receiver; //the receiver address
	string deliveryDestination; //the delivery destination of the order
	uint256 shippingCost; //the cost of shipping
	bool isShipped; //A boolean to check if the order has been shipped
	bool isReceived; //A boolean to check if the order has been received
    string currentLocation; //A boolean to get the currentLocation of the order
    Cargo[] cargos;

    //Mappings

	//A mapping to return the past orderId of a company
	mapping(address  => uint256[]) private companyHistory;

	//A mapping to return the details of a companyData
	// mapping(address => Company) public companyInfo;
	
	//A mapping to return the order of a particular orderId ??
	// mapping(uint256 => Order) public orderId;
    mapping (uint256 => Billoflanding) public bolId;
    mapping (uint256 => Cargo) public cargoId;

    //Modifiers
	modifier onlySender() {
        require(msg.sender == sender, "Only the sender can perform this action.");
        _;
    }

    modifier onlyReceiver() {
        require(msg.sender == receiver, "Only the receiver can perform this action.");
        _;
    }

    // Functions
    function registerCompany() public {}

    function addCargo(string memory _sender, 
                    string memory _receiver, 
                    string memory _material, 
                    uint256 materialCount, 
                    uint256 materialCost,
                    string memory _specialInstructions
                    
    ) public {
        Cargo memory newCargo = Cargo(_sender, _receiver, _material, materialCount, materialCost, _specialInstructions);
        // emit cargoCreated(msg.sender);
    }

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

    // function paymentSent() public {
    //     require(isReceived=true, "item has arrived at destination");
    //     require(address(this).balance >= paymentAmount, "Insufficient balance to make the payment"); 
    //     (bool success, ) = seller.call{value: shippingCost}(""); 
    //     require(success, "Payment transfer failed"); 
    //     emit PaymentSent();
        
    // }
}
