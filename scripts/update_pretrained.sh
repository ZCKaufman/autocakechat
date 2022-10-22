# Setup environment & prepare dataset
/autocakechat/scripts/setup.sh

# Update weights of pre-trained model
python3 tools/fetch.py

# Copy trained model back to local machine
cp -r results /autocakechat/.
