pragma solidity ^0.8.0;

contract Storage{
    
    address public admin;
    
    struct Patient{
        string name;
        uint8 age;
        uint8 contactNo;
        uint256 aadhar;
        string permanentAddress;
    }
    uint256 public _patientCounter;
    mapping(address => uint256) private _patientIds;
    mapping(uint256 => Patient) private _patients;
    
    constructor (address _admin) {
        admin = _admin;
    }
    
    modifier onlyadmin() {
        require( msg.sender == admin, "Storage: admin function" );
        _;
    }
    
    modifier initialized() {
        require( admin != address(0), "Storage: contract not initialized" );
        _;
    }
        
    function registerPatient(string memory _name, uint8 _age,uint8 _contact,uint256 _aadhar, string memory _permanentAdd,address _patient) onlyadmin initialized public {
        _patientCounter++;
        Patient memory patient = Patient(_name, _age, _contact,_aadhar, _permanentAdd);
        _patientIds[_patient] = _patientCounter;
        _patients[_patientCounter] = patient;
    }
}