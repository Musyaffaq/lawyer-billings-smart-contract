// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/*
 * @title A smart contract to allow transparency for Lawyer's billable hours
 * @author Musyaffaq
 * @custom:description This smart contract allows a lawyer to register themselves and record tasks done for a client and also allows a client to register themselves and retrieve the billable hours by a lawyer.
 */
contract LawyerBillings {
    struct Lawyer {
        string name;
    }

    struct Client {
        string name;
    }

    struct Task {
        address lawyerAddress;
        address clientAddress;
        string description;
        uint8 billedHours;
        uint64 timestamp;
    }

    mapping(address => Lawyer) addressToLawyer;
    mapping(address => Client) addressToClient;
    Task[] public allTasks;

    // FUNCTIONS
    // register a new lawyer
    function registerLawyer(string memory _name) public {
        require(
            bytes(addressToLawyer[msg.sender].name).length == 0,
            "This Lawyer already exists!"
        );
        require(
            bytes(_name).length > 0,
            "The Lawyer's name should not be empty!"
        );
        addressToLawyer[msg.sender] = Lawyer(_name);
    }

    // register a new client
    function registerClient(string memory _name) public {
        require(
            bytes(addressToClient[msg.sender].name).length == 0,
            "This Client already exists!"
        );
        require(
            bytes(_name).length > 0,
            "The Client's name should not be empty!"
        );
        addressToClient[msg.sender] = Client(_name);
    }

    // get lawyer's name based on address
    function getLawyer(address _address) public view returns (Lawyer memory) {
        require(
            bytes(addressToLawyer[_address].name).length != 0,
            "This Lawyer does not exist!"
        );
        return addressToLawyer[_address];
    }

    // get client's name based on address
    function getClient(address _address) public view returns (Client memory) {
        require(
            bytes(addressToClient[_address].name).length != 0,
            "This Client does not exist!"
        );
        return addressToClient[_address];
    }

    // record new task
    function recordTask(
        address _lawyerAddress,
        address _clientAddress,
        string memory _desc,
        uint8 _billedHours
    ) public {
        require(
            bytes(addressToLawyer[_lawyerAddress].name).length != 0,
            "This Lawyer does not exist!"
        );
        require(
            bytes(addressToClient[_clientAddress].name).length != 0,
            "This Client does not exist!"
        );
        allTasks.push(
            Task(
                _lawyerAddress,
                _clientAddress,
                _desc,
                _billedHours,
                uint64(block.timestamp)
            )
        );
    }

    // get all tasks
    function getTasks() public view returns (Task[] memory) {
        return allTasks;
    }

    // get total billedHours by client + lawyer
    function getbilledHoursByClientLawyer(
        address _lawyerAddress,
        address _clientAddress
    ) public view returns (uint) {
        require(
            bytes(addressToLawyer[_lawyerAddress].name).length != 0,
            "This Lawyer does not exist!"
        );
        require(
            bytes(addressToClient[_clientAddress].name).length != 0,
            "This Client does not exist!"
        );
        uint totalHours = 0;

        for (uint i = 0; i < allTasks.length; i++) {
            if (
                (allTasks[i].lawyerAddress == _lawyerAddress) &&
                (allTasks[i].clientAddress == _clientAddress)
            ) {
                totalHours += allTasks[i].billedHours;
            }
        }

        return totalHours;
    }
}
