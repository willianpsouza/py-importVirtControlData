#!/usr/bin/python

'''
    execute data send
'''

from datetime import datetime
from time import sleep, time

import os
import multiprocessing as mpc
import requests
import pymysql.cursors


API_HTTP_HOST=os.getenv('API_HTTP_HOST','http://127.0.0.1:3001')

DBHOST=os.getenv('DBHOST','localhost')
DBUSER=os.getenv('DBUSER','dbuser')
DBPASS=os.getenv('DBPASS','dbpass')
DBNAME=os.getenv('DBNAME','dbname')
TPROCS=int(os.getenv('TPROCS', '8'))
WAIT_TIMEOUT=int(os.getenv('WAIT_TIMEOUT', '30'))
RETRY_TIMES=int(os.getenv('RETRY_TIMES', '5'))
PROCESS_WAIT=int(os.getenv('PROCESS_WAIT', '5'))
DATE_INI=os.getenv('DATE_INI', '2023-05-16 07:12:00')
UNIXDAY = 86400
NOW = int(time)



def send_data(data):
    ''' send data do backend'''
    _s = requests.Session()
    _url = f'{API_HTTP_HOST}/v1/virt_control/vmData'
    _p = _s.post(_url, json=data)
    if _p.ok:
        return True
    else:
        return False

def send_data_mass(data):
    ''' send data do backend'''
    _s = requests.Session()
    _url = f'{API_HTTP_HOST}/v1/virt_control/vmMassData'
    total = 0

    while total <= RETRY_TIMES:
        try:
            _p = _s.post(_url, json={'data': data})
            if _p.ok:
                return True
        except Exception as _e:
            sleep(PROCESS_WAIT)
        finally:
            total += 1
    return False

def generate_date_range():
    ''' generating date ranges to be processes'''
    date_ini = int(datetime.timestamp(datetime.strptime(DATE_INI, "%Y-%m-%d %H:%M:%S")))
    date_acctual = date_ini
    total_sum = 300
    days = 90
    total_ranges = int((UNIXDAY * days)/total_sum)
    ret = []
    for _ in range(total_ranges):
        ret.append((int(date_acctual), int(date_acctual+total_sum)))
        date_acctual += total_sum + 1
        if date_acctual > NOW:
            return ret
    return ret

def main():
    '''     main thread     '''
    connection = pymysql.connect(host=DBHOST,
                                user=DBUSER,
                                password=DBPASS,
                                database=DBNAME,
                                cursorclass=pymysql.cursors.DictCursor)

    daterange = generate_date_range()
    totalrange = len(daterange)
    string_print = "%04d/%04d -- Executando data: %s Total de registros: %d -- Processos ativos %02d"
    seq = 0

    for date_ini,date_end in daterange:
        t_actives = len(mpc.active_children())
        mdata = []
        while True:
            if len(mpc.active_children()) < TPROCS:
                print("")
                break
            print(".", end="")
            sleep(PROCESS_WAIT)


        with connection.cursor() as cursor:
            
            sql = "select * from virt_manager_data  where clock >= %s and clock <= %s and host is not null;"
            cursor.execute(sql, (date_ini,date_end))
            results = cursor.fetchall()
            totalresults = len(results)
            if totalresults == 0:
                continue

            
            print(string_print % (seq, totalrange, datetime.fromtimestamp(date_end), totalresults, t_actives), end="")
            for result in results:
                mdata.append(result)
                
            __t = mpc.Process(target=send_data_mass, args=([mdata]))
            __t.start()

        seq += 1


    
try:
    main()
    exit()
except KeyboardInterrupt: 
    pass
