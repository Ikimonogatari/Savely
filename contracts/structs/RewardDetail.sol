// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../enums/RewardStatus.sol";

struct RewardDetail {
  string name;
  string description;

  uint maxRewardSeeker;
  uint rewardAmount;
  RewardStatus currentStatus;
  address client;
  uint rewardDeadline;

}
