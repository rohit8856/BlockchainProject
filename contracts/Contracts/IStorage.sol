pragma solidity ^0.8.0;

interface IStorage {
    function setAdmin(address _admin) external;
    function registerPatient(string memory _name, uint8 _age, address _patient) external;  
    function getPatient(address _patient) external view returns(string memory name_, uint8 age_);
}