url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/issues?state=open"

response = requests.get(url, headers=headers)

if response.status_code == 200:
    issues = response.json()
    print(f"Total open issues: {len(issues)}")
    for issue in issues:
        print(f"#{issue['number']}: {issue['title']} (State: {issue['state']})")
else:
    print(f"Failed to fetch issues: {response.status_code}")
