// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract CrowdFund {
    // Mapping for the contributors of the crowdfund
    // Address of contributor mapped to the amount
    mapping(address => uint256) public contributors;
    // Address of the manager of the crowdfund
    address public manager;
    // The count of contributors for the project
    uint256 public noOfContributors;

    // The project structure consisting of different variables in a struct
    // description : The description of the project
    // value : The amount that is required to fund this project
    // completed : The status of the project
    // noOfVoters : The number of voters voted to fund the project
    // Mapping of the voters address and vote , false by default, true if voted
    struct Project {
        string description;
        address payable recipient;
        uint256 goalAmount;
        uint256 raisedAmount;
        bool completed;
    }

    // Mapping of the projects variable to different Projects
    mapping(uint256 => Project) public projects;
    // Number of projects in the crowdfund
    uint256 public numProjects;

    // Constructor to set the goalAmount to be raised
    constructor() {
        manager = msg.sender;
    }

    //this function helps the users to transfer eth directly to the smartcontract
    receive() external payable {}

    event amountContributed(address sender, uint256 amount);

    event fundBalance(uint256 amount);

    event createdProject(
        string description,
        address recipient,
        uint256 goalAmount
    );

    event madePayment(uint256 projectNo);

    event refundMade(address receiver, uint256 refundAmount);

    // modifier to only allow manager to call some functions
    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    // function to create projects
    function createProject(
        string memory _description,
        address payable _recipient,
        uint256 _goalAmount
    ) public onlyManager {
        emit createdProject(_description, _recipient, _goalAmount);
        Project storage newProject = projects[numProjects];
        numProjects++;
        newProject.description = _description;
        newProject.recipient = _recipient;
        newProject.goalAmount = _goalAmount;
        newProject.completed = false;
        newProject.raisedAmount = 0;
    }

     // function to send ethers to the contract
    function contributeToProject(uint256 _projectNo) public payable {
        Project storage thisProject = projects[_projectNo];
        require(
            msg.value <= (thisProject.goalAmount - thisProject.raisedAmount),
            "Amount is greater than required amount, kindly reduce the value"
        );
        emit amountContributed(msg.sender, msg.value);
        emit fundBalance(address(this).balance);
        if (contributors[msg.sender] == 0) {
            noOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        thisProject.raisedAmount += msg.value;
    }

    // function to get balance of the contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // function to make payment to the project receipent
    function makePayment(uint256 _projectNo) public onlyManager {
        Project storage thisProject = projects[_projectNo];
        require(thisProject.raisedAmount >= thisProject.goalAmount);
        require(thisProject.completed == false, "Request has been completed");
        emit madePayment(_projectNo);
        thisProject.recipient.transfer(thisProject.goalAmount);
        thisProject.completed = true;
    }

    // function to process refund for the contributors if conditions are met
    function refund(uint256 _projectNo) public {
        Project storage thisProject = projects[_projectNo];
        require(
            thisProject.raisedAmount < thisProject.goalAmount,
            "You are not eligible for refund"
        );
        require(contributors[msg.sender] > 0, "You have alredy been refunded");
        address payable user = payable(msg.sender);
        emit refundMade(user, contributors[msg.sender]);
        user.transfer(contributors[msg.sender]);
        thisProject.raisedAmount -= contributors[msg.sender];
        noOfContributors--;
        contributors[msg.sender] = 0;
    }
}
