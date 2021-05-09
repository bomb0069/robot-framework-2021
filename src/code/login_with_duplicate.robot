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
