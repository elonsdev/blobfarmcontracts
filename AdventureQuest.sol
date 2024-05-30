// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC1155/extensions/ERC1155URIStorage.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

interface IGoo {
    function getMyBlobsExternal() external view returns (uint256);
    function totalBlobs() external view returns(uint256); 
    function getBalance() external view returns (uint256);
    function lastHatch(address) external view returns (uint256);
    function marketGoo() external view returns (uint256);
    function spendBlobs(uint256 amount) external;
}

contract AdventureItems {
    //// Items
        bytes[] internal items_data = [
                bytes(hex'0504cec6be0604d3ccc30704cec7bf0804c9c1b80904c1b7af0a04a0938b0305b5aca20405baaea60505d3c8c00605c5bab20705a89b920805a3978d0905998e860a0571665d0b0595877f0306b5aba30406b9afa60506d2c9c10606c5bab10706a89a920806a3968d09069a8f860a0670655c0b0695867f0307afa59d0407b4a8a0070784776f08076b605b0b07897c760308c6beb40408c9c2ba0708d6cec50808ada59e0b088a7f790309cec7bf0409d4ccc30509d3ccc60609b7aea60909ada49c0a09a59c930b09716761050acec7bf060ad2cbc1070ac8bfb8080ab3aba3090a746a630a0a726862050bcfc8be060bd2cac2070bc7bfb8080bb3aba3090b756a620a0b716862050cedeae5070cded8d3080cbdb8b30a0c9f9996'),
                bytes(hex'0805b07c300905b27c2e0a05b17b2f0506b17c300606dfbe6c0706fbebc60806fbeaca0906c8a3550a06d0ad5f0b06c09a4e0407b37b2f0507e3bd6f0607fbedc80707f1d1910807d0ab5e0907d1ab5e0a07d3aa5f0b07bf994b0408dfbd6f0508fcedc70608f0d58d0708e2bb6f0808d2ab610908d3ab5f0a08d1ab600b088868370409e3bb700509e9c67d0609d6b2660709d0ad600809a280430909ab8a430a09a98a410b097a521f040aa8834e050ac09a4b060ad0aa5e070abf9a4a080ac09b4c090a7954210a0a663913050b93581c060b91581c070b663910'),
                bytes(hex'050437946e060437946e070437946e080437946e050537946e060537946e070537946e080537946e0506b6304c0606b7304d0706b8304d08068c20360507b72f4c0607b72f4d0707b8304c08078d1f360508b62f4c0608b72f4c0708b8304e08088f20360509dfc66b0609b72f4c0709b72f4d0809b82f4d09094a1b240a09901f35050a4a1b24060ab82f4e070ab72e4d080ab82f4d090ab32f4c0a0a4a1b24060bb72e4d070bb82f4e080bb8304e090b4a1b240a0be2c66c0b0b4a1b24070c4a1b24080ce1c56d090ce3c8700a0cbca059'),
                bytes(hex'0604ffba430704ffba430804ffba430904ffba430505ffffff0605df71260705df71260805df71260905df71260a05ffba430406ffba430506df71260606df71260706ffba430806ffba430906ffba430a06df71260b06ffba430407ffba430507df71260607ffba430707ffba430807ffba430907ffba430a07df71260b07df71260408ffba430508df71260608ffba430708ffba430808ffba430908ffba430a08ffffff0b08ffba430409ffba430509df71260609ffba430709ffba430809ffba430909ffba430a09ffffff0b09ffba43050affba43060affba43070affba43080affba43090affffff0a0affba43060bffba43070bffffff080bffffff090bffba43'),
                bytes(hex'0604fff1e80704c2c3c70804c2c3c70904c2c3c70505fff1e80605c2c3c70905c2c3c70a05c2c3c70506c2c3c70a06c2c3c70507c2c3c70607c2c3c70907c2c3c70a07c2c3c70608c2c3c70708c2c3c70808c2c3c70908c2c3c70709c2c3c70809c2c3c7070ac2c3c7080ac2c3c7090ac2c3c7070bc2c3c7080bc2c3c7090b83769c'),
                bytes(hex'07032a2a2a08034a4a4a05042a2a2a06042a2a2a07042a2a2a08044a4a4a09044a4a4a0a044a4a4a06052a2a2a07052a2a2a08054a4a4a09054a4a4a06062a2a2a09064a4a4a05072a2a2a0a074a4a4a04082a2a2a0b084a4a4a030920221e0409d5cfa10509a2fa670609a9f362070998fa6208094fe34609099afa670a095de54b0b095ce74d0c094a4a4a030a1e1f1d040ad4c88b050ab5f760060abefa68070a7afa25080a0bdb02090a11f0290a0a1aef3c0b0a0be2090c0a4a4a4a030b1c201a040bd4d087050be4fa8d060bd5fa7f070bc7fa80080b54dc2b090b37f9280a0b37f8200b0b2cf6240c0b4a4a4a040c2a2a2a050c2a2a2a060c2a2a2a070c2a2a2a080c4a4a4a090c4a4a4a0a0c4a4a4a0b0c4a4a4a'),
                bytes(hex'07020000000802000000060300000007038bf13e080383e83b090300000005040000000604f7fdfa0704f4ffc808047fed37090417b7450a040000000405000000050598e65306059fe851070587eb3c08057beb3709052cc9430a0513b2460406abf46f050686eb3c06067fea3a07067fe842080675e93509063bcb360a0619b73f0b06000000040783e33705070000000607000000070774e937080772e53809070000000a070000000b0713b246030800000004087beb4005086de932060872e73707080000000808000000090866e22d0a082ac6420b0814ad4b030900000004092cc93f0509e3ffa906096fe63507096df15a080969e23309092bc83e0a0913b2440b091294460c09000000030a000000040a128b40050a2ac83f060a30cd41070a2dcb40080a29ca3f090a13b2460a0a1298440b0a1a93470c0a000000040b000000050b11a244060b24c741070b21c441080b16ba47090b0e99440a0b1298420b0b000000050c000000060c1d913f070c0d8439080c1b8e42090c1a8c3d0a0c000000')
        ];

	string[] internal items_traits = [
        'Bad Omen',
        'Potato',
        'Ugly Sock',
        'Strange Point',
        'Mysterious Key',
        'Weird Potion',
        'Baby Blob'
    ];

    string[] internal items_descriptions = [
        'A Bad Omen, whispered by the shadows. Brace yourself, adventurer, for challenges lie ahead!',
        'Behold the Potato, a spud of potential! This tater might just be your best companion.',
        'An Ugly Sock, a textile masterpiece. Woven blindfolded, or so the legends say.',
        'Look, its a Strange Point. Theyre strange because we have no idea what they do.',
        'A Mysterious Key. Lets hope it opens more than just the door to the janitor closet.',
        'Legend has it, if you stare at it long enough, you might start seeing floating blobs.',
        'Oooh, a Baby Blob. Aww, it thinks youre its parent now. Good luck explaining the world to it!'
    ];

    uint[] public  items_probability = [1, 35, 60, 80, 95, 110, 125];
   
}

contract AdventureGame is ERC1155, Ownable, ERC1155Pausable, ERC1155Burnable, ERC1155Supply, ERC1155URIStorage, AdventureItems {

    event Quest(address indexed questor, uint tokenid);

    using ECDSA for bytes32;

    address public blobFarmContract;
    uint256 public lastRandomNumber;

    
    mapping(address => uint256) public lastPlayed;

    constructor(address initialOwner, address _blobFarmContract) ERC1155("") Ownable(initialOwner) {
        blobFarmContract = _blobFarmContract;
        _pause();
    }

    function addTrait(bytes memory data, string memory name, uint[] memory probability, string memory description) external onlyOwner {
        require(probability.length == items_probability.length + 1, "not the right length of probability");
        items_data.push(data);
        items_traits.push(name);
        items_descriptions.push(description);
        items_probability = probability;
    }

    function changeProbibilities(uint[] memory probability) external onlyOwner {
        require(probability.length == items_probability.length, "not the right length of probability");
        items_probability = probability;
    }


    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function quest() public {
        require(msg.sender == tx.origin, "No contracts allowed");
        require(block.timestamp >= lastPlayed[msg.sender] + 12 hours, "Quest cooldown period not elapsed");
        require(IGoo(blobFarmContract).getMyBlobsExternal() > 0, "You must own atleast 1 Blob to go on adventures");
        
        lastPlayed[msg.sender] = block.timestamp;
        
        uint256 marketGoo = IGoo(blobFarmContract).marketGoo();
        uint256 lastHatched = IGoo(blobFarmContract).lastHatch(msg.sender);
        uint256 randomNumber = generateRandomNumber(uint256(lastHatched + marketGoo + lastRandomNumber));
        lastRandomNumber = randomNumber;

        uint256 tokenIdWon = _pickTokenIdPossibility(randomNumber, items_data, items_probability );
        _mint(msg.sender, tokenIdWon, 1, "");

        emit Quest(msg.sender, tokenIdWon);
    }

     function questandburn() public {
        require(msg.sender == tx.origin, "No contracts allowed");
        require(block.timestamp >= lastPlayed[msg.sender] + 12 hours, "Quest cooldown period not elapsed");
        require(IGoo(blobFarmContract).getMyBlobsExternal() > 0, "You must own atleast 1 Blob to go on adventures");
        
        lastPlayed[msg.sender] = block.timestamp;
        
        uint256 lastHatched = IGoo(blobFarmContract).lastHatch(msg.sender); 
        uint256 marketGoo = IGoo(blobFarmContract).marketGoo();
        uint256 randomNumber = generateRandomNumber(uint256(lastHatched + marketGoo + lastRandomNumber));
        lastRandomNumber = randomNumber;

        IGoo(blobFarmContract).spendBlobs(1);
        randomNumber += generateRandomNumber(uint256(lastHatched + marketGoo + lastRandomNumber)) / 4;  // add extra random between 1-25

        uint256 tokenIdWon = _pickTokenIdPossibility(randomNumber, items_data, items_probability );
        _mint(msg.sender, tokenIdWon, 1, "");

        emit Quest(msg.sender, tokenIdWon);
    }

    function generateRandomNumber(uint256 seed) internal view returns (uint256) {
        uint256 pseudoRandomNumber = uint256(keccak256(abi.encodePacked(seed, block.timestamp, blockhash(block.number - 1))));
        return pseudoRandomNumber % 101;  // Adjust the range as needed
    }


    function _pickTokenIdPossibility(uint seed, bytes[] memory traitArray, uint[] memory traitProbability) internal pure returns (uint) {
        require(traitArray.length > 0, "Elements array is empty");
        require(traitArray.length == traitProbability.length, "Elements and weights length mismatch");
        
        for (uint i = 0; i < traitProbability.length; i++) {
            if(seed < traitProbability[i]) {
                return i;
            }
        }
        // Fallback, return first element as a safe default
        return 0;
    }

    function uri(uint256 tokenId) public view override(ERC1155, ERC1155URIStorage) returns (string memory) {
      // Get image
        string memory image = buildSVG(tokenId);

        // Encode SVG data to base64
        string memory base64Image = Base64.encode(bytes(image));

        // Build JSON metadata
        string memory jsonId1 = string(
            abi.encodePacked(
                '{"name": "',items_traits[tokenId],'",',
                '"description": "',items_descriptions[tokenId],'",',
                '"attributes": [', _getTraits(tokenId), '],',
                '"image": "data:image/svg+xml;base64,', base64Image, '"}'
            )
        );

        // Encode JSON data to base64
        string memory base64Json = Base64.encode(bytes(jsonId1));

        // Construct final URI
        return string(abi.encodePacked('data:application/json;base64,', base64Json));
    
    }
    

     function buildSVG(uint tokenid) public view returns (string memory) {
         string memory svg = string(abi.encodePacked(
             '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" shape-rendering="crispEdges" width="512" height="512">',
            '<rect width="16" height="16" fill="#000000"/>',
             _getSVGTraitData(items_data[tokenid]),
            '</svg>'
        ));
        return svg;
    }

      function _getSVGTraitData(bytes memory data) internal pure returns (string memory) {

        require(data.length % 5 == 0, "Invalid number of reacts");

        /// if empty this is a transparent react
        if (data.length == 0) {
             return "<rect x=\"0\" y=\"0\" width=\"0\" height=\"0\" fill=\"rgb(0,0,0)\"/>"; 
        }

        // Initialize arrays to store values
        uint reactCount = data.length / 5;


        /// react string to return
        string memory rects;

        uint[] memory x = new uint[](reactCount);
        uint[] memory y = new uint[](reactCount);
        uint[] memory r = new uint[](reactCount);
        uint[] memory g = new uint[](reactCount);
        uint[] memory b = new uint[](reactCount);

        // Iterate through each react and get the values we need
        for (uint i = 0; i < reactCount; i++) {

            // Convert and assign values to respective arrays
            x[i] = uint8(data[i * 5]);
            y[i] = uint8(data[i * 5 + 1]);
            r[i] = uint8(data[i * 5 + 2]);
            g[i] = uint8(data[i * 5 + 3]);
            b[i] = uint8(data[i * 5 + 4]);

            // Convert uint values to strings
            string memory xStr = Strings.toString(x[i]);
            string memory yStr = Strings.toString(y[i]);
            string memory rStr = Strings.toString(r[i]);
            string memory gStr = Strings.toString(g[i]);
            string memory bStr = Strings.toString(b[i]);

            rects = string(abi.encodePacked(rects, '<rect x="', xStr, '" y="', yStr, '" width="1" height="1" fill="rgb(', rStr, ',', gStr, ',', bStr, ')" />'));
        }

        return rects;
    }


    function _getTraits(uint tokenid) internal view returns (string memory) {

    
        string memory metadata = string(abi.encodePacked(
        '{"trait_type":"Item", "value":"', items_traits[tokenid], '"}'
        ));

        return metadata;

    }

     // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

}



library Base64 {
    string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
                                            hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
                                            hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
                                            hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';

        // load the table into memory
        string memory table = TABLE_ENCODE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
                // read 3 bytes
                dataPtr := add(dataPtr, 3)
                let input := mload(dataPtr)

                // write 4 characters
                mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }

        return result;
    }

    function decode(string memory _data) internal pure returns (bytes memory) {
        bytes memory data = bytes(_data);

        if (data.length == 0) return new bytes(0);
        require(data.length % 4 == 0, "invalid base64 decoder input");

        // load the table into memory
        bytes memory table = TABLE_DECODE;

        // every 4 characters represent 3 bytes
        uint256 decodedLen = (data.length / 4) * 3;

        // add some extra buffer at the end required for the writing
        bytes memory result = new bytes(decodedLen + 32);

        assembly {
            // padding with '='
            let lastBytes := mload(add(data, mload(data)))
            if eq(and(lastBytes, 0xFF), 0x3d) {
                decodedLen := sub(decodedLen, 1)
                if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
                    decodedLen := sub(decodedLen, 1)
                }
            }

            // set the actual output length
            mstore(result, decodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 4 characters at a time
            for {} lt(dataPtr, endPtr) {}
            {
               // read 4 characters
               dataPtr := add(dataPtr, 4)
               let input := mload(dataPtr)

               // write 3 bytes
               let output := add(
                   add(
                       shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
                       shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
                   add(
                       shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
                               and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
                    )
                )
                mstore(resultPtr, shl(232, output))
                resultPtr := add(resultPtr, 3)
            }
        }

        return result;
    }
}

