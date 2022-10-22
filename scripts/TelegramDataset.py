import json
import os

class TelegramDataset:
    def __init__(self, corpus_dir, server_id):
        # Import JSON files from Telegram
        json_files = self.__get_json_files__(corpus_dir)
        self.corpus = self.__parse_json__(json_files)

        # Extract message data
        self.data = self.__extract_messages__(server_id)

    def __get_json_files__(self, corpus_dir):
        dir_files = os.listdir(corpus_dir)
        json_files = []
        for path in dir_files:
            if path.endswith(".json"):
                json_file = os.path.join(corpus_dir, path)
                json_files.append(json_file)
        return json_files

    def __parse_json__(self, json_files):
        corpus = []
        for file in json_files:
            with open(file) as f:
                corpus.append(json.load(f))
        return corpus

    def __extract_messages__(self, server_id):
        """
        Extract messages from Telegram JSON file
        and combine consecutive messages from the
        same sender.

        If the first message is from the server,
        discard messages until the first message is
        from the client.

        Store as {client prompt: server response}
        """
        client_server_pairs = []

        for chat in self.corpus:
            # Extract text messages only
            messages = []
            for element in chat["messages"]:
                if element["type"] == "message" and type(element["text"]) == str:
                    messages.append(element)

            # Ensure first message is from client
            while messages[0]["from_id"] == server_id:
                del messages[0]

            # Strip unnecessary metadata (only keep sender id and message text)
            cleaned_messages = []
            for message in messages:
                sender = message["from_id"]
                text = message["text"]
                cleaned_messages.append({"sender":sender, "text":text})

            # Combine consecutive messages from the same sender
            i = 0
            combined_messages = []
            while i < len(cleaned_messages) - 1:
                current_sender = cleaned_messages[i]["sender"]

                j = 0
                if cleaned_messages[i+1]["sender"] == current_sender and i+j+1 < len(cleaned_messages):
                    while i+j+1 < len(cleaned_messages) and cleaned_messages[i+j+1]["sender"] == current_sender:
                        j += 1

                # Extract messages
                current_text = ""
                for k in range(j+1):
                    current_text += cleaned_messages[i+k]["text"] + " "

                combined_messages.append({"sender":current_sender, "text":current_text.strip()})
                i = i+j+1

            # Ensure last message is from server
            while combined_messages[-1]["sender"] != server_id:
                del combined_messages[-1]

            # Construct client-server pairs
            for i in range(0, len(combined_messages)-2, 2):
                pair = {"client":combined_messages[i]["text"], "server":combined_messages[i+1]["text"]}
                client_server_pairs.append(pair)

        return client_server_pairs
