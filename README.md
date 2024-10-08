# Welcome to BotFlow!

[![Build Status](https://github.com/thezachdrake/BotFlow.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/thezachdrake/BotFlow.jl/actions/workflows/CI.yml?query=branch%3Amain)

> [!Warning]
> This project is under very early development and should not be used in production systems. Our goal is to get to a stable build as soon as possible.

BotFlow is a framework to build LLM and text model pipelines to be integrated into larger programs. You can use BotFlow with an api framework like [Oxygen.jl](https://github.com/OxygenFramework/Oxygen.jl) to creat chat bot and AI services. You can also use BotFlow as part of a feature engineering pipeline to create and modify data for analysis. In the future, BotFlow will include prebuilt flows with validated prompts to summarize tables in a [Tables.jl](https://github.com/JuliaData/Tables.jl) compatable. 

BotFlow differs from other LLM frameworks such as [LangChain](https://github.com/langchain-ai/langchainjs) and [crewAI](https://github.com/crewAIInc/crewAI) because of its empahsize on analysis of LLM outputs and the ability to leverage them in more research driven contexts. While BotFlow is very capable of building production grade systems, its structures and types lend itself to be easier to conduct assessments of LLMs, flows, and prompts. 

## Getting Started

Install this packaged into a Julia project with the following code:

```julia
using Pkg
Pkg.add("BotFlow")
```

Under the hood BotFlow consists of several modules. 
- `BotFlowCore`: This module contains the base types and functions to create flows. These are LLM/platform independant.  
- `BotFlowAnthropic`: This module contains concrete implimentations of certain abstract types to work with [Anthropic](https://docs.anthropic.com/en/docs/welcome). 
- `BotFlowOpenAI`: This module contains concrete implimentations of certain abstract types to work with [OpenAI](https://platform.openai.com/docs/api-reference/introduction).
- `BotFlowHuggingFace`: This module contains concrete implimentations of certain abstract types to work with [HuggingFace](https://huggingface.co/docs/api-inference/detailed_parameters).

Importing the library as a whole will export the modules individually:
```julia
using BotFlow

abstractModel = BotFlowCore.AbstractChatModel()

anthropicModel = BotFlowAnthropic.AnthropicChatModel()
```

This can be cumbersome for reading and writing code and also adds a lot of unneeded types to the Julia session. 

Instead it is recommended to import the submodules directly.

```julia
#always import core
using BotFlow.BotFlowCore

#import Anthropic
using BotFlow.BotFlowAnthropic

#import OpenAi
using BotFlow.BotFlowOpenAI

#import HuggingFace
using BotFlow.BotFlowHuggingFace
```

## Core Components

BotFlow is built around *flows*. A `AbstractFlow` is essentially a DAG *(directed acyclic graph)* that takes in an `AbstractContext` and executes a squenece of `AbstractStep`. Each `AbstractStep` modifies the context in some way. The three main types of steps are:
- `AbstractPromptTemplate`: Takes a string and injects data or parameters into it to form a prompt for an LLM.
- `AbstractLangModel`: An interface to an LLM/FM that runs inference on the information in the context.
- `AbstractProcess`: A user defined function that can perform operations on the context.

These steps can be chained together into a flow using the `->` operator as such:

```julia
flow = AbstractPromptTemplate() -> AbstractLangModel() -> AbstractProcess()
```
*Flows* can be one of three types:
- `SequentialFlow`: This flow executes steps one after the other in order.
- `ConditionalFlow`: This flow executes steps in order, but with the ability to conditionaly inlcude or exclude steps as desired. 
- `MultiPathFlow`: This flow runs steps (or other flows) in no defined order, with user created logic determining what runs next based on the context. *(this may or may not ending up being a DAG depending on structure)*

