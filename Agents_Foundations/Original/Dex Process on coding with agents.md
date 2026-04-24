## Dex Process on coding with agents

- High leverage planning
- Don’t outsource the thinking
- The name of the game is that you only have **approximately 170k** of context window to work with. So it's essential to use as little of it as possible. The **more you use** the context window, the **worse the outcomes** you'll get.

### Research phase

- Keep things Objective: discourage opinions, avoid implementation planning, Research == Compression of Truth
- Hide ticket (or description of the feature or whatever equivalent) from the researcher to preserve objectivity.
- Before doing the actual research there's a previous phase of back and forth based on questions to determine the right questions to answer in the research and what to look for.
- Research is actually divided in first defining the right questions to answer and then doing the actual research.

### Planning Phase

- Planning should be modular too, we can't expect an agent to follow more than the instructions it's able to follow. 
- Don’t use prompts for control flow. Use control flow for control flow. Not just for coding agents.
- Planning can be divided in design, structure outline and final plan.
- Design: discussion with questions to end with a design document
- Structure: based on the information collected previously, we then create an structure outline. If the plan is the full implementation, the outline is C header files
- Plan: the plan should be generated so that it's clear enough to implement this. Models love horizontal plans, it should be vertical plans. The plan can be very detailed, after we've already refined in previous steps to make sure we implement what we need.

- In general, intermediate markdown files should be around 200 lines (it could change base on particular details), and the final plan 