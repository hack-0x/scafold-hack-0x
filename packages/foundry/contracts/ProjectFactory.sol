// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "./Project.sol";
import "./interfaces/IUserRegistry.sol";

struct ProjectData {
    string name;
    string description;
    string[] rolesNeeded;
    bool searchingFunding;
    uint256 fundingGoal;
    address userContract;
}

contract ProjectFactory {
    modifier onlyUser(address user) {
        IUserRegistry(user).isUser(user);
        _;
    }

    event ProjectCreated(address indexed project, address indexed owner);

    function createProject() public onlyUser(msg.sender) {
        /// @dev the constructor of Project needs to be passed two arguments:
        /// @param _owner the address of the owner of the project
        /// @param _projectData the data of the project
        Project project = new Project(_projectData);

        emit ProjectCreated(address(project), msg.sender);

        // return address(project);
    }
}
