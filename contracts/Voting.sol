// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./CandidateRegistry.sol";
import "./VoterRegistry.sol";

// Контракт Voting (успадковує CandidateRegistry та VoterRegistry)
contract Voting is CandidateRegistry, VoterRegistry {
    
    // 1. Enum Status, який описує стани голосування
    enum Status {
        NotStarted,
        Active,
        Finished
    }

    // 2. Змінна status для збереження поточного стану голосування
    Status public status;

    // 3. Події для логування ключових дій системи
    event VotingStarted();
    event VoteCast(address indexed voter, uint indexed candidateId);
    event VotingFinished();

    // 4. Модифікатор onlyDuringVoting (дозволяє функції лише під час активного голосування)
    modifier onlyDuringVoting() {
        require(status == Status.Active, "Voting is not active");
        _;
    }

    // 5. Функція addCandidateToVote (доступна лише власнику, дозволяє додавати кандидатів лише до початку голосування)
    function addCandidateToVote(string memory name) external onlyOwner {
        require(status == Status.NotStarted, "Cannot add candidates after start");
        addCandidate(name); // Викликає внутрішню функцію з CandidateRegistry
    }

    // Додаткова функція зв'язку для реєстрації виборців власником до початку голосування
    function registerVoterToVote(address voterAddress) external onlyOwner {
        require(status == Status.NotStarted, "Cannot register voters after start");
        _registerVoter(voterAddress); // Викликає внутрішню функцію з VoterRegistry
    }

    // 6. Функція startVoting (запускає голосування, доступна лише для власнику, без повторного запуску)
    function startVoting() external onlyOwner {
        require(status == Status.NotStarted, "Voting already started or finished");
        status = Status.Active;
        emit VotingStarted();
    }

    // 7. Функція finishVoting (завершує голосування, доступна лише для власнику, працює лише під час активного стану)
    function finishVoting() external onlyOwner onlyDuringVoting {
        status = Status.Finished;
        emit VotingFinished();
    }

    // 8. Функція vote (головна функція для прийому голосів)
    function vote(uint candidateId) external onlyDuringVoting {
        // Перевіряє, що виборець зареєстрований (викликає функцію з п. 6 контракту VoterRegistry)
        require(isRegisteredVoter(msg.sender), "You are not registered to vote");
        
        // Перевіряє, що виборець ще не голосував
        require(!voters[msg.sender].hasVoted, "You have already voted");

        // Позначає виборця як такого, що вже проголосував (викликає функцію з п. 5 контракту VoterRegistry)
        markAsVotedVoter(msg.sender); 
        
        // Зараховує голос вибраному кандидату (викликає функцію з п. 5 контракту CandidateRegistry)
        voteCandidate(candidateId); 

        // Генерує подію про успішне голосування
        emit VoteCast(msg.sender, candidateId);
    }
}