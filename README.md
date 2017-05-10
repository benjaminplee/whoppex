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
* Includes sample agent (sample app under umbrella) to demonstrate basic concepts (HTTP, Logging, and MQTT)

## Installing / How to Use

### Setup dependencies for sample app

Install MQTT Broker, e.g. Mosquitto, for testing

    sudo apt-get install mosquitto mosquitto-clients
    service mosquitto start
    mosquitto_sub -t "#" -v # Setup testing subscriber printing to console

Send test msg (to verify setup)

    mosquitto_pub -t "whoppex/sample" -m "hey"

### How to run sample app

1. cd umbrella
2. mix deps.get
3. Run code in iex
  1. iex -S mix
  2. Sample.Launcher.launch(:logging | :http | :mqtt) # OR
  3. Sample.Launcher.launch_many(:logging | :http | :mqtt ) # OR
  4. Sample.Launcher.launch_mix()
4. OR run code from mix
  1. mix run --no-halt -e 'Sample.Launcher.launch_mix()' # OR SIMILAR AS ABOVE

### How to use whoppex app in your own project

to do

## Project To Do

### In Sample
- Ease of use for tracking cookies and the like for HTTP

### In Whoppex
- Mechnism to stop all currently running agents
- Mechanism to supply whoppex with full "scenario" and have it figure thigs out instead of individual function calls
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

