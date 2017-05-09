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

### Setup dependencies for sample app

Install RabbitMQ on same machine as sample app

    https://www.rabbitmq.com/install-debian.html
    service rabbitmq-server stop
	  sudo rabbitmq-plugins enable rabbitmq_management
    sudo rabbitmqctl add_user test test
    sudo rabbitmqctl set_user_tags test administrator
    sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
    service rabbitmq-server start
	  access via http://localhost:5672 with test:test

### How to run sample app

1. cd umbrella
2. iex -S mix
3. Sample.Launcher.launch(:logging | :http | :mqtt) # OR
4. Sample.Launcher.launch_many(:logging | :http | :mqtt ) # OR
5. Sample.Launcher.launch_mix()

### How to use whoppex app in your own project

to do

## Project To Do

### In Sample
- Ease of use for tracking cookies and the like for HTTP
- Example of non-HTTP agents (e.g. MQTT)

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

