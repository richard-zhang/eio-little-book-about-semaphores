## Chapter 1: Introduction

- Serialization: Event A must happen before event B
- Mutual Exclusion: Events A and B must not happen at the same time
- message passing is a real solution for many synchronization problems
- Actor A and B perform actions concurrently if we don't know the **order** of events
- Two events are concurrent if we cannot tell by looking at the program which will happen first
- Shared variable:
  - concurrent writes
  - concurrent updates
- mutex
  - stands for mututal exclusion

## Chapter 2: Semaphore

- Why semaphore?
  - delibrate constraints
  - easy to demonstrate the correctness
  - portable. can be implemented effeciently on many systems