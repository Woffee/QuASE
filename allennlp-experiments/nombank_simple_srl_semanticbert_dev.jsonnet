{
    "dataset_reader": {
        "type": "nom-srl-bio",
        "token_indexers": {
            "bert": {
                "type": "bert-pretrained",
                "pretrained_model": "bert-base-cased",
                "do_lowercase": false,
                "use_starting_offsets": true
            },
             "semanticbert": {
                "type": "bert-pretrained",
                "pretrained_model": "bert-base-uncased",
                "do_lowercase": true,
                "use_starting_offsets": true
             }
        }
    },
    "train_data_path": "/shared/hangfeng/code/SemanticBert/data/Nombank/development.srl",
    "validation_data_path": "/shared/hangfeng/code/SemanticBert/data/Nombank/test.srl",
    "test_data_path": "/shared/hangfeng/code/SemanticBert/data/Nombank/test.srl",
    "model": {
        "type": "srl",
         "text_field_embedder": {
            "allow_unmatched_keys": true,
            "embedder_to_indexer_map": {
                "bert": ["bert", "bert-offsets"],
                "semanticbert": ["semanticbert", "semanticbert-offsets"]
            },
            "token_embedders": {
                "bert": {
                    "type": "bert-pretrained",
                    "pretrained_model": "bert-base-cased"
                },
                "semanticbert": {
                    "type": "semanticbert-pretrained",
                    "pretrained_model": "/shared/hangfeng/code/SemanticBert/data/QAMR/outputs-semanticbert-probe-c2q-interaction-V3-all-1e-4-1e-4-64/pytorch_model.bin",
                    "top_layer_only": true
                }
            }
        },
        "initializer": [
            [
                "tag_projection_layer.*weight",
                {
                    "type": "orthogonal"
                }
            ]
        ],
        // NOTE: This configuration is correct, but slow.
        "encoder": {
            "type": "alternating_lstm",
            "input_size": 768 + 100 + 768,
            "hidden_size": 300,
            "num_layers": 2,
            "recurrent_dropout_probability": 0.1,
            "use_input_projection_bias": false
        },
        "binary_feature_dim": 100,
        "regularizer": [
            [
                ".*scalar_parameters.*",
                {
                    "type": "l2",
                    "alpha": 0.001
                }
            ]
        ]
    },
    "iterator": {
        "type": "bucket",
        "sorting_keys": [
            [
                "tokens",
                "num_tokens"
            ]
        ],
        "batch_size": 80
    },
    "trainer": {
        "num_epochs": 50,
        "grad_clipping": 1.0,
        "patience": 20,
        "num_serialized_models_to_keep": 10,
        "validation_metric": "+f1-measure-overall",
        "cuda_device": [0, 1],
        "optimizer": {
            "type": "adadelta",
            "rho": 0.95
        }
    }
}