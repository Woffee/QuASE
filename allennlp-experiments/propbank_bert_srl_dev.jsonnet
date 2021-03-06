{

    "dataset_reader": {
        "type": "srl-bio",
        "bert_model_name": "bert-base-uncased",
      },

    "iterator": {
        "type": "bucket",
        "batch_size": 8,
        "sorting_keys": [["tokens", "num_tokens"]]
    },

    "train_data_path": "/shared/hangfeng/code/SemanticBert/data/SRL/conll05.devel.txt",
    "validation_data_path": "/shared/hangfeng/code/SemanticBert/data/SRL/conll05.test.wsj.txt",
    "test_data_path": "/shared/hangfeng/code/SemanticBert/data/SRL/conll05.test.wsj.txt",

    "model": {
        "type": "srl_bert",
        "embedding_dropout": 0.1,
        "bert_model": "bert-base-uncased",
    },

    "trainer": {
        "optimizer": {
            "type": "bert_adam",
            "lr": 5e-5,
            "correct_bias": false,
            "weight_decay": 0.01,
            "parameter_groups": [
              [["bias", "LayerNorm.bias", "LayerNorm.weight", "layer_norm.weight"], {"weight_decay": 0.0}],
            ],
        },

        "learning_rate_scheduler": {
            "type": "slanted_triangular",
            "num_epochs": 15,
            "num_steps_per_epoch": 8829,
        },
        "grad_norm": 1.0,
        "num_epochs": 15,
        "validation_metric": "+f1-measure-overall",
        "num_serialized_models_to_keep": 2,
        "should_log_learning_rate": true,
        "cuda_device": [0, 1]
    },

    "evaluate_on_test": true,

}