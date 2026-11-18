pragma solidity ^0.8.20;
contract TimeLockedVault {
 
erorr InsufficientDeposit(uint256 sent, uint256 minRequired)
erorr ExceedsMaxLockDuration(uint256 requested, uint256 maxAllowed)
erorr LockPeriodActive(uint256 currentTime, uint256 unlockTime)
erorr NoFundsToWithdraw()
erorr EthTransferFailed()

  struct LockBox {
        uint256 balance;         
        uint256 unlockTimestamp; 
    }

    mapping(address => LockBox) public vaults;

    uint256 public constant MIN_DEPOSIT = 0.01 ether;
    uint256 public constant MAX_DURATION = 365 days;   

function  deposit(uint256 _lockDuration) external payable
if (msg.vaulue < MIN_DEPOSIT) {
    revert InsufficientDeposit(msg.value, MIN_DEPOSIT);
}
if (_lockDuration > MAX_DURATION) {
        revert ExceedsMaxLockDuration(_lockDuration, MAX_DURATION);
    }

    uint256 newUnlock = block.timestamp + _lockDuration;

    if (newUnlock > vaults[msg.sender].unlockTimestamp) {
        vaults[msg.sender].unlockTimestamp = newUnlock;
    }

    vaults[msg.sender].balance += msg.value;

receive() external payable {
    if (msg.value < MIN_DEPOSIT) {
        revert InsufficientDeposit(msg.value, MIN_DEPOSIT);
    }

    vaults[msg.sender].unlockTimestamp = block.timestamp + 1 days;
    vaults[msg.sender].balance += msg.value;
}

function withdraw() external {
   
    if (vaults[msg.sender].balance == 0) {
        revert NoFundsToWithdraw();
    }
    if (block.timestamp < vaults[msg.sender].unlockTimestamp) {
        revert LockPeriodActive(block.timestamp, vaults[msg.sender].unlockTimestamp);
    }

    
    uint256 amount = vaults[msg.sender].balance;
    vaults[msg.sender].balance = 0;

    
    (bool success, ) = payable(msg.sender).call{value: amount}("");
    if (!success) {
        revert EthTransferFailed();
    }
}

function packDepositData(
    address _user,
    uint256 _amount,
    uint256 _releaseTime
) external pure returns (bytes memory) {
    return abi.encode(_user, _amount, _releaseTime);
}


function unpackDepositData(
    bytes memory _data
) external pure returns (address user, uint256 amount, uint256 releaseTime) {
    (user, amount, releaseTime) = abi.decode(_data, (address, uint256, uint256));
}

}