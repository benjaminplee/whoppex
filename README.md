# Whoppex

Erlixir based load generation tool

## Features

* Clean separation of "what" from "how" in test plans and scenarios
  * Plans are lists of arbitrary function names indicating steps to perform
  * Steps can also be sublists which will be expanded
	* Steps may also use built-in constructs
		* repeat/forever
		* delay/pause
* Core is not protocol dependent
* Ability to launch one agent, many agents, or list of agents
* Agents may carry their own state along (e.g. identity, cookies, open socket)
* Includes sample agent (sample app under umbrella) to demonstrate basic concepts

## Installing / How to Use

to do

## To Do

### In Sample
- Ease of use for tracking cookies and the like for HTTP
- Example of non-HTTP agents

### In Whoppex
- Mechanism for ramp up and down of agents
- integration with statd/graphite/etc for event tracking and test visualization
- Logging to track agent and test success, agent errors, status codes, etc
- Ability to run from cmd line with some sort of preset configuration
- Easy distributed testing modes (launch agents round-robin or preset across nodes)
	- relaunch agents on other nodes or redistribute based on load
- ability to set "fixed" number of agents and restart on death or end of plan to maintain "averager user load"
- document usage and consider how other people can use the base app, integrate with their own
    elixir apps, or ideally use without having to build their own app (e.g. with .exs files)
- full test coverage
- passing ci build
- include type specs, review with dializer?
- publish to hex
