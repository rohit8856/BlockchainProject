pragma solidity ^0.8.0;

import "./IStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Admin is Ownable
{    
   // mapping(address => labs) public LabsList;
    
	address public creatorAdmin;

	enum Type { Patient, Admin ,lab}
	enum State { NotExist, Pending, Approved, Rejected }
    
	struct PatientDetail {
		uint patientId;
		Type level;
		uint age;
		string permanentAddress;
		address useerad;
		uint createdAt;
		string pass;
		//Labs lab;
	}
	
	struct admin{
     uint patientId;
     Type a;
     address main;
     uint time;
     string email;
     string pass;
	 }

	  struct Labs{
        string name;
        uint256 no;
        address _labAddress;
        string desc;
      //  State s;
    }
 
    mapping(address => bool) public LabApproved;
	mapping (address => PatientDetail) public patientDetails;
	mapping( address => admin) public admins;
	mapping (uint => address) public patientIds;

	event RequestedNewAdmin(address _newAdmin, uint256 _newAdminId);
	event RequestedNewPatient(address _newPatient, uint256 _newPatientId);
	event ApprovedPatient(address _approvedPatient);

    //It will set the admin with default email and pass at deployment
	 constructor()  {
		creatorAdmin = msg.sender;
		patientIds[1] = msg.sender;
		admins[msg.sender] = admin(1, Type.Admin, msg.sender ,block.timestamp,"SuperAdmin@gmail.com", '!@#$%^&*()');
	}
	
	// Check if the caller is a  Admin.
	modifier onlyAdmins() {
	    require(admins[msg.sender].a == Type.Admin);
	    require(admins[msg.sender].a == Type.Admin || creatorAdmin == msg.sender);
		require(msg.sender == creatorAdmin);
		_;
	}
	
	// Check if the patient has already not been registered.
	// This is to avoid repeated requests to add the same patient.
	modifier notRegisteredPatient(address _newPatient, uint _newPatientId) {
		require(patientIds[_newPatientId] == address(0));
		require(patientDetails[_newPatient].useerad != msg.sender);
		_;
	}

	// Request to add new Patient.
	function PatientDetails(address _newPatient, uint _newPatientId, uint _age, string memory _pAddress, string memory _pass) public notRegisteredPatient(_newPatient, _newPatientId) returns (bool success) {
		require(addNewPatient(_newPatient, _newPatientId, Type.Patient, _age, _pAddress, _pass));
		RequestedNewPatient(_newPatient, _newPatientId);
		return true;
	}

	// Common function to create entry in PatientDetails Mapping.
	function addNewPatient(address _patientAddress, uint _patientId, uint _age, string memory _pAddress, string memory _pass) internal returns (bool success) {
		patientIds[_patientId] = _patientAddress;
		patientDetails[_patientAddress] = PatientDetail(_patientId, Type.Patient, _age, _pAddress, msg.sender, block.timestamp , _pass);
		return true;
	}

	// Get the Patient Details.
	function getPatientDetails(address _patientAddress) public  returns (uint, State, Type, uint, string memory) {
		PatientDetail storage patient = patientDetails[_patientAddress];
		return (patient.patientId, patient.state, patient.level, patient.age, patient.permanentAddress);
	}
	
//////////////////////////////register patient #prachi
function setStorage(IStorage _storage) onlyOwner external {
	require(_storage != IStorage(address(0)), "admin: storage cannot be zero");
	store = _storage;
}

    }
}