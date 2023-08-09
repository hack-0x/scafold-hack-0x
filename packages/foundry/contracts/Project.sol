// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "./interfaces/IUserRegistry.sol";
import "./Attestter.sol";

struct ProjectData {
    string name;
    string description;
    string[] skillsNeeded;
    bool searchingFunding;
    address userContract;
    uint256 fundingGoal;
    uint256 fundedAmount;
}

contract Project {
    ProjectData ProjectInfo;

    address private owner;
    IUserRegistry private userContract;
    address[] private teamMembers;
    address[] private investors;
    mapping(address => uint256) private investorAmounts;

    mapping(address => bool) private managers;

    error Project__NotOwner();
    error Project__NotManager();
    error Project__NotDaoUser();

    modifier onlyUser(address user) {
        IUserRegistry(user).isUser(user);
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Project__NotOwner();
        }
        _;
    }

    modifier onlyManagers() {
        if (msg.sender != owner || managers[msg.sender] != true) {
            revert Project__NotManager();
        }
        _;
    }

    // @dev This constructor is called by ProjectFactory
    constructor(address _owner, ProjectData memory _projectData) {
        owner = _owner;
        userContract = IUserRegistry(_projectData.userContract);
    }

    function invest(uint256 amount) public payable {
        investors.push(msg.sender);
        investorAmounts[msg.sender] = amount;
        ProjectInfo.fundedAmount += msg.value;
    }

    function proposeInvestment(uint256 amount) {
        managers[manager] = true;
    }

    /*
     *   Utility Functions
     */

    /*
     *   Getter Functions
     */

    function getFundGoal() public view returns (uint256) {
        return ProjectInfo.fundingGoal;
    }

    function getTeamMembers() public view returns (address[] memory) {
        return teamMembers;
    }

    function getInvestors() public view returns (address[] memory) {
        return investors;
    }

    function getFundedAmount() public view returns (uint256) {
        return ProjectInfo.fundedAmount;
    }
}
