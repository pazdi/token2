pragma solidity ^0.4.8;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

  
}

contract tokenRecipient {
    
    function receiveApproval(address _from, uint256 _value, address _token, 
         bytes _extraData); 
    
}

contract token {

    string public standard = 'Token 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply1;
    uint256 public totalSupply;

  
    mapping (address => uint256) public balanceOf;
    
  
    event Transfer(address indexed from, address indexed to, uint256 value);


    function token(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol ) 
    {
        initialSupply1 = initialSupply ;
        balanceOf[msg.sender] = initialSupply1;              
        totalSupply = initialSupply1;                     
        name = tokenName;                                   
        symbol = tokenSymbol;                               
        decimals = decimalUnits;                            
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                            
        Transfer(msg.sender, _to, _value);                   
    }

    

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balanceOf[_from] < _value) throw;                 
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
    
        balanceOf[_from] -= _value;                          
        balanceOf[_to] += _value;                            
    
        Transfer(_from, _to, _value);
        return true;
    }

 
    function () payable {}
}

contract MyAdvancedToken is owned, token {

    uint256 public sellPrice;
    uint256 public buyPrice;
  
 
    event Transfer1(address indexed from, address indexed to, uint256 value);

   
    function MyAdvancedToken(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol,
        address centralMinter )
        token (initialSupply, tokenName, decimalUnits, tokenSymbol)
        {
        if(centralMinter != 0 ) owner = centralMinter;      
        balanceOf[owner] = initialSupply;                  
    }

    
     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    function buy(uint ether1) payable returns (uint256 amount)
     {
        amount = ether1 / buyPrice;                
        if (balanceOf[this] < amount) throw;              
        balanceOf[msg.sender] += amount;                  
        balanceOf[this] -= amount;                         
        Transfer(this, msg.sender, amount);           
        return msg.value;     
    }

    function sell(uint256 amount) {
        if (balanceOf[msg.sender] < amount ) throw;        
        balanceOf[this] += amount;                         
        balanceOf[msg.sender] -= amount;                  
        if (!msg.sender.send(amount * sellPrice)) {        
            throw;                                         
        } else {
            Transfer(msg.sender, this, amount);           
        }               
    }
}