# Test Template

หนึ่งในปัญหาของการเขียน Test Cases ใน Robot Framework ที่ทุกคนมักจะเจอหลังจากที่พัฒนามันมาได้สักพักแล้ว ก็คือ ความซับซ้อนของตัว Test Script ซึ่งยากต่อการทำความเข้าใจมากขึ้นเรื่อย ๆ ยิ่งทำความเข้าใจยากขึ้นก็ยิ่งใช้เวลากับการดูแลรักษามากขึ้น ซึ่งผิดกับหลักการสำคัญของการเอาภาษาที่เป็น Dynamic แบบนี้มาใช้ในการเขียน Test Script เพราะเป้าหมายหลักของการเขียน Robot Framework คือสร้าง Test Script ให้สามารถสื่อสารกับลูกค้าให้ได้ตรงกับ ภาษาของเขาให้ได้มากที่สุด เพราะฉะนั้นเราจำเป็นที่จะต้อง ดูแลรักษา Test Script ของเราให้อ่านง่าย และยังคงความใกล้ชิดกับลูกค้าหรือ ผู้ใช้งานอยู่ตลอดเวลา ซึ่งปัญหาความซับซ้อน ที่เกิดขึ้นอาจจะเกิดจากหลาย ๆ ปัจจัยหนึ่งในนั้นคือความซ้ำซ้อน (Duplication) ของ Script ที่เราเขียน หนึ่งในทางเลือกที่เราสามารถทำได้คือการสร้าง Keywords เพื่แอลดความซ้ำซ้อนดังกล่าว แต่การสร้าง Keywords เองก็มีข้อจำกัด เพราะฉะนั้นวันนี้จะขออนุญาตพาไปให้รู้จักกับ การต่อยอดเอา Keyword มาใช้ในลักษณะที่เป็น Data-Driven Tests ซึ่งใน Robot Framework เราเรียกมันว่า Test Template

## ลดความซ้ำซ้อนผ่าน Keywords

```robotframework
*** Test Cases ***
Login ด้วย User ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Input Username    invalid
    Input Password    ${VALID PASSWORD}
    Submit Credentials
    Error Message Should Be Show

Login ด้วย Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Input Username    ${VALID USER}
    Input Password    invalid
    Submit Credentials
    Error Message Should Be Show

Login ด้วย User และ Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Input Username    invalid
    Input Password    invalid
    Submit Credentials
    Error Message Should Be Show

Login โดยไม่กรอก User จะต้องแสดงข้อความ Error
    Input Username    ${EMPTY}
    Input Password    ${VALID PASSWORD}
    Submit Credentials
    Error Message Should Be Show

Login โดยไม่กรอก Password จะต้องแสดงข้อความ Error
    Input Username    ${VALID USER}
    Input Password    ${EMPTY}
    Submit Credentials
    Error Message Should Be Show

Login โดยไม่กรอกทั้ง User และ Password จะต้องแสดงข้อความ Error
    Input Username    ${EMPTY}
    Input Password    ${EMPTY}
    Submit Credentials
    Error Message Should Be Show
```

```robotframework
*** Test Cases ***
Login ด้วย User ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    invalid    ${VALID PASSWORD}

Login ด้วย Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${VALID USER}    invalid

Login ด้วย User และ Password ที่ไม่ถูกต้อง จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    invalid    invalid

Login โดยไม่กรอก User จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${EMPTY}    ${VALID PASSWORD}

Login โดยไม่กรอก Password จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${VALID USER}    ${EMPTY}

Login โดยไม่กรอกทั้ง User และ Password จะต้องแสดงข้อความ Error
    Login ผิดพลาด จะต้องแสดงข้อความ Error    ${EMPTY}    ${EMPTY}

*** Keywords ***
Login ผิดพลาด จะต้องแสดงข้อความ Error
    [Agruments]    ${USER}   ${PASSWORD}
    Input Username    ${USER}
    Input Password    ${PASSWORD}
    Submit Credentials
    Error Message Should Be Show
```

## ลองใช้ Test Template

```robotframework
*** Setting ***
Test Template    Login ผิดพลาด จะต้องแสดงข้อความ Error

*** Test Cases ***                      USER             PASSWORD
Login ด้วย User ที่ไม่ถูกต้อง                 invalid          ${VALID PASSWORD}
Login ด้วย Password ที่ไม่ถูกต้อง             ${VALID USER}    invalid
Login ด้วย User และ Password ที่ไม่ถูกต้อง    invalid          invalid
Login โดยไม่กรอก User                    ${EMPTY}         ${VALID PASSWORD}
Login โดยไม่กรอก Password                ${VALID USER}    ${EMPTY}
Login โดยไม่กรอกทั้ง User และ Password     ${EMPTY}         ${EMPTY}
    
*** Keywords ***
Login ผิดพลาด จะต้องแสดงข้อความ Error
    [Agruments]    ${USER}   ${PASSWORD}
    Input Username    ${USER}
    Input Password    ${PASSWORD}
    Submit Credentials
    Error Message Should Be Show
```

## Reference

- [How to write good test cases using Robot Framework](https://github.com/robotframework/HowToWriteGoodTestCases/blob/master/HowToWriteGoodTestCases.rst)
