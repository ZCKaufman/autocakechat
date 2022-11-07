# Setup environment & prepare dataset
/autocakechat/scripts/setup.sh

# Update weights of pre-trained model
export PYTHONHASHSEED=42
python3 tools/fetch.py
python3 tools/train.py

# Copy trained model back to local machine
cp -r results /autocakechat/results.nosync
