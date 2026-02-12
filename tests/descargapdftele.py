from telethon import TelegramClient
import os

api_id = 36014715        # tu api_id
api_hash = "95d2688650b893d32cf7fa51ed18cff1"
grupo = "me"   # ejemplo: @grupo o link
carpeta = "pdfs"

os.makedirs(carpeta, exist_ok=True)

async def main():
    async for mensaje in client.iter_messages(grupo):
        if mensaje.document:
            nombre = mensaje.document.attributes[0].file_name
            
            if nombre.lower().endswith(".pdf"):
                ruta = os.path.join(carpeta, nombre)
                print("Descargando:", nombre)
                await mensaje.download_media(file=ruta)

client = TelegramClient("session", api_id, api_hash)
client.start()
client.loop.run_until_complete(main())
