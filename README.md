# autocakechat
Autocakechat is a scripted, Dockerized environment for training and deploying
conversational chatbots. It is based around the
[Cakechat](https://github.com/lukalabs/cakechat) Emotional Generative Dialog
System.

## Generating the Corpus
The corpus is a compilation of client-server message pairs that instruct the
model on how to respond to certain prompts. Autocakechat extracts the 
client-server pairs from chatlogs, where the server is the sender.

While Cakechat supports context-aware emotional dialogs, Autocakechat does not
currently implement the feature. In the future, client-server pairs may either
be manually labelled or annotated using an emotion classifier model.

### Export Telegram Messenger Data
Autocakechat may parse chatlogs from Telegram Messenger and compile them into
a corpus. Each chatlog should be a JSON file containing messages from a single
chat. All chatlogs should be placed in a top-level directory named `tg_data`.

In the Makefile, set the `TELEGRAM_SERVER_ID` variable to the `from_id`
parameter corresponding to the sender.

### Compile the Corpus
After all chatlogs are in the `tg_data` directory and the `TELEGRAM_SERVER_ID`
variable is set, invoke the following Makefile target.

```shell
$ make generate_corpus
```

## Training the Model in Docker
There are two options for training. Fine-tuning the pretrained model fetches
weights from training on a large amount of Reddit data. This will produce
better results for smaller corpora. If enough data is available, training a
model from scratch will produce output that more closely resembles the corpus.

### Fine-Tune the Pretrained Model
To fine-tune the pretrained model, invoke the following command.

``` shell
$ make docker_update_pretrained
``` 

This process may take some time. When training has completed, the
`results.nosync` directory will be copied into the top level.

### Train the Model from Scratch
To train the model from scratch, invoke the following command.

``` shell
$ make docker_train_from_scratch
``` 

This process may take some time. When training has completed, the
`results.nosync` directory will be copied into the top level.

## Deploying the Chatbot
The trained model may be deployed as a Telegram chatbot. First, edit the
Makefile such that the `TELEGRAM_BOT_TOKEN` variable is equal to the bot token.
Next, invoke the following command.

```shell
$ make docker_deploy_model
```
