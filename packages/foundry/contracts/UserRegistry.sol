//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

contract UserRegistry {
    /// @notice User information
    /// @dev User information lives in EAS
    struct UserInfo {
        bool isUser;
        string profilePhoto;
        string name;
        string description;
        string[] skills;
    }

    mapping(address => UserInfo) private UserInformation;
    mapping(address => bool) private Authorized;

    error NotAuthorized();
    error NotUser();

    // Users may be SafeMultisig Wallets with a custom module of our own to
    // pay ourselfs the transactions

    modifier onlyUser() {
        if (isUser(msg.sender) != true) {
            revert NotUser();
        }
        _;
    }

    modifier onlyAuthorized() {
        if (Authorized[msg.sender] != true) {
            revert NotAuthorized();
        }
        _;
    }

    constructor(address _authorized) {
        Authorized[_authorized] = true;
        Authorized[msg.sender] = true;
    }

    /*
     *   OnlyAuthorized Functions
     */
    function addAuthorized(address _authorized) public onlyAuthorized {
        Authorized[_authorized] = true;
    }

    function addUser(address user) public onlyAuthorized {
        UserInformation[user].isUser = true;
    }

    function attestSkillAuthorized(
        address user,
        string memory skillId
    ) public onlyAuthorized {
        // EAS emit, get UID and add to skill array
        string memory id = "1";
        UserInformation[user].skills.push(id);

        // emit event for chainlink function
    }

    function endorseSkillAuthorized(
        address _from,
        address _to,
        string memory skillId
    ) public onlyAuthorized {
        // EAS emit endorse Skill;
    }

    /*
     *   UserOnly Functions
     */

    function attestSkill(string memory skill) public onlyUser {
        // EAS emit, get UID and add to skill array
        string memory id = skill;
        UserInformation[msg.sender].skills.push(id);
    }

    function endorseSkill(address _to, string memory skillId) public onlyUser {
        // EAS emit endorse Skill;
    }

    /*
     *   Getter and helper Functions
     */

    /// @notice Checks if address is user in DAO
    /// @param user address
    /// @return boolean
    function isUser(address user) public view returns (bool) {
        return UserInformation[user].isUser;
    }

    /// @notice Gets information about User
    /// @dev returns UID of EAS attestations
    /// @param user address
    /// @return Info about the user
    function getUserInfo(address user) external view returns (UserInfo memory) {
        return UserInformation[user];
    }

    function isAuthorized(address user) external view returns (bool) {
        return Authorized[user];
    }

    function canConvertToBytes32(
        string memory ejemplo
    ) public pure returns (bytes memory) {
        return bytes(ejemplo);
    }
}
