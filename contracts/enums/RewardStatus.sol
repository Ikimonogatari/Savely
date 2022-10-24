// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Pending  - 0
// Started  - 1
// Rating - 2
// Payment - 3
// Finished - 4
// Canceled - 5
enum RewardStatus {
  Pending,
  Started,
  Rating,
  Payment,
  Finished,
  Canceled
}
