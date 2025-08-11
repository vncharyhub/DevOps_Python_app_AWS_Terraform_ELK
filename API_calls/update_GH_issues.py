import requests

token = "GITHUB_TOKEN"
repo_owner = "vncharyhub"
repo_name = "DevOps_Python_app_AWS_Terraform_ELK"
issue_number = 3

url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/issues/{issue_number}"

headers = {
    "Authorization": f"token {token}",
    "Accept": "application/vnd.github+json"
}

data = {
    "title": "Updated title from API",
    "body": "Updated issue body content",
    "state": "closed"
}

response = requests.patch(url, headers=headers, json=data)

if response.status_code == 200:
    print("Issue updated successfully!")
    issue = response.json()
    print(f"New title: {issue['title']}")
    print(f"State: {issue['state']}")
else:
    print(f"Failed to update issue: {response.status_code}")
    print(response.json())
