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
        string[] skills; // atestations
    }

    mapping(address => UserInfo) private UserInformation;
    mapping(address => bool) private Authorized;

    error NotAuthorized();
    error NotUser();

    // Users may be SafeMultisig Wallets with a custom module of our own to
    // pay ourselfs the transactions

    modifier onlyUser(address _user) {
        if (isUser(_user) != true) {
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
}
