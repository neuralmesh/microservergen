import sys
from langchain.chains import LLMChain
from langchain.llms import OpenAI

def process_issue_data(issue_data):
    llm = LLMChain(llm=OpenAI())

    response = llm.ainvoke({"topic": issue_data})
    return response.content

if __name__ == "__main__":
    issue_data = sys.argv[1]
    
    response_content = process_issue_data(issue_data)
    
    with open("ai_response.txt", "w") as file:
        file.write(response_content)

