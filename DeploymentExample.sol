pragma solidity 0.5.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/ownership/Ownable.sol";

contract DeploymentExample is Ownable {
  using SafeMath for uint;

  mapping (address => uint) public balances;
  uint public totalDeposited;

  event Deposited(address indexed who, uint amount);
  event WithDrawn(address indexed who, uint amount);

  function () external payable {
    depositEther();
  }

  function depositEther() public payable {
    require(msg.value > 0);
    balances[msg.sender] = balances[msg.sender].add(msg.value);
    totalDeposited = totalDeposited.add(msg.value);
    emit Deposited(msg.sender, msg.value);
  }

  function withdraw(uint _amount) public {
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    totalDeposited = totalDeposited.sub(_amount);
    msg.sender.transfer(_amount);
    emit WithDrawn(msg.sender, _amount);

  }

  function kill() public onlyOwner {
    selfdestruct(address(uint160(owner())));
  }
}
