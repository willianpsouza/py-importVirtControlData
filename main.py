
import pymysql.cursors
import json
import requests
from datetime import datetime
from threading import Thread
import concurrent.futures

import os

API_HTTP_HOST=os.environt.get('HOST','http://127.0.0.1:3001')

DBHOST=os.environt.get('DBHOST','localhost')
DBUSER=os.environt.get('DBUSER','dbuser')
DBPASS=os.environt.get('DBPASS','dbpass')
DBNAME=os.environt.get('DBNAME','dbname')




def main():
    def sendData(data):
        S = requests.Session()
        _url = f'{API_HTTP_HOST}/v1/virt_control/vmData'
        _p = S.post(_url, json=data)
        if _p.ok:
            return True
        else:
            return False

    def sendDataMass(data):
        S = requests.Session()
        _url = f'{API_HTTP_HOST}/v1/virt_control/vmMassData'
        _p = S.post(_url, json=data)
        if _p.ok:
            return True
        else:
            return False


    connection = pymysql.connect(host=DBHOST,
                                user=DBUSER,
                                password=DBPASS,
                                database=DBNAME,
                                cursorclass=pymysql.cursors.DictCursor)
    dateRange = generateDateRange()
    totalRange = len(dateRange)
    string_print = "%04d/%04d -- Executando data: %s Total de registros: %d"
    seq = 0

    MASS = False
    for date_ini,date_end in dateRange:
        with connection.cursor() as cursor:
            sql = "select * from virt_manager_data  where clock >= %s and clock <= %s and host is not null;"
            cursor.execute(sql, (date_ini,date_end) )
            results = cursor.fetchall()
            totalResults = len(results)
            if totalResults == 0:
                continue

            pool = concurrent.futures.ThreadPoolExecutor(max_workers=16)
            mdata = []
            print(string_print % (seq, totalRange, datetime.fromtimestamp(date_end), totalResults))
            for result in results:
                if not MASS:
                    pool.submit(sendData(result))
                if MASS:
                    mdata.append(result)
            if MASS:
                pool.submit(sendDataMass({'data': mdata}))
            pool.shutdown(wait=True)
        seq += 1

def generateDateRange():
    date_ini = int(datetime.timestamp(datetime.strptime('2023-02-10 00:00:00', "%Y-%m-%d %H:%M:%S")))
    date_acctual = date_ini
    sum = 3600
    days = 90
    UNIXDAY = 86400
    total_ranges = int((UNIXDAY * days)/sum)
    ret = []
    for _ in range(total_ranges):
        ret.append((int(date_acctual), int(date_acctual+sum)))
        date_acctual += sum + 1
    return ret
    
try:
    main()
    exit()
except KeyboardInterrupt: 
    pass
