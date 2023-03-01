// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⣾⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠻⢿⣿⣿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⡿⠿⠟⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣆⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀⠙⠋⠀⠀⠀
⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣾⠟⢋⣥⣤⠀⣶⣶⣶⣦⣤⣌⣉⠛⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⢁⣴⣿⣿⡿⠀⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀
⠀⠀⠀⣼⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣶⣶⣾⣿⣿⣿⣿⣷⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠁⠀⠀⢹⣿⣿⣿⣿⣿⣿⢻⣿⡄⠀⠀⠀⠀
⠀⠀⠀⠛⠋⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⠿⠛⣛⣉⣉⣀⣀⡀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⢸⣿⣿⡄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡿⢋⣩⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣦⣀⣀⣴⣿⣿⣿⣿⣿⡿⢸⣿⢿⣷⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣡⣄⠀⠋⠁⠀⠈⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⡿⠀⠛⠃⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣧⡀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠃⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠈⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⢿⣿⣿⣿⣷⣦⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣶⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⣿⠇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢠⣿⣿⣿⠟⠉⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⢸⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣼⣿⡟⠁⣠⣦⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡆⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⠏⠀⣸⡏⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⡏⠀⠀⣿⣿⡀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⢹⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠙⢿⣿⣿⡿⠟⠁⠀⣸⡿⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢸⣿⠁⠀⠀⢸⣿⣇⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣦⡀⠀⠀⠀⠈⠉⠀⠀⠀⣼⡿⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⢿⣿⡄⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⣼⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣦⣄⣀⠀⠀⢀⡈⠙⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣆⠀⠀⠀⠉⠛⠿⢿⣿⣿⠿⠛⠁⠀⠀⠀⣠⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣷⣿⣯⣤⣶⠄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠺⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢻⣿⣶⣤⣤⣤⣶⣷⣤⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⡿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠶⢤⣄⣀⣀⣤⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../erc721a/contracts/ERC721A.sol";
import "../erc721a/contracts/extensions/ERC721ABurnable.sol";
import "../erc721a/contracts/extensions/ERC721AQueryable.sol";
import "../solady/auth/Ownable.sol";

contract MiladyColaTest is ERC721A, ERC721AQueryable, ERC721ABurnable, Ownable {

    uint256 public constant s_MAXMILADYCOLA = 10000;

    string public IPFSURI = '';

    bool public s_saleIsActive = false;

    address internal constant milady = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;

    address internal constant miladystation = 0xB24BaB1732D34cAD0A7C7035C3539aEC553bF3a0;

    address internal constant remilio = 0xD3D9ddd0CF0A5F0BFB8f7fcEAe075DF687eAEBaB;

    address internal constant miaura = 0x2fC722C1c77170A61F17962CC4D039692f033b43;

    address internal constant cig = 0xEEd41d06AE195CA8f5CaCACE4cd691EE75F0683f;

    uint256 public bottlePrice;
    uint256 public friendPrice;
    uint256 public bulkPrice;

    constructor() ERC721A("MiladyColaTest", "MCT") {
        _initializeOwner(0xFfDAe607cd28f6Db1303eC333Aa37A13E01f78Dd);
        bottlePrice = 12500000000000000;
        friendPrice = 10000000000000000;
        bulkPrice = 11000000000000000;
    }

    function changePrice(uint256 bottle, uint256 friend, uint256 bulk) public onlyOwner {
        bottlePrice = bottle;
        friendPrice = friend;
        bulkPrice = bulk;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        IPFSURI = baseURI;
    }

    function _baseURI() internal view virtual override(ERC721A) returns (string memory) {
        return IPFSURI;
    }
    
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    // MiladyCola Friend check for frontend
    function miladyHolderCheck(address holder) public view returns (uint256) {
        uint256 tokenNum;
        try ERC721(milady).balanceOf(holder) returns (uint256 miladyHolderIndex) {
            tokenNum = miladyHolderIndex;
        } catch (bytes memory) {
            // No tokens owned by user
        }
        try ERC721(remilio).balanceOf(holder) returns (uint256 index) {
            tokenNum = tokenNum + index;
        } catch (bytes memory) {
            // No tokens owned by user
        }
        try ERC721(miaura).balanceOf(holder) returns (uint256 index) {
            tokenNum = tokenNum + index;
        } catch (bytes memory) {
            // No tokens owned by user
        }
        try ERC721(cig).balanceOf(holder) returns (uint256 index) {
            tokenNum = tokenNum + index;
        } catch (bytes memory) {
            // No tokens owned by user
        }
        try ERC721(miladystation).balanceOf(holder) returns (uint256 index) {
            tokenNum = tokenNum + index;
        } catch (bytes memory) {
            // No tokens owned by user
        }
        return tokenNum;
    }
    
    
    function flipSaleState() public onlyOwner {
        s_saleIsActive = !s_saleIsActive;
    }

    modifier miladyFriends() {
        require(
            (ERC721(milady).balanceOf(msg.sender) > 0) ||
            (ERC721(remilio).balanceOf(msg.sender) > 0) ||
            (ERC721(miaura).balanceOf(msg.sender) > 0) ||
            (ERC721(cig).balanceOf(msg.sender) > 0) ||
            (ERC721(miladystation).balanceOf(msg.sender) > 0),
                      
            "You need at least one Milady friend"
        );
        _;
    }

    function mintNew(uint256 numberOfTokens) public payable {
        require(s_saleIsActive, "Sale must be active to mint");
        require(totalSupply() + numberOfTokens < s_MAXMILADYCOLA, "Purchase would exceed max supply");
        require(numberOfTokens < 25, "one 24 pack at a time");
        require(bottlePrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
        
        _safeMint(msg.sender, numberOfTokens);
    }

    function mintFriend(uint256 numberOfTokens) public payable miladyFriends {
        uint256 sup = totalSupply();
        require(s_saleIsActive, "Sale must be active to mint");
        require(sup + numberOfTokens < s_MAXMILADYCOLA, "Purchase would exceed max supply");
        require(numberOfTokens < 25, "one 24 pack at a time");
        require(friendPrice*(numberOfTokens) <= msg.value, "Ether value sent is not correct");
        if (sup < 349) {
            numberOfTokens = numberOfTokens + 1;
        }
        _safeMint(msg.sender, numberOfTokens);
    }

}