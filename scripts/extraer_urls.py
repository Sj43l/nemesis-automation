import re

# Archivo de entrada y salida
input_file = "bandcamp_tracks.txt"
output_file = "urls_extraidas.txt"

# Expresión regular para detectar URLs
url_pattern = re.compile(r'(https?://[^\s]+)')

# Leer archivo y extraer URLs
with open(input_file, 'r', encoding='utf-8') as file:
    contenido = file.read()
    urls = url_pattern.findall(contenido)

# Guardar las URLs en un nuevo archivo
with open(output_file, 'w', encoding='utf-8') as file:
    for url in urls:
        file.write(url + '\n')

print(f"✅ Se extrajeron {len(urls)} URLs. Guardadas en {output_file}")
