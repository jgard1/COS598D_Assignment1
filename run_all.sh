#!/usr/bin/env bash

CIFAR = "cifar_"
MNIST = "mnist_"
# experiment 1 
for PRUNER_NAME in rand snip grasp synflow
do
  python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment singleshot --pruner synflow --compression 1 --expid $CIFAR$PRUNER_NAME
  python main.py --model-class default --model fc --dataset mnist --experiment singleshot --pruner synflow --compression 1 --expid $MNIST$PRUNER_NAME
done
# have to deal with magnitue pruning seperately because the pre-epochs needs to be set to 200
python main.py --model-class lottery --model vgg16 --dataset cifar10 --experiment singleshot --pruner mag --compression 1 --pre-epochs 200 cifar_mag
python main.py --model-class default --model fc --dataset mnist --experiment singleshot --pruner mag --compression 1 --pre-epochs 200 mnist_mag