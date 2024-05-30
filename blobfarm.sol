// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/* 
  ######
 #  ^ ^ #
#    ~   #
 #   ⌣  #
  ######

Blob Farm is a game running on Base Blockchain.  
Interact with this contract at your own risk. 
You may lose everything.  The dev is not the best dev ever :') 

*/

contract BlobFarm {

    event BoughtBlobs(address indexed buyer, uint amount);
    event SoldGoo(address indexed seller, uint gooAmount);
    event HatchedBlobs(address indexed hatcher, uint amountGooUsed, uint amountBlobsHatched);

    
    // Goo Per Blob Per Second = 1
    uint256 public constant GOO_TO_HATCH_1BLOB = 8640000;
    uint256 PSN = 10000;
    uint256 PSNH = 5000;
    uint256 public constant COOLDOWN_TIME = 60 minutes;

    bool public initialized = false;
    address public ceoAddress = 0x86976168a42c5cD9Ba89b1a1e3471D6E0425c0CE; // As if CEO do anything, Dev in basement eating soup.. :/ 
    address public devAddress;

    mapping(address => uint256) public blobs;
    mapping(address => uint256) public claimedGoo;
    mapping(address => uint256) public lastHatch;
    mapping(address => address) public referrals;

    uint256 public totalBlobs;
    uint256 public marketGoo; // Up only

    constructor() {
        devAddress=msg.sender;
    }

    modifier onlyInitialized() {
        require(initialized, "Contract not yet initialized");
        _;
    }

    modifier hasNoCooldown(address user) {
        require(block.timestamp >= lastHatch[user] + COOLDOWN_TIME, "Hatching cooldown period not elapsed");
        _;
    }

    // Which came first, Goo or the Blob? 

    function hatchGoo(address ref) public onlyInitialized hasNoCooldown(msg.sender) {
        // First ref gets the goo
        if (referrals[msg.sender] == address(0x0000000000000000000000000000000000000000) && ref != msg.sender) {
            referrals[msg.sender] = ref;
        } 

        uint256 gooUsed = getMyGoo();
        require(gooUsed >= GOO_TO_HATCH_1BLOB, "Not enough goo to hatch any blobs");

        uint256 newBlobs = gooUsed / GOO_TO_HATCH_1BLOB;
        totalBlobs += newBlobs;
        blobs[msg.sender] += newBlobs;
        claimedGoo[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;

        // Send referral juicy goo rewardsy
        claimedGoo[referrals[msg.sender]] += gooUsed / 50; // 2%

        // Boost market to counter Bad blobs that hoard the goo from everyone. 
        marketGoo += gooUsed / 5;

        emit HatchedBlobs(msg.sender, gooUsed, newBlobs);
    }

    function hatchGooBought(address ref) internal onlyInitialized hasNoCooldown(msg.sender) {
        // First ref gets the goo
        if (referrals[msg.sender] == address(0x0000000000000000000000000000000000000000) && ref != msg.sender) {
            referrals[msg.sender] = ref;
        } 

        uint256 gooUsed = getMyGoo();
        require(gooUsed >= GOO_TO_HATCH_1BLOB, "Not enough goo to hatch any blobs");

        uint256 newBlobs = gooUsed / GOO_TO_HATCH_1BLOB;
        totalBlobs += newBlobs;
        blobs[msg.sender] += newBlobs;
        claimedGoo[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;

        // Send referral juicy goo rewardsy
        claimedGoo[referrals[msg.sender]] += gooUsed / 50; // 2%

        // Boost market to counter Bad blobs that hoard the goo from everyone. 
        marketGoo += gooUsed / 5;

        emit BoughtBlobs(msg.sender, newBlobs);
    }

    // Buy Goo is actually buying Blobs / why call it buyGoo... I dunno. Easier I guess :/ 
    function buyGoo(address ref) public payable onlyInitialized hasNoCooldown(msg.sender) {
        require(msg.value <= address(this).balance - msg.value, "Must buy less than the current contract balance");
        
        uint256 gooBought = calculateGooBuy(msg.value, (address(this).balance - msg.value));
        uint256 fee = ceoFee(gooBought);
        gooBought -= fee;
        require(gooBought >= GOO_TO_HATCH_1BLOB, "Must buy enough to hatch 1 Blob");

        payable(ceoAddress).transfer(ceoFee(msg.value));
        claimedGoo[msg.sender] += gooBought;
        hatchGooBought(ref);
    }

    // Sell goo anytime no coolzy
     function sellGoo() public onlyInitialized {
        uint256 hasGoo = getMyGoo();
        uint256 gooValue = calculateGooSell(hasGoo);
        uint256 fee = ceoFee(gooValue);
        claimedGoo[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;
        marketGoo += hasGoo;
        payable(ceoAddress).transfer(fee);
        payable(msg.sender).transfer(gooValue - fee);

        emit SoldGoo(msg.sender, hasGoo);
    }


    // you honestly don't need to know what any of this stuff does below here. Just get that Goo. 

    function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns (uint256) {
        return (PSN * bs) / (PSNH + ((PSN * rs + PSNH * rt) / rt));
    }

    function calculateGooSell(uint256 goo) public view returns (uint256) {
        return calculateTrade(goo, marketGoo, address(this).balance);
    }

    function calculateGooBuy(uint256 eth, uint256 contractBalance) public view returns (uint256) {
        uint256 gooBought = calculateTrade(eth, contractBalance, marketGoo);
        return gooBought - ceoFee(gooBought);
    }

    function calculateGooBuySimple(uint256 eth) public view returns(uint256){
        return calculateGooBuy(eth,address(this).balance);
    }

    function ceoFee(uint256 amount) public pure returns (uint256) {
        return (amount * 20) / 1000; // 2%
    }

    function seedMarket() public payable {
        require(msg.sender == address(devAddress), "Must be DEV");
        require(!initialized, "Market already seeded");
        initialized = true;
        marketGoo = 864000000000;    
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getMyBlobs() public view returns (uint256) {
        return blobs[msg.sender];
    }

    function getMyGoo() public view returns (uint256) {
        return claimedGoo[msg.sender] + getGooSinceLastHatch(msg.sender);
    }


    function getGooSinceLastHatch(address adr) public view returns (uint256) {
        uint256 secondsPassed = min(GOO_TO_HATCH_1BLOB, block.timestamp - lastHatch[adr]);

        return secondsPassed * blobs[adr];
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }

    // for phase 2... If you read this far.....  shhh... Don't be a blob, it's gonna be cool beans. 

   function getMyBlobsExternal() external view returns (uint256) {
        return blobs[tx.origin];
    }

   
    function spendBlobs(uint256 amount) external   {
       require(blobs[tx.origin] - amount >= 0, "You must have enough Blobs for this...");
       blobs[tx.origin] -= amount;
    }


}
