# Nemesis Automation

Proyecto de automatización que combina:

* API testing
* Automatización web con Selenium
* Ejecución con pytest
* Integración continua con Jenkins

## Tecnologías usadas

* Python
* Requests
* Selenium
* Pytest
* Jenkins

## Flujo del test principal

1. Se consulta una API pública de películas.
2. Se obtiene el nombre de una película.
3. Selenium abre Wikipedia.
4. Busca la película.
5. Valida que exista en la página.

## Ejecución local

```bash
venv\Scripts\activate
python -m pytest -v
```
