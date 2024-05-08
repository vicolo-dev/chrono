import csv
import json
import requests
import os

def csv_to_json(csv_file, json_file):
    members = []
    with open(csv_file, 'r') as file:
        csv_reader = csv.DictReader(file)
        for row in csv_reader:
            if(float(row['Lifetime Amount']) > 0):
                member_info = {
                    'name': row['Name'],
                    'lifetime_amount': row['Lifetime Amount'],
                    'email': row['Email'],
                }
                members.append(member_info)
    json_output_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), '../assets/patreons/')
    os.makedirs(json_output_dir, exist_ok=True)
    json_output_path = os.path.join(json_output_dir, 'patreons.json')
    with open(json_output_path, 'w') as json_file:
        json.dump(members, json_file, indent=4)
    print("CSV converted to JSON")

if __name__ == "__main__":
    csv_to_json('patreons.csv', 'patreons.json')
