{
  "random_seed": std.parseInt(std.extVar("SEED")),
  "pytorch_seed": std.parseInt(std.extVar("PYTORCH_SEED")),
  "numpy_seed": std.parseInt(std.extVar("NUMPY_SEED")),
  "dataset_reader": {
    "type": "classification_dataset_reader",
     "token_indexers": {
      "bert": {
          "type": "bert-pretrained",
          "pretrained_model": std.extVar("BERT_VOCAB"),
          "do_lowercase": std.extVar("is_lowercase"),
          "use_starting_offsets": true
      },
      "bert2": {
          "type": "bert-pretrained",
          "pretrained_model": std.extVar("BERT_VOCAB2"),
          "do_lowercase": std.extVar("is_lowercase2"),
          "use_starting_offsets": true
      },
      "token_characters": {
        "type": "characters",
        "min_padding_length": 3
      }
    }
  },
  "train_data_path": std.extVar("TRAIN_PATH"),
  "validation_data_path": std.extVar("DEV_PATH"),
  "test_data_path": std.extVar("TEST_PATH"),
  "evaluate_on_test": true,
  "model": {
    "type": "text_classifier",
    "verbose_metrics": false,
    "text_field_embedder": {
        "allow_unmatched_keys": true,
        "embedder_to_indexer_map": {
            "bert": ["bert", "bert-offsets"],
            "bert2": ["bert2", "bert2-offsets"],
            "token_characters": ["token_characters"],
        },
        "token_embedders": {
            "bert": {
                "type": "bert-pretrained",
                "pretrained_model": std.extVar("BERT_WEIGHTS"),
                "requires_grad": false
            },
            "bert2": {
                "type": "bert-pretrained",
                "pretrained_model": std.extVar("BERT_WEIGHTS2"),
                "requires_grad": false
            },
            "token_characters": {
                "type": "character_encoding",
                "embedding": {
                    "embedding_dim": 16
                },
                "encoder": {
                    "type": "cnn",
                    "embedding_dim": 16,
                    "num_filters": 128,
                    "ngram_filter_sizes": [3],
                    "conv_layer_activation": "relu"
                }
            }
        }
    },
      "text_encoder": {
      "type": "lstm",
      "bidirectional": true,
      "input_size": 768 + 768 + 128,
      "hidden_size": 200,
      "num_layers": 2,
      "dropout": 0.5
    },
    "classifier_feedforward": {
      "input_dim": 400,
      "num_layers": 2,
      "hidden_dims": [50, 25],
      "activations": ["relu", "linear"],
      "dropout": [0.25, 0.0]
    }
  },
  "iterator": {
    "type": "bucket",
    "sorting_keys": [["text", "num_tokens"]],
    "batch_size": 8
  },

  "trainer": {
    "num_epochs": 30,
    "grad_clipping": 5.0,
    "patience": 10,
    "validation_metric": "+average_F1", //"-loss",
    "cuda_device": 0,
    "optimizer": {
        "type": "adam",
        "lr": 0.001
    },
  }
}
