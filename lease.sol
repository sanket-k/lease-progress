/**
 *                                  Lease - Smart Contract
 *          1. Contract Initializer has admin access 
 *          2. Only admin can add an Issuer
 *          3. Only Issuer can sign a lease
 *          4. Any one can make a lease
 *          5. Currently a lease is between two people/entity
**/

pragma solidity ^0.4.11;

contract leaseIssue {
    address admin;         //user with higest rights
    
    //stores all values of an Issuer using an unique identifier (here it is the address of the issuer)
    struct IssuerInformation{
        string IssuerNmae;
        string IssuerDetails;
        address IssuerAddress;
    }
    
    //stores all values of a lease using a specific identifier 
    struct lesseInformation{
        string from;
        address fromAddress;
        string to;
        address toAddress;
        string addenda;
        string date;
        bool IssuerState1;
        bool IssuerState2;
        bool IssuerState3;
        address Issuer1Address;
        address Issuer2Address;
        address Issuer3Address;
    }
    
    mapping (address => IssuerInformation) IssuerInfo;      // maps to the structs using a specific identifier (here it is address)
    
    mapping (bytes32 => lesseInformation) leaseInfo;                       // maps to the structs using a specific identifier (here it is bytes32 or UIN)    
    
    //Constructor(to initialize admin)
    function leaseIssue() public{
        admin = msg.sender;
    }
    
    //Modifier to allow only admin to certain sections of code
    modifier OnlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    
    //Modifier to allow only an Issuer to some sections of the code
    modifier OnlyIssuer(){
        require(msg.sender == IssuerInfo[msg.sender].IssuerAddress);
        _;
    }
    
    function compare(bytes32 _UIN) external returns(bool){
        if(IssuerInfo[_UIN].IssuerState1 == true && IssuerInfo[_UIN].IssuerState2 == true){
            return(true);
        }
    }
    
    // modifier approvedTrue(){
    //     require(IssuerState1)
    // }

    
    //function to add issuer who issues the lease
    function addIssuer(address _address,
                        string _IssuerNmae,
                        string _IssuerDetails)external OnlyAdmin returns(bool){
                            
        IssuerInfo[_address].IssuerNmae = _IssuerNmae;
        IssuerInfo[_address].IssuerDetails = _IssuerDetails;
        IssuerInfo[_address].IssuerAddress = _address;
    }
    
    //function to display the issuer details(name and details)
    function IssuerInfoDetails(address _address) external constant returns(string, string){
        return(
                IssuerInfo[_address].IssuerNmae,
                IssuerInfo[_address].IssuerDetails);
    }
    
    //function to make a lease between two entities 
    function makeLease(bytes32 _UIN,
                        string _from,
                        string _to,
                        address _toAddress,
                        string _addenda,
                        string _date) external returns(bool){
        leaseInfo[_UIN].from = _from;
        leaseInfo[_UIN].fromAddress = msg.sender;
        leaseInfo[_UIN].to = _to;
        leaseInfo[_UIN].toAddress = _toAddress;
        leaseInfo[_UIN].addenda = _addenda;
        leaseInfo[_UIN].date = _date;
    }
    
    function approve1(bytes32 _UIN) OnlyIssuer external returns(bool) {
        leaseInfo[_UIN].IssuerState1 = true;
        leaseInfo[_UIN].Issuer1Address = msg.sender;
    }
    
    function approve2(bytes32 _UIN) OnlyIssuer external returns(bool) {
        leaseInfo[_UIN].IssuerState2 = true;
        leaseInfo[_UIN].Issuer2Address = msg.sender;
    }
    
    function approve3(bytes32 _UIN) OnlyIssuer external returns(bool) {
        leaseInfo[_UIN].IssuerState3 = true;
        leaseInfo[_UIN].Issuer3Address = msg.sender;
    }
    
    //function to display the nature of the lease
    function displayLease(bytes32 _UIN) external constant returns(string,
                                                                  address,
                                                                  string,
                                                                  address,
                                                                  string,
                                                                  string) {
        return(
                leaseInfo[_UIN].from,
                leaseInfo[_UIN].fromAddress,
                leaseInfo[_UIN].to,
                leaseInfo[_UIN].toAddress,
                leaseInfo[_UIN].addenda,
                leaseInfo[_UIN].date);
    }
    
    function displayApproved(bytes32 _UIN) external constant returns(address, address, address) {
        return(
                leaseInfo[_UIN].Issuer1Address,
                leaseInfo[_UIN].Issuer2Address,
                leaseInfo[_UIN].Issuer3Address);
    }
    
}