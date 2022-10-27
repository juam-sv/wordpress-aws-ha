# Wordpress AWS High Avaliable

![Pipeline Status](https://github.com/juam-sv/wordpress-aws-ha/actions/workflows/terraform.yml/badge.svg) 

Este projeto tem como objetivo provisionar um ambiente na aws utilizando terraform com a finalidade de hospedar o wordpress utilizando de varios recursos da plataforma para garantir um alto grau de resiliência, disponibilidade e elasticidade.

## Recursos Utilizados
- [x] VPC
- [x] RDS
- [x] EFS
- [x] Load Balancer
- [x] Elastic Cache
- [x] EC2
- [x] S3
- [ ] CloudFront

# Diagrama da arquitetura proposta
![alt architecture diagram](./assets/architecture.jpeg)

## Requisitos
- [Terraform instalado](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Credenciais da AWS, seja por variaveis de ambiente ou com o [AWS CLI](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), recomenda-se o uso de uma conta de serviço para isso.

```bash

```
## Instruções

### 1. Edição do arquivo de variaveis **"variables.tfvars.exemple"**
```bash
cp variables.tfvars.exemple variables.tfvars
```
### 1.1 Apos a copia do mesmo substitua as variaveis necessarias, como por exemplo o campo **lc_key_name** para a sua propria chave e outros que ache necessário.

<br> 

### 2. Feito isso para seguir o procedimento padrão do terraform.
```bash
#para baixar os plugins
terraform init 

# para ver o que será executado
terraform plan

# para propriamente executar
terraform apply

```