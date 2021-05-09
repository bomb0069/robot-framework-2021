# Test Template

หนึ่งในปัญหาของการเขียน Test Cases ใน Robot Framework ที่ทุกคนมักจะเจอหลังจากที่พัฒนามันมาได้สักพักแล้ว ก็คือ ความซับซ้อนของตัว Test Script ซึ่งยากต่อการทำความเข้าใจมากขึ้นเรื่อย ๆ ยิ่งทำความเข้าใจยากขึ้นก็ยิ่งใช้เวลากับการดูแลรักษามากขึ้น ซึ่งผิดกับหลักการสำคัญของการเอาภาษาที่เป็น Dynamic แบบนี้มาใช้ในการเขียน Test Script เพราะเป้าหมายหลักของการเขียน Robot Framework คือสร้าง Test Script ให้สามารถสื่อสารกับลูกค้าให้ได้ตรงกับ ภาษาของเขาให้ได้มากที่สุด เพราะฉะนั้นเราจำเป็นที่จะต้อง ดูแลรักษา Test Script ของเราให้อ่านง่าย และยังคงความใกล้ชิดกับลูกค้าหรือ ผู้ใช้งานอยู่ตลอดเวลา ซึ่งปัญหาความซับซ้อน ที่เกิดขึ้นอาจจะเกิดจากหลาย ๆ ปัจจัยหนึ่งในนั้นคือความซ้ำซ้อน (Duplication) ของ Script ที่เราเขียน หนึ่งในทางเลือกที่เราสามารถทำได้คือการสร้าง Keywords เพื่แอลดความซ้ำซ้อนดังกล่าว แต่การสร้าง Keywords เองก็มีข้อจำกัด เพราะฉะนั้นวันนี้จะขออนุญาตพาไปให้รู้จักกับ การต่อยอดเอา Keyword มาใช้ในลักษณะที่เป็น Data-Driven Tests ซึ่งใน Robot Framework เราเรียกมันว่า Test Template

## ลดความซ้ำซ้อนผ่าน Keywords

ก่อนจะไปที่ Test Template กัน ผมขอให้ดูตัวอย่างของ Test ที่ซ้ำซ้อน กันก่อนนะครับ เพื่อจะได้เห็นภาพที่ชัดเจน โดยที่ในตัวอย่างนี้ เป็น Test Cases สำหรับการทดสอบ Login โดยผมยกมาเฉพาะกรณีที่ Login ไม่สำเร็จเท่านั้น (`ปกติผมจะแยก Test Scenarios/Test Cases ของกรณีที่ทำงานสำเร็จ กับกรณีที่ทำงานไม่สำเร็จออกจากกัน เพราะ Step/Flow การทำงานมักจะไม่เหมือนกันอยู่แล้ว`) ซึ่งประกอบไปด้วย Test Cases จำนวน 6 เคส ดังตัวอย่างข้างล่าง

```robotframework
*** Test Cases ***
Login ด้วย User ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Input Username    invalid
    Input Password    ${VALID PASSWORD}
    Submit Credentials
    Error Message Should Be Show    User/Password ไม่ถูกต้อง

Login ด้วย Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Input Username    ${VALID USER}
    Input Password    invalid
    Submit Credentials
    Error Message Should Be Show    User/Password ไม่ถูกต้อง

Login ด้วย User และ Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Input Username    invalid
    Input Password    invalid
    Submit Credentials
    Error Message Should Be Show    User/Password ไม่ถูกต้อง

Login โดยไม่กรอก User จะต้องแสดงข้อความ Error
    Input Username    ${EMPTY}
    Input Password    ${VALID PASSWORD}
    Submit Credentials
    Error Message Should Be Show    กรุณากรอก User

Login โดยไม่กรอก Password จะต้องแสดงข้อความ Error
    Input Username    ${VALID USER}
    Input Password    ${EMPTY}
    Submit Credentials
    Error Message Should Be Show    กรุณากรอก Password

Login โดยไม่กรอกทั้ง User และ Password จะต้องแสดงข้อความ Error
    Input Username    ${EMPTY}
    Input Password    ${EMPTY}
    Submit Credentials
    Error Message Should Be Show    กรุณากรอก User และ Password
```

จาก Code ตัวอย่างเราจะเห็นว่าทั้ง 6 เคส มีขั้นตอนการทำงานเหมือนกันทั้งหมด ต่างกันก็แค่ข้อมูลที่ใส่เข้าไปในระบบ เพื่อทำการ Login เท่านั้น ให้ลองคิดว่าเราต้องดูแล Script ชุดนี้ต่อไป แล้วปรากฏว่า มีการเปลี่ยนแปลงเกี่ยวกับการ Login เช่น ต้องเพิ่ม หรือแก้ Step เราก็ต้องมาตามแก้ในทุก ๆ Test Cases ซึ่งคงไม่ค่อยดีเท่าไหร่ เพราะก็มีโอกาสที่เราจะแก้ หรือเพิ่ม Step เข้าไปไม่ครบได้ เพราะฉะนั้นเราสามารถเอา Step ของทุก ๆ Test Cases มาสร้างเป็น Keywords ใหม่ที่ชื่อว่า `Login ผิดพลาด จะต้องแสดงข้อความ Error` และให้รับ Arguments เข้ามา 3 ตัว คือ `USER`, `PASSWORD` และ `ERROR_MESSAGE` ซึ่งจะได้เป็นตัวอย่าง Code ข้างล่างนี้

```robotframework
*** Test Cases ***
Login ด้วย User ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    invalid    ${VALID PASSWORD}    User/Password ไม่ถูกต้อง

Login ด้วย Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${VALID USER}    invalid    User/Password ไม่ถูกต้อง

Login ด้วย User และ Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    invalid    invalid    User/Password ไม่ถูกต้อง

Login โดยไม่กรอก User จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${EMPTY}    ${VALID PASSWORD}        กรุณากรอก User

Login โดยไม่กรอก Password จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${VALID USER}    ${EMPTY}    กรุณากรอก Password

Login โดยไม่กรอกทั้ง User และ Password จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${EMPTY}    ${EMPTY}    กรุณากรอก User และ Password

*** Keywords ***
Login ผิดพลาด จะต้องแสดงข้อความ Error
    [Arguments]    ${USER}   ${PASSWORD}   ${ERROR_MESSAGE}
    Input Username    ${USER}
    Input Password    ${PASSWORD}
    Submit Credentials
    Error Message Should Be Show   ${ERROR_MESSAGE}
```

โอเคหล่ะ มาถึงตรงนี้ถ้าเกิดต้องมีการแก้ไข ก็สามารถแก้ที่ Keywords ที่ชื่อ `Login ผิดพลาด จะต้องแสดงข้อความ Error` ได้เลย แต่ถ้าสังเกตุก็จะเห็นว่า Test Case ที่เราเขียนมาก็ยังดูอ่านยากหน่อย ๆ แถมในแต่ละ Test Cases ก็มีแค่ Step เดียวด้วน ๆ ดูไม่ค่อยส่วยงามเลย เพราะฉะนั้นเราลองมาปรับ Test Cases ของเราให้อ่านง่ายขึ้น โดยใช้ หลักกการ Data-Driven ดูแล้วกัน

## Data Driven Tests คืออะไร

Data-Driven Testing หรือหลาย ๆ คนอาจจะรู้จักกันในชื่อ Table-Driven Testing หรือ Parameterized Testing คือ วิธีการในการทดสอบ Software โดยพยายาม อธิบายเงื่อนไขของการทดสอบนั้นให้อยู่ในรูปแบบของ ตารางของข้อมูลที่ใช้ในการทดสอบ ซึ่งข้อมูลในตารางจะประกอบไปด้วย ข้อมูลที่ป้อนเข้าระบบ รวมถึงผลลัพท์ที่จะได้จากการใช้งาน

ซึ่งถ้ากลับมาที่ Test Cases ของการ Login ก็จะสามารถเขียนอธฺบาย การทดสอบทั้งหมดในกรณี Login ผิดพลาด ในรูปแบบของตารางของข้อมูลได้คร่าว ๆ ดังนี้

| Test Case Name | User | Password | Error Message |
| -------------- | :--: | :------: | ------------- |
| Login ด้วย User ที่ไม่ถูกต้อง | invalid | ${VALID PASSWORD} | User/Password ไม่ถูกต้อง |
| Login ด้วย Password ที่ไม่ถูกต้อง | ${VALID USER} | invalid | User/Password ไม่ถูกต้อง |
| Login ด้วย User และ Password ที่ไม่ถูกต้อง | invalid | invalid | User/Password ไม่ถูกต้อง |
| Login โดยไม่กรอก User | ${EMPTY} | ${VALID PASSWORD} | กรุณากรอก User |
| Login โดยไม่กรอก Password | ${VALID USER} | ${EMPTY} | กรุณากรอก Password |
| Login โดยไม่กรอกทั้ง User และ Password | ${EMPTY} | ${EMPTY} | กรุณากรอก User และ Password |

จะเห็นว่า ถ้าเราสามารถอธิบาย Test Cases ของเราได้ในรูปแบบของตารางแบบนี้ จะทำให้ Test Cases ของเราอ่านเข้าใจได้ง่ายขึ้นทันที แถมถ้าจะต้องแก้ไขเงื่อนไขในการทดสอบของแต่ละ Test Case ก็สามารถแก้ไขที่ข้อมูลในบรรทัดนั้นได้ทันที

---

## ลองใช้ Test Template

```robotframework
*** Setting ***
Test Template    Login ผิดพลาด จะต้องแสดงข้อความ Error

*** Test Cases ***                      USER             PASSWORD               ERROR_MESSAGE
Login ด้วย User ที่ไม่ถูกต้อง                 invalid          ${VALID PASSWORD}      User/Password ไม่ถูกต้อง
Login ด้วย Password ที่ไม่ถูกต้อง             ${VALID USER}    invalid                User/Password ไม่ถูกต้อง
Login ด้วย User และ Password ที่ไม่ถูกต้อง    invalid          invalid                User/Password ไม่ถูกต้อง
Login โดยไม่กรอก User                    ${EMPTY}         ${VALID PASSWORD}      กรุณากรอก User
Login โดยไม่กรอก Password                ${VALID USER}    ${EMPTY}               กรุณากรอก Password
Login โดยไม่กรอกทั้ง User และ Password     ${EMPTY}         ${EMPTY}               กรุณากรอก User และ Password
    
*** Keywords ***
Login ผิดพลาด จะต้องแสดงข้อความ Error
    [Arguments]    ${USER}   ${PASSWORD}   ${ERROR_MESSAGE}
    Input Username    ${USER}
    Input Password    ${PASSWORD}
    Submit Credentials
    Error Message Should Be Show   ${ERROR_MESSAGE}

```

## Reference

- [Robot Framework User Guide - 2.2.7   Test templates](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#test-templates)
- [How to write good test cases using Robot Framework](https://github.com/robotframework/HowToWriteGoodTestCases/blob/master/HowToWriteGoodTestCases.rst)
- [Web testing with Robot Framework and SeleniumLibrary](https://github.com/robotframework/WebDemo/)
- [Data-driven testing](https://en.wikipedia.org/wiki/Data-driven_testing#:~:text=Data%2Ddriven%20testing%20(DDT),the%20process%20where%20test%20environment)
