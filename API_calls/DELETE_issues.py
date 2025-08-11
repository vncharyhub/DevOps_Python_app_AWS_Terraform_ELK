lock_url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/issues/{issue_number}/lock"
lock_data = {"lock_reason": "resolved"}

response = requests.put(lock_url, headers=headers, json=lock_data)

if response.status_code == 204:
    print("Issue locked successfully!")
else:
    print(f"Failed to lock issue: {response.status_code}")
    print(response.json())
