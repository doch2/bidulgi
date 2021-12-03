#라이브러리 임포트
import RPi.GPIO as GPIO
import time
import cv2
import os
from multiprocessing import Process, Lock

import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

from lcd import drivers

lcd = drivers.Lcd() #lcd설정

cap = cv2.VideoCapture(0) #카메라 장치 열기

if not cap.isOpened():   #카메라 장치 열림  여부
    print('Camera open failed')
    exit()

#핀 설정
ECHO_PIN = 12
TRIG_PIN = 16
LED_PIN = 13
BUZZER_PIN = 19
#GPIO초기 설정
GPIO.setmode(GPIO.BCM)
GPIO.setup(ECHO_PIN, GPIO.IN)
GPIO.setup(TRIG_PIN, GPIO.OUT)
GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.setup(BUZZER_PIN, GPIO.OUT)

display = drivers.Lcd()

cred = credentials.Certificate('bidulgi-2ef5c-firebase-adminsdk-79pp6-ff40d0d42e.json') #Firebase Admin 모듈 프로젝트 정보 입력

firebase_admin.initialize_app( #Firebase Admin 라이브러리 Init.
    cred,
    {
        'databaseURL': 'https://bidulgi-2ef5c-default-rtdb.asia-southeast1.firebasedatabase.app/'
    }
)

serviceDB = db.reference()

def alarm(l): #침입자 감지 및 경고신호 앱 전송 프로세스
    global serviceDB

    try:
        while True:
            GPIO.output(TRIG_PIN, True) #트리거 출력
            time.sleep(0.00001) #10us,  10마이크로세컨드
            GPIO.output(TRIG_PIN, False) #트리거 정지

            while GPIO.input(ECHO_PIN) == 0: #펄스발생중
                pass
            start = time.time() #ECHO PIN HIGH 측정시작시간

            while GPIO.input(ECHO_PIN) == 1: #펄스발생종료
                pass
            stop = time.time() #ECHO PIN LOW 측정종료시간

            duration_time = stop - start
            distance = duration_time * 17160 # 34321/2, 거리 저장

            print('Distance : %.1fcm' % distance)
            if distance <= 20: #거리가 20cm 미만 : 침입자 감지, 모니터 경고 출력 및 앱 신호 전송
                print('warning!')
                serviceDB.update(
                    {
                        "hasThief": True
                    }
                )

            else:
                print('safe.')

                serviceDB.update(
                    {
                        "hasThief": False
                    }
                )
            time.sleep(0.1)
            
    finally: #종료 시 초기화
        GPIO.cleanup()
        cap.release()
        cv2.destroyAllWindows()
        l.realease()

def cctv(l): #카메라 영상 출력 프로세스
    try:
        while True:
            ret, frame = cap.read() #동영상 촬영
            if not ret:
                break

            cv2.imshow('frame', frame) #동영상 출력
            if cv2.waitKey(10) == 13: #1초 = 1000, 10 = 0.01초
                break
    
    finally:
        cap.release()
        cv2.destroyAllWindows()
        GPIO.cleanup()
        l.release()

# def message():
#     try:
#         display.lcd_display_string("{}",2)

#     finally:

def loading(): #장치 사용을 위한 딜레이
    display.lcd_display_string("    LOADING!   ", 1)
    time.sleep(0.1)
    display.lcd_display_string("=---------------", 2)
    time.sleep(0.2)
    display.lcd_display_string("==--------------", 2)
    time.sleep(0.4)
    display.lcd_display_string("===-------------", 2)
    time.sleep(0.2)
    display.lcd_display_string("====------------", 2)
    time.sleep(0.1)
    display.lcd_display_string("=====-----------", 2)
    time.sleep(0.3)
    display.lcd_display_string("======----------", 2)
    time.sleep(0.2)
    display.lcd_display_string("=======---------", 2)
    time.sleep(0.1)
    display.lcd_display_string("========--------", 2)
    time.sleep(0.1)
    display.lcd_display_string("=========-------", 2)
    time.sleep(0.05)
    display.lcd_display_string("==========------", 2)
    time.sleep(0.1)
    display.lcd_display_string("===========-----", 2)
    time.sleep(0.4)
    display.lcd_display_string("============----", 2)
    time.sleep(0.3)
    display.lcd_display_string("=============---", 2)
    time.sleep(0.3)
    display.lcd_display_string("==============--", 2)
    time.sleep(0.2)
    display.lcd_display_string("===============-", 2)
    time.sleep(1)
    display.lcd_display_string("================", 2)
    time.sleep(0.05)
    display.lcd_display_string("    SUCCESS!   ", 1)
    time.sleep(1)

def playSound(l, playTime): #소리출력 함수
    GPIO.output(BUZZER_PIN, GPIO.HIGH)
    time.sleep(playTime)
    GPIO.output(BUZZER_PIN, GPIO.LOW)

def firebaseListener(event): #Firebase Realtime Database 
    global serviceDB
    global alarmP
    global lock

    updateData = event.data
    keyList = list(updateData.keys())

    if 'led' in keyList:
        if updateData['led']:
            GPIO.output(LED_PIN, GPIO.HIGH)
        else:
            GPIO.output(LED_PIN, GPIO.LOW)
    elif 'sound' in keyList:
        if updateData['sound']:
            playTime = serviceDB.child('soundTime').get()
            soundp = Process(target = playSound, args=(lock, playTime,))
            soundp.start()


    elif 'lcdMessage' in keyList:
        display.lcd_display_string("                ", 1)
        display.lcd_display_string(updateData['lcdMessage'], 1)

lock = Lock()

alarmP = Process(target = alarm, args=(lock,))

if __name__ == '__main__': #파일 확인 후 메인 실행
    

    loading() #초기 로딩


    alarmP.start() #프로세스 실행
    Process(target = cctv, args=(lock,)).start()
    
    db_listener = serviceDB.listen(firebaseListener)