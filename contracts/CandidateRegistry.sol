// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Ownable.sol";

abstract contract CandidateRegistry is Ownable {
    // 1. Структура кандидата
    struct Candidate {
        uint id;
        string name;
        uint votes;
    }

    // 2. Масив кандидатів
    Candidate[] public candidates;

    // 3. Подія, яка викликається при додаванні нового кандидата
    event CandidateAdded(uint id, string name);

    // 4. Внутрішня (internal) функція для додавання кандидата
    function addCandidate(string memory name) internal {
        uint newId = candidates.length; // автоматично присвоює йому ідентифікатор
        
        // встановлює початкову кількість голосів
        candidates.push(Candidate(newId, name, 0));
        
        // генерує відповідну подію
        emit CandidateAdded(newId, name);
    }

    // 5. Внутрішню функцію voteCandidate(...), яка збільшує кількість голосів кандидата
    function voteCandidate(uint id) internal {
        // Перевіряємо, що такий кандидат взагалі існує в масиві
        require(id < candidates.length, "Candidate does not exist");
        candidates[id].votes++;
    }

    // 6. Функцію getCandidate(...) для отримання інформації про кандидата
    function getCandidate(uint id) external view returns (uint, string memory, uint) {
        require(id < candidates.length, "Candidate does not exist");
        Candidate memory c = candidates[id];
        return (c.id, c.name, c.votes);
    }

    // 7. Функцію totalCandidates(), яка повертає кількість кандидатів
    function totalCandidates() external view returns (uint) {
        return candidates.length;
    }
}