# Lambda File Processor

Este projeto simula um fluxo da AWS usando o [LocalStack](https://github.com/localstack/localstack), onde arquivos enviados para um bucket S3 disparam uma função Lambda que grava metadados no DynamoDB.

## Tecnologias

- AWS CLI
- LocalStack
- AWS Lambda (Python 3.8)
- AWS S3
- AWS DynamoDB
- AWS IAM

## Como rodar

1. Suba o LocalStack com Docker Compose:
   ```bash
   docker-compose up -d
   ```

2. De permissão de execução ao arquivo:
   ```bash
   chmod +x scripts/create_resources.sh
   ```

3. Crie os recursos (S3, Lambda, DynamoDB)
    ```bash
    ./scripts/create_resources.sh
    ```

4. Envie um arquivo para o bucket:
   ```bash
   aws --endpoint-url=http://localhost:4566 s3 cp arquivo.txt s3://uploads
   ```

A função Lambda será automaticamente acionada e irá salvar metadados no DynamoDB.

## Estrutura do projeto

```
.
├── arquivo.txt
├── docker-compose.yml
├── lambda/
│   ├── function.zip
│   ├── lambda_function.py
│   └── requirements.txt
├── scripts/
│   ├── create_resources.sh
│   └── upload_file.sh
```

## Comandos úteis

- Listar buckets:
  ```bash
  aws --endpoint-url=http://localhost:4566 s3 ls
  ```

- Ver funções Lambda:
  ```bash
  aws --endpoint-url=http://localhost:4566 lambda list-functions
  ```

- Ver logs:
  ```bash
  aws --endpoint-url=http://localhost:4566 logs describe-log-groups
  ```
