//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";
import "./Attestter.sol";

contract UserRegistry is Attestter {
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
    mapping(address => bool) private Admin;

    error UserRegistry__NotAdmin();
    error UserRegistry__NotUser();

    // Users may be SafeMultisig Wallets with a custom module of our own to
    // pay ourselfs the transactions

    modifier onlyUser() {
        if (isUser(msg.sender) != true) {
            revert UserRegistry__NotUser();
        }
        _;
    }

    modifier onlyAdmin() {
        if (Authorized[msg.sender] != true) {
            revert UserRegistry__NotAdmin();
        }
        _;
    }

    constructor(address userRegistry, address _authorized) Attestter(userRegistry) {
        Admin[_authorized] = true;
        Admain[msg.sender] = true;
    }

    /*
     *   Only Admin Functions
     */
    function addAdmin(address _authorized) public onlyAdmin {
        Authorized[_authorized] = true;
    }

    function addUser(address user) public onlyAdmin {
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

    function isAdmin(address user) external view returns (bool) {
        return Admin[user];
    }
}
