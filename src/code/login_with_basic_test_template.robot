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
