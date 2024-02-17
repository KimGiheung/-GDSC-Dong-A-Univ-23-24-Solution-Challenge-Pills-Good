import requests

url = 'http://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList'
params ={'serviceKey' : 'ZEIqwtP5ZA9zrY4JJGCxpQAhvjKCMqu1tc2FfqwmYpuEGgev2nzQLuXpg9V%2B4IOjcxUQJZ4ZQOthR2a%2BEi0uIg%3D%3D', 'pageNo' : '1', 'numOfRows' : '3', 'entpName' : '', 'itemName' : '', 'itemSeq' : '', 'efcyQesitm' : '', 'useMethodQesitm' : '', 'atpnWarnQesitm' : '', 'atpnQesitm' : '', 'intrcQesitm' : '', 'seQesitm' : '', 'depositMethodQesitm' : '', 'openDe' : '', 'updateDe' : '', 'type' : 'xml' }

response = requests.get(url, params=params)
print(response.content)