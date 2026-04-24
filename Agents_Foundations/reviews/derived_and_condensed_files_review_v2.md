# Review of Derived and Condensed Files v2

This review uses the updated framing: not every non-primary file should be judged by the same standard.

## 1. Source-local condensations

These should be judged mainly on:
- fidelity
- edge preservation
- caveat preservation
- usefulness as support material

### `Harness_Engineering.condensed(2).md`
**Verdict:** keep as support, not canonical  
Strong source-local compression, but still secondary to the primary source and weaker than the refined invariant layer for final operating docs.

### `Prompt Caching is Everything.condensed(2).md`
**Verdict:** keep  
High fidelity and still useful as a support artifact.

### `Skills_Use_Anthropic_engineer.condensed(2).md`
**Verdict:** keep, possibly extend  
Strong and usable, but still a source-local summary rather than a policy layer.

---

## 2. User-refined synthesis files

These should be judged mainly on:
- whether they capture the intended operating truth
- whether they make good weighting and tradeoff choices
- whether they deserve canonical status in the final system

### `Agent_Oriented_Thinking(2).md`
**Verdict:** treat as canonical starting point  
This is not just a derived summary. It is already a high-value foundation layer and should be treated with higher weight.

### `Agent_Project_Principles(2).md`
**Verdict:** keep as policy memo / operating synthesis  
This file is useful precisely because it interprets the raw source into operating guidance. It should not be treated as a faithful source-local condensation, but it should influence the invariant layer strongly.

### `Architecture_Doc_Principles(2).md`
**Verdict:** treat as canonical starting point  
One of the strongest files in the corpus. Very little change needed beyond integrating it into a broader weighted system.

---

## 3. Workflow notes and fragments

### `Dex Process on coding with agents.md`
**Verdict:** keep as playbook input, not invariant authority  
High-signal, but too thin and truncated to carry core principles by itself.

### `AI-Engineer-Conference-EU-0426.md`
**Verdict:** keep as supporting notes and candidate-principle source  
Contains strong ideas, especially around reviewability, entropy, and agent-legible architecture, but several items are hypothesis-like and should be marked carefully.

---

## Main change from the previous review

The earlier review over-flattened “condensed” and “derived” into one bucket.  
After your clarification, the right split is:

1. **primary sources**
2. **user-refined syntheses**
3. **source-local condensations**
4. **notes / fragments**

That weighting model is much closer to the job you actually wanted done.
