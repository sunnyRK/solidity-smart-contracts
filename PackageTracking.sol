pragma solidity ^0.4.24;

contract PackageTracking {
    
    address Owner;
    
    struct package{
        bool isuidgenerated;
        uint itemid;
        string itemname;
        string transitstatus;
        uint orderstatus;
        address customer;
        uint ordertime;
        
        address carrier1;
        uint carrier1_time;
        
        address carrier2;
        uint carrier2_time;
        
        address carrier3;
        uint carrier3_time;
    }

    mapping (address => package) public packagemapping;
    mapping (address => bool) public carriers;
    
    constructor() {
        Owner = msg.sender;
    }
    
    modifier onlyOwner()
    {
        require(Owner == msg.sender);
        _;
    }
    
    function ManageCarriers(address _carrierAddress) onlyOwner public returns(string){
        if(!carriers[_carrierAddress]){
            carriers[_carrierAddress] = true;
        }else{
            carriers[_carrierAddress] = false;
        }
        return "carrier is updated";
    }
    
    
    
    function PackageOrder(uint _itemid,string _itemname) public returns (address){
        address uniqueId = address(sha256(msg.sender,now));
        packagemapping[uniqueId].isuidgenerated = true;
        packagemapping[uniqueId].itemid = _itemid;
        packagemapping[uniqueId].itemname = _itemname;
        packagemapping[uniqueId].transitstatus = "Your package is ordered and is under processing";
        packagemapping[uniqueId].orderstatus = 1;
        packagemapping[uniqueId].customer = msg.sender;
        packagemapping[uniqueId].ordertime = now;
        return uniqueId;
    }
    
    function CancelOrder(address _uniqueId) public returns (string){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(packagemapping[_uniqueId].customer == msg.sender);
        packagemapping[_uniqueId].orderstatus = 4;
        packagemapping[_uniqueId].transitstatus = "Your order has been canceled";
        return "Your order has been canceled succefully.";
    }
    
    function Carrier1Report(address _uniqueId,string _transitStatus){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 1);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier1 = msg.sender;
        packagemapping[_uniqueId].carrier1_time = now;
        packagemapping[_uniqueId].orderstatus = 2;
    }
    
     function Carrier2Report(address _uniqueId,string _transitStatus){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 2);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier2 = msg.sender;
        packagemapping[_uniqueId].carrier2_time = now;
        packagemapping[_uniqueId].orderstatus = 3;
    }
    
     function Carrier3Report(address _uniqueId,string _transitStatus){
        require(packagemapping[_uniqueId].isuidgenerated);
        require(carriers[msg.sender]);
        require(packagemapping[_uniqueId].orderstatus == 3);
        
        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier3 = msg.sender;
        packagemapping[_uniqueId].carrier3_time = now;
    }
}