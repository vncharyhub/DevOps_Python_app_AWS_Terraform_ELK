import requests

token = "GITHUB_TOKEN"
url = "https://api.github.com/repos/vncharyhub/DevOps_Python_app_AWS_Terraform_ELK/issues"

headers = {
    "Authorization": f"token {token}",
    "Accept": "application/vnd.github+json"
}

data = {
    "title": "Test issue from Python script",
    "body": "This issue was created via the GitHub API using Python requests."
}

response = requests.post(url, headers=headers, json=data)

if response.status_code == 201:
    print("Issue created successfully!")
    issue = response.json()
    print(f"Issue URL: {issue['html_url']}")
else:
    print(f"Failed to create issue: {response.status_code}")
    print(response.json())
