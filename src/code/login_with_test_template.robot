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
