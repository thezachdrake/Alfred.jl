"""
    HumanMessage

Message type for human/user input into LLMs. This type inhernetly indicates that
the content in 'message' was created by a human either through code or user input. 
Messages generated by other parts of an application (such as automation) 
should avoid this type in favor of `ProcessMessage`.
"""
@kwdef struct HumanMessage <: AbstractMessage
    message::String
end


"""
    AIMessage

Message type for output of LLMs. This type inhernetly indicates that
the content in 'message' was created by an LLM. Messages generated by other parts
of an application (such as automation) should avoid this type in favor of `ProcessMessage`.
"""
@kwdef struct AIMessage <: AbstractMessage
    message::String
end

"""
    ProcessMessage

Message type for automated inputs into LLMs. This type inhernetly indicates that
the content in 'message' was created by some kind of automation or is the result of
some other process such as a model or calculation. 
"""
@kwdef struct ProcessMessage <: AbstractMessage
    message::String
end
