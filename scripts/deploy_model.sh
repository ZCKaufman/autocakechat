# Setup environment & prepare dataset
/autocakechat/scripts/setup.sh

# Copy trained model
cp -r /autocakechat/results.nosync ./results

# Run Telegram server
export PYTHONHASHSEED=42
python3 tools/telegram_bot.py --token $1
