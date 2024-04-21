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

## Chapter 3:
- A mutex is a token that passed from one thread to another. allowing one thread at a time to proceed
- critical section
  - the code that needs to be protected is called the critical section
  - critical section is a room that only one thread is allowed to be in the room.
- semaphore of n starting value can be considered as the set of token 
- barrier can be created by using two semaphore
  - one for managing the mutual exclusion when updating the variable of count
  - one for barrier
- turnstile
  - wait followed by signal in a rapid succession
  - versatile component
  - drawbacks it forces only one thread go through hence more context switching
- A common source of deadlocks
  - blocking on a semaphore while holding a mutex
- two-phase barrier
  - phase 1: all threads wait while entering the critical section
  - phase 2: all threads wait while leaving the critial section
- Semaphore and Queue
  - When semaphore with init value as 0
  - it can be interpreted as queue
    - Acquire == Push
    - Release == Pop
  
## Chapter 4:
- Producer & Consumer
  - any time you wait for a semaphore while holding a mutex, there is a danger of deadlock
  - for best performances: release mutex before signalling
  - avoid deadlock, check availability before getting the mutex
- Reader & Writer Problems:
  - Any number of readers can be in the critical section simultaneously
  - Writers must have exclusive access to the critical section
  - categorical mutual exclusion
    - A thread in a particular category in the critical section excludes other categories