import requests
import os
import json

def fetch_contributors(repo_owner, repo_name):
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/contributors"
    response = requests.get(url)
    contributors_data = response.json()
    return contributors_data

def download_avatar(contributor, output_dir):
    avatar_url = contributor['avatar_url']
    avatar_name = f"{avatar_url.split('/')[-1]}.jpg"
    avatar_path = os.path.join(output_dir, avatar_name)    
    with open(avatar_path, 'wb') as avatar_file:
        response = requests.get(avatar_url)
        avatar_file.write(response.content)
    return avatar_name

def main(repo_owner, repo_name):
    contributors_data = fetch_contributors(repo_owner, repo_name)
    output_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), '../assets/contributors/')
    avatar_output_dir = os.path.join(output_dir, 'avatars')
    json_output_dir = os.path.join(output_dir, 'git.json')
    os.makedirs(avatar_output_dir, exist_ok=True)
    
    contributors = []
    for contributor in contributors_data:
        avatar_name = download_avatar(contributor, avatar_output_dir)
        contributor_info = {
            'username': contributor['login'],
            'avatar_url': f'assets/contributors/avatars/{avatar_name}',
            'profile_url': contributor['html_url']
        }
        contributors.append(contributor_info)
    
    with open(json_output_dir, 'w') as json_file:
        json.dump(contributors, json_file, indent=4)
    print("Contributors data saved to git.json")

if __name__ == "__main__":
    repo_owner = "vicolo-dev"
    repo_name = "chrono"
    main(repo_owner, repo_name)
