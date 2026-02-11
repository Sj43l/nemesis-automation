*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${TEST_URL}    https://immortalfrostproductions1.bandcamp.com/album/vampyric-war-in-blood

*** Test Cases ***
Test Cerrar Popup De Cookies
    Open Browser    ${TEST_URL}    Chrome
    Maximize Browser Window
    Sleep    10s

    Cerrar Popup Cookies Con Shadow DOM

    Sleep    5s
    Close Browser


*** Keywords ***
Cerrar Popup Cookies Con Shadow DOM
    ${result}=    Execute JavaScript
    ...    let all = document.querySelectorAll('*');
    ...    for (let el of all) {
    ...        if (el.shadowRoot) {
    ...            let btn = el.shadowRoot.querySelector('button');
    ...            if (btn && btn.innerText.includes('Aceptar todo')) {
    ...                btn.click();
    ...                return 'CLICKED';
    ...            }
    ...        }
    ...    }
    ...    return 'NOT_FOUND';
    Log To Console    Resultado cookies: ${result}
    Should Be Equal    ${result}    CLICKED
