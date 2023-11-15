// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // Structure to represent a candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Mapping to store voters and their voting status
    mapping(address => bool) public voters;

    // Array to store the list of candidates
    Candidate[] public candidates;

    // Mapping to store the vote count for each candidate
    mapping(uint256 => uint256) public votesReceived;

    // Event to notify when a vote is cast
    event Voted(address indexed voter, uint256 candidateIndex);

    // Owner of the contract
    address public owner;
    
    // Modifier to ensure that only the owner can perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Modifier to ensure that only registered voters can votePP
    modifier onlyRegisteredVoter() {
        require(voters[msg.sender], "You are not a registered voter");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to register a voter
    function registerVoter(address _voter) external onlyOwner {
        require(!voters[_voter], "Voter already registered");
        voters[_voter] = true;
    }

    // Function to add a candidate
    function addCandidate(string memory _name) external onlyOwner {
        candidates.push(Candidate({name: _name, voteCount: 0}));
    }

    // Function to cast a vote
    function vote(uint256 _candidateIndex) external onlyRegisteredVoter {
        require(_candidateIndex < candidates.length, "Invalid candidate index");
        require(votesReceived[_candidateIndex] < 1, "You can only vote once for a candidate");

        votesReceived[_candidateIndex]++;
        emit Voted(msg.sender, _candidateIndex);
    }

    // Function to get the total votes for a candidate
    function getVotesForCandidate(uint256 _candidateIndex) external view returns (uint256) {
        require(_candidateIndex < candidates.length, "Invalid candidate index");
        return votesReceived[_candidateIndex];
    }
}