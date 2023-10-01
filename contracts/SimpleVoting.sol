// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleVoting {
    
    uint public counter = 0;
    address public owner;

    // the structure of a ballot object
    struct Ballot {
        string question;
        string[] options;
        uint startTime;
        uint duration;
    }

    // the structure of the voter
      struct Voter {
        address voterAddress;
        bool hasVoted;  // if true, that person already voted

    }

    modifier onlyOwner(){
    require(msg.sender == owner);
    _;
}

    mapping(uint => Ballot) private _ballots;

    mapping(uint => mapping(uint => uint)) private _tally;
    mapping(uint => mapping(address => bool)) public hasVoted;

   
    Voter[] public voters;

// only owner can create Ballot
   function createBallot(
        string memory question_,
        string[] memory options_,
        uint startTime_,
        uint duration_
    ) external  onlyOwner(){
        require(duration_ > 0, "Duration must be greater than 0");
        require(startTime_ > block.timestamp, "Start time must be in the future");
        require(options_.length >= 2, "Provide at minimum two options"); // new
        _ballots[counter] = Ballot(question_, options_, startTime_, duration_);
        counter++;
    }

    // only Owner can register voter

    function registerVoter(address voter) external onlyOwner(){
     
            voters.push(Voter({
                voterAddress : voter,
                hasVoted: false

            }));
        

    }

    function getBallotByIndex(uint index_) external view returns (Ballot memory ballot) {
        ballot = _ballots[index_];
    }


   function castVote(uint ballotIndex_, uint optionIndex_) external {
  require(!hasVoted[ballotIndex_][msg.sender], "Address already casted a vote for ballot"); // new
  Ballot memory ballot = _ballots[ballotIndex_];
  require(block.timestamp >= ballot.startTime, "Can't cast before start time");
  require(block.timestamp < ballot.startTime + ballot.duration, "Can't cast after end time");
  _tally[ballotIndex_][optionIndex_]++;
  hasVoted[ballotIndex_][msg.sender] = true;
}

function getTally(uint ballotIndex_, uint optionIndex_) external view returns (uint) {
  return _tally[ballotIndex_][optionIndex_];
}

//only owner can compile results
function results(uint ballotIndex_) external onlyOwner() view returns (uint[] memory) {
  Ballot memory ballot = _ballots[ballotIndex_];
  uint len = ballot.options.length;
  uint[] memory result = new uint[](len);
  for (uint i = 0; i < len; i++) {
    result[i] = _tally[ballotIndex_][i];
  }
  return result;
}

//Only owner can call winners
function winners(uint ballotIndex_) external onlyOwner() view returns  (bool[] memory) {
  Ballot memory ballot = _ballots[ballotIndex_];
  uint len = ballot.options.length;
  uint[] memory result = new uint[](len);
  uint max;
  for (uint i = 0; i < len; i++) {
    result[i] = _tally[ballotIndex_][i];
    if (result[i] > max) {
      max = result[i];
    }
  }
  bool[] memory winner = new bool[](len);
  for (uint i = 0; i < len; i++) {
    if (result[i] == max) {
      winner[i] = true;
    }
  }
  return winner;
}


}