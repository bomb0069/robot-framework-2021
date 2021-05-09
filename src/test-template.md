# Test Template

หนึ่งในปัญหาของการเขียน Test Cases ใน Robot Framework ที่ทุกคนมักจะเจอหลังจากที่พัฒนามันมาได้สักพักแล้ว ก็คือ ความซับซ้อนของตัว Test Script ซึ่งยากต่อการทำความเข้าใจมากขึ้นเรื่อย ๆ ยิ่งทำความเข้าใจยากขึ้นก็ยิ่งใช้เวลากับการดูแลรักษามากขึ้น ซึ่งผิดกับหลักการสำคัญของการเอาภาษาที่เป็น Dynamic แบบนี้มาใช้ในการเขียน Test Script เพราะเป้าหมายหลักของการเขียน Robot Framework คือสร้าง Test Script ให้สามารถสื่อสารกับลูกค้าให้ได้ตรงกับ ภาษาของเขาให้ได้มากที่สุด เพราะฉะนั้นเราจำเป็นที่จะต้อง ดูแลรักษา Test Script ของเราให้อ่านง่าย และยังคงความใกล้ชิดกับลูกค้าหรือ ผู้ใช้งานอยู่ตลอดเวลา ซึ่งปัญหาความซับซ้อน ที่เกิดขึ้นอาจจะเกิดจากหลาย ๆ ปัจจัยหนึ่งในนั้นคือความซ้ำซ้อน (Duplication) ของ Script ที่เราเขียน หนึ่งในทางเลือกที่เราสามารถทำได้คือการสร้าง Keywords เพื่แอลดความซ้ำซ้อนดังกล่าว แต่การสร้าง Keywords เองก็มีข้อจำกัด เพราะฉะนั้นวันนี้จะขออนุญาตพาไปให้รู้จักกับ การต่อยอดเอา Keyword มาใช้ในลักษณะที่เป็น Data-Driven Tests ซึ่งใน Robot Framework เราเรียกมันว่า Test Template

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

ด้วยแนวคิดที่ทำให้ง่ายต่อการดูแลรักษา และการทำความเข้า Test Cases  แบบนี้นี่เองจึงทำให้เครื่องมือที่ใช้ในการเขียน Test Script หลาย ๆ ตัว มักจะทำมาเพื่อให้รองรับการทำ Data-Driven Tests โดยใน Robot Framework เราจะเรียกวิธีการแบบนี้ว่า `Test Template`

---

## เงื่อนไขในการใช้ Test Template

เพื่อให้เราสามารถแปลง Test Cases ที่เราเขียนไว้ ให้สามารถมาใช้ Test Template ได้ มีเงื่อนไขที่เราต้องรู้ดังนี้

1. จะมี Keyword หลักได้เพียงอันเดียวในไฟล์นั้น
2. ถ้า Keyword หลักที่ใช้เป็น Keyword ที่เราสร้างเอง ทุก ๆ Test Cases จะต้องใช้ Step หรือ Workflows เดียวกันทั้งหมด
3. ทุก ๆ Test Cases ที่อยู่ในไฟล์นี้ ต้องใช้ Keyword หลักเดียวกัน ต่างกันแค่ Agruments ที่ใส่เข้าไปในแต่ละ Test Case
4. กรณีที่มี Agruments ไม่เหมือนกัน ต้องแยกไฟล์เทสออกจากกัน
5. ถ้าจะให้ดี Keyword นั้นควรจะอยู่ที่เดียวกับที่รัน Test เพื่อจะได้เห็นว่าแต่ละ Test Cases มี Steps/Workflows อะไรบ้าง (แยกก็ได้ ถ้ามีความจำเป็นจริง ๆ)
6. ใส่ชื่อของตัวแปลไว้บนหัว Column เพื่อให้อ่านง่าย

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

จาก Code ตัวอย่างเราจะเห็นว่าทั้ง 6 เคส มีขั้นตอนการทำงานเหมือนกันทั้งหมด (เข้าเงื่อนไขข้อที่ 2) ต่างกันก็แค่ข้อมูลที่ใส่เข้าไปในระบบ (ตรงกับเงื่อนไขข้อที่ 3) เพื่อทำการ Login เท่านั้น ให้ลองคิดว่าเราต้องดูแล Script ชุดนี้ต่อไป แล้วปรากฏว่า มีการเปลี่ยนแปลงเกี่ยวกับการ Login เช่น ต้องเพิ่ม หรือแก้ Step เราก็ต้องมาตามแก้ในทุก ๆ Test Cases ซึ่งคงไม่ค่อยดีเท่าไหร่ เพราะก็มีโอกาสที่เราจะแก้ หรือเพิ่ม Step เข้าไปไม่ครบได้ เพราะฉะนั้นเราสามารถเอา Step ของทุก ๆ Test Cases มาสร้างเป็น Keywords เดียว ตัวใหม่ (ตรงกับเงื่อนไขข้อที่ 1) ที่ชื่อว่า `Login ผิดพลาด จะต้องแสดงข้อความ Error` และให้รับ Arguments เข้ามา 3 ตัว คือ `USER`, `PASSWORD` และ `ERROR_MESSAGE` ซึ่งจะได้เป็นตัวอย่าง Code ข้างล่างนี้

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

## ลองใช้ Test Template

ลองมาตรวจสอบ Test Cases ที่เราเขียนไว้ ตามเงื่อนไขก่อหน้านี้ ก็จะได้ว่า Keyword หลักของทุก ๆ Test Cases ของ Login ก็คือ `Login ผิดพลาด จะต้องแสดงข้อความ Error` แถมยังใช้ Agruments ชุดเดียวกัน แถม Steps/Workflows ของการ Test ยังเหมือนกันอีกด้วย เพราะฉะนั้นเราก็สามารถแปลง มาใช้ Test Template ใน Section `*** Setting ***` และระบุชื่อของ Keywords หลักของเรา ได้ดังตัวอย่างข้างล่างนี้

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

### คำอธิบาย

- บรรทัดที่ 2: กำหนดว่าเทสไฟล์นี้ จะให้ทำงานเป็นแบบ Test Template และจะใช้ Keyword หลักที่ชื่อ `Login ผิดพลาด จะต้องแสดงข้อความ Error` สำหรับทุก ๆ Test Cases
- บรรทัดที่ 5-10: กำหนดชื่อของแต่ละ Test Case ให้อยู่ใน Column แรก (อยู่ใต้ `*** Test Cases ***`) และให้เอา  Agruments ต่าง ๆ มาใส่ใน Column ต่อ ๆ มา ซึ่งกรณีนี้มี Agruments จำนวน 3 ตัว ก็เอามาใส่แล้วแยก Column ไป
- บรรทัดที่ 4: ด้านหลังของ `*** Test Cases ***` เราสามารถใส่ชื่องของ Agruments ที่ส่งไปยังแต่ละ Test Cases ในรูปแบบของ `หัวตาราง` เพื่อให้เราง่ายต่อการทำความเข้าใจ
- บรรทัดที่ 13-18: ยังคง Keyword หลักไว้ใน File เดียวกัน เพื่อให้เราสามารถทำความเข้าใจขั้นตอนการของทดสอบ

จะเห็นได้ว่าแค่นี้เราก็สามารถทำ Data-Driven Tests เพื่อรองรับการทดสอบในกรณีที่ Login ผิดพลาดทั้ง 6 เคส ซึ่งจะทำให้เราสามารถดูแลรักษา Script Tests ของเราได้ง่ายยิ่งกว่าเดิมแล้ว

## สามารถใช้ Template ใน Test Cases ได้ (ไม่แนะนำ)

จริง ๆ แล้วการเขียน Test Template ของ Robot Framework ยังสามารถใช้ได้อีก 1 วิธี โดยการกำหนด `[Template]` ภายใต้ชื่อ Test Cases ซึ่งทำให้เราสามารถสร้าง Test Template หลาย ๆ อันได้ในไฟล์เทสเดียว (`แต่ขอยืนยันอีกครั้งว่าไม่แนะนำ`) ดังตัวอย่างด้านล่าง

```robotframework
*** Test Cases ***
Login ผิดพลาด
    [Template]    Login ผิดพลาด จะต้องแสดงข้อความ Error
    invalid          ${VALID PASSWORD}         User/Password ไม่ถูกต้อง
    ${VALID USER}    invalid                   User/Password ไม่ถูกต้อง
    invalid          invalid                   User/Password ไม่ถูกต้อง
    ${EMPTY}         ${VALID PASSWORD}         กรุณากรอก User
    ${VALID USER}    ${EMPTY}                  กรุณากรอก Password
    ${EMPTY}         ${EMPTY}                  กรุณากรอก User และ Password   

*** Keywords ***
Login ผิดพลาด จะต้องแสดงข้อความ Error
    [Arguments]    ${USER}   ${PASSWORD}   ${ERROR_MESSAGE}
    Input Username    ${USER}
    Input Password    ${PASSWORD}
    Submit Credentials
    Error Message Should Be Show   ${ERROR_MESSAGE}
```

## Reference

- [Robot Framework User Guide - 2.2.7 Test templates](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#test-templates)
- [How to write good test cases using Robot Framework](https://github.com/robotframework/HowToWriteGoodTestCases/blob/master/HowToWriteGoodTestCases.rst)
- [Web testing with Robot Framework and SeleniumLibrary](https://github.com/robotframework/WebDemo/)
- [Data-driven testing](https://en.wikipedia.org/wiki/Data-driven_testing#:~:text=Data%2Ddriven%20testing%20(DDT),the%20process%20where%20test%20environment)
