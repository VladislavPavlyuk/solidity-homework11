// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Ownable.sol";

abstract contract VoterRegistry is Ownable {
    // 1. Структура виборця
    struct Voter {
        uint id;
        bool isRegistered; // Чи зареєстрований виборець admin-ом
        bool hasVoted;     // Чи вже віддав він свій голос
    }

    // Лічильник для створення унікальних ID виборців
    uint public voterCount;

    // 2. Mapping для зберігання інформації про виборців
    mapping(address => Voter) public voters;

    // 3. Подія реєстрації нового виборця
    event VoterRegistered(address indexed voterAddress, uint id);

    // 4. Внутрішня функція реєстрації виборця
    function _registerVoter(address voterAddress) internal {
        require(voterAddress != address(0), "Invalid voter address");
        require(!voters[voterAddress].isRegistered, "Voter already registered");

        voterCount++;
        
        voters[voterAddress] = Voter({
            id: voterCount,
            isRegistered: true,
            hasVoted: false
        });

        emit VoterRegistered(voterAddress, voterCount);
    }

    // 5. Внутрішня функція для позначення виборця як такого, що проголосував
    function markAsVotedVoter(address voterAddress) internal {
        require(voters[voterAddress].isRegistered, "Voter is not registered");
        voters[voterAddress].hasVoted = true;
    }

    //  6. Публічна view-функція для перевірки, чи зареєстрований виборець
    function isRegisteredVoter(address voterAddress) public view returns (bool) {
        return voters[voterAddress].isRegistered;
    }
}