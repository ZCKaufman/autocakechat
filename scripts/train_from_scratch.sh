# Setup environment & prepare dataset
/autocakechat/scripts/setup.sh

# Train from scratch
export PYTHONHASHSEED=42
python3 tools/prepare_index_files.py
python3 tools/train_w2v.py
python3 tools/train.py

# Copy trained model back to local machine
cp -r results /autocakechat/.
