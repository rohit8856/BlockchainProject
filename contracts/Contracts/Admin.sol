pragma solidity ^0.8.0;

contract testing{
    
    
    mapping(address => labs) public LabsList;
    
     
	address public creatorAdmin;

	enum Type { User, Admin ,lab}
	enum State { NotExist, Pending, Approved, Rejected }
    
    
	struct UserDetail {
		uint userId;
		Type level;
		uint age;
		string permanentAddress;
		address useerad;
		uint createdAt;
		string pass;
		labs lab;
	}

 struct admin{
     uint userId;
     Type a;
     address main;
     uint time;
     string email;
     string pass;
 }
 
    struct labs{
        string name;
        uint256 no;
        address _labAddress;
        string desc;
        State s;
    }
    
    
    mapping(address => bool) public LabApproved;
	mapping (address => UserDetail) public userDetails;
	mapping( address => admin) public admins;
	mapping (uint => address) public userIds;



	event RequestedNewAdmin(address _newAdmin, uint256 _newAdminId);
	event RequestedNewUser(address _newUser, uint256 _newUserId);
	event ApprovedUser(address _approvedUser);

    //It will set the admin with default email and pass at deployment
	 constructor()  {
		creatorAdmin = msg.sender;
		userIds[1] = msg.sender;
		admins[msg.sender] = admin(1, Type.Admin, msg.sender ,block.timestamp,"SuperAdmin@gmail.com", '!@#$%^&*()');
	}
	
	
	
	// Check if the caller is a  Admin.
	modifier onlyAdmins() {
	    require(admins[msg.sender].a == Type.Admin);
	    require(admins[msg.sender].a == Type.Admin || creatorAdmin == msg.sender);
		require(msg.sender == creatorAdmin);
		_;
	}

	
	// Check if the user has already not been registered.
	// This is to avoid repeated requests to add the same user.
	modifier notRegisteredUser(address _newUser, uint _newUserId) {
		require(userIds[_newUserId] == address(0));
		require(userDetails[_newUser].useerad != msg.sender);
		_;
	}



	// Request to add new User.
	function PatientDetails(address _newUser, uint _newUserId, uint _age, string memory _pAddress, string memory _pass) public notRegisteredUser(_newUser, _newUserId) returns (bool success) {
		require(addNewUser(_newUser, _newUserId, Type.User, _age, _pAddress, _pass));
		RequestedNewUser(_newUser, _newUserId);
		return true;
	}

	// Common function to create entry in UserDetails Mapping.
	function addNewUser(address _userAddress, uint _userId, uint _age, string memory _pAddress, string memory _pass) internal returns (bool success) {
		userIds[_userId] = _userAddress;
		userDetails[_userAddress] = UserDetail(_userId, Type.User, _age, _pAddress, msg.sender, block.timestamp , _pass);
		return true;
	}

	// Approve pending requests.
	function approveUser(address _approvedUser) public returns (bool success) {
	  require(userDetails[_approvedUser].createdBy != msg.sender || creatorAdmin == msg.sender);
		userDetails[_approvedUser].state = State.Approved;
		userIds[userDetails[_approvedUser].userId] = _approvedUser;
		ApprovedUser(_approvedUser);
		return true;
	}

	// Get the User Details.
	function getUserDetails(address _userAddress) public  returns (uint, State, Type, uint, string memory) {
		UserDetail storage user = userDetails[_userAddress];
		return (user.userId, user.state, user.level, user.age, user.permanentAddress);
	}
}