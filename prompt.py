from fastapi import FastAPI
import langchain
from langchain.chains import LLMChain
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate

app = FastAPI()

# Initialize the LLMChain with the OpenAI language model
chain = LLMChain(OpenAI())

@app.post("/prompt")
async def generate_text(prompt: str):
    # Define a prompt template
    template = PromptTemplate(prompt)

    # Generate text using the language model
    result = chain.generate_text(template)

    # Return the generated text as a plain text response
    return {"response": result.text}

