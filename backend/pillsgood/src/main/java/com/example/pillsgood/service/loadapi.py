import requests
import xml.etree.ElementTree as ET
import sys
import pymysql
import config

def update_or_insert_drug(edi_code, item_name, ingredient_name, entp_name, chart, storage_method, valid_term, effect, dosage, precautions):
    if edi_code is None:
        raise ValueError("EDI_CODE cannot be None")
    conn = pymysql.connect(host=config.DB_HOST, port=config.DB_PORT, user=config.DB_USERNAME, password=config.DB_PASSWORD, db=config.DB_NAME, charset='utf8') 

    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM Drug WHERE EDI_CODE = ?", (edi_code,))
            row = cur.fetchone()

            if row is None:
                cur.execute("""
                    INSERT INTO Drug 
                    (EDI_CODE, ITEM_NAME, INGREDIENT_NAME, ENTP_NAME, CHART, STORAGE_METHOD, VALID_TERM, EFFECT, USAGE, UNDERLYING_DISEASE) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (edi_code, item_name, ingredient_name, entp_name, chart, storage_method, valid_term, effect, dosage, precautions)) 
            else:
                cur.execute("""
                    UPDATE Drug 
                    SET ITEM_NAME = ?, CHART = ?, STORAGE_METHOD = ?, VALID_TERM = ?, EFFECT = ?, USAGE = ?, UNDERLYING_DISEASE = ? 
                    WHERE EDI_CODE = ?
                """, (item_name, chart, storage_method, valid_term, effect, dosage, precautions, edi_code))

        conn.commit()
    finally:
        conn.close()

url = sys.argv[1]
response = requests.get(url)

if response.status_code == 200:
    xml_data = response.content
    root = ET.fromstring(xml_data)


    for item in root.findall('./body/items/item'):
        effect = []
        dosage = []
        precautions = []

        edi_code = item.find('EDI_CODE').text
        item_name = item.find('ITEM_NAME').text
        ingredient_name = item.find('MAIN_INGR_ENG').text
        entp_name = item.find('ENTP_NAME').text
        chart = item.find('CHART').text
        storage_method = item.find('STORAGE_METHOD').text
        valid_term = item.find('VALID_TERM').text

        ee_doc_data = item.find('EE_DOC_DATA')
        
        if ee_doc_data is not None:
            doc_title = ee_doc_data.find('DOC').attrib.get('title')
            if doc_title == '효능효과':
                for article in ee_doc_data.findall('.//ARTICLE'):
                    if article.attrib.get('title') == '':
                        title_paragraph = article.find('.//PARAGRAPH')
                        if title_paragraph is not None:
                            effect.append(title_paragraph.text.strip())
                            article.remove(title_paragraph)
                    else:
                        effect.append(article.attrib.get('title'))
                    for paragraph in article.findall('.//PARAGRAPH'):
                        effect.append(paragraph.text.strip())
        

        effect = ', '.join(f'"{item}"' for item in effect)
        print(effect)


        ud_doc_data = item.find('UD_DOC_DATA')
        
        if ud_doc_data is not None:
            doc_title = ud_doc_data.find('DOC').attrib.get('title')
            if doc_title == '용법용량':
                for article in ud_doc_data.findall('.//ARTICLE'):
                    if article.attrib.get('title') == '':
                        title_paragraph = article.find('.//PARAGRAPH')
                        if title_paragraph is not None:
                            dosage.append(title_paragraph.text.strip())
                            article.remove(title_paragraph)
                    else:
                        dosage.append(article.attrib.get('title'))
                    for paragraph in article.findall('.//PARAGRAPH'):
                        dosage.append(paragraph.text.strip())
        
        dosage = ', '.join(f'"{item}"' for item in dosage)
        print(dosage)


        nb_doc_data = item.find('NB_DOC_DATA')
        
        if nb_doc_data is not None:
            doc_title = nb_doc_data.find('DOC').attrib.get('title')
            if doc_title == '사용상의주의사항' or doc_title == '사용상주의사항':
                for article in nb_doc_data.findall('.//ARTICLE'):
                    if '다음 환자에는 투여하지 말 것' in article.attrib.get('title'):
                        for paragraph in article.findall('.//PARAGRAPH'):
                            precautions.append(paragraph.text.strip())
                    if '다음과 같은 사람은 이 약을 복용하지 말 것' in article.attrib.get('title'):
                        for paragraph in article.findall('.//PARAGRAPH'):
                            precautions.append(paragraph.text.strip())
                    if '다음 환자(경우)에는 투여하지 말 것' in article.attrib.get('title'):
                        for paragraph in article.findall('.//PARAGRAPH'):
                            precautions.append(paragraph.text.strip())

        precautions = ', '.join(f'"{item}"' for item in precautions)
        print(precautions)
        update_or_insert_drug(edi_code, item_name, ingredient_name, entp_name, chart, storage_method, valid_term, effect, dosage, precautions) 
    

else:
    print('API Failed')
