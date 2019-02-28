# Run allennlp training locally

dataset='sciie'
task='ner'
config_file=allennlp_config/"$task".jsonnet

SEED=13270
PYTORCH_SEED=`expr $SEED / 10`
NUMPY_SEED=`expr $PYTORCH_SEED / 10`

export SEED=$SEED
export PYTORCH_SEED=$PYTORCH_SEED
export NUMPY_SEED=$NUMPY_SEED

export BERT_VOCAB=vocab/s2vocab_cased.vocab
export BERT_WEIGHTS=pytorch_models/s2bert_s2vocab_cased_512.tar.gz
export is_lowercase=false
export BERT_VOCAB2=vocab/s2vocab_uncased.vocab
export BERT_WEIGHTS2=pytorch_models/s2bert_s2vocab_uncased_512.tar.gz
export is_lowercase2=true
export TRAIN_PATH=data/$task/$dataset/train.txt
export DEV_PATH=data/$task/$dataset/dev.txt
export TEST_PATH=data/$task/$dataset/test.txt


export CUDA_VISIBLE_DEVICES=0

python -m allennlp.run train $config_file  --include-package sci_bert -s "$@"
