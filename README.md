# Whoppex

Erlixir based load generation tool

## To Do

- Give easy "pause" configurable step ability
- Mechanism to easily create multiple agents with fewer calls and same or varied state/type
- Mechanism for ramp up and down of agents
- integration with statd/graphite/etc for event tracking and test visualization
- Logging to track agent and test success, agent errors, status codes, etc
- Ability to run from cmd line with some sort of preset configuration
- Composable plan elements (repeat group of steps not just one)
- Ease of use for tracking cookies and the like for HTTP
- Example of non-HTTP agents
- Easy distributed testing modes (launch agents round-robin or preset across nodes)
	- relaunch agents on other nodes or redistribute based on load
- ability to set "fixed" number of agents and restart on death or end of plan to maintain
- document usage and consider how other people can use the base app, integrate with their own
    elixir apps, or ideally use without having to build their own app (e.g. with .exs files)
- full test coverage
- passing ci build
