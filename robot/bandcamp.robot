*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${INPUT_FILE}      robot/bandcamp_urls.csv
${OUTPUT_FILE}     bandcamp_tracks.txt
${FAILED_FILE}     failed_pages.txt
${MISSING_FILE}    missing_tracks.txt
${IMAGE_DIR}       covers

*** Test Cases ***
Extraer URLs E Imagenes De Bandcamp
    ${urls}=    Leer URLs Desde CSV
    Create File    ${OUTPUT_FILE}    ${EMPTY}
    Create File    ${FAILED_FILE}    ${EMPTY}
    Create File    ${MISSING_FILE}    ${EMPTY}
    Create Directory    ${IMAGE_DIR}


    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage

    Open Browser    about:blank    Chrome    options=${options}

    Maximize Browser Window
    ${contador}=    Set Variable    1

    FOR    ${url}    IN    @{urls}
        Log To Console    Procesando: ${url}

        Go To    ${url}
        Sleep    3s

        ${cookie_result}=    Aceptar Cookies Si Aparece    ${contador}

        ${contador}=    Evaluate    ${contador} + 1
        Sleep    3s
        ${page_ok}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    css:.trackTitle
        ...    timeout=10s

        IF    not ${page_ok}
            Log To Console    Página no cargó correctamente
            Append To File    ${FAILED_FILE}    ${url}\n
            Continue For Loop
        END

        # Obtener título del álbum
        ${album_title}=    Get Text    css:.trackTitle

        # Obtener nombre de banda
        ${artist_ok}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    xpath=//*[@id="name-section"]//a
        ...    timeout=10s

        IF    not ${artist_ok}
            Append To File    ${MISSING_FILE}    ${url}\n
            Continue For Loop
        END

        ${artist}=    Get Text    xpath=//*[@id="name-section"]//a

        Append To File
        ...    ${OUTPUT_FILE}
        ...    \n### ${artist} - ${album_title} (${url}) ###\n

        # Descargar imagen
        ${cover_exists}=    Run Keyword And Return Status
        ...    Get WebElement    css:#tralbumArt img

        IF    ${cover_exists}
            ${cover_element}=    Get WebElement    css:#tralbumArt img
            ${cover_url}=    Get Element Attribute    ${cover_element}    src
            Descargar Imagen    ${cover_url}    ${artist}    ${album_title}
        END

        # Obtener canciones
        ${tracks}=    Get WebElements    css:.track_list .title a

        IF    $tracks == []
            Append To File    ${MISSING_FILE}    ${url}\n
            Continue For Loop
        END

        FOR    ${track}    IN    @{tracks}
            ${track_url}=    Get Element Attribute    ${track}    href
            Append To File    ${OUTPUT_FILE}    ${track_url}\n
        END
    END

    Close Browser


*** Keywords ***
Leer URLs Desde CSV
    ${lines}=    Get File    ${INPUT_FILE}
    ${urls}=    Create List
    FOR    ${line}    IN    @{lines.splitlines()}
        Append To List    ${urls}    ${line}
    END
    RETURN    ${urls}


Aceptar Cookies Si Aparece
    [Arguments]    ${contador}
    Log To Console    🔍 Buscando popup de cookies (Shadow DOM)...

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
    Log To Console    Iteración: ${contador}

    IF    '${result}' == 'NOT_FOUND' and ${contador} == 1
         Log To Console    ⚠️ No apareció popup en la primera URL, se continúa
    END

    RETURN    ${result}


Descargar Imagen
    [Arguments]    ${url}    ${artist}    ${album_title}

    ${safe_artist}=    Evaluate    "${artist}".replace(" ", "_").replace("/", "_")
    ${safe_album}=     Evaluate    "${album_title}".replace(" ", "_").replace("/", "_")

    ${image_file}=    Set Variable
    ...    ${IMAGE_DIR}/${safe_artist}_-_${safe_album}.jpg

    ${cmd}=    Set Variable
    ...    (lambda u, f: __import__('urllib.request').request.urlretrieve(u, f))("${url}", "${image_file}")

    Evaluate    ${cmd}
