from telethon import TelegramClient

api_id = 36014715
api_hash = "95d2688650b893d32cf7fa51ed18cff1"

client = TelegramClient("session", api_id, api_hash)

async def main():
    dialogs = await client.get_dialogs()
    for d in dialogs:
        print(f"Nombre: {d.name}")
        print(f"ID: {d.id}")
        print("-" * 40)

client.start()
client.loop.run_until_complete(main())
