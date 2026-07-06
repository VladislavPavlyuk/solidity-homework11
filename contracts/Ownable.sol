// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28; 

abstract contract Ownable {
    // 1. Змінна для зберігання адреси власника контракту
    address public owner;

    // 2. Подія, яка спрацьовує при зміні або встановленні власника
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    // 3. Конструктор який
    constructor() {
        owner = msg.sender;     // встановлює власником адресу, що деплоїла контракт (msg.sender)
        emit OwnerChanged(address(0), msg.sender);  // генерує подію OwnerChanged
    }

    // 4. Модифікатор onlyOwner, який дозволяє викликати певні функції лише власнику контракту
    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner");
        _;
    }
}