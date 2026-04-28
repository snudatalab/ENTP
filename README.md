# ENTP

This repository is the official implementation of "Fast and Accurate Element-Level Streaming CP Decomposition for Higher-Order Tensors" (ICDE 2026).

## Abstract

How can we efficiently and accurately analyze a tensor when only partial observations arrive over time? In an element-level streaming setting, only a subset of entries within the newest slice of a tensor is revealed at each update, either individually or in small groups. This formulation naturally arises when seasonal multivariate time-series are folded into higher-order tensors to separate periodic components (e.g., day-of-week) from longer trends, and new data appear as elements rather than full slices. Existing streaming tensor decomposition methods, designed for slice-level updates, become inefficient or inaccurate when applied to element-level streams.

In this paper, we propose ENTP (Element-Level Streaming CP Decomposition), a fast and accurate online tensor decomposition method specifically designed for element-level tensor streams. ENTP partitions observations into structured subtensors and reformulates the optimization to include only the newly revealed entries, enabling accurate updates that affect only the relevant factors while avoiding redundant computation. Extensive experiments on real-world datasets show that ENTP achieves up to $28\times$ speed-up over state-of-the-art baselines for streaming tensor decomposition, while maintaining comparable or higher accuracy. We further demonstrate that ENTP delivers strong predictive performance and scalability, confirming its effectiveness for real-time applications.

## Prerequisites

Our code requires Tensor Toolbox (available at https://gitlab.com/tensors/tensor_toolbox).

## Datasets

The datasets are available at [VicRoads](https://github.com/florinsch/BigTrafficData), [PEMS](https://www.timeseriesclassification.com/), and [Electricity](https://archive.ics.uci.edu/dataset/321/electricityloaddiagrams20112014).

| Dataset     | Total Size (order 3)         | Total Size (order 4)                 | Update Size |
| ----------- | ---------------------------- | ------------------------------------ | ----------- |
| VicRoads    | $1084 \times 96 \times 2030$ | $1084 \times 96 \times 7 \times 290$ | $1084$      |
| PEMS        | $963 \times 144 \times 448$  | $963 \times 144 \times 7 \times 64$  | $963$       |
| Electricity | $370 \times 96 \times 1092$  | $370 \times 96 \times 7 \times 156$  | $370$       |

## Reference

If you use this code, please cite the following paper.
```bibtex
@inproceedings{lee2026fast,
  author={Lee, Jeongyoung and Lee, SeungJoo and Kang, U},
  title={Fast and Accurate Element-Level Streaming CP Decomposition for Higher-Order Tensors},
  booktitle    = {42nd {IEEE} International Conference on Data Engineering, {ICDE} 2026},
  publisher    = {{IEEE}},
  year         = {2026},
}
