// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// import "../interfaces/.sol";

import "../structs/RewardDetail.sol";
import "../structs/RewardSeekerDetail.sol";
import "../structs/RewardRateDetail.sol";

import "../structs/SeekerDetail.sol";

import "../enums/RewardStatus.sol";

contract UnihornJobNFT is ERC721, AccessControl {
    using Counters for Counters.Counter;

    RewardDetail[] public rewardDetails;
    RewardSeekerDetail[] public rewardSeekerDetails;
    RewardRateDetail[] public rewardRateDetails;

    mapping(uint => SeekerDetail[]) public seekers;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    // IUnihornFreelancerNFT public freelancerNft;

    constructor(address _jobFactory,address _freelancerNft) ERC721("RewardNFT", "RWD") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, _rewardFactory);
        // freelancerNft = IUnihornFreelancerNFT(_freelancerNft);
    }

    function RewardMint(
      address to,
      string memory _rewardName,
      string memory _rewardDescription,
      bool active,
      uint _rewardAmount,
      bool _isDeadline,
      uint _rewardDeadline,
      uint _maxSeekerAmount
      
    ) external onlyRole(MINTER_ROLE) returns(uint) {
      uint256 tokenId = _tokenIdCounter.current();
      _tokenIdCounter.increment();
      _safeMint(to, tokenId);

      RewardDetail memory detail;
      RewardSeekerDetail memory seeker;

      detail.name = _rewardName;
      detail.description = _rewardDescription;
      detail.maxRewardSeeker = _maxRewardSeeker;
      detail.rewardAmount = _rewardAmount;
      detail.currentStatus = JobStatus.Pending;
      detail.rewardDeadline = _Deadline;
      detail.client = to;
      

      rewardDetails.push(detail);
      rewardSeekerDetails.push(seeker);
      rewardRateDetails.push(RewardRateDetail(0,0,false,false));

      return tokenId;
    }

    // State Changing Functions

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}


    function sentRewardPayment(uint jobId) payable external onlyRewardOwner(rewardId,msg.sender) onlyPendingStatus(rewardId) {
      RewardDetail storage detail = rewardDetails[rewardId];
      require(detail.paymentAmount == msg.value,"PAYMENT AMOUNT WRONG");

      detail.currentStatus = RewardStatus.PaymentReceived;
    }

    

    function paymentWithdraw(uint jobId) onlyFreelancer(msg.sender) onlyPaymentStatus(jobId) external {
      RewardDetail storage detail = rewardDetails[rewardId];

      (bool success, ) = msg.sender.call{value: address(this).balance}("");
      require(success == true,"PAYMENT ERROR");

      detail.currentStatus = RewardStatus.Finished;
    }

    function cancelReward(uint jobId) notPaymentStatus(jobId) external {
      RewardDetail storage detail = rewardDetails[rewardId];
      RewardSeekerDetail storage rewardSeekerDetail = rewardSeekerDetails[rewardId];

    //   (bool freelancerSent, ) = address(jobBidderDetail.chosenBidderAddress).call{value: jobBidderDetail.chosenBidderAmount}("");
    //   require(freelancerSent == true,"ERROR SENDING FREELANCER CLIENT INITIAL BID AMOUNT");

    //   (bool clientSent, ) = address(ownerOf(jobId)).call{value: address(this).balance}("");
    //   require(clientSent == true,"ERROR SENDING JOB CLIENT INITIAL PAYMENT");

      detail.currentStatus = RewardStatus.Canceled;
    }

    // Utility

    function getAllSeekers(uint rewardId) external view returns(SeekerDetail[] memory){
      return seekers[rewardId];
    }

    // Modifiers

    modifier onlyRewardOwner(uint rewardId,address _owner) {
      require(ownerOf(rewardId) == _owner,"NOT REWARD OWNER");
      _;
    }

    modifier notPaymentStatus(uint id) {
      RewardDetail memory detail = rewardDetails[id];
      require(detail.currentStatus != RewardStatus.Payment, "CURRENTLy IN PAYMENT STATUS");
      _;
    }

    modifier onlyPaymentStatus(uint id) {
      RewardDetail memory detail = rewardDetails[id];
      require(detail.currentStatus == RewardStatus.Payment, "NOT PAYMENT STATUS");
      _;
    }

    modifier onlyPendingStatus(uint id) {
      RewardDetail memory detail = rewardDetails[id];
      require(detail.currentStatus == RewardStatus.Pending, "NOT PENDING STATUS");
      _;
    }

    modifier onlyRatingStatus(uint id) {
      RewardDetail memory detail = jobDetails[id];
      require(detail.currentStatus == RewardStatus.Rating, "NOT RATING STATUS");
      _;
    }

    modifier onlyFinishedStatus(uint id) {
      RewardDetail memory detail = rewardDetails[id];
      require(detail.currentStatus == RewardStatus.Finished, "NOT FINISHED STATUS");
      _;
    }

    modifier onlyStartedStatus(uint id) {
      RewardDetail memory detail = rewardDetails[id];
      require(detail.currentStatus == RewardStatus.Started, "NOT STARTED STATUS");
      _;
    }

    modifier onlyPaymentReceivedStatus(uint id) {
      RewardDetail memory detail = rewardDetails[id];
      require(detail.currentStatus == RewardStatus.PaymentReceived, "NOT PAYMENT RECEIVED STATUS");
      _;
    }
    
    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
