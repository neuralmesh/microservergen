from fastapi import FastAPI
from pydantic import BaseModel
from langchain.chains import LLMChain
from langchain.llms import OpenAI

# Define Pydantic models for request and response
class AIRequest(BaseModel):
    content: str

class AIResponse(BaseModel):
    content: str

# Initialize FastAPI app
app = FastAPI()

# Initialize LLMChain with OpenAI model
llm = LLMChain(llm=OpenAI())

@app.post("/generate", response_model=AIResponse)
async def generate_text(request: AIRequest):
    # Process request using Langchain
    response = await llm.ainvoke({"topic": request.content})
    return AIResponse(content=response.content)

