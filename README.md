# Whoppex

Erlixir based load generation tool and sample application

## Features

* Clean separation of "what" from "how" in test plans and scenarios
  * Plans are lists of arbitrary function names indicating steps to perform
  * Steps can also be sublists which will be expanded
	* Steps may also use built-in constructs
		* repeat/repeat_for_period/forever
		* delay/pause
    * noop
  * Common functions can be overridden
		* init - initialize state 1 time at the begining
		* id - set id for a given agent, used in identification and logging
* Core is not protocol dependent
* Agent control is through the Commander
	* Launching agents can take many forms and involves creating an Agent "spec" structurej
		* one agent, many, or a list
		* immediate, every ___ time units, or all over ___ time unit ("ramp-in")
  * Stop all agents
	* Count living agents
* Agents may carry their own state along (e.g. identity, cookies, open socket)
* Includes sample agent (sample app under umbrella) to demonstrate basic concepts and common protocols (HTTP, Logging, and MQTT)

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
  * iex -S mix
  * Sample.Launcher.launch(:logging | :http | :mqtt) # OR
  * Sample.Launcher.launch_many(:logging | :http | :mqtt, times ) # where times is optional and defaults to 10, OR
  * Sample.Launcher.launch_mix()
4. _OR_ run code from mix
  * mix run --no-halt -e 'Sample.Launcher.launch_mix()' # OR SIMILAR AS ABOVE

### To demonstrate agent shutdown

From one terminal session, start agents

    elixir --sname test1 --cookie 321 -S mix run --no-halt -e 'Sample.Launcher.launch_many(:http)'

From another session, connect to remote shell and tell supervisor to stopp agent children

    iex --sname test2 --cookie 321 --remsh test1@devenv
    iex(test1@devenv)1> Whoppex.Supervisor.stop_all_agents()

### How to use whoppex app in your own project

to do

## Project To Do

### In Sample

- Ease of use for tracking cookies and the like for HTTP
- Consider switching (or trying out) Bus library for MQTT as it may be more mature: https://i-m-v-j.github.io/Bus/
- Demonstrate some sort of secure comm with HTTP and MQTT, ideally with unique identies and certificate usage

### In Whoppex

- Change pause impl to not sleep but delay send of next msg to actor to allow for kill or other cmd during pause/delay
- Mechanism to report (e.g. publish to mqtt, log, etc) status of agents (e.g. # alive, state of test, etc) and configurable intervals
- Mechanism to generate basic reports of success or data over time (this may be out of scope)
- Mechanism to supply whoppex with full "scenario" and have it figure thigs out instead of individual function calls
- Integration with statd/graphite/etc for event tracking and test visualization
- Logging to track agent and test success, agent errors, status codes, etc
- Ability to run from cmd line with some sort of preset configuration
- Easy distributed testing modes (launch agents round-robin or preset across nodes)
	- relaunch agents on other nodes or redistribute based on load
- Ability to set "fixed" number of agents and restart on death or end of plan to maintain "averager user load"
- Document usage and consider how other people can use the base app, integrate with their own
    elixir apps, or ideally use without having to build their own app (e.g. with .exs files)
- Full test coverage
- Passing ci build
- Include type specs, review with dializer?
- Publish to hex

