/**
    Blobs Onchain
    PFP for the Blob Ecosystem
    
    Website: blob.farm
**/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract BlobsData  {

/// Blob Trait Struct
    struct TraitStruct {
    uint body;
    uint eye;
    uint mouth;
    uint hat;
    uint background;
}

//// Store a blobs traits here - this is filled when minted!
    mapping(uint => TraitStruct) public tokenTraits;

//// Bodys of Blobs
        bytes[] internal body_data = [
                bytes(hex'080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000070c000000080c30cd41090c30cd410a0c69e2330b0c69e2330c0c69e2330d0c69e2330e0c30cd410f0c30cd41100c30cd41110c000000060d000000070d000000080d30cd41090d30cd410a0d69e2330b0d69e2330c0d69e2330d0d69e2330e0d30cd410f0d30cd41100d30cd41110d000000050e000000060e69e233070e69e233080e69e233090e69e2330a0eabf46f0b0eabf46f0c0eabf46f0d0e69e2330e0e69e2330f0e69e233100e69e233110e30cd41120e000000050f000000060f69e233070f69e233080fabf46f090fabf46f0a0fabf46f0b0fabf46f0c0fabf46f0d0fabf46f0e0f69e2330f0f69e233100f69e233110f69e233120f30cd41130f0000000510000000061069e233071069e233081069e233091069e2330a10abf46f0b10abf46f0c10abf46f0d1069e2330e1069e2330f1069e233101069e233111069e233121030cd4113100000000411000000051130cd41061169e233071169e233081169e233091169e2330a11abf46f0b11abf46f0c11abf46f0d1169e2330e1169e2330f1169e233101169e233111169e233121169e23313110000000412000000051230cd41061269e233071269e233081269e233091269e2330a1269e2330b1269e2330c1269e2330d1269e2330e1269e2330f1269e233101269e233111269e233121269e23313120000000413000000051330cd41061369e233071369e233081369e233091369e2330a1369e2330b1369e2330c1369e2330d1369e2330e1369e2330f1369e233101369e233111369e233121369e23313130000000414000000051430cd41061469e233071469e233081469e233091469e2330a1469e2330b1469e2330c1469e2330d1469e2330e1469e2330f1469e233101469e233111469e233121430cd4113140000000515000000061530cd41071530cd41081569e233091569e2330a1569e2330b1569e2330c1569e2330d1569e2330e1569e2330f1569e233101569e233111530cd41121530cd4113150000000616000000071630cd41081630cd41091630cd410a1630cd410b1630cd410c1630cd410d1630cd410e1630cd410f1630cd41101630cd41111630cd41121600000006170000000717000000081700000009170000000a170000000b170000000c170000000d170000000e170000000f1700000010170000001117000000'),
                bytes(hex'080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000070c000000080c606060090c6060600a0cb5b5b50b0cb5b5b50c0cb5b5b50d0cb5b5b50e0c6060600f0c606060100c606060110c000000060d000000070d000000080d606060090d6060600a0db5b5b50b0db5b5b50c0db5b5b50d0db5b5b50e0d6060600f0d606060100d606060110d000000050e000000060eb5b5b5070eb5b5b5080eb5b5b5090eb5b5b50a0ed5d5d50b0ed5d5d50c0ed5d5d50d0eb5b5b50e0eb5b5b50f0eb5b5b5100eb5b5b5110e606060120e000000050f000000060fb5b5b5070fb5b5b5080fd5d5d5090fd5d5d50a0fd5d5d50b0fd5d5d50c0fd5d5d50d0fd5d5d50e0fb5b5b50f0fb5b5b5100fb5b5b5110fb5b5b5120f606060130f00000005100000000610b5b5b50710b5b5b50810b5b5b50910b5b5b50a10d5d5d50b10d5d5d50c10d5d5d50d10b5b5b50e10b5b5b50f10b5b5b51010b5b5b51110b5b5b512106060601310000000041100000005116060600611b5b5b50711b5b5b50811b5b5b50911b5b5b50a11d5d5d50b11d5d5d50c11d5d5d50d11b5b5b50e11b5b5b50f11b5b5b51011b5b5b51111b5b5b51211b5b5b51311000000041200000005126060600612b5b5b50712b5b5b50812b5b5b50912b5b5b50a12b5b5b50b12b5b5b50c12b5b5b50d12b5b5b50e12b5b5b50f12b5b5b51012b5b5b51112b5b5b51212b5b5b51312000000041300000005136060600613b5b5b50713b5b5b50813b5b5b50913b5b5b50a13b5b5b50b13b5b5b50c13b5b5b50d13b5b5b50e13b5b5b50f13b5b5b51013b5b5b51113b5b5b51213b5b5b51313000000041400000005146060600614b5b5b50714b5b5b50814b5b5b50914b5b5b50a14b5b5b50b14b5b5b50c14b5b5b50d14b5b5b50e14b5b5b50f14b5b5b51014b5b5b51114b5b5b5121460606013140000000515000000061560606007156060600815b5b5b50915b5b5b50a15b5b5b50b15b5b5b50c15b5b5b50d15b5b5b50e15b5b5b50f15b5b5b51015b5b5b511156060601215606060131500000006160000000716606060081660606009166060600a166060600b166060600c166060600d166060600e166060600f1660606010166060601116606060121600000006170000000717000000081700000009170000000a170000000b170000000c170000000d170000000e170000000f1700000010170000001117000000'),
                bytes(hex'080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000070c000000080cff0000090cff00000a0cff707d0b0cff707d0c0cff707d0d0cff707d0e0cff00000f0cff0000100cff0000110c000000060d000000070d000000080dff0000090dff00000a0dff707d0b0dff707d0c0dff707d0d0dff707d0e0dff00000f0dff0000100dff0000110d000000050e000000060eff707d070eff707d080eff707d090eff707d0a0effc9ce0b0effc9ce0c0effc9ce0d0eff707d0e0eff707d0f0eff707d100eff707d110eff0000120e000000050f000000060fff707d070fff707d080fffc9ce090fffc9ce0a0fffc9ce0b0fffc9ce0c0fffc9ce0d0fffc9ce0e0fff707d0f0fff707d100fff707d110fff707d120fff0000130f00000005100000000610ff707d0710ff707d0810ff707d0910ff707d0a10ffc9ce0b10ffc9ce0c10ffc9ce0d10ff707d0e10ff707d0f10ff707d1010ff707d1110ff707d1210ff0000131000000004110000000511ff00000611ff707d0711ff707d0811ff707d0911ff707d0a11ffc9ce0b11ffc9ce0c11ffc9ce0d11ff707d0e11ff707d0f11ff707d1011ff707d1111ff707d1211ff707d131100000004120000000512ff00000612ff707d0712ff707d0812ff707d0912ff707d0a12ff707d0b12ff707d0c12ff707d0d12ff707d0e12ff707d0f12ff707d1012ff707d1112ff707d1212ff707d131200000004130000000513ff00000613ff707d0713ff707d0813ff707d0913ff707d0a13ff707d0b13ff707d0c13ff707d0d13ff707d0e13ff707d0f13ff707d1013ff707d1113ff707d1213ff707d131300000004140000000514ff00000614ff707d0714ff707d0814ff707d0914ff707d0a14ff707d0b14ff707d0c14ff707d0d14ff707d0e14ff707d0f14ff707d1014ff707d1114ff707d1214ff0000131400000005150000000615ff00000715ff00000815ff707d0915ff707d0a15ff707d0b15ff707d0c15ff707d0d15ff707d0e15ff707d0f15ff707d1015ff707d1115ff00001215ff0000131500000006160000000716ff00000816ff00000916ff00000a16ff00000b16ff00000c16ff00000d16ff00000e16ff00000f16ff00001016ff00001116ff0000121600000006170000000717000000081700000009170000000a170000000b170000000c170000000d170000000e170000000f1700000010170000001117000000'),
                bytes(hex'080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000070c000000080cdfd723090cdfd7230a0cfff8670b0cfff8670c0cfff8670d0cfff8670e0cdfd7230f0cdfd723100cdfd723110c000000060d000000070d000000080ddfd723090ddfd7230a0dfff8670b0dfff8670c0dfff8670d0dfff8670e0ddfd7230f0ddfd723100ddfd723110d000000050e000000060efff867070efff867080efff867090efff8670a0efffcb30b0efffcb30c0efffcb30d0efff8670e0efff8670f0efff867100efff867110edfd723120e000000050f000000060ffff867070ffff867080ffffcb3090ffffcb30a0ffffcb30b0ffffcb30c0ffffcb30d0ffffcb30e0ffff8670f0ffff867100ffff867110ffff867120fdfd723130f00000005100000000610fff8670710fff8670810fff8670910fff8670a10fffcb30b10fffcb30c10fffcb30d10fff8670e10fff8670f10fff8671010fff8671110fff8671210dfd723131000000004110000000511dfd7230611fff8670711fff8670811fff8670911fff8670a11fffcb30b11fffcb30c11fffcb30d11fff8670e11fff8670f11fff8671011fff8671111fff8671211fff867131100000004120000000512dfd7230612fff8670712fff8670812fff8670912fff8670a12fff8670b12fff8670c12fff8670d12fff8670e12fff8670f12fff8671012fff8671112fff8671212fff867131200000004130000000513dfd7230613fff8670713fff8670813fff8670913fff8670a13fff8670b13fff8670c13fff8670d13fff8670e13fff8670f13fff8671013fff8671113fff8671213fff867131300000004140000000514dfd7230614fff8670714fff8670814fff8670914fff8670a14fff8670b14fff8670c14fff8670d14fff8670e14fff8670f14fff8671014fff8671114fff8671214dfd723131400000005150000000615dfd7230715dfd7230815fff8670915fff8670a15fff8670b15fff8670c15fff8670d15fff8670e15fff8670f15fff8671015fff8671115dfd7231215dfd723131500000006160000000716dfd7230816dfd7230916dfd7230a16dfd7230b16dfd7230c16dfd7230d16dfd7230e16dfd7230f16dfd7231016dfd7231116dfd723121600000006170000000717000000081700000009170000000a170000000b170000000c170000000d170000000e170000000f1700000010170000001117000000'),
                bytes(hex'080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000070c000000080c8043d5090c8043d50a0cc9a1ff0b0cc9a1ff0c0cc9a1ff0d0cc9a1ff0e0c8043d50f0c8043d5100c8043d5110c000000060d000000070d000000080d8043d5090d8043d50a0dc9a1ff0b0dc9a1ff0c0dc9a1ff0d0dc9a1ff0e0d8043d50f0d8043d5100d8043d5110d000000050e000000060ec9a1ff070ec9a1ff080ec9a1ff090ec9a1ff0a0ee5d2ff0b0ee5d2ff0c0ee5d2ff0d0ec9a1ff0e0ec9a1ff0f0ec9a1ff100ec9a1ff110e8043d5120e000000050f000000060fc9a1ff070fc9a1ff080fe5d2ff090fe5d2ff0a0fe5d2ff0b0fe5d2ff0c0fe5d2ff0d0fe5d2ff0e0fc9a1ff0f0fc9a1ff100fc9a1ff110fc9a1ff120f8043d5130f00000005100000000610c9a1ff0710c9a1ff0810c9a1ff0910c9a1ff0a10e5d2ff0b10e5d2ff0c10e5d2ff0d10c9a1ff0e10c9a1ff0f10c9a1ff1010c9a1ff1110c9a1ff12108043d51310000000041100000005118043d50611c9a1ff0711c9a1ff0811c9a1ff0911c9a1ff0a11e5d2ff0b11e5d2ff0c11e5d2ff0d11c9a1ff0e11c9a1ff0f11c9a1ff1011c9a1ff1111c9a1ff1211c9a1ff1311000000041200000005128043d50612c9a1ff0712c9a1ff0812c9a1ff0912c9a1ff0a12c9a1ff0b12c9a1ff0c12c9a1ff0d12c9a1ff0e12c9a1ff0f12c9a1ff1012c9a1ff1112c9a1ff1212c9a1ff1312000000041300000005138043d50613c9a1ff0713c9a1ff0813c9a1ff0913c9a1ff0a13c9a1ff0b13c9a1ff0c13c9a1ff0d13c9a1ff0e13c9a1ff0f13c9a1ff1013c9a1ff1113c9a1ff1213c9a1ff1313000000041400000005148043d50614c9a1ff0714c9a1ff0814c9a1ff0914c9a1ff0a14c9a1ff0b14c9a1ff0c14c9a1ff0d14c9a1ff0e14c9a1ff0f14c9a1ff1014c9a1ff1114c9a1ff12148043d51314000000051500000006158043d507158043d50815c9a1ff0915c9a1ff0a15c9a1ff0b15c9a1ff0c15c9a1ff0d15c9a1ff0e15c9a1ff0f15c9a1ff1015c9a1ff11158043d512158043d51315000000061600000007168043d508168043d509168043d50a168043d50b168043d50c168043d50d168043d50e168043d50f168043d510168043d511168043d5121600000006170000000717000000081700000009170000000a170000000b170000000c170000000d170000000e170000000f1700000010170000001117000000'),
                bytes(hex'080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000070c000000080c0152fb090c0152fb0a0c79a4ff0b0c79a4ff0c0c79a4ff0d0c79a4ff0e0c0152fb0f0c0152fb100c0152fb110c000000060d000000070d000000080d0152fb090d0152fb0a0d79a4ff0b0d79a4ff0c0d79a4ff0d0d79a4ff0e0d0152fb0f0d0152fb100d0152fb110d000000050e000000060e79a4ff070e79a4ff080e79a4ff090e79a4ff0a0eccdcfe0b0eccdcfe0c0eccdcfe0d0e79a4ff0e0e79a4ff0f0e79a4ff100e79a4ff110e0152fb120e000000050f000000060f79a4ff070f79a4ff080fccdcfe090fccdcfe0a0fccdcfe0b0fccdcfe0c0fccdcfe0d0fccdcfe0e0f79a4ff0f0f79a4ff100f79a4ff110f79a4ff120f0152fb130f0000000510000000061079a4ff071079a4ff081079a4ff091079a4ff0a10ccdcfe0b10ccdcfe0c10ccdcfe0d1079a4ff0e1079a4ff0f1079a4ff101079a4ff111079a4ff12100152fb1310000000041100000005110152fb061179a4ff071179a4ff081179a4ff091179a4ff0a11ccdcfe0b11ccdcfe0c11ccdcfe0d1179a4ff0e1179a4ff0f1179a4ff101179a4ff111179a4ff121179a4ff1311000000041200000005120152fb061279a4ff071279a4ff081279a4ff091279a4ff0a1279a4ff0b1279a4ff0c1279a4ff0d1279a4ff0e1279a4ff0f1279a4ff101279a4ff111279a4ff121279a4ff1312000000041300000005130152fb061379a4ff071379a4ff081379a4ff091379a4ff0a1379a4ff0b1379a4ff0c1379a4ff0d1379a4ff0e1379a4ff0f1379a4ff101379a4ff111379a4ff121379a4ff1313000000041400000005140152fb061479a4ff071479a4ff081479a4ff091479a4ff0a1479a4ff0b1479a4ff0c1479a4ff0d1479a4ff0e1479a4ff0f1479a4ff101479a4ff111479a4ff12140152fb1314000000051500000006150152fb07150152fb081579a4ff091579a4ff0a1579a4ff0b1579a4ff0c1579a4ff0d1579a4ff0e1579a4ff0f1579a4ff101579a4ff11150152fb12150152fb1315000000061600000007160152fb08160152fb09160152fb0a160152fb0b160152fb0c160152fb0d160152fb0e160152fb0f160152fb10160152fb11160152fb121600000006170000000717000000081700000009170000000a170000000b170000000c170000000d170000000e170000000f1700000010170000001117000000')
                 ];

	string[] internal body_names = [
        'Blob Green',
        'Machine Grey',
        'Burnt Red',
        'Sun Yellow',
        'Juiced Purple',
        'Based Blue'
    ];

        uint[] internal  body_costs = [1, 5, 10, 10, 10, 420];
        uint[] public body_limits = [0, 10000, 5000, 5000, 5000, 100];
        bool[] internal body_isUnlimited = [true, false, false, false, false, false];



//// Eyes of Blobs
        bytes[] internal eye_data = [
                bytes(hex'081000000009100000000e100000000f10000000081100000009110000000e110000000f11000000081200000009120000000e120000000f12000000'),
                bytes(hex'081000000009100000000e100000000f1000000008110000000911ffffff0e110000000f11ffffff081200000009120000000e120000000f12000000'),
                bytes(hex'081000000009100000000e100000000f10000000081100000009110000000e110000000f1100000008120000000912ffffff0e120000000f12ffffff'),
                bytes(hex'0810ffffff09100000000e10ffffff0f100000000811ffffff09110000000e11ffffff0f11000000081200000009120000000e120000000f12000000'),
                bytes(hex'0810ffffff09100000000e10ffffff0f100000000811ffffff09110000000e11ffffff0f1100000008120000000912ffffff0e120000000f12ffffff'),
                bytes(hex'0810ffffff09100000000e10ffffff0f10000000081100000009110000000e110000000f1100000008120000000912ffffff0e120000000f12ffffff'),
                bytes(hex'081000000009100000000e100000000f10000000081100000009110000000e110000000f11000000081200000009120000000e120000000f120000000613ff00000713ff00001013ff00001113ff0000'),
                bytes(hex'081000000009100000000e100000000f10000000081100000009110000000e110000000f11000000081200000009120000000e120000000f1200000006130152fb07130152fb10130152fb11130152fb'),
                bytes(hex'081000000009100000000e100000000f100000000811ffffff09110000000e11ffffff0f110000000812ff00000912ff00000e12ff00000f12ff0000'),
                bytes(hex'07100152fb08100152fb09100152fb0a100152fb0b100152fb0c100152fb0d100152fb0e100152fb0f100152fb05110152fb06110152fb07110152fb0811ffffff09110152fb0a11ffffff0b110152fb0c110152fb0d110152fb0e11ffffff0f110152fb05120152fb07120152fb08120152fb09120152fb0a120152fb0b120152fb0c120152fb0d120152fb0e120152fb0f120152fb'),
                bytes(hex'081000000009100000000e100000000f1000000008110000000911ffffff0a11ff00000b11ff00000c11ff00000d11ff00000e110000000f11ffffff1011ff00001111ff00001211ff00001311ff00001411ff00001511ff00001611ff00001711ff0000081200000009120000000e120000000f12000000')
        ];

	string[] internal eye_names = [
        'Normal',
        'Look',
        'Shy',
        'Dreamy',
        'Degen',
        'Alien',
        'Blush',
        'Cold',
        'Stoned',
        'Based Nouns',
        'Lazer'
	];


        uint[] internal eye_costs = [0, 1, 1, 1, 1, 5, 10, 10, 42, 100, 100];
        uint[] public eye_limits =  [0, 0, 0, 0, 0, 2000, 1000, 1000, 420, 100, 100];
        bool[] internal eye_isUnlimited = [true, true, true, true, true, false, false, false, false, false, false];


//// mouth of Blobs
        bytes[] internal mouth_data = [
                bytes(hex''),
                bytes(hex'0b140000000c14000000'),
                bytes(hex'0a140000000b140000000c140000000d14000000'),
                bytes(hex'0c14000000'),
                bytes(hex'0a140000000b140000000c14000000'),
                bytes(hex'0b14ff00000c14ff0000'),
                bytes(hex'0b140152fb0c140152fb'),
                bytes(hex'0c140000000d140000000e14e6e6e60f14e6e6e61014e6e6e61114ff0000')
        ];

	string[] internal mouth_names = [
        'None',
        'Normal',
        'Wide',
        'Oooh',
        'Chill',
        'Lipstick',
        'Cold',
        'Smoke'
	];


        uint[] internal mouth_costs = [0, 1, 1, 1, 1, 5, 5, 42];
        uint[] public mouth_limits =  [0, 0, 0, 0, 0, 1000, 1000, 420];
        bool[] internal mouth_isUnlimited = [true, true, true, true, true, false, false, false];

//// hat of Blobs
        bytes[] internal hat_data = [
                bytes(hex''),
                bytes(hex'070aff0000080aff0000090aff00000a0aff00000b0aff00000c0aff00000d0aff00000e0aff00000f0aff0000100aff0000070bff0000080bff0000090bff00000a0bff00000b0bff00000c0bff00000d0bff00000e0bff00000f0bff0000100bff0000110bff707d040cff0000050cff0000060cff0000070cff0000080cff0000090cff00000a0cff00000b0cff00000c0cff00000d0cff00000e0cff00000f0cff0000100cff0000110cff707d040dff0000050dff0000060dff0000070dff0000080dff0000090dff00000a0dff00000b0dff00000c0dff00000d0dff00000e0dff00000f0dff0000100dff0000110dff707d'),
                bytes(hex'070a000000080a000000090a0000000a0a0000000b0a0000000c0a0000000d0a0000000e0a0000000f0a000000100a000000070b000000080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000110b606060040c000000050c000000060c000000070c000000080c000000090c0000000a0c0000000b0c0000000c0c0000000d0c0000000e0c0000000f0c000000100c000000110c606060040d000000050d000000060d000000070d000000080d000000090d0000000a0d0000000b0d0000000c0d0000000d0d0000000e0d0000000f0d000000100d000000110d606060'),
                bytes(hex'070a30cd41080a30cd41090a30cd410a0a30cd410b0a30cd410c0a30cd410d0a30cd410e0a30cd410f0a30cd41100a30cd41070b30cd41080b30cd41090b30cd410a0b30cd410b0b30cd410c0b30cd410d0b30cd410e0b30cd410f0b30cd41100b30cd41110b69e233040c30cd41050c30cd41060c30cd41070c30cd41080c30cd41090c30cd410a0c30cd410b0c30cd410c0c30cd410d0c30cd410e0c30cd410f0c30cd41100c30cd41110c69e233040d30cd41050d30cd41060d30cd41070d30cd41080d30cd41090d30cd410a0d30cd410b0d30cd410c0d30cd410d0d30cd410e0d30cd410f0d30cd41100d30cd41110d69e233'),
                bytes(hex'070a0152fb080a0152fb090a0152fb0a0a0152fb0b0a0152fb0c0a0152fb0d0a0152fb0e0a0152fb0f0a0152fb100a0152fb070b0152fb080b0152fb090b0152fb0a0b0152fb0b0b0152fb0c0b0152fb0d0b0152fb0e0b0152fb0f0b0152fb100b0152fb110b79a4ff040c0152fb050c0152fb060c0152fb070c0152fb080c0152fb090c0152fb0a0c0152fb0b0c0152fb0c0c0152fb0d0c0152fb0e0c0152fb0f0c0152fb100c0152fb110c79a4ff040d0152fb050d0152fb060d0152fb070d0152fb080d0152fb090d0152fb0a0d0152fb0b0d0152fb0c0d0152fb0d0d0152fb0e0d0152fb0f0d0152fb100d0152fb110d79a4ff'),
                bytes(hex'070aff0000080aff0000090aff00000a0aff00000b0aff00000c0aff00000d0aff00000e0aff00000f0aff0000100aff0000070bff707d080bff707d090bff707d0a0bff707d0b0bff707d0c0bff707d0d0bff707d0e0bff707d0f0bff707d100bff707d110bfff867040cff0000050cff0000060cff0000070cff0000080cff0000090cff00000a0cff00000b0cff00000c0cff00000d0cff00000e0cff00000f0cff0000100cff0000110cff0000120cff0000130cfff867040dff0000050dff0000060dff0000070dff0000080dff0000090dff00000a0dff00000b0dff00000c0dff00000d0dff00000e0dff00000f0dff0000100dff0000110dff0000120dff0000130dff0000'),
                bytes(hex'0708fbf2360809fbf236070adf7126080adf7126090afbf2360a0adf71260b0adf71260c0adf71260d0adf71260e0adf71260f0adf7126100adf7126070bd9a066080bd9a066090bd9a0660a0bfbf2360b0bd9a0660c0bd9a0660d0bd9a0660e0bd9a0660f0bd9a066100bd9a066040cdf7126050cdf7126060cdf7126070cdf7126080cdf7126090cdf71260a0cdf71260b0cdf71260c0cdf71260d0cdf71260e0cdf71260f0cdf7126100cdf7126110cdf7126120cdf7126130cdf7126040ddf7126050ddf7126060ddf7126070ddf7126080ddf7126090ddf71260a0ddf71260b0ddf71260c0ddf71260d0ddf71260e0ddf71260f0ddf7126100ddf7126110ddf7126120ddf7126130ddf7126'),
                bytes(hex'070a0152fb080a0152fb090a0152fb0a0a0152fb0b0a0152fb0c0a0152fb0d0a0152fb0e0a0152fb0f0a0152fb100a0152fb070b000000080b000000090b0000000a0b0152fb0b0b0000000c0b0000000d0b0000000e0b0000000f0b000000100b000000040c0152fb050c0152fb060c0152fb070c0152fb080c0152fb090c0152fb0a0c0152fb0b0c0152fb0c0c0152fb0d0c0152fb0e0c0152fb0f0c0152fb100c0152fb110c0152fb120c0152fb130c0152fb050d0152fb060d0152fb070d0152fb080d0152fb090d0152fb0a0d0152fb0b0d0152fb0c0d0152fb0d0d0152fb0e0d0152fb0f0d0152fb100d0152fb110d0152fb120d0152fb'),
                bytes(hex'070affffff080affffff090affffff0a0affffff0b0affffff0c0affffff0d0affffff0e0affffff0f0affffff100affffff070b000000080b000000090b0000000a0b0000000b0b0000000c0b0000000d0b0000000e0b0000000f0bffffff100b000000040cffffff050cffffff060cffffff070cffffff080cffffff090cffffff0a0cffffff0b0cffffff0c0cffffff0d0cffffff0e0cffffff0f0cffffff100cffffff110cffffff120cffffff130cffffff050dffffff060dffffff070dffffff080dffffff090dffffff0a0dffffff0b0dffffff0c0dffffff0d0dffffff0e0dffffff0f0dffffff100dffffff110dffffff120dffffff'),
                bytes(hex'070ad9a066080ad9a066090ad9a0660a0ad9a0660b0ad9a0660c0ad9a0660d0ad9a0660e0ad9a0660f0ad9a066100ad9a066030bd9a066070b663931080b663931090b6639310a0b6639310b0b6639310c0b6639310d0b6639310e0b6639310f0b663931100b663931140bd9a066030cd9a066040cd9a066050cd9a066060cd9a066070cd9a066080cd9a066090cd9a0660a0cd9a0660b0cd9a0660c0cd9a0660d0cd9a0660e0cd9a0660f0cd9a066100cd9a066110cd9a066120cd9a066130cd9a066140cd9a066030dd9a066040dd9a066050dd9a066060dd9a066070dd9a066080dd9a066090dd9a0660a0dd9a0660b0dd9a0660c0dd9a0660d0dd9a0660e0dd9a0660f0dd9a066100dd9a066110dd9a066120dd9a066130dd9a066140dd9a066'),
                bytes(hex'0b06dcdcdc0c06b5b5b50b07b5b5b50c07dcdcdc0a08b5b5b50b08dcdcdc0c08b5b5b50d08dcdcdc0909b5b5b50a09dcdcdc0b09b5b5b50c09dcdcdc0d09b5b5b50e09b5b5b5080ab5b5b5090ab5b5b50a0ab5b5b50b0ab5b5b50c0ab5b5b50d0adcdcdc0e0ab5b5b50f0adcdcdc100ab5b5b5070bdcdcdc080bb5b5b5090bdcdcdc0a0bdcdcdc0b0bb5b5b50c0bb5b5b50d0bb5b5b50e0bb5b5b50f0bb5b5b5100bb5b5b5110bdcdcdc060cb5b5b5070cb5b5b5080cb5b5b5090cb5b5b50a0cdcdcdc0b0cb5b5b50c0cdcdcdc0d0cdcdcdc0e0cb5b5b50f0cdcdcdc100cb5b5b5110cb5b5b5120cb5b5b5050db5b5b5060ddcdcdc070db5b5b5080ddcdcdc090db5b5b50a0ddcdcdc0b0db5b5b50c0ddcdcdc0d0db5b5b50e0ddcdcdc0f0db5b5b5100db5b5b5110ddcdcdc120db5b5b5130ddcdcdc050edcdcdc060eb5b5b5070eb5b5b5080eb5b5b5090edcdcdc0a0eb5b5b50b0edcdcdc0c0eb5b5b50d0eb5b5b50e0eb5b5b50f0edcdcdc100edcdcdc110eb5b5b5120eb5b5b5130eb5b5b5'),
                bytes(hex'0b060000000c060000000d060000000a070000000b07f7fdfa0c07f4ffc80d077fed370e0700000009080000000a087beb370b087beb370c087beb370d087beb370e0813b2460f08000000080900000009097beb370a0986eb3c0b097fea3a0c097fe8420d0975e9350e0913b2460f0913b2461009000000080a000000090a7beb370a0a7beb370b0a0000000c0a74e9370d0a72e5380e0a0000000f0a13b246100a000000080b000000090b7beb370a0b6de9320b0b72e7370c0b0000000d0b0000000e0b13b2460f0b13b246100b000000090c0000000a0ce3ffa90b0c7beb370c0c7beb370d0c7beb370e0c13b2460f0c13b246100c0000000a0d13b2460b0d13b2460c0d13b2460d0d13b2460e0d13b2460f0d0000000a0e0000000b0e0000000c0e0000000d0e0000000e0e000000')
        ];

	string[] internal hat_names = [
        'None',
        'Red Cap',
        'Black Cap',
        'Green Cap',
        'Blue Cap',
        'Fancy',
        'Farmer',
        'Sailor',
        'Mafia',
        'Cowboy',
        'Tinfoil',
        'Baby Blob'
	];

        uint[] internal hat_costs = [0, 10, 10, 10, 20, 25, 25, 25, 25, 25, 100, 500];
        uint[] public hat_limits =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200, 100];
        bool[] internal hat_isUnlimited = [true, true, true, true, true, true, true, true, true, true, false, false];

//// Backgrounds 

 //// Backgrounds for Blobs
    bytes[] internal background_data = [
        bytes(hex'0000ffc9c9'), 
        bytes(hex'0000ffe0c9'), 
        bytes(hex'0000fff6c9'), 
        bytes(hex'0000e5ffc9'), 
        bytes(hex'0000c9ffe5'),
        bytes(hex'0000c9f6ff'),
        bytes(hex'0000c9cfff'),
        bytes(hex'0000ebc9ff'),
        bytes(hex'0000ffc9fc')
    ];

    string[] internal background_names = [
        'Red',
        'Orange',
        'Yellow',
        'Green',
        'Aqua',
        'Blue',
        'Violet',
        'Purple',
        'Pink'
    ];

    uint[] internal background_costs = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    uint[] public background_limits =  [0, 0, 0, 0, 0, 0, 0, 0, 0];
    bool[] internal background_isUnlimited = [true, true, true, true, true, true, true, true, true];
}



contract BlobsNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable, BlobsData {
    event HatchedBlobNFT(address indexed minter, uint256 tokenid);

    uint256 private _nextTokenId;
    address public blobFarmContract;
     IERC20 public jellyContract;

    constructor(address initialOwner, address jelly)
        ERC721("Blobs Onchain", "BLOBS")
        Ownable(initialOwner)
    {
        jellyContract = IERC20(jelly);
    }

    bool public isPaused = true;

   
    function safeMint(uint[5] memory traits) public {
        require(isPaused == false, "Minting is paused");

        uint256 totalCost = calculateTotalCost(traits);
        require(IERC20(jellyContract).balanceOf(msg.sender) >= totalCost, "Insufficient $JELLY for this NFT");

        // Approve the token contract to spend the user's JELLY tokens
        require(IERC20(jellyContract).allowance(msg.sender, address(this)) >= totalCost, "Insufficient allowance");

        // Transfer the JELLY tokens from the user's account to the burn address (0xdead)
        require(IERC20(jellyContract).transferFrom(msg.sender, address(0xdead),  totalCost), "Transfer failed");

        require(traits[0] < body_data.length, "Invalid body trait index");
        require(traits[1] < eye_data.length, "Invalid eye trait index");
        require(traits[2] < mouth_data.length, "Invalid mouth trait index");
        require(traits[3] < hat_data.length, "Invalid hat trait index");
        require(traits[4] < background_data.length, "Invalid background trait index");

         if (!body_isUnlimited[traits[0]]) {
        require(body_limits[traits[0]] > 0, "Body trait limit exceeded");
        body_limits[traits[0]]--;
        }

         if (!eye_isUnlimited[traits[1]]) {
        require(eye_limits[traits[1]] > 0, "Body trait limit exceeded");
        eye_limits[traits[1]]--;
        }

         if (!mouth_isUnlimited[traits[2]]) {
        require(mouth_limits[traits[2]] > 0, "Body trait limit exceeded");
        mouth_limits[traits[2]]--;
        }

         if (!hat_isUnlimited[traits[3]]) {
        require(hat_limits[traits[3]] > 0, "Hat trait limit exceeded");
        hat_limits[traits[3]]--;
        }

         if (!background_isUnlimited[traits[4]]) {
        require(background_limits[traits[4]] > 0, "Background trait limit exceeded");
        background_limits[traits[4]]--;
        }

        uint256 tokenId = _nextTokenId++;

         _setBlobTraits(tokenId, traits);

        _safeMint(msg.sender, tokenId);

        emit HatchedBlobNFT(msg.sender, tokenId);
    }

     function calculateTotalCost(uint[5] memory traits) internal view returns (uint256) {
        uint256 totalCost;

        totalCost += body_costs[traits[0]];
        totalCost += eye_costs[traits[1]];
        totalCost += mouth_costs[traits[2]];
        totalCost += hat_costs[traits[3]];
        totalCost += background_costs[traits[4]];

        return totalCost * 10 ** 18;
    }

     function _setBlobTraits(uint _tokenID, uint[5] memory _traits) internal {
        TraitStruct memory newTraits = TraitStruct({
            body: _traits[0],
            eye: _traits[1],
            mouth: _traits[2],
            hat: _traits[3],
            background: _traits[4]
        });

        // Assign the generated traits to the token
        tokenTraits[_tokenID] = newTraits;
    }

     function tokenURI(uint256 tokenId) public view  override(ERC721, ERC721URIStorage) returns (string memory) {
        // Get image
        string memory image = buildSVG(tokenId);

        // Encode SVG data to base64
        string memory base64Image = Base64.encode(bytes(image));

        // Build JSON metadata
        string memory json = string(
            abi.encodePacked(
                '{"name": "Blobs Onchain #', Strings.toString(tokenId), '",',
                '"description": "Blobs Onchain have hatched on Base as NFTs - 100% stored on the Blockchain",',
             '"attributes": [', _getBlobTraits(tokenId), '],',
                '"image": "data:image/svg+xml;base64,', base64Image, '"}'
            )
        );

        // Encode JSON data to base64
        string memory base64Json = Base64.encode(bytes(json));

        // Construct final URI
        return string(abi.encodePacked('data:application/json;base64,', base64Json));
    }

     function buildSVG(uint tokenid) public view returns (string memory) {
        TraitStruct memory localTraits = tokenTraits[tokenid];

        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" shape-rendering="crispEdges" width="512" height="512">',
            SVGUtils.getBackgroundSVGTraitData(background_data[localTraits.background]),
            SVGUtils.getSVGTraitData(body_data[localTraits.body]),
            SVGUtils.getSVGTraitData(eye_data[localTraits.eye]),
            SVGUtils.getSVGTraitData(hat_data[localTraits.hat]),
            SVGUtils.getSVGTraitData(mouth_data[localTraits.mouth]),
            '</svg>'
        ));
        return svg;
    }


     function _getBlobTraits(uint tokenid) internal view returns (string memory) {

        TraitStruct memory traits = tokenTraits[tokenid];


        string memory metadata = string(abi.encodePacked(
        '{"trait_type":"Background", "value":"', background_names[traits.background], '"},',
        '{"trait_type":"Body", "value":"', body_names[traits.body], '"},',
        '{"trait_type":"Eyes", "value":"', eye_names[traits.eye], '"},',
        '{"trait_type":"Mouth", "value":"', mouth_names[traits.mouth], '"},',
        '{"trait_type":"Hat", "value":"', hat_names[traits.hat], '"}'
        ));

        return metadata;

    }

    function switchPause(bool _isPaused) external onlyOwner {
        isPaused = _isPaused;
    }


    function addBackgroundTrait(bytes memory data, string memory name, uint cost, bool isUnlimited, uint limit) external onlyOwner {
       
        background_data.push(data);
        background_names.push(name);
        background_costs.push(cost);
        background_limits.push(limit);
        background_isUnlimited.push(isUnlimited);
    }

    function addBodyTrait(bytes memory data, string memory name, uint cost, bool isUnlimited, uint limit) external onlyOwner {
        body_data.push(data);
        body_names.push(name);
        body_costs.push(cost);
        body_limits.push(limit);
        body_isUnlimited.push(isUnlimited);
    }

    function addEyeTrait(bytes memory data, string memory name, uint cost, bool isUnlimited, uint limit) external onlyOwner {
        eye_data.push(data);
        eye_names.push(name);
        eye_costs.push(cost);
        eye_limits.push(limit);
        eye_isUnlimited.push(isUnlimited);
    }

    function addMouthTrait(bytes memory data, string memory name, uint cost, bool isUnlimited, uint limit) external onlyOwner {
        mouth_data.push(data);
        mouth_names.push(name);
        mouth_costs.push(cost);
        mouth_limits.push(limit);
        mouth_isUnlimited.push(isUnlimited);
    }

    function addHatTrait(bytes memory data, string memory name, uint cost, bool isUnlimited, uint limit) external onlyOwner {
        hat_data.push(data);
        hat_names.push(name);
        hat_costs.push(cost);
        hat_limits.push(limit);
        hat_isUnlimited.push(isUnlimited);
    }




    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

library SVGUtils {
     function getBackgroundSVGTraitData(bytes memory data) internal pure returns (string memory) {
        // if empty, this is a transparent background
        if (data.length == 0) {
            return '<rect width="24" height="24" fill="#99ccff"/>';
        }

        // Extract values from the data

        uint r = uint8(data[2]);
        uint g = uint8(data[3]);
        uint b = uint8(data[4]);

        // Convert uint values to strings
        string memory xStr = Strings.toString(0);
        string memory yStr = Strings.toString(0);
        string memory rStr = Strings.toString(r);
        string memory gStr = Strings.toString(g);
        string memory bStr = Strings.toString(b);

        // Build the SVG string for the background
        return string(abi.encodePacked('<rect x="', xStr, '" y="', yStr, '" width="24" height="24" fill="rgb(', rStr, ',', gStr, ',', bStr, ')" />'));
    }

    function getSVGTraitData(bytes memory data) internal pure returns (string memory) {

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

    
}

library TraitDataValidator {
    function validateTraitData(
        bytes memory data,
        string memory name,
        uint cost,
        bool isUnlimited,
        uint limit
    ) internal pure returns (bool) {
        // Check if trait data is not empty
        if (data.length == 0) {
            return false;
        }

        // Check if trait name is not empty
        if (bytes(name).length == 0) {
            return false;
        }

        // Check if trait cost is non-negative
        if (cost < 0) {
            return false;
        }

        // If trait is not unlimited, check if limit is greater than zero
        if (!isUnlimited && limit == 0) {
            return false;
        }

        // All validations passed
        return true;
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