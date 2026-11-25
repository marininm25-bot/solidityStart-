pragma solidity ^0.8.0;

interface IERC20  {
    

function totalSupply() external view returns (uint256);
function balanceOf(address account) external view returns (uint256);
function transfer(address to, uint256 amount) external returns (bool);
function allowance(address owner, address spender) external view returns (uint256);
function approve(address spender, uint256 amount) external returns (bool);
function transferFrom(address from, address to, uint256 amount) external returns (bool);


event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);



}  



contract MyCustomToken is IERC20  {

address owner;




    string public constant name = "ProfiHub Token";
    string public constant symbol = "PHT";
    uint8 public constant decimals = 18;
 

 uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances; 
   

       constructor(uint256 _initialSupply) {
        _mint(msg.sender, _initialSupply * 10 ** decimals);
    }

function _mint(address account, uint256 amount) internal {

           _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
}

function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= amount, "Not enough balance");

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);

}

   

function approve(address spender, uint256 amount) external override returns (bool) {
        _allowances[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
        return true;
    
}



  function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        uint256 allowed = _allowances[from][msg.sender];
        require(allowed >= amount, "ERC20: insufficient allowance");
        _allowances[from][msg.sender] = allowed - amount;

        _transfer(from, to, amount);
        return true;
    }

    function burn(uint256 amount) external {
    require(_balances[msg.sender] >= amount);
    _balances[msg.sender] -= amount;
    _totalSupply -= amount;
    emit Transfer(msg.sender, address(0), amount);
}

function totalSupply() external view override returns (uint256) {
    return _totalSupply;
}

    
function balanceOf(address account) external view override returns (uint256) {
    return _balances[account];
}


function transfer(address to, uint256 amount) external override returns (bool) {
    _transfer(msg.sender, to, amount);
    return true;
}

function allowance(address _owner, address spender) external view override returns (uint256) {
    return _allowances[_owner][spender];
}


}


contract TokenLocker  {

mapping(address => mapping(address => uint256)) public lockedBalances;

function lockTokens(address _tokenAddress, uint256 _amount)  external    {

IERC20 token = IERC20(_tokenAddress);
    
    require (
    token.transferFrom(msg.sender, address(this), _amount )
    );

    lockedBalances[_tokenAddress][msg.sender] += _amount;
}

}
