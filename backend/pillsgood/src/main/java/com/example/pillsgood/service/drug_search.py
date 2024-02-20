import requests
import xml.etree.ElementTree as ET
import sys

url = sys.argv[1]
response = requests.get(url)

if response.status_code == 200:
    xml_data = response.content
    root = ET.fromstring(xml_data)

    for item in root.findall('./body/items/item'):
        item_name = item.find('ITEM_NAME').text
        print(item_name)

else:
    print('API Failed')
