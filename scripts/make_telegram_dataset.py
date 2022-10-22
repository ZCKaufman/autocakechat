from TelegramDataset import TelegramDataset
import json

SERVER_ID = "REPLACE ME"

if __name__ == "__main__":
    # Import JSON chatlog exported from Telegram
    # Treat the user######## as the server/bot
    dataset = TelegramDataset("corpus/", SERVER_ID)
    print(f"Imported {len(dataset.data)} client-server pairs from {len(dataset.corpus)} files")

    # Convert to cakechat format
    lines = []
    for pair in dataset.data:
        pattern = pair["client"].strip()
        response = pair["server"].strip()

        if pattern != "" and response != "":
            line = [{"text": pattern, "condition": "neutral"}, {"text": response, "condition": "neutral"}]
            lines.append(line)

    # Export
    with open("train_processed_dialogs.txt", "w") as file:
        for line in lines:
            json_str = json.dumps(line)
            file.write(json_str + "\n")

    exit()
