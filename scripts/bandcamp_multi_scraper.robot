*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${INPUT_FILE}      bandcamp_urls.csv
${OUTPUT_FILE}     bandcamp_tracks.txt
${IMAGE_DIR}       covers

*** Test Cases ***
Extraer URLs E Imagenes De Varias Paginas Bandcamp
    ${urls}=    Leer URLs Desde CSV
    Create File    ${OUTPUT_FILE}    ${EMPTY}
    Create Directory    ${IMAGE_DIR}
    Open Browser    about:blank    Chrome
    Maximize Browser Window

    FOR    ${url}    IN    @{urls}
        Log To Console    Procesando: ${url}
        Go To    ${url}
        Sleep    3s
        ${album_title}=    Get Text    css:.trackTitle
        Append To File    ${OUTPUT_FILE}    \n### ${album_title} (${url}) ###\n

        # Extraer y guardar imagen de portada sin RequestsLibrary
        ${cover_element}=    Get WebElement    css:#tralbumArt img
        ${cover_url}=    Get Element Attribute    ${cover_element}    src
        Descargar Imagen    ${cover_url}    ${album_title}

        # Extraer URLs de canciones
        ${tracks}=    Get WebElements    css:.track_list .title a
        FOR    ${track}    IN    @{tracks}
            ${track_url}=    Get Element Attribute    ${track}    href
            Append To File    ${OUTPUT_FILE}    ${track_url}\n
        END
    END

    Close Browser
    Log To Console    "Extracción completada. Revisar ${OUTPUT_FILE} y carpeta ${IMAGE_DIR}"

*** Keywords ***
Leer URLs Desde CSV
    ${lines}=    Get File    ${INPUT_FILE}
    ${urls}=    Create List
    FOR    ${line}    IN    @{lines.splitlines()}
        Append To List    ${urls}    ${line}
    END
    [Return]    ${urls}

Descargar Imagen
    [Arguments]    ${url}    ${album_title}
    ${safe_title}=    Evaluate    "${album_title}".replace(" ", "_").replace("/", "_")
    ${image_file}=    Set Variable    ${IMAGE_DIR}/${safe_title}.jpg
    Evaluate    (lambda u, f: __import__('importlib').import_module('urllib.request').urlretrieve(u, f))("${url}", "${image_file}")
