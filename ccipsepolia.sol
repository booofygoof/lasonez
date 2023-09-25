// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

import "sushi/uniswapv2/interfaces/IERC20.sol";
//import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
//import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "../solady/utils/MerkleProofLib.sol";

//flow
//user pays tickets on main, sending message of how many they want
//contract logs their address and closes the valve for processing
//sends message to polygon contianing a string of numbers
//polygon vrf ccip contract recieves the message and requests the number of words according to the string
//the fulfillment of the randomness checks whether they won and then sends a string back with 1 or 0 indicating what happened
//the mainnet contract receives a message and automatically sends the prize to the logged address IF they won
//regardless, it erases the saved address and opens the valve for the next entrant

//on ethereum mainnet we need
//ccip send and recieve LINK 
//prize doling auto
//valve and address storage
//merkle proof

//on polygon we need
//ccip send and recieve NATIVE
//vrf request and fulfill


//ETHEREUM SEPOLIA CONTRACT


/// @title - A simple messenger contract for sending/receving string data across chains.
//contract MessengerRaffle is VRFConsumerBaseV2, CCIPReceiver, OwnerIsCreator  {
contract MessengerRaffle is CCIPReceiver, OwnerIsCreator  {
    // Custom errors to provide more descriptive revert messages.
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); // Used to make sure contract has enough balance.
    error NothingToWithdraw(); // Used when trying to withdraw Ether but there's nothing to withdraw.
    error FailedToWithdrawEth(address owner, address target, uint256 value); // Used when the withdrawal of Ether fails.
    error DestinationChainNotWhitelisted(uint64 destinationChainSelector); // Used when the destination chain has not been whitelisted by the contract owner.
    error SourceChainNotWhitelisted(uint64 sourceChainSelector); // Used when the source chain has not been whitelisted by the contract owner.
    error SenderNotWhitelisted(address sender); // Used when the sender has not been whitelisted by the contract owner.

    error RaffleNotLive(string err);
    error IncorrectFee(string err);
    error MembersOnly(string err);
    //error RequestFail(string err);
    error NoDice(string err);

    //event RequestSent(uint256 requestId, uint32 numWords);
    //event RequestFulfilled(address playa, uint256 requestId, uint256[] randomWords);
    event clubWinner(address playa);

    event MessageSent(
        bytes32 indexed messageId, // The unique ID of the CCIP message.
        uint64 indexed destinationChainSelector, // The chain selector of the destination chain.
        address receiver, // The address of the receiver on the destination chain.
        string text, // The text being sent.
        address feeToken, // the token address used to pay CCIP fees.
        uint256 fees // The fees paid for sending the CCIP message.
    );

    event MessageReceived(
        bytes32 indexed messageId, // The unique ID of the CCIP message.
        uint64 indexed sourceChainSelector, // The chain selector of the source chain.
        address sender, // The address of the sender from the source chain.
        string text // The text that was received.
    );

        //request struct linkvrf
    // struct RequestStatus {
    //     bool fulfilled; // whether the request has been successfully fulfilled
    //     bool exists; // whether a requestId exists
    //     uint256[] randomWords;
    //     address playa;
    // }

    bytes32 private lastReceivedMessageId; // Store the last received messageId.
    string private lastReceivedText; // Store the last received text.
    

    // mapping(uint256 => RequestStatus)
    // public s_requests; /* requestId --> requestStatus */
    //VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    //uint64 s_subscriptionId;

    // past requests Id.
    //uint256[] public requestIds;
    //uint256 public lastRequestId;

    // 500gwei gaslane mainnet
    //bytes32 keyHash =
    //    0xff8dedfbfa60af186cf3c830acbc32c05aae823045ae5ea7da1e45fbfaba4f92;


    // sepolia gaslane
    // bytes32 keyHash = 
    //     0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    // uint32 callbackGasLimit = 120000;
    // uint16 requestConfirmations = 3;

    uint64 sisterDestination;
    address sisterReciever;

    uint32 public oddsClub;
    uint256 public clubTicketPrice;
    uint32 public clubPops;
    address public clubPrizeCA;
    bool public raffleOn;
    bool public valveO;
    address public atBat;
    //change to private
    bytes32 public root = 0xfcfefff7408ac3cfb359feca5693768eab79688191f8ecfedbc05d20a3fd10eb;

    //variable prize for bottle club
    IERC20Uniswap _tertx;
    
    mapping(uint64 => bool) public whitelistedDestinationChains;

    mapping(uint64 => bool) public whitelistedSourceChains;

    mapping(address => bool) public whitelistedSenders;

    LinkTokenInterface linkToken;

    //NETWORK 115511 Sepolia coordinator
    //0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
    //network mumbai
    //0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed

    constructor
        (address _ccrouter, address _link
        //,address _vrfrouter, 
        //uint64 _subscriptionId
        )
        CCIPReceiver(_ccrouter) 
        //VRFConsumerBaseV2(_vrfrouter) 
    {
        linkToken = LinkTokenInterface(_link);
        //COORDINATOR = VRFCoordinatorV2Interface(_vrfrouter);
        //s_subscriptionId = _subscriptionId;
    }

/*
 ::::::::   :::::::: ::::::::::: :::::::::        :::::::: ::::::::::: :::    ::: :::::::::: :::::::::: 
:+:    :+: :+:    :+:    :+:     :+:    :+:      :+:    :+:    :+:     :+:    :+: :+:        :+:        
+:+        +:+           +:+     +:+    +:+      +:+           +:+     +:+    +:+ +:+        +:+        
+#+        +#+           +#+     +#++:++#+       +#++:++#++    +#+     +#+    +:+ :#::+::#   :#::+::#   
+#+        +#+           +#+     +#+                    +#+    +#+     +#+    +#+ +#+        +#+        
#+#    #+# #+#    #+#    #+#     #+#             #+#    #+#    #+#     #+#    #+# #+#        #+#        
 ########   ######## ########### ###              ########     ###      ########  ###        ###        
*/


    function init() public onlyOwner {
        //sepolia whitelisting mumbai
        whitelistedDestinationChains[12532609583862916517] = true;
        whitelistedSourceChains[16015286601757825753] = true;

        //polygon whitelisting sepolia
        //whitelistedDestinationChains[16015286601757825753] = true;
        //whitelistedSourceChains[12532609583862916517] = true;
    }

    modifier onlyWhitelistedDestinationChain(uint64 _destinationChainSelector) {
        if (!whitelistedDestinationChains[_destinationChainSelector])
            revert DestinationChainNotWhitelisted(_destinationChainSelector);
        _;
    }

    modifier onlyWhitelistedSourceChain(uint64 _sourceChainSelector) {
        if (!whitelistedSourceChains[_sourceChainSelector])
            revert SourceChainNotWhitelisted(_sourceChainSelector);
        _;
    }

    modifier onlyWhitelistedSenders(address _sender) {
        if (!whitelistedSenders[_sender]) revert SenderNotWhitelisted(_sender);
        _;
    }

    function whitelistDestinationChain(
        uint64 _destinationChainSelector
    ) external onlyOwner {
        whitelistedDestinationChains[_destinationChainSelector] = true;
    }

    function denylistDestinationChain(
        uint64 _destinationChainSelector
    ) external onlyOwner {
        whitelistedDestinationChains[_destinationChainSelector] = false;
    }

    function whitelistSourceChain(
        uint64 _sourceChainSelector
    ) external onlyOwner {
        whitelistedSourceChains[_sourceChainSelector] = true;
    }

    function denylistSourceChain(
        uint64 _sourceChainSelector
    ) external onlyOwner {
        whitelistedSourceChains[_sourceChainSelector] = false;
    }

    function whitelistSender(address _sender) external onlyOwner {
        whitelistedSenders[_sender] = true;
    }

    function denySender(address _sender) external onlyOwner {
        whitelistedSenders[_sender] = false;
    }

    /// @notice Sends data to receiver on the destination chain.
    /// @notice Pay for fees in LINK.
    /// @dev Assumes your contract has sufficient LINK.
    /// @param _destinationChainSelector The identifier (aka selector) for the destination blockchain.
    /// @param _receiver The address of the recipient on the destination blockchain.
    /// @param _text The text to be sent.
    /// @return messageId The ID of the CCIP message that was sent.
    function sendMessagePayLINK(
        uint64 _destinationChainSelector,
        address _receiver,
        string calldata _text
    )
        internal
        onlyOwner
        onlyWhitelistedDestinationChain(_destinationChainSelector)
        returns (bytes32 messageId)
    {
        // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
        Client.EVM2AnyMessage memory evm2AnyMessage = _buildCCIPMessage(
            _receiver,
            _text,
            address(linkToken)
        );

        // Initialize a router client instance to interact with cross-chain router
        IRouterClient router = IRouterClient(this.getRouter());

        // Get the fee required to send the CCIP message
        uint256 fees = router.getFee(_destinationChainSelector, evm2AnyMessage);

        if (fees > linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), fees);

        // approve the Router to transfer LINK tokens on contract's behalf. It will spend the fees in LINK
        linkToken.approve(address(router), fees);

        // Send the CCIP message through the router and store the returned CCIP message ID
        messageId = router.ccipSend(_destinationChainSelector, evm2AnyMessage);

        // Emit an event with message details
        emit MessageSent(
            messageId,
            _destinationChainSelector,
            _receiver,
            _text,
            address(linkToken),
            fees
        );

        // Return the CCIP message ID
        return messageId;
    }

    /// @notice Sends data to receiver on the destination chain.
    /// @notice Pay for fees in native gas.
    /// @dev Assumes your contract has sufficient native gas tokens.
    /// @param _destinationChainSelector The identifier (aka selector) for the destination blockchain.
    /// @param _receiver The address of the recipient on the destination blockchain.
    /// @param _text The text to be sent.
    /// @return messageId The ID of the CCIP message that was sent.
    function sendMessagePayNative(
        uint64 _destinationChainSelector,
        address _receiver,
        string calldata _text
    )
        internal
        onlyOwner
        onlyWhitelistedDestinationChain(_destinationChainSelector)
        returns (bytes32 messageId)
    {
        // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
        Client.EVM2AnyMessage memory evm2AnyMessage = _buildCCIPMessage(
            _receiver,
            _text,
            address(0)
        );

        // Initialize a router client instance to interact with cross-chain router
        IRouterClient router = IRouterClient(this.getRouter());

        // Get the fee required to send the CCIP message
        uint256 fees = router.getFee(_destinationChainSelector, evm2AnyMessage);

        if (fees > address(this).balance)
            revert NotEnoughBalance(address(this).balance, fees);

        // Send the CCIP message through the router and store the returned CCIP message ID
        messageId = router.ccipSend{value: fees}(
            _destinationChainSelector,
            evm2AnyMessage
        );

        // Emit an event with message details
        emit MessageSent(
            messageId,
            _destinationChainSelector,
            _receiver,
            _text,
            address(0),
            fees
        );

        // Return the CCIP message ID
        return messageId;
    }

    /// handle a received message
    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    )
        internal
        override
        onlyWhitelistedSourceChain(any2EvmMessage.sourceChainSelector) // Make sure source chain is whitelisted
        onlyWhitelistedSenders(abi.decode(any2EvmMessage.sender, (address))) // Make sure the sender is whitelisted
    {
        bool win;
        address _atBat = atBat;
        lastReceivedMessageId = any2EvmMessage.messageId; // fetch the messageId
        lastReceivedText = abi.decode(any2EvmMessage.data, (string)); // abi-decoding of the sent text
        bytes memory inputBytes = bytes(lastReceivedText);
        win = (inputBytes[0] == bytes1("1"));
        if(win){
            sendIt(_atBat);
            emit clubWinner(_atBat);
        }
        atBat = address(0);
        valveO = true;
        emit MessageReceived(
            any2EvmMessage.messageId,
            any2EvmMessage.sourceChainSelector, // fetch the source chain identifier (aka selector)
            abi.decode(any2EvmMessage.sender, (address)), // abi-decoding of the sender address,
            abi.decode(any2EvmMessage.data, (string))
        );
    }

    function createBytes(string memory str) public pure returns (bytes memory ) {
        return bytes(str);
    }

    // function createAddressBytes(address str) public view returns (bytes20) {
    //     return bytes20(str);
    // }

    // function checkWinLogic(string memory winsim) public pure returns (bool) {
    //     bool win;
    //     bytes memory inputBytes = bytes(winsim);
    //     if (inputBytes.length != 1) {
    //         win = false; // String length is not equal to 1, not equal to "1"
    //     }
    //     win = (inputBytes[0] == bytes1("1"));
    //     return win;
    // }
    
    function bytesToUint(bytes memory data) public pure returns (uint256) {
        uint256 result = 0;

        for (uint256 i = 0; i < data.length; i++) {
            uint8 char = uint8(data[i]);
            
            // Ensure the byte represents a valid ASCII digit (0-9)
            require(char >= 48 && char <= 57, "Invalid character in bytes");
            
            // Subtract ASCII '0' to get the digit's integer value
            char -= 48;
            
            // Multiply the result by 10 and add the digit value
            assembly {
                // Load result into memory
                let temp := result
                
                // Multiply temp by 10
                result := mul(temp, 10)
                
                // Add the digit value to result
                result := add(result, char)
            }
        }
        
        return result;
    }

    // function bytesToAddress(bytes memory data) public pure returns (address) {
    //     require(data.length == 20, "Invalid address length");
        
    //     address addr;
    //     assembly {
    //         addr := mload(add(data, 0x20))
    //     }
    //     return addr;
    // }

    /// @notice Construct a CCIP message.
    /// @dev This function will create an EVM2AnyMessage struct with all the necessary information for sending a text.
    /// @param _receiver The address of the receiver.
    /// @param _text The string data to be sent.
    /// @param _feeTokenAddress The address of the token used for fees. Set address(0) for native gas.
    /// @return Client.EVM2AnyMessage Returns an EVM2AnyMessage struct which contains information for sending a CCIP message.
    function _buildCCIPMessage(
        address _receiver,
        string calldata _text,
        address _feeTokenAddress
    ) internal pure returns (Client.EVM2AnyMessage memory) {
        // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
        Client.EVM2AnyMessage memory evm2AnyMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(_receiver), // ABI-encoded receiver address
            data: abi.encode(_text), // ABI-encoded string
            tokenAmounts: new Client.EVMTokenAmount[](0), // Empty array aas no tokens are transferred
            extraArgs: Client._argsToBytes(
                // Additional arguments, setting gas limit and non-strict sequencing mode
                Client.EVMExtraArgsV1({gasLimit: 200_000, strict: false})
            ),
            // Set the feeToken to a feeTokenAddress, indicating specific asset will be used for fees
            feeToken: _feeTokenAddress
        });
        return evm2AnyMessage;
    }

    function getLastReceivedMessageDetails()
        external
        view
        returns (bytes32 messageId, string memory text)
    {
        return (lastReceivedMessageId, lastReceivedText);
    }

    receive() external payable {}

    function withdraw(address _beneficiary) public onlyOwner {
        // Retrieve the balance of this contract
        uint256 amount = address(this).balance;

        // Revert if there is nothing to withdraw
        if (amount == 0) revert NothingToWithdraw();

        // Attempt to send the funds, capturing the success status and discarding any return data
        (bool sent, ) = _beneficiary.call{value: amount}("");

        // Revert if the send failed, with information about the attempted transfer
        if (!sent) revert FailedToWithdrawEth(msg.sender, _beneficiary, amount);
    }

    function withdrawToken(
        address _beneficiary,
        address _token
    ) public onlyOwner {
        // Retrieve the balance of this contract
        uint256 amount = IERC20Uniswap(_token).balanceOf(address(this));

        // Revert if there is nothing to withdraw
        if (amount == 0) revert NothingToWithdraw();

        IERC20Uniswap(_token).transfer(_beneficiary, amount);
    }

    /*
:::     ::: :::::::::  ::::::::::      :::::::::      :::     :::::::::: :::::::::: :::        :::::::::: 
:+:     :+: :+:    :+: :+:             :+:    :+:   :+: :+:   :+:        :+:        :+:        :+:        
+:+     +:+ +:+    +:+ +:+             +:+    +:+  +:+   +:+  +:+        +:+        +:+        +:+        
+#+     +:+ +#++:++#:  :#::+::#        +#++:++#:  +#++:++#++: :#::+::#   :#::+::#   +#+        +#++:++#   
 +#+   +#+  +#+    +#+ +#+             +#+    +#+ +#+     +#+ +#+        +#+        +#+        +#+        
  #+#+#+#   #+#    #+# #+#             #+#    #+# #+#     #+# #+#        #+#        #+#        #+#        
    ###     ###    ### ###             ###    ### ###     ### ###        ###        ########## ########## 
*/

    // function testStringtoNumber(string calldata numTickets) public pure returns(uint256) {
    //     return bytesToUint(createBytes(numTickets));
    // }

        //Bottle Club
        //this happens on mainnet
    function bottleClubPop(bytes32[] calldata proof,string calldata numTickets) public payable {
        uint256 num = bytesToUint(createBytes(numTickets));
        if(checkClubPrize() == 0){revert RaffleNotLive("RaffleOff");}
        if(!valveO){revert NoDice("Please wait a moment");}
        if(!checkClubMember(proof)){revert MembersOnly("MembersOnly");}
        if(msg.value < clubTicketPrice*num){revert IncorrectFee("BadFee");}
        //requestRandomWords(uint32(10), msg.sender);
        sendMessagePayLINK(sisterDestination,sisterReciever,numTickets);
        unchecked {
            ++clubPops;
        }
        atBat = msg.sender;
        valveO = false;
    }

/*
       // Assumes the subscription is funded sufficiently.
       //happens on polygon
    function requestRandomWords(address player)
        internal
        returns (uint256 requestId)
    {
        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit*10,
            10
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false,
            playa: player
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, 10);
        return requestId;
    }

    //meat and potatos of the raffle here in fulfilment
    //bulk and reg
    //200k gas limit
    //this happens on polygon
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        bool win;
        if(s_requests[_requestId].exists){
            RequestStatus memory request = s_requests[_requestId];
                //MiladyCola Raffle
           
                //milady wincheck
                for (uint8 i = 0; i < _randomWords.length; ++i) {
                    if (_randomWords[i]%oddsClub + 1 == 1) {
                        //milady
                        win = true;
                        emit clubWinner(_requestId, request.playa);
                    }
                }
                //Bottle Club Raffle
            request.fulfilled = true;
            emit RequestFulfilled(request.playa, _requestId, _randomWords);
            if(win){
                sendMessagePayNative(sisterDestination,sisterReciever,"1");
            } else {
                sendMessagePayNative(sisterDestination,sisterReciever,"0");
            }
            
            valveO = true;
        } else {
            revert RequestFail("RequestNotFound");
        }

    }

    */

    function configureClubRaffle(
        address PrizeCoinAddress, 
        uint256 newClubPrice, 
        uint32 newOdds, 
        bytes32 newRoot
        ) public onlyOwner {
        if(PrizeCoinAddress != address(0)){
            clubPrizeCA = PrizeCoinAddress;
            _tertx = IERC20Uniswap(PrizeCoinAddress);
        }
        if(newClubPrice != 1){clubTicketPrice = newClubPrice;}
        if(newOdds != 1){oddsClub = newOdds;}
        if(newRoot != bytes32(0)){root = newRoot;} 
    }

    // function configureVrf(uint32 newGas, bytes32 newLane) public onlyOwner {
    //     callbackGasLimit = newGas;
    //     keyHash = newLane;
    // }

    function goSwitch() public onlyOwner {
        raffleOn = !raffleOn;
    }

    function withdrawClubPrize() public onlyOwner {
        require(
            _tertx.transfer(msg.sender,_tertx.balanceOf(address(this))),
            "Unable to transfer"
        );
    }

    function checkClubPrize() public view returns(uint256 clubPrize) {
        return _tertx.balanceOf(address(this));
    }

    // function getRequestStatus(
    //     uint256 _requestId
    // ) external view returns (bool fulfilled, uint256[] memory randomWords) {
    //     require(s_requests[_requestId].exists, "request not found");
    //     RequestStatus memory request = s_requests[_requestId];
    //     return (request.fulfilled, request.randomWords);
    // }

    function sendIt(address recip) internal {
        //milady
        _tertx.transfer(recip,checkClubPrize());
    }

    //bottle auth
    function checkClubMember(bytes32[] calldata proof) public view returns (bool){
        return MerkleProofLib.verifyCalldata(proof, root, keccak256(abi.encodePacked(bytes20(msg.sender))));
    }

    function checkCheckClubMember() public view returns (bytes32){
        return keccak256(abi.encodePacked(bytes20(msg.sender)));
    }


}
