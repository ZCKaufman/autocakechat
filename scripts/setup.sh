# Link dataset and converters
cp -r /autocakechat .
cp -r /autocakechat/corpus .

# Install dependencies
pip3 install --upgrade pip
pip3 install -r autocakechat/requirements.txt

# Insert Telegram server ID into dataset generation script
SERVER_ID=$(< autocakechat/server_id)
sed -i -e "s/REPLACE ME/$SERVER_ID/" autocakechat/scripts/make_telegram_dataset.py
rm -f /autocakechat/server_id

# Prepare dataset
python3 autocakechat/scripts/make_telegram_dataset.py
mv train_processed_dialogs.txt data/corpora_processed/.
